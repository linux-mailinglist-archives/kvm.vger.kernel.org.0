Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80E71D5409
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgEOPP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:15:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726295AbgEOPP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 11:15:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589555754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p0/M0lhsGgck9q4bh5uc5CG4I5IojC672QlJB9lODL4=;
        b=Ww20mL8nJmK3XL8du72OjYf0ehAOALoZ0c0iZF0x9XH6Y52k4O2vUE38ZQt7uHAqJ6JIGd
        iy2Y1wfdLXXZxbUcIXYzZ1fGL0YMhqBEVT6vFFhZxyy4XklvM8OVzT64eNp8BVzZC5m78H
        9FYqvZ02Cmhb/NJTZyKdFVaqEtZ7WDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-EbIgBuGTPNG1-P1sM3xPYQ-1; Fri, 15 May 2020 11:15:50 -0400
X-MC-Unique: EbIgBuGTPNG1-P1sM3xPYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F2E98018AD;
        Fri, 15 May 2020 15:15:47 +0000 (UTC)
Received: from w520.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 124FB5D9F3;
        Fri, 15 May 2020 15:15:34 +0000 (UTC)
Date:   Fri, 15 May 2020 09:15:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v20 5/8] vfio iommu: Implementation of ioctl for
 dirty pages tracking
Message-ID: <20200515091533.53259392@w520.home>
In-Reply-To: <be9ff834-04b5-56c2-b103-44eff794bd3a@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-6-git-send-email-kwankhede@nvidia.com>
        <20200515100553.GA5559@joy-OptiPlex-7040>
        <be9ff834-04b5-56c2-b103-44eff794bd3a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 16:44:38 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/15/2020 3:35 PM, Yan Zhao wrote:
> > On Fri, May 15, 2020 at 02:07:44AM +0530, Kirti Wankhede wrote:  
> >> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> >> - Start dirty pages tracking while migration is active
> >> - Stop dirty pages tracking.
> >> - Get dirty pages bitmap. Its user space application's responsibility to
> >>    copy content of dirty pages from source to destination during migration.
> >>
> >> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> >> structure. Bitmap size is calculated considering smallest supported page
> >> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> >>
> >> Bitmap is populated for already pinned pages when bitmap is allocated for
> >> a vfio_dma with the smallest supported page size. Update bitmap from
> >> pinning functions when tracking is enabled. When user application queries
> >> bitmap, check if requested page size is same as page size used to
> >> populated bitmap. If it is equal, copy bitmap, but if not equal, return
> >> error.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>
> >> Fixed error reported by build bot by changing pgsize type from uint64_t
> >> to size_t.
> >> Reported-by: kbuild test robot <lkp@intel.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 294 +++++++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 288 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index de17787ffece..b76d3b14abfd 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -72,6 +72,7 @@ struct vfio_iommu {
> >>   	uint64_t		pgsize_bitmap;
> >>   	bool			v2;
> >>   	bool			nesting;
> >> +	bool			dirty_page_tracking;
> >>   };
> >>   
> >>   struct vfio_domain {
> >> @@ -92,6 +93,7 @@ struct vfio_dma {
> >>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >>   	struct task_struct	*task;
> >>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >> +	unsigned long		*bitmap;
> >>   };
> >>   
> >>   struct vfio_group {
> >> @@ -126,6 +128,19 @@ struct vfio_regions {
> >>   #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >>   					(!list_empty(&iommu->domain_list))
> >>   
> >> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> >> +
> >> +/*
> >> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> >> + * further casts to signed integer for unaligned multi-bit operation,
> >> + * __bitmap_set().
> >> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> >> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> >> + * system.
> >> + */
> >> +#define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
> >> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> >> +
> >>   static int put_pfn(unsigned long pfn, int prot);
> >>   
> >>   /*
> >> @@ -176,6 +191,74 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >>   	rb_erase(&old->node, &iommu->dma_list);
> >>   }
> >>   
> >> +
> >> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
> >> +{
> >> +	uint64_t npages = dma->size / pgsize;
> >> +
> >> +	if (npages > DIRTY_BITMAP_PAGES_MAX)
> >> +		return -EINVAL;
> >> +
> >> +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> >> +	if (!dma->bitmap)
> >> +		return -ENOMEM;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
> >> +{
> >> +	kfree(dma->bitmap);
> >> +	dma->bitmap = NULL;
> >> +}
> >> +
> >> +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
> >> +{
> >> +	struct rb_node *p;
> >> +
> >> +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> >> +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
> >> +
> >> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> >> +	}
> >> +}
> >> +
> >> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +		int ret;
> >> +
> >> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> >> +		if (ret) {
> >> +			struct rb_node *p = rb_prev(n);
> >> +
> >> +			for (; p; p = rb_prev(p)) {
> >> +				struct vfio_dma *dma = rb_entry(n,
> >> +							struct vfio_dma, node);
> >> +
> >> +				vfio_dma_bitmap_free(dma);
> >> +			}
> >> +			return ret;
> >> +		}
> >> +		vfio_dma_populate_bitmap(dma, pgsize);
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		vfio_dma_bitmap_free(dma);
> >> +	}
> >> +}
> >> +
> >>   /*
> >>    * Helper Functions for host iova-pfn list
> >>    */
> >> @@ -568,6 +651,17 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   			vfio_unpin_page_external(dma, iova, do_accounting);
> >>   			goto pin_unwind;
> >>   		}
> >> +
> >> +		if (iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> >> +
> >> +			/*
> >> +			 * Bitmap populated with the smallest supported page
> >> +			 * size
> >> +			 */
> >> +			bitmap_set(dma->bitmap,
> >> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> >> +		}
> >>   	}
> >>   
> >>   	ret = i;
> >> @@ -802,6 +896,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >>   	vfio_unmap_unpin(iommu, dma, true);
> >>   	vfio_unlink_dma(iommu, dma);
> >>   	put_task_struct(dma->task);
> >> +	vfio_dma_bitmap_free(dma);
> >>   	kfree(dma);
> >>   	iommu->dma_avail++;
> >>   }
> >> @@ -829,6 +924,80 @@ static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >>   	}
> >>   }
> >>   
> >> +static int update_user_bitmap(u64 __user *bitmap, struct vfio_dma *dma,
> >> +			      dma_addr_t base_iova, size_t pgsize)
> >> +{
> >> +	unsigned long pgshift = __ffs(pgsize);
> >> +	unsigned long nbits = dma->size >> pgshift;
> >> +	unsigned long bit_offset = (dma->iova - base_iova) >> pgshift;
> >> +	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
> >> +	unsigned long shift = bit_offset % BITS_PER_LONG;
> >> +	unsigned long leftover;
> >> +
> >> +	if (shift) {
> >> +		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
> >> +				  nbits + shift);
> >> +
> >> +		if (copy_from_user(&leftover, (u64 *)bitmap + copy_offset,
> >> +				   sizeof(leftover)))
> >> +			return -EFAULT;
> >> +
> >> +		bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
> >> +	}
> >> +
> >> +	if (copy_to_user((u64 *)bitmap + copy_offset, dma->bitmap,
> >> +			 DIRTY_BITMAP_BYTES(nbits + shift)))
> >> +		return -EFAULT;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> >> +				  dma_addr_t iova, size_t size, size_t pgsize)
> >> +{
> >> +	struct vfio_dma *dma;
> >> +	dma_addr_t i = iova, limit = iova + size;
> >> +	unsigned long pgshift = __ffs(pgsize);
> >> +	size_t sz = size;
> >> +	int ret;
> >> +
> >> +	while ((dma = vfio_find_dma(iommu, i, sz))) {  
> > not quite get the logic here.
> > if (i, i + size) is intersecting with (dma->iova, dma->iova + dma->size),
> > and a dma is found here, why the whole bitmap is cleared and copied?
> >   
> 
> This works with multiple but full vfio_dma, not intersects of vfio_dma, 
> similar to unmap ioctl.

I don't see that the VFIO_IOMMU_DIRTY_PAGES ioctl validates that like
VFIO_IOMMU_UNMAP_DMA does though.  We should have the same test as
vfio_dma_do_unmap() to verify that they user range doesn't bisect a
mapping, otherwise Yan is right, it looks like we allow the user to
specify an arbitrary range that might bisect a bitmap, but we clear and
attempt to copy the entire bitmap to the user buffer regardless.
Thanks,

Alex

