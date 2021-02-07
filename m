Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23E4312357
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 11:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGKDs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 05:03:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:50122 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGKDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 05:03:47 -0500
IronPort-SDR: ETI7YzxekrQHHF6lb0EdsdVghedbMZOEOriMx8FTAEBnCY7lN0YceM8AsQ4riz5w+SIZuiA1F7
 U+a/hTrAKt5A==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="243097226"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="243097226"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 02:02:01 -0800
IronPort-SDR: Mp8oKFuCuA6dAZ2YZ/k3bHQSVYlOl31EFoAhZtw2KltKpjEurl1bATYaVs9WFlQSWAC71xuHE6
 2n62yqCcbYLg==
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="394665971"
Received: from yisun1-ubuntu.bj.intel.com (HELO yi.y.sun) ([10.238.156.116])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 07 Feb 2021 02:01:56 -0800
Date:   Sun, 7 Feb 2021 17:56:30 +0800
From:   Yi Sun <yi.y.sun@linux.intel.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com,
        yuzenghui@huawei.com, lushenming@huawei.com, kevin.tian@intel.com,
        yan.y.zhao@intel.com, baolu.lu@linux.intel.com
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
Message-ID: <20210207095630.GA28580@yi.y.sun>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210128151742.18840-11-zhukeqian1@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 21-01-28 23:17:41, Keqian Zhu wrote:

[...]

> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
> +				     struct vfio_dma *dma)
> +{
> +	struct vfio_domain *d;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		/* Go through all domain anyway even if we fail */
> +		iommu_split_block(d->domain, dma->iova, dma->size);
> +	}
> +}

This should be a switch to prepare for dirty log start. Per Intel
Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
It enables Accessed/Dirty Flags in second-level paging entries.
So, a generic iommu interface here is better. For Intel iommu, it
enables SLADE. For ARM, it splits block.

> +
> +static void vfio_dma_dirty_log_stop(struct vfio_iommu *iommu,
> +				    struct vfio_dma *dma)
> +{
> +	struct vfio_domain *d;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		/* Go through all domain anyway even if we fail */
> +		iommu_merge_page(d->domain, dma->iova, dma->size,
> +				 d->prot | dma->prot);
> +	}
> +}

Same as above comment, a generic interface is required here.

> +
> +static void vfio_iommu_dirty_log_switch(struct vfio_iommu *iommu, bool start)
> +{
> +	struct rb_node *n;
> +
> +	/* Split and merge even if all iommu don't support HWDBM now */
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		if (!dma->iommu_mapped)
> +			continue;
> +
> +		/* Go through all dma range anyway even if we fail */
> +		if (start)
> +			vfio_dma_dirty_log_start(iommu, dma);
> +		else
> +			vfio_dma_dirty_log_stop(iommu, dma);
> +	}
> +}
> +
>  static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  					unsigned long arg)
>  {
> @@ -2812,8 +2900,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>  		if (!iommu->dirty_page_tracking) {
>  			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> -			if (!ret)
> +			if (!ret) {
>  				iommu->dirty_page_tracking = true;
> +				vfio_iommu_dirty_log_switch(iommu, true);
> +			}
>  		}
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> @@ -2822,6 +2912,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		if (iommu->dirty_page_tracking) {
>  			iommu->dirty_page_tracking = false;
>  			vfio_dma_bitmap_free_all(iommu);
> +			vfio_iommu_dirty_log_switch(iommu, false);
>  		}
>  		mutex_unlock(&iommu->lock);
>  		return 0;
> -- 
> 2.19.1
