Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577CD3F1D8D
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 18:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhHSQQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 12:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHSQQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 12:16:21 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8543C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:15:44 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 7so5962763pfl.10
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 09:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a+8DQbljQdz6C1wtyLmjHIS18vmUlHmWntWV+uOShZg=;
        b=l3pUB6JZiIHpBHbzn4RxaBhuLISFp5JubgFnLNNXAekDE0rXkEyTQKf+oZvG4EOi0w
         Q+ehMRXKnD/aajOWlm3XCk3qjB5XB6XUFrD5ABmHmrfcuIOZQdv+snq5+ETkoWUa3GyB
         RA+vcerRIQjrdUSCuDoT0V86OntUaHPe/65UZ+AaRIQmznumJiDUmnsMDsGEPlX9tsrS
         DFkjtWqd2ixgE98aAG0MQUwDMvO+2ULSnei4T4VIc/j9/XTwvlZDWn0B/4/hSVvKSdjk
         S7S9++SOSvgSkc0iS4fWOCU/FsTRSFyH6SZjjV2mYmwfNk9KUkl+dh+p+m8DgCEiL0yU
         nu4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a+8DQbljQdz6C1wtyLmjHIS18vmUlHmWntWV+uOShZg=;
        b=YpVv20lFCfmLSI+F0AvlN+7IGqTUkbVJnA2I2eQB7r1Y9VHVNNGDzYaruBoghuRe38
         6QczYVa7UeIaZgw020sy3oOA8GAGY9fAVQjkhQrw2n+oEJL5M7NeIYkKrjSch5fRNru0
         +6LFFOXtcwScCXLRE8gwg9TqRevx5qFpa5ACrbeHvaz3mDDtwckbJEVeTJ1CijYbRXx+
         q+CtCKsaT8TGaanYjhsA/WAkFJo+1Fb5HbJ3MGjMk6Q9/w2oX8RGVHy5UASlekrhLyLh
         aLKRd0UylIy4CrO6PMuFlHfU5u2r8DP9eaZ9RAzDtGAOhIQ8tpgwMjq5E3AswGqRBlRA
         Xfjg==
X-Gm-Message-State: AOAM532rATtTelkASnb4Rhn3ZdYMsqR2zD5aqxADcwREW7IHZVNkOKD4
        1TkmhNRhA3UJEWvJuzmiJPPLQTMgjNb3V0Pwxut2ZRZdWBo=
X-Google-Smtp-Source: ABdhPJyoQuiSK8WYq9yxlBnjpiA1gRwA7+FJGewUvudQB0PR+c7fb3zjfUcOkjT18F7P7uRHb3LekLyIkqosNFwHfTo=
X-Received: by 2002:a62:36c5:0:b029:32b:83fa:3a3e with SMTP id
 d188-20020a6236c50000b029032b83fa3a3emr15402422pfa.52.1629389743837; Thu, 19
 Aug 2021 09:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203504.2742757-1-dmatlack@google.com> <20210813203504.2742757-6-dmatlack@google.com>
 <e6070335-3f7e-aebd-93cd-3fb42a426425@redhat.com>
In-Reply-To: <e6070335-3f7e-aebd-93cd-3fb42a426425@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 19 Aug 2021 09:15:17 -0700
Message-ID: <CALzav=do97h9LtbWJfDaj0xRv5Ccq5m-bPq0u0=_h8ut=M6Eow@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] KVM: x86/mmu: Avoid memslot lookup in rmap_add
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021 at 5:03 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/08/21 22:35, David Matlack wrote:
> > Avoid the memslot lookup in rmap_add by passing it down from the fault
> > handling code to mmu_set_spte and then to rmap_add.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> I think before doing this we should take another look at the aguments
> for make_spte, set_spte and mmu_set_spte.  St
>
> static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>                          u64 *sptep, unsigned int pte_access, bool write_fault,
>                          int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
>                          bool host_writable)
>
> static int set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>                      u64 *sptep, unsigned int pte_access, int level,
>                      gfn_t gfn, kvm_pfn_t pfn, bool speculative,
>                      bool can_unsync, bool host_writable)
>
> int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
>                       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
>                       bool can_unsync, bool host_writable, bool ad_disabled,
>                       u64 *new_spte)
>
> In particular:
>
> - set_spte should be inlined in its two callers.  The SET_SPTE_*
> flags are overkill if both functions can just call make_spte+mmu_spte_update:
> mmu_set_spte can check *sptep == spte and return RET_PF_SPURIOUS directly,
> while SET_SPTE_NEED_REMOTE_TLB_FLUSH can become just a bool that is
> returned by make_spte.
>
> - level and ad_disabled can be replaced by a single pointer to struct
> kvm_mmu_page (tdp_mmu does not set ad_disabled in page_role_for_level,
> but that's not an issue).
>
> - in mmu_set_spte, write_fault, speculative and host_writable are either
> false/true/true (prefetching) or fault->write, fault->prefault,
> fault->map_writable (pagefault).  So they can be replaced by a single
> struct kvm_page_fault pointer, where NULL means false/true/true.  Then
> if set_spte is inlined, the ugly bool arguments only remain in make_spte
> (minus ad_disabled).
>
> This does not remove the need for a separate slot parameter,
> but at least the balance is that there are no extra arguments to
> make_spte (two go, level and ad_disabled; two come, sp and slot).
>
> I've started hacking on the above, but didn't quite finish.  I'll
> keep patches 4-6 in my queue, but they'll have to wait for 5.15.

Ack. 5.15 sounds good. Let me know if you want any helping with testing.

>
> Paolo
>
> > ---
> >   arch/x86/kvm/mmu/mmu.c         | 29 ++++++++---------------------
> >   arch/x86/kvm/mmu/paging_tmpl.h | 12 +++++++++---
> >   2 files changed, 17 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index c148d481e9b5..41e2ef8ad09b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1630,16 +1630,15 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >
> >   #define RMAP_RECYCLE_THRESHOLD 1000
> >
> > -static void rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> > +static void rmap_add(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> > +                  u64 *spte, gfn_t gfn)
> >   {
> > -     struct kvm_memory_slot *slot;
> >       struct kvm_mmu_page *sp;
> >       struct kvm_rmap_head *rmap_head;
> >       int rmap_count;
> >
> >       sp = sptep_to_sp(spte);
> >       kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
> > -     slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >       rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
> >       rmap_count = pte_list_add(vcpu, spte, rmap_head);
> >
> > @@ -2679,9 +2678,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >       return ret;
> >   }
> >
> > -static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> > -                     unsigned int pte_access, bool write_fault, int level,
> > -                     gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> > +static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
> > +                     u64 *sptep, unsigned int pte_access, bool write_fault,
> > +                     int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> >                       bool host_writable)
> >   {
> >       int was_rmapped = 0;
> > @@ -2744,24 +2743,12 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >
> >       if (!was_rmapped) {
> >               kvm_update_page_stats(vcpu->kvm, level, 1);
> > -             rmap_add(vcpu, sptep, gfn);
> > +             rmap_add(vcpu, slot, sptep, gfn);
> >       }
> >
> >       return ret;
> >   }
> >
> > -static kvm_pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                  bool no_dirty_log)
> > -{
> > -     struct kvm_memory_slot *slot;
> > -
> > -     slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
> > -     if (!slot)
> > -             return KVM_PFN_ERR_FAULT;
> > -
> > -     return gfn_to_pfn_memslot_atomic(slot, gfn);
> > -}
> > -
> >   static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
> >                                   struct kvm_mmu_page *sp,
> >                                   u64 *start, u64 *end)
> > @@ -2782,7 +2769,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
> >               return -1;
> >
> >       for (i = 0; i < ret; i++, gfn++, start++) {
> > -             mmu_set_spte(vcpu, start, access, false, sp->role.level, gfn,
> > +             mmu_set_spte(vcpu, slot, start, access, false, sp->role.level, gfn,
> >                            page_to_pfn(pages[i]), true, true);
> >               put_page(pages[i]);
> >       }
> > @@ -2979,7 +2966,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >                       account_huge_nx_page(vcpu->kvm, sp);
> >       }
> >
> > -     ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
> > +     ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
> >                          fault->write, fault->goal_level, base_gfn, fault->pfn,
> >                          fault->prefault, fault->map_writable);
> >       if (ret == RET_PF_SPURIOUS)
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 50ade6450ace..653ca44afa58 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -561,6 +561,7 @@ static bool
> >   FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >                    u64 *spte, pt_element_t gpte, bool no_dirty_log)
> >   {
> > +     struct kvm_memory_slot *slot;
> >       unsigned pte_access;
> >       gfn_t gfn;
> >       kvm_pfn_t pfn;
> > @@ -573,8 +574,13 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >       gfn = gpte_to_gfn(gpte);
> >       pte_access = sp->role.access & FNAME(gpte_access)(gpte);
> >       FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
> > -     pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
> > +
> > +     slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
> >                       no_dirty_log && (pte_access & ACC_WRITE_MASK));
> > +     if (!slot)
> > +             return false;
> > +
> > +     pfn = gfn_to_pfn_memslot_atomic(slot, gfn);
> >       if (is_error_pfn(pfn))
> >               return false;
> >
> > @@ -582,7 +588,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >        * we call mmu_set_spte() with host_writable = true because
> >        * pte_prefetch_gfn_to_pfn always gets a writable pfn.
> >        */
> > -     mmu_set_spte(vcpu, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
> > +     mmu_set_spte(vcpu, slot, spte, pte_access, false, PG_LEVEL_4K, gfn, pfn,
> >                    true, true);
> >
> >       kvm_release_pfn_clean(pfn);
> > @@ -749,7 +755,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >               }
> >       }
> >
> > -     ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, fault->write,
> > +     ret = mmu_set_spte(vcpu, fault->slot, it.sptep, gw->pte_access, fault->write,
> >                          it.level, base_gfn, fault->pfn, fault->prefault,
> >                          fault->map_writable);
> >       if (ret == RET_PF_SPURIOUS)
> >
>
