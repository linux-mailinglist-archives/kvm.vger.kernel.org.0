Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812049439F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357785AbiASXJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344247AbiASXIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:14 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321D2C06161C
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:14 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id e16-20020a17090a119000b001b28f7b2a3bso2661002pja.8
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NxdE4UkoNDKVd1y+9gUH/nA5kkYNo8vtuqAG3qr2pl4=;
        b=MQd9qwzBIUoVvDmovqiIgJ+aMFXiW3irmm/vgYXtIOZmwXMsOjEuQKFf1et1yAHOh7
         9uWYslps0Xkar0SqqF85i5EmY4iZ7tDqwz6DJwhSSdhfTv9g0Muk+k/lzWJszpGAD2GZ
         SYw39RxQd+NSve3/phujAWQ6jfHMJiYxWhy6pwDze8ctruSSnYF8GR8ew9/fNngK5lZK
         2zZx1FGvF8HmDy/xcNRgTEmO/UXbzlZftKhfLl5wIFomT+Kkou37+6EWYvUA0NozmcTJ
         hsFlC/F0I+jfs/MNv+3LNwwIThVT8g20CIHos2bPJmkJ9uhORilEz2z0r7CIER89kNnT
         XOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NxdE4UkoNDKVd1y+9gUH/nA5kkYNo8vtuqAG3qr2pl4=;
        b=pSseIfKkop0pJMKUbfYMWfx/qiBBByCpwxPJnuWbjGA1tZ1lUZYUXoFcfyotiDAMot
         rP08rkR3OgNvjOO8zdpWdHfjbUegbezBUB4bhfiyNmir2Q4wQGJGA0ZJM2G10/nYhRnf
         JF5F/6/KuykARkvsd3u6wYD7xbWDoLqJSgQtJr9ge6DlaGkoRPpNUuMDN79hOgp8f5er
         iDgekbbGaw1wQaZoHQCQ5cjB/PHaKGpme00VtlO/+g4w2hplVG472Iph8AZF0TVnSWU2
         O0h/QKu3v9KHOibqkr9zPu8hh5nfBitPil/MUUi4LoAR7liN4MWbXHyH4sn9qIpz3UQ7
         nbnw==
X-Gm-Message-State: AOAM532dzBHJDhVoahVFXNyb467gn+CDm+Ge9F0ZNwmIIBN1WmQMcMis
        Vu/fy+NIZ5czArRuRVGrWIHRQciYZ/6TjA==
X-Google-Smtp-Source: ABdhPJy6umejyHZdX24IGaSqfRX226Z6tRO+lD1J37Irg+7ZPkHKTzweeLF6Su+48Yk0mvVKFvhCcrOfrkH8fg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:88cb:0:b0:4c4:452:2e96 with SMTP id
 k11-20020aa788cb000000b004c404522e96mr17751627pff.38.1642633693674; Wed, 19
 Jan 2022 15:08:13 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:37 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 16/18] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 during KVM_CLEAR_DIRTY_LOG
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using KVM_DIRTY_LOG_INITIALLY_SET, huge pages are not
write-protected when dirty logging is enabled on the memslot. Instead
they are write-protected once userspace invokes KVM_CLEAR_DIRTY_LOG for
the first time and only for the specific sub-region being cleared.

Enhance KVM_CLEAR_DIRTY_LOG to also try to split huge pages prior to
write-protecting to avoid causing write-protection faults on vCPU
threads. This also allows userspace to smear the cost of huge page
splitting across multiple ioctls rather than splitting the entire
memslot when not using initially-all-set.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  4 +-
 arch/x86/include/asm/kvm_host.h               |  4 ++
 arch/x86/kvm/mmu/mmu.c                        | 25 ++++++-
 arch/x86/kvm/mmu/tdp_mmu.c                    | 67 +++++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.h                    |  2 +-
 arch/x86/kvm/x86.c                            |  2 +-
 arch/x86/kvm/x86.h                            |  2 +
 7 files changed, 73 insertions(+), 33 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f5e9c4a45aef..1b54e410e206 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2347,7 +2347,9 @@
 			KVM_DIRTY_LOG_INITIALLY_SET is enabled or disabled. If
 			disabled, all huge pages in a memslot will be eagerly
 			split when dirty logging is enabled on that memslot. If
-			enabled, huge pages will not be eagerly split.
+			enabled, eager page splitting will be performed during
+			the KVM_CLEAR_DIRTY ioctl, and only for the pages being
+			cleared.
 
 			Eager page splitting currently only supports splitting
 			huge pages mapped by the TDP MMU.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 97560980456d..e089f34a66eb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1582,6 +1582,10 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 				       const struct kvm_memory_slot *memslot,
 				       int target_level);
+void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
+				  const struct kvm_memory_slot *memslot,
+				  u64 start, u64 end,
+				  int target_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a273536e8b25..62caf5b6d82e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1360,6 +1360,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
 		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
 
+		if (READ_ONCE(eager_page_split))
+			kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
+
 		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
 
 		/* Cross two large pages? */
@@ -5834,16 +5837,32 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+/* Must be called with the mmu_lock held in write-mode. */
+void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot,
+				   u64 start, u64 end,
+				   int target_level)
+{
+	if (is_tdp_mmu_enabled(kvm))
+		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
+						 target_level, false);
+
+	/*
+	 * A TLB flush is unnecessary at this point for the same resons as in
+	 * kvm_mmu_slot_try_split_huge_pages().
+	 */
+}
+
 void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
-				       const struct kvm_memory_slot *memslot,
-				       int target_level)
+					const struct kvm_memory_slot *memslot,
+					int target_level)
 {
 	u64 start = memslot->base_gfn;
 	u64 end = start + memslot->npages;
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
-		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
+		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
 		read_unlock(&kvm->mmu_lock);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 88f723fc0d1f..d5e713b849e9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -943,27 +943,33 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 }
 
 /*
- * tdp_mmu_link_sp_atomic - Atomically replace the given spte with an spte
- * pointing to the provided page table.
+ * tdp_mmu_link_sp - Replace the given spte with an spte pointing to the
+ * provided page table.
  *
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @sp: The new TDP page table to install.
  * @account_nx: True if this page table is being installed to split a
  *              non-executable huge page.
+ * @shared: This operation is running under the MMU lock in read mode.
  *
  * Returns: 0 if the new page table was installed. Non-0 if the page table
  *          could not be installed (e.g. the atomic compare-exchange failed).
  */
-static int tdp_mmu_link_sp_atomic(struct kvm *kvm, struct tdp_iter *iter,
-				  struct kvm_mmu_page *sp, bool account_nx)
+static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
+			   struct kvm_mmu_page *sp, bool account_nx,
+			   bool shared)
 {
 	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
-	int ret;
+	int ret = 0;
 
-	ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
-	if (ret)
-		return ret;
+	if (shared) {
+		ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
+		if (ret)
+			return ret;
+	} else {
+		tdp_mmu_set_spte(kvm, iter, spte);
+	}
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
@@ -1031,7 +1037,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			sp = tdp_mmu_alloc_sp(vcpu);
 			tdp_mmu_init_child_sp(sp, &iter);
 
-			if (tdp_mmu_link_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
+			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
@@ -1262,12 +1268,11 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 }
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
-						       struct tdp_iter *iter)
+						       struct tdp_iter *iter,
+						       bool shared)
 {
 	struct kvm_mmu_page *sp;
 
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
 	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
@@ -1282,20 +1287,27 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		return sp;
 
 	rcu_read_unlock();
-	read_unlock(&kvm->mmu_lock);
+
+	if (shared)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
 	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
 
-	read_lock(&kvm->mmu_lock);
+	if (shared)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
+
 	rcu_read_lock();
 
 	return sp;
 }
 
-static int tdp_mmu_split_huge_page_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  struct kvm_mmu_page *sp)
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared)
 {
 	const u64 huge_spte = iter->old_spte;
 	const int level = iter->level;
@@ -1318,7 +1330,7 @@ static int tdp_mmu_split_huge_page_atomic(struct kvm *kvm,
 	 * correctness standpoint since the translation will be the same either
 	 * way.
 	 */
-	ret = tdp_mmu_link_sp_atomic(kvm, iter, sp, false);
+	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
 	if (ret)
 		return ret;
 
@@ -1335,7 +1347,7 @@ static int tdp_mmu_split_huge_page_atomic(struct kvm *kvm,
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 					 struct kvm_mmu_page *root,
 					 gfn_t start, gfn_t end,
-					 int target_level)
+					 int target_level, bool shared)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct tdp_iter iter;
@@ -1356,14 +1368,14 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 */
 	for_each_tdp_pte_min_level(iter, root, target_level + 1, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
 			continue;
 
 		if (!sp) {
-			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter);
+			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, shared);
 			if (!sp) {
 				ret = -ENOMEM;
 				break;
@@ -1373,7 +1385,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}
 
-		if (tdp_mmu_split_huge_page_atomic(kvm, &iter, sp))
+		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
 			goto retry;
 
 		sp = NULL;
@@ -1393,23 +1405,24 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	return ret;
 }
 
+
 /*
  * Try to split all huge pages mapped by the TDP MMU down to the target level.
  */
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      gfn_t start, gfn_t end,
-				      int target_level)
+				      int target_level, bool shared)
 {
 	struct kvm_mmu_page *root;
 	int r = 0;
 
-	lockdep_assert_held_read(&kvm->mmu_lock);
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true) {
-		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, shared) {
+		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
 		if (r) {
-			kvm_tdp_mmu_put_root(kvm, root, true);
+			kvm_tdp_mmu_put_root(kvm, root, shared);
 			break;
 		}
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 4a8756507829..ed9f6fbf5f25 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -74,7 +74,7 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      gfn_t start, gfn_t end,
-				      int target_level);
+				      int target_level, bool shared);
 
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5aad3e8e0a0..e2ee6fc92dbc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -192,7 +192,7 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
-static bool __read_mostly eager_page_split = true;
+bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
 /*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1ebd5a7594da..d1836f69f20c 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -352,6 +352,8 @@ extern int pi_inject_timer;
 
 extern bool report_ignored_msrs;
 
+extern bool eager_page_split;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
-- 
2.35.0.rc0.227.g00780c9af4-goog

