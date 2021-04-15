Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC23E3613AA
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbhDOUoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 16:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235150AbhDOUoL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 16:44:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618519427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GxEGQ6WbGdMLQ9XEOvu1wvt7ZSWG9pv/O+MOPHmN598=;
        b=ZrW0Z83PfXEMxyMLmdXi2qR4ftiw/nhajZmRGWS7LJdHUQCg4I+o+sMxbPDnVJvX72FxTb
        FbIhgmldoxaM1AtXCWih/nA4F0XRjj6gmJ6Fh/LQRGCaNjmUiDULdmNUOmUTs6TxnDHz4h
        vDkqPAzVockEtOBJlPEHllW2cmYqdIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-TwEVkYgJMGuYe5r7s1L7zQ-1; Thu, 15 Apr 2021 16:43:44 -0400
X-MC-Unique: TwEVkYgJMGuYe5r7s1L7zQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DA4F1008060;
        Thu, 15 Apr 2021 20:43:42 +0000 (UTC)
Received: from redhat.com (ovpn-117-254.rdu2.redhat.com [10.10.117.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B0A15D71F;
        Thu, 15 Apr 2021 20:43:38 +0000 (UTC)
Date:   Thu, 15 Apr 2021 14:43:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Tian Kevin <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <yuzenghui@huawei.com>, <lushenming@huawei.com>
Subject: Re: [PATCH 3/3] vfio/iommu_type1: Add support for manual dirty log
 clear
Message-ID: <20210415144338.54b90041@redhat.com>
In-Reply-To: <20210413091445.7448-4-zhukeqian1@huawei.com>
References: <20210413091445.7448-1-zhukeqian1@huawei.com>
        <20210413091445.7448-4-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 17:14:45 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> From: Kunkun Jiang <jiangkunkun@huawei.com>
> 
> In the past, we clear dirty log immediately after sync dirty
> log to userspace. This may cause redundant dirty handling if
> userspace handles dirty log iteratively:
> 
> After vfio clears dirty log, new dirty log starts to generate.
> These new dirty log will be reported to userspace even if they
> are generated before userspace handles the same dirty page.
> 
> That's to say, we should minimize the time gap of dirty log
> clearing and dirty log handling. We can give userspace the
> interface to clear dirty log.

IIUC, a user would be expected to clear the bitmap before copying the
dirty pages, therefore you're trying to reduce that time gap between
clearing any copy, but it cannot be fully eliminated and importantly,
if the user clears after copying, they've introduced a race.  Correct?

What results do you have to show that this is a worthwhile optimization?

I really don't like the semantics that testing for an IOMMU capability
enables it.  It needs to be explicitly controllable feature, which
suggests to me that it might be a flag used in combination with _GET or
a separate _GET_NOCLEAR operations.  Thanks,

Alex


> Co-developed-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 100 ++++++++++++++++++++++++++++++--
>  include/uapi/linux/vfio.h       |  28 ++++++++-
>  2 files changed, 123 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 77950e47f56f..d9c4a27b3c4e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -78,6 +78,7 @@ struct vfio_iommu {
>  	bool			v2;
>  	bool			nesting;
>  	bool			dirty_page_tracking;
> +	bool			dirty_log_manual_clear;
>  	bool			pinned_page_dirty_scope;
>  	bool			container_open;
>  };
> @@ -1242,6 +1243,78 @@ static int vfio_iommu_dirty_log_sync(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iova_dirty_log_clear(u64 __user *bitmap,
> +				     struct vfio_iommu *iommu,
> +				     dma_addr_t iova, size_t size,
> +				     size_t pgsize)
> +{
> +	struct vfio_dma *dma;
> +	struct rb_node *n;
> +	dma_addr_t start_iova, end_iova, riova;
> +	unsigned long pgshift = __ffs(pgsize);
> +	unsigned long bitmap_size;
> +	unsigned long *bitmap_buffer = NULL;
> +	bool clear_valid;
> +	int rs, re, start, end, dma_offset;
> +	int ret = 0;
> +
> +	bitmap_size = DIRTY_BITMAP_BYTES(size >> pgshift);
> +	bitmap_buffer = kvmalloc(bitmap_size, GFP_KERNEL);
> +	if (!bitmap_buffer) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (copy_from_user(bitmap_buffer, bitmap, bitmap_size)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		dma = rb_entry(n, struct vfio_dma, node);
> +		if (!dma->iommu_mapped)
> +			continue;
> +		if ((dma->iova + dma->size - 1) < iova)
> +			continue;
> +		if (dma->iova > iova + size - 1)
> +			break;
> +
> +		start_iova = max(iova, dma->iova);
> +		end_iova = min(iova + size, dma->iova + dma->size);
> +
> +		/* Similar logic as the tail of vfio_iova_dirty_bitmap */
> +
> +		clear_valid = false;
> +		start = (start_iova - iova) >> pgshift;
> +		end = (end_iova - iova) >> pgshift;
> +		bitmap_for_each_set_region(bitmap_buffer, rs, re, start, end) {
> +			clear_valid = true;
> +			riova = iova + (rs << pgshift);
> +			dma_offset = (riova - dma->iova) >> pgshift;
> +			bitmap_clear(dma->bitmap, dma_offset, re - rs);
> +		}
> +
> +		if (clear_valid)
> +			vfio_dma_populate_bitmap(dma, pgsize);
> +
> +		if (clear_valid && !iommu->pinned_page_dirty_scope &&
> +		    dma->iommu_mapped && !iommu->num_non_hwdbm_groups) {
> +			ret = vfio_iommu_dirty_log_clear(iommu, start_iova,
> +					end_iova - start_iova,	bitmap_buffer,
> +					iova, pgshift);
> +			if (ret) {
> +				pr_warn("dma dirty log clear failed!\n");
> +				goto out;
> +			}
> +		}
> +
> +	}
> +
> +out:
> +	kfree(bitmap_buffer);
> +	return ret;
> +}
> +
>  static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  			      struct vfio_dma *dma, dma_addr_t base_iova,
>  			      size_t pgsize)
> @@ -1329,6 +1402,10 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>  		if (ret)
>  			return ret;
>  
> +		/* Do not clear dirty automatically when manual_clear enabled */
> +		if (iommu->dirty_log_manual_clear)
> +			continue;
> +
>  		/* Clear iommu dirty log to re-enable dirty log tracking */
>  		if (iommu->num_non_pinned_groups && dma->iommu_mapped &&
>  		    !iommu->num_non_hwdbm_groups) {
> @@ -2946,6 +3023,11 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  		if (!iommu)
>  			return 0;
>  		return vfio_domains_have_iommu_cache(iommu);
> +	case VFIO_DIRTY_LOG_MANUAL_CLEAR:
> +		if (!iommu)
> +			return 0;
> +		iommu->dirty_log_manual_clear = true;
> +		return 1;
>  	default:
>  		return 0;
>  	}
> @@ -3201,7 +3283,8 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  	struct vfio_iommu_type1_dirty_bitmap dirty;
>  	uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>  			VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> -			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> +			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP |
> +			VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP;
>  	unsigned long minsz;
>  	int ret = 0;
>  
> @@ -3243,7 +3326,8 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		}
>  		mutex_unlock(&iommu->lock);
>  		return 0;
> -	} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> +	} else if (dirty.flags & (VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP)) {
>  		struct vfio_iommu_type1_dirty_bitmap_get range;
>  		unsigned long pgshift;
>  		size_t data_size = dirty.argsz - minsz;
> @@ -3286,13 +3370,21 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  			goto out_unlock;
>  		}
>  
> -		if (iommu->dirty_page_tracking)
> +		if (!iommu->dirty_page_tracking) {
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		}
> +
> +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP)
>  			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
>  						     iommu, range.iova,
>  						     range.size,
>  						     range.bitmap.pgsize);
>  		else
> -			ret = -EINVAL;
> +			ret = vfio_iova_dirty_log_clear(range.bitmap.data,
> +							iommu, range.iova,
> +							range.size,
> +							range.bitmap.pgsize);
>  out_unlock:
>  		mutex_unlock(&iommu->lock);
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8ce36c1d53ca..784dc3cf2a8f 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -52,6 +52,14 @@
>  /* Supports the vaddr flag for DMA map and unmap */
>  #define VFIO_UPDATE_VADDR		10
>  
> +/*
> + * The vfio_iommu driver may support user clears dirty log manually, which means
> + * dirty log is not cleared automatically after dirty log is copied to userspace,
> + * it's user's duty to clear dirty log. Note: when user queries this extension
> + * and vfio_iommu driver supports it, then it is enabled.
> + */
> +#define VFIO_DIRTY_LOG_MANUAL_CLEAR	11
> +
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
>   * structure length (argsz) and flags into structures passed between
> @@ -1188,7 +1196,24 @@ struct vfio_iommu_type1_dma_unmap {
>   * actual bitmap. If dirty pages logging is not enabled, an error will be
>   * returned.
>   *
> - * Only one of the flags _START, _STOP and _GET may be specified at a time.
> + * Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP flag set,
> + * instructs the IOMMU driver to clear the dirty status of pages in a bitmap
> + * for IOMMU container for a given IOVA range. The user must specify the IOVA
> + * range, the bitmap and the pgsize through the structure
> + * vfio_iommu_type1_dirty_bitmap_get in the data[] portion. This interface
> + * supports clearing a bitmap of the smallest supported pgsize only and can be
> + * modified in future to clear a bitmap of any specified supported pgsize. The
> + * user must provide a memory area for the bitmap memory and specify its size
> + * in bitmap.size. One bit is used to represent one page consecutively starting
> + * from iova offset. The user should provide page size in bitmap.pgsize field.
> + * A bit set in the bitmap indicates that the page at that offset from iova is
> + * cleared the dirty status, and dirty tracking is re-enabled for that page. The
> + * caller must set argsz to a value including the size of structure
> + * vfio_iommu_dirty_bitmap_get, but excluing the size of the actual bitmap. If
> + * dirty pages logging is not enabled, an error will be returned.
> + *
> + * Only one of the flags _START, _STOP, _GET and _CLEAR may be specified at a
> + * time.
>   *
>   */
>  struct vfio_iommu_type1_dirty_bitmap {
> @@ -1197,6 +1222,7 @@ struct vfio_iommu_type1_dirty_bitmap {
>  #define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
>  #define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
>  #define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_CLEAR_BITMAP (1 << 3)
>  	__u8         data[];
>  };
>  

