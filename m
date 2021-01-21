Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC542FF2DE
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 19:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389426AbhAUSHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 13:07:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389381AbhAUSH0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 13:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611252359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0BzXy7E7RCQ8XomVqvpDGY8133NeYJFV0xqq8nPS+0=;
        b=ZQniOnXe3w/1+6o7JUioJ/rWXLe+6HMFQV9NXhyyPBTu21u0l8fmzYQiVWvNIHLurupDUt
        AMRXISacvOzrCv0RSTrEIALDXAmRd2OThcQvis2kj6koA1fMYqejhvYJpTgwqpBVdMHeHe
        8/xYKvhrqGQSY7DN5j93jIFUGOHuhWA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-mlXu5cnsPNOhiPC0mfKlzQ-1; Thu, 21 Jan 2021 13:05:54 -0500
X-MC-Unique: mlXu5cnsPNOhiPC0mfKlzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CE1D15725;
        Thu, 21 Jan 2021 18:05:51 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1871360BF3;
        Thu, 21 Jan 2021 18:05:49 +0000 (UTC)
Date:   Thu, 21 Jan 2021 11:05:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH v2 1/2] vfio/iommu_type1: Populate full dirty when
 detach non-pinned group
Message-ID: <20210121110548.33f37048@omen.home.shazbot.org>
In-Reply-To: <f8de434c-1993-cfe8-c451-2235be1ceb85@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
        <20210115092643.728-2-zhukeqian1@huawei.com>
        <20210115110144.61e3c843@omen.home.shazbot.org>
        <f8de434c-1993-cfe8-c451-2235be1ceb85@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 Jan 2021 20:25:09 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> On 2021/1/16 2:01, Alex Williamson wrote:
> > On Fri, 15 Jan 2021 17:26:42 +0800
> > Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >   
> >> If a group with non-pinned-page dirty scope is detached with dirty
> >> logging enabled, we should fully populate the dirty bitmaps at the
> >> time it's removed since we don't know the extent of its previous DMA,
> >> nor will the group be present to trigger the full bitmap when the user
> >> retrieves the dirty bitmap.
> >>
> >> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> >> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> >> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
> >>  1 file changed, 17 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 0b4dedaa9128..4e82b9a3440f 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -236,6 +236,19 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
> >>  	}
> >>  }
> >>  
> >> +static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n;
> >> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> >> +
> >> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		if (dma->iommu_mapped)
> >> +			bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
> >> +	}
> >> +}
> >> +
> >>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> >>  {
> >>  	struct rb_node *n;
> >> @@ -2415,8 +2428,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> >>  	 * Removal of a group without dirty tracking may allow the iommu scope
> >>  	 * to be promoted.
> >>  	 */
> >> -	if (update_dirty_scope)
> >> +	if (update_dirty_scope) {
> >>  		update_pinned_page_dirty_scope(iommu);
> >> +		if (iommu->dirty_page_tracking)
> >> +			vfio_iommu_populate_bitmap_full(iommu);
> >> +	}
> >>  	mutex_unlock(&iommu->lock);
> >>  }
> >>    
> > 
> > This doesn't do the right thing.  This marks the bitmap dirty if:
> > 
> >  * The detached group dirty scope was not limited to pinned pages
> > 
> >  AND
> > 
> >  * Dirty tracking is enabled
> > 
> >  AND
> > 
> >  * The vfio_dma is *currently* (ie. after the detach) iommu_mapped
> > 
> > We need to mark the bitmap dirty based on whether the vfio_dma *was*
> > iommu_mapped by the group that is now detached.  Thanks,
> > 
> > Alex
> >   
> Hi Alex,
> 
> Yes, I missed this point again :-(. The update_dirty_scope means we
> detached an iommu backed group, and that means the vfio_dma *was*
> iommu_mapped by this group, so we can populate full bitmap
> unconditionally, right?

To do it unconditionally, the assumption would be that all current
vfio_dmas are iommu_mapped.  It seems like it's deterministic that a
non-pinned-page scope group implies all vfio_dmas are iommu_mapped.  I
can't currently think of an exception.  Thanks,

Alex

