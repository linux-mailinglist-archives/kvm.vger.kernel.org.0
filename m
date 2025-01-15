Return-Path: <kvm+bounces-35515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1158A11BB4
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 09:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D54D416670D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 08:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA15424635B;
	Wed, 15 Jan 2025 08:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtS4YogD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30DC1DB150;
	Wed, 15 Jan 2025 08:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929052; cv=none; b=Y/zBce6A2YuCB7Wwb36PZweG4WOEh4vIBW/6KXdRAZ/h+vh29ZzT/5b3gcA+gWLMZxWEto0Cc4NdjBz1SA3ZaUjMRgcajoGfi9cTZTXQPqVWpBcjwevoKKXsJgdksWzSH9heuW+h8VOLyZG5LD1V/uFpbL/BRiUnChJelBtNIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929052; c=relaxed/simple;
	bh=Yu7S/jLyUGhfFZjVFlk4eprtZYRxfla2Nw7nZEhy9no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nHYM0FRi8hR27xAay804JFfYHPqR3c82VSXMvKjfyg+QXHjtLGrSfPvg8YvzraFY5uzrD+nzXRJ6oU7mjTcCMC3SERRuwDd4M0aNXS3AyQiTjotk7MOkQPXV/DVsOZp9i4u8hGXSvOLfaJewEvIVI8kh67Xrz2ckXvM+4NASUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtS4YogD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD6DC4CEDF;
	Wed, 15 Jan 2025 08:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736929050;
	bh=Yu7S/jLyUGhfFZjVFlk4eprtZYRxfla2Nw7nZEhy9no=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jtS4YogDlGBJKPE4uxCOLjxH7XCi5QYsOo4leoD+xgmN8tj70qVx5829WIg+sShgX
	 yiakEsBadvxORmzL2tNvh64PTbxN2Yn7ZjPr4SYb84VfV3NxFD7kGP/KdoZOcX+tov
	 rQJGthlfV+pWswtBJZw2US2akwQ3E9tQt/jwG/ICtUFlz/2ySVXe68KJv7W8xdw1OU
	 pIcG2l3K1LSF8572QwfNaFSMofL4ExapBuk12HqOU0whbiq9SaXUul7IQT4rV47kiH
	 Y6/VezMg1RWwWJ+XN6OfK0HDAZ0irI3FF3+Tw83vfWul8FBVAnUy0tZrZ3zZK1Ybu0
	 cyRrXOGYV/nDQ==
Date: Wed, 15 Jan 2025 10:17:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 05/17] dma-mapping: Provide an interface to allow
 allocate IOVA
Message-ID: <20250115081726.GK3146852@unreal>
References: <cover.1734436840.git.leon@kernel.org>
 <fac6bc6fdcf8e13bd5668386d36289ee38a8a95b.1734436840.git.leon@kernel.org>
 <ecb59036-b279-4412-9a09-40e05af3b9ea@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecb59036-b279-4412-9a09-40e05af3b9ea@arm.com>

On Tue, Jan 14, 2025 at 08:50:28PM +0000, Robin Murphy wrote:
> On 17/12/2024 1:00 pm, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The existing .map_page() callback provides both allocating of IOVA
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
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   drivers/iommu/dma-iommu.c   | 74 +++++++++++++++++++++++++++++++++++++
> >   include/linux/dma-mapping.h | 49 ++++++++++++++++++++++++
> >   2 files changed, 123 insertions(+)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index 853247c42f7d..5906b47a300c 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1746,6 +1746,80 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
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
> > + *
> > + * Returns %true if the IOVA-based DMA API can be used and IOVA space has been
> > + * allocated, or %false if the regular DMA API should be used.
> > + */
> > +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> > +		phys_addr_t phys, size_t size)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	size_t iova_off = iova_offset(iovad, phys);
> > +	dma_addr_t addr;
> > +
> > +	memset(state, 0, sizeof(*state));
> > +	if (!use_dma_iommu(dev))
> > +		return false;
> 
> Can you guess why that return won't ever be taken?

I will move references to pointers after this check, but like Christoph
said, this "if ..." is taken a lot and we didn't see any issues with
inbox GCC versions.

> 
> > +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> > +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> > +		return false;
> > +
> > +	if (WARN_ON_ONCE(!size))
> > +		return false;
> > +	if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
> 
> This looks weird. Why would a caller ever set an effectively-private flag in
> the first place? If it's actually supposed to be a maximum size check,
> please make it look like a maximum size check.

It is in-kernel API and the idea is to warn developers of something that
is not right and not perform defensive programming by doing size checks.

<...>

> > +/**
> > + * dma_iova_free - Free an IOVA space
> > + * @dev: Device to free the IOVA space for
> > + * @state: IOVA state
> > + *
> > + * Undoes a successful dma_try_iova_alloc().
> > + *
> > + * Note that all dma_iova_link() calls need to be undone first.  For callers
> > + * that never call dma_iova_unlink(), dma_iova_destroy() can be used instead
> > + * which unlinks all ranges and frees the IOVA space in a single efficient
> > + * operation.
> 
> That's only true if they *also* call dma_iova_link() in just the right way
> too.

We can update the comment section to any wording, feel free to propose.

> 
> > + */
> > +void dma_iova_free(struct device *dev, struct dma_iova_state *state)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	size_t iova_start_pad = iova_offset(iovad, state->addr);
> > +	size_t size = dma_iova_size(state);
> > +
> > +	iommu_dma_free_iova(cookie, state->addr - iova_start_pad,
> > +			iova_align(iovad, size + iova_start_pad), NULL);
> > +}
> > +EXPORT_SYMBOL_GPL(dma_iova_free);
> > +
> >   void iommu_setup_dma_ops(struct device *dev)
> >   {
> >   	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index b79925b1c433..55899d65668b 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -7,6 +7,8 @@
> >   #include <linux/dma-direction.h>
> >   #include <linux/scatterlist.h>
> >   #include <linux/bug.h>
> > +#include <linux/mem_encrypt.h>
> > +#include <linux/iommu.h>
> 
> Why are these being pulled in here?

It is rebase leftover.

> 
> >   /**
> >    * List of possible attributes associated with a DMA mapping. The semantics
> > @@ -72,6 +74,21 @@
> >   #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
> > +struct dma_iova_state {
> > +	dma_addr_t addr;
> > +	size_t __size;
> > +};
> > +
> > +/*
> > + * Use the high bit to mark if we used swiotlb for one or more ranges.
> > + */
> > +#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
> 
> This will give surprising results for 32-bit size_t (in fact I guess it
> might fire some build warnings already).

We got none, I will change to u64.

> 
> Thanks,
> Robin.

Thanks

