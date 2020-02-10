Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9651581A6
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 18:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgBJRt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 12:49:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726563AbgBJRt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 12:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581356964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THs6MD5F63Yy+s4wIRGm/FwycdxIdSFSGTNqGNxiuVY=;
        b=JV6ZU2DVxzq67BjiZWdsAiH2P3Vk32SFSAizvc2A0J5EjkRirxpTZM6XH4vyGuG36BEnPp
        3/hppMP/EYNU60qqeKIrd8Q09aD4Wjpz834qgK4AYNTng2UEAO5kVQppONRUvrq3uZE8Pe
        TlL3aPjrOpN9+Sb+yj56vj8ubjCGS1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-j1T4NXJNMTWeaVKLCt0QAQ-1; Mon, 10 Feb 2020 12:49:19 -0500
X-MC-Unique: j1T4NXJNMTWeaVKLCt0QAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1281A13E4;
        Mon, 10 Feb 2020 17:49:17 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61E6C60BF1;
        Mon, 10 Feb 2020 17:49:15 +0000 (UTC)
Date:   Mon, 10 Feb 2020 10:48:50 -0700
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
Subject: Re: [PATCH v12 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200210104850.5c4c2da4@x1.home>
In-Reply-To: <1581104554-10704-6-git-send-email-kwankhede@nvidia.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
        <1581104554-10704-6-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 8 Feb 2020 01:12:32 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Pages, pinned by external interface for requested IO virtual address
> range,  might get unpinned  and unmapped while migration is active and
> device is still running, that is, in pre-copy phase while guest driver
> still could access those pages. Host device can write to these pages while
> those were mapped. Such pages should be marked dirty so that after
> migration guest driver should still be able to complete the operation.
> 
> To get bitmap during unmap, user should set flag
> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
> zeroed by user space application. Bitmap size and page size should be set
> by user application.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 56 +++++++++++++++++++++++++++++++++++++----
>  include/uapi/linux/vfio.h       | 12 +++++++++
>  2 files changed, 63 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index df358dc1c85b..4e6ad0513932 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1032,7 +1032,8 @@ static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
>  }
>  
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> +			     unsigned long *bitmap)
>  {
>  	uint64_t mask;
>  	struct vfio_dma *dma, *dma_last = NULL;
> @@ -1107,6 +1108,15 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		    (dma_last != dma))
> +			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
> +					       unmap->bitmap_pgsize,
> +					      (unsigned char __user *) bitmap);
> +		else
> +			vfio_remove_unpinned_from_pfn_list(dma);

Isn't there a race here?  A vendor driver could have an outstanding
page pin request that's blocked on the iommu mutex, as soon as we
release the mutex to notify vendor drivers of the unmap, it would get
pinned, but on the next iteration we're not going to collect any new
dirty pages.  This whole sequence seems to favor tracking unpinned
pages in the dirty bitmap rather than the vpfn list with ref_count = 0.

Maybe this is also the reason for the access_ok() checks in
vfio_iova_dirty_bitmap(), but couldn't we do that in advance here for
the whole bitmap?  Thanks,

Alex

> +
> +
>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -1132,6 +1142,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  						    &nb_unmap);
>  			goto again;
>  		}
> +
>  		unmapped += dma->size;
>  		vfio_remove_dma(iommu, dma);
>  	}
> @@ -2462,22 +2473,57 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  	} else if (cmd == VFIO_IOMMU_UNMAP_DMA) {
>  		struct vfio_iommu_type1_dma_unmap unmap;
> -		long ret;
> +		unsigned long *bitmap = NULL;
> +		long ret, bsize;
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
> +			uint64_t iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> +			uint64_t iommu_pgmask =
> +				 ((uint64_t)1 << __ffs(iommu_pgsizes)) - 1;
> +
> +			if (copy_from_user(&unmap, (void __user *)arg,
> +					   sizeof(unmap)))
> +				return -EFAULT;
> +
> +			pgshift = __ffs(unmap.bitmap_pgsize);
> +
> +			if (((unmap.bitmap_pgsize - 1) & iommu_pgmask) !=
> +			     (unmap.bitmap_pgsize - 1))
> +				return -EINVAL;
> +
> +			if ((unmap.bitmap_pgsize & iommu_pgsizes) !=
> +			     unmap.bitmap_pgsize)
> +				return -EINVAL;
> +			if (unmap.iova + unmap.size < unmap.iova)
> +				return -EINVAL;
> +			if (!access_ok((void __user *)unmap.bitmap,
> +				       unmap.bitmap_size))
> +				return -EINVAL;
> +
> +			bsize = verify_bitmap_size(unmap.size >> pgshift,
> +						   unmap.bitmap_size);
> +			if (bsize < 0)
> +				return bsize;
> +			bitmap = unmap.bitmap;
> +		}
> +
> +		ret = vfio_dma_do_unmap(iommu, &unmap, bitmap);
>  		if (ret)
>  			return ret;
>  
> -		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> +		ret = copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +		return ret;
>  	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>  		struct vfio_iommu_type1_dirty_bitmap range;
>  		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index b1b03c720749..a852e729b5a2 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -985,12 +985,24 @@ struct vfio_iommu_type1_dma_map {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> + * before unmapping IO virtual addresses. When this flag is set, user should
> + * allocate memory to get bitmap, clear the bitmap memory by setting zero and
> + * should set size of allocated memory in bitmap_size field. One bit in bitmap
> + * represents per page , page of user provided page size in 'bitmap_pgsize',
> + * consecutively starting from iova offset. Bit set indicates page at that
> + * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
> + * returned in bitmap.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> +	__u64        bitmap_pgsize;		/* page size for bitmap */
> +	__u64        bitmap_size;               /* in bytes */
> +	void __user *bitmap;                    /* one bit per page */
>  };
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)

