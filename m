Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F247557F9D
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiFWQSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 12:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiFWQSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 12:18:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7BE15A0B
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 09:18:06 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t25so34193576lfg.7
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XY1W1mKHWqC6JBhKdaZEdWv44Lzb7X/o82EUgjd//SA=;
        b=JkiFunDM2TCfNuZkrjD3IT0qRgCs8rQZ4pN+xY2TQvxVkjOIhcxSzj3R+0I3zt02ld
         1TKu9fmxY4cuoVYdqngzyNTZJjgkFBJxsRF6p5WVj7fdJzvJ8ApoaEhq2o92Q8r7/9zd
         SMJJaW/CdcxyhpUn4a3VdQSM4Lmgooef/hn18EB3ZbwxgkFDTJss3pflrCic31WvQkkf
         5RpH87rCznFELMHuZP3RXiThh2KiwujffkjtTHw9a/1dAdNDC+yDV6a3mLEktX///Y9+
         mcmzKsdD93JdgA4g1qNkc+8vgxQtcIBLE97MggWaej7UT2bpLjVyHrJnjMcB57w2PIMe
         8Ghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XY1W1mKHWqC6JBhKdaZEdWv44Lzb7X/o82EUgjd//SA=;
        b=z8fDrpq5mvO0nb6JEQrONjlVzPYfWvBQvuGQ//7S4x/FrVUr6x1t6KFkBJiwvIifb0
         WJW6+kh8rKavU+gsuV0hXzP2+il6j9JcOfmaCwkWflfCvA5piMOGZDMSp46YSSZhXc3D
         JPZ9Q9/guTfYCl/DbnJ8knvZ//BTKs+oRHPW/46go2lqT3BRw6uYGUDPrwNgM31YPeqE
         2/FpygJrcoEHAay2ioYj7t41xbC1uFd6u+HUg3Hfqj5OZ1o8JdjHpV2eiFjVtWB14SE8
         kW6eEPow7t7jU1XMViCr/gy9N07s4b+wpuPmtcMZ9vLngFVP3+ROOxHsUTOuO3rugQKJ
         psMQ==
X-Gm-Message-State: AJIora9k/E4BjTj2eNkZPDLgv6ZFWKb8V2Qy+wsnUuYai4p5+YJts0Sm
        R763I7ei2H5GcdSMkCkGYPk5d9UU83Q6apGmO3iCvQ==
X-Google-Smtp-Source: AGRyM1v51tmlNaPRLb/9IynHNT3iJOxkSdiI90POZx1bY+dbQw9ViydYq7Pf3pvVL06ddH8PPgUNlmWoBHKHYrJiTUA=
X-Received: by 2002:a05:6512:3992:b0:47c:48fc:3c62 with SMTP id
 j18-20020a056512399200b0047c48fc3c62mr5880295lfu.102.1656001084812; Thu, 23
 Jun 2022 09:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220622192710.2547152-1-pbonzini@redhat.com> <20220622192710.2547152-23-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-23-pbonzini@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 23 Jun 2022 09:17:38 -0700
Message-ID: <CALzav=fH_9_LKVE0_UCftwy2KZaB3nSBoWU07aPWALag4_mcHQ@mail.gmail.com>
Subject: Re: [PATCH v7 22/23] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> From: David Matlack <dmatlack@google.com>
>
> Add support for Eager Page Splitting pages that are mapped by nested
> MMUs. Walk through the rmap first splitting all 1GiB pages to 2MiB
> pages, and then splitting all 2MiB pages to 4KiB pages.
>
> Note, Eager Page Splitting is limited to nested MMUs as a policy rather
> than due to any technical reason (the sp->role.guest_mode check could
> just be deleted and Eager Page Splitting would work correctly for all
> shadow MMU pages). There is really no reason to support Eager Page
> Splitting for tdp_mmu=N, since such support will eventually be phased
> out, and there is no current use case supporting Eager Page Splitting on
> hosts where TDP is either disabled or unavailable in hardware.
> Furthermore, future improvements to nested MMU scalability may diverge
> the code from the legacy shadow paging implementation. These
> improvements will be simpler to make if Eager Page Splitting does not
> have to worry about legacy shadow paging.
>
> Splitting huge pages mapped by nested MMUs requires dealing with some
> extra complexity beyond that of the TDP MMU:
>
> (1) The shadow MMU has a limit on the number of shadow pages that are
>     allowed to be allocated. So, as a policy, Eager Page Splitting
>     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
>     pages available.
>
> (2) Splitting a huge page may end up re-using an existing lower level
>     shadow page tables. This is unlike the TDP MMU which always allocates
>     new shadow page tables when splitting.
>
> (3) When installing the lower level SPTEs, they must be added to the
>     rmap which may require allocating additional pte_list_desc structs.
>
> Case (2) is especially interesting since it may require a TLB flush,
> unlike the TDP MMU which can fully split huge pages without any TLB
> flushes. Specifically, an existing lower level page table may point to
> even lower level page tables that are not fully populated, effectively
> unmapping a portion of the huge page, which requires a flush.  As of
> this commit, a flush is always done always after dropping the huge page
> and before installing the lower level page table.
>
> This TLB flush could instead be delayed until the MMU lock is about to be
> dropped, which would batch flushes for multiple splits.  However these
> flushes should be rare in practice (a huge page must be aliased in
> multiple SPTEs and have been split for NX Huge Pages in only some of
> them). Flushing immediately is simpler to plumb and also reduces the
> chances of tripping over a CPU bug (e.g. see iTLB multihit).
>
> Suggested-by: Peter Feiner <pfeiner@google.com>
> [ This commit is based off of the original implementation of Eager Page
>   Splitting from Peter in Google's kernel from 2016. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> Message-Id: <20220516232138.1783324-23-dmatlack@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |   3 +-
>  arch/x86/include/asm/kvm_host.h               |  22 ++
>  arch/x86/kvm/mmu/mmu.c                        | 261 +++++++++++++++++-
>  3 files changed, 277 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 97c16aa2f53f..329f0f274e2b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2418,8 +2418,7 @@
>                         the KVM_CLEAR_DIRTY ioctl, and only for the pages being
>                         cleared.
>
> -                       Eager page splitting currently only supports splitting
> -                       huge pages mapped by the TDP MMU.
> +                       Eager page splitting is only supported when kvm.tdp_mmu=Y.
>
>                         Default is Y (on).
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 64efe8c90c31..665667d61caf 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1338,6 +1338,28 @@ struct kvm_arch {
>         u32 max_vcpu_ids;
>
>         bool disable_nx_huge_pages;
> +
> +       /*
> +        * Memory caches used to allocate shadow pages when performing eager
> +        * page splitting. No need for a shadowed_info_cache since eager page
> +        * splitting only allocates direct shadow pages.
> +        *
> +        * Protected by kvm->slots_lock.
> +        */
> +       struct kvm_mmu_memory_cache split_shadow_page_cache;
> +       struct kvm_mmu_memory_cache split_page_header_cache;
> +
> +       /*
> +        * Memory cache used to allocate pte_list_desc structs while splitting
> +        * huge pages. In the worst case, to split one huge page, 512
> +        * pte_list_desc structs are needed to add each lower level leaf sptep
> +        * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> +        * page table.
> +        *
> +        * Protected by kvm->slots_lock.
> +        */
> +#define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> +       struct kvm_mmu_memory_cache split_desc_cache;
>  };
>
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bf1ae5ebf41b..22681931921f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5942,9 +5942,25 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>         node->track_write = kvm_mmu_pte_write;
>         node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>         kvm_page_track_register_notifier(kvm, node);
> +
> +       kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> +       kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> +
> +       kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +
> +       kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> +       kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +
>         return 0;
>  }
>
> +static void mmu_free_vm_memory_caches(struct kvm *kvm)
> +{
> +       kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> +       kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> +       kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +}
> +
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
>  {
>         struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> @@ -5952,6 +5968,8 @@ void kvm_mmu_uninit_vm(struct kvm *kvm)
>         kvm_page_track_unregister_notifier(kvm, node);
>
>         kvm_mmu_uninit_tdp_mmu(kvm);
> +
> +       mmu_free_vm_memory_caches(kvm);
>  }
>
>  static bool __kvm_zap_rmaps(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> @@ -6073,15 +6091,237 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>                 kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>
> +static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> +{
> +       return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> +}
> +
> +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> +{
> +       if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +               return true;
> +
> +       /*
> +        * In the worst case, SPLIT_DESC_CACHE_MIN_NR_OBJECTS descriptors are needed
> +        * to split a single huge page. Calculating how many are actually needed
> +        * is possible but not worth the complexity.
> +        */
> +       return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
> +              need_topup(&kvm->arch.split_page_header_cache, 1) ||
> +              need_topup(&kvm->arch.split_shadow_page_cache, 1);
> +}
> +
> +static int topup_split_caches(struct kvm *kvm)
> +{
> +       int r;
> +
> +       lockdep_assert_held(&kvm->slots_lock);
> +
> +       /*
> +        * It's common to need all SPLIT_DESC_CACHE_MIN_NR_OBJECTS (513) objects
> +        * when splitting a page, but setting capacity == min would cause
> +        * KVM to drop mmu_lock even if just one object was consumed from the
> +        * cache.  So make capacity larger than min and handle two huge pages
> +        * without having to drop the lock.

I was going to do some testing this week to confirm, but IIUC KVM will
only allocate from split_desc_cache if the L1 hypervisor has aliased a
huge page in multiple {E,N}PT12 page table entries. i.e. L1 is mapping
a huge page into an L2 multiple times, or mapped into multiple L2s.
This should be common in traditional, process-level, shadow paging,
but I think will be quite rare for nested shadow paging.

I don't have any objection to using 2x for capacity but I would
recommend dropping the "It's common part ...," part from the comment.


> +        */
> +       r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
> +                                        2 * SPLIT_DESC_CACHE_MIN_NR_OBJECTS,
> +                                        SPLIT_DESC_CACHE_MIN_NR_OBJECTS);
> +       if (r)
> +               return r;
> +
> +       r = kvm_mmu_topup_memory_cache(&kvm->arch.split_page_header_cache, 1);
> +       if (r)
> +               return r;
> +
> +       return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
> +}
> +
> +static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
> +{
> +       struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> +       struct shadow_page_caches caches = {};
> +       union kvm_mmu_page_role role;
> +       unsigned int access;
> +       gfn_t gfn;
> +
> +       gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
> +       access = kvm_mmu_page_get_access(huge_sp, huge_sptep - huge_sp->spt);
> +
> +       /*
> +        * Note, huge page splitting always uses direct shadow pages, regardless
> +        * of whether the huge page itself is mapped by a direct or indirect
> +        * shadow page, since the huge page region itself is being directly
> +        * mapped with smaller pages.
> +        */
> +       role = kvm_mmu_child_role(huge_sptep, /*direct=*/true, access);
> +
> +       /* Direct SPs do not require a shadowed_info_cache. */
> +       caches.page_header_cache = &kvm->arch.split_page_header_cache;
> +       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> +
> +       /* Safe to pass NULL for vCPU since requesting a direct SP. */
> +       return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
> +}
> +
> +static void shadow_mmu_split_huge_page(struct kvm *kvm,
> +                                      const struct kvm_memory_slot *slot,
> +                                      u64 *huge_sptep)
> +
> +{
> +       struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> +       u64 huge_spte = READ_ONCE(*huge_sptep);
> +       struct kvm_mmu_page *sp;
> +       u64 *sptep, spte;
> +       gfn_t gfn;
> +       int index;
> +
> +       sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep);
> +
> +       for (index = 0; index < SPTE_ENT_PER_PAGE; index++) {
> +               sptep = &sp->spt[index];
> +               gfn = kvm_mmu_page_get_gfn(sp, index);
> +
> +               /*
> +                * The SP may already have populated SPTEs, e.g. if this huge
> +                * page is aliased by multiple sptes with the same access
> +                * permissions. These entries are guaranteed to map the same
> +                * gfn-to-pfn translation since the SP is direct, so no need to
> +                * modify them.
> +                *
> +                * If a given SPTE points to a lower level page table, installing
> +                * such SPTEs would effectively unmap a potion of the huge page.
> +                * This is not an issue because __link_shadow_page() flushes the TLB
> +                * when the passed sp replaces a large SPTE.
> +                */
> +               if (is_shadow_present_pte(*sptep))
> +                       continue;
> +
> +               spte = make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
> +               mmu_spte_set(sptep, spte);
> +               __rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
> +       }
> +
> +       __link_shadow_page(kvm, cache, huge_sptep, sp);
> +}
> +
> +static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
> +                                         const struct kvm_memory_slot *slot,
> +                                         u64 *huge_sptep)
> +{
> +       struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> +       int level, r = 0;
> +       gfn_t gfn;
> +       u64 spte;
> +
> +       /* Grab information for the tracepoint before dropping the MMU lock. */
> +       gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
> +       level = huge_sp->role.level;
> +       spte = *huge_sptep;
> +
> +       if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES) {
> +               r = -ENOSPC;
> +               goto out;
> +       }
> +
> +       if (need_topup_split_caches_or_resched(kvm)) {
> +               write_unlock(&kvm->mmu_lock);
> +               cond_resched();
> +               /*
> +                * If the topup succeeds, return -EAGAIN to indicate that the
> +                * rmap iterator should be restarted because the MMU lock was
> +                * dropped.
> +                */
> +               r = topup_split_caches(kvm) ?: -EAGAIN;
> +               write_lock(&kvm->mmu_lock);
> +               goto out;
> +       }
> +
> +       shadow_mmu_split_huge_page(kvm, slot, huge_sptep);
> +
> +out:
> +       trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> +       return r;
> +}
> +
> +static bool shadow_mmu_try_split_huge_pages(struct kvm *kvm,
> +                                           struct kvm_rmap_head *rmap_head,
> +                                           const struct kvm_memory_slot *slot)
> +{
> +       struct rmap_iterator iter;
> +       struct kvm_mmu_page *sp;
> +       u64 *huge_sptep;
> +       int r;
> +
> +restart:
> +       for_each_rmap_spte(rmap_head, &iter, huge_sptep) {
> +               sp = sptep_to_sp(huge_sptep);
> +
> +               /* TDP MMU is enabled, so rmap only contains nested MMU SPs. */
> +               if (WARN_ON_ONCE(!sp->role.guest_mode))
> +                       continue;
> +
> +               /* The rmaps should never contain non-leaf SPTEs. */
> +               if (WARN_ON_ONCE(!is_large_pte(*huge_sptep)))
> +                       continue;
> +
> +               /* SPs with level >PG_LEVEL_4K should never by unsync. */
> +               if (WARN_ON_ONCE(sp->unsync))
> +                       continue;
> +
> +               /* Don't bother splitting huge pages on invalid SPs. */
> +               if (sp->role.invalid)
> +                       continue;
> +
> +               r = shadow_mmu_try_split_huge_page(kvm, slot, huge_sptep);
> +
> +               /*
> +                * The split succeeded or needs to be retried because the MMU
> +                * lock was dropped. Either way, restart the iterator to get it
> +                * back into a consistent state.
> +                */
> +               if (!r || r == -EAGAIN)
> +                       goto restart;
> +
> +               /* The split failed and shouldn't be retried (e.g. -ENOMEM). */
> +               break;
> +       }
> +
> +       return false;
> +}
> +
> +static void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
> +                                               const struct kvm_memory_slot *slot,
> +                                               gfn_t start, gfn_t end,
> +                                               int target_level)
> +{
> +       int level;
> +
> +       /*
> +        * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> +        * down to the target level. This ensures pages are recursively split
> +        * all the way to the target level. There's no need to split pages
> +        * already at the target level.
> +        */
> +       for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> +               slot_handle_level_range(kvm, slot, shadow_mmu_try_split_huge_pages,
> +                                       level, level, start, end - 1, true, false);
> +       }
> +}
> +
>  /* Must be called with the mmu_lock held in write-mode. */
>  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
>                                    const struct kvm_memory_slot *memslot,
>                                    u64 start, u64 end,
>                                    int target_level)
>  {
> -       if (is_tdp_mmu_enabled(kvm))
> -               kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> -                                                target_level, false);
> +       if (!is_tdp_mmu_enabled(kvm))
> +               return;
> +
> +       if (kvm_memslots_have_rmaps(kvm))
> +               kvm_shadow_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
> +
> +       kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, false);
>
>         /*
>          * A TLB flush is unnecessary at this point for the same resons as in
> @@ -6096,12 +6336,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
>         u64 start = memslot->base_gfn;
>         u64 end = start + memslot->npages;
>
> -       if (is_tdp_mmu_enabled(kvm)) {
> -               read_lock(&kvm->mmu_lock);
> -               kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> -               read_unlock(&kvm->mmu_lock);
> +       if (!is_tdp_mmu_enabled(kvm))
> +               return;
> +
> +       if (kvm_memslots_have_rmaps(kvm)) {
> +               write_lock(&kvm->mmu_lock);
> +               kvm_shadow_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
> +               write_unlock(&kvm->mmu_lock);
>         }
>
> +       read_lock(&kvm->mmu_lock);
> +       kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> +       read_unlock(&kvm->mmu_lock);
> +
>         /*
>          * No TLB flush is necessary here. KVM will flush TLBs after
>          * write-protecting and/or clearing dirty on the newly split SPTEs to
> --
> 2.31.1
>
>
