Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52372F8989
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 00:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbhAOXnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 18:43:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbhAOXna (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 18:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610754124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlht7br4mqv7F1sN7U7/EAPyte/4NdiUCZ7SCmktRbE=;
        b=A56Fs0zFttYr5AAs38Ymm4uvUiM9glXYApmb40q46hJf7jLn1ELFOrWfURcihKZ3CA4Blw
        a5D830kQlvMEB3qaNkXGnDHht16MEETNdFqZ5YH78zcc24jwS3wQfFUOuZOmFck7xwCaIt
        32oXvKBNXEefkQJVZzcatYeynGVDhNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-hgMpZCqAORS7qjHkQ2sM7A-1; Fri, 15 Jan 2021 18:39:30 -0500
X-MC-Unique: hgMpZCqAORS7qjHkQ2sM7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17826806660;
        Fri, 15 Jan 2021 23:39:28 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFF7A6F818;
        Fri, 15 Jan 2021 23:39:26 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:39:26 -0700
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
Subject: Re: [PATCH 5/6] vfio/iommu_type1: Drop parameter "pgsize" of
 vfio_iova_dirty_bitmap
Message-ID: <20210115163926.3d107090@omen.home.shazbot.org>
In-Reply-To: <20210107044401.19828-6-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
        <20210107044401.19828-6-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Jan 2021 12:44:00 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> We always use the smallest supported page size of vfio_iommu as
> pgsize. Remove parameter "pgsize" of vfio_iova_dirty_bitmap.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 080c05b129ee..82649a040148 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1015,11 +1015,12 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  }
>  
>  static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> -				  dma_addr_t iova, size_t size, size_t pgsize)
> +				  dma_addr_t iova, size_t size)
>  {
>  	struct vfio_dma *dma;
>  	struct rb_node *n;
> -	unsigned long pgshift = __ffs(pgsize);
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +	size_t pgsize = (size_t)1 << pgshift;
>  	int ret;
>  
>  	/*
> @@ -2824,8 +2825,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		if (iommu->dirty_page_tracking)
>  			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
>  						     iommu, range.iova,
> -						     range.size,
> -						     range.bitmap.pgsize);
> +						     range.size);
>  		else
>  			ret = -EINVAL;
>  out_unlock:

In this case the caller has actually already calculated both pgsize and
pgshift, the better optimization would be to pass both rather than
recalculate.  Thanks,

Alex

