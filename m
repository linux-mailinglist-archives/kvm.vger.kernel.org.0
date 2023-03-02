Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C506A7BF3
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 08:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCBHkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 02:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCBHko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 02:40:44 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A055199D6
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 23:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:Subject:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PGo6surgK71U+p+HtrTAIZ0gVyfecjrnIWnIG/k4/uA=; b=d9GY5OFqRvLBCdAeBP+RihARFB
        4vA/6qdffqJYnbEJm1Y7T4lsrSSq4/ZahGf8TUyUmaQzF5mN4lmJboVLChpmfqH/x8Ah0julDOpDD
        Goi6TfwfowdHyd0Vz97HSXt11UWw3rEBuMZd1GzwS2JzTNJRb0Jk+ksuwWjJy6eREtgI=;
Received: from [2a02:587:6a02:3a00::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pXdYK-00CKgP-1L; Thu, 02 Mar 2023 09:40:36 +0200
Message-ID: <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
Date:   Thu, 2 Mar 2023 09:40:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
 <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
 <20230228114606.446e8db2.alex.williamson@redhat.com>
 <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
 <20230301071049.0f8f88ae.alex.williamson@redhat.com>
From:   Tasos Sahanidis <tasos@tasossah.com>
Subject: Re: Bug: Completion-Wait loop timed out with vfio
In-Reply-To: <20230301071049.0f8f88ae.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-03-01 16:10, Alex Williamson wrote:
> 0000:02:00.0 is the upstream port of that switch and 0000:03:02.0 is
> the downstream port for the 7790.  0000:03:02.0 is the port that should
> also now enter D3hot.
> 
>> If so, I tested in 5.18, both before and while running the VM, with 6.2
>> both with and without disable_idle_d3, and in all cases they stayed at D0.
> 
> In this case the upstream port should always stay in D0, it has quite a
> lot more devices under it than just the GPU.  It's interesting that the
> MosChip that assigns ok is also under a downstream port of this switch.
> That means the downstream port 0000:03:06.0 should also be entering
> D3hot when all of the MosChip devices are attached to vfio-pci and
> unused.
> 
> I'm not convinced thought that the MosChip assignment is a good
> comparison device though, as a "multi-i/o" controller, it's possible
> that it doesn't actually make use of DMA that would trigger the IOMMU
> like the GPU does.  Do you have a NIC card you could replace one of
> these with?

Unfortunately I do not have any other PCIe devices available.
I did, however, pass through the onboard Realtek NIC and it worked
perfectly fine (without any errors in dmesg).

0000:03:05.0 should be the root port for the NIC.

==> 6_2_before_vm_rtl <==
+ cat /sys/bus/pci/devices/0000:03:05.0/power_state
D3hot
+ cat /sys/bus/pci/devices/0000:03:05.0/power/runtime_status
suspended
+ cat /sys/bus/pci/devices/0000:03:05.0/power/control
auto
+ cat /sys/bus/pci/devices/0000:09:00.0/power_state
D3hot
+ cat /sys/bus/pci/devices/0000:09:00.0/power/runtime_status
suspended
+ cat /sys/bus/pci/devices/0000:09:00.0/power/control
auto
+ lspci -vvv -s 0000:03:05.0
03:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 37
	Bus: primary=03, secondary=09, subordinate=09, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff [size=4K]
	Memory behind bridge: d0300000-d03fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport


==> 6_2_running_vm_rtl <==
+ cat /sys/bus/pci/devices/0000:03:05.0/power_state
D0
+ cat /sys/bus/pci/devices/0000:03:05.0/power/runtime_status
active
+ cat /sys/bus/pci/devices/0000:03:05.0/power/control
auto
+ cat /sys/bus/pci/devices/0000:09:00.0/power_state
D0
+ cat /sys/bus/pci/devices/0000:09:00.0/power/runtime_status
active
+ cat /sys/bus/pci/devices/0000:09:00.0/power/control
auto
+ lspci -vvv -s 0000:03:05.0
03:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 37
	Bus: primary=03, secondary=09, subordinate=09, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff [size=4K]
	Memory behind bridge: d0300000-d03fffff [size=1M]
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport


> It's possible the switch has a problem with D3hot support and it may
> need to be disabled or augmented with a PCI quirk.  In addition to
> investigating what power state the downstream port is achieving and
> reporting lspci -vvv with and without disable_idle_d3, would you mind
> reporting "lspci -nns 2:00.0" and "lspci -nns 3:" to report all the
> vendor and device IDs of the switch.  Thanks,
> 

It seems that way, especially after manually preventing the root port
for the graphics card from entering D3hot, however the one for the NIC
seems to be doing that just fine, which makes things more confusing.

$ lspci -nns 2:00.0
02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstream [1022:57ad]

$ lspci -nns 3:
03:01.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
03:02.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
03:03.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
03:05.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
03:06.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
03:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]
03:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]
03:0a.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]

And the information for the PCIe port:

==> 6_2_before_vm <==
+ cat /sys/bus/pci/devices/0000:03:02.0/power_state
D3hot
+ cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
suspended
+ cat /sys/bus/pci/devices/0000:03:02.0/power/control
auto
+ lspci -vvv -s 0000:03:02.0
03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 35
	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff [size=4K]
	Memory behind bridge: d0100000-d01fffff [size=1M]
	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-, ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
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
		LaneErrStat: LaneErr at lane: 0 1 2 3
	Capabilities: [2a0 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [370 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
		L1SubCtl2:
	Capabilities: [400 v1] Data Link Feature <?>
	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
	Capabilities: [440 v1] Lane Margining at the Receiver <?>
	Kernel driver in use: pcieport


==> 6_2_running_vm <==
+ cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
+ cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
+ cat /sys/bus/pci/devices/0000:03:02.0/power/control
auto
+ lspci -vvv -s 0000:03:02.0
03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 35
	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff [size=4K]
	Memory behind bridge: d0100000-d01fffff [size=1M]
	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-, ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
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
		LaneErrStat: LaneErr at lane: 0 1 2 3
	Capabilities: [2a0 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [370 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
		L1SubCtl2:
	Capabilities: [400 v1] Data Link Feature <?>
	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
	Capabilities: [440 v1] Lane Margining at the Receiver <?>
	Kernel driver in use: pcieport


==> 6_2_before_vm_disable_d3_idle <==
+ cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
+ cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
+ cat /sys/bus/pci/devices/0000:03:02.0/power/control
auto
+ lspci -vvv -s 0000:03:02.0
03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 35
	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff [size=4K]
	Memory behind bridge: d0100000-d01fffff [size=1M]
	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-, ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
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
		LaneErrStat: LaneErr at lane: 0 1 2 3
	Capabilities: [2a0 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [370 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
		L1SubCtl2:
	Capabilities: [400 v1] Data Link Feature <?>
	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
	Capabilities: [440 v1] Lane Margining at the Receiver <?>
	Kernel driver in use: pcieport


==> 6_2_running_vm_disable_d3_idle <==
+ cat /sys/bus/pci/devices/0000:03:02.0/power_state
D0
+ cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
active
+ cat /sys/bus/pci/devices/0000:03:02.0/power/control
auto
+ lspci -vvv -s 0000:03:02.0
03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 35
	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff [size=4K]
	Memory behind bridge: d0100000-d01fffff [size=1M]
	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0
			ExtTag+ RBE+
		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM Disabled; Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS-, ARIFwd-
			 AtomicOpsCap: Routing-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
			 AtomicOpsCtl: EgressBlck-
		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
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
		LaneErrStat: LaneErr at lane: 0 1 2 3
	Capabilities: [2a0 v1] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	Capabilities: [370 v1] L1 PM Substates
		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
		L1SubCtl2:
	Capabilities: [400 v1] Data Link Feature <?>
	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
	Capabilities: [440 v1] Lane Margining at the Receiver <?>
	Kernel driver in use: pcieport


--
Tasos
