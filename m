Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157DB16353A
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBRVlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:41:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726481AbgBRVlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582062074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJ1ScK2FYq0efwHuQ6rKyXzvL/wveappU3xhTyrJCrM=;
        b=WZI3C2AgKg1LB5Ys/YYPvEL6QCuReiBV7K5bVYx9DnUYgQzhdZoCVW7d2aar6dWUv3PVlO
        s3IcwSN6xAAGOperS78JAYLg++DbnkU5zKZblWMm3tSE8X/lRtMYLBfEwb+B7v83BlyAcZ
        QjoFSM90Odu6lwwOrhf3T0Ce7f5IvXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-FT46i10EOW2gfaVCnvNsVQ-1; Tue, 18 Feb 2020 16:41:11 -0500
X-MC-Unique: FT46i10EOW2gfaVCnvNsVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E467190B2AB;
        Tue, 18 Feb 2020 21:41:08 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AA3160C81;
        Tue, 18 Feb 2020 21:41:06 +0000 (UTC)
Date:   Tue, 18 Feb 2020 14:41:05 -0700
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
Message-ID: <20200218144105.4076b7eb@w520.home>
In-Reply-To: <57199367-e562-800a-ef73-f28bc5ddb2fe@nvidia.com>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
        <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
        <20200210102518.490a0d87@x1.home>
        <7e7356c8-29ed-31fa-5c0b-2545ae69f321@nvidia.com>
        <20200212161320.02d8dfac@w520.home>
        <0244aca6-80f7-1c1d-812e-d53a48b5479d@nvidia.com>
        <20200213162011.40b760a8@w520.home>
        <ea31fb62-4cd3-babb-634d-f69407586c93@nvidia.com>
        <20200217135518.4d48ebd6@w520.home>
        <57199367-e562-800a-ef73-f28bc5ddb2fe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Feb 2020 11:28:53 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> <snip>
> 
> >>>>>    As I understand the above algorithm, we find a vfio_dma
> >>>>> overlapping the request and populate the bitmap for that range.  Then
> >>>>> we go back and put_user() for each byte that we touched.  We could
> >>>>> instead simply work on a one byte buffer as we enumerate the requested
> >>>>> range and do a put_user() ever time we reach the end of it and have bits
> >>>>> set. That would greatly simplify the above example.  But I would expect
> >>>>> that we're a) more likely to get asked for ranges covering a single
> >>>>> vfio_dma  
> >>>>
> >>>> QEMU ask for single vfio_dma during each iteration.
> >>>>
> >>>> If we restrict this ABI to cover single vfio_dma only, then it
> >>>> simplifies the logic here. That was my original suggestion. Should we
> >>>> think about that again?  
> >>>
> >>> But we currently allow unmaps that overlap multiple vfio_dmas as long
> >>> as no vfio_dma is bisected, so I think that implies that an unmap while
> >>> asking for the dirty bitmap has even further restricted semantics.  I'm
> >>> also reluctant to design an ABI around what happens to be the current
> >>> QEMU implementation.
> >>>
> >>> If we take your example above, ranges {0x0000,0xa000} and
> >>> {0xa000,0x10000} ({start,end}), I think you're working with the
> >>> following two bitmaps in this implementation:
> >>>
> >>> 00000011 11111111b
> >>> 00111111b
> >>>
> >>> And we need to combine those into:
> >>>
> >>> 11111111 11111111b
> >>>
> >>> Right?
> >>>
> >>> But it seems like that would be easier if the second bitmap was instead:
> >>>
> >>> 11111100b
> >>>
> >>> Then we wouldn't need to worry about the entire bitmap being shifted by
> >>> the bit offset within the byte, which limits our fixes to the boundary
> >>> byte and allows us to use copy_to_user() directly for the bulk of the
> >>> copy.  So how do we get there?
> >>>
> >>> I think we start with allocating the vfio_dma bitmap to account for
> >>> this initial offset, so we calculate bitmap_base_iova as:
> >>>     (iova & ~((PAGE_SIZE << 3) - 1))
> >>> We then use bitmap_base_iova in calculating which bits to set.
> >>>
> >>> The user needs to follow the same rules, and maybe this adds some value
> >>> to the user providing the bitmap size rather than the kernel
> >>> calculating it.  For example, if the user wanted the dirty bitmap for
> >>> the range {0xa000,0x10000} above, they'd provide at least a 1 byte
> >>> bitmap, but we'd return bit #2 set to indicate 0xa000 is dirty.
> >>>
> >>> Effectively the user can ask for any iova range, but the buffer will be
> >>> filled relative to the zeroth bit of the bitmap following the above
> >>> bitmap_base_iova formula (and replacing PAGE_SIZE with the user
> >>> requested pgsize).  I'm tempted to make this explicit in the user
> >>> interface (ie. only allow bitmaps starting on aligned pages), but a
> >>> user is able to map and unmap single pages and we need to support
> >>> returning a dirty bitmap with an unmap, so I don't think we can do that.
> >>>      
> >>
> >> Sigh, finding adjacent vfio_dmas within the same byte seems simpler than
> >> this.  
> > 
> > How does KVM do this?  My intent was that if all of our bitmaps share
> > the same alignment then we can merge the intersection and continue to
> > use copy_to_user() on either side.  However, if QEMU doesn't do the
> > same, it doesn't really help us.  Is QEMU stuck with an implementation
> > of only retrieving dirty bits per MemoryRegionSection exactly because
> > of this issue and therefore we can rely on it in our implementation as
> > well?  Thanks,
> >   
> 
> QEMU sync dirty_bitmap per MemoryRegionSection. Within 
> MemoryRegionSection there could be multiple KVMSlots. QEMU queries 
> dirty_bitmap per KVMSlot and mark dirty for each KVMSlot.
> On kernel side, KVM_GET_DIRTY_LOG ioctl calls 
> kvm_get_dirty_log_protect(), where it uses copy_to_user() to copy bitmap 
> of that memSlot.
> vfio_dma is per MemoryRegionSection. We can reply on MemoryRegionSection 
> in our implementation. But to get bitmap during unmap, we have to take 
> care of concatenating bitmaps.

So KVM does not worry about bitmap alignment because the interface is
based on slots, a dirty bitmap can only be retrieved for a single,
entire slot.  We need VFIO_IOMMU_UNMAP_DMA to maintain its support for
spanning multiple vfio_dmas, but maybe we have some leeway that we
don't need to support both multiple vfio_dmas and dirty bitmap at the
same time.  It seems like it would be a massive simplification if we
required an unmap with dirty bitmap to span exactly one vfio_dma,
right?  I don't see that we'd break any existing users with that, it's
unfortunate that we can't have the flexibility of the existing calling
convention, but I think there's good reason for it here.  Our separate
dirty bitmap log reporting would follow the same semantics.  I think
this all aligns with how the MemoryListener works in QEMU right now,
correct?  For example we wouldn't need any extra per MAP_DMA tracking
in QEMU like KVM has for its slots.

> In QEMU, in function kvm_physical_sync_dirty_bitmap() there is a comment 
> where bitmap size is calculated and bitmap is defined as 'void __user 
> *dirty_bitmap' which is also the concern you raised and could be handled 
> similarly as below.
> 
>          /* XXX bad kernel interface alert
>           * For dirty bitmap, kernel allocates array of size aligned to
>           * bits-per-long.  But for case when the kernel is 64bits and
>           * the userspace is 32bits, userspace can't align to the same
>           * bits-per-long, since sizeof(long) is different between kernel
>           * and user space.  This way, userspace will provide buffer which
>           * may be 4 bytes less than the kernel will use, resulting in
>           * userspace memory corruption (which is not detectable by valgrind
>           * too, in most cases).
>           * So for now, let's align to 64 instead of HOST_LONG_BITS here, in
>           * a hope that sizeof(long) won't become >8 any time soon.
>           */
>          if (!mem->dirty_bmap) {
>              hwaddr bitmap_size = ALIGN(((mem->memory_size) >> 
> TARGET_PAGE_BITS),
>                                          /*HOST_LONG_BITS*/ 64) / 8;
>              /* Allocate on the first log_sync, once and for all */
>              mem->dirty_bmap = g_malloc0(bitmap_size);
>          }

Sort of, the the KVM ioctl seems to just pass a slot number and user
dirty bitmap pointer, so the size of the bitmap is inferred by the size
of the slot, but if both kernel and user round up to a multiple of
longs they might come up with different lengths.  QEMU therefore decides
to always round up the size for an LP64 based long.  Since you've
specified bitmap_size in our ioctl, the size agreement is explicit.

The concern I had looks like it addressed in KVM by placing the void*
__user pointer in a union with a u64:

struct kvm_dirty_log {
        __u32 slot;
        __u32 padding1;
        union {
                void __user *dirty_bitmap; /* one bit per page */
                __u64 padding2;
        };
};

The the kvm_vm_compat_ioctl() ioctl handles this with it's own private
structure:

truct compat_kvm_dirty_log {
        __u32 slot;
        __u32 padding1;
        union {
                compat_uptr_t dirty_bitmap; /* one bit per page */
                __u64 padding2;
        };
};

Which gets extracted via:

	log.dirty_bitmap = compat_ptr(compat_log.dirty_bitmap);

However, compat_ptr() has:

/*
 * A pointer passed in from user mode. This should not
 * be used for syscall parameters, just declare them
 * as pointers because the syscall entry code will have
 * appropriately converted them already.
 */
#ifndef compat_ptr
static inline void __user *compat_ptr(compat_uptr_t uptr)
{
        return (void __user *)(unsigned long)uptr;
}
#endif

So maybe we don't need to do anything special?  I'm tempted to think
the KVM handling is using legacy mechanism or the padding in the union
was assumed not to be for that purpose.  Thanks,

Alex

