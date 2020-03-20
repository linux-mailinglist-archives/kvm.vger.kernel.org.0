Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A7018C91B
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 09:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgCTIpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 04:45:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:57059 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgCTIpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 04:45:04 -0400
IronPort-SDR: mwtNSkv2ibYSugq/wR3jgtxszvtGX5vnjBPV078SdfkgWs6h9V/Zk783a3w4RLTRxB76p3u7Fb
 7gvTBEmCp04Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 01:45:03 -0700
IronPort-SDR: nNrMH6GPses5RmUwVIeFI9qYGCkVUMZMviDujdJLGKnIa+DslPz8GvrMZt5RkP5pUkrTuQB53C
 2OlWn0A3GdrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="444901022"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2020 01:44:59 -0700
Date:   Fri, 20 Mar 2020 04:35:29 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
Message-ID: <20200320083529.GA5456@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 03:41:12AM +0800, Kirti Wankhede wrote:
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
> 
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
dma is probably NULL here!

And this restriction on UNMAP would make some UNMAP operations of vIOMMU
fail.

e.g. below condition indeed happens in reality.
an UNMAP ioctl comes for IOVA range from 0xff800000, of size 0x200000
However, IOVAs in this range are mapped page by page.i.e., dma->size is 0x1000.

Previous, this UNMAP ioctl could unmap successfully as a whole.

Thanks
Yan

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
> -- 
> 2.7.0
> 
