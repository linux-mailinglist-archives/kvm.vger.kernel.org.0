Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51A12590F
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 02:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfLSBGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 20:06:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:48162 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLSBGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 20:06:07 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 17:06:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="248093681"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 18 Dec 2019 17:06:03 -0800
Date:   Wed, 18 Dec 2019 19:57:49 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 Kernel 4/5] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20191219005749.GJ21868@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-5-git-send-email-kwankhede@nvidia.com>
 <20191217051513.GE21868@joy-OptiPlex-7040>
 <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
 <20191217095110.GH21868@joy-OptiPlex-7040>
 <0d9604d9-3bb2-6944-9858-983366f332bb@nvidia.com>
 <20191218010451.GI21868@joy-OptiPlex-7040>
 <20191218200552.GX3707@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218200552.GX3707@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 04:05:52AM +0800, Dr. David Alan Gilbert wrote:
> * Yan Zhao (yan.y.zhao@intel.com) wrote:
> > On Tue, Dec 17, 2019 at 07:47:05PM +0800, Kirti Wankhede wrote:
> > > 
> > > 
> > > On 12/17/2019 3:21 PM, Yan Zhao wrote:
> > > > On Tue, Dec 17, 2019 at 05:24:14PM +0800, Kirti Wankhede wrote:
> > > >>
> > > >>
> > > >> On 12/17/2019 10:45 AM, Yan Zhao wrote:
> > > >>> On Tue, Dec 17, 2019 at 04:21:39AM +0800, Kirti Wankhede wrote:
> > > >>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > > >>>> - Start unpinned pages dirty pages tracking while migration is active and
> > > >>>>     device is running, i.e. during pre-copy phase.
> > > >>>> - Stop unpinned pages dirty pages tracking. This is required to stop
> > > >>>>     unpinned dirty pages tracking if migration failed or cancelled during
> > > >>>>     pre-copy phase. Unpinned pages tracking is clear.
> > > >>>> - Get dirty pages bitmap. Stop unpinned dirty pages tracking and clear
> > > >>>>     unpinned pages information on bitmap read. This ioctl returns bitmap of
> > > >>>>     dirty pages, its user space application responsibility to copy content
> > > >>>>     of dirty pages from source to destination during migration.
> > > >>>>
> > > >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > > >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > > >>>> ---
> > > >>>>    drivers/vfio/vfio_iommu_type1.c | 210 ++++++++++++++++++++++++++++++++++++++--
> > > >>>>    1 file changed, 203 insertions(+), 7 deletions(-)
> > > >>>>
> > > >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > >>>> index 3f6b04f2334f..264449654d3f 100644
> > > >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> > > >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> > > >>>> @@ -70,6 +70,7 @@ struct vfio_iommu {
> > > >>>>    	unsigned int		dma_avail;
> > > >>>>    	bool			v2;
> > > >>>>    	bool			nesting;
> > > >>>> +	bool			dirty_page_tracking;
> > > >>>>    };
> > > >>>>    
> > > >>>>    struct vfio_domain {
> > > >>>> @@ -112,6 +113,7 @@ struct vfio_pfn {
> > > >>>>    	dma_addr_t		iova;		/* Device address */
> > > >>>>    	unsigned long		pfn;		/* Host pfn */
> > > >>>>    	atomic_t		ref_count;
> > > >>>> +	bool			unpinned;
> > > >>>>    };
> > > >>>>    
> > > >>>>    struct vfio_regions {
> > > >>>> @@ -244,6 +246,32 @@ static void vfio_remove_from_pfn_list(struct vfio_dma *dma,
> > > >>>>    	kfree(vpfn);
> > > >>>>    }
> > > >>>>    
> > > >>>> +static void vfio_remove_unpinned_from_pfn_list(struct vfio_dma *dma, bool warn)
> > > >>>> +{
> > > >>>> +	struct rb_node *n = rb_first(&dma->pfn_list);
> > > >>>> +
> > > >>>> +	for (; n; n = rb_next(n)) {
> > > >>>> +		struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn, node);
> > > >>>> +
> > > >>>> +		if (warn)
> > > >>>> +			WARN_ON_ONCE(vpfn->unpinned);
> > > >>>> +
> > > >>>> +		if (vpfn->unpinned)
> > > >>>> +			vfio_remove_from_pfn_list(dma, vpfn);
> > > >>>> +	}
> > > >>>> +}
> > > >>>> +
> > > >>>> +static void vfio_remove_unpinned_from_dma_list(struct vfio_iommu *iommu)
> > > >>>> +{
> > > >>>> +	struct rb_node *n = rb_first(&iommu->dma_list);
> > > >>>> +
> > > >>>> +	for (; n; n = rb_next(n)) {
> > > >>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> > > >>>> +
> > > >>>> +		vfio_remove_unpinned_from_pfn_list(dma, false);
> > > >>>> +	}
> > > >>>> +}
> > > >>>> +
> > > >>>>    static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
> > > >>>>    					       unsigned long iova)
> > > >>>>    {
> > > >>>> @@ -254,13 +282,17 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
> > > >>>>    	return vpfn;
> > > >>>>    }
> > > >>>>    
> > > >>>> -static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
> > > >>>> +static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn,
> > > >>>> +				  bool dirty_tracking)
> > > >>>>    {
> > > >>>>    	int ret = 0;
> > > >>>>    
> > > >>>>    	if (atomic_dec_and_test(&vpfn->ref_count)) {
> > > >>>>    		ret = put_pfn(vpfn->pfn, dma->prot);
> > > >>> if physical page here is put, it may cause problem when pin this iova
> > > >>> next time:
> > > >>> vfio_iommu_type1_pin_pages {
> > > >>>       ...
> > > >>>       vpfn = vfio_iova_get_vfio_pfn(dma, iova);
> > > >>>       if (vpfn) {
> > > >>>           phys_pfn[i] = vpfn->pfn;
> > > >>>           continue;
> > > >>>       }
> > > >>>       ...
> > > >>> }
> > > >>>
> > > >>
> > > >> Good point. Fixing it as:
> > > >>
> > > >>                   vpfn = vfio_iova_get_vfio_pfn(dma, iova);
> > > >>                   if (vpfn) {
> > > >> -                       phys_pfn[i] = vpfn->pfn;
> > > >> -                       continue;
> > > >> +                       if (vpfn->unpinned)
> > > >> +                               vfio_remove_from_pfn_list(dma, vpfn);
> > > > what about updating vpfn instead?
> > > > 
> > > 
> > > vfio_pin_page_external() takes care of verification checks and mem lock 
> > > accounting. I prefer to free existing and add new node with existing 
> > > functions.
> > > 
> > > >> +                       else {
> > > >> +                               phys_pfn[i] = vpfn->pfn;
> > > >> +                               continue;
> > > >> +                       }
> > > >>                   }
> > > >>
> > > >>
> > > >>
> > > >>>> -		vfio_remove_from_pfn_list(dma, vpfn);
> > > >>>> +		if (dirty_tracking)
> > > >>>> +			vpfn->unpinned = true;
> > > >>>> +		else
> > > >>>> +			vfio_remove_from_pfn_list(dma, vpfn);
> > > >>> so the unpinned pages before dirty page tracking is not treated as
> > > >>> dirty?
> > > >>>
> > > >>
> > > >> Yes. That's we agreed on previous version:
> > > >> https://www.mail-archive.com/qemu-devel@nongnu.org/msg663157.html
> > > >>
> > > >>>>    	}
> > > >>>>    	return ret;
> > > >>>>    }
> > > >>>> @@ -504,7 +536,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
> > > >>>>    }
> > > >>>>    
> > > >>>>    static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> > > >>>> -				    bool do_accounting)
> > > >>>> +				    bool do_accounting, bool dirty_tracking)
> > > >>>>    {
> > > >>>>    	int unlocked;
> > > >>>>    	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
> > > >>>> @@ -512,7 +544,10 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> > > >>>>    	if (!vpfn)
> > > >>>>    		return 0;
> > > >>>>    
> > > >>>> -	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
> > > >>>> +	if (vpfn->unpinned)
> > > >>>> +		return 0;
> > > >>>> +
> > > >>>> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, dirty_tracking);
> > > >>>>    
> > > >>>>    	if (do_accounting)
> > > >>>>    		vfio_lock_acct(dma, -unlocked, true);
> > > >>>> @@ -583,7 +618,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > > >>>>    
> > > >>>>    		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> > > >>>>    		if (ret) {
> > > >>>> -			vfio_unpin_page_external(dma, iova, do_accounting);
> > > >>>> +			vfio_unpin_page_external(dma, iova, do_accounting,
> > > >>>> +						 false);
> > > >>>>    			goto pin_unwind;
> > > >>>>    		}
> > > >>>>    	}
> > > >>>> @@ -598,7 +634,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> > > >>>>    
> > > >>>>    		iova = user_pfn[j] << PAGE_SHIFT;
> > > >>>>    		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> > > >>>> -		vfio_unpin_page_external(dma, iova, do_accounting);
> > > >>>> +		vfio_unpin_page_external(dma, iova, do_accounting, false);
> > > >>>>    		phys_pfn[j] = 0;
> > > >>>>    	}
> > > >>>>    pin_done:
> > > >>>> @@ -632,7 +668,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
> > > >>>>    		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> > > >>>>    		if (!dma)
> > > >>>>    			goto unpin_exit;
> > > >>>> -		vfio_unpin_page_external(dma, iova, do_accounting);
> > > >>>> +		vfio_unpin_page_external(dma, iova, do_accounting,
> > > >>>> +					 iommu->dirty_page_tracking);
> > > >>>>    	}
> > > >>>>    
> > > >>>>    unpin_exit:
> > > >>>> @@ -850,6 +887,88 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> > > >>>>    	return bitmap;
> > > >>>>    }
> > > >>>>    
> > > >>>> +/*
> > > >>>> + * start_iova is the reference from where bitmaping started. This is called
> > > >>>> + * from DMA_UNMAP where start_iova can be different than iova
> > > >>>> + */
> > > >>>> +
> > > >>>> +static void vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > > >>>> +				  size_t size, uint64_t pgsize,
> > > >>>> +				  dma_addr_t start_iova, unsigned long *bitmap)
> > > >>>> +{
> > > >>>> +	struct vfio_dma *dma;
> > > >>>> +	dma_addr_t i = iova;
> > > >>>> +	unsigned long pgshift = __ffs(pgsize);
> > > >>>> +
> > > >>>> +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
> > > >>>> +		/* mark all pages dirty if all pages are pinned and mapped. */
> > > >>>> +		if (dma->iommu_mapped) {
> > > >>> This prevents pass-through devices from calling vfio_pin_pages to do
> > > >>> fine grained log dirty.
> > > >>
> > > >> Yes, I mentioned that in yet TODO item in cover letter:
> > > >>
> > > >> "If IOMMU capable device is present in the container, then all pages are
> > > >> marked dirty. Need to think smart way to know if IOMMU capable device's
> > > >> driver is smart to report pages to be marked dirty by pinning those
> > > >> pages externally."
> > > >>
> > > > why not just check first if any vpfn present for IOMMU capable devices?
> > > > 
> > > 
> > > vfio_pin_pages(dev, ...) calls driver->ops->pin_pages(iommu, ...)
> > > 
> > > In vfio_iommu_type1 module, vfio_iommu_type1_pin_pages() doesn't know 
> > > the device. vpfn are tracked against container->iommu, not against 
> > > device. Need to think of smart way to know if devices in container are 
> > > all smart which report pages dirty ny pinning those pages manually.
> > >
> > I believe in such case, the mdev on top of device is in the same iommu
> > group (i.e. 1:1 mdev on top of device).
> > device vendor driver calls vfio_pin_pages to notify vfio which pages are dirty. 
> > > 
> > > >>
> > > >>>> +			dma_addr_t iova_limit;
> > > >>>> +
> > > >>>> +			iova_limit = (dma->iova + dma->size) < (iova + size) ?
> > > >>>> +				     (dma->iova + dma->size) : (iova + size);
> > > >>>> +
> > > >>>> +			for (; i < iova_limit; i += pgsize) {
> > > >>>> +				unsigned int start;
> > > >>>> +
> > > >>>> +				start = (i - start_iova) >> pgshift;
> > > >>>> +
> > > >>>> +				__bitmap_set(bitmap, start, 1);
> > > >>>> +			}
> > > >>>> +			if (i >= iova + size)
> > > >>>> +				return;
> > > >>>> +		} else {
> > > >>>> +			struct rb_node *n = rb_first(&dma->pfn_list);
> > > >>>> +			bool found = false;
> > > >>>> +
> > > >>>> +			for (; n; n = rb_next(n)) {
> > > >>>> +				struct vfio_pfn *vpfn = rb_entry(n,
> > > >>>> +							struct vfio_pfn, node);
> > > >>>> +				if (vpfn->iova >= i) {
> > > >>>> +					found = true;
> > > >>>> +					break;
> > > >>>> +				}
> > > >>>> +			}
> > > >>>> +
> > > >>>> +			if (!found) {
> > > >>>> +				i += dma->size;
> > > >>>> +				continue;
> > > >>>> +			}
> > > >>>> +
> > > >>>> +			for (; n; n = rb_next(n)) {
> > > >>>> +				unsigned int start;
> > > >>>> +				struct vfio_pfn *vpfn = rb_entry(n,
> > > >>>> +							struct vfio_pfn, node);
> > > >>>> +
> > > >>>> +				if (vpfn->iova >= iova + size)
> > > >>>> +					return;
> > > >>>> +
> > > >>>> +				start = (vpfn->iova - start_iova) >> pgshift;
> > > >>>> +
> > > >>>> +				__bitmap_set(bitmap, start, 1);
> > > >>>> +
> > > >>>> +				i = vpfn->iova + pgsize;
> > > >>>> +			}
> > > >>>> +		}
> > > >>>> +		vfio_remove_unpinned_from_pfn_list(dma, false);
> > > >>>> +	}
> > > >>>> +}
> > > >>>> +
> > > >>>> +static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
> > > >>>> +{
> > > >>>> +	long bsize;
> > > >>>> +
> > > >>>> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
> > > >>>> +		return -EINVAL;
> > > >>>> +
> > > >>>> +	bsize = ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
> > > >>>> +
> > > >>>> +	if (bitmap_size < bsize)
> > > >>>> +		return -EINVAL;
> > > >>>> +
> > > >>>> +	return bsize;
> > > >>>> +}
> > > >>>> +
> > > >>>>    static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > > >>>>    			     struct vfio_iommu_type1_dma_unmap *unmap)
> > > >>>>    {
> > > >>>> @@ -2298,6 +2417,83 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> > > >>>>    
> > > >>>>    		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > > >>>>    			-EFAULT : 0;
> > > >>>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> > > >>>> +		struct vfio_iommu_type1_dirty_bitmap range;
> > > >>>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > > >>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > > >>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > > >>>> +		int ret;
> > > >>>> +
> > > >>>> +		if (!iommu->v2)
> > > >>>> +			return -EACCES;
> > > >>>> +
> > > >>>> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > > >>>> +				    bitmap);
> > > >>>> +
> > > >>>> +		if (copy_from_user(&range, (void __user *)arg, minsz))
> > > >>>> +			return -EFAULT;
> > > >>>> +
> > > >>>> +		if (range.argsz < minsz || range.flags & ~mask)
> > > >>>> +			return -EINVAL;
> > > >>>> +
> > > >>>> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > > >>>> +			iommu->dirty_page_tracking = true;
> > > >>>> +			return 0;
> > > >>>> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> > > >>>> +			iommu->dirty_page_tracking = false;
> > > >>>> +
> > > >>>> +			mutex_lock(&iommu->lock);
> > > >>>> +			vfio_remove_unpinned_from_dma_list(iommu);
> > > >>>> +			mutex_unlock(&iommu->lock);
> > > >>>> +			return 0;
> > > >>>> +
> > > >>>> +		} else if (range.flags &
> > > >>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > > >>>> +			uint64_t iommu_pgmask;
> > > >>>> +			unsigned long pgshift = __ffs(range.pgsize);
> > > >>>> +			unsigned long *bitmap;
> > > >>>> +			long bsize;
> > > >>>> +
> > > >>>> +			iommu_pgmask =
> > > >>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> > > >>>> +
> > > >>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> > > >>>> +			    (range.pgsize - 1))
> > > >>>> +				return -EINVAL;
> > > >>>> +
> > > >>>> +			if (range.iova & iommu_pgmask)
> > > >>>> +				return -EINVAL;
> > > >>>> +			if (!range.size || range.size > SIZE_MAX)
> > > >>>> +				return -EINVAL;
> > > >>>> +			if (range.iova + range.size < range.iova)
> > > >>>> +				return -EINVAL;
> > > >>>> +
> > > >>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
> > > >>>> +						   range.bitmap_size);
> > > >>>> +			if (bsize)
> > > >>>> +				return ret;
> > > >>>> +
> > > >>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);
> > > >>>> +			if (!bitmap)
> > > >>>> +				return -ENOMEM;
> > > >>>> +
> > > >>>> +			ret = copy_from_user(bitmap,
> > > >>>> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
> > > >>>> +			if (ret)
> > > >>>> +				goto bitmap_exit;
> > > >>>> +
> > > >>>> +			iommu->dirty_page_tracking = false;
> > > >>> why iommu->dirty_page_tracking is false here?
> > > >>> suppose this ioctl can be called several times.
> > > >>>
> > > >>
> > > >> This ioctl can be called several times, but once this ioctl is called
> > > >> that means vCPUs are stopped and VFIO devices are stopped (i.e. in
> > > >> stop-and-copy phase) and dirty pages bitmap are being queried by user.
> > > >>
> > > > can't agree that VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP can only be
> > > > called in stop-and-copy phase.
> > > > As stated in last version, this will cause QEMU to get a wrong expectation
> > > > of VM downtime and this is also the reason for previously pinned pages
> > > > before log_sync cannot be treated as dirty. If this get bitmap ioctl can
> > > > be called early in save_setup phase, then it's no problem even all ram
> > > > is dirty.
> > > > 
> > > 
> > > Device can also write to pages which are pinned, and then there is no 
> > > way to know pages dirtied by device during pre-copy phase.
> > > If user ask dirty bitmap in per-copy phase, even then user will have to 
> > > query dirty bitmap in stop-and-copy phase where this will be superset 
> > > including all pages reported during pre-copy. Then instead of copying 
> > > all pages twice, its better to do it once during stop-and-copy phase.
> > >
> > I think the flow should be like this:
> > 1. save_setup --> GET_BITMAP ioctl --> return bitmap for currently + previously
> > pinned pages and clean all previously pinned pages
> > 
> > 2. save_pending --> GET_BITMAP ioctl  --> return bitmap of (currently
> > pinned pages + previously pinned pages since last clean) and clean all
> > previously pinned pages
> > 
> > 3. save_complete_precopy --> GET_BITMAP ioctl --> return bitmap of (currently
> > pinned pages + previously pinned pages since last clean) and clean all
> > previously pinned pages
> > 
> > 
> > Copying pinned pages multiple times is unavoidable because those pinned pages
> > are always treated as dirty. That's per vendor's implementation.
> > But if the pinned pages are not reported as dirty before stop-and-copy phase,
> > QEMU would think dirty pages has converged
> > and enter blackout phase, making downtime_limit severely incorrect.
> 
> I'm not sure it's any worse.
> I *think* we do a last sync after we've decided to go to stop-and-copy;
> wont that then mark all those pages as dirty again, so it'll have the
> same behaviour?
No. something will be different.
currently, in kirti's implementation, if GET_BITMAP ioctl is called only
once in stop-and-copy phase, then before that phase, QEMU does not know those
pages are dirty. 
If we can report those dirty pages earlier before stop-and-copy phase,
QEMU can at least copy other pages to reduce dirty pages to below threshold.

Take a example, let's assume those vfio dirty pages is 1Gb, and network speed is
also 1Gb. Expected vm downtime is 1s.
If before stop-and-copy phase, dirty pages produced by other pages is
also 1Gb. To meet the expected vm downtime, QEMU should copy pages to
let dirty pages be less than 1Gb, otherwise, it should not complete live
migration.
If vfio does not report this 1Gb dirty pages, QEMU would think there's
only 1Gb and stop the vm. It would then find out there's actually 2Gb and vm
downtime is 2s.
Though the expected vm downtime is always not exactly the same as the
true vm downtime, it should be caused by rapid dirty page rate, which is
not predictable.
Right?

Thanks
Yan



> Anyway, it seems wrong to repeatedly send pages that you know are
> pointless - but that probably means we need a way to mark those somehow
> to avoid it.
> 
> Dave
> 
> > Thanks
> > Yan
> > 
> > > >>>> +			mutex_lock(&iommu->lock);
> > > >>>> +			vfio_iova_dirty_bitmap(iommu, range.iova, range.size,
> > > >>>> +					     range.pgsize, range.iova, bitmap);
> > > >>>> +			mutex_unlock(&iommu->lock);
> > > >>>> +
> > > >>>> +			ret = copy_to_user((void __user *)range.bitmap, bitmap,
> > > >>>> +					   range.bitmap_size) ? -EFAULT : 0;
> > > >>>> +bitmap_exit:
> > > >>>> +			kfree(bitmap);
> > > >>>> +			return ret;
> > > >>>> +		}
> > > >>>>    	}
> > > >>>>    
> > > >>>>    	return -ENOTTY;
> > > >>>> -- 
> > > >>>> 2.7.0
> > > >>>>
> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
