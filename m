Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976E0198698
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgC3Veb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 17:34:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54422 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728876AbgC3Veb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 17:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585604069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtjwwfzDKZSlwdDvTiWl9L/PjX6dffjMgObgN6KyfzU=;
        b=BMXJhXRaykwnofBCJyTxjkDcS5a4P6bgGuWkovmhZR+aojrBmWUQpllbR9r9qi0KoJ+8vN
        rYCPpVms40IaxKv5Z2G2WvD3DFtpfUxJDCNUEidQ2xlRBvP6yy1BIeNaEXHeBfHW8tXzX8
        sCJWcgBp+/wousF3ctJGrKnurJzT29o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-grHHkrF8MM2FacgiOjk0eA-1; Mon, 30 Mar 2020 17:34:26 -0400
X-MC-Unique: grHHkrF8MM2FacgiOjk0eA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A8B13F8;
        Mon, 30 Mar 2020 21:34:23 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 871905DA66;
        Mon, 30 Mar 2020 21:34:21 +0000 (UTC)
Date:   Mon, 30 Mar 2020 15:34:21 -0600
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
Message-ID: <20200330153421.6246c2c6@w520.home>
In-Reply-To: <1585587044-2408-6-git-send-email-kwankhede@nvidia.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
        <1585587044-2408-6-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Mar 2020 22:20:42 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> DMA mapped pages, including those pinned by mdev vendor drivers, might
> get unpinned and unmapped while migration is active and device is still
> running. For example, in pre-copy phase while guest driver could access
> those pages, host device or vendor driver can dirty these mapped pages.
> Such pages should be marked dirty so as to maintain memory consistency
> for a user making use of dirty page tracking.
> 
> To get bitmap during unmap, user should allocate memory for bitmap, set
> size of allocated memory, set page size to be considered for bitmap and
> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
>  include/uapi/linux/vfio.h       | 10 ++++++++
>  2 files changed, 61 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5efebc2b60e1..266550bd7307 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -983,7 +983,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>  }
>  
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> +			     struct vfio_bitmap *bitmap)
>  {
>  	uint64_t mask;
>  	struct vfio_dma *dma, *dma_last = NULL;
> @@ -1034,6 +1035,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  	 * will be returned if these conditions are not met.  The v2 interface
>  	 * will only return success and a size of zero if there were no
>  	 * mappings within the range.
> +	 *
> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
> +	 * must be for single mapping. Multiple mappings with this flag set is
> +	 * not supported.
>  	 */
>  	if (iommu->v2) {
>  		dma = vfio_find_dma(iommu, unmap->iova, 1);
> @@ -1041,6 +1046,14 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			ret = -EINVAL;
>  			goto unlock;
>  		}
> +
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		    dma &&
> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {


I think your intention was to return error if the user asked for the
dirty bitmap and the requested unmap range doesn't exactly match the
vfio_dma.  Not finding a vfio_dma should therefore also be an error.
For example, if we had a single mapping at {0x1000-0x1fff} and the user
unmapped with dirty bitmap {0x0-0x2fff}, that should return an error,
but it's not caught by the above because there is no vfio_dma @0x0.
Therefore I think you want:

((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
 (!dma || dma->iova != unmap->iova || dma->size != unmap->size))

Right?  Thanks,

Alex


> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
>  		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>  		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>  			ret = -EINVAL;
> @@ -1058,6 +1071,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		     iommu->dirty_page_tracking)
> +			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
> +						bitmap->pgsize, bitmap->data);
> +
>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -2419,17 +2437,46 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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
> +			size_t iommu_pgsize =
> +				(size_t)1 << __ffs(vfio_pgsize_bitmap(iommu));
> +
> +			if (unmap.argsz < (minsz + sizeof(bitmap)))
> +				return -EINVAL;
> +
> +			if (copy_from_user(&bitmap,
> +					   (void __user *)(arg + minsz),
> +					   sizeof(bitmap)))
> +				return -EFAULT;
> +
> +			/* allow only min supported pgsize */
> +			if (bitmap.pgsize != iommu_pgsize)
> +				return -EINVAL;
> +			if (!access_ok((void __user *)bitmap.data, bitmap.size))
> +				return -EINVAL;
> +
> +			pgshift = __ffs(bitmap.pgsize);
> +			ret = verify_bitmap_size(unmap.size >> pgshift,
> +						 bitmap.size);
> +			if (ret)
> +				return ret;
> +
> +		}
> +
> +		ret = vfio_dma_do_unmap(iommu, &unmap, &bitmap);
>  		if (ret)
>  			return ret;
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 5f359c63f5ef..e3cbf8b78623 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> + * before unmapping IO virtual addresses. When this flag is set, user must
> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
> + * bitmap and must set size of allocated memory in vfio_bitmap.size field.
> + * A bit in bitmap represents one page of user provided page size in 'pgsize',
> + * consecutively starting from iova offset. Bit set indicates page at that
> + * offset from iova is dirty. Bitmap of pages in the range of unmapped size is
> + * returned in vfio_bitmap.data
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

