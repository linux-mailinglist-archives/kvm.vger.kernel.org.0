Return-Path: <kvm+bounces-44494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F36C3A9E0AF
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 10:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33646188EEAA
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 08:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3974824A044;
	Sun, 27 Apr 2025 08:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/Og4bFj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE5F8BE7;
	Sun, 27 Apr 2025 08:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745741599; cv=none; b=AXt6OT6qujARVFBUhoLNMN/dYFlxEZzzwttgZhxSBucwfNf277IKW6h6yCOzuvTmIsOguwIIzc5KFjzDA+7c7NQFZyDno2r/Vw1wLepN8jPSsO0R9UQ93bJIhisBz5qeuKwcIoId4XtwsVyFuCcacODRZD1Bvqxz/lhLNTPx2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745741599; c=relaxed/simple;
	bh=n1LP0hWDAYYPPGoxCmhHUpx37KloYPiSW/LsrkJ+pog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ck3+Dr72d+ZWiBqQdru1YnbO9WYjNmjpoNDItlRUyQt7WjfQx9qakiZbJ3ORxYR2HaJZkkOAe8pTEHIxN2uIe6JGkDVtjh0w8w1tmxWOicCZLvs0Q88J24gMZSz2o3TxdTDGVQ42a7f4RVaAdMDkilu7jP5Gx8haG+QMu1fCn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/Og4bFj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103DBC4CEE3;
	Sun, 27 Apr 2025 08:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745741598;
	bh=n1LP0hWDAYYPPGoxCmhHUpx37KloYPiSW/LsrkJ+pog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l/Og4bFjNyyLOyqiobd0OX+NlvlhiWMjlqCuR7bjQ3koqjqNsiHAbxhyy+n6EFWpx
	 F0s02toBkpYSqLGr5zllGOwnm/YR+cBtijfhM7TVWEWRlqZZD7tdVQ2f1cr6H3j+vY
	 /V4qD4omORMMjdDmZK0stm+5Mw4PJdjUhKlKsl6UBn8mYclrE4YOqm0/14yFLod31h
	 ZCy3hMjY93C/oDHv0y2/amWuCxtPm2rAUMkBEU2/j5WJZJ36ZRGs00HmVVhJdNAAU3
	 OAmjF5VOgM3oeArUzKcU+xI7P+9v0yugvVf2x9c6hhu7fKaqUTKAgYRmAQgjnW9EMm
	 4KL9ASZVaAifQ==
Date: Sun, 27 Apr 2025 11:13:12 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
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
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 07/24] dma-mapping: Implement link/unlink ranges API
Message-ID: <20250427081312.GE5848@unreal>
References: <cover.1745394536.git.leon@kernel.org>
 <2d6ca43ef8d26177d7674b9e3bdf0fe62b55a7ed.1745394536.git.leon@kernel.org>
 <aA1iRtCsPkuprI-X@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aA1iRtCsPkuprI-X@bombadil.infradead.org>

On Sat, Apr 26, 2025 at 03:46:30PM -0700, Luis Chamberlain wrote:
> On Wed, Apr 23, 2025 at 11:12:58AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Introduce new DMA APIs to perform DMA linkage of buffers
> > in layers higher than DMA.
> > 
> > In proposed API, the callers will perform the following steps.
> > In map path:
> > 	if (dma_can_use_iova(...))
> > 	    dma_iova_alloc()
> > 	    for (page in range)
> > 	       dma_iova_link_next(...)
> > 	    dma_iova_sync(...)
> > 	else
> > 	     /* Fallback to legacy map pages */
> >              for (all pages)
> > 	       dma_map_page(...)
> > 
> > In unmap path:
> > 	if (dma_can_use_iova(...))
> > 	     dma_iova_destroy()
> > 	else
> > 	     for (all pages)
> > 		dma_unmap_page(...)
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Tested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/iommu/dma-iommu.c   | 261 ++++++++++++++++++++++++++++++++++++
> >  include/linux/dma-mapping.h |  32 +++++
> >  2 files changed, 293 insertions(+)
> > 
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index d2c298083e0a..2e014db5a244 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -1818,6 +1818,267 @@ void dma_iova_free(struct device *dev, struct dma_iova_state *state)
> >  }
> >  EXPORT_SYMBOL_GPL(dma_iova_free);
> >  
> > +static int __dma_iova_link(struct device *dev, dma_addr_t addr,
> > +		phys_addr_t phys, size_t size, enum dma_data_direction dir,
> > +		unsigned long attrs)
> > +{
> > +	bool coherent = dev_is_dma_coherent(dev);
> > +
> > +	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> > +		arch_sync_dma_for_device(phys, size, dir);
> 
> So arch_sync_dma_for_device() is a no-op on some architectures, notably x86.
> So since you're doing this work and given the above pattern is common on
> the non iova case, we could save ourselves 2 branches checks on x86 on
> __dma_iova_link() and also generalize savings for the non-iova case as
> well. For the non-iova case we have two use cases, one with the attrs on
> initial mapping, and one without on subsequent sync ops. For the iova
> case the attr is always consistently used.

I want to believe that compiler will discards these "if (!coherent &&
!(attrs & DMA_ATTR_SKIP_CPU_SYNC)))" branch if case is empty.

> 
> So we could just have something like this:
> 
> #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE
> static inline void arch_sync_dma_device(struct device *dev,
>                                         phys_addr_t paddr, size_t size,
>                                         enum dma_data_direction dir)
> {
>     if (!dev_is_dma_coherent(dev))
>         arch_sync_dma_for_device(paddr, size, dir);
> }
> 
> static inline void arch_sync_dma_device_attrs(struct device *dev,
>                                               phys_addr_t paddr, size_t size,
>                                               enum dma_data_direction dir,
>                                               unsigned long attrs)
> {
>     if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
>         arch_sync_dma_for_device(paddr, size, dir);
> }
> #else
> static inline void arch_sync_dma_device(struct device *dev,
>                                         phys_addr_t paddr, size_t size,
>                                         enum dma_data_direction dir)
> {
> }
> 
> static inline void arch_sync_dma_device_attrs(struct device *dev,
>                                               phys_addr_t paddr, size_t size,
>                                               enum dma_data_direction dir,
>                                               unsigned long attrs)
> {
> }
> #endif

The problem is that dev_is_dma_coherent() and DMA_ATTR_SKIP_CPU_SYNC
checks are scattered over all dma-iommu.c file with different
combinations. While we can do new static functions for small number of
use cases, it will be half-solution.

> 
> > +/**
> > + * dma_iova_link - Link a range of IOVA space
> > + * @dev: DMA device
> > + * @state: IOVA state
> > + * @phys: physical address to link
> > + * @offset: offset into the IOVA state to map into
> > + * @size: size of the buffer
> > + * @dir: DMA direction
> > + * @attrs: attributes of mapping properties
> > + *
> > + * Link a range of IOVA space for the given IOVA state without IOTLB sync.
> > + * This function is used to link multiple physical addresses in contiguous
> > + * IOVA space without performing costly IOTLB sync.
> > + *
> > + * The caller is responsible to call to dma_iova_sync() to sync IOTLB at
> > + * the end of linkage.
> > + */
> > +int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> > +		phys_addr_t phys, size_t offset, size_t size,
> > +		enum dma_data_direction dir, unsigned long attrs)
> > +{
> > +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> > +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> > +	struct iova_domain *iovad = &cookie->iovad;
> > +	size_t iova_start_pad = iova_offset(iovad, phys);
> > +
> > +	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
> > +		return -EIO;
> > +
> > +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
> 
> There is already a similar check for the non-iova case for this on
> iommu_dma_map_page() and a nice comment about what why this checked,
> this seems to be just screaming for a helper:
> 
> /*                                                                       
>  * Checks if a physical buffer has unaligned boundaries with respect to
>  * the IOMMU granule. Returns non-zero if either the start or end
>  * address is not aligned to the granule boundary.
> */
> static inline size_t iova_unaligned(struct iova_domain *iovad,
>                                     phys_addr_t phys,
> 				    size_t size)
> {                                                                                
> 	return iova_offset(iovad, phys | size);
> }  

I added this function, thanks.
 
> Other than that, looks good.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> 
>   Luis

