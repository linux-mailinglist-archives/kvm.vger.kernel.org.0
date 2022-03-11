Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3436F4D56A5
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345217AbiCKA1Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345216AbiCKA1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:27:15 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7061A274E
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:05 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 196-20020a6307cd000000b0038027886594so3790052pgh.4
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WA6HST15t1Zfp54ZQZHtPJ91hXGCHATf6ynvL/uqJAw=;
        b=a47vI4e5DCLaCtH52PqEaW29IZ49EU6bu9Rtjt5nca1GCTKOBl18RsRsz75mldZGaG
         XnFfgd02wvDk2wnozXhQbnICqjNQs17WnM/32z1+uCSsnejAyzh8b0lDcVaydkV54BuQ
         V3vkbcLloBzuDdED20UrMdE3Il0cIOBfanM0k5idb7yf57pB7WbDwd0NOg5s/9YoDsXc
         KHFuZ//SEJSl+hkOJCD4FX9bUeeL1FUDpeJTzgxJ5j3IzEcRqlj5a846ofSfsEvxbauK
         2oj/JLoCtYAnLAYlhHcJSawLqdh5mHiPv0oIRiaTtKtya1rdgCovUPMxIz7AwSjgxD0M
         1qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WA6HST15t1Zfp54ZQZHtPJ91hXGCHATf6ynvL/uqJAw=;
        b=xx6/zj5MDfMvedMwyp1G0ZWfkT/OZRXf1PRMnY0/RBqwOYpq7rGFI/rwWNi1lSOd+f
         Ei1OsHEpqtiQxUIyJMwJxzE7rG/Ye8ANSHdjv89bWGSADZU6XJQqfxvcDPwwZPhVcvsO
         OZj6MfLg2O7EVdibMg6JIg0cACqiZK42o9rhYiu4DEHlyFgQQ2vUbwJ2U7NB3Rfi8THp
         72oS9ExS4CrosrL9belQ9aSaiZ9bZVFI+8L1ZFUZmEndntpqFTWuOcU5bJWb57XPVICz
         DHP1hCPUebErELG9fvKZl+MkkdbhvCfbrUoEIWPrafbGEjYSsncFGQUsfCx+NhLIe5A1
         xP8g==
X-Gm-Message-State: AOAM533bJrMp404ek0idQF9sVNg36qld4FCWZRB63MH4/zlWorK1uHb6
        7w8g13vhCcGodbeQZz2KdZ6MWfzXySUbzw==
X-Google-Smtp-Source: ABdhPJwYWz8wUmi2nMsvX7GLlR+W5kd6r41rJtex5GTM+ljEkO3lCJi7MRe0hudTcE7ycgRLMGPLjQQzzRCeJg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:c984:b0:1bf:aee2:3503 with SMTP
 id w4-20020a17090ac98400b001bfaee23503mr7712377pjt.28.1646958365095; Thu, 10
 Mar 2022 16:26:05 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:22 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-21-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 20/26] KVM: x86/mmu: Extend Eager Page Splitting to the
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend KVM's eager page splitting to also split huge pages that are
mapped by the shadow MMU. Specifically, walk through the rmap splitting
all 1GiB pages to 2MiB pages, and splitting all 2MiB pages to 4KiB
pages.

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
    new shadow page tables when splitting.  This commit does *not*
    handle such aliasing and opts not to split such huge pages.

(4) When installing the lower level SPTEs, they must be added to the
    rmap which may require allocating additional pte_list_desc structs.
    This commit does *not* handle such cases and instead opts to leave
    such lower-level SPTEs non-present. In this situation TLBs must be
    flushed before dropping the MMU lock as a portion of the huge page
    region is being unmapped.

Suggested-by: Peter Feiner <pfeiner@google.com>
[ This commit is based off of the original implementation of Eager Page
  Splitting from Peter in Google's kernel from 2016. ]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   3 -
 arch/x86/kvm/mmu/mmu.c                        | 307 ++++++++++++++++++
 2 files changed, 307 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 926ddfaa9e1a..dd56b5b9624f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -727,6 +727,11 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
 {
+	static const gfp_t gfp_nocache = GFP_ATOMIC | __GFP_ACCOUNT | __GFP_ZERO;
+
+	if (WARN_ON_ONCE(!cache))
+		return kmem_cache_alloc(pte_list_desc_cache, gfp_nocache);
+
 	return kvm_mmu_memory_cache_alloc(cache);
 }
 
@@ -743,6 +748,28 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
 }
 
+static gfn_t sptep_to_gfn(u64 *sptep)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+
+	return kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+}
+
+static unsigned int kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
+{
+	if (!sp->role.direct)
+		return sp->shadowed_translation[index].access;
+
+	return sp->role.access;
+}
+
+static unsigned int sptep_to_access(u64 *sptep)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(sptep);
+
+	return kvm_mmu_page_get_access(sp, sptep - sp->spt);
+}
+
 static void kvm_mmu_page_set_gfn_access(struct kvm_mmu_page *sp, int index,
 					gfn_t gfn, u32 access)
 {
@@ -912,6 +939,9 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	return count;
 }
 
+static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
+					 const struct kvm_memory_slot *slot);
+
 static void
 pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
 			   struct pte_list_desc *desc, int i,
@@ -2125,6 +2155,23 @@ static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
+static struct kvm_mmu_page *kvm_mmu_find_direct_sp(struct kvm *kvm, gfn_t gfn,
+						   union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+	LIST_HEAD(invalid_list);
+
+	BUG_ON(!role.direct);
+
+	sp = __kvm_mmu_find_shadow_page(kvm, gfn, role, &invalid_list);
+
+	/* Direct SPs are never unsync. */
+	WARN_ON_ONCE(sp && sp->unsync);
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	return sp;
+}
+
 /*
  * Looks up an existing SP for the given gfn and role if one exists. The
  * return SP is guaranteed to be synced.
@@ -6063,12 +6110,266 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+static int prepare_to_split_huge_page(struct kvm *kvm,
+				      const struct kvm_memory_slot *slot,
+				      u64 *huge_sptep,
+				      struct kvm_mmu_page **spp,
+				      bool *flush,
+				      bool *dropped_lock)
+{
+	int r = 0;
+
+	*dropped_lock = false;
+
+	if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
+		return -ENOSPC;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		goto drop_lock;
+
+	*spp = kvm_mmu_alloc_direct_sp_for_split(true);
+	if (r)
+		goto drop_lock;
+
+	return 0;
+
+drop_lock:
+	if (*flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+
+	*flush = false;
+	*dropped_lock = true;
+
+	write_unlock(&kvm->mmu_lock);
+	cond_resched();
+	*spp = kvm_mmu_alloc_direct_sp_for_split(false);
+	if (!*spp)
+		r = -ENOMEM;
+	write_lock(&kvm->mmu_lock);
+
+	return r;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
+						     const struct kvm_memory_slot *slot,
+						     u64 *huge_sptep,
+						     struct kvm_mmu_page **spp)
+{
+	struct kvm_mmu_page *split_sp;
+	union kvm_mmu_page_role role;
+	unsigned int access;
+	gfn_t gfn;
+
+	gfn = sptep_to_gfn(huge_sptep);
+	access = sptep_to_access(huge_sptep);
+
+	/*
+	 * Huge page splitting always uses direct shadow pages since we are
+	 * directly mapping the huge page GFN region with smaller pages.
+	 */
+	role = kvm_mmu_child_role(huge_sptep, true, access);
+	split_sp = kvm_mmu_find_direct_sp(kvm, gfn, role);
+
+	/*
+	 * Opt not to split if the lower-level SP already exists. This requires
+	 * more complex handling as the SP may be already partially filled in
+	 * and may need extra pte_list_desc structs to update parent_ptes.
+	 */
+	if (split_sp)
+		return NULL;
+
+	swap(split_sp, *spp);
+	init_shadow_page(kvm, split_sp, slot, gfn, role);
+	trace_kvm_mmu_get_page(split_sp, true);
+
+	return split_sp;
+}
+
+static int kvm_mmu_split_huge_page(struct kvm *kvm,
+				   const struct kvm_memory_slot *slot,
+				   u64 *huge_sptep, struct kvm_mmu_page **spp,
+				   bool *flush)
+
+{
+	struct kvm_mmu_page *split_sp;
+	u64 huge_spte, split_spte;
+	int split_level, index;
+	unsigned int access;
+	u64 *split_sptep;
+	gfn_t split_gfn;
+
+	split_sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
+	if (!split_sp)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Since we did not allocate pte_list_desc_structs for the split, we
+	 * cannot add a new parent SPTE to parent_ptes. This should never happen
+	 * in practice though since this is a fresh SP.
+	 *
+	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
+	 */
+	if (WARN_ON_ONCE(split_sp->parent_ptes.val))
+		return -EINVAL;
+
+	huge_spte = READ_ONCE(*huge_sptep);
+
+	split_level = split_sp->role.level;
+	access = split_sp->role.access;
+
+	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
+		split_sptep = &split_sp->spt[index];
+		split_gfn = kvm_mmu_page_get_gfn(split_sp, index);
+
+		BUG_ON(is_shadow_present_pte(*split_sptep));
+
+		/*
+		 * Since we did not allocate pte_list_desc structs for the
+		 * split, we can't add a new SPTE that maps this GFN.
+		 * Skipping this SPTE means we're only partially mapping the
+		 * huge page, which means we'll need to flush TLBs before
+		 * dropping the MMU lock.
+		 *
+		 * Note, this make it safe to pass NULL to __rmap_add() below.
+		 */
+		if (gfn_to_rmap(split_gfn, split_level, slot)->val) {
+			*flush = true;
+			continue;
+		}
+
+		split_spte = make_huge_page_split_spte(
+				huge_spte, split_level + 1, index, access);
+
+		mmu_spte_set(split_sptep, split_spte);
+		__rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);
+	}
+
+	/*
+	 * Replace the huge spte with a pointer to the populated lower level
+	 * page table. Since we are making this change without a TLB flush vCPUs
+	 * will see a mix of the split mappings and the original huge mapping,
+	 * depending on what's currently in their TLB. This is fine from a
+	 * correctness standpoint since the translation will either be identical
+	 * or non-present. To account for non-present mappings, the TLB will be
+	 * flushed prior to dropping the MMU lock.
+	 */
+	__drop_large_spte(kvm, huge_sptep, false);
+	__link_shadow_page(NULL, huge_sptep, split_sp);
+
+	return 0;
+}
+
+static bool should_split_huge_page(u64 *huge_sptep)
+{
+	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
+
+	if (WARN_ON_ONCE(!is_large_pte(*huge_sptep)))
+		return false;
+
+	if (huge_sp->role.invalid)
+		return false;
+
+	/*
+	 * As a policy, do not split huge pages if SP on which they reside
+	 * is unsync. Unsync means the guest is modifying the page table being
+	 * shadowed by huge_sp, so splitting may be a waste of cycles and
+	 * memory.
+	 */
+	if (huge_sp->unsync)
+		return false;
+
+	return true;
+}
+
+static bool rmap_try_split_huge_pages(struct kvm *kvm,
+				      struct kvm_rmap_head *rmap_head,
+				      const struct kvm_memory_slot *slot)
+{
+	struct kvm_mmu_page *sp = NULL;
+	struct rmap_iterator iter;
+	u64 *huge_sptep, spte;
+	bool flush = false;
+	bool dropped_lock;
+	int level;
+	gfn_t gfn;
+	int r;
+
+restart:
+	for_each_rmap_spte(rmap_head, &iter, huge_sptep) {
+		if (!should_split_huge_page(huge_sptep))
+			continue;
+
+		spte = *huge_sptep;
+		level = sptep_to_sp(huge_sptep)->role.level;
+		gfn = sptep_to_gfn(huge_sptep);
+
+		r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &flush, &dropped_lock);
+		if (r) {
+			trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
+			break;
+		}
+
+		if (dropped_lock)
+			goto restart;
+
+		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp, &flush);
+
+		trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
+
+		/*
+		 * If splitting is successful we must restart the iterator
+		 * because huge_sptep has just been removed from it.
+		 */
+		if (!r)
+			goto restart;
+	}
+
+	if (sp)
+		kvm_mmu_free_shadow_page(sp);
+
+	return flush;
+}
+
+static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
+					  const struct kvm_memory_slot *slot,
+					  gfn_t start, gfn_t end,
+					  int target_level)
+{
+	bool flush;
+	int level;
+
+	/*
+	 * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
+	 * down to the target level. This ensures pages are recursively split
+	 * all the way to the target level. There's no need to split pages
+	 * already at the target level.
+	 *
+	 * Note that TLB flushes must be done before dropping the MMU lock since
+	 * rmap_try_split_huge_pages() may partially split any given huge page,
+	 * i.e. it may effectively unmap (make non-present) a portion of the
+	 * huge page.
+	 */
+	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
+		flush = slot_handle_level_range(kvm, slot,
+						rmap_try_split_huge_pages,
+						level, level, start, end - 1,
+						true, flush);
+	}
+
+	if (flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+}
+
 /* Must be called with the mmu_lock held in write-mode. */
 void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot,
 				   u64 start, u64 end,
 				   int target_level)
 {
+	if (kvm_memslots_have_rmaps(kvm))
+		kvm_rmap_try_split_huge_pages(kvm, memslot, start, end,
+					      target_level);
+
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
 						 target_level, false);
@@ -6086,6 +6387,12 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
+	if (kvm_memslots_have_rmaps(kvm)) {
+		write_lock(&kvm->mmu_lock);
+		kvm_rmap_try_split_huge_pages(kvm, memslot, start, end, target_level);
+		write_unlock(&kvm->mmu_lock);
+	}
+
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
-- 
2.35.1.723.g4982287a31-goog

