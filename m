Return-Path: <kvm+bounces-57132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3380B5069F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75C81C64D98
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A8730506E;
	Tue,  9 Sep 2025 19:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="knODBuXS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410C26981E;
	Tue,  9 Sep 2025 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757447652; cv=none; b=geHxjSc1TPmyJWTOxT3enGZLYCWVEJR0qZxih80wPkvxmdA54bfeEGy5+/0CF2Vea8rMCgAlmPy5YkQUiyUCCfJI/a3PTkouT/18pu3jmNbVzIXpwHW153XSmagMKrjVWx1YcIYiVixi2rIAR08gbbPruWAZ5Yt9MZuzUJXP3f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757447652; c=relaxed/simple;
	bh=zzCw2qcd4aLJ0aUiMPrvAmEp4Z8C5mHBYfMb5yXTslU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=fG7lFJAN2KB7+xdSnuPWJ9n5pg5sTp7frQgCrJn5fA41w3705ABaRj9XZhKYybFleIJ24TKW+fTFCVIzOAofE6WBhHfn941xdpjW/PSnRD25soTQ7hfweqF7/+B6nfEb/zfIaiAUsO3duX4gZTjFjPn+BN2ClMtiwssJ7jlA+Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=knODBuXS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48814C4CEF4;
	Tue,  9 Sep 2025 19:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757447651;
	bh=zzCw2qcd4aLJ0aUiMPrvAmEp4Z8C5mHBYfMb5yXTslU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=knODBuXS4Hy5vfuYvTJR7B/1AjtY8I4UsR2CPPYOPY7QMOE+OfIOxAqCELYE4V9kN
	 1FIu71aXvvGm9jnrrNXqF/hrrkWHdxbqxmQVn3HORlhluX5ixDwFfmJovcAdWeQdN6
	 qNJ0fBgDfV/AxCsLZx8dkOpjEwrlRTrL8OK8lRtdZZ1GI/ZErjNNu0aLAdWhYQnvfC
	 tbXMn75UZNwAeMChbT/uL2XfWDZGOzh4T9j4GA1tS7RFxme9E+7Z7POkeE5yNdvIgu
	 OBiyV1aAqohv4wCSRk7nPmvP5h8SNeUb6RLWwBCAQQjUUSiYQ/6sSWDJxr86h8OUzM
	 cpBlrZRxpQnAw==
Date: Tue, 9 Sep 2025 14:54:09 -0500
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
Subject: Re: [PATCH v3 02/11] PCI: Add pci_bus_isolated()
Message-ID: <20250909195409.GA1494873@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:17PM -0300, Jason Gunthorpe wrote:
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

I guess a device being isolated means that peer-to-peer Requests from
a different bus can't reach it?

Did you mean "Root Port" instead of "Root Complex"?  Or are you
assuming an ACS Capability in an RCRB?  (I don't think Linux supports
RCRBs, except maybe for CXL)

> Multi-function devices also have an isolation concern with self loopback
> between the functions, though pci_bus_isolated() does not deal with
> devices.

It looks like multi-function devices *can* implement ACS and can
isolate functions from each other (PCIe r7.0, sec 6.12.1.2).  But it
sounds like we're ignoring peer-to-peer on the same bus for now and
assuming devices on the same bus can't be isolated from each other?

If we ignore ACS on non-bridge multi-function devices, I think the
only way to isolate things is bridge ACS that controls forwarding
between buses.  If everything on the bus must be in the same group, it
makes sense for pci_bus_isolated() to take a pci_bus pointer and not
deal with individual devices.

Below, it seems like sometimes we refer to *buses* being isolated and
other times *devices* (Root Port, Switch Port, Switch, etc), so I'm a
little confused.

> As a property of a bus, there are several positive cases:
> 
>  - The point to point "bus" on a physical PCIe link is isolated if the
>    bridge/root device has something preventing self-access to its own
>    MMIO.
>
>  - A Root Port is usually isolated
>
>  - A PCIe switch can be isolated if all it's Down Stream Ports have good
>    ACS flags

I guess this is saying that a switch's internal bus is isolated if all
the DSPs have the ACS flags we need?

s/it's/its/
s/Down Stream Ports/Downstream Ports/

> pci_bus_isolated() implements these rules and returns an enum indicating
> the level of isolation the bus has, with five possibilies:
> 
>  PCIE_ISOLATED: Traffic on this PCIE bus can not do any P2P.

Is this saying that peer-to-peer Requests can't reach devices on this
bus?  Or Requests *from* this bus can only go to the IOMMU?

>  PCIE_SWITCH_DSP_NON_ISOLATED: The bus is the internal bus of a PCIE
>      switch and the USP is isolated but the DSPs are not.
> 
>  PCIE_NON_ISOLATED: The PCIe bus has no isolation between the bridge or
>      any downstream devices.
> 
>  PCI_BUS_NON_ISOLATED: It is a PCI/PCI-X but the bridge is PCIe, has no
>      aliases and the bridge is isolated from the bus.

s|PCI/PCI-X|PCI/PCI-X bus| to match below?

>  PCI_BRIDGE_NON_ISOLATED: It is a PCI/PCI-X bus and has no isolation, the
>      bridge is part of the group.
> 
> The calculation is done per-bus, so it is possible for a transactions from
> a PCI device to travel through different bus isolation types on its way
> upstream. PCIE_SWITCH_DSP_NON_ISOLATED/PCI_BUS_NON_ISOLATED and
> PCIE_NON_ISOLATED/PCI_BRIDGE_NON_ISOLATED are the same for the purposes of
> creating iommu groups. The distinction between PCIe and PCI allows for
> easier understanding and debugging as to why the groups are chosen.

s/for a transactions/for a transaction/

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
>  drivers/pci/search.c | 174 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h  |  31 ++++++++
>  2 files changed, 205 insertions(+)
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 53840634fbfc2b..fe6c07e67cb8ce 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -113,6 +113,180 @@ int pci_for_each_dma_alias(struct pci_dev *pdev,
>  	return ret;
>  }
>  
> +static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
> +{
> +	struct pci_dev *pdev;
> +
> +	/*
> +	 * Within a PCIe switch we have an interior bus that has the Upstream
> +	 * port as the bridge and a set of Downstream port bridging to the
> +	 * egress ports.

s/interior/internal/ to match commit log and use below
s/Upstream port/Upstream Port/
s/set of Downstream port/set of Downstream Ports/

> +	 *
> +	 * Each DSP has an ACS setting which controls where its traffic is
> +	 * permitted to go. Any DSP with a permissive ACS setting can send
> +	 * traffic flowing upstream back downstream through another DSP.
> +	 *
> +	 * Thus any non-permissive DSP spoils the whole bus.

s/non-permissive/permissive/ ?  seems backwards to me

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

I would say "isolation" is something about the ability to *prevent*
devices from talking to each other.

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

s/PCI/PCIe/ since other text here is pretty consistent about
distinguishing them

Maybe s/if a PCI switch/if it/, since they must refer to the same
device.

> + * Old PCI/PCI-X busses cannot have isolation due to their physical properties,
> + * but they do have some aliasing properties that effect group creation.

s/effect/affect/

> + * pci_bus_isolated() does not consider loopback internal to devices, like
> + * multi-function devices performing a self-loopback. The caller must check
> + * this separately. It does not considering alasing within the bus.

s/alasing/aliasing/ (I guess this refers to the
PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS thing where a bridge takes ownership?)

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

s/VF RIDs/VFs/  I think?  I think we allocate these virtual bus
numbers when enabling the VFs.

> +	if (WARN_ON(!bridge))
> +		return PCI_BRIDGE_NON_ISOLATED;
> +
> +	/*
> +	 * The bridge is not a PCIe bridge therefore this bus is PCI/PCI-X.
> +	 *
> +	 * PCI does not have anything like ACS. Any down stream device can bus
> +	 * master an address that any other downstream device can claim. No
> +	 * isolation is possible.

s/down stream device/downstream device/

I guess this comment applies to the !pci_is_pcie() branch below?
Maybe it should go inside the "if"?

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

s/interior/internal/ to match use above
s/PCI-E/PCIe/

I'm not sure what this is saying.  A USP can't have an ACS Capability
unless it's part of a multi-function device.

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

s/PCIe express/PCIe/

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
>  static struct pci_bus *pci_do_find_bus(struct pci_bus *bus, unsigned char busnr)
>  {
>  	struct pci_bus *child;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 59876de13860db..c36fff9d2254f8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -855,6 +855,32 @@ struct pci_dynids {
>  	struct list_head	list;	/* For IDs added at runtime */
>  };
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
>  /*
>   * PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
> @@ -1243,6 +1269,8 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
>  struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
>  struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
>  
> +enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
> +
>  int pci_dev_present(const struct pci_device_id *ids);
>  
>  int pci_bus_read_config_byte(struct pci_bus *bus, unsigned int devfn,
> @@ -2056,6 +2084,9 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
>  						 struct pci_dev *from)
>  { return NULL; }
>  
> +static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
> +{ return PCIE_NON_ISOLATED; }
> +
>  static inline int pci_dev_present(const struct pci_device_id *ids)
>  { return 0; }
>  
> -- 
> 2.43.0
> 

