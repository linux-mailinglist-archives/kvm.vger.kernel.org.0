Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6334176D030
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 16:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbjHBOiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 10:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbjHBOiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 10:38:07 -0400
Received: from mgamail.intel.com (unknown [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC5A213D;
        Wed,  2 Aug 2023 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690987085; x=1722523085;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=24AT3BpfQv6J5OZlOJTbIyfrZvqPdwnxbYzIc/ExOpA=;
  b=Jk5n2srX3FKZreQgC0czRN9fQriAMFNiYTNXdnPDqA/A0KVchZZIjwFb
   4meuB9pVQ4m0C9t+tl2ng4Ea1Nf2RxXm/0pii8D1TT/Efx4e5yPhvqzCH
   T73vIpkEAinYP7tINpog+lYf8NBitSIjL2pCX8I2dxdhpOs8gVl0eWz3E
   gkUPDmUMDJ4l9lqs29f4ljdvyyvHIF/TM8rwY4+f+x7P1LcSv9MhhqYnT
   cZ13pWesnRfOssD/OPMOj4SF4ECfiWbYBTGi758uc30n7fd/XmYNWY9PI
   P0efyF9Q5XvVSl2n8UBTmPM7a/aXyn5kA+e+H+9oYY8SAcbBx88K+ZtGn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="435925564"
X-IronPort-AV: E=Sophos;i="6.01,249,1684825200"; 
   d="scan'208";a="435925564"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 07:27:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="764230763"
X-IronPort-AV: E=Sophos;i="6.01,249,1684825200"; 
   d="scan'208";a="764230763"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orsmga001.jf.intel.com with ESMTP; 02 Aug 2023 07:27:39 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1] KVM: x86/mmu: refactor kvm_tdp_mmu_map
Date:   Wed,  2 Aug 2023 22:27:37 +0800
Message-Id: <20230802142737.5572-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The implementation of kvm_tdp_mmu_map is a bit long. It essentially does
three things:
1) adjust the leaf entry level (e.g. 4KB, 2MB or 1GB) to map according to
   the hugepage configurations;
2) map the nonleaf entries of the tdp page table; and
3) map the target leaf entry.

Improve the readabiliy by moving the implementation of 2) above into a
subfunction, kvm_tdp_mmu_map_nonleaf, and removing the unnecessary
"goto"s. No functional changes intended.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 76 ++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 512163d52194..0b29a7f853b5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1057,43 +1057,33 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 				   struct kvm_mmu_page *sp, bool shared);
 
-/*
- * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
- * page tables and SPTEs to translate the faulting guest physical address.
- */
-int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+static int kvm_tdp_mmu_map_nonleafs(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault,
+				    struct tdp_iter *iter)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
-	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	int ret = RET_PF_RETRY;
-
-	kvm_mmu_hugepage_adjust(vcpu, fault);
-
-	trace_kvm_mmu_spte_requested(fault);
-
-	rcu_read_lock();
-
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
-		int r;
+	int ret;
 
+	tdp_mmu_for_each_pte((*iter), mmu, fault->gfn, fault->gfn + 1) {
 		if (fault->nx_huge_page_workaround_enabled)
-			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
+			disallowed_hugepage_adjust(fault, iter->old_spte,
+						   iter->level);
 
 		/*
 		 * If SPTE has been frozen by another thread, just give up and
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
-		if (is_removed_spte(iter.old_spte))
-			goto retry;
+		if (is_removed_spte(iter->old_spte))
+			return RET_PF_RETRY;
 
-		if (iter.level == fault->goal_level)
-			goto map_target_level;
+		if (iter->level == fault->goal_level)
+			return RET_PF_CONTINUE;
 
 		/* Step down into the lower level page table if it exists. */
-		if (is_shadow_present_pte(iter.old_spte) &&
-		    !is_large_pte(iter.old_spte))
+		if (is_shadow_present_pte(iter->old_spte) &&
+		    !is_large_pte(iter->old_spte))
 			continue;
 
 		/*
@@ -1101,26 +1091,26 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * needs to be split.
 		 */
 		sp = tdp_mmu_alloc_sp(vcpu);
-		tdp_mmu_init_child_sp(sp, &iter);
+		tdp_mmu_init_child_sp(sp, iter);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte))
-			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
+		if (is_shadow_present_pte(iter->old_spte))
+			ret = tdp_mmu_split_huge_page(kvm, iter, sp, true);
 		else
-			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
+			ret = tdp_mmu_link_sp(kvm, iter, sp, true);
 
 		/*
 		 * Force the guest to retry if installing an upper level SPTE
 		 * failed, e.g. because a different task modified the SPTE.
 		 */
-		if (r) {
+		if (ret) {
 			tdp_mmu_free_sp(sp);
-			goto retry;
+			return RET_PF_RETRY;
 		}
 
 		if (fault->huge_page_disallowed &&
-		    fault->req_level >= iter.level) {
+		    fault->req_level >= iter->level) {
 			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 			if (sp->nx_huge_page_disallowed)
 				track_possible_nx_huge_page(kvm, sp);
@@ -1132,13 +1122,29 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * The walk aborted before reaching the target level, e.g. because the
 	 * iterator detected an upper level SPTE was frozen during traversal.
 	 */
-	WARN_ON_ONCE(iter.level == fault->goal_level);
-	goto retry;
+	WARN_ON_ONCE(iter->level == fault->goal_level);
+	return RET_PF_RETRY;
+}
 
-map_target_level:
-	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
+/*
+ * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
+ * page tables and SPTEs to translate the faulting guest physical address.
+ */
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+{
+	struct tdp_iter iter;
+	int ret;
+
+	kvm_mmu_hugepage_adjust(vcpu, fault);
+
+	trace_kvm_mmu_spte_requested(fault);
+
+	rcu_read_lock();
+
+	ret = kvm_tdp_mmu_map_nonleafs(vcpu, fault, &iter);
+	if (ret == RET_PF_CONTINUE)
+		ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 
-retry:
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.27.0

