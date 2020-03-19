Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5799718ACBD
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCSGZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:25:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:63744 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSGZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:25:08 -0400
IronPort-SDR: TfVsTepOiTLwtU2BGkvqSZxC2LkWvFe4gsP3M9bxr6rRsAz/qRqgOC21pKLBdWQdOex7IbaAAm
 em8/GMqtxzLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 23:25:08 -0700
IronPort-SDR: CrZSm3d6V4c6ikoZn5JxlUIsQmixrctWXVim5vheZiA3pzbuvbxNCCyvdbFT1RDrnR0x1IzlwN
 w8ejzN0lQ/Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="444452018"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 18 Mar 2020 23:25:03 -0700
Date:   Thu, 19 Mar 2020 02:15:34 -0400
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
Subject: Re: [PATCH v14 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200319061534.GG4641@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-5-git-send-email-kwankhede@nvidia.com>
 <20200319030639.GD4641@joy-OptiPlex-7040>
 <20200318220100.1aac12fa@w520.home>
 <20200319041533.GE4641@joy-OptiPlex-7040>
 <20200318224053.3651c818@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318224053.3651c818@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 12:40:53PM +0800, Alex Williamson wrote:
> On Thu, 19 Mar 2020 00:15:33 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, Mar 19, 2020 at 12:01:00PM +0800, Alex Williamson wrote:
> > > On Wed, 18 Mar 2020 23:06:39 -0400
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > On Thu, Mar 19, 2020 at 03:41:11AM +0800, Kirti Wankhede wrote:  
> > > > > VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > > > > - Start dirty pages tracking while migration is active
> > > > > - Stop dirty pages tracking.
> > > > > - Get dirty pages bitmap. Its user space application's responsibility to
> > > > >   copy content of dirty pages from source to destination during migration.
> > > > > 
> > > > > To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> > > > > structure. Bitmap size is calculated considering smallest supported page
> > > > > size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> > > > > 
> > > > > Bitmap is populated for already pinned pages when bitmap is allocated for
> > > > > a vfio_dma with the smallest supported page size. Update bitmap from
> > > > > pinning functions when tracking is enabled. When user application queries
> > > > > bitmap, check if requested page size is same as page size used to
> > > > > populated bitmap. If it is equal, copy bitmap, but if not equal, return
> > > > > error.
> > > > > 
> > > > > Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > > > > Reviewed-by: Neo Jia <cjia@nvidia.com>
> > > > > ---
> > > > >  drivers/vfio/vfio_iommu_type1.c | 205 +++++++++++++++++++++++++++++++++++++++-
> > > > >  1 file changed, 203 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > > index 70aeab921d0f..d6417fb02174 100644
> > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -71,6 +71,7 @@ struct vfio_iommu {
> > > > >  	unsigned int		dma_avail;
> > > > >  	bool			v2;
> > > > >  	bool			nesting;
> > > > > +	bool			dirty_page_tracking;
> > > > >  };
> > > > >  
> > > > >  struct vfio_domain {
> > > > > @@ -91,6 +92,7 @@ struct vfio_dma {
> > > > >  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> > > > >  	struct task_struct	*task;
> > > > >  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> > > > > +	unsigned long		*bitmap;
> > > > >  };
> > > > >  
> > > > >  struct vfio_group {
> > > > > @@ -125,7 +127,10 @@ struct vfio_regions {
> > > > >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> > > > >  					(!list_empty(&iommu->domain_list))
> > > > >  
> > > > > +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> > > > > +
> > > > >  static int put_pfn(unsigned long pfn, int prot);
> > > > > +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> > > > >  
> > > > >  /*
> > > > >   * This code handles mapping and unmapping of user data buffers
> > > > > @@ -175,6 +180,55 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> > > > >  	rb_erase(&old->node, &iommu->dma_list);
> > > > >  }
> > > > >  
> > > > > +static int vfio_dma_bitmap_alloc(struct vfio_iommu *iommu, uint64_t pgsize)
> > > > > +{
> > > > > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > > > > +
> > > > > +	for (; n; n = rb_next(n)) {
> > > > > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > > > > +		struct rb_node *p;
> > > > > +		unsigned long npages = dma->size / pgsize;
> > > > > +
> > > > > +		dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> > > > > +		if (!dma->bitmap) {
> > > > > +			struct rb_node *p = rb_prev(n);
> > > > > +
> > > > > +			for (; p; p = rb_prev(p)) {
> > > > > +				struct vfio_dma *dma = rb_entry(n,
> > > > > +							struct vfio_dma, node);
> > > > > +
> > > > > +				kfree(dma->bitmap);
> > > > > +				dma->bitmap = NULL;
> > > > > +			}
> > > > > +			return -ENOMEM;
> > > > > +		}
> > > > > +
> > > > > +		if (RB_EMPTY_ROOT(&dma->pfn_list))
> > > > > +			continue;
> > > > > +
> > > > > +		for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> > > > > +			struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn,
> > > > > +							 node);
> > > > > +
> > > > > +			bitmap_set(dma->bitmap,
> > > > > +					(vpfn->iova - dma->iova) / pgsize, 1);
> > > > > +		}
> > > > > +	}
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static void vfio_dma_bitmap_free(struct vfio_iommu *iommu)
> > > > > +{
> > > > > +	struct rb_node *n = rb_first(&iommu->dma_list);
> > > > > +
> > > > > +	for (; n; n = rb_next(n)) {
> > > > > +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > > > > +
> > > > > +		kfree(dma->bitmap);
> > > > > +		dma->bitmap = NULL;
> > > > > +	}
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * Helper Functions for host iova-pfn list
> > > > >   */
> > > > > @@ -567,6 +621,14 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > > > >  			vfio_unpin_page_external(dma, iova, do_accounting);
> > > > >  			goto pin_unwind;
> > > > >  		}
> > > > > +
> > > > > +		if (iommu->dirty_page_tracking) {
> > > > > +			unsigned long pgshift =
> > > > > +					 __ffs(vfio_pgsize_bitmap(iommu));
> > > > > +
> > > > > +			bitmap_set(dma->bitmap,
> > > > > +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> > > > > +		}
> > > > >  	}
> > > > >  
> > > > >  	ret = i;
> > > > > @@ -801,6 +863,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> > > > >  	vfio_unmap_unpin(iommu, dma, true);
> > > > >  	vfio_unlink_dma(iommu, dma);
> > > > >  	put_task_struct(dma->task);
> > > > > +	kfree(dma->bitmap);
> > > > >  	kfree(dma);
> > > > >  	iommu->dma_avail++;
> > > > >  }
> > > > > @@ -831,6 +894,50 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> > > > >  	return bitmap;
> > > > >  }
> > > > >  
> > > > > +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > > > > +				  size_t size, uint64_t pgsize,
> > > > > +				  unsigned char __user *bitmap)
> > > > > +{
> > > > > +	struct vfio_dma *dma;
> > > > > +	unsigned long pgshift = __ffs(pgsize);
> > > > > +	unsigned int npages, bitmap_size;
> > > > > +
> > > > > +	dma = vfio_find_dma(iommu, iova, 1);
> > > > > +
> > > > > +	if (!dma)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	if (dma->iova != iova || dma->size != size)
> > > > > +		return -EINVAL;
> > > > > +    
> > > > looks this size is passed from user. how can it ensure size always
> > > > equals to dma->size ?
> > > > 
> > > > shouldn't we iterate dma tree to look for dirty for whole range if a
> > > > single dma cannot meet them all?  
> > > 
> > > Please see the discussion on v12[1], the problem is with the alignment
> > > of DMA mapped regions versus the bitmap.  A DMA mapping only requires
> > > page alignment, so for example imagine a user requests the bitmap from
> > > page zero to 4GB, but we have a DMA mapping starting at 4KB.  We can't
> > > efficiently copy the bitmap tracked by the vfio_dma structure to the
> > > user buffer when it's shifted by 1 bit.  Adjacent mappings can also
> > > make for a very complicated implementation.  In the discussion linked
> > > we decided to compromise on a more simple implementation that requires
> > > the user to ask for a bitmap which exactly matches a single DMA
> > > mapping, which Kirti indicates is what we require to support QEMU.
> > > Later in the series, the unmap operation also makes this requirement
> > > when used with the flags to retrieve the dirty bitmap.  Thanks,
> > >  
> > 
> > so, what about for vIOMMU enabling case?
> > if IOVAs are mapped per page, then there's a log_sync in qemu,
> > it's supposed for range from 0-U64MAX, qemu has to find out which
> > ones are mapped and cut them into pages before calling this IOCTL?
> > And what if those IOVAs are mapped for len more than one page?
> 
> Good question.  Kirti?
> 
> > > [1] https://lore.kernel.org/kvm/20200218215330.5bc8fc6a@w520.home/
> > >    
> > > > > +	npages = dma->size >> pgshift;
> > > > > +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> > > > > +
> > > > > +	/* mark all pages dirty if all pages are pinned and mapped. */
> > > > > +	if (dma->iommu_mapped)
> > > > > +		bitmap_set(dma->bitmap, 0, npages);
> > > > > +
> > > > > +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> > > > > +		return -EFAULT;
> > > > > +
Here, dma->bitmap needs to be cleared. right?

> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> > > > > +{
> > > > > +	uint64_t bsize;
> > > > > +
> > > > > +	if (!npages || !bitmap_size || bitmap_size > UINT_MAX)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	bsize = DIRTY_BITMAP_BYTES(npages);
> > > > > +
> > > > > +	if (bitmap_size < bsize)
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > > > >  			     struct vfio_iommu_type1_dma_unmap *unmap)
> > > > >  {
> > > > > @@ -2278,6 +2385,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > > >  
> > > > >  		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > > > >  			-EFAULT : 0;
> > > > > +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> > > > > +		struct vfio_iommu_type1_dirty_bitmap dirty;
> > > > > +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > > > > +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > > > > +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > > > > +		int ret = 0;
> > > > > +
> > > > > +		if (!iommu->v2)
> > > > > +			return -EACCES;
> > > > > +
> > > > > +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > > > > +				    flags);
> > > > > +
> > > > > +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> > > > > +			return -EFAULT;
> > > > > +
> > > > > +		if (dirty.argsz < minsz || dirty.flags & ~mask)
> > > > > +			return -EINVAL;
> > > > > +
> > > > > +		/* only one flag should be set at a time */
> > > > > +		if (__ffs(dirty.flags) != __fls(dirty.flags))
> > > > > +			return -EINVAL;
> > > > > +
> > > > > +		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > > > > +			uint64_t pgsize = 1 << __ffs(vfio_pgsize_bitmap(iommu));
> > > > > +
> > > > > +			mutex_lock(&iommu->lock);
> > > > > +			if (!iommu->dirty_page_tracking) {
> > > > > +				ret = vfio_dma_bitmap_alloc(iommu, pgsize);
> > > > > +				if (!ret)
> > > > > +					iommu->dirty_page_tracking = true;
> > > > > +			}
> > > > > +			mutex_unlock(&iommu->lock);
> > > > > +			return ret;
> > > > > +		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> > > > > +			mutex_lock(&iommu->lock);
> > > > > +			if (iommu->dirty_page_tracking) {
> > > > > +				iommu->dirty_page_tracking = false;
> > > > > +				vfio_dma_bitmap_free(iommu);
> > > > > +			}
> > > > > +			mutex_unlock(&iommu->lock);
> > > > > +			return 0;
> > > > > +		} else if (dirty.flags &
> > > > > +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > > > > +			struct vfio_iommu_type1_dirty_bitmap_get range;
> > > > > +			unsigned long pgshift;
> > > > > +			size_t data_size = dirty.argsz - minsz;
> > > > > +			uint64_t iommu_pgsize =
> > > > > +					 1 << __ffs(vfio_pgsize_bitmap(iommu));
> > > > > +
> > > > > +			if (!data_size || data_size < sizeof(range))
> > > > > +				return -EINVAL;
> > > > > +
> > > > > +			if (copy_from_user(&range, (void __user *)(arg + minsz),
> > > > > +					   sizeof(range)))
> > > > > +				return -EFAULT;
> > > > > +
> > > > > +			/* allow only min supported pgsize */
> > > > > +			if (range.bitmap.pgsize != iommu_pgsize)
> > > > > +				return -EINVAL;
> > > > > +			if (range.iova & (iommu_pgsize - 1))
> > > > > +				return -EINVAL;
> > > > > +			if (!range.size || range.size & (iommu_pgsize - 1))
> > > > > +				return -EINVAL;
> > > > > +			if (range.iova + range.size < range.iova)
> > > > > +				return -EINVAL;
> > > > > +			if (!access_ok((void __user *)range.bitmap.data,
> > > > > +				       range.bitmap.size))
> > > > > +				return -EINVAL;
> > > > > +
> > > > > +			pgshift = __ffs(range.bitmap.pgsize);
> > > > > +			ret = verify_bitmap_size(range.size >> pgshift,
> > > > > +						 range.bitmap.size);
> > > > > +			if (ret)
> > > > > +				return ret;
> > > > > +
> > > > > +			mutex_lock(&iommu->lock);
> > > > > +			if (iommu->dirty_page_tracking)
> > > > > +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
> > > > > +					 range.size, range.bitmap.pgsize,
> > > > > +				    (unsigned char __user *)range.bitmap.data);
> > > > > +			else
> > > > > +				ret = -EINVAL;
> > > > > +			mutex_unlock(&iommu->lock);
> > > > > +
> > > > > +			return ret;
> > > > > +		}
> > > > >  	}
> > > > >  
> > > > >  	return -ENOTTY;
> > > > > @@ -2345,10 +2539,17 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> > > > >  
> > > > >  	vaddr = dma->vaddr + offset;
> > > > >  
> > > > > -	if (write)
> > > > > +	if (write) {
> > > > >  		*copied = __copy_to_user((void __user *)vaddr, data,
> > > > >  					 count) ? 0 : count;
> > > > > -	else
> > > > > +		if (*copied && iommu->dirty_page_tracking) {
> > > > > +			unsigned long pgshift =
> > > > > +				__ffs(vfio_pgsize_bitmap(iommu));
> > > > > +
> > > > > +			bitmap_set(dma->bitmap, offset >> pgshift,
> > > > > +				   *copied >> pgshift);
> > > > > +		}
> > > > > +	} else
> > > > >  		*copied = __copy_from_user(data, (void __user *)vaddr,
> > > > >  					   count) ? 0 : count;
> > > > >  	if (kthread)
> > > > > -- 
> > > > > 2.7.0
> > > > >     
> > > >   
> > >   
> > 
> 
