Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C082F897C
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbhAOXjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 18:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbhAOXjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 18:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610753867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f4lruco0oPKqZQoWQHySstTWv9/IZ9UW7zETLf13+EE=;
        b=gGtnqmHvssvL6P4h9Ai5F4hbQAkcKnDKSGDcqjOVeqgWZucJsVCKtf+ACXSkzPVIPCkA1V
        El+TjFg9MMAuc1rNwHayVkbUYDMJHbqSgl/sAa5EzA8em+NFqyd68fJ4O2OlCsDVg6QEpo
        57RNDoi+Ev78gcayGuGf+7qE6tcFPrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-Pzajvn_WMai53lejIzHg9Q-1; Fri, 15 Jan 2021 18:37:43 -0500
X-MC-Unique: Pzajvn_WMai53lejIzHg9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87CDCC2A7;
        Fri, 15 Jan 2021 23:37:40 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB31E61F49;
        Fri, 15 Jan 2021 23:37:38 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:37:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH 4/6] vfio/iommu_type1: Drop parameter "pgsize" of
 vfio_dma_bitmap_alloc_all
Message-ID: <20210115163738.112f0c34@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-5-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
        <20210107044401.19828-5-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 12:43:59 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> We always use the smallest supported page size of vfio_iommu as
> pgsize. Remove parameter "pgsize" of vfio_dma_bitmap_alloc_all.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b596c482487b..080c05b129ee 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -236,9 +236,10 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  	}
>  }
>  
> -static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>  {
>  	struct rb_node *n;
> +	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>  
>  	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>  		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> @@ -2761,12 +2762,9 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		return -EINVAL;
>  
>  	if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> -		size_t pgsize;
> -
>  		mutex_lock(&iommu->lock);
> -		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>  		if (!iommu->dirty_page_tracking) {
> -			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> +			ret = vfio_dma_bitmap_alloc_all(iommu);
>  			if (!ret)
>  				iommu->dirty_page_tracking = true;
>  		}

This just moves the same calculation from one place to another, what's
the point?  Thanks,

Alex

