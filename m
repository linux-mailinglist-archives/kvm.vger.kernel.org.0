Return-Path: <kvm+bounces-57148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5913FB50818
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA78B3A9D41
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB76125B1FF;
	Tue,  9 Sep 2025 21:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqsN63Wa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43B6221F15;
	Tue,  9 Sep 2025 21:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757453099; cv=none; b=MiAD8Hj8cQSZTQ11h3chXLnT+flGS2Qd01YFzF6BIc55GYHqssJQmM7T/Q+jVaxwVc88ibFLfAW2oXGFVLVaLc19JtsSSBt+jCEoczkA8Fdel4ZjtDyDVN2U3iyLNV6QCILw/pt13KqpNvkGhqjHUPpQAgGwDP4O+Lr+GLk3tiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757453099; c=relaxed/simple;
	bh=nVeL025PyzaygZ/cm/L6ZCfVuIYMF82QcpuSOzrDeu8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ogxJzT5qe+UIc7eilfvsUrQEbx9k1B1/Ztt6uI1R6RPojQYRseOvc7K3sGg/b7abBzk4s2S5CGooU2bMAx2GaJZgR/KQ1e3DylDoK9sKlPVtigqNs5M6bbdw5G3dGp2n2vinVMeYbb3iixs50xOpn9aCx3xFGOh+zMfTu5FHqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqsN63Wa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A931C4CEF4;
	Tue,  9 Sep 2025 21:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757453099;
	bh=nVeL025PyzaygZ/cm/L6ZCfVuIYMF82QcpuSOzrDeu8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=UqsN63WaTM+aTS+Yx59jQKkT9DfkWSDLlFnKzOdF0a6rerY9/rR4H9Dq09yoJ3/5E
	 ++J7/l+I9GWmeGwQY2npxnshPw1UTBik5RopJig+eqyZOoilmXaZq7cTk3tk7j8eqi
	 cdM5SwYBMr1261Uj7Lns0ud3tPzQM2PWIZx7BPNGzsW/A0+PgruczCuzPlg/zO1C58
	 74LGM5IFcgGVL0iE/Qg6dqCRD5V6QE6Pb/W1iWDCTTVBSU/g2seMCyItfa8JoRWzyT
	 iv8y70Ih9tOSLD7xvpMEuVMLbQ11ltVoAAjbFPXGbNVhqgEQN3biBQ4UQ3Q7wNYRQc
	 5vtphmwHHt0TQ==
Date: Tue, 9 Sep 2025 16:24:57 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Message-ID: <20250909212457.GA1508122@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:21PM -0300, Jason Gunthorpe wrote:
> Like with switches the current MFD algorithm does not consider asymmetric
> ACS within a MFD. If any MFD function has ACS that permits P2P the spec
> says it can reach through the MFD internal loopback any other function in
> the device.
> 
> For discussion let's consider a simple MFD topology like the below:
> 
>                       -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
>       Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
>                       |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

REQ_ACS_FLAGS was renamed in an earlier patch.

I don't quite understand the "Root 00:00.00" notation.  I guess it
must refer to the root bus 00?  It looks sort of like a bridge, and
the ".00" makes it look sort of like a bus/device/function address,
but I don't think it is.

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
>                       -- MFD 00:1f.0
>       Root 00:00.00 --|- MFD 00:1f.2 Root Port --- 01:01.0
>                       |- MFD 00:1f.6

Same question.

> Then the correct grouping will include 01:01.0, 00:1f.0/2/6 together in a
> group if there is any internal loopback within the MFD 00:1f. The current
> algorithm does not understand this and gives 01:01.0 it's own group even
> if it thinks there is an internal loopback in the MFD.

s/it's/its/

> Unfortunately this detail makes it hard to fix. Currently the code assumes
> that any MFD without an ACS cap has an internal loopback which will cause
> a large number of modern real systems to group in a pessimistic way.
> 
> However, the PCI spec does not really support this:
> 
>    PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function
>    Devices
> 
>     ACS P2P Request Redirect: must be implemented by Functions that
>     support peer-to-peer traffic with other Functions.

I would include the PCIe r7.0 spec revision, even though the PCI SIG
seems to try to preserve section numbers across revisions.

It seems pretty clear that Multi-Function Devices that have an ACS
Capability and support peer-to-peer traffic with other Functions are
required to implement ACS P2P Request Redirect.

> Meaning from a spec perspective the absence of ACS indicates the absence
> of internal loopback. Granted I think we are aware of older real devices
> that ignore this, but it seems to be the only way forward.

It's not as clear to me that Multi-Function Devices that support
peer-to-peer traffic are required to have an ACS Capability at all.

Alex might remember more, but I kind of suspect the current system of
quirks is there because of devices that do internal loopback but have
no ACS Capability.

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

s/aCS/ACS/

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
>  drivers/iommu/iommu.c | 189 +++++++++++++++++++-----------------------
>  1 file changed, 87 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 543d6347c0e5e3..fc3c71b243a850 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_id);
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
>  /*
>   * Generic device_group call-back function. It just allocates one
>   * iommu-group per device.
> @@ -1534,44 +1455,108 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
>  	return group;
>  }
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

"SR-IOV" is more typical in drivers/pci/.

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

PCIe r7.0, sec 6.12.1.2

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
>  /*
>   * Return a group if the function has isolation restrictions related to
>   * aliases or MFD ACS.
>   */
>  static struct iommu_group *pci_get_function_group(struct pci_dev *pdev)
>  {
> -	struct iommu_group *group;
> -	DECLARE_BITMAP(devfns, 256) = {};
> +	struct pci_reachable_set devfns;
> +	const unsigned int NR_DEVFNS = sizeof(devfns.devfns) * BITS_PER_BYTE;
> +	unsigned int devfn;
>  
>  	/*
> -	 * Look for existing groups on device aliases.  If we alias another
> -	 * device or another device aliases us, use the same group.
> +	 * Look for existing groups on device aliases and multi-function ACS. If
> +	 * we alias another device or another device aliases us, use the same
> +	 * group.
> +	 *
> +	 * pci_reachable_set() should return the same bitmap if called for any
> +	 * device in the set and we want all devices in the set to have the same
> +	 * group.
>  	 */
> -	group = get_pci_alias_group(pdev, devfns);
> -	if (group)
> -		return group;
> +	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
> +	/* start is known to have iommu_group_get() == NULL */
> +	__clear_bit(pdev->devfn, devfns.devfns);
>  
>  	/*
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
>  	 *
>  	 * It is less clear what aliases mean when applied to a bridge. For now
>  	 * be conservative and also propagate the group downstream.
>  	 */
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
>  }
>  
>  /* Return a group if the upstream hierarchy has isolation restrictions. */
> -- 
> 2.43.0
> 

