Return-Path: <kvm+bounces-57144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7183BB5079F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186A11746D1
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D119B242D6B;
	Tue,  9 Sep 2025 21:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rker6rYa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE9B80B;
	Tue,  9 Sep 2025 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757451820; cv=none; b=r5lF5n4mMp9BCmBI31ESM9AJeaM7QPOflbOWiZmh8YSq/dliU6/zk/0JLbRNxXlMnPO5RX7+KuwXHXKJi5UdCXRLdTSJh0arlWbYL+fm8TyOZiHcYIb8McofguPeD9/yx/N/mN9ON1L8qASrDIHASj8YiDKAbktNgRChj/7Bor4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757451820; c=relaxed/simple;
	bh=fHQCgeIfFerWfyiKnWevc0KBl+geiQXdoCwRBomFimI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=DXZjNRQppIbaVhlvHnf998zlaLE4gx6NpClfUys/M2y5UVN+rFVkO8/eWPpACLgFGdKIx4z2T0i03bVwTeEGonFCJ5qhcdWi3kC9OnxeqoMVZbNYH1YSeM1GUfMpjrGVD9LqBGOZd52m/OUgIdsDxZpQW2UjD87SIIvlcdOVhq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rker6rYa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47896C4CEF4;
	Tue,  9 Sep 2025 21:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757451818;
	bh=fHQCgeIfFerWfyiKnWevc0KBl+geiQXdoCwRBomFimI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Rker6rYavqlM4A5gbdTJTChCkhUD/zdGVai3dsg0VVvo0D8PfdNfhKKuEkAi9VxCy
	 QBj4072DohjOxPE16KKBScYpvG/ctY8ttTCI9JKCr5UmS+knmZflPvRlXBoArLzf/o
	 MTHj0K324OhfiS/4WIEYji9oSs39ja5Gn+ABKUzB7SHeQ86WDkfze0V2HiTfgZfFoU
	 5h69l3DuhOIuCOwTUA4v12omQDapX4iZxVPCqBCulWT2jNlXrSOwc4lUwgfEvHKbgB
	 WJlgEgJJgHeQEtlec/g8AcgUSEiKobCQ5qteSzFNMCPbhsAJtgm6d1vgK6knCQxv3F
	 QQz5j+0tm9ZMQ==
Date: Tue, 9 Sep 2025 16:03:36 -0500
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
Subject: Re: [PATCH v3 05/11] PCI: Add pci_reachable_set()
Message-ID: <20250909210336.GA1507895@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>

On Fri, Sep 05, 2025 at 03:06:20PM -0300, Jason Gunthorpe wrote:
> Implement pci_reachable_set() to efficiently compute a set of devices on
> the same bus that are "reachable" from a starting device. The meaning of
> reachability is defined by the caller through a callback function.
> 
> This is a faster implementation of the same logic in
> pci_device_group(). Being inside the PCI core allows use of pci_bus_sem so
> it can use list_for_each_entry() on a small list of devices instead of the
> expensive for_each_pci_dev(). Server systems can now have hundreds of PCI
> devices, but typically only a very small number of devices per bus.
> 
> An example of a reachability function would be pci_devs_are_dma_aliases()
> which would compute a set of devices on the same bus that are
> aliases. This would also be useful in future support for the ACS P2P
> Egress Vector which has a similar reachability problem.
> 
> This is effectively a graph algorithm where the set of devices on the bus
> are vertexes and the reachable() function defines the edges. It returns a
> set of vertexes that form a connected graph.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/pci/search.c | 90 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h  | 12 ++++++
>  2 files changed, 102 insertions(+)
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index fe6c07e67cb8ce..dac6b042fd5f5d 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -595,3 +595,93 @@ int pci_dev_present(const struct pci_device_id *ids)
>  	return 0;
>  }
>  EXPORT_SYMBOL(pci_dev_present);
> +
> +/**
> + * pci_reachable_set - Generate a bitmap of devices within a reachability set
> + * @start: First device in the set
> + * @devfns: The set of devices on the bus

@devfns is a return parameter, right?  Maybe mention that somewhere?
And the fact that the set only includes the *reachable* devices on the
bus.

> + * @reachable: Callback to tell if two devices can reach each other
> + *
> + * Compute a bitmap where every set bit is a device on the bus that is reachable
> + * from the start device, including the start device. Reachability between two
> + * devices is determined by a callback function.
> + *
> + * This is a non-recursive implementation that invokes the callback once per
> + * pair. The callback must be commutative:
> + *    reachable(a, b) == reachable(b, a)
> + * reachable() can form a cyclic graph:
> + *    reachable(a,b) == reachable(b,c) == reachable(c,a) == true
> + *
> + * Since this function is limited to a single bus the largest set can be 256
> + * devices large.
> + */
> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
> +		       bool (*reachable)(struct pci_dev *deva,
> +					 struct pci_dev *devb))
> +{
> +	struct pci_reachable_set todo_devfns = {};
> +	struct pci_reachable_set next_devfns = {};
> +	struct pci_bus *bus = start->bus;
> +	bool again;
> +
> +	/* Assume devfn of all PCI devices is bounded by MAX_NR_DEVFNS */
> +	static_assert(sizeof(next_devfns.devfns) * BITS_PER_BYTE >=
> +		      MAX_NR_DEVFNS);
> +
> +	memset(devfns, 0, sizeof(devfns->devfns));
> +	__set_bit(start->devfn, devfns->devfns);
> +	__set_bit(start->devfn, next_devfns.devfns);
> +
> +	down_read(&pci_bus_sem);
> +	while (true) {
> +		unsigned int devfna;
> +		unsigned int i;
> +
> +		/*
> +		 * For each device that hasn't been checked compare every
> +		 * device on the bus against it.
> +		 */
> +		again = false;
> +		for_each_set_bit(devfna, next_devfns.devfns, MAX_NR_DEVFNS) {
> +			struct pci_dev *deva = NULL;
> +			struct pci_dev *devb;
> +
> +			list_for_each_entry(devb, &bus->devices, bus_list) {
> +				if (devb->devfn == devfna)
> +					deva = devb;
> +
> +				if (test_bit(devb->devfn, devfns->devfns))
> +					continue;
> +
> +				if (!deva) {
> +					deva = devb;
> +					list_for_each_entry_continue(
> +						deva, &bus->devices, bus_list)
> +						if (deva->devfn == devfna)
> +							break;
> +				}
> +
> +				if (!reachable(deva, devb))
> +					continue;
> +
> +				__set_bit(devb->devfn, todo_devfns.devfns);
> +				again = true;
> +			}
> +		}
> +
> +		if (!again)
> +			break;
> +
> +		/*
> +		 * Every new bit adds a new deva to check, reloop the whole
> +		 * thing. Expect this to be rare.
> +		 */
> +		for (i = 0; i != ARRAY_SIZE(devfns->devfns); i++) {
> +			devfns->devfns[i] |= todo_devfns.devfns[i];
> +			next_devfns.devfns[i] = todo_devfns.devfns[i];
> +			todo_devfns.devfns[i] = 0;
> +		}
> +	}
> +	up_read(&pci_bus_sem);
> +}
> +EXPORT_SYMBOL_GPL(pci_reachable_set);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index fb9adf0562f8ef..21f6b20b487f8d 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -855,6 +855,10 @@ struct pci_dynids {
>  	struct list_head	list;	/* For IDs added at runtime */
>  };
>  
> +struct pci_reachable_set {
> +	DECLARE_BITMAP(devfns, 256);
> +};
> +
>  enum pci_bus_isolation {
>  	/*
>  	 * The bus is off a root port and the root port has isolated ACS flags
> @@ -1269,6 +1273,9 @@ struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
>  struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
>  struct pci_dev *pci_get_base_class(unsigned int class, struct pci_dev *from);
>  
> +void pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
> +		       bool (*reachable)(struct pci_dev *deva,
> +					 struct pci_dev *devb));
>  enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus);
>  
>  int pci_dev_present(const struct pci_device_id *ids);
> @@ -2084,6 +2091,11 @@ static inline struct pci_dev *pci_get_base_class(unsigned int class,
>  						 struct pci_dev *from)
>  { return NULL; }
>  
> +static inline void
> +pci_reachable_set(struct pci_dev *start, struct pci_reachable_set *devfns,
> +		  bool (*reachable)(struct pci_dev *deva, struct pci_dev *devb))
> +{ }
> +
>  static inline enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
>  { return PCIE_NON_ISOLATED; }
>  
> -- 
> 2.43.0
> 

