Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9FB3CA65
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 13:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbfFKLvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 07:51:35 -0400
Received: from foss.arm.com ([217.140.110.172]:59358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfFKLve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 07:51:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14D75344;
        Tue, 11 Jun 2019 04:51:34 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A463F557;
        Tue, 11 Jun 2019 04:53:15 -0700 (PDT)
Date:   Tue, 11 Jun 2019 13:51:32 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Jerome Glisse <jglisse@redhat.com>
Subject: Re: Reference count on pages held in secondary MMUs
Message-ID: <20190611115132.GB5318@e113682-lin.lund.arm.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
 <20190609174024.GA4785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609174024.GA4785@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 09, 2019 at 01:40:24PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Sun, Jun 09, 2019 at 11:37:19AM +0200, Paolo Bonzini wrote:
> > On 09/06/19 10:18, Christoffer Dall wrote:
> > > In some sense, we are thus maintaining a 'hidden', or internal,
> > > reference to the page, which is not counted anywhere.
> > > 
> > > I am wondering if it would be equally valid to take a reference on the
> > > page, and remove that reference when unmapping via MMU notifiers, and if
> > > so, if there would be any advantages/drawbacks in doing so?
> > 
> > If I understand correctly, I think the MMU notifier would not fire if
> > you took an actual reference; the page would be pinned in memory and
> > could not be swapped out.
> 
> MMU notifiers still fires, the refcount is simple and can be dropped
> also in the mmu notifier invalidate 

Sorry, what does this mean?  Do you mean that we can either do:

  on_vm_s2_fault() {
      page = gup();
      map_page_in_s2_mmu();
      put_page();
  }

  mmu_notifier_invalidate() {
      unmap_page_in_s2_mmu();
  }

or

  on_vm_s2_fault() {
      page = gup();
      map_page_in_s2_mmu();
  }

  mmu_notifier_invalidate() {
      unmap_page_in_s2_mmu();
      put_page();
  }


> and in fact Jerome also thinks
> like me that we should eventually optimize away the FOLL_GET and not
> take the refcount in the first place, 

So if I understood the above correct, the next point is that there are
advantages to avoiding keeping the extra reference on that page, because
we have problematic race conditions related to set_page_dirty(), and we
can reduce the problem of race conditions further by not getting a
reference on the page at all when going GUP as part of a KVM fault?

Can you explain, or provide a pointer to, the root cause of the
problem with holding a reference on the page and setting it dirty?

> but a whole different chapter is
> dedicated on the set_page_dirty_lock crash on MAP_SHARED mappings
> after long term GUP pins. So since you're looking into how to handle
> the page struct in the MMU notifier it's worth mentioning the issues
> related to set_page_dirty too.

Is there some background info on the "set_page_dirty_lock crash on
MAP_SHARED" ?  I'm having trouble following this without the background.

> 
> To achieve the cleanest writeback fix to avoid crashes in
> set_page_dirty_lock on long term secondary MMU mappings that supports
> MMU notifier like KVM shadow MMU, the ideal is to mark the page dirty
> before establishing a writable the mapping in the secondary MMU like
> in the model below.
> 
> The below solution works also for those secondary MMU that are like a
> TLB and if there are two concurrent invalidates on the same page
> invoked at the same time (a potential problem Jerome noticed), you
> don't know which come out first and you would risk to call
> set_page_dirty twice, which would be still potentially kernel crashing
> (even if only a theoretical issue like O_DIRECT).

Why is it problematic to call set_page_dirty() twice?  I thought that at
worst it would only lead to writing out data to disk unnecessarily ?

I am also not familiar with a problem related to KVM and O_DIRECT, so
I'm having trouble keeping up here as well :(


> So the below model
> will solve that and it's also valid for KVM/vhost accelleration,
> despite KVM can figure out how to issue a single set_page_dirty call
> for each spte that gets invalidated by concurrent invalidates on the
> same page because it has shadow pagetables and it's not just a TLB.
> 
>   access = FOLL_WRITE|FOLL_GET
> 
> repeat:
>   page = gup(access)
>   put_page(page)
> 
>   spin_lock(mmu_notifier_lock);
>   if (race with invalidate) {
>     spin_unlock..
>     goto repeat;
>   }
>   if (access == FOLL_WRITE)
>     set_page_dirty(page)
>   establish writable mapping in secondary MMU on page
>   spin_unlock
> 
> The above solves the crash in set_page_dirty_lock without having to
> modify any filesystem, it should work theoretically safer than the
> O_DIRECT short term GUP pin.

That is not exactly how we do things today on the arm64 side.  We do
something that looks like:

  /*
   * user_mem_abort is our function for a secondary MMU fault that
   * resolves to a memslot.
   */
  user_mem_abort() {
      page = gup(access, &writable);
      spin_lock(&kvm->mmu_lock);
      if (mmu_notifier_retry(kvm, mmu_seq))
          goto out; /* run the VM again and see what happens */

      if (writable)
          kvm_set_pfn_dirty(page_to_pfn(page));
      stage2_set_pte(); /* establish_writable mapping in secondary MMU on page */

  out:
      spin_unlock(&kvm_mmu_lock);
      put_page(page);
  }

Should we rework this to address the race you are refering to, and are
other architectures already safe against this?

> 
> With regard to KVM this should be enough, but we also look for a crash
> avoidance solution for those devices that cannot support the MMU
> notifier for short and long term GUP pins.

Sorry, can you define short and long term GUP pins, and do we have
current examples of both?


> 
> There's lots of work going on on linux-mm, to try to let those devices
> support writeback in a safe way (also with stable pages so all fs
> integrity checks will pass) using bounce buffer if a long term GUP pin
> is detected by the filesystem. In addition there's other work to make
> the short term GUP pin theoretically safe by delaying the writeback
> for the short window the GUP pin is taken by O_DIRECT, so it becomes
> theoretically safe too (currently it's only practically safe).
> 
> However I'm not sure if the long term GUP pins really needs to support
> writeback.
> 

I don't think I understand the distinction between a long term GUP pin
that supports writeback vs. a short term GUP pin.  My question was
whether or not the pin could be dropped at the time the mapping was torn
down, or if it has to be done at the same time the mapping is
established, for things to work properly wrt. the semantics of memory
behavior of the rest of the kernel.

I'm not sure if we're talking about the same thing here, or if you're
explaining a different scenario?


Thanks,

    Christoffer
