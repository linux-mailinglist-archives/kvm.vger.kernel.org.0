Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EF151C755
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383888AbiEESXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383218AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BFF49684;
        Thu,  5 May 2022 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774554; x=1683310554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pVoiIWs/KT0rFFHvpPmgf/2kpDklS0hKSk3efqDHWmY=;
  b=nlFjGtGZMRAjNvI9XnOrWmjdsOFz4O6UL4lFCgryqCUwA6Dh+r4H5A0p
   rN4DdKBGUs46m0FC0QYMTV333s7di+FkcXVlpI3vBs/f75thpJgGPPwxA
   ZHZUA4h2TtF6pBikliccu8jm0oOio4Y+Q23tJOxv2TmrPcnyUxUg8bDZH
   tOEXszZJyhkM4/LuYttXZIbN4MNPubPoE//yuChPHB2A9phcOETQWYUPP
   XLVZdo6KggMJACAxbejtQm7W3YcoAdb2bG5WgHHQ4S3qGnYYsRw1lLx0f
   R8Q7sYXRZV+hg4Aj7X24PzBE2HvOXOv6qSz2X9VIYsv4GiCQMUoMGAMRy
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746282"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746282"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083298"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 046/104] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Date:   Thu,  5 May 2022 11:14:40 -0700
Message-Id: <4744ed20a4d9db95b515559e7525623781261b0c.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 arch/x86/kvm/mmu/tdp_mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b7e13061e57d..9e015b3e0578 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1149,6 +1149,24 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
+{
+	struct kvm_mmu_page *sp;
+	int ret;
+
+	WARN_ON(is_shadow_present_pte(iter->old_spte));
+	WARN_ON(is_removed_spte(iter->old_spte));
+
+	sp = tdp_mmu_alloc_sp(vcpu);
+	tdp_mmu_init_child_sp(sp, iter);
+
+	ret = tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
+	if (ret)
+		tdp_mmu_free_sp(sp);
+	return ret;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1157,7 +1175,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1203,13 +1220,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = tdp_mmu_alloc_sp(vcpu);
-			tdp_mmu_init_child_sp(sp, &iter);
-
-			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
-				tdp_mmu_free_sp(sp);
+			if (tdp_mmu_populate_nonleaf(vcpu, &iter, account_nx))
 				break;
-			}
 		}
 	}
 
-- 
2.25.1

