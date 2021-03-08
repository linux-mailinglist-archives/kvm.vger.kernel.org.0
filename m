Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170A5331A83
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 23:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhCHW4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 17:56:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231301AbhCHW4c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 17:56:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Q8D8LboIHh4Rz0+Zc87mq3F8gHasOwTkfuMAD39SmA=;
        b=igj88wQ8T8MHEI8q0X1+e6HaWlm/0GIl2IT98gYnRZQwInbl2mR2GdJgl5TibJy9D0gUdx
        g/L5B6Q31rPn7D+ars/ayVzFKvDI1kfCbq+VueuL+EX+jdY10u6MvjeUXw+nAduHwhmIwc
        nkrULWOJXzEzn7OfO8/UKLqOjLZgGHM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-Ro6n6sOMM4anLdOQ0vVahg-1; Mon, 08 Mar 2021 17:56:30 -0500
X-MC-Unique: Ro6n6sOMM4anLdOQ0vVahg-1
Received: by mail-qk1-f197.google.com with SMTP id y9so8547678qki.14
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 14:56:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8Q8D8LboIHh4Rz0+Zc87mq3F8gHasOwTkfuMAD39SmA=;
        b=syk6xQEkuqPUAQedNJcnI1q6fc8YviM7NBd1o4qY0ssfA6iixDiGorZynGkrumBAMJ
         F58f+ep1gseuHxzakP40ooclMQ7fAdK9R6wPVAFFKbXZH87iCfHy3AbfnpLiSfxZEmxQ
         RAYWh49IaTp9fwz3F+IZA4+0fdZQVbAoTCmfppmRELVdKcDWoWWga/jWlHaIWzv/otDJ
         f9jz6W3A16jr4Om/Q/0jj6kH3wqZ7lWq8tC3a6NqpYrddH3C+uqBlPj26cvxXCJdk7Db
         1Yg8JpBKoP049OgxchczhmHUgPu378etJBHCjA9lqqidbrBdLNVkyTMLW9PQdYfq9JMq
         xvpg==
X-Gm-Message-State: AOAM530lk+XsvGt3iRBM+TBCdfw3XXmVws2fqF74XfSUNIujIqVvaMX0
        xR7eMhbV5iGlT6pLcSfk0F8uCp+d8jqUiobULX1vCKyWFs29r6KoaG3n1Y15c9fGcoiHwvNaamb
        VJPY57A9gAFnK
X-Received: by 2002:ae9:f81a:: with SMTP id x26mr22056586qkh.497.1615244188954;
        Mon, 08 Mar 2021 14:56:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAdfY7rRvRz121TSQ1iCc4+E3Shh3qRDjW8+t6o4vpI+iGAXcZhfvaA7qGz2Mb6KUqQ2DO+g==
X-Received: by 2002:ae9:f81a:: with SMTP id x26mr22056567qkh.497.1615244188573;
        Mon, 08 Mar 2021 14:56:28 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id d23sm8679920qka.125.2021.03.08.14.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 14:56:28 -0800 (PST)
Date:   Mon, 8 Mar 2021 17:56:26 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Zeng Tao <prime.zeng@hisilicon.com>, linuxarm@huawei.com,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210308225626.GN397383@xz-x1>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210308132106.49da42e2@omen.home.shazbot.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 01:21:06PM -0700, Alex Williamson wrote:
> On Mon, 8 Mar 2021 19:11:26 +0800
> Zeng Tao <prime.zeng@hisilicon.com> wrote:
> 
> > We have met the following error when test with DPDK testpmd:
> > [ 1591.733256] kernel BUG at mm/memory.c:2177!
> > [ 1591.739515] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> > [ 1591.747381] Modules linked in: vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
> > [ 1591.760536] CPU: 2 PID: 227 Comm: lcore-worker-2 Tainted: G O 5.11.0-rc3+ #1
> > [ 1591.770735] Hardware name:  , BIOS HixxxxFPGA 1P B600 V121-1
> > [ 1591.778872] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> > [ 1591.786134] pc : remap_pfn_range+0x214/0x340
> > [ 1591.793564] lr : remap_pfn_range+0x1b8/0x340
> > [ 1591.799117] sp : ffff80001068bbd0
> > [ 1591.803476] x29: ffff80001068bbd0 x28: 0000042eff6f0000
> > [ 1591.810404] x27: 0000001100910000 x26: 0000001300910000
> > [ 1591.817457] x25: 0068000000000fd3 x24: ffffa92f1338e358
> > [ 1591.825144] x23: 0000001140000000 x22: 0000000000000041
> > [ 1591.832506] x21: 0000001300910000 x20: ffffa92f141a4000
> > [ 1591.839520] x19: 0000001100a00000 x18: 0000000000000000
> > [ 1591.846108] x17: 0000000000000000 x16: ffffa92f11844540
> > [ 1591.853570] x15: 0000000000000000 x14: 0000000000000000
> > [ 1591.860768] x13: fffffc0000000000 x12: 0000000000000880
> > [ 1591.868053] x11: ffff0821bf3d01d0 x10: ffff5ef2abd89000
> > [ 1591.875932] x9 : ffffa92f12ab0064 x8 : ffffa92f136471c0
> > [ 1591.883208] x7 : 0000001140910000 x6 : 0000000200000000
> > [ 1591.890177] x5 : 0000000000000001 x4 : 0000000000000001
> > [ 1591.896656] x3 : 0000000000000000 x2 : 0168044000000fd3
> > [ 1591.903215] x1 : ffff082126261880 x0 : fffffc2084989868
> > [ 1591.910234] Call trace:
> > [ 1591.914837]  remap_pfn_range+0x214/0x340
> > [ 1591.921765]  vfio_pci_mmap_fault+0xac/0x130 [vfio_pci]
> > [ 1591.931200]  __do_fault+0x44/0x12c
> > [ 1591.937031]  handle_mm_fault+0xcc8/0x1230
> > [ 1591.942475]  do_page_fault+0x16c/0x484
> > [ 1591.948635]  do_translation_fault+0xbc/0xd8
> > [ 1591.954171]  do_mem_abort+0x4c/0xc0
> > [ 1591.960316]  el0_da+0x40/0x80
> > [ 1591.965585]  el0_sync_handler+0x168/0x1b0
> > [ 1591.971608]  el0_sync+0x174/0x180
> > [ 1591.978312] Code: eb1b027f 540000c0 f9400022 b4fffe02 (d4210000)
> > 
> > The cause is that the vfio_pci_mmap_fault function is not reentrant, if
> > multiple threads access the same address which will lead to a page fault
> > at the same time, we will have the above error.
> > 
> > Fix the issue by making the vfio_pci_mmap_fault reentrant, and there is
> > another issue that when the io_remap_pfn_range fails, we need to undo
> > the __vfio_pci_add_vma, fix it by moving the __vfio_pci_add_vma down
> > after the io_remap_pfn_range.
> > 
> > Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
> > Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 65e7e6b..6928c37 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1613,6 +1613,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> >  	vm_fault_t ret = VM_FAULT_NOPAGE;
> > +	unsigned long pfn;
> >  
> >  	mutex_lock(&vdev->vma_lock);
> >  	down_read(&vdev->memory_lock);
> > @@ -1623,18 +1624,23 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  		goto up_out;
> >  	}
> >  
> > -	if (__vfio_pci_add_vma(vdev, vma)) {
> > -		ret = VM_FAULT_OOM;
> > +	if (!follow_pfn(vma, vma->vm_start, &pfn)) {
> >  		mutex_unlock(&vdev->vma_lock);
> >  		goto up_out;
> >  	}
> >  
> > -	mutex_unlock(&vdev->vma_lock);
> 
> 
> If I understand correctly, I think you're using (perhaps slightly
> abusing) the vma_lock to extend the serialization of the vma_list
> manipulation to include io_remap_pfn_range() such that you can test
> whether the pte has already been populated using follow_pfn().  In that
> case we return VM_FAULT_NOPAGE without trying to repopulate the page
> and therefore avoid the BUG_ON in remap_pte_range() triggered by trying
> to overwrite an existing pte, and less importantly, a duplicate vma in
> our list.  I wonder if use of follow_pfn() is still strongly
> discouraged for this use case.
> 
> I'm surprised that it's left to the fault handler to provide this
> serialization, is this because we're filling the entire vma rather than
> only the faulting page?

There's definitely some kind of serialization in the process using pgtable
locks, which gives me the feeling that the BUG_ON() in remap_pte_range() seems
too strong on "!pte_none(*pte)" rather than -EEXIST.

However there'll still be the issue of duplicated vma in vma_list - that seems
to be a sign that it's still better to fix it from vfio layer.

> 
> As we move to unmap_mapping_range()[1] we remove all of the complexity
> of managing a list of vmas to zap based on whether device memory is
> enabled, including the vma_lock.  Are we going to need to replace that
> with another lock here, or is there a better approach to handling
> concurrency of this fault handler?  Jason/Peter?  Thanks,

Not looked into the new series of unmap_mapping_range() yet..  But for the
current code base: instead of follow_pte(), maybe we could simply do the
ordering by searching the vma list first before inserting into the vma list?
Because if vma existed, it means the pte installation has done, or at least in
progress.  Then we could return VM_FAULT_RETRY hoping that it'll be done soon.

Then maybe it would also make some sense to have vma_lock protect the whole
io_remap_pfn_range() too? - it'll not be for the ordering, but just that it'll
guarantee after we're with the vma_lock it means current vma has all ptes
installed, then the next memory access will guaranteed to success.  It seems
more efficient than multiple VM_FAULT_RETRY page fault looping until it's done.

Thanks,

-- 
Peter Xu

