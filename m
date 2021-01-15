Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E618F2F833B
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 19:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAOSDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 13:03:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726519AbhAOSDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 13:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610733714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gq10Kr5xse22ieR9b4aF/0j+yRbARGW5WK7gbGTTvCI=;
        b=AACCP0VmzRAPiQcQ43ied0klwKAs4QBIgqTsiW81gqngo7pN+40H+8LGEWH+63exEV0WLq
        gy1MHqrsd5FbUIA6Un02tVaW8LertZyhPHrtnpyAB9YPE3yISoL236MOdd0TNrsI42MDdo
        srlZ9kb2Lt5KN7RuK+o6RfTcyyc6FyY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-gAhkavzzP3CD-QHWbBOljQ-1; Fri, 15 Jan 2021 13:01:50 -0500
X-MC-Unique: gAhkavzzP3CD-QHWbBOljQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11F6107ACF8;
        Fri, 15 Jan 2021 18:01:47 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90E4460BF3;
        Fri, 15 Jan 2021 18:01:45 +0000 (UTC)
Date:   Fri, 15 Jan 2021 11:01:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v2 1/2] vfio/iommu_type1: Populate full dirty when
 detach non-pinned group
Message-ID: <20210115110144.61e3c843@omen.home.shazbot.org>
In-Reply-To: <20210115092643.728-2-zhukeqian1@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
        <20210115092643.728-2-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Jan 2021 17:26:42 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> If a group with non-pinned-page dirty scope is detached with dirty
> logging enabled, we should fully populate the dirty bitmaps at the
> time it's removed since we don't know the extent of its previous DMA,
> nor will the group be present to trigger the full bitmap when the user
> retrieves the dirty bitmap.
> 
> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0b4dedaa9128..4e82b9a3440f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -236,6 +236,19 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>  	}
>  }
>  
> +static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n;
> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		if (dma->iommu_mapped)
> +			bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
> +	}
> +}
> +
>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>  {
>  	struct rb_node *n;
> @@ -2415,8 +2428,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>  	 * Removal of a group without dirty tracking may allow the iommu scope
>  	 * to be promoted.
>  	 */
> -	if (update_dirty_scope)
> +	if (update_dirty_scope) {
>  		update_pinned_page_dirty_scope(iommu);
> +		if (iommu->dirty_page_tracking)
> +			vfio_iommu_populate_bitmap_full(iommu);
> +	}
>  	mutex_unlock(&iommu->lock);
>  }
>  

This doesn't do the right thing.  This marks the bitmap dirty if:

 * The detached group dirty scope was not limited to pinned pages

 AND

 * Dirty tracking is enabled

 AND

 * The vfio_dma is *currently* (ie. after the detach) iommu_mapped

We need to mark the bitmap dirty based on whether the vfio_dma *was*
iommu_mapped by the group that is now detached.  Thanks,

Alex

