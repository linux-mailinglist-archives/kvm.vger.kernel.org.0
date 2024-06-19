Return-Path: <kvm+bounces-20016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE82E90F90E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 00:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F891B2136B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 22:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1C515B157;
	Wed, 19 Jun 2024 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efXdoIgL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4114654D;
	Wed, 19 Jun 2024 22:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718836585; cv=none; b=mkKm5B1Z7/w8B97/l7NzXqz4ankmUpGKDnUGT5Vv72iyahE6um6pgd0ZeXF5XD+gqGjVJ+L3gORIt9+F959NCjB8jcHDS4rhuPwDiD4M+030qIelIbixkaVyjF+CN9fWEr/ddDaEtnRuVileA8UjRBSvij4XggDn5KlzL2UM1vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718836585; c=relaxed/simple;
	bh=VmemIAUgnP3098dvCm7mVzhdbNFuPHYOops+7ZyOUTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YZSnYcIq/Mgheb0b/fyr7NyhoLkLfk7kj6nyZA1XeFmTtIWBzNY2eDeixu6DLF650fxGm9TECbcs+Zecpnf1cSWtIbzfr4C3GEtfnOVDgpYd+aP9AVhV7l+ew77Xgc0JlyQThpYe1jdsR06W0YKa6paPygM1Bmis0qNCTJxhCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efXdoIgL; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718836583; x=1750372583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VmemIAUgnP3098dvCm7mVzhdbNFuPHYOops+7ZyOUTo=;
  b=efXdoIgLdfAu0jCZIXIPp/wacNRJtHgEi0qbVmr1QJjvgKaYxl86bgf4
   0rU5hYIMRamv9CzTNfXuAsd+2DEkvlRi+cafIwNU7p01W0nF+RJAjS40B
   nRzvir7elQ8x5R2IJbDXUeVjLX8yNrc38aweSw7nFxGSJ6vL2SGb6SxvG
   aUpDawkzWGRI1MSLlConMTsnjmQVu+eXyJ3xCb9Airdy2c8gwWdC/F1OT
   0J/2wntLe/QXjaAJ59wssu22dF6o2CrDSje8hbdqqHtNtXQco8yJOU/iR
   FaDWvvcemYeiDX90/CRYG93LSz28ENeHShg7GXCn+vl2iCbbftj4ja/ZB
   A==;
X-CSE-ConnectionGUID: 5xZxmEB8SHS9F17/2e2xIg==
X-CSE-MsgGUID: vNpONqOuQHKykU1iW80Ezg==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15931928"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="15931928"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:20 -0700
X-CSE-ConnectionGUID: ZS6iWqvrReW330pvwa2taA==
X-CSE-MsgGUID: Hq8nqKhnQECcppOjhIpM4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="72793319"
Received: from ivsilic-mobl2.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.54.39])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 15:36:19 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 01/17] KVM: x86/tdp_mmu: Rename REMOVED_SPTE to FROZEN_SPTE
Date: Wed, 19 Jun 2024 15:35:58 -0700
Message-Id: <20240619223614.290657-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename REMOVED_SPTE to FROZEN_SPTE so that it can be used for other
multi-part operations.

REMOVED_SPTE is used as a non-present intermediate value for multi-part
operations that can happen when a thread doesn't have an MMU write lock.
Today these operations are when removing PTEs.

However, future changes will want to use the same concept for setting a
PTE. In that case the REMOVED_SPTE name does not quite fit. So rename it
to FROZEN_SPTE so it can be used for both types of operations.

Also rename the relevant helpers and comments that refer to "removed"
within the context of the SPTE value. Take care to not update naming
referring the "remove" operations, which are still distinct.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Prep v3:
 - New patch
---
 arch/x86/kvm/mmu/mmu.c     |  2 +-
 arch/x86/kvm/mmu/spte.c    |  2 +-
 arch/x86/kvm/mmu/spte.h    | 10 ++++-----
 arch/x86/kvm/mmu/tdp_mmu.c | 42 +++++++++++++++++++-------------------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61982da8c8b2..828c70ead96f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3455,7 +3455,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * available as the vCPU holds a reference to its root(s).
 		 */
 		if (WARN_ON_ONCE(!sptep))
-			spte = REMOVED_SPTE;
+			spte = FROZEN_SPTE;
 
 		if (!is_shadow_present_pte(spte))
 			break;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a5e014d7bc62..59cac37615b6 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -383,7 +383,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	 * not set any RWX bits.
 	 */
 	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
-	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
+	    WARN_ON(mmio_value && (FROZEN_SPTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
 	if (!mmio_value)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 5dd5405fa07a..86e5259aa824 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -200,7 +200,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 
 /*
  * If a thread running without exclusive control of the MMU lock must perform a
- * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
+ * multi-part operation on an SPTE, it can set the SPTE to FROZEN_SPTE as a
  * non-present intermediate value. Other threads which encounter this value
  * should not modify the SPTE.
  *
@@ -210,14 +210,14 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  *
  * Only used by the TDP MMU.
  */
-#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
+#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
-static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
 
-static inline bool is_removed_spte(u64 spte)
+static inline bool is_frozen_spte(u64 spte)
 {
-	return spte == REMOVED_SPTE;
+	return spte == FROZEN_SPTE;
 }
 
 /* Get an SPTE's index into its parent's page table (and the spt array). */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 36539c1b36cd..16b54208e8d7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -365,8 +365,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * value to the removed SPTE value.
 			 */
 			for (;;) {
-				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, REMOVED_SPTE);
-				if (!is_removed_spte(old_spte))
+				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, FROZEN_SPTE);
+				if (!is_frozen_spte(old_spte))
 					break;
 				cpu_relax();
 			}
@@ -397,11 +397,11 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * No retry is needed in the atomic update path as the
 			 * sole concern is dropping a Dirty bit, i.e. no other
 			 * task can zap/remove the SPTE as mmu_lock is held for
-			 * write.  Marking the SPTE as a removed SPTE is not
+			 * write.  Marking the SPTE as a frozen SPTE is not
 			 * strictly necessary for the same reason, but using
-			 * the remove SPTE value keeps the shared/exclusive
+			 * the frozen SPTE value keeps the shared/exclusive
 			 * paths consistent and allows the handle_changed_spte()
-			 * call below to hardcode the new value to REMOVED_SPTE.
+			 * call below to hardcode the new value to FROZEN_SPTE.
 			 *
 			 * Note, even though dropping a Dirty bit is the only
 			 * scenario where a non-atomic update could result in a
@@ -413,10 +413,10 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * it here.
 			 */
 			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
-							  REMOVED_SPTE, level);
+							  FROZEN_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+				    old_spte, FROZEN_SPTE, level, shared);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -490,19 +490,19 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (!was_present && !is_present) {
 		/*
-		 * If this change does not involve a MMIO SPTE or removed SPTE,
+		 * If this change does not involve a MMIO SPTE or frozen SPTE,
 		 * it is unexpected. Log the change, though it should not
 		 * impact the guest since both the former and current SPTEs
 		 * are nonpresent.
 		 */
 		if (WARN_ON_ONCE(!is_mmio_spte(kvm, old_spte) &&
 				 !is_mmio_spte(kvm, new_spte) &&
-				 !is_removed_spte(new_spte)))
+				 !is_frozen_spte(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
 			       "different nonpresent SPTE, unless one or both\n"
 			       "are MMIO SPTEs, or the new SPTE is\n"
-			       "a temporary removed SPTE.\n"
+			       "a temporary frozen SPTE.\n"
 			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
 			       as_id, gfn, old_spte, new_spte, level);
 		return;
@@ -540,7 +540,7 @@ static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 new_spte)
 	 * and pre-checking before inserting a new SPTE is advantageous as it
 	 * avoids unnecessary work.
 	 */
-	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
+	WARN_ON_ONCE(iter->yielded || is_frozen_spte(iter->old_spte));
 
 	/*
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
@@ -603,26 +603,26 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * in its place before the TLBs are flushed.
 	 *
 	 * Delay processing of the zapped SPTE until after TLBs are flushed and
-	 * the REMOVED_SPTE is replaced (see below).
+	 * the FROZEN_SPTE is replaced (see below).
 	 */
-	ret = __tdp_mmu_set_spte_atomic(iter, REMOVED_SPTE);
+	ret = __tdp_mmu_set_spte_atomic(iter, FROZEN_SPTE);
 	if (ret)
 		return ret;
 
 	kvm_flush_remote_tlbs_gfn(kvm, iter->gfn, iter->level);
 
 	/*
-	 * No other thread can overwrite the removed SPTE as they must either
+	 * No other thread can overwrite the frozen SPTE as they must either
 	 * wait on the MMU lock or use tdp_mmu_set_spte_atomic() which will not
-	 * overwrite the special removed SPTE value. Use the raw write helper to
+	 * overwrite the special frozen SPTE value. Use the raw write helper to
 	 * avoid an unnecessary check on volatile bits.
 	 */
 	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
 
 	/*
 	 * Process the zapped SPTE after flushing TLBs, and after replacing
-	 * REMOVED_SPTE with 0. This minimizes the amount of time vCPUs are
-	 * blocked by the REMOVED_SPTE and reduces contention on the child
+	 * FROZEN_SPTE with 0. This minimizes the amount of time vCPUs are
+	 * blocked by the FROZEN_SPTE and reduces contention on the child
 	 * SPTEs.
 	 */
 	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
@@ -652,12 +652,12 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	/*
 	 * No thread should be using this function to set SPTEs to or from the
-	 * temporary removed SPTE value.
+	 * temporary frozen SPTE value.
 	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
 	 * should be used. If operating under the MMU lock in write mode, the
-	 * use of the removed SPTE should not be necessary.
+	 * use of the frozen SPTE should not be necessary.
 	 */
-	WARN_ON_ONCE(is_removed_spte(old_spte) || is_removed_spte(new_spte));
+	WARN_ON_ONCE(is_frozen_spte(old_spte) || is_frozen_spte(new_spte));
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
@@ -1126,7 +1126,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * If SPTE has been frozen by another thread, just give up and
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
-		if (is_removed_spte(iter.old_spte))
+		if (is_frozen_spte(iter.old_spte))
 			goto retry;
 
 		if (iter.level == fault->goal_level)
-- 
2.34.1


