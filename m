Return-Path: <kvm+bounces-24979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B66595D9FC
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 662F8B21C74
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C411F1C93B6;
	Fri, 23 Aug 2024 23:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D3xhXyGU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F86A1CC8B2
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457421; cv=none; b=D8DcMc0gVrQA3K8qFIgTfhmeZP8ly7qOvfNkE60/ExN2jzR3lbCgrRlhAM92udVfUBLJjKsRWH852Pgng9ex8JJcO86mhgJ9sHf9SmOCqUbWYZs6AcSc3fbvohj6DA/vOkX5Hq502ekWxT7mM6bx1eGOr95Xvuv0SJ+fZ7aa4y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457421; c=relaxed/simple;
	bh=txQMjcL9/9tPv9EGsyCvP7kVwE1o5XumCGliCdbXmbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cb2dFNEOumGfichSeXXpNzcMaWI5Y1icsIEaQsfmLQGxxSkhUyN87REcovtzUIx/JmbLuuNHpKkYCynmpyg8s83KXDXt9L1FS79bMuKVTDyA4hZIl5hrjh3HbEemwwbw03OIVT3I8oWZ88WQVaebMGhrDeWox7BLHKyDjFzPqZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D3xhXyGU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1159159528so4808065276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457418; x=1725062218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+3er8uN5v3H5c/9SKj7By3SrywJZM8hn9HeBn4fV9hI=;
        b=D3xhXyGUQmHsMhqETMqlAT9W2W78Gahe9cJCwgo6O5LlYXxcertH0K6bKYRxsjYQam
         blVkKiXx6XT1tDFM9lYbw9e70bLjF66EMMjZ08dX2Yq/NvAmwecDSn10jBzlm4BVmmBz
         NQ4JjtEhJK7hM3ERqekHmiJCJiOOYY+jrOG6FsG35sLiSETWdfe7DI325XbNBHVHhQnQ
         HKZnSrCPBxB+BL6qthypXQKMhjt4s6eqDoo3rC4O6Xaaa6NNIizpiwbvzKAEN1DBnHf1
         xEBd8gUzZyBhA9y7svr7hfCYVapYkEXb98XgAeR/+SpVHVfUoI/iO4f61ZbVdpBF1K3h
         H+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457418; x=1725062218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+3er8uN5v3H5c/9SKj7By3SrywJZM8hn9HeBn4fV9hI=;
        b=FCCk1iYdcEdAM5P8qQlme2P6tPANC8w1MGjNN/R8utFvpQ5hTnaZkgIcrtPUc8j6pp
         PKPtQinwL2iMwnovIE7av4Y6CNQLb8LPPWYGKt+WX3A+rje/1odeRKVu1wE98AMb94ok
         Plp7pzSf0lnmt7zUGpyB4C6EBEnbwN6KsQ8EYBdaGpcj0LVfu+fYoJQdT+8fwQLcG4aL
         DGqR6rXiL0XVsgGeVgNuVrFHYTHXI2HfARGwCyJL9OG8CoGZK09ZaTe4dKBshYoJMv8w
         OZvF2kq7eodDLNcq/ThM3nbjWTH6WmIDt3VYSF2QlfbkuMt6IdXoJnS2bOiB0V5NYBzk
         RRng==
X-Gm-Message-State: AOJu0YymcC0Ikkcee6rKm+roIUZL8Mifxcmc7dIdWCvbMHvypiNDvvnK
	MT+d03449tL09oKG54USpIS3P0lqnFmiUyB4r0Ge1A2A9IzSK5x8affJtHXIrSu4LhRkn2eQwpY
	owuIT+H4x4A==
X-Google-Smtp-Source: AGHT+IEHKHd2nm/KOB9WyClDfVWsNjfy3Sjgx1PENrhaKa/o/oqE5MIMNOo6FaPKK+b5cmtuQXNaMtXe51jpQw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:870d:0:b0:e13:ca63:f17c with SMTP id
 3f1490d57ef6-e1767770842mr99486276.1.1724457418247; Fri, 23 Aug 2024 16:56:58
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:46 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-5-dmatlack@google.com>
Subject: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Recover TDP MMU huge page mappings in-place instead of zapping them when
dirty logging is disabled, and rename functions that recover huge page
mappings when dirty logging is disabled to move away from the "zap
collapsible spte" terminology.

Before KVM flushes TLBs, guest accesses may be translated through either
the (stale) small SPTE or the (new) huge SPTE. This is already possible
when KVM is doing eager page splitting (where TLB flushes are also
batched), and when vCPUs are faulting in huge mappings (where TLBs are
flushed after the new huge SPTE is installed).

Recovering huge pages reduces the number of page faults when dirty
logging is disabled:

 $ perf stat -e kvm:kvm_page_fault -- ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g

 Before: 393,599      kvm:kvm_page_fault
 After:  262,575      kvm:kvm_page_fault

vCPU throughput and the latency of disabling dirty-logging are about
equal compared to zapping, but avoiding faults can be beneficial to
remove vCPU jitter in extreme scenarios.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +--
 arch/x86/kvm/mmu/mmu.c          |  6 ++--
 arch/x86/kvm/mmu/spte.c         | 39 +++++++++++++++++++++++--
 arch/x86/kvm/mmu/spte.h         |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 52 +++++++++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
 arch/x86/kvm/x86.c              | 18 +++++-------
 7 files changed, 94 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1811a42fa093..8f9bd7c0e139 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1953,8 +1953,8 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
 				  const struct kvm_memory_slot *memslot,
 				  u64 start, u64 end,
 				  int target_level);
-void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				   const struct kvm_memory_slot *memslot);
+void kvm_mmu_recover_huge_pages(struct kvm *kvm,
+				const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2e92d9e9b311..2f8b1ebcbe9c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6904,8 +6904,8 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 		kvm_flush_remote_tlbs_memslot(kvm, slot);
 }
 
-void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot)
+void kvm_mmu_recover_huge_pages(struct kvm *kvm,
+				const struct kvm_memory_slot *slot)
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
@@ -6915,7 +6915,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
+		kvm_tdp_mmu_recover_huge_pages(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8f7eb3ad88fc..a12437bf6e0c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -268,15 +268,14 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return wrprot;
 }
 
-static u64 make_spte_executable(u64 spte)
+static u64 modify_spte_protections(u64 spte, u64 set, u64 clear)
 {
 	bool is_access_track = is_access_track_spte(spte);
 
 	if (is_access_track)
 		spte = restore_acc_track_spte(spte);
 
-	spte &= ~shadow_nx_mask;
-	spte |= shadow_x_mask;
+	spte = (spte | set) & ~clear;
 
 	if (is_access_track)
 		spte = mark_spte_for_access_track(spte);
@@ -284,6 +283,16 @@ static u64 make_spte_executable(u64 spte)
 	return spte;
 }
 
+static u64 make_spte_executable(u64 spte)
+{
+	return modify_spte_protections(spte, shadow_x_mask, shadow_nx_mask);
+}
+
+static u64 make_spte_nonexecutable(u64 spte)
+{
+	return modify_spte_protections(spte, shadow_nx_mask, shadow_x_mask);
+}
+
 /*
  * Construct an SPTE that maps a sub-page of the given huge page SPTE where
  * `index` identifies which sub-page.
@@ -320,6 +329,30 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 	return child_spte;
 }
 
+u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
+{
+	u64 huge_spte;
+
+	if (KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm))
+		return SHADOW_NONPRESENT_VALUE;
+
+	if (KVM_BUG_ON(level == PG_LEVEL_4K, kvm))
+		return SHADOW_NONPRESENT_VALUE;
+
+	huge_spte = small_spte | PT_PAGE_SIZE_MASK;
+
+	/*
+	 * huge_spte already has the address of the sub-page being collapsed
+	 * from small_spte, so just clear the lower address bits to create the
+	 * huge page address.
+	 */
+	huge_spte &= KVM_HPAGE_MASK(level) | ~PAGE_MASK;
+
+	if (is_nx_huge_page_enabled(kvm))
+		huge_spte = make_spte_nonexecutable(huge_spte);
+
+	return huge_spte;
+}
 
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 2cb816ea2430..990d599eb827 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -503,6 +503,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 		      	      union kvm_mmu_page_role role, int index);
+u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9b8299ee4abb..be70f0f22550 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1581,15 +1581,43 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
-static void zap_collapsible_spte_range(struct kvm *kvm,
-				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot)
+static int tdp_mmu_make_huge_spte(struct kvm *kvm,
+				  struct tdp_iter *parent,
+				  u64 *huge_spte)
+{
+	struct kvm_mmu_page *root = spte_to_child_sp(parent->old_spte);
+	gfn_t start = parent->gfn;
+	gfn_t end = start + KVM_PAGES_PER_HPAGE(parent->level);
+	struct tdp_iter iter;
+
+	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		/*
+		 * Use the parent iterator when checking for forward progress so
+		 * that KVM doesn't get stuck continuously trying to yield (i.e.
+		 * returning -EAGAIN here and then failing the forward progress
+		 * check in the caller ad nauseam).
+		 */
+		if (tdp_mmu_iter_need_resched(kvm, parent))
+			return -EAGAIN;
+
+		*huge_spte = make_huge_spte(kvm, iter.old_spte, parent->level);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static void recover_huge_pages_range(struct kvm *kvm,
+				     struct kvm_mmu_page *root,
+				     const struct kvm_memory_slot *slot)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	int max_mapping_level;
 	bool flush = false;
+	u64 huge_spte;
+	int r;
 
 	rcu_read_lock();
 
@@ -1626,7 +1654,13 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (max_mapping_level < iter.level)
 			continue;
 
-		if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
+		r = tdp_mmu_make_huge_spte(kvm, &iter, &huge_spte);
+		if (r == -EAGAIN)
+			goto retry;
+		else if (r)
+			continue;
+
+		if (tdp_mmu_set_spte_atomic(kvm, &iter, huge_spte))
 			goto retry;
 
 		flush = true;
@@ -1639,17 +1673,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 }
 
 /*
- * Zap non-leaf SPTEs (and free their associated page tables) which could
- * be replaced by huge pages, for GFNs within the slot.
+ * Recover huge page mappings within the slot by replacing non-leaf SPTEs with
+ * huge SPTEs where possible.
  */
-void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot)
+void kvm_tdp_mmu_recover_huge_pages(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
-		zap_collapsible_spte_range(kvm, root, slot);
+		recover_huge_pages_range(kvm, root, slot);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1b74e058a81c..ddea2827d1ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -40,8 +40,8 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				       const struct kvm_memory_slot *slot);
+void kvm_tdp_mmu_recover_huge_pages(struct kvm *kvm,
+				    const struct kvm_memory_slot *slot);
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 966fb301d44b..3d09c12847d5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13053,19 +13053,15 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 
 	if (!log_dirty_pages) {
 		/*
-		 * Dirty logging tracks sptes in 4k granularity, meaning that
-		 * large sptes have to be split.  If live migration succeeds,
-		 * the guest in the source machine will be destroyed and large
-		 * sptes will be created in the destination.  However, if the
-		 * guest continues to run in the source machine (for example if
-		 * live migration fails), small sptes will remain around and
-		 * cause bad performance.
+		 * Recover huge page mappings in the slot now that dirty logging
+		 * is disabled, i.e. now that KVM does not have to track guest
+		 * writes at 4KiB granularity.
 		 *
-		 * Scan sptes if dirty logging has been stopped, dropping those
-		 * which can be collapsed into a single large-page spte.  Later
-		 * page faults will create the large-page sptes.
+		 * Dirty logging might be disabled by userspace if an ongoing VM
+		 * live migration is cancelled and the VM must continue running
+		 * on the source.
 		 */
-		kvm_mmu_zap_collapsible_sptes(kvm, new);
+		kvm_mmu_recover_huge_pages(kvm, new);
 	} else {
 		/*
 		 * Initially-all-set does not require write protecting any page,
-- 
2.46.0.295.g3b9ea8a38a-goog


