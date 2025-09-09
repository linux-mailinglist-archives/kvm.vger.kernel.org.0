Return-Path: <kvm+bounces-57037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25E86B4A07E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D06F61B253A9
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D8F2D879C;
	Tue,  9 Sep 2025 04:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGKJNYYF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D212D0605
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 04:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391006; cv=none; b=LiEN5jON7k2LBNxbQt42gMwxe5FNonBLSpvVaPhfG3rTOvHOLj7QnrltVf3dwh3UJpmZuMZTwBPtzflLXjqnop1rAdq9fgcPAj1V8gF0JNsD87PmFC36mqgb+fChvVNZcj+zf83lfxyeGwc+c+1jQeFW43x5o6kcCOOtwfFV9Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391006; c=relaxed/simple;
	bh=1onYyHC1u8u6j2lhsvIJ9+liID/czv3MUojWnztIh7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HuBt15jrvjUCWppO7BrWbrCSnAwaHikNcQUVRwkKm9w27PlMk8gMay5X5QhOaYwyFounpz6NreUQI16BzVfuLGnXplqoSSTvGkHZ8JCb0QkkoLQVSpoSP0ZJH1IM0GYW7Stm1N7CpUYQ9UL4kewXMFWotazX9vcvWlsqgs+jB4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGKJNYYF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757391002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G7ml4dhkBiVs++e+v/GVds/iqZ4PDwaGWIOeAtXIqEU=;
	b=JGKJNYYFfwLxN2d9M+AoEqo0OAolw8s9cU18Nl/XPKhoDLeycWfbyypL79HNYHD31RHJH9
	s3QQVt6lcTuWCXbo8IRVdt2VTV/TLqe+3xLhAtmrcbtiLnj/RTvm5nKylrqIxXBXReDdX6
	+6oW32wMRvRzKVd8Bzc7iJvSyfNTnnw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-8DN6fzUYPz-ZBzx0Va5gDQ-1; Tue, 09 Sep 2025 00:10:01 -0400
X-MC-Unique: 8DN6fzUYPz-ZBzx0Va5gDQ-1
X-Mimecast-MFC-AGG-ID: 8DN6fzUYPz-ZBzx0Va5gDQ_1757391000
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8080713fa17so1118455285a.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 21:10:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757391000; x=1757995800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G7ml4dhkBiVs++e+v/GVds/iqZ4PDwaGWIOeAtXIqEU=;
        b=vpS4sewAh/KS9FPtfeGJ5KdvIhpnigYMOu/CJTv+tJFKie3raSafqSYFvRUcJqxRuj
         b5r4I5E2t6JoN19cTq/m9ycCdmGhksSE23AtKYXOBNRT/agB13Nd/8xoANHGMW2q2SlJ
         DP19OUrbDKRlXvGZxPnxDC0fb3ftZnWU2vgekgPYBH12y50HWdGydqoEzpYf0MuX0icj
         Wxt9BedaIwL1K+jG+/fJu0IwhSTjpYDylBgpJuNiaznksYq93g1Net77qrEDF5LWYQSc
         bySzncOMTz8FN5+mzSUyZjopAq0LrvTWn9Io5pyTMzRVPuW8EU4cu4PCdmAXxS904Vqn
         0V3w==
X-Forwarded-Encrypted: i=1; AJvYcCV4iENNU64Mg9Bm2LB2BoUhVjnSGL8UcwxnY16ZF1UuzEUNpoxL13byrX97ripzQSmRnb8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6UDCz55M0dgjOo8ch2a0lJiuNvvTrcehF4bZROrCbyjuiqMUt
	HUPqmoTu3y+JuoHStxL6HGEIYqQnWHsE7nF7ddBmYVoHPS6gPy0WFaS50gfPx2+zuvlD7kq6dyy
	UcobIxMfxcWS+GYeUB9R1mPqLo455LrA0UDVHUh29oBwslLqS31EI2g==
X-Gm-Gg: ASbGncuEyfaEJhEVYoUOKgrV00VzpLPHR2TEkT+5CJgScEaqDbzsz4W+0A0rPyuGaqg
	kf3iAanMVtoGfIPoejcS8qKbrBw6Sptg4TQTvmkd2c7klkjiKfNXmFIQvfV1jbKeNqu4zRK8T1G
	/LjCLCTugOMQGToEW2IcN6NC9b1c8s805HhMPbVwMc9vuctvVFxy34iVpFTDim3ufZiT/YqWRo4
	GPolf8LvUJqc12YGHI0SPFOjoL5cdbI5VTYGu9XOGcgU8rFX4N+JXrII7GgxckrV411ei1IQw3W
	jWS9Y4Buz0mpKxr9ndO0cME0s/FztaVXnfy+97TP
X-Received: by 2002:a05:620a:2795:b0:813:f407:b231 with SMTP id af79cd13be357-813f407b2c1mr823787585a.7.1757390999764;
        Mon, 08 Sep 2025 21:09:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErBD4W95dKaQcdqqNQkv06LN8NvAxfsSKmERFWxkZIRNntelL7w9EYUZ1FKzZJ+j//rnYxrw==
X-Received: by 2002:a05:620a:2795:b0:813:f407:b231 with SMTP id af79cd13be357-813f407b2c1mr823784085a.7.1757390999028;
        Mon, 08 Sep 2025 21:09:59 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5f9f65e9sm56912485a.64.2025.09.08.21.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 21:09:58 -0700 (PDT)
Message-ID: <609f6c06-feb4-4aa9-972c-72747377ab6a@redhat.com>
Date: Tue, 9 Sep 2025 00:09:57 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/11] PCI: Add pci_bus_isolated()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <2-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <2-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> Prepare to move the calculation of the bus P2P isolation out of the iommu
> code and into the PCI core. This allows using the faster list iteration
> under the pci_bus_sem, and the code has a kinship with the logic in
> pci_for_each_dma_alias().
> 
> Bus isolation is the concept that drives the iommu_groups for the purposes
> of VFIO. Stated simply, if device A can send traffic to device B then they
> must be in the same group.
> 
> Only PCIe provides isolation. The multi-drop electrical topology in
> classical PCI allows any bus member to claim the transaction.
> 
> In PCIe isolation comes out of ACS. If a PCIe Switch and Root Complex has
> ACS flags that prevent peer to peer traffic and funnel all operations to
> the IOMMU then devices can be isolated.
> 
> Multi-function devices also have an isolation concern with self loopback
> between the functions, though pci_bus_isolated() does not deal with
> devices.
> 
> As a property of a bus, there are several positive cases:
> 
>   - The point to point "bus" on a physical PCIe link is isolated if the
>     bridge/root device has something preventing self-access to its own
>     MMIO.
> 
>   - A Root Port is usually isolated
> 
>   - A PCIe switch can be isolated if all it's Down Stream Ports have good
>     ACS flags
> 
> pci_bus_isolated() implements these rules and returns an enum indicating
> the level of isolation the bus has, with five possibilies:
> 
>   PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.
> 
>   PCIE_SWITCH_DSP_NON_ISOLATED: The bus is the internal bus of a PCIE
>       switch and the USP is isolated but the DSPs are not.
> 
>   PCIE_NON_ISOLATED: The PCIe bus has no isolation between the bridge or
>       any downstream devices.
> 
>   PCI_BUS_NON_ISOLATED: It is a PCI/PCI-X but the bridge is PCIe, has no
>       aliases and the bridge is isolated from the bus.
> 
>   PCI_BRIDGE_NON_ISOLATED: It is a PCI/PCI-X bus and has no isolation, the
>       bridge is part of the group.
> 
> The calculation is done per-bus, so it is possible for a transactions from
> a PCI device to travel through different bus isolation types on its way
> upstream. PCIE_SWITCH_DSP_NON_ISOLATED/PCI_BUS_NON_ISOLATED and
> PCIE_NON_ISOLATED/PCI_BRIDGE_NON_ISOLATED are the same for the purposes of
> creating iommu groups. The distinction between PCIe and PCI allows for
> easier understanding and debugging as to why the groups are chosen.
> 
> For the iommu groups if all busses on the upstream path are PCIE_ISOLATED
> then the end device has a chance to have a single-device iommu_group. Once
> any non-isolated bus segment is found that bus segment will have an
> iommu_group that captures all downstream devices, and sometimes the
> upstream bridge.
> 
> pci_bus_isolated() is principally about isolation, but there is an
> overlap with grouping requirements for legacy PCI aliasing. For purely
> legacy PCI environments pci_bus_isolated() returns
> PCI_BRIDGE_NON_ISOLATED for everything and all devices within a hierarchy
> are in one group. No need to worry about bridge aliasing.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/pci/search.c | 174 +++++++++++++++++++++++++++++++++++++++++++
>   include/linux/pci.h  |  31 ++++++++
>   2 files changed, 205 insertions(+)
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 53840634fbfc2b..fe6c07e67cb8ce 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -113,6 +113,180 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
>   	return ret;
>   }
>   
> +static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *pdev;
> +
> +	/*
> +	 * Within a PCIe switch we have an interior bus that has the Upstream
> +	 * port as the bridge and a set of Downstream port bridging to the
> +	 * egress ports.
> +	 *
> +	 * Each DSP has an ACS setting which controls where its traffic is
> +	 * permitted to go. Any DSP with a permissive ACS setting can send
> +	 * traffic flowing upstream back downstream through another DSP.
> +	 *
> +	 * Thus any non-permissive DSP spoils the whole bus.
> +	 */
> +	guard(rwsem_read)(&pci_bus_sem);
> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
> +		/* Don't understand what this is, be conservative */
> +		if (!pci_is_pcie(pdev) ||
> +		    pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM ||
> +		    pdev->dma_alias_mask)
> +			return PCIE_NON_ISOLATED;
> +
> +		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
> +			return PCIE_SWITCH_DSP_NON_ISOLATED;
> +	}
> +	return PCIE_ISOLATED;
> +}
> +
> +static bool pci_has_mmio(struct pci_dev *pdev)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
> +		struct resource *res = pci_resource_n(pdev, i);
> +
> +		if (resource_size(res) && resource_type(res) == IORESOURCE_MEM)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/**
> + * pci_bus_isolated - Determine how isolated connected devices are
> + * @bus: The bus to check
> + *
> + * Isolation is the ability of devices to talk to each other. Full isolation
> + * means that a device can only communicate with the IOMMU and can not do peer
> + * to peer within the fabric.
> + *
> + * We consider isolation on a bus by bus basis. If the bus will permit a
> + * transaction originated downstream to complete on anything other than the
> + * IOMMU then the bus is not isolated.
> + *
> + * Non-isolation includes all the downstream devices on this bus, and it may
> + * include the upstream bridge or port that is creating this bus.
> + *
> + * The various cases are returned in an enum.
> + *
> + * Broadly speaking this function evaluates the ACS settings in a PCI switch to
> + * determine if a PCI switch is configured to have full isolation.
> + *
> + * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
> + * but they do have some aliasing properties that effect group creation.
> + *
> + * pci_bus_isolated() does not consider loopback internal to devices, like
> + * multi-function devices performing a self-loopback. The caller must check
> + * this separately. It does not considering alasing within the bus.
> + *
> + * It does not currently support the ACS P2P Egress Control Vector, Linux does
> + * not yet have any way to enable this feature. EC will create subsets of the
> + * bus that are isolated from other subsets.
> + */
> +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *bridge = bus->self;
> +	int type;
> +
> +	/*
> +	 * This bus was created by pci_register_host_bridge(). The spec provides
> +	 * no way to tell what kind of bus this is, for PCIe we expect this to
> +	 * be internal to the root complex and not covered by any spec behavior.
> +	 * Linux has historically been optimistic about this bus and treated it
> +	 * as isolating. Given that the behavior of the root complex and the ACS
> +	 * behavior of RCiEP's is explicitly not specified we hope that the
> +	 * implementation is directing everything that reaches the root bus to
> +	 * the IOMMU.
> +	 */
> +	if (pci_is_root_bus(bus))
> +		return PCIE_ISOLATED;
> +
> +	/*
> +	 * bus->self is only NULL for SRIOV VFs, it represents a "virtual" bus
> +	 * within Linux to hold any bus numbers consumed by VF RIDs. Caller must
> +	 * use pci_physfn() to get the bus for calling this function.
> +	 */
> +	if (WARN_ON(!bridge))
> +		return PCI_BRIDGE_NON_ISOLATED;
> +
> +	/*
> +	 * The bridge is not a PCIe bridge therefore this bus is PCI/PCI-X.
> +	 *
> +	 * PCI does not have anything like ACS. Any down stream device can bus
> +	 * master an address that any other downstream device can claim. No
> +	 * isolation is possible.
> +	 */
> +	if (!pci_is_pcie(bridge)) {
> +		if (bridge->dev_flags & PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS)
> +			type = PCI_EXP_TYPE_PCI_BRIDGE;
> +		else
> +			return PCI_BRIDGE_NON_ISOLATED;
> +	} else {
> +		type = pci_pcie_type(bridge);
> +	}
> +
> +	switch (type) {
> +	/*
> +	 * Since PCIe links are point to point root ports are isolated if there
> +	 * is no internal loopback to the root port's MMIO. Like MFDs assume if
> +	 * there is no ACS cap then there is no loopback.
> +	 */
> +	case PCI_EXP_TYPE_ROOT_PORT:
> +		if (bridge->acs_cap &&
> +		    !pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
> +			return PCIE_NON_ISOLATED;
> +		return PCIE_ISOLATED;
> +
> +	/*
> +	 * Since PCIe links are point to point a DSP is always considered
> +	 * isolated. The internal bus of the switch will be non-isolated if the
> +	 * DSP's have any ACS that allows upstream traffic to flow back
> +	 * downstream to any DSP, including back to this DSP or its MMIO.
> +	 */
> +	case PCI_EXP_TYPE_DOWNSTREAM:
> +		return PCIE_ISOLATED;
> +
> +	/*
> +	 * bus is the interior bus of a PCI-E switch where ACS rules apply.
> +	 */
> +	case PCI_EXP_TYPE_UPSTREAM:
> +		return pcie_switch_isolated(bus);
> +
> +	/*
> +	 * PCIe to PCI/PCI-X - this bus is PCI.
> +	 */
> +	case PCI_EXP_TYPE_PCI_BRIDGE:
> +		/*
> +		 * A PCIe express bridge will use the subordinate bus number
> +		 * with a 0 devfn as the RID in some cases. This causes all
> +		 * subordinate devfns to alias with 0, which is the same
> +		 * grouping as PCI_BUS_NON_ISOLATED. The RID of the bridge
> +		 * itself is only used by the bridge.
> +		 *
> +		 * However, if the bridge has MMIO then we will assume the MMIO
> +		 * is not isolated due to no ACS controls on this bridge type.
> +		 */
> +		if (pci_has_mmio(bridge))
> +			return PCI_BRIDGE_NON_ISOLATED;
> +		return PCI_BUS_NON_ISOLATED;
> +
> +	/*
> +	 * PCI/PCI-X to PCIe - this bus is PCIe. We already know there must be a
> +	 * PCI bus upstream of this bus, so just return non-isolated. If
> +	 * upstream is PCI-X the PCIe RID should be preserved, but for PCI the
> +	 * RID will be lost.
> +	 */
> +	case PCI_EXP_TYPE_PCIE_BRIDGE:
> +		return PCI_BRIDGE_NON_ISOLATED;
> +
> +	default:
> +		return PCI_BRIDGE_NON_ISOLATED;
> +	}
> +}
> +
>   static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
>   {
>   	struct pci_bus *child;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 59876de13860db..c36fff9d2254f8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -855,6 +855,32 @@ struct pci_dynids {
>   	struct list_head	list;	/* For IDs added at runtime */
>   };
>   
> +enum pci_bus_isolation {
> +	/*
> +	 * The bus is off a root port and the root port has isolated ACS flags
> +	 * or the bus is part of a PCIe switch and the switch has isolated ACS
> +	 * flags.
> +	 */
> +	PCIE_ISOLATED,
> +	/*
> +	 * The switch's DSP's are not isolated from each other but are isolated
> +	 * from the USP.
> +	 */
> +	PCIE_SWITCH_DSP_NON_ISOLATED,
> +	/* The above and the USP's MMIO is not isolated. */
> +	PCIE_NON_ISOLATED,
> +	/*
> +	 * A PCI/PCI-X bus, no isolation. This is like
> +	 * PCIE_SWITCH_DSP_NON_ISOLATED in that the upstream bridge is isolated
> +	 * from the bus. The bus itself may also have a shared alias of devfn=0.
> +	 */
> +	PCI_BUS_NON_ISOLATED,
> +	/*
> +	 * The above and the bridge's MMIO is not isolated and the bridge's RID
> +	 * may be an alias.
> +	 */
> +	PCI_BRIDGE_NON_ISOLATED,
> +};
>   
>   /*
>    * PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
> @@ -1243,6 +1269,8 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
>   struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
>   struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
>   
> +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
> +
>   int pci_dev_present(const struct pci_device_id *ids);
>   
>   int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
> @@ -2056,6 +2084,9 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
>   						 struct pci_dev *from)
>   { return NULL; }
>   
> +static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> +{ return PCIE_NON_ISOLATED; }
> +
>   static inline int pci_dev_present(const struct pci_device_id *ids)
>   { return 0; }
>   
clarity a +1.

Reviewed-by: Donald Dutile <ddutile@redhat.com>


