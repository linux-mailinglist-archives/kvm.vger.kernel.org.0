Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3992D6636
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393357AbgLJTSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:18:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392857AbgLJTSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 14:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607627818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5kmp9gy5nxGFdrl4LVG8Ly3qZOFyWyiuhjDzmpydZu0=;
        b=ckpziQfxpdcKMa6couIMEWdCA3gmujRCVrN6Fx6hMsEIjCporHE48ICAn4mHLcdCDtfwh4
        1cxkFf9o21rw3gJylVLUC5NS5E6cSl9RrdltYe5My4Pq3sACVoDLnd6VwogScSEBGN1o90
        X1y7XvYznCvWyYGc5kCvKDzG93rRl3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-RbUqo1cuMGOk8bK4pmTycw-1; Thu, 10 Dec 2020 14:16:54 -0500
X-MC-Unique: RbUqo1cuMGOk8bK4pmTycw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF75710054FF;
        Thu, 10 Dec 2020 19:16:50 +0000 (UTC)
Received: from omen.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B078B5D6D3;
        Thu, 10 Dec 2020 19:16:47 +0000 (UTC)
Date:   Thu, 10 Dec 2020 12:16:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH 1/7] vfio: iommu_type1: Clear added dirty bit when
 unwind pin
Message-ID: <20201210121646.24fb3cd8@omen.home>
In-Reply-To: <20201210073425.25960-2-zhukeqian1@huawei.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
        <20201210073425.25960-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 15:34:19 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> Currently we do not clear added dirty bit of bitmap when unwind
> pin, so if pin failed at halfway, we set unnecessary dirty bit
> in bitmap. Clearing added dirty bit when unwind pin, userspace
> will see less dirty page, which can save much time to handle them.
> 
> Note that we should distinguish the bits added by pin and the bits
> already set before pin, so introduce bitmap_added to record this.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 67e827638995..f129d24a6ec3 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -637,7 +637,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	struct vfio_iommu *iommu = iommu_data;
>  	struct vfio_group *group;
>  	int i, j, ret;
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>  	unsigned long remote_vaddr;
> +	unsigned long bitmap_offset;
> +	unsigned long *bitmap_added;
> +	dma_addr_t iova;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
>  
> @@ -650,6 +654,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	bitmap_added = bitmap_zalloc(npage, GFP_KERNEL);
> +	if (!bitmap_added) {
> +		ret = -ENOMEM;
> +		goto pin_done;
> +	}


This is allocated regardless of whether dirty tracking is enabled, so
this adds overhead to the common case in order to reduce user overhead
(not correctness) in the rare condition that dirty tracking is enabled,
and the even rarer condition that there's a fault during that case.
This is not a good trade-off.  Thanks,

Alex


> +
>  	/* Fail if notifier list is empty */
>  	if (!iommu->notifier.head) {
>  		ret = -EINVAL;
> @@ -664,7 +674,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>  
>  	for (i = 0; i < npage; i++) {
> -		dma_addr_t iova;
>  		struct vfio_pfn *vpfn;
>  
>  		iova = user_pfn[i] << PAGE_SHIFT;
> @@ -699,14 +708,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		}
>  
>  		if (iommu->dirty_page_tracking) {
> -			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> -
> -			/*
> -			 * Bitmap populated with the smallest supported page
> -			 * size
> -			 */
> -			bitmap_set(dma->bitmap,
> -				   (iova - dma->iova) >> pgshift, 1);
> +			/* Populated with the smallest supported page size */
> +			bitmap_offset = (iova - dma->iova) >> pgshift;
> +			if (!test_and_set_bit(bitmap_offset, dma->bitmap))
> +				set_bit(i, bitmap_added);
>  		}
>  	}
>  	ret = i;
> @@ -722,14 +727,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  pin_unwind:
>  	phys_pfn[i] = 0;
>  	for (j = 0; j < i; j++) {
> -		dma_addr_t iova;
> -
>  		iova = user_pfn[j] << PAGE_SHIFT;
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>  		vfio_unpin_page_external(dma, iova, do_accounting);
>  		phys_pfn[j] = 0;
> +
> +		if (test_bit(j, bitmap_added)) {
> +			bitmap_offset = (iova - dma->iova) >> pgshift;
> +			clear_bit(bitmap_offset, dma->bitmap);
> +		}
>  	}
>  pin_done:
> +	if (bitmap_added)
> +		bitmap_free(bitmap_added);
> +
>  	mutex_unlock(&iommu->lock);
>  	return ret;
>  }

