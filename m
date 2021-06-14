Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21FE3A6DD8
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 19:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhFNSAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 14:00:02 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:37647 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhFNSAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 14:00:01 -0400
Received: by mail-il1-f170.google.com with SMTP id x12so10318928ill.4
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJkdLjuxH4ToxgQOGIkUb01NFZTkVpleMBFAOA6+EQs=;
        b=hROWaGFJUrYzxWCe3CbmymQQJPN4SvkMecKq/5KPKfFheeuq+J2hQvOYBSc/nY6Ybj
         Sd8Bw4wTcT01PTrFUidGBpjpCT2rZ3koqjnjO/2hzrdeizWfz8O4k081OpHNeFlLLjZc
         5IuMnB39xhxeIfEgjh72DdaZManHjbmpFOHcOP1OoJ+tlViaBeqR4q3Tqb0g6Q0YnEZ4
         C9+tVVKmOLRLMoADjByBT0pySmRlNxiwBkIcwXJa759TZuvdXFsp+swhXIR6Zct25FtJ
         IwKG7yCM7OVIX6/AWG85RlLSQr7Z3dTQGgEWMa5OdRWUQPnCIKhn7t3RFsxB2ZSJfDVd
         JQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJkdLjuxH4ToxgQOGIkUb01NFZTkVpleMBFAOA6+EQs=;
        b=Y7f8l+dHQtQ5zl0JpcJj4jQjdHQRDNwACJ0Icb7pcj6QWDXFmkrzGgbbZgiGYALhJe
         hIojpNfnGcxLCwbHn5Wq2R+l/1e0cbeDzJJnVR2hmdHRN5kYuxN9RGoRwvq0J6gT1PVQ
         mlYxeR/KqQS6q1XmJUt4THTSfbAJyVLdUGMZP0QMyezqEuzRoPP6e2re3kiJ009TI6d8
         ZcYVPRmIEv6vUzowRLKB1okHrOZBEQGDo4tj5cPW5Af/+hIMBloqWFk5bQT7eMCT7NsF
         fcSDduTJegYNeyt1KSa7GcKWyJfPjTP6lNHs5xgiauPJcHmdQkOQyF6ysaWgz/V1F210
         RxFQ==
X-Gm-Message-State: AOAM5339SBQprzxrfU1cJxeu3YyUMqMUlBs0aq/SK17M+HRDQl+PDm8M
        34xjvMns69AzF7Yzky4f1VcH/x1iqJ3uC42+xyP4pg==
X-Google-Smtp-Source: ABdhPJwbU/98a4I5RwNC5KWib9czcveCRXJEo0XxVqvaf/ZQxZpaXNtVd6PXmuBFObNvwsnDgsfmWvyjY5HIfcIoeVg=
X-Received: by 2002:a92:d24c:: with SMTP id v12mr15760646ilg.306.1623693418184;
 Mon, 14 Jun 2021 10:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com> <20210611235701.3941724-7-dmatlack@google.com>
 <CALzav=embwx9PoZrMSS3XkQsFjnAu4UyG8VBY=3yj8uqzKBgRg@mail.gmail.com>
In-Reply-To: <CALzav=embwx9PoZrMSS3XkQsFjnAu4UyG8VBY=3yj8uqzKBgRg@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 14 Jun 2021 10:56:47 -0700
Message-ID: <CANgfPd97iUUduRi-faL4i3fMov7f67iU_LheeJzYoW=QnaHXLg@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: x86/mmu: fast_page_fault support for the TDP MMU
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 4:59 PM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Jun 11, 2021 at 4:57 PM David Matlack <dmatlack@google.com> wrote:
> >
> > This commit enables the fast_page_fault handler to work when the TDP MMU
> > is enabled by leveraging the new walk_shadow_page_lockless* API to
> > collect page walks independent of the TDP MMU.
> >
> > fast_page_fault was already using
> > walk_shadow_page_lockless_{begin,end}(), we just have to change the
> > actual walk to use walk_shadow_page_lockless() which does the right
> > thing if the TDP MMU is in use.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Adding this feature was suggested by Ben Gardon:
>
> Suggested-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++-------------------------
> >  1 file changed, 21 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 765f5b01768d..5562727c3699 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -657,6 +657,9 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >         local_irq_enable();
> >  }
> >
> > +static bool walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > +                                     struct shadow_page_walk *walk);
> > +
> >  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> >  {
> >         int r;
> > @@ -2967,14 +2970,9 @@ static bool page_fault_can_be_fast(u32 error_code)
> >   * Returns true if the SPTE was fixed successfully. Otherwise,
> >   * someone else modified the SPTE from its original value.
> >   */
> > -static bool
> > -fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > -                       u64 *sptep, u64 old_spte, u64 new_spte)
> > +static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, gpa_t gpa,
> > +                                   u64 *sptep, u64 old_spte, u64 new_spte)
> >  {
> > -       gfn_t gfn;
> > -
> > -       WARN_ON(!sp->role.direct);
> > -
> >         /*
> >          * Theoretically we could also set dirty bit (and flush TLB) here in
> >          * order to eliminate unnecessary PML logging. See comments in
> > @@ -2990,14 +2988,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >         if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
> >                 return false;
> >
> > -       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
> > -               /*
> > -                * The gfn of direct spte is stable since it is
> > -                * calculated by sp->gfn.
> > -                */
> > -               gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> > -               kvm_vcpu_mark_page_dirty(vcpu, gfn);
> > -       }
> > +       if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
> > +               kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);

I love how cleanly you've implemented TDP MMU fast PF support here
with so little code duplication. I think this approach will work well.

My only reservation is that this links the way we locklessly change
(and handle changes to) SPTEs between the TDP and legacy MMUs.

fast_pf_fix_direct_spte is certainly a much simpler function than
tdp_mmu_set_spte_atomic, but it might be worth adding a comment
explaining that the function can modify SPTEs in a TDP MMU paging
structure. Alternatively, fast_page_fault could call
tdp_mmu_set_spte_atomic, but I don't know if that would carry a
performance penalty. On the other hand, the handling for this
particular type of SPTE modification is unlikely to change, so it
might not matter.



> >
> >         return true;
> >  }
> > @@ -3019,10 +3011,9 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
> >   */
> >  static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >  {
> > -       struct kvm_shadow_walk_iterator iterator;
> > -       struct kvm_mmu_page *sp;
> >         int ret = RET_PF_INVALID;
> >         u64 spte = 0ull;
> > +       u64 *sptep = NULL;
> >         uint retry_count = 0;
> >
> >         if (!page_fault_can_be_fast(error_code))
> > @@ -3031,17 +3022,19 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >         walk_shadow_page_lockless_begin(vcpu);
> >
> >         do {
> > +               struct shadow_page_walk walk;
> >                 u64 new_spte;
> >
> > -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> > -                       if (!is_shadow_present_pte(spte))
> > -                               break;
> > +               if (!walk_shadow_page_lockless(vcpu, gpa, &walk))
> > +                       break;
> > +
> > +               spte = walk.sptes[walk.last_level];
> > +               sptep = walk.spteps[walk.last_level];
> >
> >                 if (!is_shadow_present_pte(spte))
> >                         break;
> >
> > -               sp = sptep_to_sp(iterator.sptep);
> > -               if (!is_last_spte(spte, sp->role.level))
> > +               if (!is_last_spte(spte, walk.last_level))
> >                         break;
> >
> >                 /*
> > @@ -3084,7 +3077,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >                          *
> >                          * See the comments in kvm_arch_commit_memory_region().
> >                          */
> > -                       if (sp->role.level > PG_LEVEL_4K)
> > +                       if (walk.last_level > PG_LEVEL_4K)
> >                                 break;
> >                 }
> >
> > @@ -3098,8 +3091,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >                  * since the gfn is not stable for indirect shadow page. See
> >                  * Documentation/virt/kvm/locking.rst to get more detail.
> >                  */
> > -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> > -                                           new_spte)) {
> > +               if (fast_pf_fix_direct_spte(vcpu, gpa, sptep, spte, new_spte)) {
> >                         ret = RET_PF_FIXED;
> >                         break;
> >                 }
> > @@ -3112,7 +3104,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >
> >         } while (true);
> >
> > -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> > +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
> >         walk_shadow_page_lockless_end(vcpu);
> >
> >         return ret;
> > @@ -3748,11 +3740,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >         if (page_fault_handle_page_track(vcpu, error_code, gfn))
> >                 return RET_PF_EMULATE;
> >
> > -       if (!is_vcpu_using_tdp_mmu(vcpu)) {
> > -               r = fast_page_fault(vcpu, gpa, error_code);
> > -               if (r != RET_PF_INVALID)
> > -                       return r;
> > -       }
> > +       r = fast_page_fault(vcpu, gpa, error_code);
> > +       if (r != RET_PF_INVALID)
> > +               return r;
> >
> >         r = mmu_topup_memory_caches(vcpu, false);
> >         if (r)
> > --
> > 2.32.0.272.g935e593368-goog
> >
