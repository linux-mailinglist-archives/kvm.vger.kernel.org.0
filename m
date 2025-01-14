Return-Path: <kvm+bounces-35444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4459CA11283
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 21:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 886813A0FD5
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 20:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7492D20F97E;
	Tue, 14 Jan 2025 20:50:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03B71F9ABE;
	Tue, 14 Jan 2025 20:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736887849; cv=none; b=EXqr4DTCjX+8/s/pJXWeNqCvYEfsq25ZwCw+YAs2IPWyxItoPli7Bvc5TV9UovISki5Mi55hMOhzAK4rk2Xyudcx1pkGTHj4iM28YzFobEUItPQ1bMP1W8WQHG4RJHW82V9Ph39Gp1MWXMgJaysBvZREubX3HqlgKmy0CWR+R/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736887849; c=relaxed/simple;
	bh=9EKAGbEzUwplEuxyWnRSts0mBps2I6MBFwSv3Z+5+bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m47xwV/Gc8XDtpr4Qvnd0sbdoBiKJOanPMrRyoU9G9Ovb/mGki8uQtWryN1HaVVK6sTDH0Kn1IP6cd4qKpKVSHoTL6g1jrFaK/AwVgqwNiwl9VRIfjSgddivXUaJrAW6XWkfzKNtn9T/bAcY/9yxBBYGmu+c7SSyWk5UpitYfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2962D1D13;
	Tue, 14 Jan 2025 12:51:15 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 217DE3F673;
	Tue, 14 Jan 2025 12:50:35 -0800 (PST)
Message-ID: <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
Date: Tue, 14 Jan 2025 20:50:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>
Cc: Leon Romanovsky <leonro@nvidia.com>, Keith Busch <kbusch@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 Randy Dunlap <rdunlap@infradead.org>
References: <cover.1734436840.git.leon@kernel.org>
 <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/12/2024 1:00 pm, Leon Romanovsky wrote:
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
>               for (all pages)
> 	       dma_map_page(...)
> 
> In unmap path:
> 	if (dma_can_use_iova(...))
> 	     dma_iova_destroy()
> 	else
> 	     for (all pages)
> 		dma_unmap_page(...)
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/iommu/dma-iommu.c   | 259 ++++++++++++++++++++++++++++++++++++
>   include/linux/dma-mapping.h |  32 +++++
>   2 files changed, 291 insertions(+)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index d473ea4329ab..7972270e82b4 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1829,6 +1829,265 @@ void dma_iova_free(struct device *dev, struct dma_iova_state *state)
>   }
>   EXPORT_SYMBOL_GPL(dma_iova_free);
>   
> +static int __dma_iova_link(struct device *dev, dma_addr_t addr,
> +		phys_addr_t phys, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
> +{
> +	bool coherent = dev_is_dma_coherent(dev);
> +
> +	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> +		arch_sync_dma_for_device(phys, size, dir);

Again, if we're going to pretend to support non-coherent devices, where 
are the dma_sync_for_{device,cpu} calls that work for a dma_iova_state? 
It can't be the existing dma_sync_single ops since that would require 
the user to keep track of every mapping to sync them individually, and 
the whole premise is to avoid doing that (not to mention dma-debug 
wouldn't like it). Same for anything coherent but SWIOTLB-bounced.

Or if the API is intended to be actively hostile to buffer reuse, and 
the only way to recycle an active page is to completely unlink it and 
link it again, then please clearly document that.

> +	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
> +			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
> +}
> +
> +static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
> +		phys_addr_t phys, size_t bounce_len,
> +		enum dma_data_direction dir, unsigned long attrs,
> +		size_t iova_start_pad)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iova_domain *iovad = &domain->iova_cookie->iovad;
> +	phys_addr_t bounce_phys;
> +	int error;
> +
> +	bounce_phys = iommu_dma_map_swiotlb(dev, phys, bounce_len, dir, attrs);
> +	if (bounce_phys == DMA_MAPPING_ERROR)
> +		return -ENOMEM;
> +
> +	error = __dma_iova_link(dev, addr - iova_start_pad,
> +			bounce_phys - iova_start_pad,
> +			iova_align(iovad, bounce_len), dir, attrs);
> +	if (error)
> +		swiotlb_tbl_unmap_single(dev, bounce_phys, bounce_len, dir,
> +				attrs);
> +	return error;
> +}
> +
> +static int iommu_dma_iova_link_swiotlb(struct device *dev,
> +		struct dma_iova_state *state, phys_addr_t phys, size_t offset,
> +		size_t size, enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	size_t iova_start_pad = iova_offset(iovad, phys);
> +	size_t iova_end_pad = iova_offset(iovad, phys + size);

"end_pad" implies a length of padding from the unaligned end address to 
reach the *next* granule boundary, but it seems this is actually the 
unaligned tail length of the data itself. That's what confused me last 
time, since in the map path that post-data padding region does matter in 
its own right.

> +	dma_addr_t addr = state->addr + offset;
> +	size_t mapped = 0;
> +	int error;
> +
> +	if (iova_start_pad) {
> +		size_t bounce_len = min(size, iovad->granule - iova_start_pad);
> +
> +		error = iommu_dma_iova_bounce_and_link(dev, addr, phys,
> +				bounce_len, dir, attrs, iova_start_pad);
> +		if (error)
> +			return error;
> +		state->__size |= DMA_IOVA_USE_SWIOTLB;
> +
> +		mapped += bounce_len;
> +		size -= bounce_len;
> +		if (!size)
> +			return 0;
> +	}
> +
> +	size -= iova_end_pad;
> +	error = __dma_iova_link(dev, addr + mapped, phys + mapped, size, dir,
> +			attrs);
> +	if (error)
> +		goto out_unmap;
> +	mapped += size;
> +
> +	if (iova_end_pad) {
> +		error = iommu_dma_iova_bounce_and_link(dev, addr + mapped,
> +				phys + mapped, iova_end_pad, dir, attrs, 0);
> +		if (error)
> +			goto out_unmap;
> +		state->__size |= DMA_IOVA_USE_SWIOTLB;
> +	}
> +
> +	return 0;
> +
> +out_unmap:
> +	dma_iova_unlink(dev, state, 0, mapped, dir, attrs);
> +	return error;
> +}
> +
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

"iova_start_pad == 0" still doesn't guarantee that "phys" and "offset" 
are appropriately aligned to each other.

In fact there are so many other basic sanity checks which could easily 
be here to make the interface robust that I start to wonder whether 
maybe this token one its own is a misdirect and the in-joke is actually 
that the whole thing is designed to be as fragile as possible...

> +		return -EIO;
> +
> +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))

Again, why are we supporting non-granule-aligned mappings in the middle 
of a range when the documentation explicitly says not to?

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

Infinite WARN_ON loop, nice.

> +		len = min_t(size_t,
> +			end - addr, iovad->granule - iova_start_pad);
> +
> +		if (!dev_is_dma_coherent(dev) &&
> +		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> +			arch_sync_dma_for_cpu(phys, len, dir);

Hmm, how do attrs even work for a bulk unlink/destroy when the 
individual mappings could have been linked with different values?

(So no, irrespective of how conceptually horrid it is, clearly it's not 
even functionally viable to open-code abuse of DMA_ATTR_SKIP_CPU_SYNC in 
callers to attempt to work around P2P mappings...)

> +
> +		swiotlb_tbl_unmap_single(dev, phys, len, dir, attrs);

This is still dumb. For everything other than the first and last 
granule, either it's definitely not in SWIOTLB, or it is (per the 
unaligned size thing above) but then "len" is definitely wrong and 
SWIOTLB will complain.

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

This makes things needlessly hard to follow, just keep the IOVA freeing 
separate. And by that I really mean just have unlink and free, since 
dma_iova_destroy() really doesn't seem worth the extra complexity to 
save one line in one caller...

> +	size = iova_align(iovad, size + iova_start_pad);
> +	addr -= iova_start_pad;
> +	unmapped = iommu_unmap_fast(domain, addr, size, &iotlb_gather);
> +	WARN_ON(unmapped != size);
> +
> +	if (!iotlb_gather.queued)
> +		iommu_iotlb_sync(domain, &iotlb_gather);
> +	if (free_iova)
> +		iommu_dma_free_iova(cookie, addr, size, &iotlb_gather);

Case in point, can you spot the bug here if dma_iova_destroy() is used 
as intended? At least it's the relatively benign direction of this bug, 
not the really fun pagetable corruption one.

Furthermore I'm also still not convinced it's worth worrying about flush 
queues here - they make a difference when IOVA release/recycling is in 
the unmap fastpath, but once link/unlink already replaces that, 
micro-optimising the one-time teardown slowpath doesn't seem like 
something to worry about. And I do consider that the interesting case 
for this, because if you put the whole try_alloc/link/destroy cycle in 
the per-transfer fastpath then it cannot perform *significantly* better 
than dma_map_sg/dma_unmap_sg could, given that it's then fundamentally 
the exact same sequence of IOVA/IOMMU operations. Thus for those uses we 
come back around to it seeming a better use of effort to just tweak the 
existing stuff for maximum efficiency.

Thanks,
Robin.

> +}
> +
> +/**
> + * dma_iova_unlink - Unlink a range of IOVA space
> + * @dev: DMA device
> + * @state: IOVA state
> + * @offset: offset into the IOVA state to unlink
> + * @size: size of the buffer
> + * @dir: DMA direction
> + * @attrs: attributes of mapping properties
> + *
> + * Unlink a range of IOVA space for the given IOVA state.
> + */
> +void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
> +{
> +	 __iommu_dma_iova_unlink(dev, state, offset, size, dir, attrs, false);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_unlink);
> +
> +/**
> + * dma_iova_destroy - Finish a DMA mapping transaction
> + * @dev: DMA device
> + * @state: IOVA state
> + * @mapped_len: number of bytes to unmap
> + * @dir: DMA direction
> + * @attrs: attributes of mapping properties
> + *
> + * Unlink the IOVA range up to @mapped_len and free the entire IOVA space. The
> + * range of IOVA from dma_addr to @mapped_len must all be linked, and be the
> + * only linked IOVA in state.
> + */
> +void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
> +		size_t mapped_len, enum dma_data_direction dir,
> +		unsigned long attrs)
> +{
> +	if (mapped_len)
> +		__iommu_dma_iova_unlink(dev, state, 0, mapped_len, dir, attrs,
> +				true);
> +	else
> +		/*
> +		 * We can be here if first call to dma_iova_link() failed and
> +		 * there is nothing to unlink, so let's be more clear.
> +		 */
> +		dma_iova_free(dev, state);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_destroy);
> +
>   void iommu_setup_dma_ops(struct device *dev)
>   {
>   	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 55899d65668b..f4d717e17bde 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -310,6 +310,17 @@ static inline bool dma_use_iova(struct dma_iova_state *state)
>   bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
>   		phys_addr_t phys, size_t size);
>   void dma_iova_free(struct device *dev, struct dma_iova_state *state);
> +void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
> +		size_t mapped_len, enum dma_data_direction dir,
> +		unsigned long attrs);
> +int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size);
> +int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs);
> +void dma_iova_unlink(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs);
>   #else /* CONFIG_IOMMU_DMA */
>   static inline bool dma_use_iova(struct dma_iova_state *state)
>   {
> @@ -324,6 +335,27 @@ static inline void dma_iova_free(struct device *dev,
>   		struct dma_iova_state *state)
>   {
>   }
> +static inline void dma_iova_destroy(struct device *dev,
> +		struct dma_iova_state *state, size_t mapped_len,
> +		enum dma_data_direction dir, unsigned long attrs)
> +{
> +}
> +static inline int dma_iova_sync(struct device *dev,
> +		struct dma_iova_state *state, size_t offset, size_t size)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int dma_iova_link(struct device *dev,
> +		struct dma_iova_state *state, phys_addr_t phys, size_t offset,
> +		size_t size, enum dma_data_direction dir, unsigned long attrs)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline void dma_iova_unlink(struct device *dev,
> +		struct dma_iova_state *state, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs)
> +{
> +}
>   #endif /* CONFIG_IOMMU_DMA */
>   
>   #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)

