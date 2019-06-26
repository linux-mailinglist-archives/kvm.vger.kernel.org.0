Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA685686C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFZMQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:16:16 -0400
Received: from foss.arm.com ([217.140.110.172]:59746 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZMQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:16:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B65D1360;
        Wed, 26 Jun 2019 05:16:14 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46C4C3F718;
        Wed, 26 Jun 2019 05:16:14 -0700 (PDT)
Date:   Wed, 26 Jun 2019 14:16:13 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Jerome Glisse <jglisse@redhat.com>
Subject: Re: Reference count on pages held in secondary MMUs
Message-ID: <20190626121612.GB29851@e113682-lin.lund.arm.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
 <20190609174024.GA4785@redhat.com>
 <20190611115132.GB5318@e113682-lin.lund.arm.com>
 <20190622191136.GB32455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622191136.GB32455@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 22, 2019 at 03:11:36PM -0400, Andrea Arcangeli wrote:
> Hello Christoffer,
> 
> On Tue, Jun 11, 2019 at 01:51:32PM +0200, Christoffer Dall wrote:
> > Sorry, what does this mean?  Do you mean that we can either do:
> > 
> >   on_vm_s2_fault() {
> >       page = gup();
> >       map_page_in_s2_mmu();
> >       put_page();
> >   }
> > 
> >   mmu_notifier_invalidate() {
> >       unmap_page_in_s2_mmu();
> >   }
> > 
> > or
> > 
> >   on_vm_s2_fault() {
> >       page = gup();
> >       map_page_in_s2_mmu();
> >   }
> > 
> >   mmu_notifier_invalidate() {
> >       unmap_page_in_s2_mmu();
> >       put_page();
> >   }
> 
> Yes both work, refcounting always works.
> 
> > > and in fact Jerome also thinks
> > > like me that we should eventually optimize away the FOLL_GET and not
> > > take the refcount in the first place, 
> > 
> > So if I understood the above correct, the next point is that there are
> > advantages to avoiding keeping the extra reference on that page, because
> > we have problematic race conditions related to set_page_dirty(), and we
> > can reduce the problem of race conditions further by not getting a
> > reference on the page at all when going GUP as part of a KVM fault?
> 
> You could still keep the extra reference until the
> invalidate.
> 
> The set_page_dirty however if you do in the context of the secondary
> MMU fault (i.e. atomically with the mapping of the page in the
> secondary MMU, with respect of MMU notifier invalidates), it solves
> the whole problem with the ->mkwrite/mkclean and then you can keep a
> GUP long term pin fully safely already. That is a solution that always
> works and becomes guaranteed by design by the MMU notifier not to
> interfere with the _current_ writeback code in the filesystem. It also
> already provides stable pages.
> 

Ok.

> > Can you explain, or provide a pointer to, the root cause of the
> > problem with holding a reference on the page and setting it dirty?
> 
> The filesystem/VM doesn't possibly expect set_page_dirty to be called
> again after it called page_mkclean. Supposedly a wrprotect fault
> should have been generated if somebody tried to write to the page
> under writeback, so page_mkwrite should have run again before you
> could have called set_page_dirty.
> 
> Instead page_mkclean failed to get rid of the long term GUP obtained
> with FOLL_WRITE because it simply can't ask the device to release it
> without MMU notifier, so the device can later still call
> set_page_dirty despite page_mkclean already run.
> 

I see, I'm now able to link this to recent articles on LWN.

> > > but a whole different chapter is
> > > dedicated on the set_page_dirty_lock crash on MAP_SHARED mappings
> > > after long term GUP pins. So since you're looking into how to handle
> > > the page struct in the MMU notifier it's worth mentioning the issues
> > > related to set_page_dirty too.
> > 
> > Is there some background info on the "set_page_dirty_lock crash on
> > MAP_SHARED" ?  I'm having trouble following this without the background.
> 
> Jan Kara leaded the topic explained all the details on this filesystem
> issue at the LSF-MM and also last year.
> 
> Which is what makes me think there can't be too many uses cases that
> require writback to work while long term GUP pin allow some device to
> write to the pages at any given time, if nobody requires this to be
> urgently fixed.
> 
> You can find coverage on lwn and on linux-mm.
> 
> > 
> > > 
> > > To achieve the cleanest writeback fix to avoid crashes in
> > > set_page_dirty_lock on long term secondary MMU mappings that supports
> > > MMU notifier like KVM shadow MMU, the ideal is to mark the page dirty
> > > before establishing a writable the mapping in the secondary MMU like
> > > in the model below.
> > > 
> > > The below solution works also for those secondary MMU that are like a
> > > TLB and if there are two concurrent invalidates on the same page
> > > invoked at the same time (a potential problem Jerome noticed), you
> > > don't know which come out first and you would risk to call
> > > set_page_dirty twice, which would be still potentially kernel crashing
> > > (even if only a theoretical issue like O_DIRECT).
> > 
> > Why is it problematic to call set_page_dirty() twice?  I thought that at
> > worst it would only lead to writing out data to disk unnecessarily ?
> 
> According to Jerome, after the first set_page_dirty returns, writeback
> could start before the second set_page_dirty has been called. So if
> there are additional random later invalidates the next ones shouldn't
> call set_page_dirty again.
> 
> The problem is if you call set_page_dirty in the invalidate, you've
> also to make sure set_page_dirty is being called only once.
> 
> There can be concurrent invalidates for the same page running at the
> same time, while the page fault there is only one that runs atomically
> with respect to the mmu notifier invalidates (under whatever lock that
> serializes the MMU notifier invalidates vs the secondary MMU page fault).
> 
> If you call set_page_dirty twice in a row, you again open the window
> for the writeback to have already called ->page_mkclean on the page
> after the first set_page_dirty, so the second set_page_dirty will
> then crash.
> 
> You can enforce to call it only once if you have sptes (shadow
> pagetables) like in KVM has, so this is not an issue for KVM.
> 

Makes sense.  The key for my understanding was that an atomic
relationship between the page fault and the mmu notifier has to be
enforced.

> > I am also not familiar with a problem related to KVM and O_DIRECT, so
> > I'm having trouble keeping up here as well :(
> 
> There's no problem in KVM and O_DIRECT.
> 
> There's a problem in O_DIRECT itself regardless if it's qemu or any
> other app using it: just the time window is too low to be
> noticeable. It's still a corollary of why we can't run two
> set_page_dirty per page, if there are concurrent MMU notifier
> invalidates.
> 
> > > So the below model
> > > will solve that and it's also valid for KVM/vhost accelleration,
> > > despite KVM can figure out how to issue a single set_page_dirty call
> > > for each spte that gets invalidated by concurrent invalidates on the
> > > same page because it has shadow pagetables and it's not just a TLB.
> > > 
> > >   access = FOLL_WRITE|FOLL_GET
> > > 
> > > repeat:
> > >   page = gup(access)
> > >   put_page(page)
> > > 
> > >   spin_lock(mmu_notifier_lock);
> > >   if (race with invalidate) {
> > >     spin_unlock..
> > >     goto repeat;
> > >   }
> > >   if (access == FOLL_WRITE)
> > >     set_page_dirty(page)
> > >   establish writable mapping in secondary MMU on page
> > >   spin_unlock
> > > 
> > > The above solves the crash in set_page_dirty_lock without having to
> > > modify any filesystem, it should work theoretically safer than the
> > > O_DIRECT short term GUP pin.
> > 
> > That is not exactly how we do things today on the arm64 side.  We do
> > something that looks like:
> 
> The above is the model that solves all problems with writeback
> page_mkclean/mkwrite, provides stable pages to current filesystems,
> regardless of lowlevel implementation details of the mmu notifier
> methods.
> 
> For KVM all models works not only the above one because we have sptes
> to disambiguate which is the first invalidate that has to run
> set_page_dirty.
> 
> > 
> >   /*
> >    * user_mem_abort is our function for a secondary MMU fault that
> >    * resolves to a memslot.
> >    */
> >   user_mem_abort() {
> >       page = gup(access, &writable);
> >       spin_lock(&kvm->mmu_lock);
> >       if (mmu_notifier_retry(kvm, mmu_seq))
> >           goto out; /* run the VM again and see what happens */
> > 
> >       if (writable)
> >           kvm_set_pfn_dirty(page_to_pfn(page));
> >       stage2_set_pte(); /* establish_writable mapping in secondary MMU on page */
> > 
> >   out:
> >       spin_unlock(&kvm_mmu_lock);
> >       put_page(page);
> >   }
> > 
> > Should we rework this to address the race you are refering to, and are
> > other architectures already safe against this?
> 
> Actually it seems you mark the page dirty exactly where I suggested
> above: i.e. atomically with the secondary MMU mapping establishment
> with respect to the mmu notifier invalidates.
> 
> I don't see any problem with the above (well you need to have a way to
> track if you run stage2_set_pte or if you taken "goto out" but the
> above is pseudocode).
> 
> There's a problem however in kvm_set_pfn_dirty common code, it should
> call set_page_dirty not SetPageDirty or it won't do anything in the
> MAP_SHARED filebacked case. The current code is perfectly ok for anon and
> MAP_PRIVATE write=1 cases.
> 
> However FOLL_TOUCH in gup already either calls set_page_dirty or it
> marks the linux pte as dirty, so that's working around the lack of
> set_page_dirty... I wonder if we could just rely on the set_page_dirty
> in gup with FOLL_TOUCH and drop SetPageDirty as a whole in KVM in fact.
> 

I may have misled you with my use of 'gup()' as a function above.  In
reality we use the gfn_to_pfn_prot() wrapper, which means there are
several things going on:

First, it appears we only do pte_mkdirty with FOLL_TOUCH if we also set
FOLL_WRITE.  This seems to be confimed by the commentary on
get_user_pages, which says that set_page_dirty() must be called if a
page is written to, and the page is found without FOLL_WRITE.

Second, KVM first attempts a __get_user_pages_fast(), and if that fails
does get_user_pages_unlocked(), but only sets FOLL_WRITE as part of a
write fauult.  If the page is nevertheless mapped writable, I think we
still need the subsequent set_page_dirty() when a write fault happens on
the secondary mmu.

So I take it you'll send a patch addressing the SetPageDirty to
set_page_dirty problem?


> > > With regard to KVM this should be enough, but we also look for a crash
> > > avoidance solution for those devices that cannot support the MMU
> > > notifier for short and long term GUP pins.
> > 
> > Sorry, can you define short and long term GUP pins, and do we have
> > current examples of both?
> 
> Long term as in mm/gup.c:FOLL_LONGTERM, means you expect to call some
> get_user_pages with FOLL_GET and not release the refcount immediately
> after I/O completion, the page could remain indefinitely pinned,
> virt example: vfio device assignment.
> 
> The most common example of short term GUP (i.e. default behavior of
> GPU) is O_DIRECT. I/O completion takes short time (depends on the
> buffer size of course.. could be 1TB of buffer I/O) but it's still
> going to be released ASAP.
> 
> > > There's lots of work going on on linux-mm, to try to let those devices
> > > support writeback in a safe way (also with stable pages so all fs
> > > integrity checks will pass) using bounce buffer if a long term GUP pin
> > > is detected by the filesystem. In addition there's other work to make
> > > the short term GUP pin theoretically safe by delaying the writeback
> > > for the short window the GUP pin is taken by O_DIRECT, so it becomes
> > > theoretically safe too (currently it's only practically safe).
> > > 
> > > However I'm not sure if the long term GUP pins really needs to support
> > > writeback.
> > > 
> > 
> > I don't think I understand the distinction between a long term GUP pin
> > that supports writeback vs. a short term GUP pin.  My question was
> > whether or not the pin could be dropped at the time the mapping was torn
> > down, or if it has to be done at the same time the mapping is
> > established, for things to work properly wrt. the semantics of memory
> > behavior of the rest of the kernel.
> 
> Yes sorry, the question about the refcounting was just trivial to
> answer: it always works, you can drop the refcount anywhere.
> 
> I just thought if there was any doubt on the refcounting issue which
> had an immediate black and white answer, it was safer to raise
> awareness about the much more troubling and subtle issues with
> set_page_dirty caused by GUP refcounts.
> 

I understand, and thanks for doing that.  I just had to put the pieces
together on my end.

> > I'm not sure if we're talking about the same thing here, or if you're
> > explaining a different scenario?
> 
> Simply KVM secondary MMU fault has to mark the page dirty somehow
> (either in gup itself or in the fault or in the invalidates) in
> addition to dealing the refcount. That's the connection.
> 
> However this set_page_dirty issue needs solution that works both for
> short term GPU pins that can't use mmu notifier (O_DIRECT), long term
> GUP pins that can't use mmu notifier (vfio) and the MMU notifier
> mappings (KVM page fault, whose refcount can be implicitly hold on by
> the MMU notifier itself and in turn the put_page can go anywhere).
> 
> The solution to the O_DIRECT gup pin is also highly connected with the
> GUP refcounting, because the solution is to alter the refcount so that
> the filesystem learns that there's a special refcounting and
> ->page_mkclean can be then deferred as long as the special refcount is
> hold by O_DIRECT. I argue the same special refcount can be also hold
> by long term GUP pins and the MMU notifier KVM page fault case (which
> will either drop FOLL_GET ideally) so we can defer the page_mkwrite
> indefinitely for long term GUP pins too (there will be no deferred
> write in MMU Notifier case because ->page_mkclean invokes the MMU
> notifier invalidates).
> 
> If one wants to flush to disk the dirty MAP_SHARED periodically the
> device needs to be told to drop the refcounts and stop writing to the
> memory. If the device isn't told to stop writing to the memory what
> comes out is only coherent at 512 bytes units or maybe less anyway.
> 

Thanks for the clarification.

    Christoffer
