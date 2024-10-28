Return-Path: <kvm+bounces-29792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A119B21FA
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36A35280DF9
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 01:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035A8156243;
	Mon, 28 Oct 2024 01:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIURW7bc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D26088F;
	Mon, 28 Oct 2024 01:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730078662; cv=none; b=h2ZNJFj3dseyksea1iLXyaXB4hv7o9idqqZ6GXGNv3ftJhY8pAFW4qmG9D8K5aAKsmfOqrQM+PjMq0mbhnysKpW7q0WnuuIjoaRUmRGhyiLaGGrZF994qL4w+Zhs9YsCGelZUb1nQix+aD6LF438ivb/mtTZUl2/l48Bu39yykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730078662; c=relaxed/simple;
	bh=bf/VeYucpNv6ZZcK2fwIQKDea5xGi/UZ5dimPkOuYKQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iQPwaeLyE1sB311tpGGd33c3XpCrnDTXsrw9lE89H1xljA2wRnTeCyvBUjJCzYwSgL7PlvreRBk8ah7e9dgkeQuKuyhP51BT/cUMa3jqEpxDlUtD888iQvY0kleCxjRn7+zlY0DobK8TS8lMH1qz24MZ5oBW9jU/VKYsJgfZGUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIURW7bc; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730078660; x=1761614660;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bf/VeYucpNv6ZZcK2fwIQKDea5xGi/UZ5dimPkOuYKQ=;
  b=YIURW7bcE23xqiz8YIpgYH8bWnzyD4MyTr76iiXVCrbu5E14ZHjuG/2a
   oKsUjpudo1KLHbOlvC+d7txqYG0hnXhrfpHFmPlVPFp3k7z6lr8PxdHt6
   iSalkx1khfPPIpwQyTfkpUrO2vnFdOWozbvL5kn/iiO+ky4wgY0AYqLt8
   NC/P3OWCPl0MkTqp9rrQhPWQz+M4TbO/IUZKVlpTUazkLmLf48zqB0kRu
   qTFzw9JQyHiHUPdJzKOKUFEZxutmDzQVLKel1NXujepjvFUTZlHBs/Zbe
   cyX2o/Q8j5xpqePF0lHaN2k8OcNthLQjLnunFdehGdyQPlz6aKGyjZlub
   A==;
X-CSE-ConnectionGUID: 7DnuyC14RTW9l20zUBYcuA==
X-CSE-MsgGUID: XozA1EDOShavepJd8ZpKJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40769204"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40769204"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 18:24:17 -0700
X-CSE-ConnectionGUID: 3XId+CpwRcup4hw+6LoFIA==
X-CSE-MsgGUID: nYY7ZZ8XT8aQBqUAXsE3Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="86065323"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.238.0.51]) ([10.238.0.51])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 18:24:10 -0700
Message-ID: <25c32551-32e2-4a44-b0ae-30ad08e06799@linux.intel.com>
Date: Mon, 28 Oct 2024 09:24:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Leon Romanovsky <leonro@nvidia.com>,
 Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
To: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>
References: <cover.1730037276.git.leon@kernel.org>
 <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/10/27 22:21, Leon Romanovsky wrote:
> From: Leon Romanovsky<leonro@nvidia.com>
> 
> The existing .map_page() callback provides both allocating of IOVA
> and linking DMA pages. That combination works great for most of the
> callers who use it in control paths, but is less effective in fast
> paths where there may be multiple calls to map_page().
> 
> These advanced callers already manage their data in some sort of
> database and can perform IOVA allocation in advance, leaving range
> linkage operation to be in fast path.
> 
> Provide an interface to allocate/deallocate IOVA and next patch
> link/unlink DMA ranges to that specific IOVA.
> 
> The API is exported from dma-iommu as it is the only implementation
> supported, the namespace is clearly different from iommu_* functions
> which are not allowed to be used. This code layout allows us to save
> function call per API call used in datapath as well as a lot of boilerplate
> code.
> 
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> ---
>   drivers/iommu/dma-iommu.c   | 79 +++++++++++++++++++++++++++++++++++++
>   include/linux/dma-mapping.h | 15 +++++++
>   2 files changed, 94 insertions(+)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index c422e36c0d66..0644152c5aad 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1745,6 +1745,85 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
>   	return SIZE_MAX;
>   }
>   
> +static bool iommu_dma_iova_alloc(struct device *dev,
> +		struct dma_iova_state *state, phys_addr_t phys, size_t size)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	size_t iova_off = iova_offset(iovad, phys);
> +	dma_addr_t addr;
> +
> +	if (WARN_ON_ONCE(!size))
> +		return false;
> +	if (WARN_ON_ONCE(size & DMA_IOVA_USE_SWIOTLB))
> +		return false;
> +
> +	addr = iommu_dma_alloc_iova(domain,
> +			iova_align(iovad, size + iova_off),
> +			dma_get_mask(dev), dev);
> +	if (!addr)
> +		return false;
> +
> +	state->addr = addr + iova_off;
> +	state->__size = size;
> +	return true;
> +}
> +
> +/**
> + * dma_iova_try_alloc - Try to allocate an IOVA space
> + * @dev: Device to allocate the IOVA space for
> + * @state: IOVA state
> + * @phys: physical address
I'm curious to know why a physical address is necessary for IOVA space
allocation. Could you please elaborate?

> + * @size: IOVA size
> + *
> + * Check if @dev supports the IOVA-based DMA API, and if yes allocate IOVA space
> + * for the given base address and size.
> + *
> + * Note: @phys is only used to calculate the IOVA alignment. Callers that always
> + * do PAGE_SIZE aligned transfers can safely pass 0 here.
> + *
> + * Returns %true if the IOVA-based DMA API can be used and IOVA space has been
> + * allocated, or %false if the regular DMA API should be used.
> + */
> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t size)
> +{
> +	memset(state, 0, sizeof(*state));
> +	if (!use_dma_iommu(dev))
> +		return false;
> +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> +		return false;
> +	return iommu_dma_iova_alloc(dev, state, phys, size);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_try_alloc);

Thanks,
baolu

