Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C513E18AB3F
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 04:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCSDpZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 23:45:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:53699 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbgCSDpZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 23:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584589523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X9bvoNBDYRc3/2YYJX0L5AB1mVN/FVkxZTuxUWUuDks=;
        b=AvTzKl5UmYJO4fML3RN07LioLtCQGHKtfPJNSPd6tdp+WL8RUojwCkE4uYYy5/DEkRUFmj
        X5uRhjxWccoOLC5KaXoDsMbMeM/N/ByCJehmtwwwXdNdnLn2O4eMTmc+wFz9t2M/fQMECZ
        3EHPVCy74YSi5KBwkwICUVmxEBXwKh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-ZBownWWuMRmaJS5nILnbUA-1; Wed, 18 Mar 2020 23:45:19 -0400
X-MC-Unique: ZBownWWuMRmaJS5nILnbUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CD451857BE1;
        Thu, 19 Mar 2020 03:45:17 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C25FA5D9E2;
        Thu, 19 Mar 2020 03:45:15 +0000 (UTC)
Date:   Wed, 18 Mar 2020 21:45:15 -0600
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
Subject: Re: [PATCH v14 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200318214515.7180330d@w520.home>
In-Reply-To: <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 01:11:12 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> DMA mapped pages, including those pinned by mdev vendor drivers, might
> get unpinned and unmapped while migration is active and device is still
> running. For example, in pre-copy phase while guest driver could access
> those pages, host device or vendor driver can dirty these mapped pages.
> Such pages should be marked dirty so as to maintain memory consistency
> for a user making use of dirty page tracking.
> 
> To get bitmap during unmap, user should set flag
> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
> zeroed by user space application. Bitmap size and page size should be set
> by user application.

Looks good, but as mentioned we no longer require the user to zero the
bitmap.  It's mentioned in the commit log above and in the uapi
comment.  Thanks,

Alex

> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
>  include/uapi/linux/vfio.h       | 11 +++++++++
>  2 files changed, 62 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d6417fb02174..aa1ac30f7854 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -939,7 +939,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
>  }
>  
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> +			     struct vfio_bitmap *bitmap)
>  {
>  	uint64_t mask;
>  	struct vfio_dma *dma, *dma_last = NULL;
> @@ -990,6 +991,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
> @@ -997,6 +1002,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			ret = -EINVAL;
>  			goto unlock;
>  		}
> +
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
>  		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>  		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>  			ret = -EINVAL;
> @@ -1014,6 +1026,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  		if (dma->task->mm != current->mm)
>  			break;
>  
> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> +		     iommu->dirty_page_tracking)
> +			vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
> +					bitmap->pgsize,
> +					(unsigned char __user *) bitmap->data);
> +
>  		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
>  			struct vfio_iommu_type1_dma_unmap nb_unmap;
>  
> @@ -2369,17 +2387,46 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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
> +			uint64_t iommu_pgsize =
> +					 1 << __ffs(vfio_pgsize_bitmap(iommu));
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
> index 043e9eafb255..a704e5380f04 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1010,12 +1010,23 @@ struct vfio_bitmap {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
> + * before unmapping IO virtual addresses. When this flag is set, user must
> + * provide data[] as structure vfio_bitmap. User must allocate memory to get
> + * bitmap, clear the bitmap memory by setting zero and must set size of
> + * allocated memory in vfio_bitmap.size field. One bit in bitmap
> + * represents per page, page of user provided page size in 'pgsize',
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

