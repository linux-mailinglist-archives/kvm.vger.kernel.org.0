Return-Path: <kvm+bounces-52177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CF7B01FE0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CE66B4015D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6C02EA495;
	Fri, 11 Jul 2025 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5bNLI71"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF1A2E9EAF
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245713; cv=none; b=C6gZDaizFIN6qyeeBCiFffTng3AFAgPyPtRMl/W4rsV3syv6Zb9fFb1kPlc8bSgpL72s/3pV/lGqDml+oP85WmG+Gx7F4ABmv2QSo++y6+1gQmpnmA+5jQ6MVpkebG0Ml7crhj/YI2HICBYyA/T5+e01y+4KqWLA6Qfi66o8prQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245713; c=relaxed/simple;
	bh=3rYV+q8dro8J8VmX9J9011omILzulSyiYxKai8MXQ6c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4Q8+2HdAJkGpbzWxE1q8IFCWmcRXC0BUGTPRfA9gA7lUk552Zmu5uOsMLpE7WiV6OKZx9eoVvmiftyGQBcLIks1ltJCmSwctz5EclbJVI8MZv8zoypQ3ZeA5XjQYVG0HIhHysqgK+lj65IHxgl+tlomhMcGLzM+VjOVzjaHHtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5bNLI71; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752245711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ta4WBHEbbLvWrSbuIq4BWMmcEk+1DQi+vz9sFGyVfUo=;
	b=Q5bNLI719wM/5Dbdgml0nTSTRVwvdrPomGYe1z+YZHFw0V1yVYcrIo0bop99co8sqm4roZ
	v5sWeHdJx1uen8bFrJ++q0YWgxZ0RjCeE0bRI4kMZkf1DCYuMFGH+v0NP//NQxp4i1DsST
	Zg/rsPUPrRA6o6pkt9n5CLuj7M2n87Y=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-5sCJqtqEO3-YbwhMSlipHw-1; Fri, 11 Jul 2025 10:55:09 -0400
X-MC-Unique: 5sCJqtqEO3-YbwhMSlipHw-1
X-Mimecast-MFC-AGG-ID: 5sCJqtqEO3-YbwhMSlipHw_1752245709
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8796b8132d8so24303439f.1
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752245709; x=1752850509;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ta4WBHEbbLvWrSbuIq4BWMmcEk+1DQi+vz9sFGyVfUo=;
        b=owpf/4HmvFllXbUgyfkQrzytlkE177ocjW7ASGb9zT6GMMkgdhAfHO3hW8dRvMNdsy
         6eysjwA06m0RH0nNmPc7s3My/+Ue9M907OL0BkwNXCjHSjAdFPmfL4Kfva4xgzXq8wXK
         7UC4VgIBWNcuZRxuEZ8B5gA4oyGfQTbNCpYEKQlOEm8BXuyQbJpSAM0RxrvkZI0kX7e+
         FYvH/QJrcBwDUNmDjsrANOIp0HxPJ//xvFzkxJcNpUMVnJnKoAufnAn92wDn9hEc60Jw
         mFg/8R0lQbMfdRqKlnkVReK4xYjNuPfQFeiYwo4k4OqqJQWm2/KG2VXt9JDfzd1YVnrR
         51uA==
X-Forwarded-Encrypted: i=1; AJvYcCXIV9kGKsZLl9pdiZ2cnRQqxUSnkZm+vx1BT/so7nzfrvoDHh8LynZjCyCADxImMhsVPzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyZQxMekk3CSi9NRkwulWoWqvEQjuL3dYk99YbN7rJ0DvPdo92
	KZjMTt8W9MQhvHoIALjAI6P03nhCF4/Vq1TJmNoGuuyIycLYTEZH1+SeTKMZco96Rp7szCe7Mk0
	K6W3WxTK0VKkcqDKuIlpiF5sCU0rTfAnmmLooSki5LHvVDgcJ9aft/Q==
X-Gm-Gg: ASbGncu0qixJXzivw317fEBsDqwxEl1JlKD5uAO/nAgXtNn6duvO5JFEM/TIvynR2bb
	qO/jQnJGp6ijKWvX+CQNXaHSBgRFY6BR30vMwCjVmO/fNQySV4Xq/GL4ne0VJglEOYc//mRpg6a
	wlirnUh0w31zMtccE1nJfsxxmISiiGzOPGn3G/mHhl12gNfn4O8LbKEasoJCSnUQdz9NWGfQJ1S
	n4EtNoQ+rO3iQOBqx7CcrJRxyiGGqAyqeYbWB+4OOD41nRR7BxASFDbhLsmF+92rTlMuQrV02qQ
	0h/1KBsmK3hUnQ/ZTnl6Gm/p289iA7KvFZW1ALpiKQ8=
X-Received: by 2002:a05:6e02:2303:b0:3dd:ba33:be80 with SMTP id e9e14a558f8ab-3e25332249bmr11118015ab.4.1752245708724;
        Fri, 11 Jul 2025 07:55:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESAhokzcREM2efcYWg5taAtBEn6xjkoeFrQcvcZKKxKbXQ1sHV3AGxifcXnBRp6ucuzWJSdQ==
X-Received: by 2002:a05:6e02:2303:b0:3dd:ba33:be80 with SMTP id e9e14a558f8ab-3e25332249bmr11117875ab.4.1752245708161;
        Fri, 11 Jul 2025 07:55:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611e84asm12417435ab.15.2025.07.11.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 07:55:07 -0700 (PDT)
Date: Fri, 11 Jul 2025 08:55:04 -0600
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
Message-ID: <20250711085504.71e82a16.alex.williamson@redhat.com>
In-Reply-To: <20250704003709.GJ1209783@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701154826.75a7aba6.alex.williamson@redhat.com>
	<20250704003709.GJ1209783@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Jul 2025 21:37:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 01, 2025 at 03:48:26PM -0600, Alex Williamson wrote:
> 
> > 00:1c. are all grouped together.  Here 1c.0 does not report ACS, but
> > the other root ports do:  
> 
> I dug an older Intel system out of my closet and got it to run this
> kernel, it has another odd behavior, maybe related to what you are
> seeing..
> 
> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v6/7th Gen Core Processor Host Bridge/DRAM Registers (rev 05)
> 00:01.0 PCI bridge: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) (rev 05)
> 00:02.0 VGA compatible controller: Intel Corporation HD Graphics 630 (rev 04)
> 00:14.0 USB controller: Intel Corporation 100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller (rev 31)
> 00:14.2 Signal processing controller: Intel Corporation 100 Series/C230 Series Chipset Family Thermal Subsystem (rev 31)
> 00:16.0 Communication controller: Intel Corporation 100 Series/C230 Series Chipset Family MEI Controller #1 (rev 31)
> 00:17.0 SATA controller: Intel Corporation Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI Mode] (rev 31)
> 00:1b.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #17 (rev f1)
> 00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
> 00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
> 00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
> 00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
> 00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I219-LM (rev 31)
> 00:01.0/01:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
> 00:01.0/01:00.1 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
> 00:1b.0/02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller SM961/PM961/SM963
> 
> And here we are interested in this group:
> 
> 00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
> 00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
> 00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
> 00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
> 00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I219-LM (rev 31)
> 
> Which the current code puts into two groups
>   [00:1f.0 00:1f.2 00:1f.3 00:1f.4]
>   [00:1f.6]
> 
> While this series puts them all in one group.
> 
> No device in the MFD 00:1f has an ACS capability however only 00:1f.6 has a quirk:
> 
> 	{ PCI_VENDOR_ID_INTEL, 0x15b7, pci_quirk_mf_endpoint_acs },
> 	/*
> 	 * SV, TB, and UF are not relevant to multifunction endpoints.
> 	 *
> 	 * Multifunction devices are only required to implement RR, CR, and DT
> 	 * in their ACS capability if they support peer-to-peer transactions.
> 	 * Devices matching this quirk have been verified by the vendor to not
> 	 * perform peer-to-peer with other functions, allowing us to mask out
> 	 * these bits as if they were unimplemented in the ACS capability.
> 	 */
> 
> Giving these ACS results:
> 
> pci 0000:00:1f.0: pci_acs_enabled:3693   result=0 1d
> pci 0000:00:1f.2: pci_acs_enabled:3693   result=0 1d
> pci 0000:00:1f.3: pci_acs_enabled:3693   result=0 1d
> pci 0000:00:1f.4: pci_acs_enabled:3693   result=0 1d
> pci 0000:00:1f.6: pci_acs_enabled:3693   result=1 1d
> 
> Which shows the logic here:
> 
> static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
> 							unsigned long *devfns)
> {
> 	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
> 		return NULL;
> 
> Is causing the grouping difference. When it checks 00:1f.6 it sees
> pci_acs_enabled = true and then ignores the rest of the MFD.  This is
> basically part of my issue #2 that off-path ACS is not considered.
> 
> AFAIK ACS is a per-function egress property (eg it is why it is called
> the ACS Egress Vector). Meaning if 01f.4 sends a P2P DMA targetting
> MMIO in 1f.6 it is the ACS of 01f.4 as the egress that is responsible
> to block it. The ACS of 1f.6 as the ingress is not considered.
> 
> By our rules if 01f.4 can DMA into 01f.6 they should be in the same
> group.
> 
> I point to "Table 6-10 ACS P2P Request Redirect and ACS P2P Egress
> Control Interactions" as supporting this. None of these options are
> 'block incoming request' - they are all talking about how to route the
> original outgoing request.
> 
> So I think the above is a bug in the current kernel, the logic should
> require that all functions in the MFD have ACS on, otherwise they need
> to share a single group. It is what is implemented in this series, and
> I think it is why you saw other cases where a single bad ACS "spoils"
> the MFD?
> 
> It seems the qurking should have included all the functions in this
> MFD, not just the NIC.
> 
> Does this seem right to you?

Sorry, you hit me right before holiday and PTO here.  I agree that
we're currently looking at isolation primarily from an egress
perspective.  Unfortunately it's not always symmetric.  In your case
above, I think we'd consider it safe to assign 1f.6 to a userspace
driver because 1f.6 cannot generate DMA out of its isolation domain.
On the other hand, 1f.4 can theoretically DMA into 1f.6, so it would be
unwise to attach 1f.4 to a userspace driver.  In practice there's not
much utility in assigning 1f.4 to a userspace driver, it's generally
bound to a "trusted" kernel driver, so all is well.

If we say that 1f.4 taints the group, including 1f.6, I think we're
going to see a bunch of functional regressions for not much actual gain
in security.  Maybe we need some extension to the concept of groups to
represent the asymmetry.  Thanks,

Alex


