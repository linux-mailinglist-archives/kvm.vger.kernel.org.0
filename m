Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3815B48D
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 00:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgBLXNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 18:13:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44820 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729132AbgBLXNc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 18:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581549209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+d7zJwKj676J7JU8irRo6qMw99N4qRZBWEn8DYyfbhw=;
        b=ibk3lX0jl0yGMIFvun8uHVUbzVxaHLzNh0A3GBuEte4JreJvvJ+SdbwnT21eXlm2Ik9l4l
        nTGXqZ3jHrsamvXNG+6MOt8vnh9sumeLCIji6FH3JocAz5h+XrDSnXJ8TTO1PZYlaY7Lta
        VW+pSIEi9THGniri1wDi0HTtqyDV+xE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-jd0VX_ZDO5-P9jiR9lRePw-1; Wed, 12 Feb 2020 18:13:25 -0500
X-MC-Unique: jd0VX_ZDO5-P9jiR9lRePw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02C38DB21;
        Wed, 12 Feb 2020 23:13:23 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4941A5C1B0;
        Wed, 12 Feb 2020 23:13:21 +0000 (UTC)
Date:   Wed, 12 Feb 2020 16:13:20 -0700
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
Subject: Re: [PATCH v12 Kernel 4/7] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200212161320.02d8dfac@w520.home>
In-Reply-To: <7e7356c8-29ed-31fa-5c0b-2545ae69f321@nvidia.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
        <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
        <20200210102518.490a0d87@x1.home>
        <7e7356c8-29ed-31fa-5c0b-2545ae69f321@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Feb 2020 02:26:23 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 2/10/2020 10:55 PM, Alex Williamson wrote:
> > On Sat, 8 Feb 2020 01:12:31 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> >> - Start pinned and unpinned pages tracking while migration is active
> >> - Stop pinned and unpinned dirty pages tracking. This is also used to
> >>    stop dirty pages tracking if migration failed or cancelled.
> >> - Get dirty pages bitmap. This ioctl returns bitmap of dirty pages, its
> >>    user space application responsibility to copy content of dirty pages
> >>    from source to destination during migration.
> >>
> >> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> >> structure. Bitmap size is calculated considering smallest supported page
> >> size. Bitmap is allocated when dirty logging is enabled for those
> >> vfio_dmas whose vpfn list is not empty or whole range is mapped, in
> >> case of pass-through device.
> >>
> >> There could be multiple option as to when bitmap should be populated:
> >> * Polulate bitmap for already pinned pages when bitmap is allocated for
> >>    a vfio_dma with the smallest supported page size. Updates bitmap from
> >>    page pinning and unpinning functions. When user application queries
> >>    bitmap, check if requested page size is same as page size used to
> >>    populated bitmap. If it is equal, copy bitmap. But if not equal,
> >>    re-populated bitmap according to requested page size and then copy to
> >>    user.
> >>    Pros: Bitmap gets populated on the fly after dirty tracking has
> >>          started.
> >>    Cons: If requested page size is different than smallest supported
> >>          page size, then bitmap has to be re-populated again, with
> >>          additional overhead of allocating bitmap memory again for
> >>          re-population of bitmap.  
> > 
> > No memory needs to be allocated to re-populate the bitmap.  The bitmap
> > is clear-on-read and by tracking the bitmap in the smallest supported
> > page size we can guarantee that we can fit the user requested bitmap
> > size within the space occupied by that minimal page size range of the
> > bitmap.  Therefore we'd destructively translate the requested region of
> > the bitmap to a different page size, write it out to the user, and
> > clear it.  Also we expect userspace to use the minimum page size almost
> > exclusively, which is optimized by this approach as dirty bit tracking
> > is spread out over each page pinning operation.
> >   
> >>
> >> * Populate bitmap when bitmap is queried by user application.
> >>    Pros: Bitmap is populated with requested page size. This eliminates
> >>          the need to re-populate bitmap if requested page size is
> >>          different than smallest supported pages size.
> >>    Cons: There is one time processing time, when bitmap is queried.  
> > 
> > Another significant Con is that the vpfn list needs to track and manage
> > unpinned pages, which makes it more complex and intrusive.  The
> > previous option seems to have both time and complexity advantages,
> > especially in the case we expect to be most common of the user
> > accessing the bitmap with the minimum page size, ie. PAGE_SIZE.  It's
> > also not clear why we pre-allocate the bitmap at all with this approach.
> >   
> >> I prefer later option with simple logic and to eliminate over-head of
> >> bitmap repopulation in case of differnt page sizes. Later option is
> >> implemented in this patch.  
> > 
> > Hmm, we'll see below, but I not convinced based on the above rationale.
> >   
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 299 ++++++++++++++++++++++++++++++++++++++--
> >>   1 file changed, 287 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index d386461e5d11..df358dc1c85b 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -70,6 +70,7 @@ struct vfio_iommu {
> >>   	unsigned int		dma_avail;
> >>   	bool			v2;
> >>   	bool			nesting;
> >> +	bool			dirty_page_tracking;
> >>   };
> >>   
> >>   struct vfio_domain {
> >> @@ -90,6 +91,7 @@ struct vfio_dma {
> >>   	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
> >>   	struct task_struct	*task;
> >>   	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >> +	unsigned long		*bitmap;
> >>   };
> >>   
> >>   struct vfio_group {
> >> @@ -125,6 +127,7 @@ struct vfio_regions {
> >>   					(!list_empty(&iommu->domain_list))
> >>   
> >>   static int put_pfn(unsigned long pfn, int prot);
> >> +static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu);
> >>   
> >>   /*
> >>    * This code handles mapping and unmapping of user data buffers
> >> @@ -174,6 +177,57 @@ static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
> >>   	rb_erase(&old->node, &iommu->dma_list);
> >>   }
> >>   
> >> +static inline unsigned long dirty_bitmap_bytes(unsigned int npages)
> >> +{
> >> +	if (!npages)
> >> +		return 0;
> >> +
> >> +	return ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
> >> +}
> >> +
> >> +static int vfio_dma_bitmap_alloc(struct vfio_iommu *iommu,
> >> +				 struct vfio_dma *dma, unsigned long pgsizes)
> >> +{
> >> +	unsigned long pgshift = __ffs(pgsizes);
> >> +
> >> +	if (!RB_EMPTY_ROOT(&dma->pfn_list) || dma->iommu_mapped) {
> >> +		unsigned long npages = dma->size >> pgshift;
> >> +		unsigned long bsize = dirty_bitmap_bytes(npages);
> >> +
> >> +		dma->bitmap = kvzalloc(bsize, GFP_KERNEL);  
> > 
> > nit, we don't need to store bsize in a local variable.
> >   
> >> +		if (!dma->bitmap)
> >> +			return -ENOMEM;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static int vfio_dma_all_bitmap_alloc(struct vfio_iommu *iommu,
> >> +				     unsigned long pgsizes)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +	int ret;
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		ret = vfio_dma_bitmap_alloc(iommu, dma, pgsizes);
> >> +		if (ret)
> >> +			return ret;  
> > 
> > This doesn't unwind on failure, so we're left with partially allocated
> > bitmap cruft.
> >  
> 
> Good point. Adding unwind on failure.
> 
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static void vfio_dma_all_bitmap_free(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		kfree(dma->bitmap);  
> > 
> > We don't set dma->bitmap = NULL and we don't even prevent the case of a
> > user making multiple STOP calls, so we have a user triggerable double
> > free :(
> >   
> 
> Ok.
> 
> >> +	}
> >> +}
> >> +
> >>   /*
> >>    * Helper Functions for host iova-pfn list
> >>    */
> >> @@ -244,6 +298,29 @@ static void vfio_remove_from_pfn_list(struct vfio_dma *dma,
> >>   	kfree(vpfn);
> >>   }
> >>   
> >> +static void vfio_remove_unpinned_from_pfn_list(struct vfio_dma *dma)
> >> +{
> >> +	struct rb_node *n = rb_first(&dma->pfn_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn, node);
> >> +
> >> +		if (!vpfn->ref_count)
> >> +			vfio_remove_from_pfn_list(dma, vpfn);
> >> +	}
> >> +}
> >> +
> >> +static void vfio_remove_unpinned_from_dma_list(struct vfio_iommu *iommu)
> >> +{
> >> +	struct rb_node *n = rb_first(&iommu->dma_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >> +
> >> +		vfio_remove_unpinned_from_pfn_list(dma);
> >> +	}
> >> +}
> >> +
> >>   static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
> >>   					       unsigned long iova)
> >>   {
> >> @@ -261,7 +338,8 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
> >>   	vpfn->ref_count--;
> >>   	if (!vpfn->ref_count) {
> >>   		ret = put_pfn(vpfn->pfn, dma->prot);
> >> -		vfio_remove_from_pfn_list(dma, vpfn);
> >> +		if (!dma->bitmap)
> >> +			vfio_remove_from_pfn_list(dma, vpfn);
> >>   	}
> >>   	return ret;
> >>   }
> >> @@ -483,13 +561,14 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
> >>   	return ret;
> >>   }
> >>   
> >> -static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> >> +static int vfio_unpin_page_external(struct vfio_iommu *iommu,  
> > 
> > We added a parameter but didn't use it in this patch.
> >   
> 
> Ok, Moving it to relevant patch.
> 
> >> +				    struct vfio_dma *dma, dma_addr_t iova,
> >>   				    bool do_accounting)
> >>   {
> >>   	int unlocked;
> >>   	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
> >>   
> >> -	if (!vpfn)
> >> +	if (!vpfn || !vpfn->ref_count)
> >>   		return 0;
> >>   
> >>   	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
> >> @@ -510,6 +589,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   	unsigned long remote_vaddr;
> >>   	struct vfio_dma *dma;
> >>   	bool do_accounting;
> >> +	unsigned long iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> >>   
> >>   	if (!iommu || !user_pfn || !phys_pfn)
> >>   		return -EINVAL;
> >> @@ -551,8 +631,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   
> >>   		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
> >>   		if (vpfn) {
> >> -			phys_pfn[i] = vpfn->pfn;
> >> -			continue;
> >> +			if (vpfn->ref_count > 1) {
> >> +				phys_pfn[i] = vpfn->pfn;
> >> +				continue;
> >> +			}
> >>   		}
> >>   
> >>   		remote_vaddr = dma->vaddr + iova - dma->iova;
> >> @@ -560,11 +642,23 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   					     do_accounting);
> >>   		if (ret)
> >>   			goto pin_unwind;
> >> -
> >> -		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >> -		if (ret) {
> >> -			vfio_unpin_page_external(dma, iova, do_accounting);
> >> -			goto pin_unwind;
> >> +		if (!vpfn) {
> >> +			ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >> +			if (ret) {
> >> +				vfio_unpin_page_external(iommu, dma, iova,
> >> +							 do_accounting);
> >> +				goto pin_unwind;
> >> +			}
> >> +		} else
> >> +			vpfn->pfn = phys_pfn[i];
> >> +
> >> +		if (iommu->dirty_page_tracking && !dma->bitmap) {
> >> +			ret = vfio_dma_bitmap_alloc(iommu, dma, iommu_pgsizes);
> >> +			if (ret) {
> >> +				vfio_unpin_page_external(iommu, dma, iova,
> >> +							 do_accounting);
> >> +				goto pin_unwind;
> >> +			}
> >>   		}
> >>   	}
> >>   
> >> @@ -578,7 +672,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   
> >>   		iova = user_pfn[j] << PAGE_SHIFT;
> >>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> >> -		vfio_unpin_page_external(dma, iova, do_accounting);
> >> +		vfio_unpin_page_external(iommu, dma, iova, do_accounting);
> >>   		phys_pfn[j] = 0;
> >>   	}
> >>   pin_done:
> >> @@ -612,7 +706,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
> >>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> >>   		if (!dma)
> >>   			goto unpin_exit;
> >> -		vfio_unpin_page_external(dma, iova, do_accounting);
> >> +		vfio_unpin_page_external(iommu, dma, iova, do_accounting);
> >>   	}
> >>   
> >>   unpin_exit:
> >> @@ -830,6 +924,113 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >>   	return bitmap;
> >>   }
> >>   
> >> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >> +				  size_t size, uint64_t pgsize,
> >> +				  unsigned char __user *bitmap)
> >> +{
> >> +	struct vfio_dma *dma;
> >> +	dma_addr_t i = iova, iova_limit;
> >> +	unsigned int bsize, nbits = 0, l = 0;
> >> +	unsigned long pgshift = __ffs(pgsize);
> >> +
> >> +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
> >> +		int ret, j;
> >> +		unsigned int npages = 0, shift = 0;
> >> +		unsigned char temp = 0;
> >> +
> >> +		/* mark all pages dirty if all pages are pinned and mapped. */
> >> +		if (dma->iommu_mapped) {
> >> +			iova_limit = min(dma->iova + dma->size, iova + size);
> >> +			npages = iova_limit/pgsize;
> >> +			bitmap_set(dma->bitmap, 0, npages);  
> > 
> > npages is derived from iova_limit, which is the number of bits to set
> > dirty relative to the first requested iova, not iova zero, ie. the set
> > of dirty bits is offset from those requested unless iova == dma->iova.
> >   
> 
> Right, fixing.
> 
> > Also I hope dma->bitmap was actually allocated.  Not only does the
> > START error path potentially leave dirty tracking enabled without all
> > the bitmap allocated, when does the bitmap get allocated for a new
> > vfio_dma when dirty tracking is enabled?  Seems it only occurs if a
> > vpfn gets marked dirty.
> >   
> 
> Right.
> 
> Fixing error paths.
> 
> 
> >> +		} else if (dma->bitmap) {
> >> +			struct rb_node *n = rb_first(&dma->pfn_list);
> >> +			bool found = false;
> >> +
> >> +			for (; n; n = rb_next(n)) {
> >> +				struct vfio_pfn *vpfn = rb_entry(n,
> >> +						struct vfio_pfn, node);
> >> +				if (vpfn->iova >= i) {
> >> +					found = true;
> >> +					break;
> >> +				}
> >> +			}
> >> +
> >> +			if (!found) {
> >> +				i += dma->size;
> >> +				continue;
> >> +			}
> >> +
> >> +			for (; n; n = rb_next(n)) {
> >> +				unsigned int s;
> >> +				struct vfio_pfn *vpfn = rb_entry(n,
> >> +						struct vfio_pfn, node);
> >> +
> >> +				if (vpfn->iova >= iova + size)
> >> +					break;
> >> +
> >> +				s = (vpfn->iova - dma->iova) >> pgshift;
> >> +				bitmap_set(dma->bitmap, s, 1);
> >> +
> >> +				iova_limit = vpfn->iova + pgsize;
> >> +			}
> >> +			npages = iova_limit/pgsize;  
> > 
> > Isn't iova_limit potentially uninitialized here?  For example, if our
> > vfio_dma covers {0,8192} and we ask for the bitmap of {0,4096} and
> > there's a vpfn at {4096,8192}.  I think that means vpfn->iova >= i
> > (4096 >= 0), so we break with found = true, then we test 4096 >= 0 +
> > 4096 and break, and npages = ????/pgsize.
> >   
> 
> Right, Fixing it.
> 
> >> +		}
> >> +
> >> +		bsize = dirty_bitmap_bytes(npages);
> >> +		shift = nbits % BITS_PER_BYTE;
> >> +
> >> +		if (npages && shift) {
> >> +			l--;
> >> +			if (!access_ok((void __user *)bitmap + l,
> >> +					sizeof(unsigned char)))
> >> +				return -EINVAL;
> >> +
> >> +			ret = __get_user(temp, bitmap + l);  
> > 
> > I don't understand why we care to get the user's bitmap, are we trying
> > to leave whatever garbage they might have set in it and only also set
> > the dirty bits?  That seems unnecessary.
> >   
> 
> Suppose dma mapped ranges are {start, size}:
> {0, 0xa000}, {0xa000, 0x10000}
> 
> Bitmap asked from 0 - 0x10000. Say suppose all pages are dirty.
> Then in first iteration for dma {0,0xa000} there are 10 pages, so 10 
> bits are set, put_user() happens for 2 bytes, (00000011 11111111b).
> In second iteration for dma {0xa000, 0x10000} there are 6 pages and 
> these bits should be appended to previous byte. So get_user() that byte, 
> then shift-OR rest of the bitmap, result should be: (11111111 11111111b)
> 
> Without get_user() and shift-OR, resulting bitmap would be
> 111111 00000011 11111111b which would be wrong.

Seems like if we use a put_user() approach then we should look for
adjacent vfio_dmas within the same byte/word/dword before we push it to
the user to avoid this sort of inefficiency.

> > Also why do we need these access_ok() checks when we already checked
> > the range at the start of the ioctl?  
> 
> Since pointer is updated runtime here, better to check that pointer 
> before using that pointer.

Sorry, I still don't understand this, we check access_ok() with a
pointer and a length, therefore as long as we're incrementing the
pointer within that length, why do we need to retest?

> >   
> >> +			if (ret)
> >> +				return ret;
> >> +		}
> >> +
> >> +		for (j = 0; j < bsize; j++, l++) {
> >> +			temp = temp |
> >> +			       (*((unsigned char *)dma->bitmap + j) << shift);  
> > 
> > |=
> >   
> >> +			if (!access_ok((void __user *)bitmap + l,
> >> +					sizeof(unsigned char)))
> >> +				return -EINVAL;
> >> +
> >> +			ret = __put_user(temp, bitmap + l);
> >> +			if (ret)
> >> +				return ret;
> >> +			if (shift) {
> >> +				temp = *((unsigned char *)dma->bitmap + j) >>
> >> +					(BITS_PER_BYTE - shift);
> >> +			}  
> > 
> > When shift == 0, temp just seems to accumulate bits that never get
> > cleared.
> >   
> 
> Hope example above explains the shift logic.

But that example is when shift is non-zero.  When shift is zero, each
iteration of the loop just ORs in new bits to temp without ever
clearing the bits for the previous iteration.


> >> +		}
> >> +
> >> +		nbits += npages;
> >> +
> >> +		i = min(dma->iova + dma->size, iova + size);
> >> +		if (i >= iova + size)
> >> +			break;  
> > 
> > So whether we error or succeed, we leave cruft in dma->bitmap for the
> > next pass.  It doesn't seem to make any sense why we pre-allocated the
> > bitmap, we might as well just allocate it on demand here.  Actually, if
> > we're not going to do a copy_to_user() for some range of the bitmap,
> > I'm not sure what it's purpose is at all.  I think the big advantages
> > of the bitmap are that we can't amortize the cost across every pinned
> > page or DMA mapping, we don't need the overhead of tracking unmapped
> > vpfns, and we can use copy_to_user() to push the bitmap out.  We're not
> > getting any of those advantages here.
> >   
> 
> That would still not work if dma range size is not multiples of 8 pages. 
> See example above.

I don't understand this comment, what about the example above justifies
the bitmap?  As I understand the above algorithm, we find a vfio_dma
overlapping the request and populate the bitmap for that range.  Then
we go back and put_user() for each byte that we touched.  We could
instead simply work on a one byte buffer as we enumerate the requested
range and do a put_user() ever time we reach the end of it and have bits
set.  That would greatly simplify the above example.  But I would expect
that we're a) more likely to get asked for ranges covering a single
vfio_dma and b) we're going to spend far more time operating in the
middle of the range and limiting ourselves to one-byte operations there
seems absurd.  If we want to specify that the user provides 4-byte
aligned buffers and naturally aligned iova ranges to make our lives
easier in the kernel, now would be the time to do that.

> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
> >> +{
> >> +	long bsize;
> >> +
> >> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
> >> +		return -EINVAL;
> >> +
> >> +	bsize = dirty_bitmap_bytes(npages);
> >> +
> >> +	if (bitmap_size < bsize)
> >> +		return -EINVAL;
> >> +
> >> +	return bsize;
> >> +}  
> > 
> > Seems like this could simply return int, -errno or zero for success.
> > The returned bsize is not used for anything else.
> >   
> 
> ok.
> 
> >> +
> >>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   			     struct vfio_iommu_type1_dma_unmap *unmap)
> >>   {
> >> @@ -2277,6 +2478,80 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
> >>   
> >>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> >>   			-EFAULT : 0;
> >> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> >> +		struct vfio_iommu_type1_dirty_bitmap range;
> >> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> >> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> >> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> >> +		int ret;
> >> +
> >> +		if (!iommu->v2)
> >> +			return -EACCES;
> >> +
> >> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> >> +				    bitmap);  
> > 
> > We require the user to provide iova, size, pgsize, bitmap_size, and
> > bitmap fields to START/STOP?  Why?
> >  
> 
> No. But those are part of structure.

But we do require it, minsz here includes all those fields, which would
probably make a user scratch their head wondering why they need to pass
irrelevant data for START/STOP.  It almost implies that we support
starting and stopping dirty logging for specific ranges of the IOVA
space.  We could define the structure, for example:

struct vfio_iommu_type1_dirty_bitmap {
	__u32	argsz;
	__u32	flags;
	__u8	data[];
};

struct vfio_iommu_type1_dirty_bitmap_get {
	__u64	iova;
	__u64	size;
	__u64	pgsize;
	__u64	bitmap_size;
	void __user *bitmap;
};

Where data[] is defined as the latter structure when FLAG_GET_BITMAP is
specified.  BTW, don't we need to specify the trailing void* as __u64?
We could theoretically be talking to an ILP32 user process.  Thanks,

Alex

> >> +
> >> +		if (copy_from_user(&range, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (range.argsz < minsz || range.flags & ~mask)
> >> +			return -EINVAL;
> >> +
> >> +		/* only one flag should be set at a time */
> >> +		if (__ffs(range.flags) != __fls(range.flags))
> >> +			return -EINVAL;
> >> +
> >> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> >> +			unsigned long iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> >> +
> >> +			mutex_lock(&iommu->lock);
> >> +			iommu->dirty_page_tracking = true;
> >> +			ret = vfio_dma_all_bitmap_alloc(iommu, iommu_pgsizes);  
> > 
> > So dirty page tracking is enabled even if we fail to allocate all the
> > bitmaps?  Shouldn't this return an error if dirty tracking is already
> > enabled?
> >   
> 
> Adding error handling here in next patch.
> 
> >> +			mutex_unlock(&iommu->lock);
> >> +			return ret;
> >> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> >> +			mutex_lock(&iommu->lock);
> >> +			iommu->dirty_page_tracking = false;  
> > 
> > Shouldn't we only allow STOP if tracking is enabled?
> >   
> 
> Right,adding.
> 
> >> +			vfio_dma_all_bitmap_free(iommu);  
> > 
> > Here's where that user induced double free enters the picture.
> >   
> 
> Error handling as mentioned above will prevent double free.
> 
> Thanks,
> Kirti
> 
> >> +			vfio_remove_unpinned_from_dma_list(iommu);
> >> +			mutex_unlock(&iommu->lock);
> >> +			return 0;
> >> +		} else if (range.flags &
> >> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >> +			long bsize;
> >> +			unsigned long pgshift = __ffs(range.pgsize);
> >> +			uint64_t iommu_pgsizes = vfio_pgsize_bitmap(iommu);
> >> +			uint64_t iommu_pgmask =
> >> +				 ((uint64_t)1 << __ffs(iommu_pgsizes)) - 1;
> >> +
> >> +			if ((range.pgsize & iommu_pgsizes) != range.pgsize)
> >> +				return -EINVAL;
> >> +			if (range.iova & iommu_pgmask)
> >> +				return -EINVAL;
> >> +			if (!range.size || range.size & iommu_pgmask)
> >> +				return -EINVAL;
> >> +			if (range.iova + range.size < range.iova)
> >> +				return -EINVAL;
> >> +			if (!access_ok((void __user *)range.bitmap,
> >> +				       range.bitmap_size))
> >> +				return -EINVAL;
> >> +
> >> +			bsize = verify_bitmap_size(range.size >> pgshift,
> >> +						   range.bitmap_size);
> >> +			if (bsize < 0)
> >> +				return bsize;
> >> +
> >> +			mutex_lock(&iommu->lock);
> >> +			if (iommu->dirty_page_tracking)
> >> +				ret = vfio_iova_dirty_bitmap(iommu, range.iova,
> >> +					 range.size, range.pgsize,
> >> +					 (unsigned char __user *)range.bitmap);
> >> +			else
> >> +				ret = -EINVAL;
> >> +			mutex_unlock(&iommu->lock);
> >> +
> >> +			return ret;
> >> +		}
> >>   	}
> >>   
> >>   	return -ENOTTY;  
> > 
> > Thanks,
> > Alex
> >   
> 

