Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172A1642FB7
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 19:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiLESRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 13:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLESRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 13:17:22 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA712036D
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 10:17:20 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id z17so5637744qki.11
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 10:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OJitEge6k1C0iVW4gatL8mOXDXQMwS9CGkbz56WU6+0=;
        b=FgvEKthHQPUChaUlP88CXRY4aYDEqPiAyGg50ffbTrQGoCmUXRl4cIIs4RcGlR1WiF
         SmueeYl9+PqCWjopBmHYNDgiWGFcugmZjRvKrL695tBcdvDe/b4nDOjCQIFthaEwojHa
         V88Tf0N2liWcv+JGyE58ZTOs3kYvgVRwFp2tzIzANOohFbcrgbGiYxCuXbDrqmOWrDVc
         kK/H6BB++pX5TGfKG2ZupUwiMpe9BDfqzroneonNl7IF0QGW4ixm6opJ1m8ThS5UUeZG
         9i6Gmq006Wh16jlUqpY2zId3bCEBLVgD/oLWFl2ODhsIbORGbdwUh/ALnepahw6QLAgS
         K6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJitEge6k1C0iVW4gatL8mOXDXQMwS9CGkbz56WU6+0=;
        b=o3FTO/rOLKd10GzGPPGTj3UBSFRWF/c3Exc6B6o2orL+U9jw+pcFKhodwpT7RDbY7V
         DVUCGGurw2PXZwWnR0ibec8ZjpJu44qyziVMErfXe2JVF8y8jv+J0ltSAWYDdTarO4B8
         0kMwW6YsQXWOBGoAXasXZhOpn5rirUXp+uf56ITBdfZrWTDTEX1/eu+9ldJfUDajTU9X
         Z1xfNyJ61sy6k0g4Y7yCzqFapbNXuQzCuA1/s3kiKbRevcCC9TaoZN2m7du77Dbb8/gY
         KLoGgTW5nxhxn0PT8mh7jhPd2Tk4vK3rSIvFiiR6pUJYJWH80BS6T4xTfhXCpkM0dDQq
         vSEQ==
X-Gm-Message-State: ANoB5pkd+rf8aSf5klqs/LjXRdghFUgtLlYShLwyWFwcSiFgUecs04Mr
        VaSGp3JbG++BOjdmbdrYUQ/V2HKkd2JE+BwNuWOmuw==
X-Google-Smtp-Source: AA0mqf55JqdXpQS6zQVkmNokw0SRrPtP+h0RULbijxHxItcJ8ecbt5d0TIDwu3JjdNERiYzQXtWpe8yKJ2DNlKS3mW0=
X-Received: by 2002:a37:d246:0:b0:6f6:e7d1:4d1f with SMTP id
 f67-20020a37d246000000b006f6e7d14d1fmr73244242qkj.477.1670264239304; Mon, 05
 Dec 2022 10:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com> <20221201195718.1409782-3-vipinsh@google.com>
In-Reply-To: <20221201195718.1409782-3-vipinsh@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 5 Dec 2022 10:17:08 -0800
Message-ID: <CANgfPd9Khg2tMAfpj18R39cqzerFE6pu+4YUSrYr3KD5FG9zRA@mail.gmail.com>
Subject: Re: [Patch v2 2/2] KVM: x86/mmu: Allocate page table pages on NUMA
 node of underlying pages
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, seanjc@google.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 1, 2022 at 11:57 AM Vipin Sharma <vipinsh@google.com> wrote:
>
> Page table pages of a VM are currently allocated based on the current
> task's NUMA node or its mempolicy. This can cause suboptimal remote
> accesses by the vCPU if it is accessing physical pages local to its NUMA
> node but the page table pages mapping those physcal pages were created
> by some other vCPU which was on different NUMA node or had different
> policy.
>
> Allocate page table pages on the same NUMA node where underlying
> physical page exists. Page table at level 5, 4, and 3 might not end up
> on the same NUMA node as they can span multiple NUMA nodes.
>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu.h              |   1 -
>  arch/x86/kvm/mmu/mmu.c          | 109 ++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h  |   4 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  16 +++--
>  include/linux/kvm_host.h        |   2 +
>  include/linux/kvm_types.h       |   2 +
>  virt/kvm/kvm_main.c             |   7 +-
>  8 files changed, 101 insertions(+), 44 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 283cbb83d6ae..8a0293326abc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -782,7 +782,7 @@ struct kvm_vcpu_arch {
>         struct kvm_mmu *walk_mmu;
>
>         struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> -       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> +       struct kvm_mmu_memory_cache mmu_shadow_page_cache[MAX_NUMNODES];
>         struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>         struct kvm_mmu_memory_cache mmu_page_header_cache;
>
> @@ -1415,7 +1415,7 @@ struct kvm_arch {
>          *
>          * Protected by kvm->slots_lock.
>          */
> -       struct kvm_mmu_memory_cache split_shadow_page_cache;
> +       struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
>         struct kvm_mmu_memory_cache split_page_header_cache;
>
>         /*
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index c960fb096e5c..6bdaacb6faa0 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -119,7 +119,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
>  void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
> -void *kvm_mmu_get_free_page(int nid, gfp_t gfp);
>
>  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0554dfc55553..ff7b17af8ab8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -648,31 +648,43 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
> -       int r;
> +       int r, i;

Nit: nid or node or node_id would be more descriptive than just i.

>
>         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
>         r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
>                                        1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>         if (r)
>                 return r;
> -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -                                      PT64_ROOT_MAX_LEVEL);
> -       if (r)
> -               return r;
> +
> +       for (i = 0; i < MAX_NUMNODES; i++) {
> +               if (node_online(i)) {
> +                       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache[i],
> +                                                      PT64_ROOT_MAX_LEVEL);
> +                       if (r)
> +                               return r;
> +               }
> +       }
> +

Nice, I was worried about wasting cache memory we were never going to
use, but this works great to at least ensure we're not allocating
cached memory for nodes that don't exist.



>         if (maybe_indirect) {
>                 r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
>                                                PT64_ROOT_MAX_LEVEL);
>                 if (r)
>                         return r;
>         }
> +
>         return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
>                                           PT64_ROOT_MAX_LEVEL);
>  }
>
>  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> +       int i;
> +
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +
> +       for (i = 0; i < MAX_NUMNODES; i++)
> +               kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache[i]);
> +
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
>         kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
> @@ -2203,13 +2215,17 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
>
>  static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>                                                     gfn_t gfn,
> -                                                   union kvm_mmu_page_role role)
> +                                                   union kvm_mmu_page_role role,
> +                                                   int nid)
>  {
> -       struct shadow_page_caches caches = {
> -               .page_header_cache = &vcpu->arch.mmu_page_header_cache,
> -               .shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
> -               .shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
> -       };
> +       struct shadow_page_caches caches;
> +
> +       if (nid == NUMA_NO_NODE)
> +               nid = numa_mem_id();
> +
> +       caches.page_header_cache = &vcpu->arch.mmu_page_header_cache;
> +       caches.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache[nid];
> +       caches.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache;
>
>         return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
>  }
> @@ -2262,15 +2278,19 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
>
>  static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
>                                                  u64 *sptep, gfn_t gfn,
> -                                                bool direct, unsigned int access)
> +                                                bool direct, unsigned int access,
> +                                                kvm_pfn_t pfn)
>  {
>         union kvm_mmu_page_role role;
> +       int nid;
>
>         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep))
>                 return ERR_PTR(-EEXIST);
>
>         role = kvm_mmu_child_role(sptep, direct, access);
> -       return kvm_mmu_get_shadow_page(vcpu, gfn, role);
> +       nid = kvm_pfn_to_refcounted_page_nid(pfn);
> +
> +       return kvm_mmu_get_shadow_page(vcpu, gfn, role, nid);
>  }
>
>  static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterator,
> @@ -3153,7 +3173,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 if (it.level == fault->goal_level)
>                         break;
>
> -               sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true, ACC_ALL);
> +               sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn, true,
> +                                         ACC_ALL, fault->pfn);
>                 if (sp == ERR_PTR(-EEXIST))
>                         continue;
>
> @@ -3579,7 +3600,7 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>         WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
>         WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
>
> -       sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
> +       sp = kvm_mmu_get_shadow_page(vcpu, gfn, role, NUMA_NO_NODE);
>         ++sp->root_count;
>
>         return __pa(sp->spt);
> @@ -5853,15 +5874,20 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>
>  int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
> -       int ret;
> +       int ret, i;
>
>         vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
>         vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> +       vcpu->arch.mmu_pte_list_desc_cache.node = NUMA_NO_NODE;
>
>         vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>         vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> +       vcpu->arch.mmu_page_header_cache.node = NUMA_NO_NODE;
>
> -       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +       for (i = 0; i < MAX_NUMNODES; i++) {
> +               vcpu->arch.mmu_shadow_page_cache[i].gfp_zero = __GFP_ZERO;
> +               vcpu->arch.mmu_shadow_page_cache[i].node = i;
> +       }
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
>         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> @@ -6012,7 +6038,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  int kvm_mmu_init_vm(struct kvm *kvm)
>  {
>         struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> -       int r;
> +       int r, i;
>
>         INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>         INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> @@ -6029,20 +6055,29 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>
>         kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
>         kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> +       kvm->arch.split_page_header_cache.node = NUMA_NO_NODE;
> +
> +       for (i = 0; i < MAX_NUMNODES; i++) {
> +               kvm->arch.split_shadow_page_cache[i].gfp_zero = __GFP_ZERO;
> +               kvm->arch.split_shadow_page_cache[i].node = i;
> +       }
>
> -       kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
>
>         kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
>         kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +       kvm->arch.split_desc_cache.node = NUMA_NO_NODE;
>
>         return 0;
>  }
>
>  static void mmu_free_vm_memory_caches(struct kvm *kvm)
>  {
> +       int i;
> +
>         kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
>         kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> -       kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +       for (i = 0; i < MAX_NUMNODES; i++)
> +               kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache[i]);
>  }
>
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
> @@ -6150,7 +6185,7 @@ static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
>         return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
>  }
>
> -static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> +static bool need_topup_split_caches_or_resched(struct kvm *kvm, int nid)
>  {
>         if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
>                 return true;
> @@ -6162,10 +6197,10 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
>          */
>         return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
>                need_topup(&kvm->arch.split_page_header_cache, 1) ||
> -              need_topup(&kvm->arch.split_shadow_page_cache, 1);
> +              need_topup(&kvm->arch.split_shadow_page_cache[nid], 1);
>  }
>
> -static int topup_split_caches(struct kvm *kvm)
> +static int topup_split_caches(struct kvm *kvm, int nid)
>  {
>         /*
>          * Allocating rmap list entries when splitting huge pages for nested
> @@ -6195,16 +6230,19 @@ static int topup_split_caches(struct kvm *kvm)
>         if (r)
>                 return r;
>
> -       return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
> +       return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache[nid], 1);
>  }
>
> -static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
> +static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm,
> +                                                       u64 *huge_sptep,
> +                                                       u64 huge_spte)
>  {
>         struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
>         struct shadow_page_caches caches = {};
>         union kvm_mmu_page_role role;
>         unsigned int access;
>         gfn_t gfn;
> +       int nid;
>
>         gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
>         access = kvm_mmu_page_get_access(huge_sp, spte_index(huge_sptep));
> @@ -6217,9 +6255,13 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
>          */
>         role = kvm_mmu_child_role(huge_sptep, /*direct=*/true, access);
>
> +       nid = kvm_pfn_to_refcounted_page_nid(spte_to_pfn(huge_spte));
> +       if (nid == NUMA_NO_NODE)
> +               nid = numa_mem_id();
> +
>         /* Direct SPs do not require a shadowed_info_cache. */
>         caches.page_header_cache = &kvm->arch.split_page_header_cache;
> -       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> +       caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache[nid];
>
>         /* Safe to pass NULL for vCPU since requesting a direct SP. */
>         return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
> @@ -6238,7 +6280,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
>         gfn_t gfn;
>         int index;
>
> -       sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep);
> +       sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep, huge_spte);
>
>         for (index = 0; index < SPTE_ENT_PER_PAGE; index++) {
>                 sptep = &sp->spt[index];
> @@ -6276,7 +6318,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
>                                           u64 *huge_sptep)
>  {
>         struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> -       int level, r = 0;
> +       int level, r = 0, nid;
>         gfn_t gfn;
>         u64 spte;
>
> @@ -6284,13 +6326,16 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
>         gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
>         level = huge_sp->role.level;
>         spte = *huge_sptep;
> +       nid = kvm_pfn_to_refcounted_page_nid(spte_to_pfn(spte));
> +       if (nid == NUMA_NO_NODE)
> +               nid = numa_mem_id();
>
>         if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES) {
>                 r = -ENOSPC;
>                 goto out;
>         }
>
> -       if (need_topup_split_caches_or_resched(kvm)) {
> +       if (need_topup_split_caches_or_resched(kvm, nid)) {
>                 write_unlock(&kvm->mmu_lock);
>                 cond_resched();
>                 /*
> @@ -6298,7 +6343,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
>                  * rmap iterator should be restarted because the MMU lock was
>                  * dropped.
>                  */
> -               r = topup_split_caches(kvm) ?: -EAGAIN;
> +               r = topup_split_caches(kvm, nid) ?: -EAGAIN;
>                 write_lock(&kvm->mmu_lock);
>                 goto out;
>         }
> @@ -6988,7 +7033,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>                 kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
>
> -void *kvm_mmu_get_free_page(int nid, gfp_t gfp)
> +void *kvm_arch_mmu_get_free_page(int nid, gfp_t gfp)
>  {
>         struct page *spt_page;
>         void *address = NULL;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0f6455072055..1b1039a1b178 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -652,7 +652,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                 table_gfn = gw->table_gfn[it.level - 2];
>                 access = gw->pt_access[it.level - 2];
>                 sp = kvm_mmu_get_child_sp(vcpu, it.sptep, table_gfn,
> -                                         false, access);
> +                                         false, access, fault->pfn);
>
>                 if (sp != ERR_PTR(-EEXIST)) {
>                         /*
> @@ -708,7 +708,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                 validate_direct_spte(vcpu, it.sptep, direct_access);
>
>                 sp = kvm_mmu_get_child_sp(vcpu, it.sptep, base_gfn,
> -                                         true, direct_access);
> +                                         true, direct_access, fault->pfn);
>                 if (sp == ERR_PTR(-EEXIST))
>                         continue;
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1607afbfcc0b..be0763e6b058 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -270,12 +270,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
>                     kvm_mmu_page_as_id(_root) != _as_id) {              \
>                 } else
>
> -static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, int nid)
>  {
>         struct kvm_mmu_page *sp;
>
> +       if (nid == NUMA_NO_NODE)
> +               nid = numa_mem_id();
> +
>         sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache[nid]);
>
>         return sp;
>  }
> @@ -327,7 +330,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>                         goto out;
>         }
>
> -       root = tdp_mmu_alloc_sp(vcpu);
> +       root = tdp_mmu_alloc_sp(vcpu, NUMA_NO_NODE);
>         tdp_mmu_init_sp(root, NULL, 0, role);
>
>         refcount_set(&root->tdp_mmu_root_count, 1);
> @@ -1159,7 +1162,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         struct kvm *kvm = vcpu->kvm;
>         struct tdp_iter iter;
>         struct kvm_mmu_page *sp;
> -       int ret = RET_PF_RETRY;
> +       int ret = RET_PF_RETRY, nid;
>
>         kvm_mmu_hugepage_adjust(vcpu, fault);
>
> @@ -1188,11 +1191,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                     !is_large_pte(iter.old_spte))
>                         continue;
>
> +               nid = kvm_pfn_to_refcounted_page_nid(fault->pfn);
>                 /*
>                  * The SPTE is either non-present or points to a huge page that
>                  * needs to be split.
>                  */
> -               sp = tdp_mmu_alloc_sp(vcpu);
> +               sp = tdp_mmu_alloc_sp(vcpu, nid);
>                 tdp_mmu_init_child_sp(sp, &iter);
>
>                 sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> @@ -1423,7 +1427,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
>         if (!sp)
>                 return NULL;
>
> -       sp->spt = kvm_mmu_get_free_page(nid, gfp);
> +       sp->spt = kvm_arch_mmu_get_free_page(nid, gfp);
>
>         if (!sp->spt) {
>                 kmem_cache_free(mmu_page_header_cache, sp);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 558ded73f660..07674955460b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1374,6 +1374,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>
> +void *kvm_arch_mmu_get_free_page(int nid, gfp_t gfp);
> +
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
>  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 3ca3db020e0e..cb627cf1b4e1 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -96,6 +96,8 @@ struct kvm_mmu_memory_cache {
>         struct kmem_cache *kmem_cache;
>         int capacity;
>         void **objects;
> +       /* Node on which memory should be allocated by default */
> +       int node;
>  };
>  #endif
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1782c4555d94..4d59c9d48277 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -384,6 +384,11 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
>         kvm_arch_guest_memory_reclaimed(kvm);
>  }
>
> +void * __weak kvm_arch_mmu_get_free_page(int nid, gfp_t gfp_flags)
> +{
> +               return (void *)__get_free_page(gfp_flags);
> +}
> +

Rather than making this __weak, you could use #ifdef CONFIG_NUMA to
just put all the code in the arch-neutral function.

>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                                                gfp_t gfp_flags)
> @@ -393,7 +398,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>         if (mc->kmem_cache)
>                 return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
>         else
> -               return (void *)__get_free_page(gfp_flags);
> +               return kvm_arch_mmu_get_free_page(mc->node, gfp_flags);
>  }
>
>  int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> --
> 2.39.0.rc0.267.gcb52ba06e7-goog
>
