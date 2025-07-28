Return-Path: <kvm+bounces-53531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44072B13854
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 11:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A53BE175B3B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 09:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEABF25B30D;
	Mon, 28 Jul 2025 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH0wFo/5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7572E259C85
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 09:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753696113; cv=none; b=iQt48+ZjyrFg6EK0XvfTKYDWWiNKTtLnhn9q/LFq7HWRJwQbSPww9mTFgB6BAq/AlC5WDTdXmZpVFxU/x2Ext+cFdJbqVmaJDvx6MUqTLKiJW2QfOoWkx5GzI9wEnlZ5+Vt+m1NxUG+XfiCwue4albfWvrodz4IDQPe+XfC6coo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753696113; c=relaxed/simple;
	bh=Hcp0mvps1beknbM+Gv+c/4V/7RLrjcuPtzxCqZxLi8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8bGP8i/wEHAeUWVmVVdE8tm6Xr4l49pnnfjMfGpouD2nI7+JGPXbo+BY6SpTRG1XFKTZi94+uOkUbqlUoNSBa0C49d58iJzyM2lU2QQHsiaodxVWso/aYS1ZBYwFaE15tTgPrnOYmX0EeWdD5UABZZ7uGWvsfYUuhPQ+hEn6lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH0wFo/5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753696110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Tb32ByScpQIehIaZKySMx9AWM1gfTt6mgT4fZGiOxsA=;
	b=YH0wFo/5m6paHsQP49ecZUO8slTHrso+ectlA+MdqmbsQqna2dFB67ivW96AANSICjg9a9
	O5Qod9NsZzzVgQ/U1Ud7gTCOGgCHUDSv/HuY7kCWqpESsx+qGals86COe/kDXpknirElB8
	DW85yjeynH48UB468xYljOyI4bVbKnk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-R7s__RqkMG-aP0dDX_4RMA-1; Mon, 28 Jul 2025 05:48:28 -0400
X-MC-Unique: R7s__RqkMG-aP0dDX_4RMA-1
X-Mimecast-MFC-AGG-ID: R7s__RqkMG-aP0dDX_4RMA_1753696107
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b20f50da27so2194100f8f.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 02:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753696107; x=1754300907;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tb32ByScpQIehIaZKySMx9AWM1gfTt6mgT4fZGiOxsA=;
        b=TwVyFpRu2yiuW+SkdB2Jto3wAmH4kcptuBCFeQWxPpRs0Rn93fbjxkiMbs9hIWkCcZ
         65Zz1iTrgiuFQGN5q8v3O6JBFwo3YKXuL6x4fBUy8AWGTvU6rr01r748UR1F3vPwL8Lk
         atyKbzQi7sQ1pyqTBNy2WskbFnF6oL2zv+Rlyfs/d0Ip3XfDyOfHcJz4ClDuuD/GKXR4
         IL0XxLdn9VUzFK/23eh/wGrOS9FQ0nzoUGPKDpgu69wk8JmYTHqkR9H4Ga7Pjf+ymLwe
         XloRTO7oY3VFa7s+3vxjs377e7Eoqhn1vEYAy+FoXNX6q5s8nT7Q2ayJ8X0l34Cj9QzH
         VPkw==
X-Forwarded-Encrypted: i=1; AJvYcCWjaX8Gs3PoDhql7JmTQXDUs4VEURv1d0pNiqilaJCsRv21Skt/bUSD3yWiHVxdG3YgG/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/PWSef4BTE593UepYZz/xb2fntr8ic47bycLJ+Hkiyo+RCF71
	mEURU4UMt834td1eboQu4ezkVLOE1TnY1Z7DaJXOQl+I/EmNF+wU77yuVxnKOqaMs5RZ39Stgfs
	Bj31LL+Y+/xXz5df03xbV5UP/QVkOipWg+6kSvmcs2rWHvRKwG0KoYA==
X-Gm-Gg: ASbGncv3t2qkoUrsuymgxYpeS7kuctX1MzRNmtaT0aVx3QA8vDfxCvLfFVoEyKWd/hA
	lz9cpOahBEs/heY8fQnJ48HyUwSIegIxeZmv4B3Z9cflspLV2BwE7tqbEwzz3D8haHsbwqt1K/u
	AI/JC+SKTpQXFnmZSh1H9TO3OPHVLTE/SnY3M0Xpmlf2CfkUgNmkH/AHnSK2doSoUELA7OoJ0Th
	3+dY235sHuwVZO436738ax3aTWOtHT8/RPPQ6FG6qIeUPaYjI1/huZXjac5h8NGPP2sphdzjaWj
	qvsUYay377zTa0u0SzI4KE4aRU1m3c8P43aMkt6hyPqCtfdzmsO8G27Xk8joPPN9TCc/wbUapd5
	iCA==
X-Received: by 2002:a05:6000:26c6:b0:3a5:8934:4959 with SMTP id ffacd0b85a97d-3b77137c0f0mr12039870f8f.27.1753696107139;
        Mon, 28 Jul 2025 02:48:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUXRjwOPVbA59nK4v5ianQtoJcvTZGPoentHCek+qAYkv5qFyqsFP1/OpiBjVpvRqU32WS/Q==
X-Received: by 2002:a05:6000:26c6:b0:3a5:8934:4959 with SMTP id ffacd0b85a97d-3b77137c0f0mr12039832f8f.27.1753696106389;
        Mon, 28 Jul 2025 02:48:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4cacsm147540415e9.24.2025.07.28.02.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 02:47:59 -0700 (PDT)
Message-ID: <5051c509-75a3-4ab6-bcfb-4610a660a142@redhat.com>
Date: Mon, 28 Jul 2025 11:47:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/16] iommu: Compute iommu_groups properly for PCIe
 MFDs
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <11-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <11-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Jason,

On 7/9/25 16:52, Jason Gunthorpe wrote:
> The current algorithm does not work if the ACS is not uniform across the
> entire MFD. This seems to mostly happen in the real world because of
> Linux's quirk systems that sometimes quirks only one function in a MFD,
> creating an asymmetric situation.
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
> This is a problematic fix because this historical mistake has created an
> ecosystem around it. We now have quirks that assume single function is
> enough to quirk and it seems there are PCI root complexes that make the
> same non-compliant assumption.
> 
> The new helper pci_mfd_isolation() retains the existing quirks and we
> will probably need to add additional HW quirks for PCI root complexes that
> have not followed the spec but have been silently working today.
> 
> Use pci_reachable_set() in pci_device_group() to make the resulting
> algorithm faster and easier to understand.
> 
> Add pci_mfds_are_same_group() which specifically looks pair-wise at all
> functions in the MFDs. Any function without ACS isolation will become
> reachable to all other functions.
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
>   drivers/iommu/iommu.c | 173 +++++++++++++++++-------------------------
>   1 file changed, 71 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 7b407065488296..cd26b43916e8be 100644
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
> @@ -1534,40 +1455,88 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
>   	return group;
>   }
>   
> +/*
> + * Ignoring quirks, all functions in the MFD need to be isolated from each other
> + * and get their own groups, otherwise the whole MFD will share a group. Any
> + * function that lacks explicit ACS isolation is assumed to be able to P2P
> + * access any other function in the MFD.
> + */
> +static bool pci_mfds_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
> +{
> +	/* Are deva/devb functions in the same MFD? */
> +	if (PCI_SLOT(deva->devfn) != PCI_SLOT(devb->devfn))
> +		return false;
> +	/* Don't understand what is happening, be conservative */
> +	if (deva->multifunction != devb->multifunction)
> +		return true;
> +	if (!deva->multifunction)
> +		return false;
> +
> +	/* Quirks can inhibit single MFD functions from combining into groups */
> +	if (pci_mfd_isolated(deva) || pci_mfd_isolated(devb))
> +		return false;
> +
> +	/* Can they reach each other's MMIO through P2P? */
> +	return !pci_acs_enabled(deva, PCI_ACS_ISOLATED) ||
> +	       !pci_acs_enabled(devb, PCI_ACS_ISOLATED);
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
>   static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
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
>   static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)


I am seeing this WARN_ON when creating VFs of a CX-7 adapter :

[   31.436294] pci 0000:b1:00.2: enabling Extended Tags
[   31.448767] ------------[ cut here ]------------
[   31.453392] WARNING: CPU: 47 PID: 1673 at drivers/iommu/iommu.c:1533 pci_device_group+0x307/0x3b0
....
[   31.869174]  </TASK>
[   31.871373] ---[ end trace 0000000000000000 ]---
[   31.876020] pci 0000:b1:00.2: Adding to iommu group 11
[   31.883572] mlx5_core 0000:b1:00.2: enabling device (0000 -> 0002)
[   31.889846] mlx5_core 0000:b1:00.2: firmware version: 28.40.1000

Some more info on the system below,

b1:00.1 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
	Subsystem: Mellanox Technologies Device 0026
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	NUMA node: 1
	IOMMU group: 12
	Region 0: Memory at dc000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at dbd00000 [disabled] [size=1M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 75.000W
		DevCtl:	CorrErr- NonFatalErr+ FatalErr+ UnsupReq+
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 512 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ NonFatalErr- FatalErr- UnsupReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 32GT/s, Width x16, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 16GT/s (downgraded), Width x8 (downgraded)
			TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR-
			 10BitTagComp+ 10BitTagReq+ OBFF Not Supported, ExtFmt- EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS- TPHComp- ExtTPHComp-
			 AtomicOpsCap: 32bit+ 64bit+ 128bitCAS+
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- LTR- OBFF Disabled,
			 AtomicOpsCtl: ReqEn+
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
			 EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
			 Retimer- 2Retimers- CrosslinkRes: unsupported
	Capabilities: [48] Vital Product Data
		Product Name: NVIDIA ConnectX-7 Ethernet adapter card, 200 GbE , Dual-port QSFP112, PCIe 5.0 x16, Crypto and Secure Boot
		Read-only fields:
			[PN] Part number: MCX713106AC-VEAT
			[EC] Engineering changes: A5
			[V2] Vendor specific: MCX713106AC-VEAT
			[SN] Serial number: MT2304XZ02VD
			[V3] Vendor specific: 6e988f87fb9ced118000946dae47a24a
			[VA] Vendor specific: MLX:MN=MLNX:CSKU=V2:UUID=V3:PCI=V0:MODL=CX713106A
			[V0] Vendor specific: PCIeGen5 x16
			[VU] Vendor specific: MT2304XZ02VDMLNXS0D0F1
			[RV] Reserved: checksum good, 1 byte(s) reserved
		End
	Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt+ RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP+ FCP+ CmpltTO+ CmpltAbrt+ UnxCmplt- RxOF+ MalfTLP+ ECRC+ UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		CEMsk:	RxErr- BadTLP+ BadDLLP+ Rollover+ Timeout+ AdvNonFatalErr+
		AERCap:	First Error Pointer: 04, ECRCGenCap+ ECRCGenEn+ ECRCChkCap+ ECRCChkEn+
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 00000000 00000000 00000000 00000000
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Capabilities: [180 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable- Migration- Interrupt- MSE- ARIHierarchy-
		IOVSta:	Migration-
		Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 01
		VF offset: 9, stride: 1, Device ID: 101e
		Supported Page Size: 000007ff, System Page Size: 00000001
		Region 0: Memory at 00000000e0000000 (64-bit, prefetchable)
		VF Migration: offset: 00000000, BIR: 0
	Capabilities: [230 v1] Access Control Services
		ACSCap:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-
	Capabilities: [420 v1] Data Link Feature <?>
	Kernel driver in use: mlx5_core
	Kernel modules: mlx5_core
b1:00.2 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	Subsystem: Mellanox Technologies Device 0026
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	NUMA node: 1
	IOMMU group: 11
	Region 0: Memory at e0800000 (64-bit, prefetchable) [virtual] [size=1M]
	Capabilities: [60] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
		DevCtl:	CorrErr- NonFatalErr- FatalErr- UnsupReq-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 32GT/s, Width x16, ASPM not supported
			ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
		LnkCtl:	ASPM Disabled; RCB 64 bytes, Disabled- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown (downgraded), Width x0 (downgraded)
			TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABC, TimeoutDis+ NROPrPrP- LTR-
			 10BitTagComp+ 10BitTagReq+ OBFF Not Supported, ExtFmt- EETLPPrefix-
			 EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
			 FRS- TPHComp- ExtTPHComp-
			 AtomicOpsCap: 32bit+ 64bit+ 128bitCAS+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- OBFF Disabled,
			 AtomicOpsCtl: ReqEn-
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
			 EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
			 Retimer- 2Retimers- CrosslinkRes: unsupported
	Capabilities: [9c] MSI-X: Enable- Count=12 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [100 v1] Vendor Specific Information: ID=0000 Rev=0 Len=00c <?>
	Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
		ARICap:	MFVC- ACS-, Next Function: 0
		ARICtl:	MFVC- ACS-, Function Group: 0
	Kernel driver in use: mlx5_vfio_pci
	Kernel modules: mlx5_core


  +-[0000:b0]-+-00.0  Intel Corporation Ice Lake Memory Map/VT-d
  |           +-00.1  Intel Corporation Ice Lake Mesh 2 PCIe
  |           +-00.2  Intel Corporation Ice Lake RAS
  |           +-00.4  Intel Corporation Ice Lake IEH
  |           \-04.0-[b1-b2]--+-00.0  Mellanox Technologies MT2910 Family [ConnectX-7]
  |                           +-00.1  Mellanox Technologies MT2910 Family [ConnectX-7]
  |                           +-00.2  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-00.3  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-00.4  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-00.5  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-00.6  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-00.7  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           +-01.0  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  |                           \-01.1  Mellanox Technologies ConnectX Family mlx5Gen Virtual Function


IOMMU groups are baroque :


  *IOMMU Group 11 :
	b1:00.0 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
	b1:00.2 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	b1:00.3 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	b1:00.4 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	b1:00.5 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	b1:00.6 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
	b1:00.7 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  *IOMMU Group 12 :
	b1:00.1 Ethernet controller: Mellanox Technologies MT2910 Family [ConnectX-7]
  *IOMMU Group 184 :
	b1:01.0 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function
  *IOMMU Group 185 :
	b1:01.1 Ethernet controller: Mellanox Technologies ConnectX Family mlx5Gen Virtual Function



Other differences are on the onboard graphic card:

  *IOMMU Group 26 :
	02:00.0 PCI bridge: PLDA PCI Express Bridge (rev 02)
	03:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. Integrated Matrox G200eW3 Graphics Controller (rev 04)

becomes :

  *IOMMU Group 26 :
	02:00.0 PCI bridge: PLDA PCI Express Bridge (rev 02)
  *IOMMU Group 27 :
	03:00.0 VGA compatible controller: Matrox Electronics Systems Ltd. Integrated Matrox G200eW3 Graphics Controller (rev 04)

I guess that's unrelated


Thanks,

C.



