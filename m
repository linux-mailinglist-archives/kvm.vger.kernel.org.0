Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FECC2DA486
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 01:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgLOAGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 19:06:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727211AbgLOAGe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 19:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607990707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6g3IZkefy8eigv1Fk+b3mkHNOWy4CEh/CsuZ+osvTpg=;
        b=RI/HhD7yxWR8w5M7A630pFTfU8jCZgIWQNhFgO4cfsQLxPDnAqzTlAbgqWWQbYGPlfE3N/
        pP3RA9xWlACH7nD6mytBCKaiTOD7Vv7Xqyj4fGBcDv/1+75fzK9tbbAo8q7MxuDd3dZAwh
        PYko6FnC4NsAT+8cmNHa1h4cjLa5ZVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-SlUMOcjYPhqQzRsC2yXrMQ-1; Mon, 14 Dec 2020 19:05:04 -0500
X-MC-Unique: SlUMOcjYPhqQzRsC2yXrMQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7820C59;
        Tue, 15 Dec 2020 00:05:01 +0000 (UTC)
Received: from omen.home (ovpn-112-193.phx2.redhat.com [10.3.112.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A28DC5D9DC;
        Tue, 15 Dec 2020 00:04:59 +0000 (UTC)
Date:   Mon, 14 Dec 2020 17:04:59 -0700
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
Subject: Re: [PATCH 4/7] vfio: iommu_type1: Fix missing dirty page when
 promote pinned_scope
Message-ID: <20201214170459.50cb8729@omen.home>
In-Reply-To: <20201210073425.25960-5-zhukeqian1@huawei.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
        <20201210073425.25960-5-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Dec 2020 15:34:22 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> When we pin or detach a group which is not dirty tracking capable,
> we will try to promote pinned_scope of vfio_iommu.
> 
> If we succeed to do so, vfio only report pinned_scope as dirty to
> userspace next time, but these memory written before pin or detach
> is missed.
> 
> The solution is that we must populate all dma range as dirty before
> promoting pinned_scope of vfio_iommu.

Please don't bury fixes patches into a series with other optimizations
and semantic changes.  Send it separately.

> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bd9a94590ebc..00684597b098 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1633,6 +1633,20 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>  	return group;
>  }
>  
> +static void vfio_populate_bitmap_all(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n;
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +		unsigned long nbits = dma->size >> pgshift;
> +
> +		if (dma->iommu_mapped)
> +			bitmap_set(dma->bitmap, 0, nbits);
> +	}
> +}


If we detach a group which results in only non-IOMMU backed mdevs,
don't we also clear dma->iommu_mapped as part of vfio_unmap_unpin()
such that this test is invalid?  Thanks,

Alex

> +
>  static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>  {
>  	struct vfio_domain *domain;
> @@ -1657,6 +1671,10 @@ static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
>  	}
>  
>  	iommu->pinned_page_dirty_scope = true;
> +
> +	/* Set all bitmap to avoid missing dirty page */
> +	if (iommu->dirty_page_tracking)
> +		vfio_populate_bitmap_all(iommu);
>  }
>  
>  static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,

