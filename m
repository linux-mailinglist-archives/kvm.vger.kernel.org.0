Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E306A7BC3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCBHTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCBHTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:19:20 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050412A157
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:References:Cc:To:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AlsxuHp6SXP8Cbw3lxv6XD+2CDQed0ZL4dZVrSjHw+E=; b=vTj1ToYcCSBZ9InFmrd+8n+tmO
        8vIxvdU5bs3jaEwIN3hb+fQYAY4OEIKftTsfhm+s9aI/WneAE2Wp0XtwaBBa7E7HO6PMx8AWsJGEh
        SAGq8uvZhMe5j6YQ0Z760+nPSTE5Jn6penCDxD0QWisWOMPeEhEb4ae2qPOOg8H/gfd4=;
Received: from [2a02:587:6a02:3a00::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pXdDZ-00CKZ0-D8; Thu, 02 Mar 2023 09:19:09 +0200
Message-ID: <0b723bb5-1ca1-da97-256e-b6fd730166c6@tasossah.com>
Date:   Thu, 2 Mar 2023 09:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <de78ffc1-430f-7eb9-938f-af5c4ed27ea0@nvidia.com>
Content-Language: en-US
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <de78ffc1-430f-7eb9-938f-af5c4ed27ea0@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-01 12:10, Abhishek Sahu wrote:
>  So D3cold is not supported on this system.
>  Most of the desktop systems doesn’t support D3cold. 
>  In that case, as Alex mentioned that after that patch the root port can also
>  go into D3hot state.
>  
>  Another difference is that earlier we were changing the device power state by
>  directly writing into PCI PM_CTRL registers. Now, we are using kernel generic
>  runtime PM function to perform the same.
> 
>  We need to print the root port runtime status and power_state as Alex mentioned.

Understood. Thanks for explaining!

>  Apart from that, can we try following things to get more information,
> 
>  Before binding the Device to vfio-pci driver, disable the runtime power
>  management of the root port
>  
>  # echo on > /sys/bus/pci/devices/<root_port B:D:F>/power/control
> 
>  After this, bind the device to vfio-pci driver and check the runtime status and power_state
>  for both device and root port. The root port runtime_status should be active and power_state
>  should be D0.
> 
>  With the runtime PM disabled for the root port, check if this issue happens.
>  It will give clue if the root port going into D3hot status is causing the issue or
>  the use of runtime PM to put device into D3hot is causing this. 

I prevented vfio-pci from loading automatically on boot, and booted with
nomodeset. I set the power control to manual (echo on), and then loaded
vfio-pci. At that point, the root port was at D0 (never entered D3hot)
but the card was at D3hot.

There were no errors in dmesg when I started the VM.

On boot:
==> 6_2_before_vm_before_vfio_before_manual <==
# cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
# cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:03:02.0/power/control
auto
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power/control
on

After echo on > [..]/power/control
==> 6_2_before_vm_before_vfio_after_manual <==
# cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
# cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:03:02.0/power/control
on
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
unknown
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power/control
on

After loading vfio-pci:
==> 6_2_before_vm_after_vfio_after_manual <==
# cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
# cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:03:02.0/power/control
on
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D3hot
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
suspended
# cat /sys/bus/pci/devices/0000:06:00.0/power/control
auto

And finally, while the VM was running:
==> 6_2_running_vm_after_vfio_after_manual <==
# cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
# cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:03:02.0/power/control
on
# cat /sys/bus/pci/devices/0000:06:00.0/power_state
D0
# cat /sys/bus/pci/devices/0000:06:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000:06:00.0/power/control
auto

>  This  “Completion-Wait loop timed out with vfio” prints is coming
>  from the IOMMU driver. Can you please check once by adding ‘pci=realloc’
>  in your separate installation and see if we the memory are enabled after
>  D3hot cycles. If memory is getting disabled only after D3hot cycles with
>  ‘pci=realloc’, then we need to find out at which stage it is happening
>  (when the device is going into D3hot or when root port is going into D3hot).
> 
>  For this we can disable the runtime PM of both device and root port before
>  binding the device to vfio-pci driver. Then enable runtime PM of device first
>  and wait for it to go into suspended state. Then check lspci output. 
>  Then enable the same for root port and check lspci output.

Assuming I understood this correctly, I added pci=realloc, and the
memory was disabled while in D3hot, but enabled as expected on D0.
While running the below commands, power control was set to the default
"auto" after a fresh reboot.

Before running the VM:
# lspci -vvnn -s 0000:06:00.0
06:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] [1002:665c] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC [1043:0452]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at 1030000000 (64-bit, prefetchable) [disabled] [size=256M]
	Region 2: Memory at 1040000000 (64-bit, prefetchable) [disabled] [size=8M]
	Region 4: I/O ports at d000 [disabled] [size=256]
	Region 5: Memory at d0100000 (32-bit, non-prefetchable) [disabled] [size=256K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Vendor Specific Information: Len=08 <?>
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x4 (downgraded)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, NROPrPrP-, LTR-
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt+, EETLPPrefix+, MaxEETLPPrefixes 1
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [270 v1] Secondary PCI Express
		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
		LaneErrStat: 0
	Capabilities: [2b0 v1] Address Translation Service (ATS)
		ATSCap:	Invalidate Queue Depth: 00
		ATSCtl:	Enable+, Smallest Translation Unit: 00
	Capabilities: [2c0 v1] Page Request Interface (PRI)
		PRICtl: Enable- Reset-
		PRISta: RF- UPRGI- Stopped+
		Page Request Capacity: 00000020, Page Request Allocation: 00000000
	Capabilities: [2d0 v1] Process Address Space ID (PASID)
		PASIDCap: Exec+ Priv+, Max PASID Width: 10
		PASIDCtl: Enable- Exec- Priv-
	Kernel driver in use: vfio-pci
	Kernel modules: amdgpu


While running the VM (with IOMMU errors):
# lspci -vvnn -s 0000:06:00.0
06:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] [1002:665c] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC [1043:0452]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 42
	Region 0: Memory at 1030000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at 1040000000 (64-bit, prefetchable) [size=8M]
	Region 4: I/O ports at d000 [size=256]
	Region 5: Memory at d0100000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <ignored> [disabled]
	Capabilities: [48] Vendor Specific Information: Len=08 <?>
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (ok), Width x4 (downgraded)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, NROPrPrP-, LTR-
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt+, EETLPPrefix+, MaxEETLPPrefixes 1
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-
			 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
			 AtomicOpsCtl: ReqEn-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [270 v1] Secondary PCI Express
		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
		LaneErrStat: 0
	Capabilities: [2b0 v1] Address Translation Service (ATS)
		ATSCap:	Invalidate Queue Depth: 00
		ATSCtl:	Enable+, Smallest Translation Unit: 00
	Capabilities: [2c0 v1] Page Request Interface (PRI)
		PRICtl: Enable- Reset-
		PRISta: RF- UPRGI- Stopped+
		Page Request Capacity: 00000020, Page Request Allocation: 00000000
	Capabilities: [2d0 v1] Process Address Space ID (PASID)
		PASIDCap: Exec+ Priv+, Max PASID Width: 10
		PASIDCtl: Enable- Exec- Priv-
	Kernel driver in use: vfio-pci
	Kernel modules: amdgpu

--
Tasos
