Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4887B53AFEB
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiFAVuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiFAVuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:50:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC5CBF71
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 14:50:14 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id d129so3046794pgc.9
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 14:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wtNc6vsdvCONh901oUDxUYMrSPwB6qCC1LifRnPszzE=;
        b=gXjrdBaEUJ4aniM1oO17dFrQzIcqDCt/p0aPX9bbbNiqAki3ZGctCJxBg/scrZxgzy
         wkw6XGE20R7B5ses6wtX2mwpVMeIZhjPHpInaM06VMSoFMFh0BecBIAfvJcjcli6Sznu
         1cjTx8YTC7X/jh6GXnvzOEF79W/2ti9soQxCwMeUwYMXnXUDyCvAoZ5QYa0AtEZPXwUr
         sexRt2loi5uZREoRSekUEt23sbxCN7y4OaEhhPlAlnMFT6Zxfzoc14yaywuVHzuLqGmJ
         ZaZ/8aF+XNVQyuPwqc/vpA1J8z61hDBMrY238xFpunjC9IEV2y92q+0IC900GIiZQDRd
         Vcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wtNc6vsdvCONh901oUDxUYMrSPwB6qCC1LifRnPszzE=;
        b=TgAamYwjRq+mJoh4429OLYchQ91yvX7Ik4wxQONvseN68khvtj2Mi0xDAsyGmsGqCj
         cxHUyOzocLwBSq4XymKHMEhglq5SOKmLTkNPqRocJyQCMZWQixaf/teSE3URkT0YgFrp
         +SVVtiRLxRQPYiKOMj+SrofTjydTiO6HgcUq5S1xAre5nc6Q1f9RpTV2/NmWVCyCt01l
         dp/gdoHiM/dhfxa21UmK1BxAv43vj9Q83RgAonP+hifsBdyoav2UOwJ6Adv3pKqeRBRN
         2Jn1OaFazE7q91yqvsyTyYYb/WaiCEwxPcs6SQ+GD1LucdxEarXxI6y7h/aI//sASxvP
         3NVg==
X-Gm-Message-State: AOAM530/wmcNeTRDY032k+P+rMQYDwtKfGM/pPDCswRtja9GFfHqCVPC
        gVDy3truBZZVA51GJ5HPw71nTw==
X-Google-Smtp-Source: ABdhPJxBE89eXAVr68S29Z79fNidjFx+ZSv6EXZSi54+CPjIC8VWjCZQsIuDii0qQo4ngn3QM4Zb9g==
X-Received: by 2002:a65:6bce:0:b0:3f2:5f88:6f7d with SMTP id e14-20020a656bce000000b003f25f886f7dmr1260962pgw.253.1654120214085;
        Wed, 01 Jun 2022 14:50:14 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a318d00b001e2da6766ecsm4287700pjb.31.2022.06.01.14.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 14:50:13 -0700 (PDT)
Date:   Wed, 1 Jun 2022 14:50:10 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 22/22] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
Message-ID: <YpffEuTSJ3QJwLiy@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-23-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-23-dmatlack@google.com>
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

Hi David,

On Mon, May 16, 2022 at 11:21:38PM +0000, David Matlack wrote:
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
> unmapping a portion of the huge page, which requires a flush.
> 
> This commit performs such flushes after dropping the huge page and
> before installing the lower level page table. This TLB flush could
> instead be delayed until the MMU lock is about to be dropped, which
> would batch flushes for multiple splits.  However these flushes should
> be rare in practice (a huge page must be aliased in multiple SPTEs and
> have been split for NX Huge Pages in only some of them). Flushing
> immediately is simpler to plumb and also reduces the chances of tripping
> over a CPU bug (e.g. see iTLB multihit).
> 
> Suggested-by: Peter Feiner <pfeiner@google.com>
> [ This commit is based off of the original implementation of Eager Page
>   Splitting from Peter in Google's kernel from 2016. ]
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |   3 +-
>  arch/x86/include/asm/kvm_host.h               |  24 ++
>  arch/x86/kvm/mmu/mmu.c                        | 267 +++++++++++++++++-
>  arch/x86/kvm/x86.c                            |   6 +
>  include/linux/kvm_host.h                      |   1 +
>  virt/kvm/kvm_main.c                           |   2 +-
>  6 files changed, 293 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 3f1cc5e317ed..bc3ad3d4df0b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2387,8 +2387,7 @@
>  			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
>  			cleared.
>  
> -			Eager page splitting currently only supports splitting
> -			huge pages mapped by the TDP MMU.
> +			Eager page splitting is only supported when kvm.tdp_mmu=Y.
>  
>  			Default is Y (on).
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9193a700fe2d..ea99e61cc556 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1265,6 +1265,28 @@ struct kvm_arch {
>  	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
>  	 */
>  	u32 max_vcpu_ids;
> +
> +	/*
> +	 * Memory caches used to allocate shadow pages when performing eager
> +	 * page splitting. No need for a shadowed_info_cache since eager page
> +	 * splitting only allocates direct shadow pages.
> +	 *
> +	 * Protected by kvm->slots_lock.
> +	 */
> +	struct kvm_mmu_memory_cache split_shadow_page_cache;
> +	struct kvm_mmu_memory_cache split_page_header_cache;
> +
> +	/*
> +	 * Memory cache used to allocate pte_list_desc structs while splitting
> +	 * huge pages. In the worst case, to split one huge page, 512
> +	 * pte_list_desc structs are needed to add each lower level leaf sptep
> +	 * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> +	 * page table.
> +	 *
> +	 * Protected by kvm->slots_lock.
> +	 */
> +#define SPLIT_DESC_CACHE_CAPACITY 513
> +	struct kvm_mmu_memory_cache split_desc_cache;
>  };
>  
>  struct kvm_vm_stat {
> @@ -1639,6 +1661,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
>  void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
>  void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
>  
> +void free_split_caches(struct kvm *kvm);
> +
>  int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
>  
>  int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 964a8fa63e1b..7c5eab61c4ea 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5966,6 +5966,15 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> +
> +	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> +	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
> +
> +	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +
> +	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
> +	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
> +
>  	return 0;
>  }
>  
> @@ -6097,15 +6106,252 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
>  }
>  
> +void free_split_caches(struct kvm *kvm)
> +{
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
> +	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
> +	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +}
> +
> +static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
> +{
> +	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
> +}
> +
> +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> +{
> +	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> +		return true;
> +
> +	/*
> +	 * In the worst case, SPLIT_DESC_CACHE_CAPACITY descriptors are needed
> +	 * to split a single huge page. Calculating how many are actually needed
> +	 * is possible but not worth the complexity.
> +	 */
> +	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
> +	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
> +	       need_topup(&kvm->arch.split_shadow_page_cache, 1);
> +}
> +
> +static int topup_split_caches(struct kvm *kvm)
> +{
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	r = __kvm_mmu_topup_memory_cache(&kvm->arch.split_desc_cache,
> +					 SPLIT_DESC_CACHE_CAPACITY,
> +					 SPLIT_DESC_CACHE_CAPACITY);
> +	if (r)
> +		return r;
> +
> +	r = kvm_mmu_topup_memory_cache(&kvm->arch.split_page_header_cache, 1);
> +	if (r)
> +		return r;
> +
> +	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
> +}
> +
> +static struct kvm_mmu_page *nested_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
> +{
> +	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> +	struct shadow_page_caches caches = {};
> +	union kvm_mmu_page_role role;
> +	unsigned int access;
> +	gfn_t gfn;
> +
> +	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
> +	access = kvm_mmu_page_get_access(huge_sp, huge_sptep - huge_sp->spt);
> +
> +	/*
> +	 * Note, huge page splitting always uses direct shadow pages, regardless
> +	 * of whether the huge page itself is mapped by a direct or indirect
> +	 * shadow page, since the huge page region itself is being directly
> +	 * mapped with smaller pages.
> +	 */
> +	role = kvm_mmu_child_role(huge_sptep, /*direct=*/true, access);
> +
> +	/* Direct SPs do not require a shadowed_info_cache. */
> +	caches.page_header_cache = &kvm->arch.split_page_header_cache;
> +	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
> +
> +	/* Safe to pass NULL for vCPU since requesting a direct SP. */
> +	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
> +}
> +
> +static void nested_mmu_split_huge_page(struct kvm *kvm,
> +				       const struct kvm_memory_slot *slot,
> +				       u64 *huge_sptep)
> +
> +{
> +	struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> +	u64 huge_spte = READ_ONCE(*huge_sptep);
> +	struct kvm_mmu_page *sp;
> +	bool flush = false;
> +	u64 *sptep, spte;
> +	gfn_t gfn;
> +	int index;
> +
> +	sp = nested_mmu_get_sp_for_split(kvm, huge_sptep);
> +
> +	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> +		sptep = &sp->spt[index];
> +		gfn = kvm_mmu_page_get_gfn(sp, index);
> +
> +		/*
> +		 * The SP may already have populated SPTEs, e.g. if this huge
> +		 * page is aliased by multiple sptes with the same access
> +		 * permissions. These entries are guaranteed to map the same
> +		 * gfn-to-pfn translation since the SP is direct, so no need to
> +		 * modify them.
> +		 *
> +		 * However, if a given SPTE points to a lower level page table,
> +		 * that lower level page table may only be partially populated.
> +		 * Installing such SPTEs would effectively unmap a potion of the
> +		 * huge page. Unmapping guest memory always requires a TLB flush
> +		 * since a subsequent operation on the unmapped regions would
> +		 * fail to detect the need to flush.
> +		 */
> +		if (is_shadow_present_pte(*sptep)) {
> +			flush |= !is_last_spte(*sptep, sp->role.level);
> +			continue;
> +		}
> +
> +		spte = make_huge_page_split_spte(huge_spte, sp->role, index);
> +		mmu_spte_set(sptep, spte);
> +		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
> +	}
> +
> +	/*
> +	 * Replace the huge spte with a pointer to the populated lower level
> +	 * page table. If the lower-level page table indentically maps the huge
> +	 * page (i.e. no memory is unmapped), there's no need for a TLB flush.
> +	 * Otherwise, flush TLBs after dropping the huge page and before
> +	 * installing the shadow page table.
> +	 */
> +	__drop_large_spte(kvm, huge_sptep, flush);
> +	__link_shadow_page(cache, huge_sptep, sp);
> +}
> +
> +static int nested_mmu_try_split_huge_page(struct kvm *kvm,
> +					  const struct kvm_memory_slot *slot,
> +					  u64 *huge_sptep)
> +{
> +	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> +	int level, r = 0;
> +	gfn_t gfn;
> +	u64 spte;
> +
> +	/* Grab information for the tracepoint before dropping the MMU lock. */
> +	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
> +	level = huge_sp->role.level;
> +	spte = *huge_sptep;
> +
> +	if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES) {
> +		r = -ENOSPC;
> +		goto out;
> +	}
> +
> +	if (need_topup_split_caches_or_resched(kvm)) {
> +		write_unlock(&kvm->mmu_lock);
> +		cond_resched();
> +		/*
> +		 * If the topup succeeds, return -EAGAIN to indicate that the
> +		 * rmap iterator should be restarted because the MMU lock was
> +		 * dropped.
> +		 */
> +		r = topup_split_caches(kvm) ?: -EAGAIN;
> +		write_lock(&kvm->mmu_lock);
> +		goto out;
> +	}
> +
> +	nested_mmu_split_huge_page(kvm, slot, huge_sptep);
> +
> +out:
> +	trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> +	return r;
> +}
> +
> +static bool nested_mmu_try_split_huge_pages(struct kvm *kvm,
> +					    struct kvm_rmap_head *rmap_head,
> +					    const struct kvm_memory_slot *slot)
> +{
> +	struct rmap_iterator iter;
> +	struct kvm_mmu_page *sp;
> +	u64 *huge_sptep;
> +	int r;
> +
> +restart:
> +	for_each_rmap_spte(rmap_head, &iter, huge_sptep) {
> +		sp = sptep_to_sp(huge_sptep);
> +
> +		/* TDP MMU is enabled, so rmap only contains nested MMU SPs. */
> +		if (WARN_ON_ONCE(!sp->role.guest_mode))
> +			continue;
> +
> +		/* The rmaps should never contain non-leaf SPTEs. */
> +		if (WARN_ON_ONCE(!is_large_pte(*huge_sptep)))
> +			continue;
> +
> +		/* SPs with level >PG_LEVEL_4K should never by unsync. */
> +		if (WARN_ON_ONCE(sp->unsync))
> +			continue;
> +
> +		/* Don't bother splitting huge pages on invalid SPs. */
> +		if (sp->role.invalid)
> +			continue;
> +
> +		r = nested_mmu_try_split_huge_page(kvm, slot, huge_sptep);
> +
> +		/*
> +		 * The split succeeded or needs to be retried because the MMU
> +		 * lock was dropped. Either way, restart the iterator to get it
> +		 * back into a consistent state.
> +		 */
> +		if (!r || r == -EAGAIN)
> +			goto restart;
> +
> +		/* The split failed and shouldn't be retried (e.g. -ENOMEM). */
> +		break;
> +	}
> +
> +	return false;
> +}
> +
> +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> +						const struct kvm_memory_slot *slot,
> +						gfn_t start, gfn_t end,
> +						int target_level)
> +{
> +	int level;
> +
> +	/*
> +	 * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> +	 * down to the target level. This ensures pages are recursively split
> +	 * all the way to the target level. There's no need to split pages
> +	 * already at the target level.
> +	 */
> +	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> +		slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
> +					level, level, start, end - 1, true, false);
> +	}
> +}
> +
>  /* Must be called with the mmu_lock held in write-mode. */
>  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
>  				   const struct kvm_memory_slot *memslot,
>  				   u64 start, u64 end,
>  				   int target_level)
>  {
> -	if (is_tdp_mmu_enabled(kvm))
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> -						 target_level, false);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	if (kvm_memslots_have_rmaps(kvm))
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
> +
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, false);
>  
>  	/*
>  	 * A TLB flush is unnecessary at this point for the same resons as in
> @@ -6120,12 +6366,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
>  	u64 start = memslot->base_gfn;
>  	u64 end = start + memslot->npages;
>  
> -	if (is_tdp_mmu_enabled(kvm)) {
> -		read_lock(&kvm->mmu_lock);
> -		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> -		read_unlock(&kvm->mmu_lock);
> +	if (!is_tdp_mmu_enabled(kvm))
> +		return;
> +
> +	if (kvm_memslots_have_rmaps(kvm)) {
> +		write_lock(&kvm->mmu_lock);
> +		kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
> +		write_unlock(&kvm->mmu_lock);
>  	}
>  
> +	read_lock(&kvm->mmu_lock);
> +	kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> +	read_unlock(&kvm->mmu_lock);
> +
>  	/*
>  	 * No TLB flush is necessary here. KVM will flush TLBs after
>  	 * write-protecting and/or clearing dirty on the newly split SPTEs to
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 04812eaaf61b..4fe018ddd1cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12197,6 +12197,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  		 * page faults will create the large-page sptes.
>  		 */
>  		kvm_mmu_zap_collapsible_sptes(kvm, new);
> +
> +		/*
> +		 * Free any memory left behind by eager page splitting. Ignore
> +		 * the module parameter since userspace might have changed it.
> +		 */
> +		free_split_caches(kvm);
>  	} else {
>  		/*
>  		 * Initially-all-set does not require write protecting any page,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f94f72bbd2d3..17fc9247504d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1336,6 +1336,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
>  
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);

If you end up with a v7, could you move this to the previous commit,
please. In that case this would include not making
__kvm_mmu_topup_memory_cache a static in the previous one as well.

Thanks,
Ricardo

>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
>  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5e2e75014256..b9573e958a03 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -369,7 +369,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>  		return (void *)__get_free_page(gfp_flags);
>  }
>  
> -static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
>  {
>  	gfp_t gfp = GFP_KERNEL_ACCOUNT;
>  	void *obj;
> -- 
> 2.36.0.550.gb090851708-goog
> 
