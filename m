Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CCC51C77A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383643AbiEESW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383231AbiEESTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B585654BF6;
        Thu,  5 May 2022 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774554; x=1683310554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zHlYPaq/CL1BkHg8xKNWjvjdVIGklNNMbNgXRzNRwcE=;
  b=jyLNLvpB1XqryX1ABVhAqe1nFCiqusHj8v+8/AvwqTX1A7UPhNyivrC/
   eNegEXYnXbtyk4Lh6IbCji/W88+W7QPSt1B9TcFsapSVw0h72uzYACfuW
   tp0u2tbUg2RZUAESqk9Y1rWJK7oLj9ic475SLTFY9cVG2HEXoxegXzws5
   Z7H92QJkgtaDAnoD2pr3c+emEmcLOcXrvjtOerlf2TNyOLf3gG09vGnNN
   2XuQB0A1XRGi/zdmw+K27HgacaWi64SyG10B+o4OxNwQjKbGR2k9Mijtc
   DLe3S2t5S3Ahj/r0bqC9fSaFOf5uVxb8u9tvmPQ+l/avIDGvGvGiclKFP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268354847"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268354847"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083353"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 058/104] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Thu,  5 May 2022 11:14:52 -0700
Message-Id: <fb8f699b7cdd1dc54c13b663e66dfa2cc82c5cd3.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d02c0274777a..beff084d6cd3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -316,6 +316,9 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end,
+		    bool allow_private);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4284e9cf9ec..497e2b9e58cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6317,6 +6317,112 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
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
index 1d7642a0acc9..8bcb241cc12c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -658,6 +658,13 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -1303,7 +1310,8 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
-static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
+static int tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx, bool shared)
 {
 	struct kvm_mmu_page *sp;
 	int ret;
@@ -1314,7 +1322,7 @@ static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter
 	sp = tdp_mmu_alloc_sp(vcpu, iter->is_private, false);
 	tdp_mmu_init_child_sp(sp, iter);
 
-	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
+	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, shared);
 	if (ret)
 		tdp_mmu_free_sp(sp);
 	return ret;
@@ -1390,7 +1398,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
+			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx, true))
 				break;
 		}
 	}
@@ -2096,6 +2104,263 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
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
+			kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
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
+			kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
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
+				kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
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

