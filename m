Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C79197252
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 04:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgC3CQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 22:16:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:22200 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgC3CQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 22:16:50 -0400
IronPort-SDR: KGxVcThqrs8wTi0ZW4fstAzECDobKp20UutwXYkzT8wyty3FdoEXw8s/IyiJOaqk0W+apdJlv9
 TFArr5AyfaJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2020 19:16:46 -0700
IronPort-SDR: AkhDqn+8R+cblbyquh1jjIrndOcmtpTdpcPFnrlyhOFUEALzOoEuwM5ETVgQfglFRdTtgPNXo6
 IrmtRDazhG2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,322,1580803200"; 
   d="scan'208";a="421778052"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 29 Mar 2020 19:16:41 -0700
Date:   Sun, 29 Mar 2020 22:07:08 -0400
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
Subject: Re: [PATCH v16 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200330020708.GB30683@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1585084732-18473-1-git-send-email-kwankhede@nvidia.com>
 <20200325021135.GB20109@joy-OptiPlex-7040>
 <33d38629-aeaf-1c30-26d4-958b998620b0@nvidia.com>
 <20200327003055.GB26419@joy-OptiPlex-7040>
 <0fdf19d4-a45b-d0b1-b630-1ee9df087c15@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fdf19d4-a45b-d0b1-b630-1ee9df087c15@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 27, 2020 at 01:07:38PM +0800, Kirti Wankhede wrote:
> 
> 
> On 3/27/2020 6:00 AM, Yan Zhao wrote:
> > On Fri, Mar 27, 2020 at 05:39:01AM +0800, Kirti Wankhede wrote:
> >>
> >>
> >> On 3/25/2020 7:41 AM, Yan Zhao wrote:
> >>> On Wed, Mar 25, 2020 at 05:18:52AM +0800, Kirti Wankhede wrote:
> >>>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> >>>> - Start dirty pages tracking while migration is active
> >>>> - Stop dirty pages tracking.
> >>>> - Get dirty pages bitmap. Its user space application's responsibility to
> >>>>     copy content of dirty pages from source to destination during migration.
> >>>>
> >>>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> >>>> structure. Bitmap size is calculated considering smallest supported page
> >>>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
> >>>>
> >>>> Bitmap is populated for already pinned pages when bitmap is allocated for
> >>>> a vfio_dma with the smallest supported page size. Update bitmap from
> >>>> pinning functions when tracking is enabled. When user application queries
> >>>> bitmap, check if requested page size is same as page size used to
> >>>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
> >>>> error.
> >>>>
> >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>>> ---
> >>>>    drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
> >>>>    1 file changed, 260 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>>> index 70aeab921d0f..874a1a7ae925 100644
> >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>> @@ -71,6 +71,7 @@ struct vfio_iommu {
> >>>>    	unsigned int		dma_avail;
> >>>>    	bool			v2;
> >>>>    	bool			nesting;
> >>>> +	bool			dirty_page_tracking;
> >>>>    };
> >>>>    
> >>>>    struct vfio_domain {
> >>>> @@ -91,6 +92,7 @@ struct vfio_dma {
> >>>>    	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >>>>    	struct task_struct	*task;
> >>>>    	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>>> +	unsigned long		*bitmap;
> >>>>    };
> >>>>    
> >>>>    struct vfio_group {
> >>>> @@ -125,7 +127,21 @@ struct vfio_regions {
> >>>>    #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >>>>    					(!list_empty(&iommu->domain_list))
> >>>>    
> >>>> +#define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
> >>>> +
> >>>> +/*
> >>>> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> >>>> + * further casts to signed integer for unaligned multi-bit operation,
> >>>> + * __bitmap_set().
> >>>> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> >>>> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> >>>> + * system.
> >>>> + */
> >>>> +#define DIRTY_BITMAP_PAGES_MAX	(uint64_t)(INT_MAX - 1)
> >>>> +#define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> >>>> +
> >>>>    static int put_pfn(unsigned long pfn, int prot);
> >>>> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >>>>    
> >>>>    /*
> >>>>     * This code handles mapping and unmapping of user data buffers
> >>>> @@ -175,6 +191,77 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >>>>    	rb_erase(&old->node, &iommu->dma_list);
> >>>>    }
> >>>>    
> >>>> +
> >>>> +static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, uint64_t pgsize)
> >>>> +{
> >>>> +	uint64_t npages = dma->size / pgsize;
> >>>> +
> >>>> +	if (npages > DIRTY_BITMAP_PAGES_MAX)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	dma->bitmap = kvzalloc(DIRTY_BITMAP_BYTES(npages), GFP_KERNEL);
> >>>> +	if (!dma->bitmap)
> >>>> +		return -ENOMEM;
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static void vfio_dma_bitmap_free(struct vfio_dma *dma)
> >>>> +{
> >>>> +	kfree(dma->bitmap);
> >>>> +	dma->bitmap = NULL;
> >>>> +}
> >>>> +
> >>>> +static void vfio_dma_populate_bitmap(struct vfio_dma *dma, uint64_t pgsize)
> >>>> +{
> >>>> +	struct rb_node *p;
> >>>> +
> >>>> +	if (RB_EMPTY_ROOT(&dma->pfn_list))
> >>>> +		return;
> >>>> +
> >>>> +	for (p = rb_first(&dma->pfn_list); p; p = rb_next(p)) {
> >>>> +		struct vfio_pfn *vpfn = rb_entry(p, struct vfio_pfn, node);
> >>>> +
> >>>> +		bitmap_set(dma->bitmap, (vpfn->iova - dma->iova) / pgsize, 1);
> >>>> +	}
> >>>> +}
> >>>> +
> >>>> +static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, uint64_t pgsize)
> >>>> +{
> >>>> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >>>> +
> >>>> +	for (; n; n = rb_next(n)) {
> >>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >>>> +		int ret;
> >>>> +
> >>>> +		ret = vfio_dma_bitmap_alloc(dma, pgsize);
> >>>> +		if (ret) {
> >>>> +			struct rb_node *p = rb_prev(n);
> >>>> +
> >>>> +			for (; p; p = rb_prev(p)) {
> >>>> +				struct vfio_dma *dma = rb_entry(n,
> >>>> +							struct vfio_dma, node);
> >>>> +
> >>>> +				vfio_dma_bitmap_free(dma);
> >>>> +			}
> >>>> +			return ret;
> >>>> +		}
> >>>> +		vfio_dma_populate_bitmap(dma, pgsize);
> >>>> +	}
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >>>> +{
> >>>> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >>>> +
> >>>> +	for (; n; n = rb_next(n)) {
> >>>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >>>> +
> >>>> +		vfio_dma_bitmap_free(dma);
> >>>> +	}
> >>>> +}
> >>>> +
> >>>>    /*
> >>>>     * Helper Functions for host iova-pfn list
> >>>>     */
> >>>> @@ -567,6 +654,18 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>>>    			vfio_unpin_page_external(dma, iova, do_accounting);
> >>>>    			goto pin_unwind;
> >>>>    		}
> >>>> +
> >>>> +		if (iommu->dirty_page_tracking) {
> >>>> +			unsigned long pgshift =
> >>>> +					 __ffs(vfio_pgsize_bitmap(iommu));
> >>>> +
> >>>> +			/*
> >>>> +			 * Bitmap populated with the smallest supported page
> >>>> +			 * size
> >>>> +			 */
> >>>> +			bitmap_set(dma->bitmap,
> >>>> +				   (vpfn->iova - dma->iova) >> pgshift, 1);
> >>>> +		}
> >>>>    	}
> >>>>    
> >>>>    	ret = i;
> >>>> @@ -801,6 +900,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >>>>    	vfio_unmap_unpin(iommu, dma, true);
> >>>>    	vfio_unlink_dma(iommu, dma);
> >>>>    	put_task_struct(dma->task);
> >>>> +	vfio_dma_bitmap_free(dma);
> >>>>    	kfree(dma);
> >>>>    	iommu->dma_avail++;
> >>>>    }
> >>>> @@ -831,6 +931,57 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >>>>    	return bitmap;
> >>>>    }
> >>>>    
> >>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >>>> +				  size_t size, uint64_t pgsize,
> >>>> +				  u64 __user *bitmap)
> >>>> +{
> >>>> +	struct vfio_dma *dma;
> >>>> +	unsigned long pgshift = __ffs(pgsize);
> >>>> +	unsigned int npages, bitmap_size;
> >>>> +
> >>>> +	dma = vfio_find_dma(iommu, iova, 1);
> >>>> +
> >>>> +	if (!dma)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	if (dma->iova != iova || dma->size != size)
> >>>> +		return -EINVAL;
> >>>> +
> >>> Still don't sure if it's a good practice.
> >>> I saw the qemu implementation.
> >>> Qemu just iterates the whole IOVA address space,
> >>> It needs to find IOTLB entry for an IOVA
> >>> (1) if it can find an IOTLB for an IOVA, do the DIRTY_PAGES IOCTL and
> >>> increment IOVA by (iotlb.addr_mask + 1)
> >>>
> >>> (2) if no existing IOTLB found, the imrc->translate needs to go searching shadow
> >>> page table to try to generate one.
> >>> if it still fails,(most probably case, as IOMMU only maps a small part in its address
> >>> space).  increment IOVA by 1 page.
> >>>
> >>> So, if the address space width is 39bit, and if there's only one page
> >>> mapped, you still have to translate IOVA for around 2^27 times in each
> >>> query. Isn't it too inefficient?
> >>>
> >>
> >> This is Qemu side implementation, let discuss it on QEMU patches.
> >>
> > But kernel has to support it first, right?
> > 
> 
> Shadow page table will be in QEMU (?), as long as we support map and 
Yes, shadow page table in QEMU.

> unmap in kernel space, QEMU part of changes should work. That shouldn't 
> block kernel side patches.
Not sure whether this assertion is right:)
I just want to raise the issue out.

> 
> >>> So, IMHO, why we could not just save an rb tree specific for dirty pages, then generate
> >>> a bitmap for each query?
> >>
> >> This is looping back to implentation in v10 - v12 version. There are
> >> problems discussed during v10 to v12 version of patches with this approach.
> >> - populating dirty bitmap at the time of query will add more CPU cycles.
> >> - If we save these CPU cyles means dirty pages need to be tracked when
> >> they are pinned or dirtied by CPU, that is, inttoduced per vfio_dma
> >> bitmap. If ranges are not vfio_dma aligned, then copying bitmap to user
> >> space becomes complicated and unefficient.
> >>
> >> So we decided to go with the approach implemented here.
> > 
> > I checked v12, it's not like what I said.
> > In v12, bitmaps are generated per vfio_dma, and combination of the
> > bitmaps are required in order to generate a big bitmap suiting for dirty
> > query. It can cause problem when offset not aligning.
> > But what I propose here is to generate an rb tree orthogonal to the tree
> > of vfio_dma.
> > 
> > as to CPU cycles saving, I don't think iterating/translating page by page
> > would achieve that purpose.
> > 
> > 
> 
> 
> 
> > 
> >>>
> >>>> +	npages = dma->size >> pgshift;
> >>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> >>>> +
> >>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
> >>>> +	if (dma->iommu_mapped)
> >>>> +		bitmap_set(dma->bitmap, 0, npages);
> >>>> +
> >>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> >>>> +		return -EFAULT;
> >>>> +
> >>>> +	/*
> >>>> +	 * Re-populate bitmap to include all pinned pages which are considered
> >>>> +	 * as dirty but exclude pages which are unpinned and pages which are
> >>>> +	 * marked dirty by vfio_dma_rw()
> >>>> +	 */
> >>>> +	bitmap_clear(dma->bitmap, 0, npages);
> >>>> +	vfio_dma_populate_bitmap(dma, pgsize);
> >>> will this also repopulate bitmap for pinned pages set by pass-through devices in
> >>> patch 07 ?
> >>>
> >>
> >> If pass through device's driver pins pages using vfio_pin_pages and all
> >> devices in the group pins pages through vfio_pin_pages, then
> >> iommu->pinned_page_dirty_scope is set true, then bitmap is repolutated.
> >>
> >>
> > pass-through devices already have all guest memory pinned, it would have
> > no reason to call vfio_pin_pages if not attempting to mark page dirty.
> > Then if it calls vfio_pin_pages, it means "the pages are accessed, please
> > mark them dirty, feel free to clean it when you get it",
> 
> if you see vfio_dma_populate_bitmap() function, then if vfio_pin_pages 
> is called, dma->pfn_list rb_tree will be non-empty and bitmap gets 
> populates as per pinned pages.
> 
> > not "the pages will be accesses, please mark them dirty continuously"
> >
> 
> if vfio_pin_pages is not called, dma->pfn_list is empty, then it returns 
> early.
> If suppose there are 2 deviced in the group, one is IOMMU backed device 
> and other non-IOMMU mdev device. In that case, all pages are pinned, 
> iommu->pinned_page_dirty_scope is false, but dma->pfn_list is also not 
> empty since non-IOMMU backed device pins pages using external API. We 
> still have to populate bitmap according to dma->pfn_list here, because 
> in prec-copy phase on first bitmap query, IOMMU backed device might pin 
> pages using external API - with that iommu->pinned_page_dirty_scope will 
> get updated to 'true', which means during next iteration report pinned 
> pages by external API only.
>
ok, I previously thought vfio_pin_pages for IOMMU backed device is to set
dirty pages after it has write access to them. Looks your intention here
is presume pinned pages are dirty so you have to re-fill them until they
are unpinned.
Maybe you can leave it as is, and we can add mark dirty interface later for
the purpose I said above (mark dirty after write access).

Thanks
Yan
