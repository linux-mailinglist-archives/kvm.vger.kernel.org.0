Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7474CDE5F
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiCDUJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiCDUHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D171C9B57;
        Fri,  4 Mar 2022 12:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424142; x=1677960142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gRL60Eh24dbvczWyyL0w5AiCqy8X0iQtaAcE9wJT7Ow=;
  b=H9UKrRxbji5m1e6WhyjJpKIrodHIVicIgUHgMm6Y1aI4TBl51gEbw60E
   s2qz+XN7VxT+zMbc1lNpbeS1bM3lVCKCxoH16QKudaIQqwNGg7vaqJpbI
   yB5E6/PQwZ4dWF8UnwKvCyjowTDRgadcz9gzrKI3yICnAVpjDnYCwUF7b
   3ZmxMX5B8ehadY+V9ED/MJKPJX04DIesb3+UDozaTv7LyZGzxZeSH5ql3
   rhLgLTaf4z+bAle7Oo4eqQb0RHNiTMA6rlYoXEIAPoNOTMO/sZvOc1Bc9
   8wBxcmEM8VZJgwiYvI4Hrknu06JgAUTIXyX+4b4kQEXWZsx40LnSjh4Nx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983499"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983499"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:23 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344348"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:23 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 045/104] KVM: x86/tdp_mmu: make REMOVED_SPTE include shadow_initial value
Date:   Fri,  4 Mar 2022 11:49:01 -0800
Message-Id: <6614d2a2bc34441ed598830392b425fdf8e5ca52.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDP MMU uses REMOVED_SPTE = 0x5a0ULL as special constant to indicate the
intermediate value to indicate one thread is operating on it and the value
should be semi-arbitrary value.  For TDX (more correctly to use #VE), the
value should include suppress #VE value which is shadow_init_value.

Define SHADOW_REMOVED_SPTE as shadow_init_value | REMOVED_SPTE, and replace
REMOVED_SPTE with SHADOW_REMOVED_SPTE to use suppress #VE bit properly for
TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h    | 14 ++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++++++-------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index bde843bce878..e88f796724b4 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -194,7 +194,9 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * If a thread running without exclusive control of the MMU lock must perform a
  * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
  * non-present intermediate value. Other threads which encounter this value
- * should not modify the SPTE.
+ * should not modify the SPTE.  When TDX is enabled, shadow_init_value, which
+ * is "suppress #VE" bit set, is also set to removed SPTE, because TDX module
+ * always enables "EPT violation #VE".
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
  * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
@@ -207,9 +209,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
 
+/*
+ * See above comment around REMOVED_SPTE.  SHADOW_REMOVED_SPTE is the actual
+ * intermediate value set to the removed SPET.  When TDX is enabled, it sets
+ * the "suppress #VE" bit, otherwise it's REMOVED_SPTE.
+ */
+extern u64 __read_mostly shadow_init_value;
+#define SHADOW_REMOVED_SPTE	(shadow_init_value | REMOVED_SPTE)
+
 static inline bool is_removed_spte(u64 spte)
 {
-	return spte == REMOVED_SPTE;
+	return spte == SHADOW_REMOVED_SPTE;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ebd0a02620e8..b6ec2f112c26 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -338,7 +338,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			 * value to the removed SPTE value.
 			 */
 			for (;;) {
-				old_child_spte = xchg(sptep, REMOVED_SPTE);
+				old_child_spte = xchg(sptep, SHADOW_REMOVED_SPTE);
 				if (!is_removed_spte(old_child_spte))
 					break;
 				cpu_relax();
@@ -365,10 +365,10 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 			 * the two branches consistent and simplifies
 			 * the function.
 			 */
-			WRITE_ONCE(*sptep, REMOVED_SPTE);
+			WRITE_ONCE(*sptep, SHADOW_REMOVED_SPTE);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_child_spte, REMOVED_SPTE, level,
+				    old_child_spte, SHADOW_REMOVED_SPTE, level,
 				    shared);
 	}
 
@@ -537,7 +537,7 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, SHADOW_REMOVED_SPTE))
 		return false;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
@@ -550,8 +550,16 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * special removed SPTE value. No bookkeeping is needed
 	 * here since the SPTE is going from non-present
 	 * to non-present.
+	 *
+	 * Set non-present value to shadow_init_value, rather than 0.
+	 * It is because when TDX is enabled, TDX module always
+	 * enables "EPT-violation #VE", so KVM needs to set
+	 * "suppress #VE" bit in EPT table entries, in order to get
+	 * real EPT violation, rather than TDVMCALL.  KVM sets
+	 * shadow_init_value (which sets "suppress #VE" bit) so it
+	 * can be set when EPT table entries are zapped.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), shadow_init_value);
 
 	return true;
 }
@@ -748,7 +756,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared) {
-			tdp_mmu_set_spte(kvm, &iter, 0);
+			/* see comments in tdp_mmu_zap_spte_atomic() */
+			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
 			flush = true;
 		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
@@ -1135,7 +1144,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, 0);
+	tdp_mmu_set_spte(kvm, iter, shadow_init_value);
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1

