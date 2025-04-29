Return-Path: <kvm+bounces-44636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1330A9FFC1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FA413AB2B4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555E429C34C;
	Tue, 29 Apr 2025 02:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eu/VLqjy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA66C79F2;
	Tue, 29 Apr 2025 02:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745893449; cv=none; b=kcwFF5yJ07lHWqiO5+UtU2D8kBA2aAUUc+OWtaudElAZYUivHaPg5YIqPizIuDy3kaVNlSOMnOyTtb5aQiAzrYgQ8ddJq496mnPG2jati8zhIKdCFqHDQ/kem+uNOnjQz3dSSFZbBkRNcZVEiZxXe+aqEw2iBGpNoWBfHc4ORas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745893449; c=relaxed/simple;
	bh=6sGMzojzYlJ54g3FQSKtIDOIOOhDQGpN7BZFln60WPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OosZecm9LnBg0mBuzP6MgeZYuVp6SREIE2fdq96Iwlx6nzkgmEqZ8dzKdnrJlof2bwBoy7CBbtMTou1CIksxkBwFsCH72V3kVQals56veGf3H+ZnrMHR+HdKXx1zyhiAQs72EANgU6ZDi0FUZQfmtio58py4/NvMoT0p8nrw9yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eu/VLqjy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745893448; x=1777429448;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6sGMzojzYlJ54g3FQSKtIDOIOOhDQGpN7BZFln60WPk=;
  b=Eu/VLqjyox+WFVF+DSJk7KALGB0hPQxZNaElUOTs/9MHfcfQkMMjvbKA
   QxV/IKnHvE3G2hOpJzQWN/LRs5BG60dlyNPvvPC+0glutslE21IAjLJa4
   eCN/kkNUJcaG/j6O8Nj+j/toW+nd7Cm5Wb93GLyjiteEb+2V939km2bjC
   fo0t3vL4b4CxEbzF9xEwds+5xJKBtwN0heILzn1Us1z5FWbVvMRLM8TYB
   vYAXIQcIO/0zhu+S5UzEYQ5R+DZ2qhOZSW2vIYkM6YsaqqSiXBJBA58is
   0XaNgHmT5BQY5l7fQUrik/ys15YT044OXjcq3y4bbs8/TsJsy/IJJbXYO
   g==;
X-CSE-ConnectionGUID: xLITgjHoSoi5zUBRHaa20A==
X-CSE-MsgGUID: T1xMIlc/T5SOx+skZ3Tksg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="51319144"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="51319144"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:24:07 -0700
X-CSE-ConnectionGUID: vvNJFknhTVeWI8A1w+PaZg==
X-CSE-MsgGUID: xZVcFf42RYGbSOpMJUPKUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="138678340"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 19:23:58 -0700
Message-ID: <f8d86cde-d485-4e5a-a693-e9323679474f@linux.intel.com>
Date: Tue, 29 Apr 2025 10:19:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/24] iommu: generalize the batched sync after map
 interface
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>,
 Yishai Hadas <yishaih@nvidia.com>,
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
 Chaitanya Kulkarni <kch@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>
References: <cover.1745831017.git.leon@kernel.org>
 <69da19d2cc5df0be5112f0cf2365a0337b00d873.1745831017.git.leon@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <69da19d2cc5df0be5112f0cf2365a0337b00d873.1745831017.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/25 17:22, Leon Romanovsky wrote:
> From: Christoph Hellwig<hch@lst.de>
> 
> For the upcoming IOVA-based DMA API we want to batch the
> ops->iotlb_sync_map() call after mapping multiple IOVAs from
> dma-iommu without having a scatterlist. Improve the API.
> 
> Add a wrapper for the map_sync as iommu_sync_map() so that callers
> don't need to poke into the methods directly.
> 
> Formalize __iommu_map() into iommu_map_nosync() which requires the
> caller to call iommu_sync_map() after all maps are completed.
> 
> Refactor the existing sanity checks from all the different layers
> into iommu_map_nosync().
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Acked-by: Will Deacon<will@kernel.org>
> Tested-by: Jens Axboe<axboe@kernel.dk>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Luis Chamberlain<mcgrof@kernel.org>
> Signed-off-by: Leon Romanovsky<leonro@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 65 +++++++++++++++++++------------------------
>   include/linux/iommu.h |  4 +++
>   2 files changed, 33 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 4f91a740c15f..02960585b8d4 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2443,8 +2443,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
>   	return pgsize;
>   }
>   
> -static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
> -		       phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> +		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
>   {
>   	const struct iommu_domain_ops *ops = domain->ops;
>   	unsigned long orig_iova = iova;
> @@ -2453,12 +2453,19 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
>   	phys_addr_t orig_paddr = paddr;
>   	int ret = 0;
>   
> +	might_sleep_if(gfpflags_allow_blocking(gfp));
> +
>   	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
>   		return -EINVAL;
>   
>   	if (WARN_ON(!ops->map_pages || domain->pgsize_bitmap == 0UL))
>   		return -ENODEV;
>   
> +	/* Discourage passing strange GFP flags */
> +	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> +				__GFP_HIGHMEM)))
> +		return -EINVAL;
> +
>   	/* find out the minimum page size supported */
>   	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
>   
> @@ -2506,31 +2513,27 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
>   	return ret;
>   }
>   
> -int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -	      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> +int iommu_sync_map(struct iommu_domain *domain, unsigned long iova, size_t size)
>   {
>   	const struct iommu_domain_ops *ops = domain->ops;
> -	int ret;
> -
> -	might_sleep_if(gfpflags_allow_blocking(gfp));
>   
> -	/* Discourage passing strange GFP flags */
> -	if (WARN_ON_ONCE(gfp & (__GFP_COMP | __GFP_DMA | __GFP_DMA32 |
> -				__GFP_HIGHMEM)))
> -		return -EINVAL;
> +	if (!ops->iotlb_sync_map)
> +		return 0;
> +	return ops->iotlb_sync_map(domain, iova, size);
> +}

I am wondering whether iommu_sync_map() needs a return value. The
purpose of this callback is just to sync the TLB cache after new
mappings are created, which should effectively be a no-fail operation.

The definition of iotlb_sync_map in struct iommu_domain_ops seems
unnecessary:

struct iommu_domain_ops {
...
         int (*iotlb_sync_map)(struct iommu_domain *domain, unsigned 
long iova,
                               size_t size);
...
};

Furthermore, currently no iommu driver implements this callback in a way
that returns a failure. We could clean up the iommu definition in a
subsequent patch series, but for this driver-facing interface, it's
better to get it right from the beginning.

Thanks,
baolu

