Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6F14624ED
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhK2WdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbhK2WdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:33:01 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB52C047CD7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:31:25 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i9so18495123ilu.1
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZwz8VlZcf91XLPdN32jjfH7pMGp9/k7Wk1IpaVs++c=;
        b=lDslvUOTS5MZSspyvZcA1nCDPKsYbdfz+nAZrlAO2mrFq1abtL6VijjK8NaqmUuOKc
         tlFsLPW8wz9YO1F0KMrKeOy/oZNw3l6tKPz8rC4UqvE6xCxzGFU1h2U4f4DK4lKM5xVC
         sAWkVUdAA2nT1oDNdEkRHsA5Lv+x66pQ/4rTumqV7eaCqdi7Zr1UyLF6X9ON28NXa7+Q
         Fi4TS8wFnkmON48+z0SBGi6w1bGZ0SOtMg+sxBsmYErkxyiOCOt8zRo7VYCZFk3toGww
         WXCsAJk7tbUj5s9FuOL0+R81ZtP0Hf1AJeqZhgh5ymLhgtbqK8BtUjuR/GIcLkKY2QHb
         04aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZwz8VlZcf91XLPdN32jjfH7pMGp9/k7Wk1IpaVs++c=;
        b=nNIfMMqVEDWw97sCkyQacTHDTAMxJ14p/3LtxmlFeN4SDgqpF7guLjbMYH0YAGpRJb
         JNYI2h1zg7caw6oaQjsU06j5q0UkZ+MAkw2Lpg+J59+nxYk0B+O/kpLtvHQcc22d4RLF
         fi3x5OdZDxl5n88LMTaFOKuE1Y0UqQ2Yb58vX0BCEY7T3WggY+mzBRmhxTJ6egHjXVCO
         ltc913iB0fytCdVCXr65R/n8hvnQlQSUcTHtGqRi9qHGGBBRVQJB/5K1Gjr8ok4XCTbN
         XWgqQG8LM1pLEYBi1BLnRPH+2Ph52zZKLR+hliz/mTQkKRa9hrmEYWWTGL9nX94YaINi
         T1Ig==
X-Gm-Message-State: AOAM5302kL5vGxuQfqpG0mgSQGZvC0jCLG1aPvcjWVQVcLOcmERl+/bm
        3izA25E/GC019ko6iU3CC5R1yI4L+KWMS+l72tU4Iw==
X-Google-Smtp-Source: ABdhPJwwOtAuLKY7YkjBH9HHnc8JTVUwFda1/0TS31wwKeOz72T/XfpO7VX1EFpY3pdMjCISw7Q26Q7Oqmuo+J26IP4=
X-Received: by 2002:a05:6e02:16ca:: with SMTP id 10mr40248148ilx.274.1638210685156;
 Mon, 29 Nov 2021 10:31:25 -0800 (PST)
MIME-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com> <20211115234603.2908381-16-bgardon@google.com>
 <YZ8OpQmB/8k3/Maj@xz-m1.local>
In-Reply-To: <YZ8OpQmB/8k3/Maj@xz-m1.local>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 29 Nov 2021 10:31:14 -0800
Message-ID: <CANgfPd9pK83S+yoRokLg7wiroE6-OkieATTqgGn3yCCzwNFi4A@mail.gmail.com>
Subject: Re: [PATCH 15/15] KVM: x86/mmu: Promote pages in-place when disabling
 dirty logging
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 8:19 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Ben,
>
> On Mon, Nov 15, 2021 at 03:46:03PM -0800, Ben Gardon wrote:
> > When disabling dirty logging, the TDP MMU currently zaps each leaf entry
> > mapping memory in the relevant memslot. This is very slow. Doing the zaps
> > under the mmu read lock requires a TLB flush for every zap and the
> > zapping causes a storm of ETP/NPT violations.
> >
> > Instead of zapping, replace the split large pages with large page
> > mappings directly. While this sort of operation has historically only
> > been done in the vCPU page fault handler context, refactorings earlier
> > in this series and the relative simplicity of the TDP MMU make it
> > possible here as well.
>
> Thanks for this patch, it looks very useful.

Thanks for taking a look!

>
> I've got a few comments below, but before that I've also got one off-topic
> question too; it'll be great if you can help answer.
>
> When I was looking into how the old code recovers the huge pages I found that
> we'll leave the full-zero pgtable page there until the next page fault, then I
> _think_ it'll be released only until the __handle_changed_spte() when we're
> dropping the old spte (handle_removed_tdp_mmu_page).

That seems likely, though Sean's recent series that heavily refactored
zapping probably changed that.

>
> As comment above handle_removed_tdp_mmu_page() showed, at this point IIUC
> current thread should have exclusive ownership of this orphaned and abandoned
> pgtable page, then why in handle_removed_tdp_mmu_page() we still need all the
> atomic operations and REMOVED_SPTE tricks to protect from concurrent access?
> Since that's cmpxchg-ed out of the old pgtable, what can be accessing it
> besides the current thread?

The cmpxchg does nothing to guarantee that other threads can't have a
pointer to the page table, only that this thread knows it's the one
that removed it from the page table. Other threads could still have
pointers to it in two ways:
1. A kernel thread could be in the process of modifying an SPTE in the
page table, under the MMU lock in read mode. In that case, there's no
guarantee that there's not another kernel thread with a pointer to the
SPTE until the end of an RCU grace period.
2. There could be a pointer to the page table in a vCPU's paging
structure caches, which are similar to the TLB but cache partial
translations. These are also cleared out on TLB flush.
Sean's recent series linked the RCU grace period and TLB flush in a
clever way so that we can ensure that the end of a grace period
implies that the necessary flushes have happened already, but we still
need to clear out the disconnected page table with atomic operations.
We need to clear it out mostly to collect dirty / accessed bits and
update page size stats.

>
> >
> > Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
> > of memory per vCPU, this reduces the time required to disable dirty
> > logging from over 45 seconds to just over 1 second. It also avoids
> > provoking page faults, improving vCPU performance while disabling
> > dirty logging.
> >
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c          |  2 +-
> >  arch/x86/kvm/mmu/mmu_internal.h |  4 ++
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 69 ++++++++++++++++++++++++++++++++-
> >  3 files changed, 72 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ef7a84422463..add724aa9e8c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4449,7 +4449,7 @@ static inline bool boot_cpu_is_amd(void)
> >   * the direct page table on host, use as much mmu features as
> >   * possible, however, kvm currently does not do execution-protection.
> >   */
> > -static void
> > +void
> >  build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> >                               int shadow_root_level)
> >  {
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 6563cce9c438..84d439432acf 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -161,4 +161,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> >  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> >
> > +void
> > +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> > +                             int shadow_root_level);
> > +
> >  #endif /* __KVM_X86_MMU_INTERNAL_H */
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 43c7834b4f0a..b15c8cd11cf9 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1361,6 +1361,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
> >               clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
> >  }
> >
> > +static void try_promote_lpage(struct kvm *kvm,
> > +                           const struct kvm_memory_slot *slot,
> > +                           struct tdp_iter *iter)
> > +{
> > +     struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> > +     struct rsvd_bits_validate shadow_zero_check;
> > +     /*
> > +      * Since the TDP  MMU doesn't manage nested PTs, there's no need to
> > +      * write protect for a nested VM when PML is in use.
> > +      */
> > +     bool ad_need_write_protect = false;
>
> Shall we just pass in "false" in make_spte() and just move the comment there?

We could, but given the egregious number of arguments to the function
(totally my fault), I think this is probably a bit more readable.

>
> > +     bool map_writable;
> > +     kvm_pfn_t pfn;
> > +     u64 new_spte;
> > +     u64 mt_mask;
> > +
> > +     /*
> > +      * If addresses are being invalidated, don't do in-place promotion to
> > +      * avoid accidentally mapping an invalidated address.
> > +      */
> > +     if (unlikely(kvm->mmu_notifier_count))
> > +             return;
> > +
> > +     pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
> > +                                &map_writable, NULL);
>
> Should we better check pfn validity and bail out otherwise?  E.g. for atomic I
> think we can also get KVM_PFN_ERR_FAULT when fast-gup failed somehow.

That's an excellent point. We should absolutely do that.

>
> > +
> > +     /*
> > +      * Can't reconstitute an lpage if the consituent pages can't be
> > +      * mapped higher.
> > +      */
> > +     if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
> > +                                                 pfn, PG_LEVEL_NUM))
> > +             return;
> > +
> > +     build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
> > +
> > +     /*
> > +      * In some cases, a vCPU pointer is required to get the MT mask,
> > +      * however in most cases it can be generated without one. If a
> > +      * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
> > +      * In that case, bail on in-place promotion.
> > +      */
> > +     if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
> > +                                                        kvm_is_mmio_pfn(pfn),
> > +                                                        &mt_mask)))
> > +             return;
> > +
> > +     make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
> > +               map_writable, ad_need_write_protect, mt_mask,
> > +               &shadow_zero_check, &new_spte);
> > +
> > +     tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
> > +
> > +     /*
> > +      * Re-read the SPTE to avoid recursing into one of the removed child
> > +      * page tables.
> > +      */
> > +     iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
>
> Is this redundant since it seems the iterator logic handles this already, I'm
> reading try_step_down() here:
>
>         /*
>          * Reread the SPTE before stepping down to avoid traversing into page
>          * tables that are no longer linked from this entry.
>          */
>         iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));

Oh, I had forgotten about that, but it'd be great if it was redundant.
I'll double check.

>
> The rest looks good to me, thanks.

Thanks for your review!

>
> > +}
> > +
> >  /*
> >   * Clear leaf entries which could be replaced by large mappings, for
> >   * GFNs within the slot.
> > @@ -1381,9 +1441,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
> >               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
> >                       continue;
> >
> > -             if (!is_shadow_present_pte(iter.old_spte) ||
> > -                 !is_last_spte(iter.old_spte, iter.level))
> > +             if (!is_shadow_present_pte(iter.old_spte))
> > +                     continue;
> > +
> > +             /* Try to promote the constitutent pages to an lpage. */
> > +             if (!is_last_spte(iter.old_spte, iter.level)) {
> > +                     try_promote_lpage(kvm, slot, &iter);
> >                       continue;
> > +             }
> >
> >               pfn = spte_to_pfn(iter.old_spte);
> >               if (kvm_is_reserved_pfn(pfn) ||
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >
>
> --
> Peter Xu
>
