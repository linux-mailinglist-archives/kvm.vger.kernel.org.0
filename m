Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5FC134F65
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 23:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgAHW3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 17:29:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726390AbgAHW3o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 17:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578522584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eeoF1sYvyY8I9ti0kR+cfmLLTVxMhMv4ZrFm5YTgMQk=;
        b=ZaGMBHgBDwDuymtLhAo2wdSUI+PQkYBePbgt4YXZSgTK9lyLQ7kC3LkxsCOYqNbA93Db2i
        UFDT0MYo3hPFC8k2yt2rhGvSokiMqAJ8vOlmWKbXxDHurVzHvSJ/HeeUy/GQ6VTUQLs1bI
        Sl9y/QAdFX2u2bWKFI5g5hYfSed3yb4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-ecyQMbROMwKXvNAabViK7g-1; Wed, 08 Jan 2020 17:29:40 -0500
X-MC-Unique: ecyQMbROMwKXvNAabViK7g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD7EEDBA3;
        Wed,  8 Jan 2020 22:29:37 +0000 (UTC)
Received: from w520.home (ovpn-118-62.phx2.redhat.com [10.3.118.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E55A7BA39;
        Wed,  8 Jan 2020 22:29:35 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:29:34 -0700
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
Message-ID: <20200108152934.68cd0e85@w520.home>
In-Reply-To: <d2faa3fe-d656-5ba7-475a-9646298e3d50@nvidia.com>
References: <1576602651-15430-1-git-send-email-kwankhede@nvidia.com>
        <1576602651-15430-4-git-send-email-kwankhede@nvidia.com>
        <20191217151203.342b686a@x1.home>
        <ebd08133-e258-9f5e-5c8f-f88d7165cd7a@nvidia.com>
        <20200107150223.0dab0a85@w520.home>
        <d2faa3fe-d656-5ba7-475a-9646298e3d50@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 01:31:16 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 1/8/2020 3:32 AM, Alex Williamson wrote:
> > On Wed, 8 Jan 2020 01:37:03 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> 
> <snip>
> 
> >>>> +
> >>>> +	unlocked = vfio_iova_put_vfio_pfn(dma, vpfn, dirty_tracking);
> >>>>    
> >>>>    	if (do_accounting)
> >>>>    		vfio_lock_acct(dma, -unlocked, true);
> >>>> @@ -571,8 +606,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>>>    
> >>>>    		vpfn = vfio_iova_get_vfio_pfn(dma, iova);
> >>>>    		if (vpfn) {
> >>>> -			phys_pfn[i] = vpfn->pfn;
> >>>> -			continue;
> >>>> +			if (vpfn->unpinned)
> >>>> +				vfio_remove_from_pfn_list(dma, vpfn);  
> >>>
> >>> This seems inefficient, we have an allocated vpfn at the right places
> >>> in the list, wouldn't it be better to repin the page?
> >>>      
> >>
> >> vfio_pin_page_external() takes care of pinning and accounting as well.  
> > 
> > Yes, but could we call vfio_pin_page_external() without {unlinking,
> > freeing} and {re-allocating, linking} on either side of it since it's
> > already in the list?  That's the inefficient part.  Maybe at least a
> > TODO comment?
> >   
> 
> Changing it as below:
> 
>                  vpfn = vfio_iova_get_vfio_pfn(dma, iova);
>                  if (vpfn) {
> -                       phys_pfn[i] = vpfn->pfn;
> -                       continue;
> +                       if (vpfn->ref_count > 1) {
> +                               phys_pfn[i] = vpfn->pfn;
> +                               continue;
> +                       }
>                  }
> 
>                  remote_vaddr = dma->vaddr + iova - dma->iova;
>                  ret = vfio_pin_page_external(dma, remote_vaddr, 
> &phys_pfn[i],
>                                               do_accounting);
>                  if (ret)
>                          goto pin_unwind;
> -
> -               ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> -               if (ret) {
> -                       vfio_unpin_page_external(dma, iova, do_accounting);
> -                       goto pin_unwind;
> -               }
> +               if (!vpfn) {
> +                       ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> +                       if (ret) {
> +                               vfio_unpin_page_external(dma, iova,
> +                                                        do_accounting, 
> false);
> +                               goto pin_unwind;
> +                       }
> +               } else
> +                       vpfn->pfn = phys_pfn[i];
>          }
> 
> 
> 
> 
> >>>> +			else {
> >>>> +				phys_pfn[i] = vpfn->pfn;
> >>>> +				continue;
> >>>> +			}
> >>>>    		}
> >>>>    
> >>>>    		remote_vaddr = dma->vaddr + iova - dma->iova;
> >>>> @@ -583,7 +622,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>>>    
> >>>>    		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
> >>>>    		if (ret) {
> >>>> -			vfio_unpin_page_external(dma, iova, do_accounting);
> >>>> +			vfio_unpin_page_external(dma, iova, do_accounting,
> >>>> +						 false);
> >>>>    			goto pin_unwind;
> >>>>    		}
> >>>>    	}  
> 
> <snip>
> 
> >>  
> >>>> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> >>>> +			iommu->dirty_page_tracking = true;
> >>>> +			return 0;
> >>>> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> >>>> +			iommu->dirty_page_tracking = false;
> >>>> +
> >>>> +			mutex_lock(&iommu->lock);
> >>>> +			vfio_remove_unpinned_from_dma_list(iommu);
> >>>> +			mutex_unlock(&iommu->lock);
> >>>> +			return 0;
> >>>> +
> >>>> +		} else if (range.flags &
> >>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> >>>> +			uint64_t iommu_pgmask;
> >>>> +			unsigned long pgshift = __ffs(range.pgsize);
> >>>> +			unsigned long *bitmap;
> >>>> +			long bsize;
> >>>> +
> >>>> +			iommu_pgmask =
> >>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> >>>> +
> >>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> >>>> +			    (range.pgsize - 1))
> >>>> +				return -EINVAL;
> >>>> +
> >>>> +			if (range.iova & iommu_pgmask)
> >>>> +				return -EINVAL;
> >>>> +			if (!range.size || range.size > SIZE_MAX)
> >>>> +				return -EINVAL;
> >>>> +			if (range.iova + range.size < range.iova)
> >>>> +				return -EINVAL;
> >>>> +
> >>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
> >>>> +						   range.bitmap_size);
> >>>> +			if (bsize < 0)
> >>>> +				return ret;
> >>>> +
> >>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);  
> >>>
> >>> I think I remember mentioning previously that we cannot allocate an
> >>> arbitrary buffer on behalf of the user, it's far too easy for them to
> >>> kill the kernel that way.  kmalloc is also limited in what it can
> >>> alloc.  
> >>
> >> That's the reason added verify_bitmap_size(), so that size is verified  
> > 
> > That's only a consistency test, it only verifies that the user claims
> > to provide a bitmap sized sufficiently for the range they're trying to
> > request.  range.size is limited to SIZE_MAX, so 2^64, divided by page
> > size for 2^52 bits, 8bits per byte for 2^49 bytes of bitmap that we'd
> > try to kmalloc (512TB).  kmalloc is good for a couple MB AIUI.
> > Meanwhile the user doesn't actually need to allocate that bitmap in
> > order to crash the kernel.
> >   
> >>> Can't we use the user buffer directly or only work on a part of
> >>> it at a time?
> >>>      
> >>
> >> without copy_from_user(), how?  
> > 
> > For starters, what's the benefit of copying the bitmap from the user
> > in the first place?  We presume the data is zero'd and if it's not,
> > that's the user's bug to sort out (we just need to define the API to
> > specify that).  Therefore the copy_from_user() is unnecessary anyway and
> > we really just need to copy_to_user() for any places we're setting
> > bits.  We could just walk through the range with an unsigned long
> > bitmap buffer, writing it out to userspace any time we reach the end
> > with bits set, zeroing it and shifting it as a window to the user
> > buffer.  We could improve batching by allocating a larger buffer in the
> > kernel, with a kernel defined maximum size and performing the same
> > windowing scheme.
> >   
> 
> Ok removing copy_from_user().
> But AFAIK, calling copy_to_user() multiple times is not efficient in 
> terms of performance.

Right, but even with a modestly sized internal buffer for batching we
can cover quite a large address space.  128MB for a 4KB buffer, 32GB
with 1MB buffer.  __put_user() is more lightweight than copy_to_user(),
I wonder where the inflection point is in batching the latter versus
more iterations of the former.

> Checked code in virt/kvm/kvm_main.c: __kvm_set_memory_region() where 
> dirty_bitmap is allocated, that has generic checks, user space address 
> check, memory overflow check and KVM_MEM_MAX_NR_PAGES as below. I'll add 
> access_ok check. I already added overflow check.
> 
>          /* General sanity checks */
>          if (mem->memory_size & (PAGE_SIZE - 1))
>                  goto out;
> 
>         !access_ok((void __user *)(unsigned long)mem->userspace_addr,
>                          mem->memory_size)))
> 
>          if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>                  goto out;
> 
>          if (npages > KVM_MEM_MAX_NR_PAGES)
>                  goto out;
> 
> 
> Where KVM_MEM_MAX_NR_PAGES is:
> 
> /*
>   * Some of the bitops functions do not support too long bitmaps.
>   * This number must be determined not to exceed such limits.
>   */
> #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
> 
> But we can't use KVM specific KVM_MEM_MAX_NR_PAGES check in vfio module.
> Should we define similar limit in vfio module instead of SIZE_MAX?

If we have ranges that are up to 2^31 pages, that's still 2^28 bytes.
Does it seem reasonable to have a kernel interface that potentially
allocates 256MB of kernel space with kmalloc accessible to users?  That
still seems like a DoS attack vector to me, especially since the user
doesn't need to be able to map that much memory (8TB) to access it.

I notice that KVM allocate the bitmap (kvzalloc) relative to the actual
size of the memory slot when dirty logging is enabled, maybe that's the
right approach rather than walking vpfn lists and maintaining unpinned
vpfns for the purposes of tracking.  For example, when dirty logging is
enabled, walk all vfio_dmas and allocate a dirty bitmap anywhere the
vpfn list is not empty and walk the vpfn list to set dirty bits in the
bitmap.  When new pages are pinned, allocate a bitmap if not already
present and set the dirty bit.  When unpinned, update the vpfn list but
leave the dirty bit set.  When the dirty bitmap is read, copy out the
current bitmap to the user, memset it to zero, then re-walk the vpfn
list to set currently dirty pages.  A vfio_dma without a dirty bitmap
would consider the entire range dirty.  At least that way the overhead
of the bitmap is just that, overhead rather than a future exploit.
Does this seem like a better approach?  Thanks,

Alex

