Return-Path: <kvm+bounces-44681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B9C5AA01F7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F4AB1A86417
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767E22741D6;
	Tue, 29 Apr 2025 05:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPIJHlt8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E8D171E43;
	Tue, 29 Apr 2025 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745905568; cv=none; b=pnmEHfJWmMhFSBUO3hbC3OwQ1tBGXxvSF7YZn1XLglF6bm6l8kc5yixCipDSMpQUJEIVy3nAXGmomhjn87gv9jwd4Pb7QKGi1qN5QM6IdmwzuJb0VDVVm4hcehSrh7kmZVjiPyFH8sWLyAwlGr3eoKanCdxjbCoJ1cX/zUb4Ta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745905568; c=relaxed/simple;
	bh=ZlzjgR8ZCmhh7ln3bWsTRkN7njOkthtsCcGhOVJD370=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cyzc7J4DORps3PTLSoeFwWSM2YP9FnaIrbUc3wxDiNjCB35VDEqIgm4JDJM6w/q5s4MJHz+JntidSZWe7zaniJUoHQ+HveWIi2sieb8RkuQFlK7LPwcVIMCyHGHj0xtTEKf2Okf0gNSfprXGF1DWB9xFg93bzBg3IDJijYJfhlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPIJHlt8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF06C4CEE3;
	Tue, 29 Apr 2025 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745905567;
	bh=ZlzjgR8ZCmhh7ln3bWsTRkN7njOkthtsCcGhOVJD370=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OPIJHlt8bTW2SZgZvCQl0TtC/C7oWnwza0G162u6trNqiDyxNtzHYyjIBFxHIMyHP
	 kNYqu6Gd4ME2eiPecfo02OZnUJNpPqZ11ior8m1BTlK5ogMz8NZw8SNe7GhZl9kwTJ
	 AE9Uu94aifbn/PGHOYs6Xv+jxIIqUi/Vde5glUd+VZ5LXI9CAkEAbHZUqkqCHxgTf8
	 5FlvFRf8qZr6a1Vlk2E6XTcc/QgHu16QEmaS6D/ZS8tOk76ZJl2EWdi8dagzkXZD/z
	 cAVfMvTVwCBZimzwv4w3tYH/7v26KFBOlhohXUM8B1HoNMgXXtnUSEr5ZpJvKIxX2N
	 MhsioMleKoeXg==
Date: Tue, 29 Apr 2025 08:46:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v10 05/24] dma-mapping: Provide an interface to allow
 allocate IOVA
Message-ID: <20250429054602.GI5848@unreal>
References: <cover.1745831017.git.leon@kernel.org>
 <30f0601d400711b3859deeb8fef3090f5b2020a4.1745831017.git.leon@kernel.org>
 <0086302d-1cb3-43dd-a989-e4b1995a0d22@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0086302d-1cb3-43dd-a989-e4b1995a0d22@linux.intel.com>

On Tue, Apr 29, 2025 at 11:10:54AM +0800, Baolu Lu wrote:
> On 4/28/25 17:22, Leon Romanovsky wrote:
> > From: Leon Romanovsky<leonro@nvidia.com>
> > 
> > The existing .map_page() callback provides both allocating of IOVA
> 
> .map_pages()

Changed, thanks

> 
> > and linking DMA pages. That combination works great for most of the
> > callers who use it in control paths, but is less effective in fast
> > paths where there may be multiple calls to map_page().
> > 
> > These advanced callers already manage their data in some sort of
> > database and can perform IOVA allocation in advance, leaving range
> > linkage operation to be in fast path.
> > 
> > Provide an interface to allocate/deallocate IOVA and next patch
> > link/unlink DMA ranges to that specific IOVA.
> > 
> > In the new API a DMA mapping transaction is identified by a
> > struct dma_iova_state, which holds some recomputed information
> > for the transaction which does not change for each page being
> > mapped, so add a check if IOVA can be used for the specific
> > transaction.
> > 
> > The API is exported from dma-iommu as it is the only implementation
> > supported, the namespace is clearly different from iommu_* functions
> > which are not allowed to be used. This code layout allows us to save
> > function call per API call used in datapath as well as a lot of boilerplate
> > code.
> > 
> > Reviewed-by: Christoph Hellwig<hch@lst.de>
> > Tested-by: Jens Axboe<axboe@kernel.dk>
> > Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> > Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> > ---
> >   drivers/iommu/dma-iommu.c   | 86 +++++++++++++++++++++++++++++++++++++
> >   include/linux/dma-mapping.h | 48 +++++++++++++++++++++
> >   2 files changed, 134 insertions(+)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index 9ba8d8bc0ce9..d3211a8d755e 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1723,6 +1723,92 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
> >   	return SIZE_MAX;
> >   }
> > +/**
> > + * dma_iova_try_alloc - Try to allocate an IOVA space
> > + * @dev: Device to allocate the IOVA space for
> > + * @state: IOVA state
> > + * @phys: physical address
> > + * @size: IOVA size
> > + *
> > + * Check if @dev supports the IOVA-based DMA API, and if yes allocate IOVA space
> > + * for the given base address and size.
> > + *
> > + * Note: @phys is only used to calculate the IOVA alignment. Callers that always
> > + * do PAGE_SIZE aligned transfers can safely pass 0 here.
> 
> Have you considered adding a direct alignment parameter to
> dma_iova_try_alloc()? '0' simply means the default PAGE_SIZE alignment.
> 
> I'm imagining that some devices might have particular alignment needs
> for better performance, especially for the ATS cache efficiency. This
> would allow those device drivers to express the requirements directly
> during iova allocation.

This is actually what is happening now, take a look in
blk_rq_dma_map_iter_start() implementation, which uses custom alignment.

> 
> > + *
> > + * Returns %true if the IOVA-based DMA API can be used and IOVA space has been
> > + * allocated, or %false if the regular DMA API should be used.
> > + */
> > +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> > +		phys_addr_t phys, size_t size)
> > +{
> > +	struct iommu_dma_cookie *cookie;
> > +	struct iommu_domain *domain;
> > +	struct iova_domain *iovad;
> > +	size_t iova_off;
> > +	dma_addr_t addr;
> > +
> > +	memset(state, 0, sizeof(*state));
> > +	if (!use_dma_iommu(dev))
> > +		return false;
> > +
> > +	domain = iommu_get_dma_domain(dev);
> > +	cookie = domain->iova_cookie;
> > +	iovad = &cookie->iovad;
> > +	iova_off = iova_offset(iovad, phys);
> > +
> > +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> > +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> > +		return false;
> > +
> > +	if (WARN_ON_ONCE(!size))
> > +		return false;
> > +
> > +	/*
> > +	 * DMA_IOVA_USE_SWIOTLB is flag which is set by dma-iommu
> > +	 * internals, make sure that caller didn't set it and/or
> > +	 * didn't use this interface to map SIZE_MAX.
> > +	 */
> > +	if (WARN_ON_ONCE((u64)size & DMA_IOVA_USE_SWIOTLB))
> 
> I'm a little concerned that device drivers might inadvertently misuse
> the state->__size by forgetting about the high bit being used for
> DMA_IOVA_USE_SWIOTLB. Perhaps adding a separate flag within struct
> dma_iova_state to prevent such issues?

Device drivers are not supposed to use this DMA API interface and the
vision that subsystems will provide specific to them wrappers. See HMM,
and block changes as an example. VFIO mlx5 implementation is a temporary
measure till we convert another VFIO LM driver to get understanding what
type of abstraction we will need.

The high bit is used to save memory.

> 
> > +		return false;
> > +
> > +	addr = iommu_dma_alloc_iova(domain,
> > +			iova_align(iovad, size + iova_off),
> > +			dma_get_mask(dev), dev);
> > +	if (!addr)
> > +		return false;
> > +
> > +	state->addr = addr + iova_off;
> > +	state->__size = size;
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(dma_iova_try_alloc);
> 
> Thanks,
> baolu
> 

