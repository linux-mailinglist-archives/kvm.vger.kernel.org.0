Return-Path: <kvm+bounces-32017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C48129D145C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 16:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D3A5B2862C
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 14:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C486D1ADFE4;
	Mon, 18 Nov 2024 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6Bg2k8C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCC113D518;
	Mon, 18 Nov 2024 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941979; cv=none; b=EuAyZcZ5COrNDoEhNt7hNIYs5PobeNgvmGhYRqLWtTqArK73dpcGwbvJ5pSL8gx9HKYQFY+Jj8AtT29D9cms6IH6TWDuoyLizyb0d8Ywj4I2uE/wypGjv/ok1XrBZmy6e3QEAx2u9oF5G9V3blh1GfopHMGDNeMFzUUWtmPweGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941979; c=relaxed/simple;
	bh=B8pGggj3ynn83Ub48krJi7CHfczmBiFlV+ZzKagAU8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/d9wvR+6XtDC8PYFYizEURs90zApDyiYz26Im3mnMH3wSYtg71gf9TQyALRTpxQj3eaeyRS5U8dAIQggiuMXO8z6s8D1kbPAFs6sj1bssleTroQg3LqOT9Kj7Pz9J9lCvCkmVvZBoHp2t5ydTd8MF9Grbt030Lp4j1eF5hXbuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6Bg2k8C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6BEC4CECC;
	Mon, 18 Nov 2024 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731941978;
	bh=B8pGggj3ynn83Ub48krJi7CHfczmBiFlV+ZzKagAU8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G6Bg2k8CB4cyv7GvpsoK3J+5RLs/2u5H29iEyh4i6ZqGoXct/Mu22+XNHflmRvT6s
	 KZe6NXydVtOw41QSE4Mu0hI142rjcw2NGNoa3hORXv8QPudQ2LNbI7CL1PQllBv1zJ
	 PVg5OIMdYI/sifgmlsljRU/Jxm7UY+Ka84poM2U08EXGlKgrcyVUOBN2rs8H4k42SQ
	 UuahBUOxDy3vM9OoqFVolfL209f3W00Ro+weBEcZGMM2MXHHmc4mlPpCvaZhG6b4ib
	 avxefeiazL/Eyx8Z0HkLX7S1VbKRCfbXLdz1veV0FzQoJ7m9izmVY5DPnmgs81YoQr
	 LHwDUV8zWxLxA==
Date: Mon, 18 Nov 2024 14:59:30 +0000
From: Will Deacon <will@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Leon Romanovsky <leonro@nvidia.com>,
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
Subject: Re: [PATCH v3 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20241118145929.GB27795@willie-the-truck>
References: <cover.1731244445.git.leon@kernel.org>
 <f8c7f160c9ae97fef4ccd355f9979727552c7374.1731244445.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8c7f160c9ae97fef4ccd355f9979727552c7374.1731244445.git.leon@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sun, Nov 10, 2024 at 03:46:54PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new DMA APIs to perform DMA linkage of buffers
> in layers higher than DMA.
> 
> In proposed API, the callers will perform the following steps.
> In map path:
> 	if (dma_can_use_iova(...))
> 	    dma_iova_alloc()
> 	    for (page in range)
> 	       dma_iova_link_next(...)
> 	    dma_iova_sync(...)
> 	else
> 	     /* Fallback to legacy map pages */
>              for (all pages)
> 	       dma_map_page(...)
> 
> In unmap path:
> 	if (dma_can_use_iova(...))
> 	     dma_iova_destroy()
> 	else
> 	     for (all pages)
> 		dma_unmap_page(...)
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/iommu/dma-iommu.c   | 259 ++++++++++++++++++++++++++++++++++++
>  include/linux/dma-mapping.h |  32 +++++
>  2 files changed, 291 insertions(+)

[...]

> +/**
> + * dma_iova_link - Link a range of IOVA space
> + * @dev: DMA device
> + * @state: IOVA state
> + * @phys: physical address to link
> + * @offset: offset into the IOVA state to map into
> + * @size: size of the buffer
> + * @dir: DMA direction
> + * @attrs: attributes of mapping properties
> + *
> + * Link a range of IOVA space for the given IOVA state without IOTLB sync.
> + * This function is used to link multiple physical addresses in contigueous
> + * IOVA space without performing costly IOTLB sync.
> + *
> + * The caller is responsible to call to dma_iova_sync() to sync IOTLB at
> + * the end of linkage.
> + */
> +int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	size_t iova_start_pad = iova_offset(iovad, phys);
> +
> +	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
> +		return -EIO;
> +
> +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
> +		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
> +				size, dir, attrs);
> +
> +	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
> +			phys - iova_start_pad,
> +			iova_align(iovad, size + iova_start_pad), dir, attrs);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_link);
> +
> +/**
> + * dma_iova_sync - Sync IOTLB
> + * @dev: DMA device
> + * @state: IOVA state
> + * @offset: offset into the IOVA state to sync
> + * @size: size of the buffer
> + *
> + * Sync IOTLB for the given IOVA state. This function should be called on
> + * the IOVA-contigous range created by one ore more dma_iova_link() calls
> + * to sync the IOTLB.
> + */
> +int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	dma_addr_t addr = state->addr + offset;
> +	size_t iova_start_pad = iova_offset(iovad, addr);
> +
> +	return iommu_sync_map(domain, addr - iova_start_pad,
> +		      iova_align(iovad, size + iova_start_pad));
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_sync);
> +
> +static void iommu_dma_iova_unlink_range_slow(struct device *dev,
> +		dma_addr_t addr, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	size_t iova_start_pad = iova_offset(iovad, addr);
> +	dma_addr_t end = addr + size;
> +
> +	do {
> +		phys_addr_t phys;
> +		size_t len;
> +
> +		phys = iommu_iova_to_phys(domain, addr);
> +		if (WARN_ON(!phys))
> +			continue;
> +		len = min_t(size_t,
> +			end - addr, iovad->granule - iova_start_pad);
> +
> +		if (!dev_is_dma_coherent(dev) &&
> +		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> +			arch_sync_dma_for_cpu(phys, len, dir);
> +
> +		swiotlb_tbl_unmap_single(dev, phys, len, dir, attrs);
> +
> +		addr += len;
> +		iova_start_pad = 0;
> +	} while (addr < end);
> +}
> +
> +static void __iommu_dma_iova_unlink(struct device *dev,
> +		struct dma_iova_state *state, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs,
> +		bool free_iova)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	dma_addr_t addr = state->addr + offset;
> +	size_t iova_start_pad = iova_offset(iovad, addr);
> +	struct iommu_iotlb_gather iotlb_gather;
> +	size_t unmapped;
> +
> +	if ((state->__size & DMA_IOVA_USE_SWIOTLB) ||
> +	    (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)))
> +		iommu_dma_iova_unlink_range_slow(dev, addr, size, dir, attrs);
> +
> +	iommu_iotlb_gather_init(&iotlb_gather);
> +	iotlb_gather.queued = free_iova && READ_ONCE(cookie->fq_domain);
> +
> +	size = iova_align(iovad, size + iova_start_pad);
> +	addr -= iova_start_pad;
> +	unmapped = iommu_unmap_fast(domain, addr, size, &iotlb_gather);
> +	WARN_ON(unmapped != size);

Does the new API require that the 'size' passed to dma_iova_unlink()
exactly match the 'size' passed to the corresponding call to
dma_iova_link()? I ask because the IOMMU page-table code is built around
the assumption that partial unmap() operations never occur (i.e.
operations which could require splitting a huge mapping). We just
removed [1] that code from the Arm IO page-table implementations, so it
would be good to avoid adding it back for this.

Will

[1] https://git.kernel.org/pub/scm/linux/kernel/git/iommu/linux.git/commit/?h=arm/smmu&id=33729a5fc0caf7a97d20507acbeee6b012e7e519

