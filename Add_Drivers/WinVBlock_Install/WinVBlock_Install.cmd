:: ==========================================================================================================================
:: ====================================== WinVBlock_Install.cmd - July 14 2012 - wimb =======================================
:: ==========================================================================================================================
TITLE WinVBlock_Install.cmd - Install WinVBlock driver
@ECHO OFF
CLS

:: Check Windows version
IF NOT "%OS%"=="Windows_NT"  (
  ECHO.
  ECHO ***** ONLY for Windows OS *****
  ECHO.
  GOTO _end
)

ECHO.
ECHO  =============================================================================
ECHO  WinVBlock_Install.cmd - Install WinVBlock driver
ECHO.
ECHO  Continue - Or Close to STOP
ECHO  ============================================================================= 
ECHO.
pause


SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

SET TP=%~dp0
SET TP=%TP:~0,-1%
cd /d "%TP%"
SET workdrv=!TP:~0,2!

chcp 437 >nul
:: mode con cols=105


SET A=32
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" SET A=64

ECHO.
xcopy "%TP%\WVBlk%A%.sys" "%windir%\system32\drivers\" /i /k /r /y /h
ECHO.

echo Select Install Method - Default = 1
echo 1 - sc.exe
echo 2 - winvblk.exe
ECHO.

set _ok=
set /p _ok= Enter your choice: 

IF "%_ok%" == "2" (
  start winvblk.exe -cmd install -service wvblk%A%
) ELSE (
  sc create WinVBlock binPath= %windir%\system32\drivers\wvblk%A%.sys type= kernel start= boot group= "SCSI miniport"
)

net start winvblock

ECHO.
ECHO  Now in Device Manager proceed with Install of WinVBlock driver
ECHO. 
ECHO  - In XP use Select Computer - Action Scan Hardware - Wizard New Hardware
ECHO  - Advanced - Browse to IMG_XP\WinVBlock_Install folder
ECHO  - and use Install anyway - use Force to Update Unsigned driver
ECHO.
ECHO  - In Win7 Wait for Unknown Device - Update driver
ECHO  - Manual - Browse to IMG_XP\WinVBlock_Install folder
ECHO  - and use Install anyway - use Force to Update Unsigned driver
ECHO.
ECHO  Continue to Open Device Manager
ECHO  ============================================================================= 
ECHO.
pause

start  %windir%\system32\devmgmt.msc

:_end_quit
IF "%OS%"=="Windows_NT" ENDLOCAL
ECHO.
ECHO  After End Program then Reboot computer
ECHO  Check if Device Manager - Storage controllers - WinVBlock Bus SCSIAdapter

:_end
ECHO.
ECHO  End Program - WinVBlock_Install.cmd will be Closed
ECHO  ============================================================================= 
ECHO.
pause
EXIT


