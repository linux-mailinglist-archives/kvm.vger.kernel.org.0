Return-Path: <kvm+bounces-35509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B281A11997
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 07:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D00CA1889661
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC2222F84F;
	Wed, 15 Jan 2025 06:26:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDD2D05E;
	Wed, 15 Jan 2025 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736922397; cv=none; b=CTnBD1P/t1W6PEyF3PR4OVbEVY/XN9XaGM27Xmr317K4RvkCmEHCMVq+gGGZHTb7ziKjRavVN+BaXJTAv5FXwbkkH1T/74wsTUTSPziv0cLarKEwYHi6yJyeYDoJGoqV3N7J9k1RuV8E4HALpbCRoXpdkHUy2QNk8Df9Aa/mO7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736922397; c=relaxed/simple;
	bh=xFSna/f7xJGH8y4tKSVlhCPS16R70dhbYvwgmnPhA4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpMUQ9XUZ77834EeK0PQ5ALgjvtVXVld4v4x/SzNEzWiEtf49415INYfTOa6d5CgJsyPiEVEgyjeyw0ejg8fTAGtc5juyZRMUOa3HJrE6TiE0iWRYP/ybHLdrF9WoER3SxX2u1zHBalJfxKckqFQ395rCFgdXjKmfccbD6+AIMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1F9068B05; Wed, 15 Jan 2025 07:26:28 +0100 (CET)
Date: Wed, 15 Jan 2025 07:26:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v5 07/17] dma-mapping: Implement link/unlink ranges API
Message-ID: <20250115062628.GA29782@lst.de>
References: <cover.1734436840.git.leon@kernel.org> <fa43307222f263e65ae0a84c303150def15e2c77.1734436840.git.leon@kernel.org> <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2312e0-10d5-467a-be5e-75e80805b311@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 08:50:35PM +0000, Robin Murphy wrote:
>>   EXPORT_SYMBOL_GPL(dma_iova_free);
>>   +static int __dma_iova_link(struct device *dev, dma_addr_t addr,
>> +		phys_addr_t phys, size_t size, enum dma_data_direction dir,
>> +		unsigned long attrs)
>> +{
>> +	bool coherent = dev_is_dma_coherent(dev);
>> +
>> +	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
>> +		arch_sync_dma_for_device(phys, size, dir);
>
> Again, if we're going to pretend to support non-coherent devices, where are 
> the dma_sync_for_{device,cpu} calls that work for a dma_iova_state? It 
> can't be the existing dma_sync_single ops since that would require the user 
> to keep track of every mapping to sync them individually, and the whole 
> premise is to avoid doing that (not to mention dma-debug wouldn't like it). 
> Same for anything coherent but SWIOTLB-bounced.

That assumes you actually need to sync them.  Many DMA mapping if not
most dma mappings are one shots - map and unmap, no sync.  And these
will work fine here.

But I guess the documentation needs to spell that out.  While I don't
have a good non-coherent system to test, swiotlb has actually been
tested with nvme when I implemented this part.

>> +{
>> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
>> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>> +	struct iova_domain *iovad = &cookie->iovad;
>> +	size_t iova_start_pad = iova_offset(iovad, phys);
>> +	size_t iova_end_pad = iova_offset(iovad, phys + size);
>
> "end_pad" implies a length of padding from the unaligned end address to 
> reach the *next* granule boundary, but it seems this is actually the 
> unaligned tail length of the data itself. That's what confused me last 
> time, since in the map path that post-data padding region does matter in 
> its own right.

Yeah.  Do you have a suggestion for a better name?

>> +		phys_addr_t phys, size_t offset, size_t size,
>> +		enum dma_data_direction dir, unsigned long attrs)
>> +{
>> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
>> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>> +	struct iova_domain *iovad = &cookie->iovad;
>> +	size_t iova_start_pad = iova_offset(iovad, phys);
>> +
>> +	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
>
> "iova_start_pad == 0" still doesn't guarantee that "phys" and "offset" are 
> appropriately aligned to each other.

>> +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
>
> Again, why are we supporting non-granule-aligned mappings in the middle of 
> a range when the documentation explicitly says not to?

It's not trying to support that, but checking that this is guaranteed
to be the last one is harder than handling it like this.  If you have
a suggestion for better checks that would be very welcome.

>> +		if (!dev_is_dma_coherent(dev) &&
>> +		    !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
>> +			arch_sync_dma_for_cpu(phys, len, dir);
>
> Hmm, how do attrs even work for a bulk unlink/destroy when the individual 
> mappings could have been linked with different values?

They shouldn't.  Just like randomly mixing flags doesn't work for the
existing APIs.

> (So no, irrespective of how conceptually horrid it is, clearly it's not 
> even functionally viable to open-code abuse of DMA_ATTR_SKIP_CPU_SYNC in 
> callers to attempt to work around P2P mappings...)

What do you mean with "work around"?  I guess Leon added it to the hmm
code based on previous feedback, but I still don't think any of our P2P
infrastructure works reliably with non-coherent devices as
iommu_dma_map_sg gets this wrong.  So despite the earlier comments I
suspect this should stick to the state of the art even if that is broken.


