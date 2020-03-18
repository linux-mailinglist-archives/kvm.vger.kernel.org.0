Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B8B189BB9
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 13:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCRMNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 08:13:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42709 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgCRMN3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 08:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584533608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zTxXAON9YcXG0Y2z3wfR3Qe+dtfMDziTWi93aKzl7Js=;
        b=Pz2QJyhKQWYqZ88fVs5vJZy19JiV5+4pj7DDRsczvrE6IRM0Kf43AnP5HhGa/raQf4Kfqn
        iOARDP+Ea29IZAFpKvjYFiQFZJRGEwVkb8My1ulFdC+Tvi2pQdpWoMlCN/A6oltRhELoSh
        tr3V4jdXEfnwhbs2ZldlugxM+Jp5PcE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-dj3Ev-L5NYiCYjTjCsp-wQ-1; Wed, 18 Mar 2020 08:13:26 -0400
X-MC-Unique: dj3Ev-L5NYiCYjTjCsp-wQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C938107ACC9;
        Wed, 18 Mar 2020 12:13:23 +0000 (UTC)
Received: from work-vm (ovpn-115-3.ams2.redhat.com [10.36.115.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 217585D9C5;
        Wed, 18 Mar 2020 12:13:15 +0000 (UTC)
Date:   Wed, 18 Mar 2020 12:13:12 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     alex.williamson@redhat.com, cjia@nvidia.com, kevin.tian@intel.com,
        ziye.yang@intel.com, changpeng.liu@intel.com, yi.l.liu@intel.com,
        mlevitsk@redhat.com, eskultet@redhat.com, cohuck@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v13 Kernel 4/7] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200318121312.GI2850@work-vm>
References: <1584035607-23166-1-git-send-email-kwankhede@nvidia.com>
 <1584035607-23166-5-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584035607-23166-5-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.13.3 (2020-01-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Kirti Wankhede (kwankhede@nvidia.com) wrote:
> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> - Start pinned and unpinned pages tracking while migration is active
> - Stop pinned and unpinned dirty pages tracking. This is also used to
>   stop dirty pages tracking if migration failed or cancelled.
> - Get dirty pages bitmap. This ioctl returns bitmap of dirty pages, its
>   user space application responsibility to copy content of dirty pages
>   from source to destination during migration.
> 
> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> structure. Bitmap size is calculated considering smallest supported page
> size. Bitmap is allocated when dirty logging is enabled for those
> vfio_dmas whose vpfn list is not empty or whole range is mapped, in
> case of pass-through device.
> 
> Bitmap is populated for already pinned pages when bitmap is allocated for
> a vfio_dma with the smallest supported page size. Update bitmap from
> pinning and unpinning functions. When user application queries bitmap,
> check if requested page size is same as page size used to populated
> bitmap. If it is equal, copy bitmap, but if not equal, return error.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 243 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 237 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d386461e5d11..435e84269a28 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -70,6 +70,7 @@ struct vfio_iommu {
>  	unsigned int		dma_avail;
>  	bool			v2;
>  	bool			nesting;
> +	bool			dirty_page_tracking;
>  };
>  
>  struct vfio_domain {
> @@ -90,6 +91,7 @@ struct vfio_dma {
>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> +	unsigned long		*bitmap;
>  };
>  
>  struct vfio_group {
> @@ -125,6 +127,7 @@ struct vfio_regions {
>  					(!list_empty(&iommu->domain_list))
>  
>  static int put_pfn(unsigned long pfn, int prot);
> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
>  
>  /*
>   * This code handles mapping and unmapping of user data buffers
> @@ -174,6 +177,76 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
>  	rb_erase(&old->node, &iommu->dma_list);
>  }
>  
> +static inline unsigned long dirty_bitmap_bytes(unsigned int npages)
> +{
> +	if (!npages)
> +		return 0;
> +
> +	return ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
> +}
> +
> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, unsigned long pgsize)
> +{
> +	if (!RB_EMPTY_ROOT(&dma->pfn_list) || dma->iommu_mapped) {
> +		unsigned long npages = dma->size / pgsize;
> +
> +		dma->bitmap = kvzalloc(dirty_bitmap_bytes(npages), GFP_KERNEL);
> +		if (!dma->bitmap)
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static int vfio_dma_all_bitmap_alloc(struct vfio_iommu *iommu,
> +				     unsigned long pgsize)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +	int ret;
> +
> +	for (; n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +		struct rb_node *n;
> +
> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> +		if (ret) {
> +			struct rb_node *p = rb_prev(n);
> +
> +			for (; p; p = rb_prev(p)) {
> +				struct vfio_dma *dma = rb_entry(n,
> +							struct vfio_dma, node);
> +
> +				kfree(dma->bitmap);
> +				dma->bitmap = NULL;
> +			}
> +			return ret;
> +		}
> +
> +		if (!dma->bitmap)
> +			continue;
> +
> +		for (n = rb_first(&dma->pfn_list); n; n = rb_next(n)) {
> +			struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn,
> +							 node);
> +
> +			bitmap_set(dma->bitmap,
> +				   (vpfn->iova - dma->iova) / pgsize, 1);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void vfio_dma_all_bitmap_free(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +
> +	for (; n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		kfree(dma->bitmap);
> +		dma->bitmap = NULL;
> +	}
> +}
> +
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> @@ -254,12 +327,16 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
>  	return vpfn;
>  }
>  
> -static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
> +static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn,
> +				  bool do_tracking, unsigned long pgsize)
>  {
>  	int ret = 0;
>  
>  	vpfn->ref_count--;
>  	if (!vpfn->ref_count) {
> +		if (do_tracking && dma->bitmap)
> +			bitmap_set(dma->bitmap,
> +				   (vpfn->iova - dma->iova) / pgsize, 1);
>  		ret = put_pfn(vpfn->pfn, dma->prot);
>  		vfio_remove_from_pfn_list(dma, vpfn);
>  	}
> @@ -484,7 +561,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>  }
>  
>  static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> -				    bool do_accounting)
> +				    bool do_accounting, bool do_tracking,
> +				    unsigned long pgsize)
>  {
>  	int unlocked;
>  	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
> @@ -492,7 +570,7 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
>  	if (!vpfn)
>  		return 0;
>  
> -	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, do_tracking, pgsize);
>  
>  	if (do_accounting)
>  		vfio_lock_acct(dma, -unlocked, true);
> @@ -563,9 +641,26 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
>  		if (ret) {
> -			vfio_unpin_page_external(dma, iova, do_accounting);
> +			vfio_unpin_page_external(dma, iova, do_accounting,
> +						 false, 0);
>  			goto pin_unwind;
>  		}
> +
> +		if (iommu->dirty_page_tracking) {
> +			unsigned long pgshift =
> +					 __ffs(vfio_pgsize_bitmap(iommu));
> +
> +			if (!dma->bitmap) {
> +				ret = vfio_dma_bitmap_alloc(dma, 1 << pgshift);
> +				if (ret) {
> +					vfio_unpin_page_external(dma, iova,
> +						 do_accounting, false, 0);
> +					goto pin_unwind;
> +				}
> +			}
> +			bitmap_set(dma->bitmap,
> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> +		}
>  	}
>  
>  	ret = i;
> @@ -578,7 +673,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  		iova = user_pfn[j] << PAGE_SHIFT;
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> -		vfio_unpin_page_external(dma, iova, do_accounting);
> +		vfio_unpin_page_external(dma, iova, do_accounting, false, 0);
>  		phys_pfn[j] = 0;
>  	}
>  pin_done:
> @@ -612,7 +707,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>  		if (!dma)
>  			goto unpin_exit;
> -		vfio_unpin_page_external(dma, iova, do_accounting);
> +		vfio_unpin_page_external(dma, iova, do_accounting,
> +					 iommu->dirty_page_tracking, PAGE_SIZE);
>  	}
>  
>  unpin_exit:
> @@ -800,6 +896,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> +	kfree(dma->bitmap);
>  	kfree(dma);
>  	iommu->dma_avail++;
>  }
> @@ -830,6 +927,54 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  	return bitmap;
>  }
>  
> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> +				  size_t size, uint64_t pgsize,
> +				  unsigned char __user *bitmap)
> +{
> +	struct vfio_dma *dma;
> +	unsigned long pgshift = __ffs(pgsize);
> +	unsigned int npages, bitmap_size;
> +
> +	dma = vfio_find_dma(iommu, iova, 1);
> +
> +	if (!dma)
> +		return -EINVAL;
> +
> +	if (dma->iova != iova || dma->size != size)
> +		return -EINVAL;
> +
> +	npages = dma->size >> pgshift;
> +	bitmap_size = dirty_bitmap_bytes(npages);
> +
> +	/* mark all pages dirty if all pages are pinned and mapped. */
> +	if (dma->iommu_mapped)
> +		bitmap_set(dma->bitmap, 0, npages);
> +
> +	if (dma->bitmap) {
> +		if (copy_to_user((void __user *)bitmap, dma->bitmap,
> +				 bitmap_size))
> +			return -EFAULT;
> +
> +		memset(dma->bitmap, 0, bitmap_size);
> +	}
> +	return 0;
> +}
> +
> +static int verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
> +{
> +	long bsize;
> +
> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
> +		return -EINVAL;
> +
> +	bsize = dirty_bitmap_bytes(npages);
> +
> +	if (bitmap_size < bsize)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>  {
> @@ -2277,6 +2422,92 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> +		struct vfio_iommu_type1_dirty_bitmap dirty;
> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> +		int ret;
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

It seems a bit odd to use a set of ORable flags when only one can be set
at a time.

> +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> +			unsigned long iommu_pgsize =
> +					1 << __ffs(vfio_pgsize_bitmap(iommu));
> +
> +			mutex_lock(&iommu->lock);
> +			ret = vfio_dma_all_bitmap_alloc(iommu, iommu_pgsize);
> +			if (!ret)
> +				iommu->dirty_page_tracking = true;
> +			mutex_unlock(&iommu->lock);
> +			return ret;
> +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> +			mutex_lock(&iommu->lock);
> +			if (iommu->dirty_page_tracking) {
> +				iommu->dirty_page_tracking = false;
> +				vfio_dma_all_bitmap_free(iommu);
> +			}
> +			mutex_unlock(&iommu->lock);
> +			return 0;
> +		} else if (dirty.flags &
> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> +			struct vfio_iommu_type1_dirty_bitmap_get range;
> +			unsigned long pgshift;
> +			size_t data_size = dirty.argsz - minsz;
> +			uint64_t iommu_pgsize =
> +					 1 << __ffs(vfio_pgsize_bitmap(iommu));
> +
> +			if (!data_size || data_size < sizeof(range))
> +				return -EINVAL;
> +
> +			if (copy_from_user(&range, (void __user *)(arg + minsz),
> +					   sizeof(range)))
> +				return -EFAULT;
> +
> +			// allow only min supported pgsize
> +			if (range.pgsize != iommu_pgsize)
> +				return -EINVAL;
> +			if (range.iova & (iommu_pgsize - 1))
> +				return -EINVAL;
> +			if (!range.size || range.size & (iommu_pgsize - 1))
> +				return -EINVAL;
> +			if (range.iova + range.size < range.iova)
> +				return -EINVAL;
> +			if (!access_ok((void __user *)range.bitmap,
> +				       range.bitmap_size))
> +				return -EINVAL;
> +
> +			pgshift = __ffs(range.pgsize);
> +			ret = verify_bitmap_size(range.size >> pgshift,
> +						 range.bitmap_size);
> +			if (ret)
> +				return ret;
> +
> +			mutex_lock(&iommu->lock);
> +			if (iommu->dirty_page_tracking)
> +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
> +					 range.size, range.pgsize,
> +					 (unsigned char __user *)range.bitmap);
> +			else
> +				ret = -EINVAL;
> +			mutex_unlock(&iommu->lock);
> +
> +			return ret;
> +		}
>  	}
>  
>  	return -ENOTTY;
> -- 
> 2.7.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

