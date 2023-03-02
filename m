Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E997C6A8A8B
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjCBUiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 15:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCBUiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 15:38:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B014332E56
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 12:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677789420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xM7tt7vpdQnZNunCL+xINx2jfIRMJyjiUFG+7CDB9Xg=;
        b=UNDluyn04XQvqxaQ6FPRkQe3Eg/u5TfDQhuGU5FnV5BMxeAbZgs6UxXnoDwCn2BIYMzXzW
        dySxlM9QMSlxhRM7OgHNqI++vEK8XOhVPxw3JSXK36sNQQhtDEdLTX5RSjKnqIx717oa5O
        4Z+s3C7SwCkxPHFqbcpwRDDndjjggt4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-629-SpQD2EQiPke5FhzC-Qsj4Q-1; Thu, 02 Mar 2023 15:36:59 -0500
X-MC-Unique: SpQD2EQiPke5FhzC-Qsj4Q-1
Received: by mail-io1-f71.google.com with SMTP id l7-20020a0566022dc700b0074cc9aba965so185945iow.11
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 12:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xM7tt7vpdQnZNunCL+xINx2jfIRMJyjiUFG+7CDB9Xg=;
        b=n+o2ar6o5US0ButVJXwt+fE1lCWfoiRuwL2XXqdMd7t4afXj2k9US9auVgIwlgdrOf
         a18NF6j+hZgvUOtyJC94nDU0a73Hbezh1HUYF8of50ZBnaxEc0VYw3vyS9WMwKdotsBH
         Xu+yKNug7+QP8izsiy0MgO/8ViGaOK/DRJuBSXP5+vDvbhkZwdoxCg3iLBveiMXVQVu8
         LkpJCi8ThBKJssNwELGOBHqCJnmFk1Ix/DJIs+zq+/zhjLZv+tqwm1m6p7S4Zt3ZeL7S
         bvwTYkd5Kr4wskhLB7bTlf+FnctXWLlsBTbMxoBiikfHScFsNNFO4PeFBW7c4jiKkAWV
         2qhw==
X-Gm-Message-State: AO0yUKVRKJmSmWzIS5S8UdzzEVJ8wsQ2+JaoH5y5NdqDlvK9ZZ6XL+1g
        99B49FH2ixkl0S7fp6WHwR7MLSAxPRztWZl/4ufXA+0KP0JzjB0oC9jcN7EISsxTlwNdJhpuWz0
        ghRQlqNHYUBUT
X-Received: by 2002:a92:180b:0:b0:313:ce4b:a435 with SMTP id 11-20020a92180b000000b00313ce4ba435mr7052478ily.25.1677789418253;
        Thu, 02 Mar 2023 12:36:58 -0800 (PST)
X-Google-Smtp-Source: AK7set9F2qAXw+DLvzddvRun7AbORSi4PE6iqhr0OJ2kcnKxEmHWp3pAYg6+hA8bG89Nucw/14M5jQ==
X-Received: by 2002:a92:180b:0:b0:313:ce4b:a435 with SMTP id 11-20020a92180b000000b00313ce4ba435mr7052467ily.25.1677789417834;
        Thu, 02 Mar 2023 12:36:57 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e12-20020a02caac000000b003c488204c6fsm145095jap.76.2023.03.02.12.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:36:57 -0800 (PST)
Date:   Thu, 2 Mar 2023 13:36:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tasos Sahanidis <tasos@tasossah.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>, kvm@vger.kernel.org
Subject: Re: Bug: Completion-Wait loop timed out with vfio
Message-ID: <20230302133655.2966f2e3.alex.williamson@redhat.com>
In-Reply-To: <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
References: <a01fa87d-bd42-e108-606b-78759edcecf8@tasossah.com>
        <bcc9d355-b464-7eaf-238c-e95d2f65c93d@nvidia.com>
        <31c2caf4-57b2-be1a-cf15-146903f7b2a1@tasossah.com>
        <20230228114606.446e8db2.alex.williamson@redhat.com>
        <7c1980ec-d032-11c1-b09d-4db40611f268@tasossah.com>
        <20230301071049.0f8f88ae.alex.williamson@redhat.com>
        <4c079c5a-f8e2-ce4d-a811-dc574f135cff@tasossah.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Mar 2023 09:40:35 +0200
Tasos Sahanidis <tasos@tasossah.com> wrote:

> On 2023-03-01 16:10, Alex Williamson wrote:
> > 0000:02:00.0 is the upstream port of that switch and 0000:03:02.0 is
> > the downstream port for the 7790.  0000:03:02.0 is the port that should
> > also now enter D3hot.
> >   
> >> If so, I tested in 5.18, both before and while running the VM, with 6.2
> >> both with and without disable_idle_d3, and in all cases they stayed at D0.  
> > 
> > In this case the upstream port should always stay in D0, it has quite a
> > lot more devices under it than just the GPU.  It's interesting that the
> > MosChip that assigns ok is also under a downstream port of this switch.
> > That means the downstream port 0000:03:06.0 should also be entering
> > D3hot when all of the MosChip devices are attached to vfio-pci and
> > unused.
> > 
> > I'm not convinced thought that the MosChip assignment is a good
> > comparison device though, as a "multi-i/o" controller, it's possible
> > that it doesn't actually make use of DMA that would trigger the IOMMU
> > like the GPU does.  Do you have a NIC card you could replace one of
> > these with?  
> 
> Unfortunately I do not have any other PCIe devices available.
> I did, however, pass through the onboard Realtek NIC and it worked
> perfectly fine (without any errors in dmesg).
> 
> 0000:03:05.0 should be the root port for the NIC.
> 
> ==> 6_2_before_vm_rtl <==  
> + cat /sys/bus/pci/devices/0000:03:05.0/power_state
> D3hot
> + cat /sys/bus/pci/devices/0000:03:05.0/power/runtime_status
> suspended
> + cat /sys/bus/pci/devices/0000:03:05.0/power/control
> auto
> + cat /sys/bus/pci/devices/0000:09:00.0/power_state
> D3hot
> + cat /sys/bus/pci/devices/0000:09:00.0/power/runtime_status
> suspended
> + cat /sys/bus/pci/devices/0000:09:00.0/power/control
> auto
> + lspci -vvv -s 0000:03:05.0
> 03:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 37
> 	Bus: primary=03, secondary=09, subordinate=09, sec-latency=0
> 	I/O behind bridge: 0000b000-0000bfff [size=4K]
> 	Memory behind bridge: d0300000-d03fffff [size=1M]
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
> 
> 
> ==> 6_2_running_vm_rtl <==  
> + cat /sys/bus/pci/devices/0000:03:05.0/power_state
> D0
> + cat /sys/bus/pci/devices/0000:03:05.0/power/runtime_status
> active
> + cat /sys/bus/pci/devices/0000:03:05.0/power/control
> auto
> + cat /sys/bus/pci/devices/0000:09:00.0/power_state
> D0
> + cat /sys/bus/pci/devices/0000:09:00.0/power/runtime_status
> active
> + cat /sys/bus/pci/devices/0000:09:00.0/power/control
> auto
> + lspci -vvv -s 0000:03:05.0
> 03:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 37
> 	Bus: primary=03, secondary=09, subordinate=09, sec-latency=0
> 	I/O behind bridge: 0000b000-0000bfff [size=4K]
> 	Memory behind bridge: d0300000-d03fffff [size=1M]
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff [disabled]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
> 
> 
> > It's possible the switch has a problem with D3hot support and it may
> > need to be disabled or augmented with a PCI quirk.  In addition to
> > investigating what power state the downstream port is achieving and
> > reporting lspci -vvv with and without disable_idle_d3, would you mind
> > reporting "lspci -nns 2:00.0" and "lspci -nns 3:" to report all the
> > vendor and device IDs of the switch.  Thanks,
> >   
> 
> It seems that way, especially after manually preventing the root port
> for the graphics card from entering D3hot, however the one for the NIC
> seems to be doing that just fine, which makes things more confusing.

Yes, the fact that the NIC works suggests there's not simply a blatant
chip defect where we should blindly disable D3 power state support for
this downstream port.  I'm also not seeing any difference in the
downstream port configuration between the VM running after the port has
resumed from D3hot and the case where the port never entered D3hot.

But it suddenly dawns on me that you're assigning a Radeon HD 7790,
which is one of the many AMD GPUs which is plagued by reset problems.
I wonder if that's a factor there.  This particular GPU even has
special handling in QEMU to try to manually reset the device, and which
likely has never been tested since adding runtime power management
support.  In fact, I'm surprised anyone is doing regular device
assignment with an HD 7790 and considers it a normal, acceptable
experience even with the QEMU workarounds.

I certainly wouldn't feel comfortable proposing a quirk for the
downstream port to disable D3hot for an issue only seen when assigning
a device with such a nefarious background relative to device
assignment.  It does however seem like there are sufficient options in
place to work around the issue, either disabling power management at
the vfio-pci driver, or specifically for the downstream port via sysfs.
I don't really have any better suggestions given our limited ability to
test and highly suspect target device.  Any other ideas, Abhishek?
Thanks,

Alex


> $ lspci -nns 2:00.0
> 02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse Switch Upstream [1022:57ad]
> 
> $ lspci -nns 3:
> 03:01.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
> 03:02.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
> 03:03.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
> 03:05.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
> 03:06.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a3]
> 03:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]
> 03:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]
> 03:0a.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge [1022:57a4]
> 
> And the information for the PCIe port:
> 
> ==> 6_2_before_vm <==  
> + cat /sys/bus/pci/devices/0000:03:02.0/power_state
> D3hot
> + cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
> suspended
> + cat /sys/bus/pci/devices/0000:03:02.0/power/control
> auto
> + lspci -vvv -s 0000:03:02.0
> 03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 35
> 	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff [size=4K]
> 	Memory behind bridge: d0100000-d01fffff [size=1M]
> 	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [50] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
> 	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 512 bytes, PhantFunc 0
> 			ExtTag+ RBE+
> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
> 			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
> 		LnkCtl:	ASPM Disabled; Disabled- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
> 			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
> 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
> 			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
> 			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
> 			 FRS-, ARIFwd-
> 			 AtomicOpsCap: Routing-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
> 			 AtomicOpsCtl: EgressBlck-
> 		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
> 			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
> 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 		Address: 00000000fee00000  Data: 0000
> 	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
> 	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
> 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
> 	Capabilities: [150 v2] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> 		HeaderLog: 00000000 00000000 00000000 00000000
> 	Capabilities: [270 v1] Secondary PCI Express
> 		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
> 		LaneErrStat: LaneErr at lane: 0 1 2 3
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 	Capabilities: [370 v1] L1 PM Substates
> 		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
> 		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
> 		L1SubCtl2:
> 	Capabilities: [400 v1] Data Link Feature <?>
> 	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
> 	Capabilities: [440 v1] Lane Margining at the Receiver <?>
> 	Kernel driver in use: pcieport
> 
> 
> ==> 6_2_running_vm <==  
> + cat /sys/bus/pci/devices/0000:03:02.0/power_state
> D0
> + cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
> active
> + cat /sys/bus/pci/devices/0000:03:02.0/power/control
> auto
> + lspci -vvv -s 0000:03:02.0
> 03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 35
> 	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff [size=4K]
> 	Memory behind bridge: d0100000-d01fffff [size=1M]
> 	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [50] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 512 bytes, PhantFunc 0
> 			ExtTag+ RBE+
> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
> 			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
> 		LnkCtl:	ASPM Disabled; Disabled- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
> 			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
> 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
> 			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
> 			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
> 			 FRS-, ARIFwd-
> 			 AtomicOpsCap: Routing-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
> 			 AtomicOpsCtl: EgressBlck-
> 		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
> 			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
> 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 		Address: 00000000fee00000  Data: 0000
> 	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
> 	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
> 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
> 	Capabilities: [150 v2] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> 		HeaderLog: 00000000 00000000 00000000 00000000
> 	Capabilities: [270 v1] Secondary PCI Express
> 		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
> 		LaneErrStat: LaneErr at lane: 0 1 2 3
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 	Capabilities: [370 v1] L1 PM Substates
> 		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
> 		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
> 		L1SubCtl2:
> 	Capabilities: [400 v1] Data Link Feature <?>
> 	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
> 	Capabilities: [440 v1] Lane Margining at the Receiver <?>
> 	Kernel driver in use: pcieport
> 
> 
> ==> 6_2_before_vm_disable_d3_idle <==  
> + cat /sys/bus/pci/devices/0000:03:02.0/power_state
> D0
> + cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
> active
> + cat /sys/bus/pci/devices/0000:03:02.0/power/control
> auto
> + lspci -vvv -s 0000:03:02.0
> 03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 35
> 	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff [size=4K]
> 	Memory behind bridge: d0100000-d01fffff [size=1M]
> 	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [50] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 512 bytes, PhantFunc 0
> 			ExtTag+ RBE+
> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
> 			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
> 		LnkCtl:	ASPM Disabled; Disabled- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
> 			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
> 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
> 			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
> 			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
> 			 FRS-, ARIFwd-
> 			 AtomicOpsCap: Routing-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
> 			 AtomicOpsCtl: EgressBlck-
> 		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
> 			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
> 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 		Address: 00000000fee00000  Data: 0000
> 	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
> 	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
> 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
> 	Capabilities: [150 v2] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> 		HeaderLog: 00000000 00000000 00000000 00000000
> 	Capabilities: [270 v1] Secondary PCI Express
> 		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
> 		LaneErrStat: LaneErr at lane: 0 1 2 3
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 	Capabilities: [370 v1] L1 PM Substates
> 		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
> 		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
> 		L1SubCtl2:
> 	Capabilities: [400 v1] Data Link Feature <?>
> 	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
> 	Capabilities: [440 v1] Lane Margining at the Receiver <?>
> 	Kernel driver in use: pcieport
> 
> 
> ==> 6_2_running_vm_disable_d3_idle <==  
> + cat /sys/bus/pci/devices/0000:03:02.0/power_state
> D0
> + cat /sys/bus/pci/devices/0000:03:02.0/power/runtime_status
> active
> + cat /sys/bus/pci/devices/0000:03:02.0/power/control
> auto
> + lspci -vvv -s 0000:03:02.0
> 03:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Matisse PCIe GPP Bridge (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin ? routed to IRQ 35
> 	Bus: primary=03, secondary=06, subordinate=06, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff [size=4K]
> 	Memory behind bridge: d0100000-d01fffff [size=1M]
> 	Prefetchable memory behind bridge: 0000001030000000-0000001047ffffff [size=384M]
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: [50] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [58] Express (v2) Downstream Port (Slot+), MSI 00
> 		DevCap:	MaxPayload 512 bytes, PhantFunc 0
> 			ExtTag+ RBE+
> 		DevCtl:	CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> 			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
> 		LnkCap:	Port #2, Speed 16GT/s, Width x4, ASPM L1, Exit Latency L1 <32us
> 			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
> 		LnkCtl:	ASPM Disabled; Disabled- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 8GT/s (downgraded), Width x4 (ok)
> 			TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt+
> 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
> 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
> 			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
> 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, NROPrPrP-, LTR+
> 			 10BitTagComp-, 10BitTagReq-, OBFF Not Supported, ExtFmt-, EETLPPrefix-
> 			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
> 			 FRS-, ARIFwd-
> 			 AtomicOpsCap: Routing-
> 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
> 			 AtomicOpsCtl: EgressBlck-
> 		LnkCtl2: Target Link Speed: 16GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
> 			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
> 			 Compliance De-emphasis: -6dB
> 		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete+, EqualizationPhase1+
> 			 EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
> 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 		Address: 00000000fee00000  Data: 0000
> 	Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Matisse PCIe GPP Bridge
> 	Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
> 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
> 	Capabilities: [150 v2] Advanced Error Reporting
> 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr-
> 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
> 		AERCap:	First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
> 			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> 		HeaderLog: 00000000 00000000 00000000 00000000
> 	Capabilities: [270 v1] Secondary PCI Express
> 		LnkCtl3: LnkEquIntrruptEn-, PerformEqu-
> 		LaneErrStat: LaneErr at lane: 0 1 2 3
> 	Capabilities: [2a0 v1] Access Control Services
> 		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
> 		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 	Capabilities: [370 v1] L1 PM Substates
> 		L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- ASPM_L1.1+ L1_PM_Substates+
> 		L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
> 		L1SubCtl2:
> 	Capabilities: [400 v1] Data Link Feature <?>
> 	Capabilities: [410 v1] Physical Layer 16.0 GT/s <?>
> 	Capabilities: [440 v1] Lane Margining at the Receiver <?>
> 	Kernel driver in use: pcieport
> 
> 
> --
> Tasos
> 

