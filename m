Return-Path: <kvm+bounces-44640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B53AFAA0035
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BA341A85E2F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 03:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9702E27054F;
	Tue, 29 Apr 2025 03:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ko1kScYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDEC1D5ABF;
	Tue, 29 Apr 2025 03:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745896519; cv=none; b=Dk4KRA5f/wqz4JGhjkmgamD3RF31cm2H26/SFwDv6ezKMJf2nY3nAUP9rHGYUzWZ9mGTR1RPJr03G5+6uM8ptOR2OLXzZxDUggisWlzG+reVdMk3ZMO2eLLkMg8KJ4VYRPJVbOIMQp+5tebf9YuI3CsSX39M+wztZynrvEGbphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745896519; c=relaxed/simple;
	bh=gF3+aJs3Gf/hJScKyT1fbK46ZtYQ+FrmHh+AQDsrL0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=heqSH1TPJsLFKMaFUE/tF8+V91M7BoXGULmJ+GpR2w0no6pdGzEcwAUpSe+3l/24zDKS7d6/EIWT12IUi7fUycR0Iocp2vvn+7ThurtwuE1wU0q9DkoCqcL5LWSvYUrX+5MbeMzV3fnVQCMcuaAjy7F5guhNthMB5lmZ/1ZOmnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ko1kScYs; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745896517; x=1777432517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gF3+aJs3Gf/hJScKyT1fbK46ZtYQ+FrmHh+AQDsrL0w=;
  b=Ko1kScYsg+YyREB4A+YRch1TOVHQz8KWGhn4Ui5UZUtAbUzkIixv78bP
   tXJSAHQmEb8eIu+/GG3ieYLFsMuFQR2COmLPRMX09BiOBXXDL/CjzNdHn
   jwDDCAEFxi4fXFoPytugtHDg3E4Y3iV9VwW8eLQ+AxCoh/T/uonwZIt/g
   eecJ7JzHceD+e8vNmIf87SOmNktZ/NYD/kfTEabHadtuCdWdpQnrtA9Ag
   A8l1UgR31LKxhfK+uloIJg9DDyl0HJb9STYzIiwDANRcMXKu+n6fM0iDF
   zWD/2zhQdz5jdvbUljCu3sHRwNUSoWVLY92N8JukW/abJXRIXscBYttDU
   g==;
X-CSE-ConnectionGUID: /+1i8YPtRcKh0efR4BJNsA==
X-CSE-MsgGUID: naMycftATTinNUijWUxKfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="50164771"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="50164771"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:15:16 -0700
X-CSE-ConnectionGUID: ed4rLAGbTImlyIcMdAHXJw==
X-CSE-MsgGUID: 8LoauE1fTyG98pnYRixuDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="133600998"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 20:15:07 -0700
Message-ID: <0086302d-1cb3-43dd-a989-e4b1995a0d22@linux.intel.com>
Date: Tue, 29 Apr 2025 11:10:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/24] dma-mapping: Provide an interface to allow
 allocate IOVA
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
 Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
 Zhu Yanjun <zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Niklas Schnelle <schnelle@linux.ibm.com>,
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dan Williams
 <dan.j.williams@intel.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <30f0601d400711b3859deeb8fef3090f5b2020a4.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <30f0601d400711b3859deeb8fef3090f5b2020a4.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Leon Romanovsky<leonro@nvidia.com>
> 
> The existing .map_page() callback provides both allocating of IOVA

.map_pages()

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
> In the new API a DMA mapping transaction is identified by a
> struct dma_iova_state, which holds some recomputed information
> for the transaction which does not change for each page being
> mapped, so add a check if IOVA can be used for the specific
> transaction.
> 
> The API is exported from dma-iommu as it is the only implementation
> supported, the namespace is clearly different from iommu_* functions
> which are not allowed to be used. This code layout allows us to save
> function call per API call used in datapath as well as a lot of boilerplate
> code.
> 
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> ---
>   drivers/iommu/dma-iommu.c   | 86 +++++++++++++++++++++++++++++++++++++
>   include/linux/dma-mapping.h | 48 +++++++++++++++++++++
>   2 files changed, 134 insertions(+)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 9ba8d8bc0ce9..d3211a8d755e 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1723,6 +1723,92 @@ size_t iommu_dma_max_mapping_size(struct device *dev)
>   	return SIZE_MAX;
>   }
>   
> +/**
> + * dma_iova_try_alloc - Try to allocate an IOVA space
> + * @dev: Device to allocate the IOVA space for
> + * @state: IOVA state
> + * @phys: physical address
> + * @size: IOVA size
> + *
> + * Check if @dev supports the IOVA-based DMA API, and if yes allocate IOVA space
> + * for the given base address and size.
> + *
> + * Note: @phys is only used to calculate the IOVA alignment. Callers that always
> + * do PAGE_SIZE aligned transfers can safely pass 0 here.

Have you considered adding a direct alignment parameter to
dma_iova_try_alloc()? '0' simply means the default PAGE_SIZE alignment.

I'm imagining that some devices might have particular alignment needs
for better performance, especially for the ATS cache efficiency. This
would allow those device drivers to express the requirements directly
during iova allocation.

> + *
> + * Returns %true if the IOVA-based DMA API can be used and IOVA space has been
> + * allocated, or %false if the regular DMA API should be used.
> + */
> +bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t size)
> +{
> +	struct iommu_dma_cookie *cookie;
> +	struct iommu_domain *domain;
> +	struct iova_domain *iovad;
> +	size_t iova_off;
> +	dma_addr_t addr;
> +
> +	memset(state, 0, sizeof(*state));
> +	if (!use_dma_iommu(dev))
> +		return false;
> +
> +	domain = iommu_get_dma_domain(dev);
> +	cookie = domain->iova_cookie;
> +	iovad = &cookie->iovad;
> +	iova_off = iova_offset(iovad, phys);
> +
> +	if (static_branch_unlikely(&iommu_deferred_attach_enabled) &&
> +	    iommu_deferred_attach(dev, iommu_get_domain_for_dev(dev)))
> +		return false;
> +
> +	if (WARN_ON_ONCE(!size))
> +		return false;
> +
> +	/*
> +	 * DMA_IOVA_USE_SWIOTLB is flag which is set by dma-iommu
> +	 * internals, make sure that caller didn't set it and/or
> +	 * didn't use this interface to map SIZE_MAX.
> +	 */
> +	if (WARN_ON_ONCE((u64)size & DMA_IOVA_USE_SWIOTLB))

I'm a little concerned that device drivers might inadvertently misuse
the state->__size by forgetting about the high bit being used for
DMA_IOVA_USE_SWIOTLB. Perhaps adding a separate flag within struct
dma_iova_state to prevent such issues?

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
> +EXPORT_SYMBOL_GPL(dma_iova_try_alloc);

Thanks,
baolu

