Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBAC133568
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 23:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgAGWCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 17:02:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726142AbgAGWCf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jan 2020 17:02:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578434553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuzVS9rDDrkbcTytEEBvEkwtP+rm/Mdv1JDaC/FVCPE=;
        b=Wz0xB45eP3n67h8LOeLU0aEbq3UOmBRUE5aPqRNKbk42nKzUq5zCmZHxlG2aaatDe81HOz
        dL37j9DltmSnTCjLxrI1HJWauzpx8RLnztAI5mjOwSdUEdG2bvuHY6yaLzi49C/NUh7zIa
        oh5v5OhTD8DL3bWpicKHCC4avr6DNwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-4AsGpxdQOn2ykmucS3O37g-1; Tue, 07 Jan 2020 17:02:29 -0500
X-MC-Unique: 4AsGpxdQOn2ykmucS3O37g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5986D800D4C;
        Tue,  7 Jan 2020 22:02:27 +0000 (UTC)
Received: from w520.home (ovpn-116-26.phx2.redhat.com [10.3.116.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2B025C1BB;
        Tue,  7 Jan 2020 22:02:24 +0000 (UTC)
Date:   Tue, 7 Jan 2020 15:02:23 -0700
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
Subject: Re: [PATCH v11 Kernel 3/6] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200107150223.0dab0a85@w520.home>
In-Reply-To: <ebd08133-e258-9f5e-5c8f-f88d7165cd7a@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
        <1576602651-15430-4-git-send-email-kwankhede@nvidia.com>
        <20191217151203.342b686a@x1.home>
        <ebd08133-e258-9f5e-5c8f-f88d7165cd7a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 01:37:03 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 12/18/2019 3:42 AM, Alex Williamson wrote:
> > On Tue, 17 Dec 2019 22:40:48 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> >> - Start unpinned pages dirty pages tracking while migration is active and
> >>    device is running, i.e. during pre-copy phase.
> >> - Stop unpinned pages dirty pages tracking. This is required to stop
> >>    unpinned dirty pages tracking if migration failed or cancelled during
> >>    pre-copy phase. Unpinned pages tracking is clear.
> >> - Get dirty pages bitmap. Stop unpinned dirty pages tracking and clear
> >>    unpinned pages information on bitmap read. This ioctl returns bitmap of
> >>    dirty pages, its user space application responsibility to copy content
> >>    of dirty pages from source to destination during migration.
> >>
> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 218 ++++++++++++++++++++++++++++++++++++++--
> >>   1 file changed, 209 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 2ada8e6cdb88..215aecb25453 100644
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
> >> @@ -112,6 +113,7 @@ struct vfio_pfn {
> >>   	dma_addr_t		iova;		/* Device address */
> >>   	unsigned long		pfn;		/* Host pfn */
> >>   	atomic_t		ref_count;
> >> +	bool			unpinned;  
> > 
> > Doesn't this duplicate ref_count == 0?
> >   
> 
> Yes, actually. Removing unpinned.
> 
> >>   };
> >>   
> >>   struct vfio_regions {
> >> @@ -244,6 +246,32 @@ static void vfio_remove_from_pfn_list(struct vfio_dma *dma,
> >>   	kfree(vpfn);
> >>   }
> >>   
> >> +static void vfio_remove_unpinned_from_pfn_list(struct vfio_dma *dma, bool warn)
> >> +{
> >> +	struct rb_node *n = rb_first(&dma->pfn_list);
> >> +
> >> +	for (; n; n = rb_next(n)) {
> >> +		struct vfio_pfn *vpfn = rb_entry(n, struct vfio_pfn, node);
> >> +
> >> +		if (warn)
> >> +			WARN_ON_ONCE(vpfn->unpinned);  
> > 
> > This option isn't used within this patch, perhaps better to add with
> > its use case, but it seems this presents both a denial of service via
> > kernel tainting and an undocumented feature/bug.  As I interpret its
> > use within the next patch, this generates a warning if the user
> > unmapped the IOVA with dirty pages present, without using the dirty
> > bitmap extension of the unmap call.  Our job is not to babysit the
> > user, if they don't care to look at the dirty bitmap, that's their
> > prerogative.  Drop this warning and the function arg.
> >   
> 
> I was trying to extra cautious. Dropping this warning.
> 
> >> +
> >> +		if (vpfn->unpinned)  
> > 
> > if (!atomic_read(&vpfn->ref_count))
> >   
> 
> Ok.
> 
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
> >> +		vfio_remove_unpinned_from_pfn_list(dma, false);
> >> +	}
> >> +}
> >> +
> >>   static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
> >>   					       unsigned long iova)
> >>   {
> >> @@ -254,13 +282,17 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
> >>   	return vpfn;
> >>   }
> >>   
> >> -static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
> >> +static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn,
> >> +				  bool dirty_tracking)
> >>   {
> >>   	int ret = 0;
> >>   
> >>   	if (atomic_dec_and_test(&vpfn->ref_count)) {
> >>   		ret = put_pfn(vpfn->pfn, dma->prot);
> >> -		vfio_remove_from_pfn_list(dma, vpfn);
> >> +		if (dirty_tracking)
> >> +			vpfn->unpinned = true;
> >> +		else
> >> +			vfio_remove_from_pfn_list(dma, vpfn);  
> > 
> > This can also simply use ref_count.  BTW, checking the locking, I think  
> > ->ref_count is only manipulated under iommu->lock, therefore the atomic  
> > ops are probably overkill.
> >   
> 
> Yes, I'll create a seperate commit to remove atomic.
> 
> >>   	}
> >>   	return ret;
> >>   }
> >> @@ -504,7 +536,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
> >>   }
> >>   
> >>   static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> >> -				    bool do_accounting)
> >> +				    bool do_accounting, bool dirty_tracking)
> >>   {
> >>   	int unlocked;
> >>   	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
> >> @@ -512,7 +544,10 @@ static int vfio_unpin_page_external(struct vfio_dma *dma, dma_addr_t iova,
> >>   	if (!vpfn)
> >>   		return 0;
> >>   
> >> -	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn);
> >> +	if (vpfn->unpinned)
> >> +		return 0;  
> > 
> > Combine with above, if (!vpfn || !vpfn->ref_count)
> >   
> 
> Yes.
> 
> >> +
> >> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, dirty_tracking);
> >>   
> >>   	if (do_accounting)
> >>   		vfio_lock_acct(dma, -unlocked, true);
> >> @@ -571,8 +606,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   
> >>   		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
> >>   		if (vpfn) {
> >> -			phys_pfn[i] = vpfn->pfn;
> >> -			continue;
> >> +			if (vpfn->unpinned)
> >> +				vfio_remove_from_pfn_list(dma, vpfn);  
> > 
> > This seems inefficient, we have an allocated vpfn at the right places
> > in the list, wouldn't it be better to repin the page?
> >   
> 
> vfio_pin_page_external() takes care of pinning and accounting as well.

Yes, but could we call vfio_pin_page_external() without {unlinking,
freeing} and {re-allocating, linking} on either side of it since it's
already in the list?  That's the inefficient part.  Maybe at least a
TODO comment?

> >> +			else {
> >> +				phys_pfn[i] = vpfn->pfn;
> >> +				continue;
> >> +			}
> >>   		}
> >>   
> >>   		remote_vaddr = dma->vaddr + iova - dma->iova;
> >> @@ -583,7 +622,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   
> >>   		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >>   		if (ret) {
> >> -			vfio_unpin_page_external(dma, iova, do_accounting);
> >> +			vfio_unpin_page_external(dma, iova, do_accounting,
> >> +						 false);
> >>   			goto pin_unwind;
> >>   		}
> >>   	}
> >> @@ -598,7 +638,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>   
> >>   		iova = user_pfn[j] << PAGE_SHIFT;
> >>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> >> -		vfio_unpin_page_external(dma, iova, do_accounting);
> >> +		vfio_unpin_page_external(dma, iova, do_accounting, false);
> >>   		phys_pfn[j] = 0;
> >>   	}
> >>   pin_done:
> >> @@ -632,7 +672,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
> >>   		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
> >>   		if (!dma)
> >>   			goto unpin_exit;
> >> -		vfio_unpin_page_external(dma, iova, do_accounting);
> >> +		vfio_unpin_page_external(dma, iova, do_accounting,
> >> +					 iommu->dirty_page_tracking);
> >>   	}
> >>   
> >>   unpin_exit:
> >> @@ -850,6 +891,88 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >>   	return bitmap;
> >>   }
> >>   
> >> +/*
> >> + * start_iova is the reference from where bitmaping started. This is called
> >> + * from DMA_UNMAP where start_iova can be different than iova
> >> + */
> >> +
> >> +static void vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >> +				  size_t size, uint64_t pgsize,
> >> +				  dma_addr_t start_iova, unsigned long *bitmap)
> >> +{
> >> +	struct vfio_dma *dma;
> >> +	dma_addr_t i = iova;
> >> +	unsigned long pgshift = __ffs(pgsize);
> >> +
> >> +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
> >> +		/* mark all pages dirty if all pages are pinned and mapped. */
> >> +		if (dma->iommu_mapped) {
> >> +			dma_addr_t iova_limit;
> >> +
> >> +			iova_limit = (dma->iova + dma->size) < (iova + size) ?
> >> +				     (dma->iova + dma->size) : (iova + size);  
> > 
> > min(dma->iova + dma->size, iova + size);
> >   
> >> +
> >> +			for (; i < iova_limit; i += pgsize) {
> >> +				unsigned int start;
> >> +
> >> +				start = (i - start_iova) >> pgshift;
> >> +
> >> +				__bitmap_set(bitmap, start, 1);  
> > 
> > Why __bitmap_set() rather than bitmap_set()?  Also why not try to take
> > advantage of the number of bits arg?
> >   
> bitmap_set() can be used, I didn't checked about it earlier.
> Yes, we can take advantage of nbits, updating it.
> 
> 
> >> +			}
> >> +			if (i >= iova + size)
> >> +				return;  
> > 
> > This skips the removed unpinned callback at the end of the loop,
> > leaving unnecessarily tracked, unpinned vpfns.
> >   
> 
> Right, fixing it.
> 
> >> +		} else {
> >> +			struct rb_node *n = rb_first(&dma->pfn_list);
> >> +			bool found = false;
> >> +
> >> +			for (; n; n = rb_next(n)) {
> >> +				struct vfio_pfn *vpfn = rb_entry(n,
> >> +							struct vfio_pfn, node);
> >> +				if (vpfn->iova >= i) {  
> > 
> > This doesn't look right, how does a vpfn with .iova > i necessarily
> > contain i?
> >   
> 
> i might not be equal to dma->iova.
> Also iova == i might not be pinned, but there might be pages pinned 
> between i to iova + size. So find a vpfn node whose (vpfn->iova >= i)

Ok, I think my concern is resolved when it falls through to the test
below where we make sure the vpfn isn't past the end of the range.

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
> >> +				unsigned int start;
> >> +				struct vfio_pfn *vpfn = rb_entry(n,
> >> +							struct vfio_pfn, node);
> >> +
> >> +				if (vpfn->iova >= iova + size)
> >> +					return;
> >> +
> >> +				start = (vpfn->iova - start_iova) >> pgshift;
> >> +
> >> +				__bitmap_set(bitmap, start, 1);  
> > 
> > Don't we need to iterate over the vfpn relative to pgsize?  Oh, I
> > see below that pgsize is the minimum user advertised size, which is at
> > least PAGE_SIZE, to maybe not.  Same bitmap_set() question as above
> > though.
> >   
> 
> Changing to bitmap_set.
> 
> >> +
> >> +				i = vpfn->iova + pgsize;
> >> +			}
> >> +		}
> >> +		vfio_remove_unpinned_from_pfn_list(dma, false);
> >> +	}
> >> +}
> >> +
> >> +static long verify_bitmap_size(unsigned long npages, unsigned long bitmap_size)
> >> +{
> >> +	long bsize;
> >> +
> >> +	if (!bitmap_size || bitmap_size > SIZE_MAX)
> >> +		return -EINVAL;
> >> +
> >> +	bsize = ALIGN(npages, BITS_PER_LONG) / sizeof(unsigned long);
> >> +
> >> +	if (bitmap_size < bsize)
> >> +		return -EINVAL;
> >> +
> >> +	return bsize;
> >> +}
> >> +
> >>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>   			     struct vfio_iommu_type1_dma_unmap *unmap)
> >>   {
> >> @@ -2297,6 +2420,83 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
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
> >> +
> >> +		if (copy_from_user(&range, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (range.argsz < minsz || range.flags & ~mask)
> >> +			return -EINVAL;
> >> +  
> > 
> > flags should be sanitized further, invalid combinations should be
> > rejected.  For example, if a user provides STOP|GET_BITMAP it should
> > either populate the bitmap AND turn off tracking, or error.  It's not
> > acceptable to turn off tracking and silently ignore GET_BITMAP.
> >   
> 
> Ok. adding a check such that only one flag should be set at a time is 
> valid.
> 
> >> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> >> +			iommu->dirty_page_tracking = true;
> >> +			return 0;
> >> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> >> +			iommu->dirty_page_tracking = false;
> >> +
> >> +			mutex_lock(&iommu->lock);
> >> +			vfio_remove_unpinned_from_dma_list(iommu);
> >> +			mutex_unlock(&iommu->lock);
> >> +			return 0;
> >> +
> >> +		} else if (range.flags &
> >> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >> +			uint64_t iommu_pgmask;
> >> +			unsigned long pgshift = __ffs(range.pgsize);
> >> +			unsigned long *bitmap;
> >> +			long bsize;
> >> +
> >> +			iommu_pgmask =
> >> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> >> +
> >> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> >> +			    (range.pgsize - 1))
> >> +				return -EINVAL;
> >> +
> >> +			if (range.iova & iommu_pgmask)
> >> +				return -EINVAL;
> >> +			if (!range.size || range.size > SIZE_MAX)
> >> +				return -EINVAL;
> >> +			if (range.iova + range.size < range.iova)
> >> +				return -EINVAL;
> >> +
> >> +			bsize = verify_bitmap_size(range.size >> pgshift,
> >> +						   range.bitmap_size);
> >> +			if (bsize < 0)
> >> +				return ret;
> >> +
> >> +			bitmap = kmalloc(bsize, GFP_KERNEL);  
> > 
> > I think I remember mentioning previously that we cannot allocate an
> > arbitrary buffer on behalf of the user, it's far too easy for them to
> > kill the kernel that way.  kmalloc is also limited in what it can
> > alloc.    
> 
> That's the reason added verify_bitmap_size(), so that size is verified

That's only a consistency test, it only verifies that the user claims
to provide a bitmap sized sufficiently for the range they're trying to
request.  range.size is limited to SIZE_MAX, so 2^64, divided by page
size for 2^52 bits, 8bits per byte for 2^49 bytes of bitmap that we'd
try to kmalloc (512TB).  kmalloc is good for a couple MB AIUI.
Meanwhile the user doesn't actually need to allocate that bitmap in
order to crash the kernel. 

> > Can't we use the user buffer directly or only work on a part of
> > it at a time?
> >   
> 
> without copy_from_user(), how?

For starters, what's the benefit of copying the bitmap from the user
in the first place?  We presume the data is zero'd and if it's not,
that's the user's bug to sort out (we just need to define the API to
specify that).  Therefore the copy_from_user() is unnecessary anyway and
we really just need to copy_to_user() for any places we're setting
bits.  We could just walk through the range with an unsigned long
bitmap buffer, writing it out to userspace any time we reach the end
with bits set, zeroing it and shifting it as a window to the user
buffer.  We could improve batching by allocating a larger buffer in the
kernel, with a kernel defined maximum size and performing the same
windowing scheme.

I don't know if there's a way to directly map the user buffer rather
than copy_to_user(), but I thought I'd ask in case there's some obvious
efficiency improvement to be had there.

> >> +			if (!bitmap)
> >> +				return -ENOMEM;
> >> +
> >> +			ret = copy_from_user(bitmap,
> >> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
> >> +			if (ret)
> >> +				goto bitmap_exit;
> >> +
> >> +			iommu->dirty_page_tracking = false;  
> > 
> > a) This is done outside of the mutex and susceptible to races,  
> 
> moving inside lock
> 
> > b) why is this done?  
> once bitmap is read, dirty_page_tracking should be stopped. Right?

Absolutely not.  Dirty bit page tracking should remain enabled until
the user turns it off, doing otherwise precludes both iterative and
partial dirty page collection from userspace.  I think both of those
are fundamentally required of this interface.  Thanks,

Alex

