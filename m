Return-Path: <kvm+bounces-52932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC39B0AB71
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 23:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A13095C0218
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 21:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0051E21D5BB;
	Fri, 18 Jul 2025 21:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YstQ7PzF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E821D5B0
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752874185; cv=none; b=i526yjEkJqrLpTBNXuHPlMO4FxX1Apl5leoHoopiMDRqy1lMGCaVb25DLaIoUXn04HN8bkoyDPUyUZWO02pf+84jMLgsjWkiZExC9OMG1DSI8XMYOU7vHIX9zjbIZZCVHOcCIE42VIIwr6CJTEKFe7bxM5dLiabD1shm5HfuwCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752874185; c=relaxed/simple;
	bh=qqIUQ9QIcZhmGXl17HdzCq7eHSn5RW4buAwRdLV5Ez8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjZoNv7PJ929aahVd1TgCspP/6GAgw8u5lGdYKj2/OHZkT+kbFdFr48JuUMOtsZQz6cZqU+rlrGJ1CAaZlp9dx8EocKHuQrkS+L8fL3ienM8O04Lc+Hug1CReS22hHsA/rLFfaVVa0rTXsnu+XCG46fXIj20g/SHM/gYB0vaWCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YstQ7PzF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752874181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MrWlbpRkRAWEEZSZUXR7gkDwQXPo2XGHR6bPglMnBt8=;
	b=YstQ7PzF9Jn9hJwbQ48MUQXyAajxCOTN0xjxNbBIRw2pszpK+4PxREYf9Pe0c7WzBBtQHz
	ZnljVctaoH2hKFv3p+E0pivXdcSvuZ6QFSKNnnighHbzne/03MDKeoX6Ya7jJk9Yq9cTRm
	26XRO0u4NRLD7zhpGQC65rrs+PF5Juc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-0ePfiIZJMZuOxbdQZgr_Hg-1; Fri, 18 Jul 2025 17:29:39 -0400
X-MC-Unique: 0ePfiIZJMZuOxbdQZgr_Hg-1
X-Mimecast-MFC-AGG-ID: 0ePfiIZJMZuOxbdQZgr_Hg_1752874179
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3df410b6753so3881235ab.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752874179; x=1753478979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrWlbpRkRAWEEZSZUXR7gkDwQXPo2XGHR6bPglMnBt8=;
        b=CBr86JWnHQp83MHLICH5ClPzYq30wnZ9+mikI/Puy4GrXml5DmoXMiMLDrwHqOoazU
         C/8HAyN/wREvILEIrmbF7sXQyHutEkcV44PS8OT5Nggn/mt8bLwk0ibbgsGFl9AS2mmk
         8uxwYofGmxZl/hZ+R3Q+VqwdNYG4nCxT59fPXM6oCRLsayl0nJbjfOpYlNpA+n4pNldy
         I6B/oYSO2xHwP3Qjvod34nhAjl7bVRPRBWQ3vS2YWHMGnuGlHSivxmwBVC27zBGj8cyV
         e1S9zK3dK5P9Q8erQrzNDMkYmxdiFR/PCAfoeDBb8HiDGUgP2eEKa1iDR4ofZslUeHzN
         dRSA==
X-Forwarded-Encrypted: i=1; AJvYcCX/ooVMf01HTTJgbKzwfiCpAiE2j3ovd+N122aWbt8RQZK/UuwCti03llRXZIX+LvaCKtk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQ+u0e23MV4pAE1h55BZfbiDtcV1hymQofkOjBt8sXHilXArL
	Md8/ngry/ggPUYR8mqi/DmrWxXQCrnZeExJJQK3CCqFSDP1pcYMEp81Lgg0ZwkZ2IshrWvzCKiT
	PYKjM69Vz/bc2Tztob0hQo5rH2y3R5IwOBKf2Ry/QdnjMsYsXeLsZ/A==
X-Gm-Gg: ASbGncvypS+Z4tT/DS4nVuvGtWzdCePqTV4IiHCnydGmDVUedT3Xu6lePjra9wRo2LA
	+C9foSzFR+VPFkk1K4BqrNrcYFDSFTpB2cy2WpmdNxXzkGgpL2Y+OPYcLD7LKuIU2qZ+gdetrl8
	JadHXQqUngl2mWqLRlNsKEhOfzu4a8ow+65FvgK/wTgnk+QXGUSDO0lMLWOiRvdZIzSTXQs7WxK
	Dsk7D5+8fVCeQdhvacfjjSuOqkm24MQ8N6eZ5XRCQP+9TR69R5rVrXxkxFT5Qf34aFXEJaIlcVh
	vCiCLrIAAz3KpsjwCIShMe+EJI6eaO5PbnIF5PXFQR8=
X-Received: by 2002:a05:6e02:3e03:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e2822ea512mr31320105ab.2.1752874178355;
        Fri, 18 Jul 2025 14:29:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsXml8xvO+E+R9hAay3c6AEsvzRM4HktRe693pIg5RRbn8ITcNmOIWJ6JbB3lZ/WFgJul1Sw==
X-Received: by 2002:a05:6e02:3e03:b0:3dd:c927:3b4f with SMTP id e9e14a558f8ab-3e2822ea512mr31319925ab.2.1752874177726;
        Fri, 18 Jul 2025 14:29:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca6314csm512735173.125.2025.07.18.14.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 14:29:36 -0700 (PDT)
Date: Fri, 18 Jul 2025 15:29:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH v2 00/16] Fix incorrect iommu_groups with PCIe ACS
Message-ID: <20250718152934.0cdb768f.alex.williamson@redhat.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Jul 2025 11:52:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The series patches have extensive descriptions as to the problem and
> solution, but in short the ACS flags are not analyzed according to the
> spec to form the iommu_groups that VFIO is expecting for security.
> 
> ACS is an egress control only. For a path the ACS flags on each hop only
> effect what other devices the TLP is allowed to reach. It does not prevent
> other devices from reaching into this path.
> 
> For VFIO if device A is permitted to access device B's MMIO then A and B
> must be grouped together. This says that even if a path has isolating ACS
> flags on each hop, off-path devices with non-isolating ACS can still reach
> into that path and must be grouped gother.
> 
> For switches, a PCIe topology like:
> 
>                                -- DSP 02:00.0 -> End Point A
>  Root 00:00.0 -> USP 01:00.0 --|
>                                -- DSP 02:03.0 -> End Point B
> 
> Will generate unique single device groups for every device even if ACS is
> not enabled on the two DSP ports. It should at least group A/B together
> because no ACS means A can reach the MMIO of B. This is a serious failure
> for the VFIO security model.
> 
> For multi-function-devices, a PCIe topology like:
> 
>                   -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>   Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>                   |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> Will group [1f.0, 1f.2] and 1f.6 gets a single device group. In many cases
> we suspect that the MFD actually doesn't need ACS, so this is probably not
> as important a security failure, but from a spec perspective the correct
> answer is one group of [1f.0, 1f.2, 1f.6] beacuse 1f.0/2 have no ACS
> preventing them from reaching the MMIO of 1f.6.

This will break various LOM configurations where the NIC is a function
within a MFD RCiEP which has or quirks ACS while the other functions
have no ACS.

> There is also some confusing spec language about how ACS and SRIOV works
> which this series does not address.
> 
> This entire series goes further and makes some additional improvements to
> the ACS validation found while studying this problem. The groups around a
> PCIe to PCI bridge are shrunk to not include the PCIe bridge.
> 
> The last patches implement "ACS Enhanced" on top of it. Due to how ACS
> Enhanced was defined as a non-backward compatible feature it is important
> to get SW support out there.
> 
> Due to the potential of iommu_groups becoming winder and thus non-usable
> for VFIO this should go to a linux-next tree to give it some more
> exposure.
> 
> I have now tested this a few systems I could get:
> 
>  - Various Intel client systems:
>    * Raptor Lake, with VMD enabled and using the real_dev mechanism
>    * 6/7th generation 100 Series/C320
>    * 5/6th generation 100 Series/C320 with a NIC MFD quirk
>    * Tiger Lake
>    * 5/6th generation Sunrise Point
>   No change in grouping on any of these systems

Sorry I haven't had much time to look at this, but it would still cause
a regression on my AlderLake system.  I get the following new
mega-group:

IOMMU Group 12:
	0000:00:1c.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #1 [8086:7a38] (rev 11)
		Express Root Port (Slot+)
	0000:00:1c.1 PCI bridge [0604]: Intel Corporation Device [8086:7a39] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.2 PCI bridge [0604]: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 [8086:7a3a] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #4 [8086:7a3b] (rev 11)
		Express Root Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.1/06:00.0 USB controller [0c03]: Fresco Logic FL1100 USB 3.0 Host Controller [1b73:1100] (rev 10)
		Express Endpoint
	0000:00:1c.2/07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 05)
		Express Endpoint
	0000:00:1c.3/08:00.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Upstream Port
	0000:00:1c.3/08:00.0/09:01.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot-)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:02.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot+)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:03.0 PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EL/SL PCIe2 4-Port/4-Lane Packet Switch [12d8:2404] (rev 05)
		Express Downstream Port (Slot-)
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl+ DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
	0000:00:1c.3/08:00.0/09:01.0/0a:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 07)
		Express Endpoint
	0000:00:1c.3/08:00.0/09:03.0/0c:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8211/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 07)
		Express Endpoint

The source of the issue is the root port at 00:1c.0, which does not
have ACS support, claims that it has a slot but there is none, and
therefore has no subordinate DMA capable devices, nor does the root
port itself have an MMIO BAR.  I don't know if there's something we can
key on for the root port to mark it isolated.

00:1c.0 PCI bridge [0604]: Intel Corporation Raptor Lake PCI Express Root Port #1 [8086:7a38] (rev 11) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 125
	IOMMU group: 12
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 6000-6fff [size=4K] [16-bit]
	Memory behind bridge: 40800000-411fffff [size=10M] [32-bit]
	Prefetchable memory behind bridge: 60e0000000-60e09fffff [size=10M] [32-bit]
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- VGA16+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), IntMsgNum 0
		DevCap:	MaxPayload 256 bytes, PhantFunc 0
			ExtTag- RBE+ TEE-IO-
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 256 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 8GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes, LnkDisable- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt+ AutBWInt+
		LnkSta:	Speed 2.5GT/s, Width x0
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg+
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCap: CRSVisible-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR+
			 10BitTagComp- 10BitTagReq- OBFF Via WAKE#, ExtFmt+ EETLPPrefix+, MaxEETLPPrefixes 2
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS- LN System CLS Not Supported, TPHComp- ExtTPHComp- ARIFwd+
			 AtomicOpsCap: Routing- 32bit- 64bit- 128bitCAS-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
			 AtomicOpsCtl: ReqEn- EgressBlck-
			 IDOReq- IDOCompl- LTR+ EmergencyPowerReductionReq-
			 10BitTagReq- OBFF Disabled, EETLPPrefixBlk-
		LnkCap2: Supported Link Speeds: 2.5-8GT/s, Crosslink- Retimer+ 2Retimers+ DRS-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete- EqualizationPhase1-
			 EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
			 Retimer- 2Retimers- CrosslinkRes: unsupported
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee002b8  Data: 0000
	Capabilities: [90] Null
	Kernel driver in use: pcieport

This is seen on a Gigabyte B760M DS3H DDR4 motherboard.  There's a
version of this board with wifi whereas this one has empty pads where
that m.2 slot might go.  I'd guess wifi might sit downstream of this
port if it were present, but I don't know how it'd change the feature
set of the root port.  The populated root ports show a more reasonable
set of capabilities:

00:1c.1 PCI bridge [0604]: Intel Corporation Device [8086:7a39] (rev 11) (prog-if 00 [Normal decode])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
	Flags: bus master, fast devsel, latency 0, IRQ 126, IOMMU group 12
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: [disabled] [16-bit]
	Memory behind bridge: 41800000-419fffff [size=2M] [32-bit]
	Prefetchable memory behind bridge: [disabled] [64-bit]
	Capabilities: [40] Express Root Port (Slot+), IntMsgNum 0
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [98] Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
	Capabilities: [a0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [220] Access Control Services
	Capabilities: [200] L1 PM Substates
	Capabilities: [150] Precision Time Measurement
	Capabilities: [a30] Secondary PCI Express
	Capabilities: [a90] Data Link Feature <?>
	Kernel driver in use: pcieport

I can't say that the proposed code here is doing the wrong thing by
propagating the lack of isolation, but it's gratuitous when there is no
DMA initiator on the non-isolated branch and it causes a significant
usage problem for vfio.  Thanks,

Alex


