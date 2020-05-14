Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D80A1D312A
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgENNWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 09:22:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNWZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 09:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589462542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MdFatK4dMmg5r9h9ucfSIgBeMZlPxRK7IWuruD5QQV8=;
        b=KaBsUi9/eQHRXsm8ARbH3A/aJn+DFWX7ny63q88jrFoB6cXtGNtI64myCe/XmMIA/hQLMV
        m6L7f7uhsZcMwTnCkxfZqbJ2wrGrA6UQ+Q/PcTTlKiyIG897uXFyxHFLbfg+9nFoaCRvIS
        zxCRzo6t1ERHIpDIEwq/M543sBYNFpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-ZceqEK4cOhyUTgfFAGxufw-1; Thu, 14 May 2020 09:22:09 -0400
X-MC-Unique: ZceqEK4cOhyUTgfFAGxufw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D3F4EC1A0;
        Thu, 14 May 2020 13:22:07 +0000 (UTC)
Received: from x1.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66DF781E0A;
        Thu, 14 May 2020 13:22:04 +0000 (UTC)
Date:   Thu, 14 May 2020 07:22:03 -0600
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
Subject: Re: [PATCH Kernel v19 6/8] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200514072203.3aee3e89@x1.home>
In-Reply-To: <65a90392-a140-6862-b7f2-2bddc6e71ba9@nvidia.com>
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
        <1589400279-28522-7-git-send-email-kwankhede@nvidia.com>
        <20200513230747.0d2f3bc3@x1.home>
        <65a90392-a140-6862-b7f2-2bddc6e71ba9@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 11:02:33 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 5/14/2020 10:37 AM, Alex Williamson wrote:
> > On Thu, 14 May 2020 01:34:37 +0530
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
> >>   drivers/vfio/vfio_iommu_type1.c | 102 +++++++++++++++++++++++++++++++++++-----
> >>   include/uapi/linux/vfio.h       |  10 ++++
> >>   2 files changed, 99 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 469b09185b83..4358be26ff80 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -195,11 +195,15 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >>   static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
> >>   {
> >>   	uint64_t npages = dma->size / pgsize;
> >> +	size_t bitmap_size;
> >>   
> >>   	if (npages > DIRTY_BITMAP_PAGES_MAX)
> >>   		return -EINVAL;
> >>   
> >> -	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> >> +	/* Allocate extra 64 bits which are used for bitmap manipulation */
> >> +	bitmap_size = DIRTY_BITMAP_BYTES(npages) + sizeof(u64);
> >> +
> >> +	dma->bitmap = kvzalloc(bitmap_size, GFP_KERNEL);
> >>   	if (!dma->bitmap)
> >>   		return -ENOMEM;
> >>   
> >> @@ -979,23 +983,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> >>   }
> >>   
> >>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> >> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> >> +			     struct vfio_bitmap *bitmap)
> >>   {
> >> -	uint64_t mask;
> >>   	struct vfio_dma *dma, *dma_last = NULL;
> >> -	size_t unmapped = 0;
> >> -	int ret = 0, retries = 0;
> >> +	size_t unmapped = 0, pgsize;
> >> +	int ret = 0, retries = 0, cnt = 0;
> >> +	unsigned long pgshift, shift = 0, leftover;
> >>   
> >>   	mutex_lock(&iommu->lock);
> >>   
> >> -	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
> >> +	pgshift = __ffs(iommu->pgsize_bitmap);
> >> +	pgsize = (size_t)1 << pgshift;
> >>   
> >> -	if (unmap->iova & mask) {
> >> +	if (unmap->iova & (pgsize - 1)) {
> >>   		ret = -EINVAL;
> >>   		goto unlock;
> >>   	}
> >>   
> >> -	if (!unmap->size || unmap->size & mask) {
> >> +	if (!unmap->size || unmap->size & (pgsize - 1)) {
> >>   		ret = -EINVAL;
> >>   		goto unlock;
> >>   	}
> >> @@ -1006,9 +1012,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   		goto unlock;
> >>   	}
> >>   
> >> -	WARN_ON(mask & PAGE_MASK);
> >> -again:
> >> +	/* When dirty tracking is enabled, allow only min supported pgsize */
> >> +	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >> +	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
> >> +		ret = -EINVAL;
> >> +		goto unlock;
> >> +	}
> >>   
> >> +	WARN_ON((pgsize - 1) & PAGE_MASK);
> >> +again:
> >>   	/*
> >>   	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
> >>   	 * avoid tracking individual mappings.  This means that the granularity
> >> @@ -1046,6 +1058,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   			ret = -EINVAL;
> >>   			goto unlock;
> >>   		}
> >> +
> >>   		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
> >>   		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
> >>   			ret = -EINVAL;
> >> @@ -1063,6 +1076,39 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   		if (dma->task->mm != current->mm)
> >>   			break;
> >>   
> >> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >> +		    (dma_last != dma)) {
> >> +			unsigned int nbits = dma->size >> pgshift;
> >> +			int curr_lcnt = nbits / BITS_PER_LONG;
> >> +
> >> +			/*
> >> +			 * mark all pages dirty if all pages are pinned and
> >> +			 * mapped.
> >> +			 */
> >> +			if (dma->iommu_mapped)
> >> +				bitmap_set(dma->bitmap, 0, nbits);
> >> +
> >> +			if (shift) {
> >> +				bitmap_shift_left(dma->bitmap, dma->bitmap,
> >> +						  shift, nbits + shift);
> >> +				bitmap_or(dma->bitmap, dma->bitmap, &leftover,
> >> +					  shift);
> >> +				nbits += shift;
> >> +				curr_lcnt = nbits / BITS_PER_LONG;
> >> +			}
> >> +
> >> +			if (copy_to_user((void __user *)bitmap->data + cnt,
> >> +				       dma->bitmap, curr_lcnt * sizeof(u64))) {
> >> +				ret = -EFAULT;
> >> +				break;
> >> +			}
> >> +
> >> +			shift = nbits % BITS_PER_LONG;
> >> +			if (shift)
> >> +				leftover = *(u64 *)(dma->bitmap + curr_lcnt);
> >> +			cnt += curr_lcnt;
> >> +		}  
> > 
> > I don't think this works.  Let's say for example we have separate
> > single page mappings at 4K and 12K (both dirty) and the user asked to
> > unmap the range 0 - 16K.   
> 
> Unmap range should include adjacent mapped ranges, right?

Not required.

> In your example, if user asks for range 0-16k but mapping at 0 wasn't 
> done, then this unmap would fail before even reaching control here.

Nope, that's supported.

> There is a check which makes sure that mapping for start of range exist:
> 
>          dma = vfio_find_dma(iommu, unmap->iova, 1);
>          if (dma && dma->iova != unmap->iova) {
>                  ret = -EINVAL;
>                  goto unlock;
>          }

	if (dma && ...

> There is a check which makes sure that mapping for last address of range 
> exist:
>          dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>          if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>                 ret = -EINVAL;
>                 goto unlock;
>          }

	if (dma && ...

These are the tests that require an unmap request not _bisect_ a
mapping, both tests are preceded by a check of if we found a mapping at
that address, not a requirement that there be a mapping at that
address, nor a requirement that mappings are consecutive across the
unmap range.  A user can absolutely call unmap with iova = 0, size =
S64_MAX to clear a massive chunk of the address space.

> Then current implementation should work.

Even if I change my example that the user requested an unmap of 4K-16K
with 4K mappings at 4K and 12K, the bitmap returned would have bits
0 & 1 set rather than bits 0 & 2, which is still incorrect.  Thanks,

Alex
 
> > We find the mapping at 4K, shift is zero, cnt
> > is zero, so we copy the bitmap with the zero bit set to the user
> > buffer.  We're already wrong because we've just indicated the page at
> > zero is dirty and there isn't a page at zero.  shift now becomes 1 and
> > leftover is a bitmap with bit zero set.
> > 
> > We move on to the next page @12K.  We shift this bitmap by 1.  We OR in
> > our leftover and again copy out to the user buffer.  We end up with a
> > user bitmap with bits zero and one set, when we should have had bits 1
> > and 3 set, we're essentially coalescing the mappings.
> > 
> > As I see it, shift needs to be calculated as the offset from the start
> > of the user requested unmap buffer and I think an easier approach to
> > handle the leftover bits preceding the shift is to copy it back out of
> > the user buffer.
> > 
> > For example, shift should be:
> > 
> > ((dma->iova - unmap->iova) >> pgshift) % BITS_PER_LONG
> > 
> > This would give us a shift of 1 and 3 respectively for our mappings,
> > which is correct.
> > 
> > Since our shifts are non-zero, we then need to collect the preceding
> > leftovers, which is always going to be:
> > 
> > copy_from_user(&leftover, bitmap->data +
> > 		((dma->iova - unmap->iova) >> pgshift) / BITS_PER_LONG,
> > 		sizeof(leftover));
> > 
> > I don't think the curr_lcnt calculation for the copy-out is correct
> > either, mappings are not required to be a multiple of BITS_PER_LONG
> > pages, so we're truncating the size.
> > 
> > So we have:
> > 
> > bit_offset = (dma->iova - unmap->iova) >> pgshift;
> > copy_offset = bit_offset / BITS_PER_LONG;
> > shift = bit_offset % BITS_PER_LONG;
> > 
> > if (shift) {
> > 	bitmap_shift_left(dma->bitmap, dma->bitmap, shift, nbits + shift);
> > 	if (copy_from_user(&leftover, bitmap->data + copy_offset, sizeof(leftover))) {
> > 		ret = -EFAULT;
> > 		break;
> > 	}
> > 	bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
> > }
> > 
> > if (copy_to_user(bitmap->data + copy_offset, dma->bitmap,
> > 		roundup(nbits + shift, BITS_PER_LONG)/BITS_PER_BYTE)) {
> > 	ret = -EFAULT;
> > 	break;
> > }
> > 
> > Also this all needs to come after the below check of the pfn_list and
> > call to the blocking notifier or else we're just wasting time because
> > we'll need to do it all again anyway.
> > 
> >   
> >> +
> >>   		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
> >>   			struct vfio_iommu_type1_dma_unmap nb_unmap;
> >>   
> >> @@ -1093,6 +1139,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   		vfio_remove_dma(iommu, dma);
> >>   	}
> >>   
> >> +	if (!ret && (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >> +	    shift) {
> >> +		if (copy_to_user((void __user *)bitmap->data + cnt, &leftover,
> >> +				 sizeof(leftover)))
> >> +			ret = -EFAULT;
> >> +	}  
> > 
> > This is unnecessary with the algorithm I propose.
> >   
> >> +
> >>   unlock:
> >>   	mutex_unlock(&iommu->lock);
> >>   
> >> @@ -2426,17 +2479,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   
> >>   	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
> >>   		struct vfio_iommu_type1_dma_unmap unmap;
> >> -		long ret;
> >> +		struct vfio_bitmap bitmap = { 0 };
> >> +		int ret;
> >>   
> >>   		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
> >>   
> >>   		if (copy_from_user(&unmap, (void __user *)arg, minsz))
> >>   			return -EFAULT;
> >>   
> >> -		if (unmap.argsz < minsz || unmap.flags)
> >> +		if (unmap.argsz < minsz ||
> >> +		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
> >>   			return -EINVAL;
> >>   
> >> -		ret = vfio_dma_do_unmap(iommu, &unmap);
> >> +		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> >> +			unsigned long pgshift;
> >> +
> >> +			if (unmap.argsz < (minsz + sizeof(bitmap)))
> >> +				return -EINVAL;
> >> +
> >> +			if (copy_from_user(&bitmap,
> >> +					   (void __user *)(arg + minsz),
> >> +					   sizeof(bitmap)))
> >> +				return -EFAULT;
> >> +
> >> +			if (!access_ok((void __user *)bitmap.data, bitmap.size))
> >> +				return -EINVAL;
> >> +
> >> +			pgshift = __ffs(bitmap.pgsize);
> >> +			ret = verify_bitmap_size(unmap.size >> pgshift,
> >> +						 bitmap.size);
> >> +			if (ret)
> >> +				return ret;
> >> +		}
> >> +
> >> +		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
> >>   		if (ret)
> >>   			return ret;
> >>   
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 5f359c63f5ef..e3cbf8b78623 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
> >>    * field.  No guarantee is made to the user that arbitrary unmaps of iova
> >>    * or size different from those used in the original mapping call will
> >>    * succeed.
> >> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> >> + * before unmapping IO virtual addresses. When this flag is set, user must
> >> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
> >> + * bitmap and must set size of allocated memory in vfio_bitmap.size field.
> >> + * A bit in bitmap represents one page of user provided page size in 'pgsize',
> >> + * consecutively starting from iova offset. Bit set indicates page at that
> >> + * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
> >> + * returned in vfio_bitmap.data  
> > 
> > This needs to specify a user zero'd bitmap if we're only going to fill
> > it sparsely.  Thanks,
> > 
> > Alex
> >   
> >>    */
> >>   struct vfio_iommu_type1_dma_unmap {
> >>   	__u32	argsz;
> >>   	__u32	flags;
> >> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> >>   	__u64	iova;				/* IO virtual address */
> >>   	__u64	size;				/* Size of mapping (bytes) */
> >> +	__u8    data[];
> >>   };
> >>   
> >>   #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)  
> >   
> 

