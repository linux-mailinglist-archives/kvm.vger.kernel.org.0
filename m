Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97BA667B7A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240795AbjALQm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbjALQic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149A41B9E7;
        Thu, 12 Jan 2023 08:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541243; x=1705077243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mie8QegZ2aEl5qpoN94IcOYXwBiaYiRDHtMdRE5pptQ=;
  b=NW4q3R3FwaPCwsoUpeUrH9mYi8RVHgCMXvEySYF9cxfyMjQY94zrBxw8
   NdAJ/oLfM4qw0jsKbgBfw4yvzxeNaeG9mRFn7wGpliscZPeVVA9wP+wjs
   XgQe33PE/w/VjMpjZsPqaRVq+yCOotga7Oxjw9o9Np+dRhKjZGwK8wXe0
   fCEI0iACX2Fvz/WmWg/YcGlw+TRY66eJzb21L2xmVnU9QKvhB+zGtGHSy
   8BLr1kTsLjAUMFZtlnKE4Qsj9pM+kQygmf6GO7fN/TRJDRl7ptP7jo56S
   U8GLGukeBNzfHu+WJuT8czoLcQ/E8a+cjxGup6W92voFY3VM30bbgSRoW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811863"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811863"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151785"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151785"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 044/113] KVM: x86/tdp_mmu: Make handle_changed_spte() return value
Date:   Thu, 12 Jan 2023 08:31:52 -0800
Message-Id: <7cbce6eff935d9d64fa4638f5f6085ac1b8de9bb.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX operation can fail with TDX_OPERAND_BUSY when multiple vcpu try to
operation on same TDX resource like Secure EPT.  It doesn't spin and returns
busy error to VMM so that VMM has to take action, e.g. retry or whatever.

Because TDP MMU uses read spin lock for scalability, spinlock around seam
call busts TDP MMU effort.  The other option is to let SEAMCALL fail and
page fault handler should retry.  Make handle_changed_spte() and its caller
return values so that kvm page fault handler can return on such cases. This
patch makes it return only zero.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 72 +++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7ab498b80214..4fb07f91e5d6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -349,9 +349,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	return __pa(root->spt);
 }
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+					    u64 old_spte, u64 new_spte, int level,
+					    bool shared);
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
@@ -445,6 +445,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
 	gfn_t base_gfn = sp->gfn;
+	int ret;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
@@ -516,8 +517,14 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
 							  REMOVED_SPTE, level);
 		}
-		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+		ret = handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
+					  old_spte, REMOVED_SPTE, level, shared);
+		/*
+		 * We are removing page tables.  Because in TDX case we don't
+		 * zap private page tables except tearing down VM.  It means
+		 * no race condition.
+		 */
+		WARN_ON_ONCE(ret);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -538,9 +545,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
-static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+static int __must_check __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+					      u64 old_spte, u64 new_spte, int level,
+					      bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -576,7 +583,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 
 	if (old_spte == new_spte)
-		return;
+		return 0;
 
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
@@ -605,7 +612,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 			       "a temporary removed SPTE.\n"
 			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
 			       as_id, gfn, old_spte, new_spte, level);
-		return;
+		return 0;
 	}
 
 	if (is_leaf != was_leaf)
@@ -624,17 +631,25 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+
+	return 0;
 }
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+					    u64 old_spte, u64 new_spte, int level,
+					    bool shared)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
+	int ret;
+
+	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
+				    shared);
+	if (ret)
+		return ret;
+
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 				      new_spte, level);
+	return 0;
 }
 
 /*
@@ -653,12 +668,14 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * * -EBUSY - If the SPTE cannot be set. In this case this function will have
  *            no side-effects other than setting iter->old_spte to the last
  *            known value of the spte.
+ * * -EAGAIN - Same to -EBUSY. But the source is from callbacks for private spt
  */
-static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  u64 new_spte)
+static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
+	int ret;
 
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
@@ -677,15 +694,16 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
 		return -EBUSY;
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
-	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+	ret = __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+				    new_spte, iter->level, true);
+	if (!ret)
+		handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
-	return 0;
+	return ret;
 }
 
-static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter)
+static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	int ret;
 
@@ -750,6 +768,8 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
 			      bool record_acc_track, bool record_dirty_log)
 {
+	int ret;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -763,7 +783,9 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	/* Because write spin lock is held, no race.  It should success. */
+	WARN_ON_ONCE(ret);
 
 	if (record_acc_track)
 		handle_changed_spte_acc_track(old_spte, new_spte, level);
-- 
2.25.1

