Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F7218BC4F
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgCSQWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:22:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51270 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727064AbgCSQWv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 12:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584634969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5E3CHZq6olelajyC8ii74mtawhV43FEdby2RdOlWkSM=;
        b=N/oT4JmuwCQYze8SaKydW6o5UyacXaRwKv+m0n5RpM785G370I3A5mE0jkSBKSCqi63AFJ
        D/LDJ7FF1BB9zQDsRa2iovk9JOJn2ZAaI4qFiLYqxG+iNZA0MeEwB/nhjXn0vjGYgYXeeC
        WgmvZg2hxJx0JG4649+Yb4XzeYhCnOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-LCu4D0u2OPaY_HwWQIGmzA-1; Thu, 19 Mar 2020 12:22:43 -0400
X-MC-Unique: LCu4D0u2OPaY_HwWQIGmzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 575C7801E53;
        Thu, 19 Mar 2020 16:22:40 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A893760BFB;
        Thu, 19 Mar 2020 16:22:38 +0000 (UTC)
Date:   Thu, 19 Mar 2020 10:22:38 -0600
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
Subject: Re: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200319102238.77686a08@w520.home>
In-Reply-To: <e0070cf4-af58-2906-b427-0888ecb89538@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
        <20200318214500.1a0cb985@w520.home>
        <e0070cf4-af58-2906-b427-0888ecb89538@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 20:22:41 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 3/19/2020 9:15 AM, Alex Williamson wrote:
> > On Thu, 19 Mar 2020 01:11:11 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
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
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 205 +++++++++++++++++++++++++++++++++++++++-
> >>   1 file changed, 203 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 70aeab921d0f..d6417fb02174 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -71,6 +71,7 @@ struct vfio_iommu {
> >>   	unsigned int		dma_avail;
> >>   	bool			v2;
> >>   	bool			nesting;
> >> +	bool			dirty_page_tracking;
> >>   };
> >>   
> >>   struct vfio_domain {
> >> @@ -91,6 +92,7 @@ struct vfio_dma {
> >>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >>   	struct task_struct	*task;
> >>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >> +	unsigned long		*bitmap;  
> > 
> > We've made the bitmap a width invariant u64 else, should be here as
> > well.
> >   
> >>   };
> >>   
> >>   struct vfio_group {
> >> @@ -125,7 +127,10 @@ struct vfio_regions {
> >>   #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >>   					(!list_empty(&iommu->domain_list))
> >>   
> >> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> >> +
> >>   static int put_pfn(unsigned long pfn, int prot);
> >> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >>   
> >>   /*
> >>    * This code handles mapping and unmapping of user data buffers
> >> @@ -175,6 +180,55 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >>   	rb_erase(&old->node, &iommu->dma_list);
> >>   }
> >>   
> >> +static int vfio_dma_bitmap_alloc(struct vfio_iommu *iommu, uint64_t pgsize)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +		struct rb_node *p;
> >> +		unsigned long npages = dma->size / pgsize;
> >> +
> >> +		dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> >> +		if (!dma->bitmap) {
> >> +			struct rb_node *p = rb_prev(n);
> >> +
> >> +			for (; p; p = rb_prev(p)) {
> >> +				struct vfio_dma *dma = rb_entry(n,
> >> +							struct vfio_dma, node);
> >> +
> >> +				kfree(dma->bitmap);
> >> +				dma->bitmap = NULL;
> >> +			}
> >> +			return -ENOMEM;
> >> +		}
> >> +
> >> +		if (RB_EMPTY_ROOT(&dma->pfn_list))
> >> +			continue;
> >> +
> >> +		for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> >> +			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
> >> +							 node);
> >> +
> >> +			bitmap_set(dma->bitmap,
> >> +					(vpfn->iova - dma->iova) / pgsize, 1);
> >> +		}
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static void vfio_dma_bitmap_free(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		kfree(dma->bitmap);
> >> +		dma->bitmap = NULL;
> >> +	}
> >> +}
> >> +
> >>   /*
> >>    * Helper Functions for host iova-pfn list
> >>    */
> >> @@ -567,6 +621,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   			vfio_unpin_page_external(dma, iova, do_accounting);
> >>   			goto pin_unwind;
> >>   		}
> >> +
> >> +		if (iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift =
> >> +					 __ffs(vfio_pgsize_bitmap(iommu));
> >> +
> >> +			bitmap_set(dma->bitmap,
> >> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> >> +		}
> >>   	}
> >>   
> >>   	ret = i;
> >> @@ -801,6 +863,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >>   	vfio_unmap_unpin(iommu, dma, true);
> >>   	vfio_unlink_dma(iommu, dma);
> >>   	put_task_struct(dma->task);
> >> +	kfree(dma->bitmap);
> >>   	kfree(dma);
> >>   	iommu->dma_avail++;
> >>   }
> >> @@ -831,6 +894,50 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >>   	return bitmap;
> >>   }
> >>   
> >> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >> +				  size_t size, uint64_t pgsize,
> >> +				  unsigned char __user *bitmap)  
> > 
> > And here, why do callers cast to an unsigned char pointer when we're
> > going to cast to a void pointer anyway?  Should be a u64 __user pointer.
> >   
> >> +{
> >> +	struct vfio_dma *dma;
> >> +	unsigned long pgshift = __ffs(pgsize);
> >> +	unsigned int npages, bitmap_size;
> >> +
> >> +	dma = vfio_find_dma(iommu, iova, 1);
> >> +
> >> +	if (!dma)
> >> +		return -EINVAL;
> >> +
> >> +	if (dma->iova != iova || dma->size != size)
> >> +		return -EINVAL;
> >> +
> >> +	npages = dma->size >> pgshift;
> >> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> >> +
> >> +	/* mark all pages dirty if all pages are pinned and mapped. */
> >> +	if (dma->iommu_mapped)
> >> +		bitmap_set(dma->bitmap, 0, npages);
> >> +
> >> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> >> +		return -EFAULT;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> >> +{
> >> +	uint64_t bsize;
> >> +
> >> +	if (!npages || !bitmap_size || bitmap_size > UINT_MAX)  
> > 
> > As commented previously, how do we derive this UINT_MAX limitation?
> >   
> 
> Sorry, I missed that earlier
> 
>  > UINT_MAX seems arbitrary, is this specified in our API?  The size of a
>  > vfio_dma is limited to what the user is able to pin, and therefore
>  > their locked memory limit, but do we have an explicit limit elsewhere
>  > that results in this limit here.  I think a 4GB bitmap would track
>  > something like 2^47 bytes of memory, that's pretty excessive, but still
>  > an arbitrary limit.  
> 
> There has to be some upper limit check. In core KVM, in
> virt/kvm/kvm_main.c there is max number of pages check:
> 
> if (new.npages > KVM_MEM_MAX_NR_PAGES)
> 
> Where
> /*
>   * Some of the bitops functions do not support too long bitmaps.
>   * This number must be determined not to exceed such limits.
>   */
> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
> 
> Though I don't know which bitops functions do not support long bitmaps.
> 
> Something similar as above can be done or same as you also mentioned of 
> 4GB bitmap limit? that is U32_MAX instead of UINT_MAX?

Let's see, we use bitmap_set():

void bitmap_set(unsigned long *map, unsigned int start, unsigned int nbits)

So we're limited to an unsigned int number of bits, but for an
unaligned, multi-bit operation this will call __bitmap_set():

void __bitmap_set(unsigned long *map, unsigned int start, int len)

So we're down to a signed int number of bits (seems like an API bug in
bitops there), so it makes sense that KVM is testing against MAX_INT
number of pages, ie. number of bits.  But that still suggests a bitmap
size of MAX_UINT is off by a factor of 16.  So we can have 2^31 bits
divided by 2^3 bits/byte yields a maximum bitmap size of 2^28 (ie.
256MB), which maps 2^31 * 2^12 = 2^43 (8TB) on a 4K system.

Let's fix the limit check and put a nice comment explaining it.  Thanks,

Alex

> >> +		return -EINVAL;
> >> +
> >> +	bsize = DIRTY_BITMAP_BYTES(npages);
> >> +
> >> +	if (bitmap_size < bsize)
> >> +		return -EINVAL;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   			     struct vfio_iommu_type1_dma_unmap *unmap)
> >>   {  
> > 
> > We didn't address that vfio_dma_do_map() needs to kvzalloc a bitmap for
> > any new vfio_dma created while iommu->dirty_page_tracking = true.
> >   
> 
> Good point. Adding it.
> 
> Thanks,
> Kirti
> 
> >> @@ -2278,6 +2385,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   
> >>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> >>   			-EFAULT : 0;
> >> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> >> +		struct vfio_iommu_type1_dirty_bitmap dirty;
> >> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> >> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> >> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> >> +		int ret = 0;
> >> +
> >> +		if (!iommu->v2)
> >> +			return -EACCES;
> >> +
> >> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> >> +				    flags);
> >> +
> >> +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (dirty.argsz < minsz || dirty.flags & ~mask)
> >> +			return -EINVAL;
> >> +
> >> +		/* only one flag should be set at a time */
> >> +		if (__ffs(dirty.flags) != __fls(dirty.flags))
> >> +			return -EINVAL;
> >> +
> >> +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> >> +			uint64_t pgsize = 1 << __ffs(vfio_pgsize_bitmap(iommu));
> >> +
> >> +			mutex_lock(&iommu->lock);
> >> +			if (!iommu->dirty_page_tracking) {
> >> +				ret = vfio_dma_bitmap_alloc(iommu, pgsize);
> >> +				if (!ret)
> >> +					iommu->dirty_page_tracking = true;
> >> +			}
> >> +			mutex_unlock(&iommu->lock);
> >> +			return ret;
> >> +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> >> +			mutex_lock(&iommu->lock);
> >> +			if (iommu->dirty_page_tracking) {
> >> +				iommu->dirty_page_tracking = false;
> >> +				vfio_dma_bitmap_free(iommu);
> >> +			}
> >> +			mutex_unlock(&iommu->lock);
> >> +			return 0;
> >> +		} else if (dirty.flags &
> >> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >> +			struct vfio_iommu_type1_dirty_bitmap_get range;
> >> +			unsigned long pgshift;
> >> +			size_t data_size = dirty.argsz - minsz;
> >> +			uint64_t iommu_pgsize =
> >> +					 1 << __ffs(vfio_pgsize_bitmap(iommu));
> >> +
> >> +			if (!data_size || data_size < sizeof(range))
> >> +				return -EINVAL;
> >> +
> >> +			if (copy_from_user(&range, (void __user *)(arg + minsz),
> >> +					   sizeof(range)))
> >> +				return -EFAULT;
> >> +
> >> +			/* allow only min supported pgsize */
> >> +			if (range.bitmap.pgsize != iommu_pgsize)
> >> +				return -EINVAL;
> >> +			if (range.iova & (iommu_pgsize - 1))
> >> +				return -EINVAL;
> >> +			if (!range.size || range.size & (iommu_pgsize - 1))
> >> +				return -EINVAL;
> >> +			if (range.iova + range.size < range.iova)
> >> +				return -EINVAL;
> >> +			if (!access_ok((void __user *)range.bitmap.data,
> >> +				       range.bitmap.size))
> >> +				return -EINVAL;
> >> +
> >> +			pgshift = __ffs(range.bitmap.pgsize);
> >> +			ret = verify_bitmap_size(range.size >> pgshift,
> >> +						 range.bitmap.size);
> >> +			if (ret)
> >> +				return ret;
> >> +
> >> +			mutex_lock(&iommu->lock);
> >> +			if (iommu->dirty_page_tracking)
> >> +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
> >> +					 range.size, range.bitmap.pgsize,
> >> +				    (unsigned char __user *)range.bitmap.data);
> >> +			else
> >> +				ret = -EINVAL;
> >> +			mutex_unlock(&iommu->lock);
> >> +
> >> +			return ret;
> >> +		}
> >>   	}
> >>   
> >>   	return -ENOTTY;
> >> @@ -2345,10 +2539,17 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> >>   
> >>   	vaddr = dma->vaddr + offset;
> >>   
> >> -	if (write)
> >> +	if (write) {
> >>   		*copied = __copy_to_user((void __user *)vaddr, data,
> >>   					 count) ? 0 : count;
> >> -	else
> >> +		if (*copied && iommu->dirty_page_tracking) {
> >> +			unsigned long pgshift =
> >> +				__ffs(vfio_pgsize_bitmap(iommu));
> >> +
> >> +			bitmap_set(dma->bitmap, offset >> pgshift,
> >> +				   *copied >> pgshift);
> >> +		}
> >> +	} else  
> > 
> > Great, thanks for adding this!
> >   
> >>   		*copied = __copy_from_user(data, (void __user *)vaddr,
> >>   					   count) ? 0 : count;
> >>   	if (kthread)  
> >   
> 

