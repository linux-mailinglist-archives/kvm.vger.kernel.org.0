Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAECA6A53BA
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 08:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjB1HeF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 02:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjB1HeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 02:34:03 -0500
Received: from devnull.tasossah.com (devnull.tasossah.com [IPv6:2001:41d0:1:e60e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432CB10AB1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 23:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=devnull.tasossah.com; s=vps; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:References:Cc:To:Subject:From:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6p9J/8Ep3SHR1U/wob1MQm4lG7rjLZCMj+HYVRtbsPA=; b=nuCauhUv6Nj6YFh/FW61mLoWPf
        0g5jAUevuHfhPcz3ewgs9W1H1XEAt03gmKAk9n2RRBh4jzk8Mg9HQGerkq06DFWyRjVXt6wcfw6rz
        NQJj0nPDfTAnnmf8iG+zMeZpseadAcoTvatz1/R65fNPLjm59m6HRA7BaXrTMVB+z3bg=;
Received: from [2a02:587:6a08:c500::298]
        by devnull.tasossah.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <tasos@tasossah.com>)
        id 1pWuUl-00Bzfs-Kt; Tue, 28 Feb 2023 09:33:55 +0200
Message-ID: <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
Date:   Tue, 28 Feb 2023 09:33:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Tasos Sahanidis <tasos@tasossah.com>
Subject: Re: Bug: Completion-Wait loop timed out with vfio
To:     Abhishek Sahu <abhsahu@nvidia.com>, alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
 <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
Content-Language: en-US
In-Reply-To: <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
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

Thank you very much for your quick response, Abhishek.

> 1. Set disable_idle_d3 module parameter set and check if this issue happens.
The issue does not happen with disable_idle_d3, which means I can at
least now use newer kernels. All the following commands were ran
*without* disable_idle_d3, so that the issue would occur.

> 2. Without starting the VM, check the status of following sysfs entries.
I assume by /sys/bus/pci/devices/<B:D:F>/power/power_state you meant
/sys/bus/pci/devices/<B:D:F>/power_state, as the former doesn't exist.

# cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
suspended
# cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
D3hot

> 3. After issue happens, run the above command again.
This is with the VM running and the errors in dmesg:

# cat /sys/bus/pci/devices/0000\:06\:00.0/power/runtime_status
active
# cat /sys/bus/pci/devices/0000\:06\:00.0/power_state
D0

> 4. Do lspci -s <B:D:F> -vvv without starting the VM and see if it is printing the correct
>    results and there is no new prints in the dmesg.
This is from before the VM was started:

# lspci -s 0000:06:00.0 -vvv
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at <ignored> (64-bit, prefetchable) [disabled]
	Region 2: Memory at <ignored> (64-bit, prefetchable) [disabled]
	Region 4: I/O ports at d000 [disabled] [size=256]
	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [disabled] [size=256K]
	Expansion ROM at fca40000 [disabled] [size=128K]
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


This is the diff from while the VM was running:

@@ -1,25 +1,25 @@
 root@tasos-Standard-PC-Q35-ICH9-2009:~# lspci -s 0000:06:00.0 -vvv
 06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Bonaire XT [Radeon HD 7790/8770 / R7 360 / R9 260/360 OEM] (prog-if 00 [VGA controller])
 	Subsystem: ASUSTeK Computer Inc. Radeon HD 7790 DirectCU II OC
-	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
+	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
-	Interrupt: pin A routed to IRQ 255
-	Region 0: Memory at <ignored> (64-bit, prefetchable) [disabled]
-	Region 2: Memory at <ignored> (64-bit, prefetchable) [disabled]
-	Region 4: I/O ports at d000 [disabled] [size=256]
-	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [disabled] [size=256K]
+	Interrupt: pin A routed to IRQ 42
+	Region 0: Memory at <ignored> (64-bit, prefetchable)
+	Region 2: Memory at <ignored> (64-bit, prefetchable)
+	Region 4: I/O ports at d000 [size=256]
+	Region 5: Memory at fca00000 (32-bit, non-prefetchable) [size=256K]
 	Expansion ROM at fca40000 [disabled] [size=128K]
 	Capabilities: [48] Vendor Specific Information: Len=08 <?>
 	Capabilities: [50] Power Management version 3
 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
-		Status: D3 NoSoftRst+ PME-Enable+ DSel=0 DScale=0 PME-
+		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
 			MaxPayload 128 bytes, MaxReadReq 512 bytes
-		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
+		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
 		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
 			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+


If I am reading this correctly, the card claims to not support D3cold.

Nothing extra was printed in dmesg while running the lspci commands.

Regarding the "Memory at <ignored> (64-bit, prefetchable)" lines, this
is because of presumably a firmware bug where it doesn't correctly map
the secondary graphics card in the address space.

On my main installation, I boot with pci=realloc which fixes it, but due
to the filesystem corruption risk, I am performing this testing on a
separate installation with the rest of the drives unmounted, and I
forgot to add pci=realloc. The behaviour in regards to the power
management issue is the same in both cases (it was originally discovered
with pci=realloc set).

> 5. Enable the ftrace events related with runtime power management before starting the VM
I captured the trace, but
$ wc -l trace
41129 trace

It doesn't sound like a good idea to send the contents of that entire
file. Is there something specific you'd like me to filter for?

Perhaps this is a bit better?:
$ grep "KVM\|qemu\|0000:06:00" trace | wc -l
719

If not, I can upload the entire file and send a link, although I don't
know if it will be caught in a spam filter.

>  6. Do you have any NVIDIA graphics card with you. If you have, then
>     could you please check if issue happens with that.
Unfortunately, no, I do not have any NVIDIA cards.

I tried passing through a:
0a:00.0 Serial controller [0700]: MosChip Semiconductor Technology Ltd. PCIe 9912 Multi-I/O Controller [9710:9912] (prog-if 02 [16550])
which claims:
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-

and I did not get any messages/errors in dmesg.

Thank you

--
Tasos

