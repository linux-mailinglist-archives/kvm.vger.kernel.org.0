Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5811988C9
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 02:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgCaAUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 20:20:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:14522 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgCaAUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 20:20:07 -0400
IronPort-SDR: u/nEV1gHfOMk7PR0s4dkodeqZH7DCUBRjc2/uBzd8MvYMy4SsI977s6q1R0q+bhADkQ4QzJKnG
 7Nom08nkSWgg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 17:20:06 -0700
IronPort-SDR: VEGZMBuPruyzsdAz9DY2v9+OKGPBGiGChK2ilh37+/PsMdE43ekbKlkjXqJi+M56Nf1mM49+8x
 h883/84sOGrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,326,1580803200"; 
   d="scan'208";a="272556725"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2020 17:20:01 -0700
Date:   Mon, 30 Mar 2020 20:10:28 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
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
Subject: Re: [PATCH v17 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200331001027.GA6631@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
 <1585587044-2408-5-git-send-email-kwankhede@nvidia.com>
 <20200330151909.71da1f91@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330151909.71da1f91@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 05:19:09AM +0800, Alex Williamson wrote:
> On Mon, 30 Mar 2020 22:20:41 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > - Start dirty pages tracking while migration is active
> > - Stop dirty pages tracking.
> > - Get dirty pages bitmap. Its user space application's responsibility to
> >   copy content of dirty pages from source to destination during migration.
> > 
> > To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> > structure. Bitmap size is calculated considering smallest supported page
> > size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> > 
> > Bitmap is populated for already pinned pages when bitmap is allocated for
> > a vfio_dma with the smallest supported page size. Update bitmap from
> > pinning functions when tracking is enabled. When user application queries
> > bitmap, check if requested page size is same as page size used to
> > populated bitmap. If it is equal, copy bitmap, but if not equal, return
> > error.
> > 
> > Fixed below error by changing pgsize type from uint64_t to size_t.
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All errors:
> > drivers/vfio/vfio_iommu_type1.c:197: undefined reference to `__udivdi3'
> > 
> > drivers/vfio/vfio_iommu_type1.c:225: undefined reference to `__udivdi3'
> > 
> > Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > Reviewed-by: Neo Jia <cjia@nvidia.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 260 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 70aeab921d0f..5efebc2b60e1 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -71,6 +71,7 @@ struct vfio_iommu {
> >  	unsigned int		dma_avail;
> >  	bool			v2;
> >  	bool			nesting;
> > +	bool			dirty_page_tracking;
> >  };
> >  
> >  struct vfio_domain {
> > @@ -91,6 +92,7 @@ struct vfio_dma {
> >  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >  	struct task_struct	*task;
> >  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> > +	unsigned long		*bitmap;
> >  };
> >  
> >  struct vfio_group {
> > @@ -125,7 +127,21 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >  
> > +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> > +
> > +/*
> > + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> > + * further casts to signed integer for unaligned multi-bit operation,
> > + * __bitmap_set().
> > + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> > + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> > + * system.
> > + */
> > +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
> 
> 
> This was supposed to be (INT_MAX), not (INT_MAX - 1).  Thanks,
> 
> Alex
> 
> 
> > +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> > +
> >  static int put_pfn(unsigned long pfn, int prot);
> > +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >  
> >  /*
> >   * This code handles mapping and unmapping of user data buffers
> > @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >  	rb_erase(&old->node, &iommu->dma_list);
> >  }
> >  
> > +
> > +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
> > +{
> > +	uint64_t npages = dma->size / pgsize;
> > +
> > +	if (npages > DIRTY_BITMAP_PAGES_MAX)
> > +		return -EINVAL;
> > +
> > +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> > +	if (!dma->bitmap)
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
> > +{
> > +	kfree(dma->bitmap);
> > +	dma->bitmap = NULL;
> > +}
> > +
> > +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
> > +{
> > +	struct rb_node *p;
> > +
> > +	if (RB_EMPTY_ROOT(&dma->pfn_list))
> > +		return;
> > +
> > +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> > +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
> > +
> > +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> > +	}
> > +}
> > +
> > +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
> > +{
> > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > +
> > +	for (; n; n = rb_next(n)) {
> > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > +		int ret;
> > +
> > +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> > +		if (ret) {
> > +			struct rb_node *p = rb_prev(n);
> > +
> > +			for (; p; p = rb_prev(p)) {
> > +				struct vfio_dma *dma = rb_entry(n,
> > +							struct vfio_dma, node);
> > +
> > +				vfio_dma_bitmap_free(dma);
> > +			}
> > +			return ret;
> > +		}
> > +		vfio_dma_populate_bitmap(dma, pgsize);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> > +{
> > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > +
> > +	for (; n; n = rb_next(n)) {
> > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > +
> > +		vfio_dma_bitmap_free(dma);
> > +	}
> > +}
> > +
> >  /*
> >   * Helper Functions for host iova-pfn list
> >   */
> > @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >  			vfio_unpin_page_external(dma, iova, do_accounting);
> >  			goto pin_unwind;
> >  		}
> > +
> > +		if (iommu->dirty_page_tracking) {
> > +			unsigned long pgshift =
> > +					 __ffs(vfio_pgsize_bitmap(iommu));
> > +
> > +			/*
> > +			 * Bitmap populated with the smallest supported page
> > +			 * size
> > +			 */
> > +			bitmap_set(dma->bitmap,
> > +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> > +		}
> >  	}
> >  
> >  	ret = i;
> > @@ -801,6 +900,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >  	vfio_unmap_unpin(iommu, dma, true);
> >  	vfio_unlink_dma(iommu, dma);
> >  	put_task_struct(dma->task);
> > +	vfio_dma_bitmap_free(dma);
> >  	kfree(dma);
> >  	iommu->dma_avail++;
> >  }
> > @@ -831,6 +931,57 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >  	return bitmap;
> >  }
> >  
> > +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > +				  size_t size, size_t pgsize,
> > +				  u64 __user *bitmap)
> > +{
> > +	struct vfio_dma *dma;
> > +	unsigned long pgshift = __ffs(pgsize);
> > +	unsigned int npages, bitmap_size;
> > +
> > +	dma = vfio_find_dma(iommu, iova, 1);
> > +
> > +	if (!dma)
> > +		return -EINVAL;
> > +
> > +	if (dma->iova != iova || dma->size != size)
> > +		return -EINVAL;
> > +
> > +	npages = dma->size >> pgshift;
> > +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> > +
> > +	/* mark all pages dirty if all pages are pinned and mapped. */
> > +	if (dma->iommu_mapped)
> > +		bitmap_set(dma->bitmap, 0, npages);
> > +
> > +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> > +		return -EFAULT;
> > +
> > +	/*
> > +	 * Re-populate bitmap to include all pinned pages which are considered
> > +	 * as dirty but exclude pages which are unpinned and pages which are
> > +	 * marked dirty by vfio_dma_rw()
> > +	 */
> > +	bitmap_clear(dma->bitmap, 0, npages);
> > +	vfio_dma_populate_bitmap(dma, pgsize);
> > +	return 0;
> > +}
> > +
> > +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> > +{
> > +	uint64_t bsize;
> > +
> > +	if (!npages || !bitmap_size || (bitmap_size > DIRTY_BITMAP_SIZE_MAX))
> > +		return -EINVAL;
> > +
> > +	bsize = DIRTY_BITMAP_BYTES(npages);
> > +
> > +	if (bitmap_size < bsize)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> >  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >  			     struct vfio_iommu_type1_dma_unmap *unmap)
> >  {
> > @@ -1038,16 +1189,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >  	unsigned long vaddr = map->vaddr;
> >  	size_t size = map->size;
> >  	int ret = 0, prot = 0;
> > -	uint64_t mask;
> > +	size_t pgsize;
> >  	struct vfio_dma *dma;
> >  
> >  	/* Verify that none of our __u64 fields overflow */
> >  	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
> >  		return -EINVAL;
> >  
> > -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> > +	pgsize = (size_t)1 << __ffs(vfio_pgsize_bitmap(iommu));
> >  
> > -	WARN_ON(mask & PAGE_MASK);
> > +	WARN_ON((pgsize - 1) & PAGE_MASK);
> >  
> >  	/* READ/WRITE from device perspective */
> >  	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
> > @@ -1055,7 +1206,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> >  		prot |= IOMMU_READ;
> >  
> > -	if (!prot || !size || (size | iova | vaddr) & mask)
> > +	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1))
> >  		return -EINVAL;
> >  
> >  	/* Don't allow IOVA or virtual address wrap */
> > @@ -1130,6 +1281,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >  	else
> >  		ret = vfio_pin_map_dma(iommu, dma, size);
> >  
> > +	if (!ret && iommu->dirty_page_tracking) {
> > +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> > +		if (ret)
> > +			vfio_remove_dma(iommu, dma);
> > +	}
> > +
> >  out_unlock:
> >  	mutex_unlock(&iommu->lock);
> >  	return ret;
> > @@ -2278,6 +2435,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  
> >  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> >  			-EFAULT : 0;
> > +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> > +		struct vfio_iommu_type1_dirty_bitmap dirty;
> > +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > +		int ret = 0;
> > +
> > +		if (!iommu->v2)
> > +			return -EACCES;
> > +
> > +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > +				    flags);
> > +
> > +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (dirty.argsz < minsz || dirty.flags & ~mask)
> > +			return -EINVAL;
> > +
> > +		/* only one flag should be set at a time */
> > +		if (__ffs(dirty.flags) != __fls(dirty.flags))
> > +			return -EINVAL;
> > +
> > +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > +			size_t pgsize = 1 << __ffs(vfio_pgsize_bitmap(iommu));
> > +
should not use smallest iommu page size as pgsize here as well as for
bitmap_set.
qemu uses 4k for dirty page track.
> > +			mutex_lock(&iommu->lock);
> > +			if (!iommu->dirty_page_tracking) {
> > +				ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> > +				if (!ret)
> > +					iommu->dirty_page_tracking = true;
> > +			}
> > +			mutex_unlock(&iommu->lock);
> > +			return ret;
> > +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> > +			mutex_lock(&iommu->lock);
> > +			if (iommu->dirty_page_tracking) {
> > +				iommu->dirty_page_tracking = false;
> > +				vfio_dma_bitmap_free_all(iommu);
> > +			}
> > +			mutex_unlock(&iommu->lock);
> > +			return 0;
> > +		} else if (dirty.flags &
> > +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > +			struct vfio_iommu_type1_dirty_bitmap_get range;
> > +			unsigned long pgshift;
> > +			size_t data_size = dirty.argsz - minsz;
> > +			size_t iommu_pgsize =
> > +				 (size_t)1 << __ffs(vfio_pgsize_bitmap(iommu));
> > +
> > +			if (!data_size || data_size < sizeof(range))
> > +				return -EINVAL;
> > +
> > +			if (copy_from_user(&range, (void __user *)(arg + minsz),
> > +					   sizeof(range)))
> > +				return -EFAULT;
> > +
> > +			/* allow only smallest supported pgsize */
> > +			if (range.bitmap.pgsize != iommu_pgsize)
> > +				return -EINVAL;
> > +			if (range.iova & (iommu_pgsize - 1))
> > +				return -EINVAL;
> > +			if (!range.size || range.size & (iommu_pgsize - 1))
> > +				return -EINVAL;
> > +			if (range.iova + range.size < range.iova)
> > +				return -EINVAL;
> > +			if (!access_ok((void __user *)range.bitmap.data,
> > +				       range.bitmap.size))
> > +				return -EINVAL;
> > +
> > +			pgshift = __ffs(range.bitmap.pgsize);
> > +			ret = verify_bitmap_size(range.size >> pgshift,
> > +						 range.bitmap.size);
> > +			if (ret)
> > +				return ret;
> > +
> > +			mutex_lock(&iommu->lock);
> > +			if (iommu->dirty_page_tracking)
> > +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
> > +						range.size, range.bitmap.pgsize,
> > +						range.bitmap.data);
> > +			else
> > +				ret = -EINVAL;
> > +			mutex_unlock(&iommu->lock);
> > +
> > +			return ret;
> > +		}
> >  	}
> >  
> >  	return -ENOTTY;
> > @@ -2345,10 +2589,20 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> >  
> >  	vaddr = dma->vaddr + offset;
> >  
> > -	if (write)
> > +	if (write) {
> >  		*copied = __copy_to_user((void __user *)vaddr, data,
> >  					 count) ? 0 : count;
> > -	else
> > +		if (*copied && iommu->dirty_page_tracking) {
> > +			unsigned long pgshift =
> > +				__ffs(vfio_pgsize_bitmap(iommu));
> > +			/*
> > +			 * Bitmap populated with the smallest supported page
> > +			 * size
> > +			 */
> > +			bitmap_set(dma->bitmap, offset >> pgshift,
> > +				   *copied >> pgshift);
> > +		}
> > +	} else
> >  		*copied = __copy_from_user(data, (void __user *)vaddr,
> >  					   count) ? 0 : count;
> >  	if (kthread)
> 
