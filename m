Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E9372E37
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhEDQrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhEDQrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 12:47:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C250C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 09:46:09 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w3so14218685ejc.4
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 09:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHf2ZMKdg9jN9lddyLRTxgJZXNS2YqOTao5Opa455GQ=;
        b=T9ZYSMJszQasjZu5BQFTl0qdpvgJVjvC+LTlMQVCshD1xppdz/PpD07b0kCvqqxvlP
         Ie/qrss3B+O4GCBfQB3V4ezewt3yk3iF6Q+yJrS8GQ46bv+t4s7IuClHBJPX46518mH9
         z+48EQtVfOn5nkJJIen7Jvzoy7hnwnZQ5pqHU2DZMLuk4EXBi/HnMs9XQvydz4Ys+3xB
         mB1FuU91ZGZmEC88zdU783XdS7qrPaY1qYrvaYkAGDq/tuscFb8niDuJWeEeD+WT1SXJ
         IdGnuIRe5tCdhOHNxAV3fdT1jdtbN0khRrWotFq/D23V3ne5TfUtyxt+qiYdsUWxE+ux
         hqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHf2ZMKdg9jN9lddyLRTxgJZXNS2YqOTao5Opa455GQ=;
        b=EH9jb/UL3lF3N0ou6OmmQzLJ/N+XSjJd+W2XeQ3t3Q1EAAKEKiQjHzkzDlCfX3v+Jp
         HPNMEDp7hfq6YrCnAcCAFFHlUgUgZ5XB+h2yMLKI8kb908DmQQL7WejLMmbPS5IlxSLq
         QjL13C8kZOTvn5HJ0Ls/BAII5Ia5d/AnvJ/UBb4HCygZVw/GqzzExK9DKTuYDaG1at7K
         zcjZS1C8X06Thf8qKmTHsrYshQH/e+aYpOK0WHyl5jFrikYmQgSa8dDoaFqLyeJFYL0T
         x9Z9cSTT9OzHTlZxaJVbHio4Ix2RoNTi6LQrCO31qP71SyFIzX7g3NLFFOqt/gDbXPcR
         olFg==
X-Gm-Message-State: AOAM5327W15nnI0XZaAqsEfNRG6QsvM31WwdJL1lrckSxRFvVAxapUgQ
        8XULqY1cDSp07aQr9hBpeoB/HRN4jtXKrxnD7GNvfw==
X-Google-Smtp-Source: ABdhPJyXcx3zNFGneIwhm6L81T/V7HcN2SL2UNAv9pPjNRt9r+THFblmhv9pKa/4PqV1Oen8SPJ/4iPeWF6iFIur5V8=
X-Received: by 2002:a17:907:1c15:: with SMTP id nc21mr4692622ejc.49.1620146767482;
 Tue, 04 May 2021 09:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210430160138.100252-1-kai.huang@intel.com> <CANgfPd_gWYaKbdD-fkLNwCSaVQhgcQaSKOEoG0a2B90GhB03zg@mail.gmail.com>
 <e5814ecab90a3df04ea862dd31927a8f9275af77.camel@intel.com>
In-Reply-To: <e5814ecab90a3df04ea862dd31927a8f9275af77.camel@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 4 May 2021 09:45:55 -0700
Message-ID: <CANgfPd-3a1a4se--+M6fCnfXP0kbbxqpKrv18JVA3UFcxrZ_3g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Fix some return value error in kvm_tdp_mmu_map()
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 3, 2021 at 4:32 PM Kai Huang <kai.huang@intel.com> wrote:
>
> On Mon, 2021-05-03 at 10:07 -0700, Ben Gardon wrote:
> > On Fri, Apr 30, 2021 at 9:03 AM Kai Huang <kai.huang@intel.com> wrote:
> > >
> > > There are couple of issues in current tdp_mmu_map_handle_target_level()
> > > regarding to return value which reflects page fault handler's behavior
> > > -- whether it truely fixed page fault, or fault was suprious, or fault
> > > requires emulation, etc:
> > >
> > > 1) Currently tdp_mmu_map_handle_target_level() return 0, which is
> > >    RET_PF_RETRY, when page fault is actually fixed.  This makes
> > >    kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> > >    RET_PF_FIXED.
> >
> > Ooof that was an oversight. Thank you for catching that.
>
> Thanks for reviewing.
>
> >
> > >
> > > 2) When page fault is spurious, tdp_mmu_map_handle_target_level()
> > >    currently doesn't return immediately.  This is not correct, since it
> > >    may, for instance, lead to double emulation for a single instruction.
> >
> > Could you please add an example of what would be required for this to
> > happen? What effect would it have?
> > I don't doubt you're correct on this point, just having a hard time
> > pinpointing where the issue is.
>
> Hmm.. After reading your reply, I think I wasn't thinking correctly about the emulation
> part :)
>
> I was thinking the case that two threads simultaneously write to video ram (which is write
> protected and requires emulation) which has been swapped out, in which case one thread
> will succeed with setting up the mapping, and the other will get atomic exchange failure.
> Since both threads are trying to setup the same mapping, I thought in this case for the
> second thread (that gets atomic exchange failure) should just give up. But reading code
> again, and with your reply, I think the right behavior is, actually both threads need to
> do the emulation, because this is the correct behavior.'
>
> That being said, I still believe that for spurious fault, we should return immediately
> (otherwise it is not spurious fault). But I now also believe the spurious fault check in
> existing code happens too early -- it has to be after write protection emulation check.
> And I just checked the mmu_set_spte() code, if I read correctly, it exactly puts spurious
> fault check after write protection emulation check.
>
> Does this make sense?

Yeah, that makes sense. Having to move the emulation check after the
cmpxchg always felt a little weird to me Though I still think it makes
sense since the cmpxchg can fail.

>
> If this looks good to you, I guess it would be better to split this patch into smaller
> patches (for instance, one patch to handle case 1), and one to handle spurious fault
> change)?

That sounds good to me. That would definitely make it easier to review.

>
> >
> > >
> > > 3) One case of spurious fault is missing: when iter->old_spte is not
> > >    REMOVED_SPTE, but still tdp_mmu_set_spte_atomic() fails on atomic
> > >    exchange. This case means the page fault has already been handled by
> > >    another thread, and RET_PF_SPURIOUS should be returned. Currently
> > >    this case is not distinguished with iter->old_spte == REMOVED_SPTE
> > >    case, and RET_PF_RETRY is returned.
> >
> > See comment on this point in the code below.
> >
> > >
> > > Fix 1) by initializing ret to RET_PF_FIXED at beginning. Fix 2) & 3) by
> > > explicitly adding is_removed_spte() check at beginning, and return
> > > RET_PF_RETRY when it is true.  For other two cases (old spte equals to
> > > new spte, and tdp_mmu_set_spte_atomic() fails), return RET_PF_SPURIOUS
> > > immediately.
> > >
> > > Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++-----
> > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index 84ee1a76a79d..a4dc7c9a4ebb 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -905,9 +905,12 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> > >                                           kvm_pfn_t pfn, bool prefault)
> > >  {
> > >         u64 new_spte;
> > > -       int ret = 0;
> > > +       int ret = RET_PF_FIXED;
> > >         int make_spte_ret = 0;
> > >
> > > +       if (is_removed_spte(iter->old_spte))
> > > +               return RET_PF_RETRY;
> > > +
> > >         if (unlikely(is_noslot_pfn(pfn)))
> > >                 new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> > >         else
> > > @@ -916,10 +919,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> > >                                          map_writable, !shadow_accessed_mask,
> > >                                          &new_spte);
> > >
> > > -       if (new_spte == iter->old_spte)
> > > -               ret = RET_PF_SPURIOUS;
> > > -       else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> > > -               return RET_PF_RETRY;
> > > +       if (new_spte == iter->old_spte ||
> > > +                       !tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
> > > +               return RET_PF_SPURIOUS;
> >
> >
> > I'm not sure this is quite right. In mmu_set_spte, I see the following comment:
> >
> > /*
> > * The fault is fully spurious if and only if the new SPTE and old SPTE
> > * are identical, and emulation is not required.
> > */
> >
> > Based on that comment, I think the existing code is correct. Further,
> > if the cmpxchg fails, we have no guarantee that the value that was
> > inserted instead resolved the page fault. For example, if two threads
> > try to fault in a large page, but one access is a write and the other
> > an instruction fetch, the thread with the write might lose the race to
> > install its leaf SPTE to the instruction fetch thread installing a
> > non-leaf SPTE for NX hugepages. In that case the fault might not be
> > spurious and a retry could be needed.
>
> Right. Thanks for educating me :)
>
> >
> > We could do what the fast PF handler does and check
> > is_access_allowed(error_code, spte) with whatever value we lost the
> > cmpxchg to, but I don't know if that's worth doing or not. There's not
> > really much control flow difference between the two return values, as
> > far as I can tell.
> >
> > It looks like we might also be incorrectly incrementing pf_fixed on a
> > spurious PF.
>
> Yes I also think for spurious fault we should return immediately.
>
> >
> > It might be more interesting and accurate to introduce a separate
> > return value for cmpxchg failures, just to see how often vCPUs
> > actually collide like that.
>
> It might be too complicated I guess, and probably won't worth doing that (and given my
> double emulation is wrong).

Maybe something as simple as a stat would actually be a better way to
track that. No hurry to add such a stat though.

>
> >
>
