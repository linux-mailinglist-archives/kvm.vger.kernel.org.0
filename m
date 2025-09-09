Return-Path: <kvm+bounces-57137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC03FB50709
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:27:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01CA71C65E7D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C5B352FFD;
	Tue,  9 Sep 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9aUkcU5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6A31D388;
	Tue,  9 Sep 2025 20:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449625; cv=none; b=LRernP04EIFh/ujneDjsjANOPazMbhcY1P5BDsIaGAhX3avXq9Lj27bseQdpxu0QeHc24izTHV8d345S7YxDo7HjjX68ju20CbYHxi+3O6vFOHl+IA+oIrDpbb5HtIXR7igXIGT5CC9q1it/w+VTMyonqWZ/vDKuBqKUfImHI2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449625; c=relaxed/simple;
	bh=BVe13+MC2m/oVveIu1h213AGn6SSiCnXIK1R+zDTr6c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EPpS5ooZCWg57fV+c6F1yyy010ACHD5AIA5cBRKWMaU7NEzst2+jjKxZYCr9JuVpOwEJ7ZwrfJdll+BFy5Z0kc2Ap3SLaQqjnI6FwViTdEATsH6qSay3xYcPgF778RImuLVrOHqhuXXKOy1BVa5z39ojbaKOy/4NZEYP4JxQd+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9aUkcU5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7A9C4CEF5;
	Tue,  9 Sep 2025 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757449624;
	bh=BVe13+MC2m/oVveIu1h213AGn6SSiCnXIK1R+zDTr6c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=I9aUkcU5hJwmLaUF9UVx8DuI4LoYNuy6cUXUY3R5pfCm6O5nwGX1VhvJ79+WOrhDr
	 T0kPMSA/HndaZYBvy3ZdMqnfb/ZXLEOtreiPeGNbjNfwKqAbOoJM9FmC4szW4Dip52
	 mAuyRHDt4QmmNj4THpd0k69ny88EtaUYMhU7kkbhF7naf1Izk+1AvofhOftNLaSvx3
	 rIHJVfu3yQu3lhChARpGrA867Xp7XRlPPOFje6AP6uO9PLfxPSDpnXWY3RBl0yvWeA
	 OYh0oVsjGy93yPr7UTRno9cO6ahgDnfSiOD/etryRb5aMuvBtxtHP7IuzAx5q8KZin
	 eBxginJdoX51Q==
Date: Tue, 9 Sep 2025 15:27:02 -0500
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
Subject: Re: [PATCH v3 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250909202702.GA1504205@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:18PM -0300, Jason Gunthorpe wrote:
> The current algorithm does not work if ACS is turned off, and it is not
> clear how this has been missed for so long. I think it has been avoided
> because the kernel command line options to target specific devices and
> disable ACS are rarely used.
> 
> For discussion lets consider a simple topology like the below:

s/lets consider/consider/ (or "let's")

> 
>                                -- DSP 02:00.0 -> End Point A
>  Root 00:00.0 -> USP 01:00.0 --|
>                                -- DSP 02:03.0 -> End Point B
> 
> If ACS is fully activated we expect 00:00.0, 01:00.0, 02:00.0, 02:03.0, A,
> B to all have unique single device groups.
> 
> If both DSPs have ACS off then we expect 00:00.0 and 01:00.0 to have
> unique single device groups while 02:00.0, 02:03.0, A, B are part of one
> multi-device group.
> 
> If the DSPs have asymmetric ACS, with one fully isolating and one
> non-isolating we also expect the above multi-device group result.
> 
> Instead the current algorithm always creates unique single device groups
> for this topology. It happens because the pci_device_group(DSP)
> immediately moves to the USP and computes pci_acs_path_enabled(USP) ==
> true and decides the DSP can get a unique group. The pci_device_group(A)
> immediately moves to the DSP, sees pci_acs_path_enabled(DSP) == false and
> then takes the DSPs group.

s/takes the DSPs group/takes the DSP's group/ (I guess?)

> For root-ports a PCIe topology like:

s/root-ports/Root Ports/ (also various "root port" and "root complex"
spellings below that are typically capitalized in drivers/pci/)

>                                          -- Dev 01:00.0
>   Root  00:00.00 --- Root Port 00:01.0 --|
>                   |                      -- Dev 01:00.1
> 		  |- Dev 00:17.0
> 
> Previously would group [00:01.0, 01:00.0, 01:00.1] together if there is no
> ACS capability in the root port.
> 
> While ACS on root ports is underspecified in the spec, it should still
> function as an egress control and limit access to either the MMIO of the
> root port itself, or perhaps some other devices upstream of the root
> complex - 00:17.0 perhaps in this example.

Does ACS have some kind of MMIO-specific restriction?  Oh, I guess
this must be the "Memory Target Access Control" piece?  (Added by the
upcoming patch 08/11).

> Historically the grouping in Linux has assumed the root port routes all
> traffic into the TA/IOMMU and never bypasses the TA to go to other
> functions in the root complex. Following the new understanding that ACS is
> required for internal loopback also treat root ports with no ACS
> capability as lacking internal loopback as well.
> 
> The current algorithm has several issues:
> 
>  1) It implicitly depends on ordering. Since the existing group discovery
>     only goes in the upstream direction discovering a downstream device
>     before its upstream will cause the wrong creation of narrower groups.
> 
>  2) It assumes that if the path from the end point to the root is entirely
>     ACS isolated then that end point is isolated. This misses cross-traffic
>     in the asymmetric ACS case.
> 
>  3) When evaluating a non-isolated DSP it does not check peer DSPs for an
>     already established group unless the multi-function feature does it.
> 
>  4) It does not understand the aliasing rule for PCIe to PCI bridges
>     where the alias is to the subordinate bus. The bridge's RID on the
>     primary bus is not aliased. This causes the PCIe to PCI bridge to be
>     wrongly joined to the group with the downstream devices.
> 
> As grouping is a security property for VFIO creating incorrectly narrowed
> groups is a security problem for the system.

I.e., we treated devices as being isolated from P2PDMA when they
actually were not isolated, right?  More isolation => smaller
(narrower) IOMMU groups?

> Revise the design to solve these problems.
> 
> Explicitly require ordering, or return EPROBE_DEFER if things are out of
> order. This avoids silent errors that created smaller groups and solves
> problem #1.

If it's easy to state, would be nice to say what ordering is required.
The issue mentioned above was "discovering a downstream device before
its upstream", so I guess you want to discover upstream devices before
downstream?  Obviously PCI enumeration already works that way, so
IOMMU group discovery must be a little different.

> Work on busses, not devices. Isolation is a property of the bus, and the
> first non-isolated bus should form a group containing all devices
> downstream of that bus. If all busses on the path to an end device are
> isolated then the end device has a chance to make a single-device group.
> 
> Use pci_bus_isolation() to compute the bus's isolation status based on the
> ACS flags and technology. pci_bus_isolation() touches a lot of PCI
> internals to get the information in the right format.
> 
> Add a new flag in the iommu_group to record that the group contains a
> non-isolated bus. Any downstream pci_device_group() will see
> bus->self->iommu_group is non-isolated and unconditionally join it. This
> makes the first non-isolation apply to all downstream devices and solves
> problem #2
> 
> The bus's non-isolated iommu_group will be stored in either the DSP of
> PCIe switch or the bus->self upstream device, depending on the situation.
> When storing in the DSP all the DSPs are checked first for a pre-existing
> non-isolated iommu_group. When stored in the upstream the flag forces it
> to all downstreams. This solves problem #3.
> 
> Put the handling of end-device aliases and MFD into pci_get_alias_group()
> and only call it in cases where we have a fully isolated path. Otherwise
> every downstream device on the bus is going to be joined to the group of
> bus->self.
> 
> Finally, replace the initial pci_for_each_dma_alias() with a combination
> of:
> 
>  - Directly checking pci_real_dma_dev() and enforcing ordering.
>    The group should contain both pdev and pci_real_dma_dev(pdev) which is
>    only possible if pdev is ordered after real_dma_dev. This solves a case
>    of #1.
> 
>  - Indirectly relying on pci_bus_isolation() to report legacy PCI busses
>    as non-isolated, with the enum including the distinction of the PCIe to
>    PCI bridge being isolated from the downstream. This solves problem #4.
> 
> It is very likely this is going to expand iommu_group membership in
> existing systems. After all that is the security bug that is being
> fixed. Expanding the iommu_groups risks problems for users using VFIO.
> 
> The intention is to have a more accurate reflection of the security
> properties in the system and should be seen as a security fix. However
> people who have ACS disabled may now need to enable it. As such users may
> have had good reason for ACS to be disabled I strongly recommend that
> backporting of this also include the new config_acs option so that such
> users can potentially minimally enable ACS only where needed.

Minor nits below.

> +/* Return a group if the upstream hierarchy has isolation restrictions. */
> +static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
> +{
> +	/*
> +	 * SRIOV functions may reside on a virtual bus, jump directly to the PFs
> +	 * bus in all cases.
> +	 */
> +	struct pci_bus *bus = pci_physfn(pdev)->bus;
> +	struct iommu_group *group;
> +
> +	/* Nothing upstream of this */
> +	if (pci_is_root_bus(bus))
> +		return NULL;
> +
> +	/*
> +	 * !self is only for SRIOV virtual busses which should have been
> +	 * excluded by pci_physfn()
> +	 */
> +	if (WARN_ON(!bus->self))
> +		return ERR_PTR(-EINVAL);
> +
> +	group = iommu_group_get(&bus->self->dev);
> +	if (!group) {
> +		/*
> +		 * If the upstream bridge needs the same group as pdev then
> +		 * there is no way for it's pci_device_group() to discover it.

s/it's/its/

> +		dev_err(&pdev->dev,
> +			"PCI device is probing out of order, upstream bridge device of %s is not probed yet\n",
> +			pci_name(bus->self));
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +	if (group->bus_data & BUS_DATA_PCI_NON_ISOLATED)
> +		return group;
> +	iommu_group_put(group);
> +	return NULL;
> +}
> +
> +/*
> + * For legacy PCI we have two main considerations when forming groups:
> + *
> + *  1) In PCI we can loose the RID inside the fabric, or some devices will use
> + *     the wrong RID. The PCI core calls this aliasing, but from an IOMMU
> + *     perspective it means that a PCI device may have multiple RIDs and a
> + *     single RID may represent many PCI devices. This effectively means all the
> + *     aliases must share a translation, thus group, because the IOMMU cannot
> + *     tell devices apart.

s/loose/lose/

> + *  2) PCI permits a bus segment to claim an address even if the transaction
> + *     originates from an end point not the CPU. When it happens it is called
> + *     peer to peer. Claiming a transaction in the middle of the bus hierarchy
> + *     bypasses the IOMMU translation. The IOMMU subsystem rules require these
> + *     devices to be placed in the same group because they lack isolation from
> + *     each other. In PCI Express the ACS system can be used to inhibit this and
> + *     force transactions to go to the IOMMU.
> + *
> + *     From a PCI perspective any given PCI bus is either isolating or
> + *     non-isolating. Isolating means downstream originated transactions always
> + *     progress toward the CPU and do not go to other devices on the bus
> + *     segment, while non-isolating means downstream originated transactions can
> + *     progress back downstream through another device on the bus segment.
> + *
> + *     Beyond buses a multi-function device or bridge can also allow
> + *     transactions to loop back internally from one function to another.

s/PCI Express/PCIe/ to match other usage?

Elsewhere in this series you use "busses".  "Buses" is more common in
both drivers/pci and drivers/iommu.

> + *
> + *     Once a PCI bus becomes non isolating the entire downstream hierarchy of
> + *     that bus becomes a single group.

s/non isolating/non-isolating/ to match usage above

