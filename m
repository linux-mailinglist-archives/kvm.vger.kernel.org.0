Return-Path: <kvm+bounces-35507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973CEA1197F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 07:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAB331682A6
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B92D22FAE9;
	Wed, 15 Jan 2025 06:13:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2A22E41E;
	Wed, 15 Jan 2025 06:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736921615; cv=none; b=hExpO6q1Q+yh8+k7NV0x+FPQElQ3ruoKlkkQrov2JKeKqzAi8yAsYjY6MdeK67MMuKQi2KKJ13UP688dXOgi1PX0K+JoEtJTK3JUUW+XHT6ov8IzM3fZzkkHxX5Vsdaa3mJJouQVnDTWUgAndK21Off+cDZjufY3s9qoCkjylN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736921615; c=relaxed/simple;
	bh=IJpGGqTdTn3Pi3/xnnXvoMDIxvhrzP92PeGu0JYmNS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHlyHNBz+cC3GVDmLNT/HaXc5j7TbusI2Las05Fu6JqjKT760uw4h0vJcWNkaopdTRiXkFqOGCwC5KLWAKYFCyqr0P8FOLF/wGCHb9QUxY84yDva8+L+1kSkEhzXO64bObSgM3iZ1ypqk2WoIaWHAaw+T+cCwfhaU0jdEovDveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F412068B05; Wed, 15 Jan 2025 07:13:26 +0100 (CET)
Date: Wed, 15 Jan 2025 07:13:26 +0100
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
Subject: Re: [PATCH v5 05/17] dma-mapping: Provide an interface to allow
 allocate IOVA
Message-ID: <20250115061326.GA29643@lst.de>
References: <cover.1734436840.git.leon@kernel.org> <fac6bc6fdcf8e13bd5668386d36289ee38a8a95b.1734436840.git.leon@kernel.org> <ecb59036-b279-4412-9a09-40e05af3b9ea@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecb59036-b279-4412-9a09-40e05af3b9ea@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 08:50:28PM +0000, Robin Murphy wrote:
>> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
>> +		phys_addr_t phys, size_t size)
>> +{
>> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
>> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>> +	struct iova_domain *iovad = &cookie->iovad;
>> +	size_t iova_off = iova_offset(iovad, phys);
>> +	dma_addr_t addr;
>> +
>> +	memset(state, 0, sizeof(*state));
>> +	if (!use_dma_iommu(dev))
>> +		return false;
>
> Can you guess why that return won't ever be taken?

It is regularly taken.  Now that it's quoted this way it would probably
good to split the thing up to not do the deferferences above, as they
might cause problems if the compiler wasn't smart enough to only
perform them after the check..

>> +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
>> +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
>> +		return false;
>> +
>> +	if (WARN_ON_ONCE(!size))
>> +		return false;
>> +	if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
>
> This looks weird. Why would a caller ever set an effectively-private flag 
> in the first place? If it's actually supposed to be a maximum size check, 
> please make it look like a maximum size check.

As the person who added it - this is to catch a user passing in a value
that would set it.  To me this looks obvious, but should we add a
comment?

> (Which also makes me consider iommu_dma_max_mapping_size() returning 
> SIZE_MAX isn't strictly accurate, ho hum...)

You can still map SIZE_MAX, just not using this interface.  Assuming
no other real life limitations get in way, which I bet they will.

>> @@ -72,6 +74,21 @@
>>     #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>>   +struct dma_iova_state {
>> +	dma_addr_t addr;
>> +	size_t __size;
>> +};
>> +
>> +/*
>> + * Use the high bit to mark if we used swiotlb for one or more ranges.
>> + */
>> +#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
>
> This will give surprising results for 32-bit size_t (in fact I guess it 
> might fire some build warnings already).

Good point.  I guess __size should simply become a u64.


