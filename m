Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83954CDEF6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiCDUct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiCDUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06371EE27A;
        Fri,  4 Mar 2022 12:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425888; x=1677961888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+5iY4EVYMK6Gi7h7yMuInIlU9MlrM8w7YpcJz0v4d6w=;
  b=VNSho6iHWhOkYBRhaVLsnknT1BuHB3+28OM+ZwfJkAszJaWcSxM4rR7A
   7uBwIvheTryYAlcBnU+6O5QDZx9w5wfmA0fAZl44o2Cu5duZG3rxWAUsz
   TGHi22XPDyP/06bDOg4TRgXb2UlZYiGmz5y1vU/xSYOgx6ETj1yTcRVfK
   TQmP+yRBwOeBN3VBVe7lfFSyNtytif5T1RmRApLJVd2XFu4vRAe5bjtZn
   zh6OEq1idsKtVYqwlwVN9wBYQIN8Y0HktDcUN74y5s7orZ7gmhGOoO1+j
   QRdBOU6e32LxFddb2FtxZxM8FG603t4rtbtwxlsZFhxXqLNs3HFHLdOFv
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624226"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624226"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:28 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344409"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:28 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 056/104] KVM: x86/tdp_mmu: implement MapGPA hypercall for TDX
Date:   Fri,  4 Mar 2022 11:49:12 -0800
Message-Id: <7b7802a00e7dd1582db99fff1d6868303a4264c1.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

- Zap the aliased region.
  If shared (or private) GPA is requested, zap private (or shared) GPA
  (modulo shared bit).

- Record the request GPA is shared (or private) by SPTE_PRIVATE_PROHIBIT
  in SPTE in both shared and private EPT tables.
  - With SPTE_PRIVATE_PROHIBIT set, a shared GPA is allowed.
  - With SPTE_PRIVATE_PROHIBIT cleared, a private GPA is allowed.

  The reason to record SPTE_PRIVATE_PROHIBIT in both shared and private EPT
  is to optimize EPT violation path for normal guest TD execution path and
  penalize map_gpa hypercall.

  If the guest TD faults on not-allowed GPA (modulo shared bit), the KVM
  doesn't resolve EPT violation and let vcpu retry.  vcpu will keep
  faulting until other vcpu maps the region with MapGPA hypercall.  With
  the initial value of spte(initial shadow_init_value),
  SPTE_PRIVATE_PROHIBIT is cleared.  So the default behavior doesn't
  change.

- don't map GPA.
  The GPA is mapped on the next EPT violation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h         |   2 +
 arch/x86/kvm/mmu/mmu.c     |  56 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 208 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |   3 +
 4 files changed, 269 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b49841e4faaa..ac4540aa694d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -305,6 +305,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end);
+
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0ec9548ff4dd..e2d4a7d546e1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6119,6 +6119,62 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+int kvm_mmu_map_gpa(struct kvm_vcpu *vcpu, gfn_t *startp, gfn_t end)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	gfn_t start = *startp;
+	bool allow_private;
+	int ret;
+
+	if (!kvm_gfn_stolen_mask(kvm))
+		return -EOPNOTSUPP;
+
+	ret = mmu_topup_memory_caches(vcpu, false);
+	if (ret)
+		return ret;
+
+	allow_private = kvm_is_private_gfn(kvm, start);
+	start = kvm_gfn_unalias(kvm, start);
+	end = kvm_gfn_unalias(kvm, end);
+
+	mutex_lock(&kvm->slots_lock);
+	write_lock(&kvm->mmu_lock);
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
index f6bd35831e32..b33ace3d4456 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -533,6 +533,13 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 			WARN_ON(sp->gfn != gfn);
 		}
 
+		/*
+		 * SPTE_PRIVATE_PROHIBIT is only changed by map_gpa that obtains
+		 * write lock of mmu_lock.
+		 */
+		WARN_ON(shared &&
+			(is_private_prohibit_spte(old_spte) !=
+				is_private_prohibit_spte(new_spte)));
 		static_call(kvm_x86_handle_changed_private_spte)(
 			kvm, gfn, level,
 			old_pfn, was_present, was_leaf,
@@ -1751,6 +1758,207 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
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
+		 * granular of 4K in private leaf spte as SPTE_PRIVATE_PROHIBIT.
+		 * Break large page into 4K.
+		 */
+		if (is_shadow_present_pte(iter.old_spte) &&
+			is_large_pte(iter.old_spte)) {
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			WARN_ON_ONCE(true);
+			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
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
+			if (!tdp_mmu_populate_nonleaf(
+					vcpu, &iter, is_private, false)) {
+				/* As write lock is held, this case sholdn't happen. */
+				WARN_ON_ONCE(true);
+				ret = -EAGAIN;
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
+	WARN_ON(kvm_is_private_gfn(kvm, iter->gfn));
+	if (allow_private) {
+		/* Zap SPTE and clear PRIVATE_PROHIBIT */
+		new_spte = shadow_init_value;
+		if (new_spte != iter->old_spte)
+			tdp_mmu_set_spte(kvm, iter, new_spte);
+	} else {
+		new_spte = iter->old_spte | SPTE_PRIVATE_PROHIBIT;
+		/* No side effect is needed */
+		if (new_spte != iter->old_spte)
+			WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+	}
+}
+
+static void kvm_tdp_mmu_update_private_spte(
+	struct kvm *kvm, struct tdp_iter *iter, bool allow_private)
+{
+	u64 new_spte;
+
+	WARN_ON(!kvm_is_private_gfn(kvm, iter->gfn));
+	if (allow_private) {
+		new_spte = iter->old_spte & ~SPTE_PRIVATE_PROHIBIT;
+		/* No side effect is needed */
+		if (new_spte != iter->old_spte)
+			WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+	} else {
+		if (is_shadow_present_pte(iter->old_spte)) {
+			/* Zap SPTE */
+			new_spte = shadow_init_value | SPTE_PRIVATE_PROHIBIT;
+			tdp_mmu_set_spte(kvm, iter, new_spte);
+		} else {
+			new_spte = iter->old_spte | SPTE_PRIVATE_PROHIBIT;
+			/* No side effect is needed */
+			WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
+		}
+	}
+}
+
+/*
+ * Whether GPA is allowed to map private or shared is recorded in both private
+ * and shared leaf spte entry as SPTE_PRIVATE_PROHIBIT bit.  They must match.
+ * private leaf spte entry
+ * - present: private mapping is allowed. (already mapped)
+ * - non-present: private mapping is allowed.
+ * - present | PRIVATE_PROHIBIT: invalid state.
+ * - non-present | SPTE_PRIVATE_PROHIBIT: shared mapping is allowed.
+ *                                        may or may not be mapped as shared.
+ * shared leaf spte entry
+ * - present: invalid state
+ * - non-present: private mapping is allowed.
+ * - present | PRIVATE_PROHIBIT: shared mapping is allowed (already mapped)
+ * - non-present | PRIVATE_PROHIBIT: shared mapping is allowed.
+ *
+ * state change of private spte:
+ * map_gpa(private):
+ *      private EPT entry: clear PRIVATE_PROHIBIT
+ *	  present: nop
+ *	  non-present: nop
+ *	  non-present | PRIVATE_PROHIBIT -> non-present
+ *	share EPT entry: zap and clear PRIVATE_PROHIBIT
+ *	  any -> non-present
+ * map_gpa(shared):
+ *	private EPT entry: zap and set PRIVATE_PROHIBIT
+ *	  present     -> non-present | PRIVATE_PROHIBIT
+ *	  non-present -> non-present | PRIVATE_PROHIBIT
+ *	  non-present | PRIVATE_PROHIBIT: nop
+ *	shared EPT entry: set PRIVATE_PROHIBIT
+ *	  present | PRIVATE_PROHIBIT: nop
+ *	  non-present -> non-present | PRIVATE_PROHIBIT
+ *	  non-present | PRIVATE_PROHIBIT: nop
+ * map(private GPA):
+ *	private EPT entry: try to populate
+ *	  present: nop
+ *	  non-present -> present
+ *	  non-present | PRIVATE_PROHIBIT: nop. looping on EPT violation
+ *	shared EPT entry: nop
+ * map(shared GPA):
+ *	private EPT entry: nop
+ *	shared EPT entry: populate
+ *	  present | PRIVATE_PROHIBIT: nop
+ *	  non-present | PRIVATE_PROHIBIT -> present | PRIVATE_PROHIBIT
+ *	  non-present: nop. looping on EPT violation
+ * zap(private GPA):
+ *	private EPT entry: zap and keep PRIVATE_PROHIBIT
+ *	  present | PRIVATE_PROHIBIT -> non-present | PRIVATE_PROHIBIT
+ *	  non-present: nop as is_shadow_prsent_pte() is checked
+ *	  non-present | PRIVATE_PROHIBIT: nop by is_shadow_present_pte()
+ *	shared EPT entry: nop
+ * zap(shared GPA):
+ *	private EPT entry: nop
+ *	shared EPT entry: zap and keep PRIVATE_PROHIBIT
+ *	  present | PRIVATE_PROHIBIT -> non-present | PRIVATE_PROHIBIT
+ *	  non-present | PRIVATE_PROHIBIT: nop
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
+	WARN_ON(start & kvm_gfn_stolen_mask(kvm));
+	WARN_ON(end & kvm_gfn_stolen_mask(kvm));
+
+	if (!VALID_PAGE(mmu->root_hpa) || !VALID_PAGE(mmu->private_root_hpa))
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
+	ret = kvm_tdp_mmu_update_range(vcpu, true, start, end, &next,
+				kvm_tdp_mmu_update_private_spte, allow_private);
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
index 7c62f694a465..0f83960d92aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -74,6 +74,9 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
+int kvm_tdp_mmu_map_gpa(struct kvm_vcpu *vcpu,
+			gfn_t *startp, gfn_t end, bool is_private);
+
 static inline void kvm_tdp_mmu_walk_lockless_begin(void)
 {
 	rcu_read_lock();
-- 
2.25.1

