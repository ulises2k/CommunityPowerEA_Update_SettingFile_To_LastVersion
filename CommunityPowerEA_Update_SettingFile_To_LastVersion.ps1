# Script that updates the configuration file from version 2.18 to 2.48
# Drag and drop file settings MT5 to windows form and press button
#
# Autor: Ulises Cune (@Ulises2k)
# v1.0


Function Get-IniFile ($file) {
	$ini = [ordered]@{}
	switch -regex -file $file {
		"^\s*(.+?)\s*=\s*(.*)$" {
			$name, $value = $matches[1..2]
			# skip comments that start with semicolon:
			if (!($name.StartsWith(";"))) {
				if ($value.Contains('||') ) {
					$ini[$name] = $value.Split('||')[0]
					continue
				}
				else {
					$ini[$name] = $value
					continue
				}
			}
		}
	}
	$ini
}

function Set-OrAddIniValue {
	Param(
		[string]$FilePath,
		[hashtable]$keyValueList
	)

	$content = Get-Content $FilePath
	$keyValueList.GetEnumerator() | ForEach-Object {
		if ($content -match "^$($_.Key)\s*=") {
			$content = $content -replace "$($_.Key)\s*=(.*)", "$($_.Key)=$($_.Value)"
		}
		else {
			$content += "$($_.Key)=$($_.Value)"
		}
	}

	$content | Set-Content $FilePath
}


function MainUpdateVersion ([string]$filePath) {

	$version = ""
	$lastVersion = ""
	$update = ""

	$PathDest = (Get-Item $filePath).BaseName + "-v2.48.set"
	#$PathDest = (Get-Item $filePath).BaseName + ".set"
	$CurrentDir = Split-Path -Path "$filePath"
	$filePathNew = "$CurrentDir\$PathDest"
	Copy-Item "$filePath" -Destination $filePathNew

	$filePath = $filePathNew


	#Detect Version 2.18
	#Pending_Type=1
	#MinPause_Bars=0
	#BreakEven_AfterOrder=0
	if (Select-String -Path $filePath -Quiet -Pattern "Pending_Type") {
		$version = $version + ">=2.18"
		$lastVersion = "2.18"
	}
	else {
		$update = $update + "/2.18"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Pending_Type         = "1"
			MinPause_Bars        = "0"
			BreakEven_AfterOrder = "0"
		}
	}

	#Detect Version 2.19
	#MartingailOnSignal=false
	#GlobalMartingail_Properties========
	#ApplyAfterClosedLoss=false
	#BigCandle_OpenOn=0
	#Oscillators_OpenOn=2
	#Oscillator2_OpenOn=0
	#IdentifyTrend_OpenOn=2
	#TDI_OpenOn=2
	#MACD_OpenOn=0
	#MA_Filter_1_OpenOn=0
	#MA_Filter_2_OpenOn=0
	#MA_Filter_3_OpenOn=0
	#VolFilter_OpenOn=0
	#FIBO_OpenOn=0
	#GUI_Window_Alpha=255
	if (Select-String -Path $filePath -Quiet -Pattern "Oscillators_OpenOn") {
		$version = $version + ">=2.19"
		$lastVersion = "2.19"
	}
	else {
		$update = $update + "/2.19"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MartingailOnSignal          = "false"
			GlobalMartingail_Properties = "===== Apply martin to the new deals ====="
			ApplyAfterClosedLoss        = "false"
			BigCandle_OpenOn            = "0"
			Oscillators_OpenOn          = "2"
			Oscillator2_OpenOn          = "0"
			IdentifyTrend_OpenOn        = "2"
			TDI_OpenOn                  = "2"
			MACD_OpenOn                 = "0"
			MA_Filter_1_OpenOn          = "0"
			MA_Filter_2_OpenOn          = "0"
			MA_Filter_3_OpenOn          = "0"
			VolFilter_OpenOn            = "0"
			FIBO_OpenOn                 = "0"
			GUI_Window_Alpha            = "255"
		}
	}
	#Detect Version 2.20
	#StopLoss_Mode=1
	#MinProfitToClose_Properties========
	#MinProfitToClose=0
	#MartingailOnTheBarEnd=false
	#MartingailLotMode=2
	#PartialClose_Properties========
	#PartialClose_After=0
	#PartialClose_MinProfit=0
	#AntiMartingailLotMode=2
	#AntiStopLoss_ReduceSize=0
	#AntiStopLoss_ReduceCoeff=1
	#AntiStopLoss_MinSize=5
	#AntiStopLoss_Mode=1
	#BigCandle_MartinOn=0
	#Oscillators_MartinOn=0
	#Oscillator2_MartinOn=0
	#IdentifyTrend_MartinOn=0
	#TDI_MartinOn=0
	#MACD_MartinOn=0
	#MA_Filter_1_MartinOn=0
	#MA_Filter_2_MartinOn=0
	#MA_Filter_3_MartinOn=0
	#VolFilter_MartinOn=0
	#FIBO_MartinOn=0
	if (Select-String -Path $filePath -Quiet -Pattern "StopLoss_Mode") {
		$version = $version + ">=2.20"
		$lastVersion = "2.20"
	}
	else {
		$update = $update + "/2.20"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			StopLoss_Mode = "1"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MinProfitToClose_Properties = "===== Min profit to close on signal ====="
			MinProfitToClose            = "0"
			MartingailOnTheBarEnd       = "false"
			MartingailLotMode           = "2"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			PartialClose_Properties  = "===== Partial Close ====="
			PartialClose_After       = "0"
			PartialClose_MinProfit   = "0"
			AntiMartingailLotMode    = "2"
			AntiStopLoss_ReduceSize  = "0"
			AntiStopLoss_ReduceCoeff = "1"
			AntiStopLoss_MinSize     = "5"
			AntiStopLoss_Mode        = "1"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			BigCandle_MartinOn       = "0"
			Oscillators_MartinOn     = "0"
			Oscillator2_MartinOn     = "0"
			IdentifyTrend_MartinOn   = "0"
			TDI_MartinOn             = "0"
			MACD_MartinOn            = "0"
			MA_Filter_1_MartinOn     = "0"
			MA_Filter_2_MartinOn     = "0"
			MA_Filter_3_MartinOn     = "0"
			VolFilter_MartinOn       = "0"
			FIBO_MartinOn            = "0"
		}
	}
	#Detect Version 2.21
	#Setting file: CP_MT5_EURUSD_Grid8_v2.21.set
	#NewDealOnNewBar=false
	if (Select-String -Path $filePath -Quiet -Pattern "NewDealOnNewBar") {
		$version = $version + ">=2.21"
		$lastVersion = "2.21"
	}
	else {
		$update = $update + "/2.21"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			NewDealOnNewBar = "true"
		}
	}
	#Detect Version 2.22
	#I don't have the default set of this version, could you share it with me if you have it? @ulises2k

	#Detect Version 2.23
	#MaxFloatingLoss=0
	#GlobalStopLoss_ccy=0
	#PauseAfterLoss=0
	#TakeProfit_ReduceAfter========
	#TakeProfit_ReduceAfter_mins=0
	#TakeProfit_ReduceAfter_coeff=0.1
	#TakeProfit_ReduceSeries========
	#TakeProfit_ReduceSize=0
	#TakeProfit_ReduceCoeff=1
	#TakeProfit_MinSize=0
	#TakeProfit_Global========
	#PartialClose_MinProfit_Perc=0
	#GUI_VisualTest_RefreshSec=0
	if (Select-String -Path $filePath -Quiet -Pattern "MaxFloatingLoss") {
		$version = $version + ">=2.23"
		$lastVersion = "2.23"
	}
	else {
		$update = $update + "/2.23"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MaxFloatingLoss    = "0"
			GlobalStopLoss_ccy = "0"
			PauseAfterLoss     = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			TakeProfit_ReduceAfter       = "===== Reduce Take Profit after minutes ====="
			TakeProfit_ReduceAfter_mins  = "0"
			TakeProfit_ReduceAfter_coeff = "0.1"
			TakeProfit_ReduceSeries      = "===== Reduce Take Profit for every order ====="
			TakeProfit_ReduceSize        = "0"
			TakeProfit_ReduceCoeff       = "1"
			TakeProfit_MinSize           = "0"
			TakeProfit_Global            = "===== Summ Take Profit (buy + sell) ====="
			PartialClose_MinProfit_Perc  = "0"
			GUI_VisualTest_RefreshSec    = "0"
		}
	}


	#Detect Version 2.24
	#Setting file: Community EURUSD 2 risk 5% coef 1.32 stop lost 225 bon_v2.24.set
	#FIB2_Properties====== FIBO #2 =====
	#FIB2_Type=0
	#FIB2_TF=16385
	#FIB2_Bars=120
	#FIB2_Level=61.8
	#FIB2_UseClosedBars=true
	#FIB2_OpenOn=0
	#FIB2_MartinOn=0
	#FIB2_CloseOn=0
	if (Select-String -Path $filePath -Quiet -Pattern "FIB2_Type") {
		$version = $version + ">=2.24"
		$lastVersion = "2.24"
	}
	else {
		$update = $update + "/2.24"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			FIB2_Properties    = "===== FIBO #2 ====="
			FIB2_Type          = "0"
			FIB2_TF            = "16385"
			FIB2_Bars          = "120"
			FIB2_Level         = "61.8"
			FIB2_UseClosedBars = "true"
			FIB2_OpenOn        = "0"
			FIB2_MartinOn      = "0"
			FIB2_CloseOn       = "0"
		}
	}


	#Detect Version 2.25
	#BigCandle_CloseOn=0
	#BigCandle_PartialCloseOn=0
	#Oscillators_PartialCloseOn=0
	#Oscillator2_PartialCloseOn=0
	#IdentifyTrend_PartialCloseOn=0
	#TDI_PartialCloseOn=0
	#MACD_PartialCloseOn=0
	#MA_Filter_1_PartialCloseOn=0
	#MA_Filter_2_PartialCloseOn=0
	#MA_Filter_3_PartialCloseOn=0
	#VolFilter_PartialCloseOn=0
	#FIBO_CheckInterval=1
	#FIBO_PartialCloseOn=0
	#FIB2_CheckInterval=1
	#FIB2_PartialCloseOn=0
	#Time_ApplyTo=1
	#EveryDay_CloseHour=-1
	#EveryDay_CloseMinute=0
	#Custom_Schedule_Properties===== Custom Schedule ====
	#Custom_Schedule_On=false
	#Monday_StartHour=-1
	#Monday_StartMinute=0
	#Monday_EndHour=-1
	#Monday_EndMinute=0
	#Tuesday_StartHour=-1
	#Tuesday_StartMinute=0
	#Tuesday_EndHour=-1
	#Tuesday_EndMinute=0
	#Wednesday_StartHour=-1
	#Wednesday_StartMinute=0
	#Wednesday_EndHour=-1
	#Wednesday_EndMinute=0
	#Thursday_StartHour=-1
	#Thursday_StartMinute=0
	#Thursday_EndHour=-1
	#Thursday_EndMinute=0
	#Friday_StartHour=-1
	#Friday_StartMinute=0
	#Friday_EndHour=-1
	#Friday_EndMinute=0
	if (Select-String -Path $filePath -Quiet -Pattern "BigCandle_CloseOn") {
		$version = $version + ">=2.25"
		$lastVersion = "2.25"
	}
	else {
		$update = $update + "/2.25"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			BigCandle_CloseOn            = "0"
			BigCandle_PartialCloseOn     = "0"
			Oscillators_PartialCloseOn   = "0"
			Oscillator2_PartialCloseOn   = "0"
			IdentifyTrend_PartialCloseOn = "0"
			TDI_PartialCloseOn           = "0"
			MACD_PartialCloseOn          = "0"
			MA_Filter_1_PartialCloseOn   = "0"
			MA_Filter_2_PartialCloseOn   = "0"
			MA_Filter_3_PartialCloseOn   = "0"
			VolFilter_PartialCloseOn     = "0"
			FIBO_CheckInterval           = "1"
			FIBO_PartialCloseOn          = "0"
			FIB2_CheckInterval           = "1"
			FIB2_PartialCloseOn          = "0"
			Time_ApplyTo                 = "1"
			EveryDay_CloseHour           = "-1"
			EveryDay_CloseMinute         = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Custom_Schedule_Properties = "===== Custom Schedule ====="
			Custom_Schedule_On         = "false"
			Monday_StartHour           = "-1"
			Monday_StartMinute         = "0"
			Monday_EndHour             = "-1"
			Monday_EndMinute           = "0"
			Tuesday_StartHour          = "-1"
			Tuesday_StartMinute        = "0"
			Tuesday_EndHour            = "-1"
			Tuesday_EndMinute          = "0"
			Wednesday_StartHour        = "-1"
			Wednesday_StartMinute      = "0"
			Wednesday_EndHour          = "-1"
			Wednesday_EndMinute        = "0"
			Thursday_StartHour         = "-1"
			Thursday_StartMinute       = "0"
			Thursday_EndHour           = "-1"
			Thursday_EndMinute         = "0"
			Friday_StartHour           = "-1"
			Friday_StartMinute         = "0"
			Friday_EndHour             = "-1"
			Friday_EndMinute           = "0"
		}
	}


	#Detect Version 2.26
	#AutoHedge_Properties========
	#AutoHedge_AfterOrder=0
	if (Select-String -Path $filePath -Quiet -Pattern "AutoHedge_AfterOrder") {
		$version = $version + ">=2.26"
		$lastVersion = "2.26"
	}
	else {
		$update = $update + "/2.26"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AutoHedge_AfterOrder = "0"
		}
	}

	#Detect Version 2.27.1
	#UseCustomCommission=0
	#UseVirtualSL=true
	#Sounds_Enabled=false
	#Sounds_OpenFirst=expert.wav
	#Sounds_OpenMartin=alert2.wav
	#Sounds_OpenAntiMartin=alert2.wav
	#Sounds_Close=alert.wav
	if (Select-String -Path $filePath -Quiet -Pattern "UseCustomCommission") {
		$version = $version + ">=2.27"
		$lastVersion = "2.27"
	}
	else {
		$update = $update + "/2.27"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			UseCustomCommission   = "0"
			UseVirtualSL          = "true"
			Sounds_Enabled        = "false"
			Sounds_OpenFirst      = "expert.wav"
			Sounds_OpenMartin     = "alert2.wav"
			Sounds_OpenAntiMartin = "alert2.wav"
			Sounds_Close          = "alert.wav"
		}

	}

	#Detect Version 2.28
	#UseVirtualTP=false
	#BreakEven_MinProfit=0
	#TDI_Mode=1
	#TDI_SignalLevel=50
	#TDI_PeriodRSI=21
	#TDI_AppliedPriceRSI=1
	#TDI_PeriodSmRSI=2
	#TDI_MethodSmRSI=0
	#TDI_PeriodSmSig=7
	#TDI_MethodSmSig=0
	#TDI_PeriodVolBand=34
	#TDI_StdDev=1.6185
	#ShowOrders_Settings====================================================================================
	#Show_Opened=1
	#Show_Closed=true
	#Show_Pending=true
	#MaxHistoryDeals=500
	#Color_Properties=
	#Color_B_Open=16748574
	#Color_B=16748574
	#Color_B_Loss=15130800
	#Color_S_Open=17919
	#Color_S=17919
	#Color_S_Loss=12695295
	#Profit_Properties=
	#Profit_ShowInMoney=true
	#Profit_ShowInPoints=true
	#Profit_ShowInPercents=false
	#ProfitDigitsToShow=1
	#Font=Arial
	#FontSize=9
	#Style_Properties=
	#Open_Close_Line_Width=1
	#Open_Close_Line_Style=2
	#Open_PriceLabel_Width=0
	#Close_PriceLabel_Width=0
	#SL_TP_Dashes_Show=true
	#SL_TP_Lines_Width=0
	#SL_TP_Lines_Style=2
	#Expiration_Width=0
	#Expiration_Style=2
	#Optimization_Settings====================================================================================
	#InpEquityRecorderType=1
	#InpEquityRecorderCorr=0
	if (Select-String -Path $filePath -Quiet -Pattern "UseVirtualTP") {
		$version = $version + ">=2.28"
		$lastVersion = "2.28"
	}
	else {
		$update = $update + "/2.28"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			UseVirtualTP        = "false"
			BreakEven_MinProfit = "0"
			TDI_Mode            = "1"
			TDI_SignalLevel     = "50"
			TDI_PeriodRSI       = "21"
			TDI_AppliedPriceRSI = "1"
			TDI_PeriodSmRSI     = "2"
			TDI_MethodSmRSI     = "0"
			TDI_PeriodSmSig     = "7"
			TDI_MethodSmSig     = "0"
			TDI_PeriodVolBand   = "34"
			TDI_StdDev          = "1.6185"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			ShowOrders_Settings = "===== Show Orders ====="
			Show_Opened         = "1"
			Show_Closed         = "true"
			Show_Pending        = "true"
			MaxHistoryDeals     = "500"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Color_Properties = "===== Main Color ====="
			Color_B_Open     = "16748574"
			Color_B          = "16748574"
			Color_B_Loss     = "15130800"
			Color_S_Open     = "17919"
			Color_S          = "17919"
			Color_S_Loss     = "12695295"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Profit_Properties     = "===== Take Profit ====="
			Profit_ShowInMoney    = "true"
			Profit_ShowInPoints   = "true"
			Profit_ShowInPercents = "false"
			ProfitDigitsToShow    = "1"
			Font                  = "Arial"
			FontSize              = "9"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Style_Properties       = "===== Style ====="
			Open_Close_Line_Width  = "1"
			Open_Close_Line_Style  = "2"
			Open_PriceLabel_Width  = "0"
			Close_PriceLabel_Width = "0"
			SL_TP_Dashes_Show      = "true"
			SL_TP_Lines_Width      = "0"
			SL_TP_Lines_Style      = "2"
			Expiration_Width       = "0"
			Expiration_Style       = "2"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Optimization_Settings = "===== Optimization ====="
			InpEquityRecorderType = "1"
			InpEquityRecorderCorr = "0"
		}

	}

	#Detect Version 2.29
	#Setting file: eurusd_5m_leverage100_roboforex_2_v2.29.3_Beta.set
	#; News settings
	#News_Properties================================================================
	#News_Mode=0
	#News_Currencies=auto
	#News_Impact_H=true
	#News_Impact_M=true
	#News_Impact_L=true
	#News_Impact_N=false
	#News_FilterInclude=Summit,Speech,Speak,PMI,ECB,BoC,Fed,FED,NFP, payrolls, Payrolls,
	#News_MinutesBefore=15
	#News_MinutesAfter=15
	#News_Draw_Properties===== Visualization ====
	#News_ShowOnChart=true
	#News_Style_History=0
	#News_Style_Future=3
	#News_Color_ImpactH=255
	#News_Color_ImpactM=65535
	#News_Color_ImpactL=32768
	#News_Color_ImpactN=12632256
	if (Select-String -Path $filePath -Quiet -Pattern "News_Mode") {
		$version = $version + ">=2.29"
		$lastVersion = "2.29"
	}
	else {
		$update = $update + "/2.29"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			News_Properties      = "===== News ====="
			News_Mode            = "0"
			News_Currencies      = "auto"
			News_Impact_H        = "false"
			News_Impact_M        = "false"
			News_Impact_L        = "false"
			News_Impact_N        = "false"
			News_FilterInclude   = ""
			News_MinutesBefore   = "15"
			News_MinutesAfter    = "15"
			News_Draw_Properties = "===== Visualization ====="
			News_ShowOnChart     = "true"
			News_Style_History   = "0"
			News_Style_Future    = "3"
			News_Color_ImpactH   = "255"
			News_Color_ImpactM   = "65535"
			News_Color_ImpactL   = "32768"
			News_Color_ImpactN   = "12632256"
		}
	}

	#Detect Version 2.30
	#MinStepSize=0||0||0.000000||0.000000||N
	#AntiMinStepSize=0||0||0.000000||0.000000||N
	#; Oscillator #3 properties
	#Oscillator3_Properties====================================================================================
	#Oscillator3_Type=0||0||0||4||N
	#Oscillator3_Indicator=2||0||0||4||N
	#Oscillator3_TF=16408||0||0||49153||N
	#Oscillator3_Period=14||14||1||140||N
	#Oscillator3_Price=1||1||0||7||N
	#Oscillator3_MA_Period=3||3||1||30||N
	#Oscillator3_MA_Method=0||0||0||3||N
	#Oscillator3_Slowing=3||3||1||30||N
	#Oscillator3_STO_Price=0||0||0||1||N
	#Oscillator3_Level_UP_Min=80||80||8.000000||800.000000||N
	#Oscillator3_Level_DN_Min=-999||-999||-99.900000||-9990.000000||N
	#Oscillator3_ContrTrend=false||false||0||true||N
	#Oscillator3_OpenOn=0||0||0||3||N
	#Oscillator3_MartinOn=0||0||0||3||N
	#Oscillator3_CloseOn=0||0||0||4||N
	#Oscillator3_PartialCloseOn=0||0||0||3||N
	#; Parabolic SAR properties
	#PSar_Properties====================================================================================
	#PSar_Type=0||0||0||2||N
	#PSar_TF=0||0||0||49153||N
	#PSar_Step=0.02||0.02||0.002000||0.200000||N
	#PSar_Maximum=0.2||0.2||0.020000||2.000000||N
	#PSar_Reverse=false||false||0||true||N
	#PSar_OpenOn=0||0||0||3||N
	#PSar_MartinOn=0||0||0||3||N
	#PSar_CloseOn=0||0||0||4||N
	#PSar_PartialCloseOn=0||0||0||3||N
	#; ZZ properties
	#ZZ_Properties====================================================================================
	#ZZ_Type=0||0||0||4||N
	#ZZ_TF=0||0||0||49153||N
	#ZZ_Period=12||12||1||120||N
	#ZZ_MinAmplitude=10||10||1||100||N
	#ZZ_MinMotion=0||0||1||10||N
	#ZZ_DistanceType=0||0||0||2||N
	#ZZ_SignalDistCoeff=0||0||0.000000||0.000000||N
	#ZZ_Reverse=false||false||0||true||N
	#ZZ_UseClosedBars=false||false||0||true||N
	#ZZ_OpenOn=0||0||0||3||N
	#ZZ_MartinOn=0||0||0||3||N
	#ZZ_CloseOn=0||0||0||4||N
	#ZZ_PartialCloseOn=0||0||0||3||N
	#; Volatility for MA and ZZ Filters distance
	#Profit_Aggregate=true||false||0||true||N
	if (Select-String -Path $filePath -Quiet -Pattern "MinStepSize") {
		$version = $version + ">=2.30"
		$lastVersion = "2.30"
	}
	else {
		$update = $update + "/2.30"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MinStepSize     = 0
			AntiMinStepSize = 0
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Oscillator3_Properties     = "===== Oscillator #3 ====="
			Oscillator3_Type           = "0"
			Oscillator3_Indicator      = "2"
			Oscillator3_TF             = "16408"
			Oscillator3_Period         = "14"
			Oscillator3_Price          = "1"
			Oscillator3_MA_Period      = "3"
			Oscillator3_MA_Method      = "0"
			Oscillator3_Slowing        = "3"
			Oscillator3_STO_Price      = "0"
			Oscillator3_Level_UP_Min   = "80"
			Oscillator3_Level_DN_Min   = "-999"
			Oscillator3_ContrTrend     = "false"
			Oscillator3_OpenOn         = "0"
			Oscillator3_MartinOn       = "0"
			Oscillator3_CloseOn        = "0"
			Oscillator3_PartialCloseOn = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			PSar_Properties     = "===== Parabolic SAR ====="
			PSar_Type           = "0"
			PSar_TF             = "0"
			PSar_Step           = "0.02"
			PSar_Maximum        = "0.2"
			PSar_Reverse        = "false"
			PSar_OpenOn         = "0"
			PSar_MartinOn       = "0"
			PSar_CloseOn        = "0"
			PSar_PartialCloseOn = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			ZZ_Properties      = "===== ZigZag ====="
			ZZ_Type            = "0"
			ZZ_TF              = "0"
			ZZ_Period          = "12"
			ZZ_MinAmplitude    = "10"
			ZZ_MinMotion       = "0"
			ZZ_DistanceType    = "0"
			ZZ_SignalDistCoeff = "0"
			ZZ_Reverse         = "false"
			ZZ_UseClosedBars   = "false"
			ZZ_OpenOn          = "0"
			ZZ_MartinOn        = "0"
			ZZ_CloseOn         = "0"
			ZZ_PartialCloseOn  = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Profit_Aggregate = "true"
		}
	}

	#Detect Version 2.31
	#MinMarginLevel=0
	#; Volatility for all parameters nominated in points
	#VolPV_Properties====== Volatility for all parameters nominated in points =====
	#VolPV_Type=1
	#VolPV_TF=16408
	#VolPV_Period=20
	#VolPV_MinSize=0
	#VolPV_MaxSize=0
	#Pending_Distance_ModeP=0
	#StopLoss_ModeP=0
	#TakeProfit_ModeP=0
	#MinProfitToClose_ModeP=0
	#; Global Account TakeProfit properties
	#GlobalAccountTakeProfit_Prop====================================================================================
	#GlobalAccountTakeProfit_ccy=0
	#GlobalAccountTakeProfit_perc=0
	#TrailingStop_ModeP=0
	#Martingail_ModeP=0
	#AntiMartingail_ModeP=0
	#AntiStopLoss_ModeP=0
	#News_OpenOn=0
	#News_MartinOn=0
	#News_CloseOn=0
	#News_PartialCloseOn=0
	#Notifications_Settings====== Notifications =====
	#MessagesToGrammy=true
	#Alerts_Enabled=false
	if (Select-String -Path $filePath -Quiet -Pattern "MinMarginLevel") {
		$version = $version + ">=2.31"
		$lastVersion = "2.31"
	}
	else {
		$update = $update + "/2.31"

		#Read All Setting File parameters
		$inifile = Get-IniFile($filePath)

		#https://communitypowerea.userecho.com/en/communities/7/topics/336-migrate-settings-file-230-to-231-version
		#
		#Migrate Settings file 2.30 to 2.31 Version
		#
		#This is the instruction
		#https://communitypowerea.userecho.com/en/communities/1/topics/28-all-pips-parameters-calculated-using-atr?redirect_to_reply=1857#comment-1857
		# Default Value 2.31
		#; Expert properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MinMarginLevel = "0"
		}

		Add-Content -Path $filePath -Value "VolPV_Properties====== Volatility for all parameters nominated in points ====="
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			VolPV_Type = "1"
		}

		#ATR parameters must be set in the corresponding section.
		$StepATR_TF = $inifile['StepATR_TF']
		$StepATR_Period = $inifile['StepATR_Period']
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			VolPV_TF      = $StepATR_TF
			VolPV_Period  = $StepATR_Period
			VolPV_MinSize = "0"
			VolPV_MaxSize = "0"
		}

		#; Pending entry properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Pending_Distance_ModeP = "0"
		}

		#; StopLoss properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			StopLoss_ModeP = "0"
		}

		#; TakeProfit properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			TakeProfit_ModeP       = "0"
			MinProfitToClose_ModeP = "0"
		}

		#; Global Account properties
		Add-Content -Path $filePath -Value "GlobalAccount_Properties====== Global Account ====="
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			GlobalAccountTakeProfit_ccy    = "0"
			GlobalAccountTakeProfit_perc   = "0"
			GlobalAccountTargetProfit_ccy  = "0"
			GlobalAccountTargetProfit_perc = "0"
		}

		#; TrailingStop properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			TrailingStop_ModeP = "0"
		}

		#Default
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MartingailType   = "0"
			Martingail_ModeP = "0"
		}

		# ATR * coefficient" mode must be replaced with "Martingale enabled",
		if ([int]$inifile['MartingailType'] -eq 3) {
			#"Step size calc mode" must be set to "Coefficient to volatility",
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				MartingailType   = "1"
				Martingail_ModeP = "1"
			}
		}

		#Previous step * coefficient" mode must be replaced with "Martingale enabled".
		if ([int]$inifile['MartingailType'] -eq 2) {
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				MartingailType = "1"
			}
		}

		#Step increase coefficient" for "Fixed step" mode must be set 1.
		if ([int]$inifile['MartingailType'] -eq 1) {
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				StepCoeff = "1"
			}
		}

		#Add default values to replace below
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AntiMartingailType   = "0"
			AntiMartingail_ModeP = "0"
		}

		# ATR * coefficient" mode must be replaced with "Martingale enabled",
		if ([int]$inifile['AntiMartingailType'] -eq 3) {
			#"Step size calc mode" must be set to "Coefficient to volatility",
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				AntiMartingailType   = "1"
				AntiMartingail_ModeP = "1"
			}
		}

		#Previous step * coefficient" mode must be replaced with "Martingale enabled".
		if ([int]$inifile['AntiMartingailType'] -eq 2) {
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				AntiMartingailType = "1"
			}
		}

		#Step increase coefficient" for "Fixed step" mode must be set 1.
		if ([int]$inifile['AntiMartingailType'] -eq 1) {
			Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
				AntiStepCoeff = "0"
			}
		}

		#; Anti-Martingail properties
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AntiStopLoss_ModeP = "0"
		}

		#Only the values that were not added above
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			News_OpenOn         = "0"
			News_MartinOn       = "0"
			News_CloseOn        = "0"
			News_PartialCloseOn = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Notifications_Settings = "===== Notifications ====="
			MessagesToGrammy       = "false"
			Alerts_Enabled         = "false"
		}

	}

	#Detect Version 2.32.4
	#Lot_MaxPer1000=0
	#; Hedge properties
	#Hedge_Properties====== Hedge =====
	#AllowHedge=true
	#IncreaseHedge_After=0
	#IncreaseHedge_Coefficient=2.5
	#IncreaseHedge_Mode=0
	#AutoHedge_AfterOrder=0
	#; Global Account properties
	#GlobalAccount_Properties====== Global Account =====
	#GlobalAccountTakeProfit_ccy=0
	#GlobalAccountTakeProfit_perc=0
	#GlobalAccountTargetProfit_ccy=0
	#GlobalAccountTargetProfit_perc=0
	#AllowBoth_Properties========
	#AllowBothMartinAndAntiMartin=false
	#; Partial close properties
	#PartialClose_Properties====== Partial Close =====
	#PartialClose_After=0
	#PartialClose_MinProfit=0
	#PartialClose_MinProfit_Perc=0
	#PartialClose_MinPercent=100
	#PartialCloseHedge_After=0
	#PartialCloseHedge_MinProfit=0
	#PartialCloseHedge_MinProfit_Perc=0
	#PartialCloseHedge_MinPercent=100
	if (Select-String -Path $filePath -Quiet -Pattern "Lot_MaxPer1000") {
		$version = $version + ">=2.32.4"
		$lastVersion = "2.32.4"
	}
	else {
		$update = $update + "/2.32.4"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Lot_MaxPer1000            = "0"
			Hedge_Properties          = "===== Hedge ====="
			AllowHedge                = "true"
			IncreaseHedge_After       = "0"
			IncreaseHedge_Coefficient = "1"
			IncreaseHedge_Mode        = "0"
			AutoHedge_AfterOrder      = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			GlobalAccount_Properties       = "===== Global Account ====="
			GlobalAccountTakeProfit_ccy    = "0"
			GlobalAccountTakeProfit_perc   = "0"
			GlobalAccountTargetProfit_ccy  = "0"
			GlobalAccountTargetProfit_perc = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AllowBoth_Properties         = "===== Allow both Martin and Anti-martin ====="
			AllowBothMartinAndAntiMartin = "false"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			PartialClose_Properties          = "===== Partial Close ====="
			PartialClose_After               = "0"
			PartialClose_MinProfit           = "0"
			PartialClose_MinProfit_Perc      = "0"
			PartialClose_MinPercent          = "100"
			PartialCloseHedge_After          = "0"
			PartialCloseHedge_MinProfit      = "0"
			PartialCloseHedge_MinProfit_Perc = "0"
			PartialCloseHedge_MinPercent     = "100"
		}
	}

	#Detect Version 2.33
	#I don't have the default set of this version, could you share it with me if you have it? @ulises2k

	#Detect Version 2.34
	#AutoHedge_MaxOrders=0
	#GlobalAccountTrailingStop_ccy=0
	#GlobalAccountTrailingStop_perc=0
	#CutomCoefficients=2.2,3.4,4.7
	#AntiCutomCoefficients=0.95,0.77,0.53
	#PartialCloseHedge_BothWays=false
	#PartialCloseHedge_MaxPrOrders=0
	#PartialCloseHedge_MinProfit=0
	#PartialCloseHedge_MinProfit_Perc=0
	#PartialCloseHedge_MinProfit_OppL=0
	if (Select-String -Path $filePath -Quiet -Pattern "AutoHedge_MaxOrders") {
		$version = $version + ">=2.34"
		$lastVersion = "2.34"
	}
	else {
		$update = $update + "/2.34"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AutoHedge_MaxOrders              = "1"
			GlobalAccountTrailingStop_ccy    = "0"
			GlobalAccountTrailingStop_perc   = "0"
			CutomCoefficients                = "2.2,3.4,4.7"
			AntiCutomCoefficients            = "0.95,0.77,0.53"
			PartialCloseHedge_BothWays       = "false"
			PartialCloseHedge_MaxPrOrders    = "0"
			PartialCloseHedge_MinProfit      = "0"
			PartialCloseHedge_MinProfit_Perc = "0"
			PartialCloseHedge_MinProfit_OppL = "0"
		}
	}

	#Detect Version 2.35
	#Set file: EURUSD_100Cent_Oscillators1_IdentifyTrend_DTrend_FIBO1_v2.35.set
	#GlobalTakeProfit_ccy=0
	#GlobalTakeProfit_OnlyLock=true
	#Oscillators_UseClosedBars=true
	#Oscillator2_UseClosedBars=true
	#Oscillator3_UseClosedBars=true
	#Oscillator3_OpenOn=0
	#MACD_FastMA_Method=1
	#MACD_SlowMA_Method=1
	#MACD_SignalMA_Method=0
	#MACD_JMA_Phase=0
	#MACD_Reverse=false
	#; MACD #2 properties
	#MACD2_Properties====== MACD #2 =====
	#MACD2_Type=0
	#MACD2_TF=0
	#MACD2_PeriodFast=12
	#MACD2_FastMA_Method=1
	#MACD2_PeriodSlow=27
	#MACD2_SlowMA_Method=1
	#MACD2_PeriodSignal=9
	#MACD2_SignalMA_Method=0
	#MACD2_Price=1
	#MACD2_JMA_Phase=0
	#MACD2_Reverse=false
	#MACD2_UseClosedBars=true
	#MACD2_OpenOn=0
	#MACD2_MartinOn=0
	#MACD2_CloseOn=0
	#MACD2_PartialCloseOn=0
	#; DTrend properties
	#DTrend_Properties====== DTrend =====
	#DTrend_Type=0
	#DTrend_TF=5
	#DTrend_PeriodMA1=9
	#DTrend_PeriodMA2=12
	#DTrend_PeriodD=5
	#DTrend_Scalar=1000000
	#DTrend_Level=30
	#DTrend_Reverse=false
	#DTrend_UseClosedBars=true
	#DTrend_OpenOn=1
	#DTrend_MartinOn=0
	#DTrend_CloseOn=2
	#DTrend_PartialCloseOn=0
	if (Select-String -Path $filePath -Quiet -Pattern "GlobalTakeProfit_ccy") {
		$version = $version + ">=2.35"
		$lastVersion = "2.35"
	}
	else {
		$update = $update + "/2.35"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			GlobalTakeProfit_ccy      = "0"
			GlobalTakeProfit_OnlyLock = "false"
			Oscillators_UseClosedBars = "true"
			Oscillator2_UseClosedBars = "true"
			Oscillator3_UseClosedBars = "true"
			Oscillator3_OpenOn        = "0"
			MACD_FastMA_Method        = "1"
			MACD_SlowMA_Method        = "1"
			MACD_SignalMA_Method      = "0"
			MACD_JMA_Phase            = "0"
			MACD_Reverse              = "false"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MACD2_Properties      = "===== MACD #2 ====="
			MACD2_Type            = "0"
			MACD2_TF              = "0"
			MACD2_PeriodFast      = "12"
			MACD2_FastMA_Method   = "1"
			MACD2_PeriodSlow      = "27"
			MACD2_SlowMA_Method   = "1"
			MACD2_PeriodSignal    = "9"
			MACD2_SignalMA_Method = "0"
			MACD2_Price           = "1"
			MACD2_JMA_Phase       = "0"
			MACD2_Reverse         = "false"
			MACD2_UseClosedBars   = "true"
			MACD2_OpenOn          = "0"
			MACD2_MartinOn        = "0"
			MACD2_CloseOn         = "0"
			MACD2_PartialCloseOn  = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			DTrend_Properties     = "===== DTrend ====="
			DTrend_Type           = "0"
			DTrend_TF             = "0"
			DTrend_PeriodMA1      = "5"
			DTrend_PeriodMA2      = "9"
			DTrend_PeriodD        = "5"
			DTrend_Scalar         = "1000000"
			DTrend_Level          = "30"
			DTrend_Reverse        = "false"
			DTrend_UseClosedBars  = "true"
			DTrend_OpenOn         = "0"
			DTrend_MartinOn       = "0"
			DTrend_CloseOn        = "0"
			DTrend_PartialCloseOn = "0"
		}
	}

	#Detect Version 2.36
	#AutoHedge_OnDrawDown=0
	#CustomStepCoefficients=
	#PartialCloseHedge_MainToMain=false
	#BigCandle_HedgeOn=0
	#Oscillators_HedgeOn=0
	#Oscillator2_HedgeOn=0
	#Oscillator3_HedgeOn=0
	#IdentifyTrend_HedgeOn=0
	#TDI_HedgeOn=0
	#MACD_HedgeOn=0
	#MACD2_HedgeOn=0
	#DTrend_HedgeOn=0
	#PSar_HedgeOn=0
	#MA_Filter_1_HedgeOn=0
	#MA_Filter_2_HedgeOn=0
	#MA_Filter_3_HedgeOn=0
	#ZZ_HedgeOn=0
	#VolFilter_HedgeOn=0
	#FIBO_HedgeOn=0
	#FIB2_HedgeOn=0
	#News_HedgeOn=0
	if (Select-String -Path $filePath -Quiet -Pattern "AutoHedge_OnDrawDown") {
		$version = $version + ">=2.36"
		$lastVersion = "2.36"
	}
	else {
		$update = $update + "/2.36"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			AutoHedge_OnDrawDown         = "0"
			CustomStepCoefficients       = ""
			PartialCloseHedge_MainToMain = "false"
			BigCandle_HedgeOn            = "0"
			Oscillators_HedgeOn          = "0"
			Oscillator2_HedgeOn          = "0"
			Oscillator3_HedgeOn          = "0"
			IdentifyTrend_HedgeOn        = "0"
			TDI_HedgeOn                  = "0"
			MACD_HedgeOn                 = "0"
			MACD2_HedgeOn                = "0"
			DTrend_HedgeOn               = "0"
			PSar_HedgeOn                 = "0"
			MA_Filter_1_HedgeOn          = "0"
			MA_Filter_2_HedgeOn          = "0"
			MA_Filter_3_HedgeOn          = "0"
			ZZ_HedgeOn                   = "0"
			VolFilter_HedgeOn            = "0"
			FIBO_HedgeOn                 = "0"
			FIB2_HedgeOn                 = "0"
			News_HedgeOn                 = "0"
		}
	}

	#Detect Version 2.37.2
	#Pending_DisableForOpposite=false
	#AntiMartingail_AllowTP=false
	#TesterWithdrawal_Header===== Tester withdrawal ====
	#TesterWithdrawal_Type=0
	#TesterWithdrawal_Frequency=2
	#TesterWithdrawal_Size=50
	#InpEquityRecorder===== Optimization criterion ====
	if (Select-String -Path $filePath -Quiet -Pattern "Pending_DisableForOpposite") {
		$version = $version + ">=2.37.2"
	}
	else {
		$update = $update + "/2.37.2"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Pending_DisableForOpposite = "false"
			AntiMartingail_AllowTP     = "false"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			TesterWithdrawal_Header    = "==== Tester withdrawal ===="
			TesterWithdrawal_Type      = "0"
			TesterWithdrawal_Frequency = "2"
			TesterWithdrawal_Size      = "50"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			InpEquityRecorder = "==== Optimization criterion ===="
		}
	}

	#Detect Version 2.38
	#MaxStepSize=0
	#AntiMaxStepSize=0
	if (Select-String -Path $filePath -Quiet -Pattern "MaxStepSize") {
		$version = $version + ">=2.38"
		$lastVersion = "2.38"
	}
	else {
		$update = $update + "/2.38"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MaxStepSize     = "0"
			AntiMaxStepSize = "0"
		}
	}

	#Detect Version 2.39
	#MaxFloatingLoss1=0
	#MinMarginLevel1=0
	if (Select-String -Path $filePath -Quiet -Pattern "MaxFloatingLoss1") {
		$version = $version + ">=2.39"
		$lastVersion = "2.39"
	}
	else {
		$update = $update + "/2.39"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			MaxFloatingLoss1 = "0"
			MinMarginLevel1  = "0"
		}
	}

	#Detect Version 2.40, 2.41
	#BinanceTradeConnector_Settings====== BinanceTradeConnector settings =====
	#CustomStartBalance=0
	#ShowVirtualInfoOnChart=false
	#SaveVirtualStateOnEveryChange=true
	#GUI_Color_Text=0
	if (Select-String -Path $filePath -Quiet -Pattern "CustomStartBalance") {
		$version = $version + ">=(2.40,2.41)"
		$lastVersion = "2.40-2.41"
	}
	else {
		$update = $update + "/(2.40,2.41)"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			BinanceTradeConnector_Settings = "===== BinanceTradeConnector settings ====="
			CustomStartBalance             = "0"
			ShowVirtualInfoOnChart         = "false"
			SaveVirtualStateOnEveryChange  = "true"
			GUI_Color_Text                 = "0"
		}
	}

	#Detect Version 2.42
	#Set File: EURUSD_100Cent_StochasticK1_IdentifyTrend_TDI_VolFilterWATR_FIBO1_FIBO2_v2.42.set
	#Pending_DeleteIfOpposite=true
	if (Select-String -Path $filePath -Quiet -Pattern "Pending_DeleteIfOpposite") {
		$version = $version + ">=2.42"
		$lastVersion = "2.42"
	}
	else {
		$update = $update + "/2.42"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Pending_DeleteIfOpposite = "false"
		}
	}

	#Detect Version 2.43.3
	#PartialClose_AnyToAny=false
	#DirChange_Properties====== Directional Change =====
	#DirChange_Type=0
	#DirChange_OpenOn=0
	#ZZ_UsePrevExtremums=false
	#ZZ_Visualization=---Visualization---
	#ZZ_VisualizeLevels=true
	#ZZ_FillRectangle=false
	#ZZ_ColorUP=11186720
	#ZZ_ColorDN=17919
	if (Select-String -Path $filePath -Quiet -Pattern "PartialClose_AnyToAny") {
		$version = $version + ">=2.43.3"
		$lastVersion = "2.43"
	}
	else {
		$update = $update + "/2.43.3"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			Pending_DeleteIfOpposite = "false"
			PartialClose_AnyToAny    = "false"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			DirChange_Properties = "===== Directional Change ====="
			DirChange_Type       = "0"
			DirChange_OpenOn     = "0"
			ZZ_UsePrevExtremums  = "false"
			ZZ_Visualization     = "---Visualization---"
			ZZ_VisualizeLevels   = "true"
			ZZ_FillRectangle     = "false"
			ZZ_ColorUP           = "11186720"
			ZZ_ColorDN           = "17919"
		}
	}

	#Detect Version 2.44
	#BigCandle_MaxSize=0
	if (Select-String -Path $filePath -Quiet -Pattern "BigCandle_MaxSize") {
		$version = $version + ">=2.44"
		$lastVersion = "2.44"
	}
	else {
		$update = $update + "/2.44"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			BigCandle_MaxSize = "0"
		}
	}

	#Detect Version 2.45
	#GlobalAccountStopTillTomorrow=false
	#TrailingIncreaseEvery=0
	#TrailingIncreaseSize=0
	#TrailingMinMaxSize=0
	#; ADX properties
	#ADX_Properties====== ADX =====
	#ADX_Type=0
	#ADX_TF=0
	#ADX_Period=14
	#ADX_Level=10
	#ADX_Reverse=false
	#ADX_UseClosedBars=true
	#ADX_OpenOn=0
	#ADX_MartinOn=0
	#ADX_HedgeOn=0
	#ADX_CloseOn=0
	#ADX_PartialCloseOn=0
	if (Select-String -Path $filePath -Quiet -Pattern "GlobalAccountStopTillTomorrow") {
		$version = $version + ">=2.45"
		$lastVersion = "2.45"
	}
	else {
		$update = $update + "/2.45"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			GlobalAccountStopTillTomorrow = "false"
			TrailingIncreaseEvery         = "0"
			TrailingIncreaseSize          = "0"
			TrailingMinMaxSize            = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			ADX_Properties     = "===== ADX ====="
			ADX_Type           = "0"
			ADX_TF             = "0"
			ADX_Period         = "14"
			ADX_Level          = "10"
			ADX_Reverse        = "false"
			ADX_UseClosedBars  = "true"
			ADX_OpenOn         = "0"
			ADX_MartinOn       = "0"
			ADX_HedgeOn        = "0"
			ADX_CloseOn        = "0"
			ADX_PartialCloseOn = "0"
		}
	}

	#Detect Version 2.46
	#TrailingDecreaseEveryMinutes=0
	#TrailingDecreaseCoeff=0.9
	#TrailingDecreaseStartAfter=0
	#TrailingMinSize=0
	#TrailingMaxSize=0
	#ChangeStep_AfterOrder=0
	#ChangeStep_Coeff=2
	#PartialClose_CloseProfitItself=false
	if (Select-String -Path $filePath -Quiet -Pattern "TrailingDecreaseCoeff") {
		$version = $version + ">=2.46"
		$lastVersion = "2.46"
	}
	else {
		$update = $update + "/2.46"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			TrailingDecreaseEveryMinutes   = "0"
			TrailingDecreaseCoeff          = "0.9"
			TrailingDecreaseStartAfter     = "0"
			TrailingMinSize                = "0"
			TrailingMaxSize                = "0"
			ChangeStep_AfterOrder          = "0"
			ChangeStep_Coeff               = "2"
			PartialClose_CloseProfitItself = "false"
		}
	}

	#Detect Version 2.47
	#SendAlertsToGrammy=true
	#UseOnlyOpenedTrades=true
	if (Select-String -Path $filePath -Quiet -Pattern "UseOnlyOpenedTrades") {
		$version = $version + ">=2.47"
		$lastVersion = "2.47"
	}
	else {
		$update = $update + "/2.47"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			SendAlertsToGrammy  = "true"
			UseOnlyOpenedTrades = "true"
		}
	}

	#Detect Version 2.48
	#GlobalAccountStopLoss_ccy=0
	#GlobalAccountStopLoss_perc=0
	#DL_Properties====== Daily limits =====
	#DL_MaxTrades_CurSymbol=0
	#DL_MaxTrades_AllSymbols=0
	#DL_MaxDrawDown=0
	#DL_MaxDrawDown_ccy=0
	#DL_MaxProfit=0
	#DL_MaxProfit_ccy=0
	#WL_Properties====== Weekly limits =====
	#WL_MaxDrawDown=0
	#WL_MaxDrawDown_ccy=0
	#WL_MaxProfit=0
	#WL_MaxProfit_ccy=0
	#ML_Properties====== Monthly limits =====
	#ML_MaxDrawDown=0
	#ML_MaxDrawDown_ccy=0
	#ML_MaxProfit=0
	#ML_MaxProfit_ccy=0
	#CL_Properties====== Common limits properties =====
	#CL_WeekStart_Day=1
	#CL_DayStartHour=0
	#CL_CloseOnProfitAndDD=true
	if (Select-String -Path $filePath -Quiet -Pattern "GlobalAccountStopLoss_ccy") {
		$version = $version + ">=2.48"
		$lastVersion = "2.48"
	}
	else {
		$update = $update + "/2.48"
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			GlobalAccountStopLoss_ccy  = "0"
			GlobalAccountStopLoss_perc = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			DL_Properties           = "===== Daily limits ====="
			DL_MaxTrades_CurSymbol  = "0"
			DL_MaxTrades_AllSymbols = "0"
			DL_MaxDrawDown          = "0"
			DL_MaxDrawDown_ccy      = "0"
			DL_MaxProfit            = "0"
			DL_MaxProfit_ccy        = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			WL_Properties      = "===== Weekly limits ====="
			WL_MaxDrawDown     = "0"
			WL_MaxDrawDown_ccy = "0"
			WL_MaxProfit       = "0"
			WL_MaxProfit_ccy   = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			ML_Properties      = "===== Monthly limits ====="
			ML_MaxDrawDown     = "0"
			ML_MaxDrawDown_ccy = "0"
			ML_MaxProfit       = "0"
			ML_MaxProfit_ccy   = "0"
		}
		Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
			CL_Properties         = "===== Common limits properties ====="
			CL_WeekStart_Day      = "1"
			CL_DayStartHour       = "0"
			CL_CloseOnProfitAndDD = "true"
		}
	}

	#Set Properties v2.48.2
	Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
		BinanceTradeConnector_Settings = "===== BinanceTradeConnector settings ====="
		Expert_Properties              = "===== Expert ====="
		Lot_Properties                 = "===== Lot ====="
		Hedge_Properties               = "===== Hedge ====="
		GlobalAccount_Properties       = "===== Global Account ====="
		DL_Properties                  = "===== Daily limits ====="
		WL_Properties                  = "===== Weekly limits ====="
		ML_Properties                  = "===== Monthly limits ====="
		CL_Properties                  = "===== Common limits properties ====="
		VolPV_Properties               = "===== Volatility for all parameters nominated in points ====="
		Pending_Properties             = "===== Pending entry ====="
		StopLoss_Properties            = "===== Stop Loss ====="
		StopLoss_Global                = "===== Summ Stop Loss (buy + sell) ====="
		StopLoss_Pause                 = "===== Pause after loss ====="
		TakeProfit_Properties          = "===== Take Profit ====="
		TakeProfit_ReduceAfter         = "===== Reduce Take Profit after minutes ====="
		TakeProfit_ReduceSeries        = "===== Reduce Take Profit for every order ====="
		TakeProfit_Global              = "===== Summ Take Profit (buy + sell) ====="
		MinProfitToClose_Properties    = "===== Min profit to close on signal ====="
	}
	Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
		TrailingStop_Properties     = "===== Trailing Stop ====="
		Martingale_Properties       = "===== Martingale ====="
		AllowBoth_Properties        = "===== Allow both Martin and Anti-martin ====="
		PartialClose_Properties     = "===== Partial Close ====="
		GlobalMartingail_Properties = "===== Apply martin to the new deals ====="
		AntiMartingale_Properties   = "===== Anti-Martingale ====="
	}
	Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
		DirChange_Properties     = "===== Directional Change ====="
		BigCandle_Properties     = "===== Big Candle ====="
		Oscillators_Properties   = "===== Oscillator #1 ====="
		Oscillator2_Properties   = "===== Oscillator #2 ====="
		Oscillator3_Properties   = "===== Oscillator #3 ====="
		IdentifyTrend_Properties = "===== IdentifyTrend ====="
		TDI_Properties           = "===== TDI ====="
		MACD_Properties          = "===== MACD #1 ====="
		MACD2_Properties         = "===== MACD #2 ====="
		ADX_Properties           = "===== ADX ====="
		DTrend_Properties        = "===== DTrend ====="
		PSar_Properties          = "===== Parabolic SAR ====="
		MA_Filter_1_Properties   = "===== MA Filter #1 ====="
		MA_Filter_2_Properties   = "===== MA Filter #2 ====="
		MA_Filter_3_Properties   = "===== MA Filter #3 ====="
		ZZ_Properties            = "===== ZigZag ====="
		VolMA_Properties         = "===== Volatility for MA and ZigZag Filters distance ====="
		VolFilter_Properties     = "===== Volatility Filter ====="
		FIBO_Properties          = "===== FIBO #1 ====="
		FIB2_Properties          = "===== FIBO #2 ====="
	}
	Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
		Spread_Settings            = "===== Spread ====="
		Time_Settings              = "===== Time ====="
		Custom_Schedule_Properties = "===== Custom Schedule ====="
		NewYear_Properties         = "===== New Year Holidays ====="
		News_Properties            = "===== News ====="
		News_Draw_Properties       = "===== Visualization ====="
		Lines_Settings             = "===== Lines ====="
		GUI_Settings               = "===== GUI ====="
		ShowOrders_Settings        = "===== Show Orders ====="
		Color_Properties           = "===== Main Color ====="
		Profit_Properties          = "===== Take Profit ====="
		Style_Properties           = "===== Style ====="
		Notifications_Settings     = "===== Notifications ====="
		Optimization_Settings      = "===== Optimization ====="
	}

	#Read All Setting File parameters
	$inifile = Get-IniFile($filePath)

	#Expert_Comment
	$Expert_Comment = [string]$inifile["Expert_Comment"]
	$lastUpdate = "2.48"
	Set-OrAddIniValue -FilePath $filePath  -keyValueList @{
		Expert_Comment = $Expert_Comment + "Updated:" + $lastVersion + "=>" + $lastUpdate
	}

	return [string]$version, [string]$lastVersion, [string]$update, [string]$PathDest
}

#######################GUI################################################################
### API Windows Forms ###
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

### Create form ###
$form = New-Object System.Windows.Forms.Form
$form.Text = "Update Setting File to v2.48 - CommunityPower EA MT5"
$form.Size = '800,320'
$form.StartPosition = "CenterScreen"
$form.MinimumSize = $form.Size
$form.MaximizeBox = $False
$form.Topmost = $True

### Define controls ###
$button = New-Object System.Windows.Forms.Button
$button.Location = '5,5'
$button.Size = '75,23'
$button.Width = 120
$button.Text = "Update Setting File MT5"

### Define controls ###
$button2 = New-Object System.Windows.Forms.Button
$button2.Location = '5,30'
$button2.Size = '75,23'
$button2.Width = 120
$button2.Text = "Clear ListBox"

# Label
$label2 = New-Object Windows.Forms.Label
$label2.Location = '5,70'
$label2.AutoSize = $True
$label2.Text = "Versions:"

# Label
$label3 = New-Object Windows.Forms.Label
$label3.Location = '5,85'
$label3.AutoSize = $True
$label3.Text = "Last Version Detected:"

# Label
$label4 = New-Object Windows.Forms.Label
$label4.Location = '5,100'
$label4.AutoSize = $True
$label4.Text = "Update:"

# Label
$label5 = New-Object Windows.Forms.Label
$label5.Location = '5,115'
$label5.AutoSize = $True
$label5.Text = "New File Name:"

# Label
$label = New-Object Windows.Forms.Label
$label.Location = '5,160'
$label.AutoSize = $True
$label.Text = "Drag and Drop MT5 files settings here:"

# Listbox
$listBox = New-Object Windows.Forms.ListBox
$listBox.Location = '5,180'
$listBox.Height = 80
$listBox.Width = 760
$listBox.Anchor = ([System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top)
$listBox.IntegralHeight = $False
$listBox.AllowDrop = $True

# StatusBar
$statusBar = New-Object System.Windows.Forms.StatusBar
$statusBar.Text = "Ready"

### Add controls to form ###
$form.SuspendLayout()
$form.Controls.Add($button)
$form.Controls.Add($button2)
$form.Controls.Add($label)
$form.Controls.Add($label2)
$form.Controls.Add($label3)
$form.Controls.Add($label4)
$form.Controls.Add($label5)
$form.Controls.Add($listBox)
$form.Controls.Add($statusBar)
$form.ResumeLayout()

### Write event handlers ###
$button_Click = {
	foreach ($item in $listBox.Items) {
		if (!($i -is [System.IO.DirectoryInfo])) {
			$version, $lastVersion, $update, $PathDest = MainUpdateVersion -file $item
			if ($version.length -gt 2) {
				if ($update.length -gt 2) {
					$label2.Text = 'Versions: ' + $version
					$label3.Text = 'Last Version Detected: ' + $lastVersion
					$label4.Text = 'Updated: ' + $update
					$label5.Text = 'New File Name: ' + $PathDest
					[System.Windows.Forms.MessageBox]::Show('Last Version Detected: ' + $lastVersion + "`nUpdated:" + $update, 'Setting Updated', 0, 64)
				}
				else {
					$label3.Text = 'Not updated'
					[System.Windows.Forms.MessageBox]::Show('Not updated', 'Not updated', 0, 64)
				}
			}
			else {
				$label2.Text = 'Not version detected'
				[System.Windows.Forms.MessageBox]::Show('Not version detected', 'Not updated', 0, 64)
			}
		}
	}

	$statusBar.Text = ("List contains $($listBox.Items.Count) items")
}

$button2_Click = {
	$listBox.Items.Clear()
}

$listBox_DragOver = [System.Windows.Forms.DragEventHandler] {
	if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
		# $_ = [System.Windows.Forms.DragEventArgs]
		$_.Effect = 'Copy'
	}
	else {
		$_.Effect = 'None'
	}
}

$listBox_DragDrop = [System.Windows.Forms.DragEventHandler] {
	foreach ($filename in $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) {
		# $_ = [System.Windows.Forms.DragEventArgs]
		$listBox.Items.Add($filename)
	}
	$statusBar.Text = ("List contains $($listBox.Items.Count) items")
}

$form_FormClosed = {
	try {
		$button.remove_Click($button_Click)
		$button2.remove_Click($button2_Click)
		$listBox.remove_DragOver($listBox_DragOver)
		$listBox.remove_DragDrop($listBox_DragDrop)
		$form.remove_FormClosed($Form_Cleanup_FormClosed)
	}
	catch [Exception]
	{ }
}

### Wire up events ###
$button.Add_Click($button_Click)
$button2.Add_Click($button2_Click)
$listBox.Add_DragOver($listBox_DragOver)
$listBox.Add_DragDrop($listBox_DragDrop)
$form.Add_FormClosed($form_FormClosed)

#### Show form ###
[void] $form.ShowDialog()
