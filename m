Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA5199EA4
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgCaTGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:06:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39202 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726315AbgCaTGf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgxHMDFHS7EdhZt/y8v9VvwjbCh3+IDnijixAq81LLE=;
        b=UrL4uPs+/MX9qxvHB79wTh14/aN5ljquqM4PVK1eOJ6jUAyA4x6Bbovp5sWUKCjUcyrM+K
        oldI9B8wCQQ0NEPqpZs9EUZyr9C93VIM/3hyS1bvR2jwUSLuDd9fJdbi1Laq8iSS0LyfuY
        DjTEcScbL2mHY237htxXjSdqRAgduTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-uqrVF3hiNaKxOqicctyvDQ-1; Tue, 31 Mar 2020 15:06:30 -0400
X-MC-Unique: uqrVF3hiNaKxOqicctyvDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7B288017CC;
        Tue, 31 Mar 2020 19:06:27 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 889775C1BB;
        Tue, 31 Mar 2020 19:06:25 +0000 (UTC)
Date:   Tue, 31 Mar 2020 13:06:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v17 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200331130625.77851747@w520.home>
In-Reply-To: <66af06b5-4e87-9f7a-be85-08a68d6ab982@nvidia.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
        <1585587044-2408-6-git-send-email-kwankhede@nvidia.com>
        <20200330153421.6246c2c6@w520.home>
        <66af06b5-4e87-9f7a-be85-08a68d6ab982@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Apr 2020 00:16:13 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 3/31/2020 3:04 AM, Alex Williamson wrote:
> > On Mon, 30 Mar 2020 22:20:42 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> DMA mapped pages, including those pinned by mdev vendor drivers, might
> >> get unpinned and unmapped while migration is active and device is still
> >> running. For example, in pre-copy phase while guest driver could access
> >> those pages, host device or vendor driver can dirty these mapped pages.
> >> Such pages should be marked dirty so as to maintain memory consistency
> >> for a user making use of dirty page tracking.
> >>
> >> To get bitmap during unmap, user should allocate memory for bitmap, set
> >> size of allocated memory, set page size to be considered for bitmap and
> >> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
> >>   include/uapi/linux/vfio.h       | 10 ++++++++
> >>   2 files changed, 61 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 5efebc2b60e1..266550bd7307 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -983,7 +983,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> >>   }
> >>   
> >>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> >> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> >> +			     struct vfio_bitmap *bitmap)
> >>   {
> >>   	uint64_t mask;
> >>   	struct vfio_dma *dma, *dma_last = NULL;
> >> @@ -1034,6 +1035,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   	 * will be returned if these conditions are not met.  The v2 interface
> >>   	 * will only return success and a size of zero if there were no
> >>   	 * mappings within the range.
> >> +	 *
> >> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
> >> +	 * must be for single mapping. Multiple mappings with this flag set is
> >> +	 * not supported.
> >>   	 */
> >>   	if (iommu->v2) {
> >>   		dma = vfio_find_dma(iommu, unmap->iova, 1);
> >> @@ -1041,6 +1046,14 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   			ret = -EINVAL;
> >>   			goto unlock;
> >>   		}
> >> +
> >> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >> +		    dma &&
> >> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {  
> > 
> > 
> > I think your intention was to return error if the user asked for the
> > dirty bitmap and the requested unmap range doesn't exactly match the
> > vfio_dma.  Not finding a vfio_dma should therefore also be an error.
> > For example, if we had a single mapping at {0x1000-0x1fff} and the user
> > unmapped with dirty bitmap {0x0-0x2fff}, that should return an error,
> > but it's not caught by the above because there is no vfio_dma @0x0.
> > Therefore I think you want:
> > 
> > ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >   (!dma || dma->iova != unmap->iova || dma->size != unmap->size))
> > 
> > Right?  Thanks,
> >   
> 
> 
> Yes, updating check.
> 
> Is !dma here also error case when VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP 
> flag is not set?

No it's not.

> DMA_UNMAP ioctl returns how much was unmapped, from user space 
> perspective this would be from start of range (unmap->iova), right?

It's the actual amount of memory that was unmapped within the provided
range, without getting the dirty bitmap the range doesn't need to start
or end at a vfio_dma, it just cannot bisect a vfio_dma.  Thanks,

Alex

