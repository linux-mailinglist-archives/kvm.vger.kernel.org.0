Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797D055DE7B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241828AbiF0V44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241554AbiF0Vzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F23DF66;
        Mon, 27 Jun 2022 14:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366903; x=1687902903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=411epus5AX5Qv62riJ2Q7lIyk4q64OuSxGdP/khrKOE=;
  b=dJ8Bzcp43v5VKthCAzrTyfDLUyQv53cgAdkcj2Yvintd4i9qLt7aC7ya
   LjbeYKpi98NoYQIdMkKX8yyAvKvyEz75FnnYwoU8b6N9RWrWNsijar2F4
   +gPpVzhb7UpG4unc5BD8St2oRA/fyvbQOQtFHy3r+Z1CQ4gxcFf+fC4RJ
   IX0Hhe/Gr+Qms5zPPijTC3Ngsjtz0LQ1OVMgyuAYrzi7LvY12Zr6o1+45
   WXu5vjSeMpzU9lkms0Wt75bZeSOrjm9JjmfloGSn+IHw99QyJ+Cv2fRGR
   F4RLEk6z+WNTn5QVq27ZzE2tydqMnVrQEWoVrfiDdq2T4JzB21FlYCpUM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609593"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609593"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863620"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 057/102] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Mon, 27 Jun 2022 14:53:49 -0700
Message-Id: <7cda2771dffb7a70a33c30eca46ad703638c34d3.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX Guest-Hypervisor communication interface(GHCI) specification
defines MapGPA hypercall for guest TD to request the host VMM to map given
GPA range as private or shared.

It means the guest TD uses the GPA as shared (or private).  The GPA
won't be used as private (or shared).  VMM should enforce GPA usage. VMM
doesn't have to map the GPA on the hypercall request.

- Allocate 4k PTE to record SPTE_SHARED_MASK bit.

- Zap the aliased region.
  If shared (or private) GPA is requested, zap private (or shared) GPA
  (modulo shared bit).

- Record the request GPA is shared (or private) by SPTE_SHARED_MASK in SPTE
  in both shared and private EPT tables.
  - With SPTE_SHARED_MASK set, a shared GPA is allowed.
  - With SPTE_SHARED_MASK cleared, a private GPA is allowed.

  The reason to record SPTE_SHARED_MASK in both shared and private EPT
  is to optimize EPT violation path for normal guest TD execution path and
  penalize map_gpa hypercall.

  If the guest TD faults on not-allowed GPA (modulo shared bit), the KVM
  doesn't resolve EPT violation and let vcpu retry.  vcpu will keep
  faulting until other vcpu maps the region with MapGPA hypercall.  With
  the nonpresent value of spte(shadow_nonpresent_value), SPTE_SHARED_MASK
  is cleared.  So the default behavior doesn't change.

- don't map GPA.
  The GPA is mapped on the next EPT violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h         |   3 +
 arch/x86/kvm/mmu/mmu.c     | 106 +++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 271 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h |   5 +
 4 files changed, 382 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9ba60fd79d33..f5edf2e58dba 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -225,6 +225,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool allow_private);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef925722ee28..a777a1d4278c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6323,6 +6323,112 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+static int kvm_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	int ret = 0;
+
+	/* No need to populate as mmu_map_gpa() handles single GPA. */
+	if (!is_tdp_mmu_enabled(kvm))
+		return 0;
+
+	slots = __kvm_memslots(kvm, 0 /* only normal ram. not SMM. */);
+	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t s = max(start, memslot->base_gfn);
+		gfn_t e = min(end, memslot->base_gfn + memslot->npages);
+
+		if (WARN_ON_ONCE(s >= e))
+			continue;
+
+		ret = kvm_tdp_mmu_populate_nonleaf(vcpu, kvm_gfn_private(kvm, s),
+						kvm_gfn_private(kvm, e), true, false);
+		if (ret)
+			break;
+		ret = kvm_tdp_mmu_populate_nonleaf(vcpu, kvm_gfn_shared(kvm, s),
+						kvm_gfn_shared(kvm, e), false, false);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		bool allow_private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	gfn_t start = *startp;
+	int ret;
+
+	if (!kvm_gfn_shared_mask(kvm))
+		return -EOPNOTSUPP;
+
+	start = start & ~kvm_gfn_shared_mask(kvm);
+	end = end & ~kvm_gfn_shared_mask(kvm);
+
+	/*
+	 * Allocate S-EPT pages first so that the operations leaf SPTE entry
+	 * can be done without memory allocation.
+	 */
+	while (true) {
+		ret = mmu_topup_memory_caches(vcpu, false);
+		if (ret)
+			return ret;
+
+		mutex_lock(&kvm->slots_lock);
+		write_lock(&kvm->mmu_lock);
+
+		ret = kvm_mmu_populate_nonleaf(vcpu, start, end);
+		if (!ret)
+			break;
+
+		write_unlock(&kvm->mmu_lock);
+		mutex_unlock(&kvm->slots_lock);
+		if (ret == -EAGAIN) {
+			if (need_resched())
+				cond_resched();
+			continue;
+		}
+		return ret;
+	}
+
+	slots = __kvm_memslots(kvm, 0 /* only normal ram. not SMM. */);
+	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t s = max(start, memslot->base_gfn);
+		gfn_t e = min(end, memslot->base_gfn + memslot->npages);
+
+		if (WARN_ON_ONCE(s >= e))
+			continue;
+		if (is_tdp_mmu_enabled(kvm)) {
+			ret = kvm_tdp_mmu_map_gpa(vcpu, &s, e, allow_private);
+			if (ret) {
+				start = s;
+				break;
+			}
+		} else {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+	}
+
+	write_unlock(&kvm->mmu_lock);
+	mutex_unlock(&kvm->slots_lock);
+
+	if (ret == -EAGAIN) {
+		if (allow_private)
+			*startp = kvm_gfn_private(kvm, start);
+		else
+			*startp = kvm_gfn_shared(kvm, start);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_gpa);
+
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4f279700b3cc..c99f2c9a86dc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -680,6 +680,13 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		}
 		change.sept_page = sept_page;
 
+		/*
+		 * SPTE_SHARED_MASK is only changed by map_gpa that obtains
+		 * write lock of mmu_lock.
+		 */
+		WARN_ON(shared &&
+			(spte_shared_mask(old_spte) !=
+				spte_shared_mask(new_spte)));
 		static_call(kvm_x86_handle_changed_private_spte)(kvm, &change);
 	}
 }
@@ -1324,7 +1331,8 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
-static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
+static int tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx, bool shared)
 {
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1335,7 +1343,7 @@ static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter
 	sp = tdp_mmu_alloc_sp(vcpu, iter->is_private, false);
 	tdp_mmu_init_child_sp(sp, iter);
 
-	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
+	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, shared);
 	if (ret)
 		tdp_mmu_free_sp(sp);
 	return ret;
@@ -1411,7 +1419,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
+			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx, true))
 				break;
 		}
 	}
@@ -2143,6 +2151,263 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+/*
+ * Allocate shadow page table for given gfn so that the following operations
+ * on sptes can be done without memory allocation.
+ */
+int kvm_tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, gfn_t start, gfn_t end, bool is_private, bool shared)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tdp_iter iter;
+	int ret = 0;
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, false);
+	rcu_read_lock();
+	tdp_mmu_for_each_pte(iter, vcpu->arch.mmu, is_private, start, end) {
+		if (iter.level == PG_LEVEL_4K)
+			continue;
+		if (is_shadow_present_pte(iter.old_spte) &&
+			is_large_pte(iter.old_spte)) {
+			/* TODO: large page support. */
+			WARN_ON_ONCE(true);
+			return -ENOSYS;
+		}
+
+		if (is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * Guarantee that alloc_tdp_mmu_page() succees which
+		 * assumes page allocation from cache always successes.
+		 */
+		if (vcpu->arch.mmu_page_header_cache.nobjs == 0 ||
+			vcpu->arch.mmu_shadow_page_cache.nobjs == 0 ||
+			vcpu->arch.mmu_private_sp_cache.nobjs == 0) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		/*
+		 * write lock of mmu_lock is held.  No other thread
+		 * freezes SPTE.
+		 */
+		ret = tdp_mmu_populate_nonleaf(vcpu, &iter, false, shared);
+		if (ret) {
+			/* As write lock is held, this case sholdn't happen. */
+			WARN_ON_ONCE(true);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
+typedef void (*update_spte_t)(
+	struct kvm *kvm, struct tdp_iter *iter, bool allow_private);
+
+static int kvm_tdp_mmu_update_range(struct kvm_vcpu *vcpu, bool is_private,
+				gfn_t start, gfn_t end, gfn_t *nextp,
+				update_spte_t fn, bool allow_private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tdp_iter iter;
+	int ret = 0;
+
+	rcu_read_lock();
+	tdp_mmu_for_each_pte(iter, vcpu->arch.mmu, is_private, start, end) {
+		if (iter.level == PG_LEVEL_4K) {
+			fn(kvm, &iter, allow_private);
+			continue;
+		}
+
+		/*
+		 * Which GPA is allowed, private or shared, is recorded in the
+		 * granular of 4K in private leaf spte as SPTE_SHARED_MASK.
+		 * Break large page into 4K.
+		 */
+		if (is_shadow_present_pte(iter.old_spte) &&
+			is_large_pte(iter.old_spte)) {
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			WARN_ON_ONCE(true);
+			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
+			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
+		}
+
+		if (!is_shadow_present_pte(iter.old_spte)) {
+			/*
+			 * Guarantee that alloc_tdp_mmu_page() succees which
+			 * assumes page allocation from cache always successes.
+			 */
+			if (vcpu->arch.mmu_page_header_cache.nobjs == 0 ||
+				vcpu->arch.mmu_shadow_page_cache.nobjs == 0 ||
+				vcpu->arch.mmu_private_sp_cache.nobjs == 0) {
+				ret = -EAGAIN;
+				break;
+			}
+			/*
+			 * write lock of mmu_lock is held.  No other thread
+			 * freezes SPTE.
+			 */
+			ret = tdp_mmu_populate_nonleaf(vcpu, &iter, false, false);
+			if (ret) {
+				/* As write lock is held, this case sholdn't happen. */
+				WARN_ON_ONCE(true);
+				break;
+			}
+		}
+	}
+	rcu_read_unlock();
+
+	if (ret == -EAGAIN)
+		*nextp = iter.next_last_level_gfn;
+
+	return ret;
+}
+
+static void kvm_tdp_mmu_update_shared_spte(
+	struct kvm *kvm, struct tdp_iter *iter, bool allow_private)
+{
+	u64 new_spte;
+
+	WARN_ON(iter->is_private);
+	if (allow_private) {
+		/* Zap SPTE and clear SPTE_SHARED_MASK */
+		new_spte = SHADOW_NONPRESENT_VALUE;
+		if (new_spte != iter->old_spte)
+			tdp_mmu_set_spte(kvm, iter, new_spte);
+	} else {
+		new_spte = iter->old_spte | SPTE_SHARED_MASK;
+		/* No side effect is needed */
+		if (new_spte != iter->old_spte)
+			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	}
+}
+
+static void kvm_tdp_mmu_update_private_spte(
+	struct kvm *kvm, struct tdp_iter *iter, bool allow_private)
+{
+	u64 new_spte;
+
+	WARN_ON(!iter->is_private);
+	if (allow_private) {
+		new_spte = iter->old_spte & ~SPTE_SHARED_MASK;
+		/* No side effect is needed */
+		if (new_spte != iter->old_spte)
+			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+	} else {
+		if (is_shadow_present_pte(iter->old_spte)) {
+			/* Zap SPTE */
+			new_spte = shadow_nonpresent_spte(iter->old_spte) |
+				SPTE_SHARED_MASK;
+			if (new_spte != iter->old_spte)
+				tdp_mmu_set_spte(kvm, iter, new_spte);
+		} else {
+			new_spte = iter->old_spte | SPTE_SHARED_MASK;
+			/* No side effect is needed */
+			if (new_spte != iter->old_spte)
+				__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+		}
+	}
+}
+
+/*
+ * Whether GPA is allowed to map private or shared is recorded in both private
+ * and shared leaf spte entry as SPTE_SHARED_MASK bit.  They must match.
+ * private leaf spte entry
+ * - present: private mapping is allowed. (already mapped)
+ * - non-present: private mapping is allowed.
+ * - present | SPTE_SHARED_MASK: invalid state.
+ * - non-present | SPTE_SHARED_MASK: shared mapping is allowed.
+ *                                        may or may not be mapped as shared.
+ * shared leaf spte entry
+ * - present: invalid state
+ * - non-present: private mapping is allowed.
+ * - present | SPTE_SHARED_MASK: shared mapping is allowed (already mapped)
+ * - non-present | SPTE_SHARED_MASK: shared mapping is allowed.
+ *
+ * state change of private spte:
+ * map_gpa(private):
+ *      private EPT entry: clear SPTE_SHARED_MASK
+ *	  present: nop
+ *	  non-present: nop
+ *	  non-present | SPTE_SHARED_MASK -> non-present
+ *	share EPT entry: zap and clear SPTE_SHARED_MASK
+ *	  any -> non-present
+ * map_gpa(shared):
+ *	private EPT entry: zap and set SPTE_SHARED_MASK
+ *	  present     -> non-present | SPTE_SHARED_MASK
+ *	  non-present -> non-present | SPTE_SHARED_MASK
+ *	  non-present | SPTE_SHARED_MASK: nop
+ *	shared EPT entry: set SPTE_SHARED_MASK
+ *	  present | SPTE_SHARED_MASK: nop
+ *	  non-present -> non-present | SPTE_SHARED_MASK
+ *	  non-present | SPTE_SHARED_MASK: nop
+ * map(private GPA):
+ *	private EPT entry: try to populate
+ *	  present: nop
+ *	  non-present -> present
+ *	  non-present | SPTE_SHARED_MASK: nop. looping on EPT violation
+ *	shared EPT entry: nop
+ * map(shared GPA):
+ *	private EPT entry: nop
+ *	shared EPT entry: populate
+ *	  present | SPTE_SHARED_MASK: nop
+ *	  non-present | SPTE_SHARED_MASK -> present | SPTE_SHARED_MASK
+ *	  non-present: nop. looping on EPT violation
+ * zap(private GPA):
+ *	private EPT entry: zap and keep SPTE_SHARED_MASK
+ *	  present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
+ *	  non-present: nop as is_shadow_prsent_pte() is checked
+ *	  non-present | SPTE_SHARED_MASK: nop by is_shadow_present_pte()
+ *	shared EPT entry: nop
+ * zap(shared GPA):
+ *	private EPT entry: nop
+ *	shared EPT entry: zap and keep SPTE_SHARED_MASK
+ *	  present | SPTE_SHARED_MASK -> non-present | SPTE_SHARED_MASK
+ *	  non-present | SPTE_SHARED_MASK: nop
+ *	  non-present: nop.
+ */
+int kvm_tdp_mmu_map_gpa(struct kvm_vcpu *vcpu,
+			gfn_t *startp, gfn_t end, bool allow_private)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	gfn_t start = *startp;
+	gfn_t next;
+	int ret = 0;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	WARN_ON(start & kvm_gfn_shared_mask(kvm));
+	WARN_ON(end & kvm_gfn_shared_mask(kvm));
+
+	if (!VALID_PAGE(mmu->root.hpa) || !VALID_PAGE(mmu->private_root_hpa))
+		return -EINVAL;
+
+	next = end;
+	ret = kvm_tdp_mmu_update_range(
+		vcpu, false, kvm_gfn_shared(kvm, start), kvm_gfn_shared(kvm, end),
+		&next, kvm_tdp_mmu_update_shared_spte, allow_private);
+	if (ret) {
+		kvm_flush_remote_tlbs_with_address(kvm, start, next - start);
+		return ret;
+	}
+
+	ret = kvm_tdp_mmu_update_range(
+		vcpu, true, kvm_gfn_private(kvm, start), kvm_gfn_private(kvm, end),
+		&next, kvm_tdp_mmu_update_private_spte, allow_private);
+	if (ret == -EAGAIN) {
+		*startp = next;
+		end = *startp;
+	}
+	kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
+	return ret;
+}
+
 /*
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d1655571eb2f..4d1c27911134 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -51,6 +51,11 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 				      gfn_t start, gfn_t end,
 				      int target_level, bool shared);
 
+int kvm_tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
+				bool is_private, bool shared);
+int kvm_tdp_mmu_map_gpa(struct kvm_vcpu *vcpu,
+			gfn_t *startp, gfn_t end, bool allow_private);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
-- 
2.25.1

