Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9ED04CDEB1
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiCDUKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiCDUHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D445248CF6;
        Fri,  4 Mar 2022 12:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424145; x=1677960145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Me9R2iHIgVJGsU1ppIXYCXCq+0CEFXNAw3ub+Y9aAU=;
  b=SW34J/pQ48eZR4Ou6PjqWjdRhTZQXNILdNaovDOrJfe0DPMku/5HpAxT
   JPmSBFW47bWfB1nXZ843xu7JowMwI9e39fPvcgngknaw66m9/T46kXB5C
   HqJi2QOIYTazx/w4Bi50MBPM2pRDmqs+5BkFMGQG7Z99KTcIqqOIBuTbi
   9dZY51f3l4XJOF76LsxA5vNiU/d7OR9k2eAfRPbOanWz30qsjxdnE7iQe
   FEs64vBIihvDqmzwRCBFEioPHGaPpsrFeMuC5vF1Kt5QYnvjXBYTxLxty
   pMKJTYP7mDte9ISt1WeIKgpG5sSKZ4HNsyIUt8cHmqP0ahasQA48QuRKB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983504"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983504"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:23 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344353"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:23 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 046/104] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Date:   Fri,  4 Mar 2022 11:49:02 -0800
Message-Id: <8ac26dfbe645aa3e9a9f39c844dfec9c0ac841ec.1646422845.git.isaku.yamahata@intel.com>
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

Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
hypercall needs to populate non-leaf SPTE to record which GPA, private or
shared, is allowed in the leaf EPT entry.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 48 ++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b6ec2f112c26..8db262440d5c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -955,6 +955,31 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static bool tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
+{
+	struct kvm_mmu_page *sp;
+	u64 *child_pt;
+	u64 new_spte;
+
+	WARN_ON(is_shadow_present_pte(iter->old_spte));
+	WARN_ON(is_removed_spte(iter->old_spte));
+
+	sp = alloc_tdp_mmu_page(vcpu, iter->gfn, iter->level - 1);
+	child_pt = sp->spt;
+
+	new_spte = make_nonleaf_spte(child_pt, !shadow_accessed_mask);
+
+	if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte)) {
+		tdp_mmu_free_sp(sp);
+		return false;
+	}
+
+	tdp_mmu_link_page(vcpu->kvm, sp, account_nx);
+	trace_kvm_mmu_get_page(sp, true);
+	return true;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -963,9 +988,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
-	u64 *child_pt;
-	u64 new_spte;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1000,6 +1022,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+			bool account_nx;
+
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1008,22 +1032,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
-			child_pt = sp->spt;
-
-			new_spte = make_nonleaf_spte(child_pt,
-						     !shadow_accessed_mask);
-
-			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp,
-						  fault->huge_page_disallowed &&
-						  fault->req_level >= iter.level);
-
-				trace_kvm_mmu_get_page(sp, true);
-			} else {
-				tdp_mmu_free_sp(sp);
+			account_nx = fault->huge_page_disallowed &&
+				fault->req_level >= iter.level;
+			if (!tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
 				break;
-			}
 		}
 	}
 
-- 
2.25.1

