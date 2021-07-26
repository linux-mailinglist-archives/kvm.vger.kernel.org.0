Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8902F3D686D
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 23:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhGZUZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 16:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhGZUZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 16:25:44 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F1AC061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:06:11 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a13so13634896iol.5
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rkig7bE4hOxzHEgCJPd82apljPN10pQgvqX3gsxGQr8=;
        b=Dc1ZNs5zRFS+ENDVWCGOlGoSGiMpxdR7eVys+pUw/0VgibLj7iYul3jE5hlZLZ5IqY
         Ve9c4GJ/vNyHDdYgCSxe6N4QoCJ784+vSsXyPptEYwHSUNmsgO8n+gr1pcR9dcLVFMau
         V5yO+pytXFDojUXypN6sd+/D1J2EFMgsz1Z2X/zO505WAARzHskCULPZy6nWnESomYd7
         blbB67Kd/cSiXf2mQo0FHyL3TpTZ3Vz8BaDclFuMgb6PHcukr3O94YuE0VO9yYjx50n5
         oO60e1Qwn7AURxIN0RLvfcV/IhfuXdEWrU5O0SB673yMTW0P7mZCGZJZ8ULLQ59L1zCy
         yIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rkig7bE4hOxzHEgCJPd82apljPN10pQgvqX3gsxGQr8=;
        b=IZNCwdudu7e6G8DX9ZzAUOs4LglyvyAy/YOoZEVJyj3vdxqqMLQAGVpLJEY2tGDuwb
         L+o2L+aZhkysbqVUASvopRhwmyvwnQdrQ0qTHzH+AcmLXXkwxefIAxw6Vvg1OzKU6uWo
         Lw0jFiGtaUNRrJLfzTSlPelK+OhJZck1yOf/Q8Fa3yvlm4zXJf4PyzbsEdI0BHmOUEcb
         4RmIEc0emwG7mml6Ov2W7gKiJOe89iuZiFjNofacwsUF9puGPgwYGqIxWsHxUJN+9wH6
         0leZSWa3syv2/RdR9rquLkfodH9mEe6ylzhwm+qaAUT8UyErktfRyCay96YG9nG9+ynW
         I+KA==
X-Gm-Message-State: AOAM531B9z+4C2Jn6e3kUYgGOJ5gosTGwGVB6JHaAFrAgmWu3Se3JK2e
        RIyLc4d8bbvi1bGVNtS+IMr/Qg7rP56tP3+sno2sRA==
X-Google-Smtp-Source: ABdhPJxHQ4/K8JqyV+8xDhbhj04xPAp2EiPk5By73klotblAAQyaQoPbqIelufbMjYI1TcjgvZiX+UFVw22JoXT+nrA=
X-Received: by 2002:a5e:c912:: with SMTP id z18mr16302923iol.9.1627333571083;
 Mon, 26 Jul 2021 14:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210726175357.1572951-1-mizhang@google.com> <20210726175357.1572951-4-mizhang@google.com>
 <CANgfPd8iohgpauQEEAFAQjLPXqHQw1Swguc7C0exHcz985igcw@mail.gmail.com>
In-Reply-To: <CANgfPd8iohgpauQEEAFAQjLPXqHQw1Swguc7C0exHcz985igcw@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 26 Jul 2021 14:06:00 -0700
Message-ID: <CANgfPd9PD4pLkZ9zLWHRmWRk2uJ3qvqZaio0C_hs7g161NmOow@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 1:41 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Mon, Jul 26, 2021 at 10:54 AM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > Existing KVM code tracks the number of large pages regardless of their
> > sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> > information becomes less useful because lpages counts a mix of 1G and 2M
> > pages.
> >
> > So remove the lpages since it is easy for user space to aggregate the info.
> > Instead, provide a comprehensive page stats of all sizes from 4K to 512G.
> >
> > Suggested-by: Ben Gardon <bgardon@google.com>
> > Suggested-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>

Besides the check which can be dropped in mmu_spte_clear_track_bits,
this looks good to me.

Reviewed-by: Ben Gardon <bgardon@google.com>

> > ---
> >  arch/x86/include/asm/kvm_host.h | 10 +++++++++-
> >  arch/x86/kvm/mmu.h              |  2 ++
> >  arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 15 ++-------------
> >  arch/x86/kvm/x86.c              |  7 +++++--
> >  5 files changed, 37 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 974cbfb1eefe..2e4b6fd36e62 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1206,9 +1206,17 @@ struct kvm_vm_stat {
> >         u64 mmu_recycled;
> >         u64 mmu_cache_miss;
> >         u64 mmu_unsync;
> > -       u64 lpages;
> >         u64 nx_lpage_splits;
> >         u64 max_mmu_page_hash_collisions;
> > +       union {
> > +               struct {
> > +                       atomic64_t pages_4k;
> > +                       atomic64_t pages_2m;
> > +                       atomic64_t pages_1g;
> > +                       atomic64_t pages_512g;
> > +               };
> > +               atomic64_t pages[4];
> > +       } page_stats;
> >  };
> >
> >  struct kvm_vcpu_stat {
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 83e6c6965f1e..ad5638815311 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -240,4 +240,6 @@ static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> >         return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
> >  }
> >
> > +void kvm_update_page_stats(struct kvm *kvm, int level, int count);
> > +
> >  #endif
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 442cc554ebd6..7e0fc760739b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -588,16 +588,22 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> >         return flush;
> >  }
> >
> > +void kvm_update_page_stats(struct kvm *kvm, int level, int count)
> > +{
> > +       atomic64_add(count, &kvm->stat.page_stats.pages[level - 1]);
> > +}
> > +
> >  /*
> >   * Rules for using mmu_spte_clear_track_bits:
> >   * It sets the sptep from present to nonpresent, and track the
> >   * state bits, it is used to clear the last level sptep.
> >   * Returns non-zero if the PTE was previously valid.
> >   */
> > -static int mmu_spte_clear_track_bits(u64 *sptep)
> > +static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >  {
> >         kvm_pfn_t pfn;
> >         u64 old_spte = *sptep;
> > +       int level = sptep_to_sp(sptep)->role.level;
> >
> >         if (!spte_has_volatile_bits(old_spte))
> >                 __update_clear_spte_fast(sptep, 0ull);
> > @@ -607,6 +613,9 @@ static int mmu_spte_clear_track_bits(u64 *sptep)
> >         if (!is_shadow_present_pte(old_spte))
> >                 return 0;
> >
> > +       if (is_last_spte(old_spte, level))
>
> You can drop this check since it's part of the contract for calling
> this function.
>
> > +               kvm_update_page_stats(kvm, level, -1);
> > +
> >         pfn = spte_to_pfn(old_spte);
> >
> >         /*
> > @@ -984,9 +993,10 @@ static void __pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
> >         }
> >  }
> >
> > -static void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep)
> > +static void pte_list_remove(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> > +                           u64 *sptep)
> >  {
> > -       mmu_spte_clear_track_bits(sptep);
> > +       mmu_spte_clear_track_bits(kvm, sptep);
> >         __pte_list_remove(sptep, rmap_head);
> >  }
> >
> > @@ -1119,7 +1129,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
> >
> >  static void drop_spte(struct kvm *kvm, u64 *sptep)
> >  {
> > -       if (mmu_spte_clear_track_bits(sptep))
> > +       if (mmu_spte_clear_track_bits(kvm, sptep))
> >                 rmap_remove(kvm, sptep);
> >  }
> >
> > @@ -1129,7 +1139,6 @@ static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
> >         if (is_large_pte(*sptep)) {
> >                 WARN_ON(sptep_to_sp(sptep)->role.level == PG_LEVEL_4K);
> >                 drop_spte(kvm, sptep);
> > -               --kvm->stat.lpages;
> >                 return true;
> >         }
> >
> > @@ -1386,7 +1395,7 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >         while ((sptep = rmap_get_first(rmap_head, &iter))) {
> >                 rmap_printk("spte %p %llx.\n", sptep, *sptep);
> >
> > -               pte_list_remove(rmap_head, sptep);
> > +               pte_list_remove(kvm, rmap_head, sptep);
> >                 flush = true;
> >         }
> >
> > @@ -1421,13 +1430,13 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >                 need_flush = 1;
> >
> >                 if (pte_write(pte)) {
> > -                       pte_list_remove(rmap_head, sptep);
> > +                       pte_list_remove(kvm, rmap_head, sptep);
> >                         goto restart;
> >                 } else {
> >                         new_spte = kvm_mmu_changed_pte_notifier_make_spte(
> >                                         *sptep, new_pfn);
> >
> > -                       mmu_spte_clear_track_bits(sptep);
> > +                       mmu_spte_clear_track_bits(kvm, sptep);
> >                         mmu_spte_set(sptep, new_spte);
> >                 }
> >         }
> > @@ -2232,8 +2241,6 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
> >         if (is_shadow_present_pte(pte)) {
> >                 if (is_last_spte(pte, sp->role.level)) {
> >                         drop_spte(kvm, spte);
> > -                       if (is_large_pte(pte))
> > -                               --kvm->stat.lpages;
> >                 } else {
> >                         child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
> >                         drop_parent_pte(child, spte);
> > @@ -2692,8 +2699,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >         trace_kvm_mmu_set_spte(level, gfn, sptep);
> >
> >         if (!was_rmapped) {
> > -               if (is_large_pte(*sptep))
> > -                       ++vcpu->kvm->stat.lpages;
> > +               kvm_update_page_stats(vcpu->kvm, level, 1);
> >                 rmap_count = rmap_add(vcpu, sptep, gfn);
> >                 if (rmap_count > RMAP_RECYCLE_THRESHOLD)
> >                         rmap_recycle(vcpu, sptep, gfn);
> > @@ -5669,7 +5675,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >                 if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
> >                     sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
> >                                                                pfn, PG_LEVEL_NUM)) {
> > -                       pte_list_remove(rmap_head, sptep);
> > +                       pte_list_remove(kvm, rmap_head, sptep);
> >
> >                         if (kvm_available_flush_tlb_with_range())
> >                                 kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index cba2ab5db2a0..eae404c15364 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -413,7 +413,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >         bool was_leaf = was_present && is_last_spte(old_spte, level);
> >         bool is_leaf = is_present && is_last_spte(new_spte, level);
> >         bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> > -       bool was_large, is_large;
> >
> >         WARN_ON(level > PT64_ROOT_MAX_LEVEL);
> >         WARN_ON(level < PG_LEVEL_4K);
> > @@ -472,18 +471,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >                 return;
> >         }
> >
> > -       /*
> > -        * Update large page stats if a large page is being zapped, created, or
> > -        * is replacing an existing shadow page.
> > -        */
> > -       was_large = was_leaf && is_large_pte(old_spte);
> > -       is_large = is_leaf && is_large_pte(new_spte);
> > -       if (was_large != is_large) {
> > -               if (was_large)
> > -                       atomic64_sub(1, (atomic64_t *)&kvm->stat.lpages);
> > -               else
> > -                       atomic64_add(1, (atomic64_t *)&kvm->stat.lpages);
> > -       }
> > +       if (is_leaf != was_leaf)
> > +               kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
> >
> >         if (was_leaf && is_dirty_spte(old_spte) &&
> >             (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 8166ad113fb2..3858d36d3c49 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -235,9 +235,12 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> >         STATS_DESC_COUNTER(VM, mmu_recycled),
> >         STATS_DESC_COUNTER(VM, mmu_cache_miss),
> >         STATS_DESC_ICOUNTER(VM, mmu_unsync),
> > -       STATS_DESC_ICOUNTER(VM, lpages),
> >         STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
> > -       STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
> > +       STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
> > +       STATS_DESC_ICOUNTER(VM, page_stats.pages_4k),
> > +       STATS_DESC_ICOUNTER(VM, page_stats.pages_2m),
> > +       STATS_DESC_ICOUNTER(VM, page_stats.pages_1g),
> > +       STATS_DESC_ICOUNTER(VM, page_stats.pages_512g)
> >  };
> >  static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
> >                 sizeof(struct kvm_vm_stat) / sizeof(u64));
> > --
> > 2.32.0.432.gabb21c7263-goog
> >
