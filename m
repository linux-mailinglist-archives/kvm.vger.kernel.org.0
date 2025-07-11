Return-Path: <kvm+bounces-52180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A126B020A0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E77DC7BC24D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28D82ED85D;
	Fri, 11 Jul 2025 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJdvujcp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE3E2ECE9F
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752248429; cv=none; b=UOWqhjJgOxSgY5iaiICWUljG090SQr4cHn7p9wA4f918w79MAGKhMfelTUVKdFnHh1vP4aouE62oI4MEOfDTPKU0Wter+iw+Ra6z8yK9fvkJwnJvzENOJaA2K2/hcYi7XZLxADj7xJy1LiX/41MGqIEJzqE4ZvgW95co0BCBdcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752248429; c=relaxed/simple;
	bh=cRSEYeAZQIo3llsEJyfAYMMwsDk6fdhA/0tgZ9rZxlg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aozcnnC0LjTugBWmuTXA74OkURnnpPKmnLG07BV7W7UWzN6FU34cX7USypCnZWhmEVOTBd+HK8eHc2ens926QNqw25ET5ws0zcw6tVBZFzfn1YoiqzObv2szC7WT29eYvosGk6lQ4dZU1/qOhxNYXl6o7bqVxZ5KJUL/YRsbUIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJdvujcp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752248427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cYYFL7iSZ/ER1ZVOlySXlTIkEzpjXHGgym0ucB+NEiw=;
	b=GJdvujcp1biv4QjKYLpE9kAiMCCAK5GI772c/FnYHG9lEZ3C8Hp3K3P83WrWSn9quNUOdB
	snLg+XKpJMD4oPvUSEM6lfdLQoWeA88aYUuWy+BQXpNmM9bbFCSHNRb9RapIvd1WiLnUmJ
	WBCMIJ7/INuAIH5eo3QZnCnkqCZD2sY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-txrhAXzUOT24OZkZ5GHl8w-1; Fri, 11 Jul 2025 11:40:25 -0400
X-MC-Unique: txrhAXzUOT24OZkZ5GHl8w-1
X-Mimecast-MFC-AGG-ID: txrhAXzUOT24OZkZ5GHl8w_1752248425
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86cf14fd106so49980239f.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752248425; x=1752853225;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cYYFL7iSZ/ER1ZVOlySXlTIkEzpjXHGgym0ucB+NEiw=;
        b=e0kwHjrt2SV+6RFlOZ+JWQ1haVUbTfUAajVLsBkvcwIJY/hN30Kx6krwtgVs8AlppA
         9nuRG+aO13GmDEMVv0j/mFU2la+z61mhST7SlxKyMnt3tQOmw+OEU5snc5fQWkZucK0J
         51F3s67wdGH5tbaPUgYwKC5ym6OtwVROsJLjOZ9HBoFkJZ74w7je8FMync7hiNKdXX5P
         65GeSfK1KF9jGYywZXTT/SekLDd8Zz9DfvgNftWeisl6PSfbZnNQOwJLh5ohE/P6OBxs
         JUeHUcZUzNQD5q0wLxdj1O3EFybyc02sXCj8X4kPf0R4tEpdUfvvg5+4b+LDB7LqZqmt
         XKrA==
X-Forwarded-Encrypted: i=1; AJvYcCVz70UBbfxdVivKrPtZ5nNAxhvfzuVbJ46QDt0vf/MeROpTtN22MukuIWIrNGtMjEkvlfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybQfQihxaJ/fqUeNaeTezS70KiMOurmeVI0ht0YFz3SmUeAZr3
	90I10M9zZDqCyf7cTGaphPXJpUH7RFZ2pLVUdvr7qi9CYwAeFPUA41YSWUtULw3apksTvaFA/Cb
	75w/bxaGnn/5dkiRwkmbYCObYaq0WS3AfZ7qD4lx395Dl/6x+sWwCeQ==
X-Gm-Gg: ASbGncuy2GH/dUEQVfSFrStZ22raEURE9BfKqkUWiO0wF6NbRlhblx/Owm4Z9ufRU6P
	gswopyJka56wESPRtdcF3yTn48KCVi42YlYlY1WEdJqSm6Je2Bqr/BZmeel92c9pYC1DjA5Hdvq
	HgBnat3q9V1H1Is52pdIX0HfIdXuPEFx59yDrXwuhpdkfKwzCwyqH8CPxmjyKaU6s1u5Xvsa8iD
	nRdgLruRcAl0GKGZai3EjcFjdA5GDVWxUmRb4EMOkHzwF/o/np4px3qb8Aq0Zty3l5cEs/v8d0D
	E11KmSD2bvF4Il0t9Q6wH3w8t+JdK+K/1XON4M/1ovs=
X-Received: by 2002:a05:6602:2cc2:b0:876:97b0:937b with SMTP id ca18e2360f4ac-87979228fb2mr95698939f.3.1752248424006;
        Fri, 11 Jul 2025 08:40:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHVY5rBGhqRO5sp2SLT2myg1EFX29cpDhlYNuKxgTlHNrK/eYcqxX7DYKWsncg808ZpGBEWg==
X-Received: by 2002:a05:6602:2cc2:b0:876:97b0:937b with SMTP id ca18e2360f4ac-87979228fb2mr95697739f.3.1752248423477;
        Fri, 11 Jul 2025 08:40:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796b8c46f9sm107447039f.8.2025.07.11.08.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 08:40:22 -0700 (PDT)
Date: Fri, 11 Jul 2025 09:40:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, linux-pci@vger.kernel.org, Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
 <baolu.lu@linux.intel.com>, galshalom@nvidia.com, Joerg Roedel
 <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 maorg@nvidia.com, patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu
 <tony.zhu@intel.com>
Subject: Re: [PATCH 00/11] Fix incorrect iommu_groups with PCIe switches
Message-ID: <20250711094020.697678fc.alex.williamson@redhat.com>
In-Reply-To: <20250708204715.GA1599700@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701154826.75a7aba6.alex.williamson@redhat.com>
	<20250708204715.GA1599700@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 8 Jul 2025 17:47:15 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 01, 2025 at 03:48:26PM -0600, Alex Williamson wrote:
> 
> > Notably, each case where there's a dummy host bridge followed by some
> > number of additional functions (ie. 01.0, 02.0, 03.0, 08.0), that dummy
> > host bridge is tainting the function isolation and merging the group.
> > For instance each of these were previously a separate group and are now
> > combined into one group.  
> 
> I was able to run some testing on a Milan system that seems similar.
> 
> It has the weird "Dummy Host Bridge" MFD. I fixed it with this:
> 
> /*
>  * For some reason AMD likes to put "dummy functions" in their PCI hierarchy as
>  * part of a multi function device. These are notable because they can't do
>  * anything. No BARs and no downstream bus. Since they cannot accept P2P or
>  * initiate any MMIO we consider them to be isolated from the rest of MFD. Since
>  * they often accompany a real PCI bridge with downstream devices it is
>  * important that the MFD be isolated. Annoyingly there is no ACS capability
>  * reported we have to special case it.
>  */
> static bool pci_dummy_function(struct pci_dev *pdev)
> {
> 	if (pdev->class >> 8 == PCI_CLASS_BRIDGE_HOST && !pci_has_mmio(pdev))
> 		return true;
> 	return false;
> }

Yeah, that might work since it does report itself as a host bridge.
Probably noteworthy that you'd end up catching the Intel host bridge
with this too.
 
> This AMD system has second weirdness:
> 
> 40:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
>         Capabilities: [2a0 v1] Access Control Services
>                 ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
>                 ACSCtl: SrcValid- TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 40:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
>         Capabilities: [2a0 v1] Access Control Services
>                 ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
>                 ACSCtl: SrcValid- TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 40:01.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge (prog-if 00 [Normal decode])
>         Capabilities: [2a0 v1] Access Control Services
>                 ACSCap: SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
>                 ACSCtl: SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-
> 
> Notice the SrcValid- 
> 
> The kernel definately set SrcValid+, the device stored it, and it
> never set SrcValid-, yet somehow it got changed:
> 
> [    0.483828] pci 0000:40:01.1: pci_enable_acs:1089
> [    0.483828] pci 0000:40:01.1: pci_write_config_word:604 9 678 = 1d
> [    0.483831] pci 0000:40:01.1: ACS Set to 1d, readback=1d
> [..]
> [    0.826514] pci 0000:40:01.1: __pci_device_group:1635 Starting
> [    0.826517] pci 0000:40:01.1: pci_acs_flags_enabled:3668   ctrl=1c acs_flags=1d cap=5f
> 
> I instrumented pci_write_config_word() and it isn't being called a
> second time. I didn't try to narrow this down, too weird. Guessing
> ACPI or FW?
> 
> So the new logic puts all the above and the downstream into group due
> to insuffucient isolation which is the only degredation on this
> system, the LOM ethernet gets grouped together with the above MFD.
> 
> Given in this case we explicitly have ACS flags we consider
> non-isolated I'm not sure there is anything to be done about it.
> 
> Which raises a question if SrcValid should be part of grouping or not,
> it is more of a security enhancement, it doesn't permit/deny P2P
> between devices?

Strange issue.  If a device can spoof a RID then it can theoretically
inject a DMA payload as if it were another device.  That seems like
basic security, not just an enhancement.
 
> > The endpoints result in equivalent grouping, but this is a case where I
> > don't understand how we have non-isolated functions yet isolated
> > subordinate buses.  
> 
> And I fixed this too, as above is showing, by marking the group of the
> MFD as non-isolated, thus forcing it to propogate downstream.
> 
> > An Alder Lake system shows something similar:  
> 
> I also tested a bunch of Intel client systems. Some with an ACS quirk
> and one with the VMD/non transparent bridge setup. Those had no
> grouping changes, but no raptor lake in this group.
> 
> > # lspci -vvvs 1c. | grep -e ^0 -e "Access Control Services"
> > 00:1c.0 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #1 (rev 11) (prog-if 00 [Normal decode])
> > 00:1c.1 PCI bridge: Intel Corporation Device 7a39 (rev 11) (prog-if 00 [Normal decode])
> > 	Capabilities: [220 v1] Access Control Services
> > 00:1c.2 PCI bridge: Intel Corporation Raptor Point-S PCH - PCI Express Root Port 3 (rev 11) (prog-if 00 [Normal decode])
> > 	Capabilities: [220 v1] Access Control Services
> > 00:1c.3 PCI bridge: Intel Corporation Raptor Lake PCI Express Root Port #4 (rev 11) (prog-if 00 [Normal decode])
> > 	Capabilities: [220 v1] Access Control Services
> > 
> > So again the group is tainted by a device that cannot generate DMA,   
> 
> It looks like 00:1c.0 is advertised as a root port, so it can generate
> DMA as part of its root port function bridging to something outside
> the root complex.
> 
> This system doesn't seem to have anything downstream of that root port
> (currently plugged in?), but IMHO that port should have ACS. By spec I
> think it is correct to assume that without ACS traffic from downstream
> of the root port would be able to follow the internal loopback of the
> MFD.
> 
> This will probably need a quirk, and it is different from the AMD case
> which used a host bridge..
> 
> Any other idea?

This root port at 1c.0 does look like it could have a subordinate
device, but there is no unpopulated slot/socket on this motherboard.
Possibly another motherboard SKU could use these links for a wifi card.
Versus the other root ports, it lacks routing of its interrupt line, it
does have a secondary bus and apertures assigned, it has a PCIe
capability that claims it has a slot (LnkCap 8GT/s x1), it has an MSI
capability and a NULL capability, no extended config space.  I'm not
sure if this vendor (Gigabyte) is unique in incompletely stubbing out
this link or if this is par for the course.

Again, it should be perfectly safe to assign things downstream of the
ACS isolated root ports in the MFD to userspace drivers, their egress
DMA is isolated.  It would only be ingress from an endpoint that seems
like it cannot exist that would be troublesome.  I don't have a good
solution.  Thanks,

Alex


