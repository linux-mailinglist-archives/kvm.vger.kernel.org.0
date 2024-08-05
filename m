Return-Path: <kvm+bounces-23282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4F7948617
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8231728229A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73DA170A14;
	Mon,  5 Aug 2024 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VwvBVu3L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E90B16F84C
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900687; cv=none; b=E0n4PaWv+JjfprmCK+NiMZkzL/s/OElQ5RWyfKIFggTLz6grxOImIp0QyZ58UUPrWrq0aRIshi8er30bInsyKjWdQCqEZDboRqZKe8Uj41Pfz5C/rBbSUD8oSZvnD9BnJJ1gj3Ob6FMK6BjCFSt0xeaG/pA1lCMGKG0fJCxfBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900687; c=relaxed/simple;
	bh=8leJ31oJs1BNyX+3Er2KccXH2VRObSgKa3sneeSzwFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wd/tToUdDU/tCskUOiSUqT2LdZDP8nOLxDbO+zmUYODohkxhT32SRGvFdaFXFDyuWeCN9ilcyjGpCCQqaXIlN3lsFPb5HF5/LXpMjZ3Zpk42uoz2PmzSYpqTYjbky3sunksgBAqSSSigcdEWAGgTXXB91GC2AKqv+fjZ1mH5oqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VwvBVu3L; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0be2fa8f68so94889276.3
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900684; x=1723505484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vXE6JzMWFSja2kdpNMFAxnrAri58nZeKIl6fOrKa69M=;
        b=VwvBVu3LsS5WYIc+WiMK/jzZzD3wCCgm6wej6dp6SlQwwvK+v1jhYIXq4rPqOFy7KL
         N8+6LAb+otkaMD+dzGLsVIO9C+w31y57ECuem/VrfYJgwa9zwp7oJ1jf8DRuuXjABy5i
         9wzsK6qve1fonLvpot/JYkcLbgX9vEm6asKQLj9OEgtHAyn+JH97OBCxMpZGhjVw7nbZ
         oiyJUiKnYIrZSdhNt6gbe5Jtx5JJ9qwdysn9fw89h8Tux9ifLZ5ewiWoqpcAG31yu4P4
         c+6mm/65iTHYKtJWObfBOh+F1oLh/6w+33sS8/OOSFNqjSNoJSddq4IxlEUN7724kGeQ
         vG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900684; x=1723505484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vXE6JzMWFSja2kdpNMFAxnrAri58nZeKIl6fOrKa69M=;
        b=bXwYKgENAlJPQJ083xf0d1ZOfYRlzQXly1Qx+fpaXvEUwhnu2y+okQokWNb/dBTBYc
         Fez5K23Ig4ikfm5RLghqkrM9RkI2bkf+eBiuG1gDBc3TJqH0O6SG6UEV4CCq7CeG3fZC
         WvoSd8lHeRowC/l3HzoSsSF03bhgVtHuk7i2864Sy+Q1jSMPDhTAWkh46w8TQ7zvhyi1
         WcwMTPcpsnhsVQh1JMC2PXJANMQy+LVXyakBBc5RTsrAD4bNh+E7FjOBaulqwVm25YW+
         QAQPNxp8DNaN9Df+LRnEbLTpQ9Y8lxFs63BSKxhpfiDr1VLideVNwM7lXHEhAioOjEOn
         zlaA==
X-Gm-Message-State: AOJu0Yy1Rc8UhuBm2xl6E81o4LqClA7S7jXzFFa8gy1trJ/IGWlVPGFH
	6lbIKDKj3ViuYWvTS0aCKFKPQkx8chOTsw7xhs0zJHEiD0Ec0uIuYo+u+9t+V6aYb/s7vBnKCgm
	9WXFlbnnFeQ==
X-Google-Smtp-Source: AGHT+IEgFoZugA85TLSkAb19f1VjyuhrA2JHG75XPVigWc28Z+clukSUR9Z/zvV0+TaoG8rxoJ+c+KrhLbO6uA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:150a:b0:e02:ba8f:2bd5 with SMTP
 id 3f1490d57ef6-e0bde420d84mr61660276.7.1722900684308; Mon, 05 Aug 2024
 16:31:24 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:11 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-5-dmatlack@google.com>
Subject: [PATCH 4/7] KVM: x86/mmu: Recover TDP MMU huge page mappings in-place
 instead of zapping
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
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/mmu.c          |  6 +++---
 arch/x86/kvm/mmu/spte.c         | 36 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/spte.h         |  1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 32 +++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
 arch/x86/kvm/x86.c              | 18 +++++++----------
 7 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..ed3b724db4d7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1952,8 +1952,8 @@ void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
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
index 1b4e14ac512b..34e59210d94e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6917,8 +6917,8 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 		kvm_flush_remote_tlbs_memslot(kvm, slot);
 }
 
-void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
-				   const struct kvm_memory_slot *slot)
+void kvm_mmu_recover_huge_pages(struct kvm *kvm,
+				const struct kvm_memory_slot *slot)
 {
 	if (kvm_memslots_have_rmaps(kvm)) {
 		write_lock(&kvm->mmu_lock);
@@ -6928,7 +6928,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 	if (tdp_mmu_enabled) {
 		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
+		kvm_tdp_mmu_recover_huge_pages(kvm, slot);
 		read_unlock(&kvm->mmu_lock);
 	}
 }
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d4527965e48c..979387d4ebfa 100644
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
@@ -320,6 +329,27 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
 	return child_spte;
 }
 
+u64 make_huge_spte(struct kvm *kvm, u64 small_spte, int level)
+{
+	u64 huge_spte;
+
+	KVM_BUG_ON(!is_shadow_present_pte(small_spte), kvm);
+	KVM_BUG_ON(level == PG_LEVEL_4K, kvm);
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
index ef793c459b05..498c30b6ba71 100644
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
index fad2912d3d4c..3f2d7343194e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1575,15 +1575,16 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
 
-static void zap_collapsible_spte_range(struct kvm *kvm,
-				       struct kvm_mmu_page *root,
-				       const struct kvm_memory_slot *slot)
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
 
 	rcu_read_lock();
 
@@ -1608,18 +1609,19 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		/*
-		 * The page can be remapped at a higher level, so step
-		 * up to zap the parent SPTE.
+		 * Construct the huge SPTE based on the small SPTE and then step
+		 * back up to install it.
 		 */
+		huge_spte = make_huge_spte(kvm, iter.old_spte, max_mapping_level);
 		while (max_mapping_level > iter.level)
 			tdp_iter_step_up(&iter);
 
-		if (!tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, huge_spte))
 			flush = true;
 
 		/*
-		 * If the atomic zap fails, the iter will recurse back into
-		 * the same subtree to retry.
+		 * If the cmpxchg fails, the iter will recurse back into the
+		 * same subtree to retry.
 		 */
 	}
 
@@ -1630,17 +1632,21 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 }
 
 /*
- * Zap non-leaf SPTEs (and free their associated page tables) which could be
- * replaced by huge pages, for GFNs within the slot.
+ * Recover huge page mappings within the slot by replacing non-leaf SPTEs with
+ * huge SPTEs where possible.
+ *
+ * Note that all huge page mappings are recovered, including NX huge pages that
+ * were split by guest instruction fetches and huge pages that were split for
+ * dirty tracking.
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
index af6c8cf6a37a..b83bebe53840 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13056,19 +13056,15 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 
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
2.46.0.rc2.264.g509ed76dc8-goog


