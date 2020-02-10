Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E615723F
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 10:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgBJJ7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 04:59:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:64093 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgBJJ7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 04:59:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 01:59:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,424,1574150400"; 
   d="scan'208";a="431553407"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 10 Feb 2020 01:59:11 -0800
Date:   Mon, 10 Feb 2020 04:49:54 -0500
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
Subject: Re: [PATCH v12 Kernel 4/7] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200210094954.GA4530@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
 <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 08, 2020 at 03:42:31AM +0800, Kirti Wankhede wrote:
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
> There could be multiple option as to when bitmap should be populated:
> * Polulate bitmap for already pinned pages when bitmap is allocated for
>   a vfio_dma with the smallest supported page size. Updates bitmap from
>   page pinning and unpinning functions. When user application queries
>   bitmap, check if requested page size is same as page size used to
>   populated bitmap. If it is equal, copy bitmap. But if not equal,
>   re-populated bitmap according to requested page size and then copy to
>   user.
>   Pros: Bitmap gets populated on the fly after dirty tracking has
>         started.
>   Cons: If requested page size is different than smallest supported
>         page size, then bitmap has to be re-populated again, with
>         additional overhead of allocating bitmap memory again for
>         re-population of bitmap.
> 
> * Populate bitmap when bitmap is queried by user application.
>   Pros: Bitmap is populated with requested page size. This eliminates
>         the need to re-populate bitmap if requested page size is
>         different than smallest supported pages size.
>   Cons: There is one time processing time, when bitmap is queried.
> 
> I prefer later option with simple logic and to eliminate over-head of
> bitmap repopulation in case of differnt page sizes. Later option is
> implemented in this patch.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 299 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 287 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d386461e5d11..df358dc1c85b 100644
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
> @@ -174,6 +177,57 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
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
> +static int vfio_dma_bitmap_alloc(struct vfio_iommu *iommu,
> +				 struct vfio_dma *dma, unsigned long pgsizes)
> +{
> +	unsigned long pgshift = __ffs(pgsizes);
> +
> +	if (!RB_EMPTY_ROOT(&dma->pfn_list) || dma->iommu_mapped) {
> +		unsigned long npages = dma->size >> pgshift;
> +		unsigned long bsize = dirty_bitmap_bytes(npages);
> +
> +		dma->bitmap = kvzalloc(bsize, GFP_KERNEL);
> +		if (!dma->bitmap)
> +			return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static int vfio_dma_all_bitmap_alloc(struct vfio_iommu *iommu,
> +				     unsigned long pgsizes)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +	int ret;
> +
> +	for (; n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		ret = vfio_dma_bitmap_alloc(iommu, dma, pgsizes);
> +		if (ret)
> +			return ret;
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
> +	}
> +}
> +
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> @@ -244,6 +298,29 @@ static void vfio_remove_from_pfn_list(struct vfio_dma *dma,
>  	kfree(vpfn);
>  }
>  
> +static void vfio_remove_unpinned_from_pfn_list(struct vfio_dma *dma)
> +{
> +	struct rb_node *n = rb_first(&dma->pfn_list);
> +
> +	for (; n; n = rb_next(n)) {
> +		struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn, node);
> +
> +		if (!vpfn->ref_count)
> +			vfio_remove_from_pfn_list(dma, vpfn);
> +	}
> +}
> +
> +static void vfio_remove_unpinned_from_dma_list(struct vfio_iommu *iommu)
> +{
> +	struct rb_node *n = rb_first(&iommu->dma_list);
> +
> +	for (; n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		vfio_remove_unpinned_from_pfn_list(dma);
> +	}
> +}
> +
>  static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
>  					       unsigned long iova)
>  {
> @@ -261,7 +338,8 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>  	vpfn->ref_count--;
>  	if (!vpfn->ref_count) {
>  		ret = put_pfn(vpfn->pfn, dma->prot);
> -		vfio_remove_from_pfn_list(dma, vpfn);
> +		if (!dma->bitmap)
> +			vfio_remove_from_pfn_list(dma, vpfn);
>  	}
>  	return ret;
>  }
> @@ -483,13 +561,14 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>  	return ret;
>  }
>  
> -static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> +static int vfio_unpin_page_external(struct vfio_iommu *iommu,
> +				    struct vfio_dma *dma, dma_addr_t iova,
>  				    bool do_accounting)
>  {
>  	int unlocked;
>  	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
>  
> -	if (!vpfn)
> +	if (!vpfn || !vpfn->ref_count)
>  		return 0;
>  
>  	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
> @@ -510,6 +589,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	unsigned long remote_vaddr;
>  	struct vfio_dma *dma;
>  	bool do_accounting;
> +	unsigned long iommu_pgsizes = vfio_pgsize_bitmap(iommu);
>  
>  	if (!iommu || !user_pfn || !phys_pfn)
>  		return -EINVAL;
> @@ -551,8 +631,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
>  		if (vpfn) {
> -			phys_pfn[i] = vpfn->pfn;
> -			continue;
> +			if (vpfn->ref_count > 1) {
> +				phys_pfn[i] = vpfn->pfn;
> +				continue;
> +			}
>  		}
>  
>  		remote_vaddr = dma->vaddr + iova - dma->iova;
> @@ -560,11 +642,23 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  					     do_accounting);
>  		if (ret)
>  			goto pin_unwind;
> -
> -		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> -		if (ret) {
> -			vfio_unpin_page_external(dma, iova, do_accounting);
> -			goto pin_unwind;
> +		if (!vpfn) {
> +			ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> +			if (ret) {
> +				vfio_unpin_page_external(iommu, dma, iova,
> +							 do_accounting);
> +				goto pin_unwind;
> +			}
> +		} else
> +			vpfn->pfn = phys_pfn[i];
> +
> +		if (iommu->dirty_page_tracking && !dma->bitmap) {
> +			ret = vfio_dma_bitmap_alloc(iommu, dma, iommu_pgsizes);
> +			if (ret) {
> +				vfio_unpin_page_external(iommu, dma, iova,
> +							 do_accounting);
> +				goto pin_unwind;
> +			}
>  		}
>  	}
>  
> @@ -578,7 +672,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  		iova = user_pfn[j] << PAGE_SHIFT;
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> -		vfio_unpin_page_external(dma, iova, do_accounting);
> +		vfio_unpin_page_external(iommu, dma, iova, do_accounting);
>  		phys_pfn[j] = 0;
>  	}
>  pin_done:
> @@ -612,7 +706,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>  		if (!dma)
>  			goto unpin_exit;
> -		vfio_unpin_page_external(dma, iova, do_accounting);
> +		vfio_unpin_page_external(iommu, dma, iova, do_accounting);
>  	}
>  
>  unpin_exit:
> @@ -830,6 +924,113 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  	return bitmap;
>  }
>  
> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> +				  size_t size, uint64_t pgsize,
> +				  unsigned char __user *bitmap)
> +{
> +	struct vfio_dma *dma;
> +	dma_addr_t i = iova, iova_limit;
> +	unsigned int bsize, nbits = 0, l = 0;
> +	unsigned long pgshift = __ffs(pgsize);
> +
> +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
> +		int ret, j;
> +		unsigned int npages = 0, shift = 0;
> +		unsigned char temp = 0;
> +
> +		/* mark all pages dirty if all pages are pinned and mapped. */
> +		if (dma->iommu_mapped) {
> +			iova_limit = min(dma->iova + dma->size, iova + size);
> +			npages = iova_limit/pgsize;
> +			bitmap_set(dma->bitmap, 0, npages);
for pass-through devices, it's not good to always return all pinned pages as
dirty. could it also call vfio_pin_pages to track dirty pages? or any
other interface provided to do that?
> +		} else if (dma->bitmap) {
> +			struct rb_node *n = rb_first(&dma->pfn_list);
> +			bool found = false;
> +
> +			for (; n; n = rb_next(n)) {
> +				struct vfio_pfn *vpfn = rb_entry(n,
> +						struct vfio_pfn, node);
> +				if (vpfn->iova >= i) {
> +					found = true;
> +					break;
> +				}
> +			}
> +
> +			if (!found) {
> +				i += dma->size;
> +				continue;
> +			}
> +
> +			for (; n; n = rb_next(n)) {
> +				unsigned int s;
> +				struct vfio_pfn *vpfn = rb_entry(n,
> +						struct vfio_pfn, node);
> +
> +				if (vpfn->iova >= iova + size)
> +					break;
> +
> +				s = (vpfn->iova - dma->iova) >> pgshift;
> +				bitmap_set(dma->bitmap, s, 1);
> +
should not set the dma->bitmap when user space asks for dirty bitmap.
should set the bits for all vpfns when dirty page tracking starts, and clear
it after putting them to user space.
dma->bitmap is set when vfio_pin_pages is called during dirty page
tracking.
> +				iova_limit = vpfn->iova + pgsize;
> +			}
> +			npages = iova_limit/pgsize;
> +		}
> +
> +		bsize = dirty_bitmap_bytes(npages);
> +		shift = nbits % BITS_PER_BYTE;
> +
> +		if (npages && shift) {
> +			l--;
> +			if (!access_ok((void __user *)bitmap + l,
> +					sizeof(unsigned char)))
> +				return -EINVAL;
> +
> +			ret = __get_user(temp, bitmap + l);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		for (j = 0; j < bsize; j++, l++) {
> +			temp = temp |
> +			       (*((unsigned char *)dma->bitmap + j) << shift);
> +			if (!access_ok((void __user *)bitmap + l,
> +					sizeof(unsigned char)))
> +				return -EINVAL;
> +
> +			ret = __put_user(temp, bitmap + l);
> +			if (ret)
> +				return ret;
> +			if (shift) {
> +				temp = *((unsigned char *)dma->bitmap + j) >>
> +					(BITS_PER_BYTE - shift);
> +			}
> +		}
> +
> +		nbits += npages;
> +
> +		i = min(dma->iova + dma->size, iova + size);
> +		if (i >= iova + size)
> +			break;
> +	}
> +	return 0;
> +}
> +
> +static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
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
> +	return bsize;
> +}
> +
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>  {
> @@ -2277,6 +2478,80 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  
>  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  			-EFAULT : 0;
> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> +		struct vfio_iommu_type1_dirty_bitmap range;
> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> +		int ret;
> +
> +		if (!iommu->v2)
> +			return -EACCES;
> +
> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> +				    bitmap);
> +
> +		if (copy_from_user(&range, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (range.argsz < minsz || range.flags & ~mask)
> +			return -EINVAL;
> +
> +		/* only one flag should be set at a time */
> +		if (__ffs(range.flags) != __fls(range.flags))
> +			return -EINVAL;
> +
> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> +			unsigned long iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> +
> +			mutex_lock(&iommu->lock);
> +			iommu->dirty_page_tracking = true;
should only set iommu->dirty_page_tracking = true after bitmap alloc
succeeds.
> +			ret = vfio_dma_all_bitmap_alloc(iommu, iommu_pgsizes);
> +			mutex_unlock(&iommu->lock);
> +			return ret;
> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> +			mutex_lock(&iommu->lock);
> +			iommu->dirty_page_tracking = false;
> +			vfio_dma_all_bitmap_free(iommu);
> +			vfio_remove_unpinned_from_dma_list(iommu);
> +			mutex_unlock(&iommu->lock);
> +			return 0;
> +		} else if (range.flags &
> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> +			long bsize;
> +			unsigned long pgshift = __ffs(range.pgsize);
> +			uint64_t iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> +			uint64_t iommu_pgmask =
> +				 ((uint64_t)1 << __ffs(iommu_pgsizes)) - 1;
> +
> +			if ((range.pgsize & iommu_pgsizes) != range.pgsize)
> +				return -EINVAL;
> +			if (range.iova & iommu_pgmask)
> +				return -EINVAL;
> +			if (!range.size || range.size & iommu_pgmask)
> +				return -EINVAL;
> +			if (range.iova + range.size < range.iova)
> +				return -EINVAL;
> +			if (!access_ok((void __user *)range.bitmap,
> +				       range.bitmap_size))
> +				return -EINVAL;
> +
> +			bsize = verify_bitmap_size(range.size >> pgshift,
> +						   range.bitmap_size);
> +			if (bsize < 0)
> +				return bsize;
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
