Return-Path: <kvm+bounces-57042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E603B4A0F9
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EEE51B265D1
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6541D2ED84F;
	Tue,  9 Sep 2025 04:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8U6qR6W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A90A25A2DE
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 04:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757393890; cv=none; b=qu5RAU0PVx+Ew9l3dJcMQv1i1uM9oWO0CWLfquXKDxWlx7WARM/YgNXeNFwtTO/s0XpRDSiCQ2NtQrr0nP/F8z6TE1RAUrX8p6vPk4Fo/oRvnfQ9Z0AqO1OgyvYKL5GXPjXCJCsqoAAezOx0C3fjiebJLnxyGKOY7UWmWWlii64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757393890; c=relaxed/simple;
	bh=u5piwJmyEGsi1ED9NZdrjCpsu+7/IStzsHMCqioLSNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFdQpZhaRSJbx4f3sC4U6Jt/tfpwd2V38RVEM1ttKvJIqGNHNrZSFx5lMPv64G8TT6oYo/+nE9isibkJbcUpHRGKDLg8lUoHD25y5iZfpxbP/pdEYB/fIX2ON/KjQgcGljhEaat4T1r9EamcexBI4XdSxAjpmwsu+Vel24BMLf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8U6qR6W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757393886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnFEISM3p7GtV+aaIEcUnslI/UCpiYg949Zis5Oc7BU=;
	b=G8U6qR6W+vCn7PTpr34UfG/qYkfMu4BME9641fVFywkUhhjvpAx7RL1tbbA44lnkePZICW
	0HoocWbdClE4too/6kVh3G4hPvcOhyrPP13INRKcQ2o/NEOuGveoemenxI70CAAYXpt1hQ
	0O8QG8l4TP9AZjNWQRhkqeJ6eEOF9a8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-kytgGa5dOBKAFR0SE3aHCw-1; Tue, 09 Sep 2025 00:58:04 -0400
X-MC-Unique: kytgGa5dOBKAFR0SE3aHCw-1
X-Mimecast-MFC-AGG-ID: kytgGa5dOBKAFR0SE3aHCw_1757393883
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-70ddadde46bso108372056d6.2
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 21:58:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757393883; x=1757998683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NnFEISM3p7GtV+aaIEcUnslI/UCpiYg949Zis5Oc7BU=;
        b=NUfOYP0QQbwboOjrocT7ZdlbdfL4UcF2wgOohLMpdSBnxCWg8UVv5206q6BOHEhvr2
         oVhIKe3ABYAQO/KEgH8IzFd5IFfIIi/9HA+1SddvuMn3LBxybfd3W7dT7isNCv9b2RF+
         zReW7PCVZLn0eMomJ4+qGvYXSGkuhgfhqAOz5ZReF9qdF7TtScnt55doyIAX1JtRQf2L
         wjdjJv2pWno3aC4/Z7fDuhaGv2C6OU8KY9RUom6yzQPeOTLx8uZNCu1Xs6x2IVwT6vJM
         tYWY+3R436R3/P9YXz1CeU45gsmDDriRzVBqy4Et2WnAWDi/ej1YZO1NpD5/7MlPbQOh
         9Syw==
X-Forwarded-Encrypted: i=1; AJvYcCVhaA3wvtemfi1BmoACRhftL1lHZs2Qr2GOoAEHBgi0SirGKFtMPRLogNpA/W+0OxhKV4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyONSkG5tvSL6RAha13U7jJ/E7IF1WYXWfl/EeugVy5fh5jaubm
	y7gBZxdtniFxbhNzCykcpTGgf6QxPv9ktAZ0siGzadaVzfC2PEb5GshcpOY0VNB7xqTdrxugMcs
	DWpeJlWDIo5oLzd6UyveGypG0R8qgAnlpx3DhHvIOYt7vEPS8DbdPEw==
X-Gm-Gg: ASbGncv9HMU8C+6cAa/4Ag4eimz1tI3FZFX96YEiIH//BbwocfuG8hhyvh9ETAqh2XW
	PR60Fd0fiSLeSMr7LG3dBNlwC7RwUtCFb13pmXl0+oonpcuIu/gfsJRlZgkIkhe96baxmBedjYi
	pDZs8RatlYpeJLreMH98VM1QBFSgc95jU5A0xL9wifjLSMdftqj02zvy/igUz/skK2RyleKHHso
	+F0P6HVMLbuWquFWWahSqHqyhiBP1ucclwFEJlSP3fUkPBhm2Xm8YHQ/Y3tAx27kpZLxO9mEGZF
	jjM4uHcoaFxFAktPadb5/5FgNZ4vFXFlY5y1gOov
X-Received: by 2002:a05:6214:412:b0:721:ecaf:500c with SMTP id 6a1803df08f44-73943d7ddb7mr102889136d6.52.1757393883528;
        Mon, 08 Sep 2025 21:58:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFlnrJfhz7ysxSdVIy4bwObD2P7N+pyir1IThpIDS0FJyDYaqOu2jRj1g3r6NBfBNx//ZpHpQ==
X-Received: by 2002:a05:6214:412:b0:721:ecaf:500c with SMTP id 6a1803df08f44-73943d7ddb7mr102888886d6.52.1757393883029;
        Mon, 08 Sep 2025 21:58:03 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720b4947b1asm137895806d6.41.2025.09.08.21.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 21:58:02 -0700 (PDT)
Message-ID: <d0a5052e-fbbc-4bb7-b1cd-f3f72c7085d3@redhat.com>
Date: Tue, 9 Sep 2025 00:57:59 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
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
References: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> Like with switches the current MFD algorithm does not consider asymmetric
> ACS within a MFD. If any MFD function has ACS that permits P2P the spec
> says it can reach through the MFD internal loopback any other function in
> the device.
> 
> For discussion let's consider a simple MFD topology like the below:
> 
>                        -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>        Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>                        |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> This asymmetric ACS could be created using the config_acs kernel command
> line parameter, from quirks, or from a poorly thought out device that has
> ACS flags only on some functions.
> 
> Since ACS is an egress property the asymmetric flags allow for 00:1f.0 to
> do memory acesses into 00:1f.6's BARs, but 00:1f.6 cannot reach any other
> function. Thus we expect an iommu_group to contain all three
> devices. Instead the current algorithm gives a group of [1f.0, 1f.2] and a
> single device group of 1f.6.
> 
> The current algorithm sees the good ACS flags on 00:1f.6 and does not
> consider ACS on any other MFD functions.
> 
> For path properties the ACS flags say that 00:1f.6 is safe to use with
> PASID and supports SVA as it will not have any portions of its address
> space routed away from the IOMMU, this part of the ACS system is working
> correctly.
> 
> Further, if one of the MFD functions is a bridge, eg like 1f.2:
> 
>                        -- MFD 00:1f.0
>        Root 00:00.00 --|- MFD 00:1f.2 Root Port --- 01:01.0
>                        |- MFD 00:1f.6
> 
> Then the correct grouping will include 01:01.0, 00:1f.0/2/6 together in a
> group if there is any internal loopback within the MFD 00:1f. The current
> algorithm does not understand this and gives 01:01.0 it's own group even
> if it thinks there is an internal loopback in the MFD.
> 
> Unfortunately this detail makes it hard to fix. Currently the code assumes
> that any MFD without an ACS cap has an internal loopback which will cause
> a large number of modern real systems to group in a pessimistic way.
> 
> However, the PCI spec does not really support this:
> 
>     PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function
>     Devices
> 
>      ACS P2P Request Redirect: must be implemented by Functions that
>      support peer-to-peer traffic with other Functions.
> 
> Meaning from a spec perspective the absence of ACS indicates the absence
> of internal loopback. Granted I think we are aware of older real devices
> that ignore this, but it seems to be the only way forward.
> 
> So, rely on 6.12.1.2 and assume functions without ACS do not have internal
> loopback. This resolves the common issue with modern systems and MFD root
> ports, but it makes the ACS quirks system less used. Instead we'd want
> quirks that say self-loopback is actually present, not like today's quirks
> that say it is absent. This is surely negative for older hardware, but
> positive for new HW that complies with the spec.
> 
> Use pci_reachable_set() in pci_device_group() to make the resulting
> algorithm faster and easier to understand.
> 
> Add pci_mfds_are_same_group() which specifically looks pair-wise at all
> functions in the MFDs. Any function with ACS capabilities and non-isolated
> aCS flags will become reachable to all other functions.
> 
> pci_reachable_set() does the calculations for figuring out the set of
> devices under the pci_bus_sem, which is better than repeatedly searching
> across all PCI devices.
> 
> Once the set of devices is determined and the set has more than one device
> use pci_get_slot() to search for any existing groups in the reachable set.
> 
> Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 189 +++++++++++++++++++-----------------------
>   1 file changed, 87 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 543d6347c0e5e3..fc3c71b243a850 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_id);
>   
> -static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
> -					       unsigned long *devfns);
> -
> -/*
> - * For multifunction devices which are not isolated from each other, find
> - * all the other non-isolated functions and look for existing groups.  For
> - * each function, we also need to look for aliases to or from other devices
> - * that may already have a group.
> - */
> -static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
> -							unsigned long *devfns)
> -{
> -	struct pci_dev *tmp = NULL;
> -	struct iommu_group *group;
> -
> -	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
> -		return NULL;
> -
> -	for_each_pci_dev(tmp) {
> -		if (tmp == pdev || tmp->bus != pdev->bus ||
> -		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
> -		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
> -			continue;
> -
> -		group = get_pci_alias_group(tmp, devfns);
> -		if (group) {
> -			pci_dev_put(tmp);
> -			return group;
> -		}
> -	}
> -
> -	return NULL;
> -}
> -
> -/*
> - * Look for aliases to or from the given device for existing groups. DMA
> - * aliases are only supported on the same bus, therefore the search
> - * space is quite small (especially since we're really only looking at pcie
> - * device, and therefore only expect multiple slots on the root complex or
> - * downstream switch ports).  It's conceivable though that a pair of
> - * multifunction devices could have aliases between them that would cause a
> - * loop.  To prevent this, we use a bitmap to track where we've been.
> - */
> -static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
> -					       unsigned long *devfns)
> -{
> -	struct pci_dev *tmp = NULL;
> -	struct iommu_group *group;
> -
> -	if (test_and_set_bit(pdev->devfn & 0xff, devfns))
> -		return NULL;
> -
> -	group = iommu_group_get(&pdev->dev);
> -	if (group)
> -		return group;
> -
> -	for_each_pci_dev(tmp) {
> -		if (tmp == pdev || tmp->bus != pdev->bus)
> -			continue;
> -
> -		/* We alias them or they alias us */
> -		if (pci_devs_are_dma_aliases(pdev, tmp)) {
> -			group = get_pci_alias_group(tmp, devfns);
> -			if (group) {
> -				pci_dev_put(tmp);
> -				return group;
> -			}
> -
> -			group = get_pci_function_alias_group(tmp, devfns);
> -			if (group) {
> -				pci_dev_put(tmp);
> -				return group;
> -			}
> -		}
> -	}
> -
> -	return NULL;
> -}
> -
>   /*
>    * Generic device_group call-back function. It just allocates one
>    * iommu-group per device.
> @@ -1534,44 +1455,108 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
>   	return group;
>   }
>   
> +/*
> + * All functions in the MFD need to be isolated from each other and get their
> + * own groups, otherwise the whole MFD will share a group.
> + */
> +static bool pci_mfds_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
> +{
> +	/*
> +	 * SRIOV VFs will use the group of the PF if it has
> +	 * BUS_DATA_PCI_NON_ISOLATED. We don't support VFs that also have ACS
> +	 * that are set to non-isolating.
> +	 */
> +	if (deva->is_virtfn || devb->is_virtfn)
> +		return false;
> +
> +	/* Are deva/devb functions in the same MFD? */
> +	if (PCI_SLOT(deva->devfn) != PCI_SLOT(devb->devfn))
> +		return false;
> +	/* Don't understand what is happening, be conservative */
> +	if (deva->multifunction != devb->multifunction)
> +		return true;
> +	if (!deva->multifunction)
> +		return false;
> +
> +	/*
> +	 * PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and
> +	 * Multi-Function Devices
> +	 *   ...
> +	 *   ACS P2P Request Redirect: must be implemented by Functions that
> +	 *   support peer-to-peer traffic with other Functions.
> +	 *
> +	 * Therefore assume if a MFD has no ACS capability then it does not
> +	 * support a loopback. This is the reverse of what Linux <= v6.16
> +	 * assumed - that any MFD was capable of P2P and used quirks identify
> +	 * devices that complied with the above.
> +	 */
> +	if (deva->acs_cap && !pci_acs_enabled(deva, PCI_ACS_ISOLATED))
> +		return true;
> +	if (devb->acs_cap && !pci_acs_enabled(devb, PCI_ACS_ISOLATED))
> +		return true;
> +	return false;
> +}
> +
> +static bool pci_devs_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
> +{
> +	/*
> +	 * This is allowed to return cycles: a,b -> b,c -> c,a can be aliases.
> +	 */
> +	if (pci_devs_are_dma_aliases(deva, devb))
> +		return true;
> +
> +	return pci_mfds_are_same_group(deva, devb);
> +}
> +
>   /*
>    * Return a group if the function has isolation restrictions related to
>    * aliases or MFD ACS.
>    */
>   static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
>   {
> -	struct iommu_group *group;
> -	DECLARE_BITMAP(devfns, 256) = {};
> +	struct pci_reachable_set devfns;
> +	const unsigned int NR_DEVFNS = sizeof(devfns.devfns) * BITS_PER_BYTE;
> +	unsigned int devfn;
>   
>   	/*
> -	 * Look for existing groups on device aliases.  If we alias another
> -	 * device or another device aliases us, use the same group.
> +	 * Look for existing groups on device aliases and multi-function ACS. If
> +	 * we alias another device or another device aliases us, use the same
> +	 * group.
> +	 *
> +	 * pci_reachable_set() should return the same bitmap if called for any
> +	 * device in the set and we want all devices in the set to have the same
> +	 * group.
>   	 */
> -	group = get_pci_alias_group(pdev, devfns);
> -	if (group)
> -		return group;
> +	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
> +	/* start is known to have iommu_group_get() == NULL */
> +	__clear_bit(pdev->devfn, devfns.devfns);
>   
>   	/*
> -	 * Look for existing groups on non-isolated functions on the same
> -	 * slot and aliases of those funcions, if any.  No need to clear
> -	 * the search bitmap, the tested devfns are still valid.
> -	 */
> -	group = get_pci_function_alias_group(pdev, devfns);
> -	if (group)
> -		return group;
> -
> -	/*
> -	 * When MFD's are included in the set due to ACS we assume that if ACS
> -	 * permits an internal loopback between functions it also permits the
> -	 * loopback to go downstream if a function is a bridge.
> +	 * When MFD functions are included in the set due to ACS we assume that
> +	 * if ACS permits an internal loopback between functions it also permits
> +	 * the loopback to go downstream if any function is a bridge.
>   	 *
>   	 * It is less clear what aliases mean when applied to a bridge. For now
>   	 * be conservative and also propagate the group downstream.
>   	 */
> -	__clear_bit(pdev->devfn & 0xFF, devfns);
> -	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
> -		return pci_group_alloc_non_isolated();
> -	return NULL;
... and why was the above code done in patch 3 and then undone here to
use the reachable() support in patch 5 below, when patch 5 could be moved before
patch 3, and we just get to this final implementation, dropping (some of) patch 3?

> +	if (bitmap_empty(devfns.devfns, NR_DEVFNS))
> +		return NULL;
> +
> +	for_each_set_bit(devfn, devfns.devfns, NR_DEVFNS) {
> +		struct iommu_group *group;
> +		struct pci_dev *pdev_slot;
> +
> +		pdev_slot = pci_get_slot(pdev->bus, devfn);
> +		group = iommu_group_get(&pdev_slot->dev);
> +		pci_dev_put(pdev_slot);
> +		if (group) {
> +			if (WARN_ON(!(group->bus_data &
> +				      BUS_DATA_PCI_NON_ISOLATED)))
> +				group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
> +			return group;
> +		}
> +	}
> +	return pci_group_alloc_non_isolated();
>   }
>   
>   /* Return a group if the upstream hierarchy has isolation restrictions. */


