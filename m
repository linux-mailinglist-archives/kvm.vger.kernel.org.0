Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998D51D8A44
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 23:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgERVxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 17:53:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726250AbgERVxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 17:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589838830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5SdP6aOJIjg8JxVKmnhFe6cEgTeBKIgENH/aoYi2dzg=;
        b=Q7GLgmM+exaaBDLGsl4ZSHEaNeOKwKUdAeJFUDUhPA2qiyitE64s5IzxtW7Onhg3yDTRKq
        Xn6lZ7HI6f6ggStf5/JPVPb51xmhO9PUT5mEOHVD537MPYMVb7fR/oLwwDNbmAq0YOUEWO
        6LubGKTxg5+D2+cHCxCFDoXln06Hk3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-7lqpaOLYN76AblsELuojeg-1; Mon, 18 May 2020 17:53:47 -0400
X-MC-Unique: 7lqpaOLYN76AblsELuojeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E8F9835B40;
        Mon, 18 May 2020 21:53:45 +0000 (UTC)
Received: from x1.home (ovpn-112-50.phx2.redhat.com [10.3.112.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED8522B7BB;
        Mon, 18 May 2020 21:53:42 +0000 (UTC)
Date:   Mon, 18 May 2020 15:53:42 -0600
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
Subject: Re: [PATCH Kernel v22 5/8] vfio iommu: Implementation of ioctl for
 dirty pages tracking
Message-ID: <20200518155342.4dd7df99@x1.home>
In-Reply-To: <1589781397-28368-6-git-send-email-kwankhede@nvidia.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
        <1589781397-28368-6-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 11:26:34 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> - Start dirty pages tracking while migration is active
> - Stop dirty pages tracking.
> - Get dirty pages bitmap. Its user space application's responsibility to
>   copy content of dirty pages from source to destination during migration.
> 
> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> structure. Bitmap size is calculated considering smallest supported page
> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> 
> Bitmap is populated for already pinned pages when bitmap is allocated for
> a vfio_dma with the smallest supported page size. Update bitmap from
> pinning functions when tracking is enabled. When user application queries
> bitmap, check if requested page size is same as page size used to
> populated bitmap. If it is equal, copy bitmap, but if not equal, return
> error.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> 
> Fixed error reported by build bot by changing pgsize type from uint64_t
> to size_t.
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 313 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 307 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index de17787ffece..bf740fef196f 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -72,6 +72,7 @@ struct vfio_iommu {
>  	uint64_t		pgsize_bitmap;
>  	bool			v2;
>  	bool			nesting;
> +	bool			dirty_page_tracking;
>  };
>  
>  struct vfio_domain {
> @@ -92,6 +93,7 @@ struct vfio_dma {
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> +	unsigned long		*bitmap;
>  };
>  
>  struct vfio_group {
> @@ -126,6 +128,19 @@ struct vfio_regions {
>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>  					(!list_empty(&iommu->domain_list))
>  
> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> +
> +/*
> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> + * further casts to signed integer for unaligned multi-bit operation,
> + * __bitmap_set().
> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> + * system.
> + */
> +#define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> +
>  static int put_pfn(unsigned long pfn, int prot);
>  
>  /*
> @@ -176,6 +191,74 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>  	rb_erase(&old->node, &iommu->dma_list);
>  }
>  
> +
> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
> +{
> +	uint64_t npages = dma->size / pgsize;
> +
> +	if (npages > DIRTY_BITMAP_PAGES_MAX)
> +		return -EINVAL;
> +
> +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);

Curious that the extra 8-bytes are added in the next patch, but they're
just as necessary here.

We also have the explanation above about why we have the signed int
size limitation, but we sort of ignore that when adding the bytes here.
That limitation is derived from __bitmap_set(), whereas we only need
these extra bits for bitmap_shift_left(), where I can't spot a signed
int limitation.  Do you come to the same conclusion?  Maybe worth a
comment why we think we can exceed DIRTY_BITMAP_PAGES_MAX for that
extra padding.

> +	if (!dma->bitmap)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
> +{
> +	kfree(dma->bitmap);
> +	dma->bitmap = NULL;
> +}
> +
> +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
> +{
> +	struct rb_node *p;
> +
> +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
> +
> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> +	}
> +}
> +
> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +
> +	for (; n; n = rb_next(n)) {

Nit, the previous function above sets the initial value in the for()
statement, it looks like it would fit in 80 columns here too.  We have
examples either way in the code, so not a must fix.

> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +		int ret;
> +
> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> +		if (ret) {
> +			struct rb_node *p = rb_prev(n);
> +
> +			for (; p; p = rb_prev(p)) {

Same.

> +				struct vfio_dma *dma = rb_entry(n,
> +							struct vfio_dma, node);
> +
> +				vfio_dma_bitmap_free(dma);
> +			}
> +			return ret;
> +		}
> +		vfio_dma_populate_bitmap(dma, pgsize);
> +	}
> +	return 0;
> +}
> +
> +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +
> +	for (; n; n = rb_next(n)) {

And another.

> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		vfio_dma_bitmap_free(dma);
> +	}
> +}
> +
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> @@ -568,6 +651,17 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  			vfio_unpin_page_external(dma, iova, do_accounting);
>  			goto pin_unwind;
>  		}
> +
> +		if (iommu->dirty_page_tracking) {
> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +
> +			/*
> +			 * Bitmap populated with the smallest supported page
> +			 * size
> +			 */
> +			bitmap_set(dma->bitmap,
> +				   (iova - dma->iova) >> pgshift, 1);
> +		}
>  	}
>  
>  	ret = i;
> @@ -802,6 +896,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> +	vfio_dma_bitmap_free(dma);
>  	kfree(dma);
>  	iommu->dma_avail++;
>  }
> @@ -829,6 +924,99 @@ static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  	}
>  }
>  
> +static int update_user_bitmap(u64 __user *bitmap, struct vfio_dma *dma,
> +			      dma_addr_t base_iova, size_t pgsize)
> +{
> +	unsigned long pgshift = __ffs(pgsize);
> +	unsigned long nbits = dma->size >> pgshift;
> +	unsigned long bit_offset = (dma->iova - base_iova) >> pgshift;
> +	unsigned long copy_offset = bit_offset / BITS_PER_LONG;
> +	unsigned long shift = bit_offset % BITS_PER_LONG;
> +	unsigned long leftover;
> +
> +	/* mark all pages dirty if all pages are pinned and mapped. */
> +	if (dma->iommu_mapped)
> +		bitmap_set(dma->bitmap, 0, dma->size >> pgshift);

We already calculated 'dma->size >> pgshift' as nbits above, we should
use nbits here.  I imagine the compiler will optimize this, so take it
as a nit.

> +
> +	if (shift) {
> +		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
> +				  nbits + shift);
> +
> +		if (copy_from_user(&leftover, (u64 *)bitmap + copy_offset,
> +				   sizeof(leftover)))
> +			return -EFAULT;
> +
> +		bitmap_or(dma->bitmap, dma->bitmap, &leftover, shift);
> +	}
> +
> +	if (copy_to_user((u64 *)bitmap + copy_offset, dma->bitmap,
> +			 DIRTY_BITMAP_BYTES(nbits + shift)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> +				  dma_addr_t iova, size_t size, size_t pgsize)
> +{
> +	struct vfio_dma *dma;
> +	struct rb_node *n;
> +	unsigned long pgshift = __ffs(pgsize);
> +	int ret;
> +
> +	/*
> +	 * GET_BITMAP request must fully cover vfio_dma mappings.  Multiple
> +	 * vfio_dma mappings may be clubbed by specifying large ranges, but
> +	 * there must not be any previous mappings bisected by the range.
> +	 * An error will be returned if these conditions are not met.
> +	 */
> +	dma = vfio_find_dma(iommu, iova, 1);
> +	if (dma && dma->iova != iova)
> +		return -EINVAL;
> +
> +	dma = vfio_find_dma(iommu, iova + size - 1, 0);
> +	if (dma && dma->iova + dma->size != iova + size)
> +		return -EINVAL;
> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *ldma = rb_entry(n, struct vfio_dma, node);
> +
> +		if (ldma->iova >= iova)
> +			break;
> +	}
> +
> +	dma = n ? rb_entry(n, struct vfio_dma, node) : NULL;
> +
> +	while (dma && (dma->iova >= iova) &&

'dma->iova >= iova' is necessarily true per the above loop, right?
We'd have NULL if we never reach an iova within range.

> +		(dma->iova + dma->size <= iova + size)) {

I think 'dma->iova < iova + size' is sufficient here, we've already
tested that there are no dmas overlapping the ends, they're all either
fully contained or fully outside.

> +

The double loop here is a little unnecessary, we could combine them
into:

for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
	struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);

	if (dma->iova < iova)
		continue;

	if (dma->iova > iova + size)
		break;

	ret = update_user_bitmap(bitmap, dma, iova, pgsize);
	if (ret)
		return ret;

	/*
	 * Re-populate bitmap to include all pinned pages which are
	 * considered as dirty but exclude pages which are unpinned and
	 * pages which are marked dirty by vfio_dma_rw()
	 */
	bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
	vfio_dma_populate_bitmap(dma, pgsize);
}

I think what you have works, but it's a little more complicated than it
needs to be.  Thanks,

Alex

> +		ret = update_user_bitmap(bitmap, dma, iova, pgsize);
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * Re-populate bitmap to include all pinned pages which are
> +		 * considered as dirty but exclude pages which are unpinned and
> +		 * pages which are marked dirty by vfio_dma_rw()
> +		 */
> +		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
> +		vfio_dma_populate_bitmap(dma, pgsize);
> +
> +		n = rb_next(&dma->node);
> +		dma = n ? rb_entry(n, struct vfio_dma, node) : NULL;
> +	}
> +	return 0;
> +}
> +
> +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> +{
> +	if (!npages || !bitmap_size || (bitmap_size > DIRTY_BITMAP_SIZE_MAX) ||
> +	    (bitmap_size < DIRTY_BITMAP_BYTES(npages)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>  {
> @@ -1046,7 +1234,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	unsigned long vaddr = map->vaddr;
>  	size_t size = map->size;
>  	int ret = 0, prot = 0;
> -	uint64_t mask;
> +	size_t pgsize;
>  	struct vfio_dma *dma;
>  
>  	/* Verify that none of our __u64 fields overflow */
> @@ -1061,11 +1249,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  
>  	mutex_lock(&iommu->lock);
>  
> -	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
> +	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>  
> -	WARN_ON(mask & PAGE_MASK);
> +	WARN_ON((pgsize - 1) & PAGE_MASK);
>  
> -	if (!prot || !size || (size | iova | vaddr) & mask) {
> +	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -1142,6 +1330,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	else
>  		ret = vfio_pin_map_dma(iommu, dma, size);
>  
> +	if (!ret && iommu->dirty_page_tracking) {
> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> +		if (ret)
> +			vfio_remove_dma(iommu, dma);
> +	}
> +
>  out_unlock:
>  	mutex_unlock(&iommu->lock);
>  	return ret;
> @@ -2288,6 +2482,104 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> +		struct vfio_iommu_type1_dirty_bitmap dirty;
> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> +		int ret = 0;
> +
> +		if (!iommu->v2)
> +			return -EACCES;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> +				    flags);
> +
> +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (dirty.argsz < minsz || dirty.flags & ~mask)
> +			return -EINVAL;
> +
> +		/* only one flag should be set at a time */
> +		if (__ffs(dirty.flags) != __fls(dirty.flags))
> +			return -EINVAL;
> +
> +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> +			size_t pgsize;
> +
> +			mutex_lock(&iommu->lock);
> +			pgsize = 1 << __ffs(iommu->pgsize_bitmap);
> +			if (!iommu->dirty_page_tracking) {
> +				ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> +				if (!ret)
> +					iommu->dirty_page_tracking = true;
> +			}
> +			mutex_unlock(&iommu->lock);
> +			return ret;
> +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> +			mutex_lock(&iommu->lock);
> +			if (iommu->dirty_page_tracking) {
> +				iommu->dirty_page_tracking = false;
> +				vfio_dma_bitmap_free_all(iommu);
> +			}
> +			mutex_unlock(&iommu->lock);
> +			return 0;
> +		} else if (dirty.flags &
> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> +			struct vfio_iommu_type1_dirty_bitmap_get range;
> +			unsigned long pgshift;
> +			size_t data_size = dirty.argsz - minsz;
> +			size_t iommu_pgsize;
> +
> +			if (!data_size || data_size < sizeof(range))
> +				return -EINVAL;
> +
> +			if (copy_from_user(&range, (void __user *)(arg + minsz),
> +					   sizeof(range)))
> +				return -EFAULT;
> +
> +			if (range.iova + range.size < range.iova)
> +				return -EINVAL;
> +			if (!access_ok((void __user *)range.bitmap.data,
> +				       range.bitmap.size))
> +				return -EINVAL;
> +
> +			pgshift = __ffs(range.bitmap.pgsize);
> +			ret = verify_bitmap_size(range.size >> pgshift,
> +						 range.bitmap.size);
> +			if (ret)
> +				return ret;
> +
> +			mutex_lock(&iommu->lock);
> +
> +			iommu_pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
> +
> +			/* allow only smallest supported pgsize */
> +			if (range.bitmap.pgsize != iommu_pgsize) {
> +				ret = -EINVAL;
> +				goto out_unlock;
> +			}
> +			if (range.iova & (iommu_pgsize - 1)) {
> +				ret = -EINVAL;
> +				goto out_unlock;
> +			}
> +			if (!range.size || range.size & (iommu_pgsize - 1)) {
> +				ret = -EINVAL;
> +				goto out_unlock;
> +			}
> +
> +			if (iommu->dirty_page_tracking)
> +				ret = vfio_iova_dirty_bitmap(range.bitmap.data,
> +						iommu, range.iova, range.size,
> +						range.bitmap.pgsize);
> +			else
> +				ret = -EINVAL;
> +out_unlock:
> +			mutex_unlock(&iommu->lock);
> +
> +			return ret;
> +		}
>  	}
>  
>  	return -ENOTTY;
> @@ -2355,10 +2647,19 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  
>  	vaddr = dma->vaddr + offset;
>  
> -	if (write)
> +	if (write) {
>  		*copied = copy_to_user((void __user *)vaddr, data,
>  					 count) ? 0 : count;
> -	else
> +		if (*copied && iommu->dirty_page_tracking) {
> +			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
> +			/*
> +			 * Bitmap populated with the smallest supported page
> +			 * size
> +			 */
> +			bitmap_set(dma->bitmap, offset >> pgshift,
> +				   *copied >> pgshift);
> +		}
> +	} else
>  		*copied = copy_from_user(data, (void __user *)vaddr,
>  					   count) ? 0 : count;
>  	if (kthread)

