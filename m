Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE141D4408
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 05:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEOD1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 23:27:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20848 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726176AbgEOD1S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 23:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589513235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s70K14JNVjcm4uT+QZxWxJR0qJzEbvA0EQovVYBmsTE=;
        b=G1XopKIztPbegkvL2iRVvowTaaMDnvyqg50X4XgErKff6dSbNmhcWG+NHp6KOmYkw8qg/5
        3MFtyJNAiohMy7ha4Ty1LwOL/Z9jJ/9QsoSQtV7YEgBq2s4bzaOR29ZYRCcA9ptECuBjMG
        KuB10LEB7no9AVVNbModum1w8OIY8uk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-zvzUN7_mPJmGBMcQy09NAA-1; Thu, 14 May 2020 23:27:12 -0400
X-MC-Unique: zvzUN7_mPJmGBMcQy09NAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4534F461;
        Fri, 15 May 2020 03:27:09 +0000 (UTC)
Received: from x1.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1894160BE2;
        Fri, 15 May 2020 03:27:07 +0000 (UTC)
Date:   Thu, 14 May 2020 21:27:06 -0600
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
Subject: Re: [PATCH Kernel v20 6/8] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200514212706.036a336a@x1.home>
In-Reply-To: <1589488667-9683-7-git-send-email-kwankhede@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-7-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 02:07:45 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> DMA mapped pages, including those pinned by mdev vendor drivers, might
> get unpinned and unmapped while migration is active and device is still
> running. For example, in pre-copy phase while guest driver could access
> those pages, host device or vendor driver can dirty these mapped pages.
> Such pages should be marked dirty so as to maintain memory consistency
> for a user making use of dirty page tracking.
> 
> To get bitmap during unmap, user should allocate memory for bitmap, set
> it all zeros, set size of allocated memory, set page size to be
> considered for bitmap and set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++++++++++++++-------
>  include/uapi/linux/vfio.h       | 10 ++++++
>  2 files changed, 75 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b76d3b14abfd..a1dc57bcece5 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -195,11 +195,15 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>  static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
>  {
>  	uint64_t npages = dma->size / pgsize;
> +	size_t bitmap_size;
>  
>  	if (npages > DIRTY_BITMAP_PAGES_MAX)
>  		return -EINVAL;
>  
> -	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> +	/* Allocate extra 64 bits which are used for bitmap manipulation */
> +	bitmap_size = DIRTY_BITMAP_BYTES(npages) + sizeof(u64);
> +
> +	dma->bitmap = kvzalloc(bitmap_size, GFP_KERNEL);
>  	if (!dma->bitmap)
>  		return -ENOMEM;
>  
> @@ -999,23 +1003,25 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>  }
>  
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> +			     struct vfio_bitmap *bitmap)
>  {
> -	uint64_t mask;
>  	struct vfio_dma *dma, *dma_last = NULL;
> -	size_t unmapped = 0;
> +	size_t unmapped = 0, pgsize;
>  	int ret = 0, retries = 0;
> +	unsigned long pgshift;
>  
>  	mutex_lock(&iommu->lock);
>  
> -	mask = ((uint64_t)1 << __ffs(iommu->pgsize_bitmap)) - 1;
> +	pgshift = __ffs(iommu->pgsize_bitmap);
> +	pgsize = (size_t)1 << pgshift;
>  
> -	if (unmap->iova & mask) {
> +	if (unmap->iova & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto unlock;
>  	}
>  
> -	if (!unmap->size || unmap->size & mask) {
> +	if (!unmap->size || unmap->size & (pgsize - 1)) {
>  		ret = -EINVAL;
>  		goto unlock;
>  	}
> @@ -1026,9 +1032,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		goto unlock;
>  	}
>  
> -	WARN_ON(mask & PAGE_MASK);
> -again:
> +	/* When dirty tracking is enabled, allow only min supported pgsize */
> +	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
>  
> +	WARN_ON((pgsize - 1) & PAGE_MASK);
> +again:
>  	/*
>  	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
>  	 * avoid tracking individual mappings.  This means that the granularity
> @@ -1066,6 +1078,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			ret = -EINVAL;
>  			goto unlock;
>  		}
> +
>  		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>  		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>  			ret = -EINVAL;
> @@ -1083,6 +1096,23 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		    (dma_last != dma)) {
> +
> +			/*
> +			 * mark all pages dirty if all pages are pinned and
> +			 * mapped
> +			 */
> +			if (dma->iommu_mapped)
> +				bitmap_set(dma->bitmap, 0,
> +					   dma->size >> pgshift);

Nit, all the callers of update_user_bitmap() precede the call with this
identical operation, we should probably push it into the function to do
it.

> +
> +			ret = update_user_bitmap(bitmap->data, dma,
> +						 unmap->iova, pgsize);
> +			if (ret)
> +				break;
> +		}
> +

As noted last time, the above is just busy work if pfn_list is not
already empty.  The entire code block above should be moved to after
the block below.  Thanks,

Alex

>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -2447,17 +2477,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
>  		struct vfio_iommu_type1_dma_unmap unmap;
> -		long ret;
> +		struct vfio_bitmap bitmap = { 0 };
> +		int ret;
>  
>  		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
>  
>  		if (copy_from_user(&unmap, (void __user *)arg, minsz))
>  			return -EFAULT;
>  
> -		if (unmap.argsz < minsz || unmap.flags)
> +		if (unmap.argsz < minsz ||
> +		    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
>  			return -EINVAL;
>  
> -		ret = vfio_dma_do_unmap(iommu, &unmap);
> +		if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> +			unsigned long pgshift;
> +
> +			if (unmap.argsz < (minsz + sizeof(bitmap)))
> +				return -EINVAL;
> +
> +			if (copy_from_user(&bitmap,
> +					   (void __user *)(arg + minsz),
> +					   sizeof(bitmap)))
> +				return -EFAULT;
> +
> +			if (!access_ok((void __user *)bitmap.data, bitmap.size))
> +				return -EINVAL;
> +
> +			pgshift = __ffs(bitmap.pgsize);
> +			ret = verify_bitmap_size(unmap.size >> pgshift,
> +						 bitmap.size);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
>  		if (ret)
>  			return ret;
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 123de3bc2dce..0a0c7315ddd6 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> + * before unmapping IO virtual addresses. When this flag is set, user must
> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
> + * bitmap, zero the bitmap memory and must set size of allocated memory in
> + * vfio_bitmap.size field. A bit in bitmap represents one page of user provided
> + * page size in 'pgsize', consecutively starting from iova offset. Bit set
> + * indicates page at that offset from iova is dirty. Bitmap of pages in the
> + * range of unmapped size is returned in vfio_bitmap.data
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> +	__u8    data[];
>  };
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)

