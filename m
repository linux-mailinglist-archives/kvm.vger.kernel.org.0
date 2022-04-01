Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8B54EF964
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350828AbiDAR6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350784AbiDAR63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:29 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E7C28F81A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id rm11-20020a17090b3ecb00b001c713925e58so4349171pjb.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5xLJkysC3ZlCsyjnevnbbczfF7DAWIHXhWTtUpk/DaM=;
        b=BGWmxg2u+a742ZhGq8e/gaCDz955+1ZlJovsdI6L0nUAdWVa6Qdtc23Nr2Pjp8RQ3N
         ACHnaXMUEZZJtcUTF+9+oQ7mPkwkih4Kyme64gsN+BLDFtcBI2OQ/7C0QjVXQ4T/159e
         lLX9UO9w/OYj40ZxkmxV0yV/PEMV9uDKZXfTwSZfO+Vc4Ty6Q1q8YKMJMEFOWECBG+qC
         Esy1K3+NzO2OoFIKu40KLMPncdvpA75at3FLolRVU1+pXbEb1fIbJA2nh41yucAQM+1F
         fH1akGlZxRH6ir3R6Niw4Z7lGVNrxjVDaz6IRs2J8IbjR18pMPuYiYP1zkb/NFf1KEOc
         1CWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5xLJkysC3ZlCsyjnevnbbczfF7DAWIHXhWTtUpk/DaM=;
        b=KP2le9kt4MB8kddTsqT1p4PKJjvrKPUgcH1BMT8hhkbLrVr9wyfw2oG0/VuBNdP+3A
         0mFudWEQQs2pzUBv61DzANcc6eQlP+S9Ycre+nRSwdgBJ5P80nNtCWzDEwe3+qIxyeRI
         o+fpaLojd+duFJEbxCgnULZV54MnkAr/ct4XJnjzBigwHs8VAb1JRbaD7Hqmk2l3yuRx
         NfY6p0tHRN1zRKSxHKNNQn/2lQVG1W8gRkd85C3vVM+euUKF2b992XHPMJni+UzqM/Uo
         shHVICpoSUv+oKqwhRBs5nSqddj7DSIuo836Ta8Ce1XYJAscny0HXz4B7JPt/GWmKtQb
         eZMg==
X-Gm-Message-State: AOAM531GChtURu4655d21aS2EKTuQFETLpTJvb+0p6GLFiyeYUGdbUqR
        odncHBa6xVbOtSsDGNcVsrdRBlxGbTHZKQ==
X-Google-Smtp-Source: ABdhPJyRqF97zxTLz0gW9feu0V4xTh0qrgEHDZnAhXWlpLSbGZiPVvAurNY7AvSLmzoxLwnBmcQvKj8DX1SHqw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:81c1:0:b0:4f7:6ba1:553b with SMTP id
 c1-20020aa781c1000000b004f76ba1553bmr12211127pfn.45.1648835796738; Fri, 01
 Apr 2022 10:56:36 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:53 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-23-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 22/23] KVM: x86/mmu: Support Eager Page Splitting in the
 shadow MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Eager Page Splitting pages that are mapped by the shadow
MMU. Walk through the rmap first splitting all 1GiB pages to 2MiB pages,
and then splitting all 2MiB pages to 4KiB pages.

Splitting huge pages mapped by the shadow MMU requries dealing with some
extra complexity beyond that of the TDP MMU:

(1) The shadow MMU has a limit on the number of shadow pages that are
    allowed to be allocated. So, as a policy, Eager Page Splitting
    refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
    pages available.

(2) Huge pages may be mapped by indirect shadow pages which have the
    possibility of being unsync. As a policy we opt not to split such
    pages as their translation may no longer be valid.

(3) Splitting a huge page may end up re-using an existing lower level
    shadow page tables. This is unlike the TDP MMU which always allocates
    new shadow page tables when splitting.

(4) When installing the lower level SPTEs, they must be added to the
    rmap which may require allocating additional pte_list_desc structs.

Note, for case (3) we have to be careful about dealing with what's
already in the lower level page table. Specifically the lower level page
table may only be partially filled in and may point to even lower level
page tables that are partially filled in. We can fill in non-present
entries, but recursing into the lower level page tables would be too
complex.

This means that Eager Page Splitting may partially unmap a huge page.
To handle this we flush TLBs after dropping the huge SPTE whenever we
are about to install a lower level page table that was partially filled
in (*). We can skip the TLB flush if the lower level page table was
empty (no aliasing) or identical to what we were already going to
populate it with (aliased huge page that was just eagerly split).

(*) This TLB flush could probably be delayed until we're about to drop
the MMU lock, which would also let us batch flushes for multiple splits.
However such scenarios should be rare in practice (a huge page must be
aliased in multiple SPTEs and have been split for NX Huge Pages in only
some of them). Flushing immediately is simpler to plumb and also reduces
the chances of tripping over a CPU bug (e.g. see iTLB multi-hit).

Suggested-by: Peter Feiner <pfeiner@google.com>
[ This commit is based off of the original implementation of Eager Page
  Splitting from Peter in Google's kernel from 2016 that handles
  cases (1) and (2) above. ]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   3 -
 arch/x86/include/asm/kvm_host.h               |  12 +
 arch/x86/kvm/mmu/mmu.c                        | 268 ++++++++++++++++++
 arch/x86/kvm/x86.c                            |   6 +
 4 files changed, 286 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 05161afd7642..495f6ac53801 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2360,9 +2360,6 @@
 			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
 			cleared.
 
-			Eager page splitting currently only supports splitting
-			huge pages mapped by the TDP MMU.
-
 			Default is Y (on).
 
 	kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffb2b99f3a60..053a32afd18b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1246,6 +1246,16 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	/*
+	 * Memory cache used to allocate pte_list_desc structs while splitting
+	 * huge pages. In the worst case, to split one huge page we need 512
+	 * pte_list_desc structs to add each lower level leaf sptep to the rmap
+	 * plus 1 to extend the parent_ptes rmap of the lower level page table.
+	 */
+#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 513
+	__DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
+				      HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
 };
 
 struct kvm_vm_stat {
@@ -1621,6 +1631,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
+void free_huge_page_split_desc_cache(struct kvm *kvm);
+
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a8200b3f8782..9adafed43048 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5972,6 +5972,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+
+	kvm->arch.huge_page_split_desc_cache.capacity =
+		HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY;
+	kvm->arch.huge_page_split_desc_cache.kmem_cache = pte_list_desc_cache;
+	kvm->arch.huge_page_split_desc_cache.gfp_zero = __GFP_ZERO;
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6102,12 +6107,267 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+static int topup_huge_page_split_desc_cache(struct kvm *kvm, bool locked)
+{
+	gfp_t gfp = gfp_flags_for_split(locked);
+
+	/*
+	 * We may need up to HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY descriptors
+	 * to split any given huge page. We could more accurately calculate how
+	 * many we actually need by inspecting all the rmaps and check which
+	 * will need new descriptors, but that's not worth the extra cost or
+	 * code complexity.
+	 */
+	return __kvm_mmu_topup_memory_cache(
+			&kvm->arch.huge_page_split_desc_cache,
+			HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY,
+			gfp);
+}
+
+void free_huge_page_split_desc_cache(struct kvm *kvm)
+{
+	kvm_mmu_free_memory_cache(&kvm->arch.huge_page_split_desc_cache);
+}
+
+static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp,
+				  bool locked)
+{
+	int r;
+
+	r = topup_huge_page_split_desc_cache(kvm, locked);
+	if (r)
+		return r;
+
+	if (!*spp) {
+		*spp = kvm_mmu_alloc_direct_sp_for_split(locked);
+		r = *spp ? 0 : -ENOMEM;
+	}
+
+	return r;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
+						     const struct kvm_memory_slot *slot,
+						     u64 *huge_sptep,
+						     struct kvm_mmu_page **spp)
+{
+	struct kvm_mmu_page *sp, *huge_sp = sptep_to_sp(huge_sptep);
+	union kvm_mmu_page_role role;
+	LIST_HEAD(invalid_list);
+	unsigned int access;
+	gfn_t gfn;
+
+	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
+	access = kvm_mmu_page_get_access(huge_sp, huge_sptep - huge_sp->spt);
+
+	/*
+	 * Huge page splitting always uses direct shadow pages since we are
+	 * directly mapping the huge page GFN region with smaller pages.
+	 */
+	role = kvm_mmu_child_role(huge_sptep, true, access);
+
+	sp = __kvm_mmu_find_shadow_page(kvm, gfn, role, &invalid_list);
+	if (sp) {
+		/* Direct SPs should never be unsync. */
+		WARN_ON_ONCE(sp->unsync);
+		trace_kvm_mmu_get_page(sp, false);
+	} else {
+		swap(sp, *spp);
+		init_shadow_page(kvm, sp, slot, gfn, role);
+		trace_kvm_mmu_get_page(sp, true);
+	}
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+
+	return sp;
+}
+
+static void kvm_mmu_split_huge_page(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot,
+				    u64 *huge_sptep, struct kvm_mmu_page **spp)
+
+{
+	struct kvm_mmu_memory_cache *cache = &kvm->arch.huge_page_split_desc_cache;
+	u64 huge_spte = READ_ONCE(*huge_sptep);
+	struct kvm_mmu_page *sp;
+	bool flush = false;
+	u64 *sptep, spte;
+	gfn_t gfn;
+	int index;
+
+	sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
+
+	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
+		sptep = &sp->spt[index];
+		gfn = kvm_mmu_page_get_gfn(sp, index);
+
+		/*
+		 * sp may have populated page table entries, e.g. if this huge
+		 * page is aliased by multiple sptes with the same access
+		 * permissions. We know the sptes will be mapping the same
+		 * gfn-to-pfn translation since sp is direct. However, a given
+		 * spte may point to an even lower level page table. We don't
+		 * know if that lower level page table is completely filled in,
+		 * i.e. we may be effectively unmapping a region of memory, so
+		 * we must flush the TLB.
+		 */
+		if (is_shadow_present_pte(*sptep)) {
+			flush |= !is_last_spte(*sptep, sp->role.level);
+			continue;
+		}
+
+		spte = make_huge_page_split_spte(huge_spte, sp, index);
+		mmu_spte_set(sptep, spte);
+		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
+	}
+
+	/*
+	 * Replace the huge spte with a pointer to the populated lower level
+	 * page table. If the lower-level page table indentically maps the huge
+	 * page, there's no need for a TLB flush. Otherwise, flush TLBs after
+	 * dropping the huge page and before installing the shadow page table.
+	 */
+	__drop_large_spte(kvm, huge_sptep, flush);
+	__link_shadow_page(cache, huge_sptep, sp);
+}
+
+static int __try_split_huge_page(struct kvm *kvm,
+				 const struct kvm_memory_slot *slot,
+				 u64 *huge_sptep, struct kvm_mmu_page **spp)
+{
+	int r = 0;
+
+	if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
+		return -ENOSPC;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		goto drop_lock;
+
+	r = alloc_memory_for_split(kvm, spp, true);
+	if (r)
+		goto drop_lock;
+
+	kvm_mmu_split_huge_page(kvm, slot, huge_sptep, spp);
+
+	return 0;
+
+drop_lock:
+	write_unlock(&kvm->mmu_lock);
+	cond_resched();
+	r = alloc_memory_for_split(kvm, spp, false);
+	write_lock(&kvm->mmu_lock);
+
+	/*
+	 * Ask the caller to try again if the allocation succeeded. We dropped
+	 * the MMU lock so huge_sptep may no longer be valid.
+	 */
+	return r ?: -EAGAIN;
+}
+
+static int try_split_huge_page(struct kvm *kvm,
+			       const struct kvm_memory_slot *slot,
+			       u64 *huge_sptep, struct kvm_mmu_page **spp)
+{
+	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
+	int level, r;
+	gfn_t gfn;
+	u64 spte;
+
+	/*
+	 * Record information about the huge page being split to use in the
+	 * tracepoint below. Do this now because __try_split_huge_page() may
+	 * drop the MMU lock, after which huge_sptep may no longer be a valid
+	 * pointer.
+	 */
+	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
+	level = huge_sp->role.level;
+	spte = *huge_sptep;
+
+	r = __try_split_huge_page(kvm, slot, huge_sptep, spp);
+
+	trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
+
+	return r;
+}
+
+
+static bool skip_split_huge_page(u64 *huge_sptep)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(huge_sptep);
+
+	if (WARN_ON_ONCE(!is_large_pte(*huge_sptep)))
+		return true;
+
+	/*
+	 * As a policy, do not split huge pages if the sp on which they reside
+	 * is unsync. Unsync means the guest is modifying the page table being
+	 * shadowed, so splitting may be a waste of cycles and memory.
+	 */
+	return sp->role.invalid || sp->unsync;
+}
+
+static bool rmap_try_split_huge_pages(struct kvm *kvm,
+				      struct kvm_rmap_head *rmap_head,
+				      const struct kvm_memory_slot *slot)
+{
+	struct kvm_mmu_page *sp = NULL;
+	struct rmap_iterator iter;
+	u64 *huge_sptep;
+	int r;
+
+restart:
+	for_each_rmap_spte(rmap_head, &iter, huge_sptep) {
+		if (skip_split_huge_page(huge_sptep))
+			continue;
+
+		r = try_split_huge_page(kvm, slot, huge_sptep, &sp);
+		if (r < 0 && r != -EAGAIN)
+			break;
+
+		/*
+		 * Splitting succeeded (and removed huge_sptep from the
+		 * iterator) or we had to drop the MMU lock. Either way, restart
+		 * the iterator to get it back into a consistent state.
+		 */
+		goto restart;
+	}
+
+	if (sp)
+		kvm_mmu_free_shadow_page(sp);
+
+	return false;
+}
+
+static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot,
+					  gfn_t start, gfn_t end,
+					  int target_level)
+{
+	int level;
+
+	/*
+	 * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
+	 * down to the target level. This ensures pages are recursively split
+	 * all the way to the target level. There's no need to split pages
+	 * already at the target level.
+	 */
+	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
+		slot_handle_level_range(kvm, slot,
+					rmap_try_split_huge_pages,
+					level, level, start, end - 1,
+					true, false);
+	}
+}
+
 /* Must be called with the mmu_lock held in write-mode. */
 void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot,
 				   u64 start, u64 end,
 				   int target_level)
 {
+	if (kvm_memslots_have_rmaps(kvm))
+		kvm_rmap_try_split_huge_pages(kvm, memslot, start, end, target_level);
+
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
 						 target_level, false);
@@ -6125,6 +6385,14 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
+	if (kvm_memslots_have_rmaps(kvm)) {
+		topup_huge_page_split_desc_cache(kvm, false);
+		write_lock(&kvm->mmu_lock);
+		kvm_rmap_try_split_huge_pages(kvm, memslot, start, end, target_level);
+		write_unlock(&kvm->mmu_lock);
+		free_huge_page_split_desc_cache(kvm);
+	}
+
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3a9ce07a565..02728c3f088e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12106,6 +12106,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 * page faults will create the large-page sptes.
 		 */
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
+
+		/*
+		 * Free any memory left behind by eager page splitting. Ignore
+		 * the module parameter since userspace might have changed it.
+		 */
+		free_huge_page_split_desc_cache(kvm);
 	} else {
 		/*
 		 * Initially-all-set does not require write protecting any page,
-- 
2.35.1.1094.g7c7d902a7c-goog

