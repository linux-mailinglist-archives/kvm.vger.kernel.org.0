Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1D346DB9
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhCWXJq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 19:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhCWXJl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 19:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616540980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VtbedmlNWzX1nJrfue+R4NXFu7Av/YNHBdtB90efqM=;
        b=BzHFscLf1KnwuwTe/EgVcqnho85FTH1GHCumKEisjctAYdoD4IyLqz+hEa4X/fh5pO8Mqb
        /CYTfEXEo1sKs6LAw5lgL5AjsLCAw+Lx1jD797jFeOZ1WQLTIx/X997CWZ7wcj5Jy6em1C
        uHZ7KxgLnodeCFl2IFP8++kjKIbAH/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-6NN5IMKyPZ-Kzq6szfNjcw-1; Tue, 23 Mar 2021 19:09:38 -0400
X-MC-Unique: 6NN5IMKyPZ-Kzq6szfNjcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B141983DD20;
        Tue, 23 Mar 2021 23:09:36 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E97881001281;
        Tue, 23 Mar 2021 23:09:35 +0000 (UTC)
Date:   Tue, 23 Mar 2021 17:09:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vfio/type1: Batch page pinning
Message-ID: <20210323170935.5b2027c2@omen.home.shazbot.org>
In-Reply-To: <87y2ed7biu.fsf@oracle.com>
References: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
        <20210219161305.36522-4-daniel.m.jordan@oracle.com>
        <20210323133254.33ed9161@omen.home.shazbot.org>
        <87y2ed7biu.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 18:25:45 -0400
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> Hi Alex,
> 
> Alex Williamson <alex.williamson@redhat.com> writes:
> > I've found a bug in this patch that we need to fix.  The diff is a
> > little difficult to follow,  
> 
> It was an awful diff, I remember...
> 
> > so I'll discuss it in the resulting function below...
> >
> > (1) Imagine the user has passed a vaddr range that alternates pfnmaps
> > and pinned memory per page.
> >
> >
> > static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >                                   long npage, unsigned long *pfn_base,
> >                                   unsigned long limit, struct vfio_batch *batch)
> > {
> >         unsigned long pfn;
> >         struct mm_struct *mm = current->mm;
> >         long ret, pinned = 0, lock_acct = 0;
> >         bool rsvd;
> >         dma_addr_t iova = vaddr - dma->vaddr + dma->iova;
> >
> >         /* This code path is only user initiated */
> >         if (!mm)
> >                 return -ENODEV;
> >
> >         if (batch->size) {
> >                 /* Leftover pages in batch from an earlier call. */
> >                 *pfn_base = page_to_pfn(batch->pages[batch->offset]);
> >                 pfn = *pfn_base;
> >                 rsvd = is_invalid_reserved_pfn(*pfn_base);
> >
> > (4) We're called again and fill our local variables from the batch.  The
> >     batch only has one page, so we'll complete the inner loop below and refill.
> >
> > (6) We're called again, batch->size is 1, but it was for a pfnmap, the pages
> >     array still contains the last pinned page, so we end up incorrectly using
> >     this pfn again for the next entry.
> >
> >         } else {
> >                 *pfn_base = 0;
> >         }
> >
> >         while (npage) {
> >                 if (!batch->size) {
> >                         /* Empty batch, so refill it. */
> >                         long req_pages = min_t(long, npage, batch->capacity);
> >
> >                         ret = vaddr_get_pfns(mm, vaddr, req_pages, dma->prot,
> >                                              &pfn, batch->pages);
> >                         if (ret < 0)
> >                                 goto unpin_out;
> >
> > (2) Assume the 1st page is pfnmap, the 2nd is pinned memory  
> 
> Just to check we're on the same wavelength, I think you can hit this bug
> with one less call to vfio_pin_pages_remote() if the 1st page in the
> vaddr range is pinned memory and the 2nd is pfnmap.  Then you'd have the
> following sequence:
> 
> vfio_pin_pages_remote() call #1:
> 
>  - In the first batch refill, you'd get a size=1 batch with pinned
>    memory and complete the inner loop, breaking at "if (!batch->size)".
>    
>  - In the second batch refill, you'd get another size=1 batch with a
>    pfnmap page, take the "goto unpin_out" in the inner loop, and return
>    from the function with the batch still containing a single pfnmap
>    page.
> 
> vfio_pin_pages_remote() call #2:
> 
>  - *pfn_base is set from the first element of the pages array, which
>     unfortunately has the non-pfnmap pfn.
> 
> Did I follow you?

Yep, I should have simplified to skip the first mapping, but I was also
trying to make sure I made sense of the test case I was playing with
that triggered it.  The important transition is pinned memory to pfnmap
since that let's us return with non-zero batch size and stale data in
the pages array.

> >
> >                         batch->size = ret;
> >                         batch->offset = 0;
> >
> >                         if (!*pfn_base) {
> >                                 *pfn_base = pfn;
> >                                 rsvd = is_invalid_reserved_pfn(*pfn_base);
> >                         }
> >                 }
> >
> >                 /*
> >                  * pfn is preset for the first iteration of this inner loop and
> >                  * updated at the end to handle a VM_PFNMAP pfn.  In that case,
> >                  * batch->pages isn't valid (there's no struct page), so allow
> >                  * batch->pages to be touched only when there's more than one
> >                  * pfn to check, which guarantees the pfns are from a
> >                  * !VM_PFNMAP vma.
> >                  */
> >                 while (true) {
> >                         if (pfn != *pfn_base + pinned ||
> >                             rsvd != is_invalid_reserved_pfn(pfn))
> >                                 goto out;
> >
> > (3) On the 2nd page, both tests are probably true here, so we take this goto,
> >     leaving the batch with the next page.
> >
> > (5) Now we've refilled batch, but the next page is pfnmap, so likely both of the
> >     above tests are true... but this is a pfnmap'ing!
> >
> > (7) Do we add something like if (batch->size == 1 && !batch->offset) {
> >     put_pfn(pfn, dma->prot); batch->size = 0; }?  
> 
> Yes, that could work, maybe with a check for a pfnmap mapping (rsvd)
> instead of those two conditions.

@rsvd could work as well, but unfortunately means we'll call
is_invalid... even if we just have a discontinuity.
 
> I'd rejected two approaches where the batch stores pfns instead of
> pages.  Allocating two pages (one for pages, one for pfns) seems
> overkill, though the allocation is transient.  Using a union for "struct
> page **pages" and "unsigned long *pfns" seems fragile due to the sizes
> of each type needing to match, and possibly slow from having to loop
> over the array twice (once to convert them all after pin_user_pages and
> again for the inner loop).  Neither seem much better, at least to me,
> even with this bug as additional motivation.
> 
> It'd be better if pup returned pfns in some form, but that's another
> issue entirely.

It is a little curious that vfio_batch_unpin() converts pages to pfn,
only to call a function that converts them back to pages for unpinning,
when those pages should never trigger the pfnmap bypass.  I think
that's only an error path too, so it seems unnecessary to clear them as
dirty regardless of the DMA mapping protections.  At some point we'll
want to include pfnmap batches too, but only after we get rid of
follow_pte() lookups for them.

> >
> >                         /*
> >                          * Reserved pages aren't counted against the user,
> >                          * externally pinned pages are already counted against
> >                          * the user.
> >                          */
> >                         if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> >                                 if (!dma->lock_cap &&
> >                                     mm->locked_vm + lock_acct + 1 > limit) {
> >                                         pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >                                                 __func__, limit << PAGE_SHIFT);
> >                                         ret = -ENOMEM;
> >                                         goto unpin_out;
> >                                 }
> >                                 lock_acct++;
> >                         }
> >
> >                         pinned++;
> >                         npage--;
> >                         vaddr += PAGE_SIZE;
> >                         iova += PAGE_SIZE;
> >                         batch->offset++;
> >                         batch->size--;
> >
> >                         if (!batch->size)
> >                                 break;
> >
> >                         pfn = page_to_pfn(batch->pages[batch->offset]);
> >                 }
> >
> >                 if (unlikely(disable_hugepages))
> >                         break;
> >         }
> >
> > out:
> >         ret = vfio_lock_acct(dma, lock_acct, false);
> >
> > unpin_out:
> >         if (ret < 0) {
> >                 if (pinned && !rsvd) {
> >                         for (pfn = *pfn_base ; pinned ; pfn++, pinned--)
> >                                 put_pfn(pfn, dma->prot);
> >                 }
> >                 vfio_batch_unpin(batch, dma);
> >
> > (8) These calls to batch_unpin are rather precarious as well, any time batch->size is
> >     non-zero, we risk using the pages array for a pfnmap.  We might actually want the
> >     above change in (7) moved into this exit path so that we can never return a potential
> >     pfnmap batch.  
> 
> Yes, the exit path seems like the right place for the fix.
> 
> >
> >                 return ret; }
> >
> >         return pinned;
> > }
> >
> > This is a regression that not only causes incorrect mapping for the
> > user, but also allows the user to trigger bad page counts, so we need
> > a fix for v5.12.  
> 
> Sure, I can test a fix after I get your thoughts on the above.

I think you've got the right idea about my concern above.  Thanks,

Alex

