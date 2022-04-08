Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A5B4F9F10
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiDHVWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 17:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbiDHVWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 17:22:30 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8825320DB7
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 14:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649452825; x=1680988825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0sV5atnbVGmWdjTapA3H2arq6viYlrYUrdsqarICHpA=;
  b=kY7mmVwsrUvo3PM3xF1n8SR192DEkuAGta2in3od0fDurfb5TM43Hlb3
   s+xq2liSe8fYQI5T7Gv2gxVdusYxS2Yr9tcM+Fh9uLRBmY/znGsYktSZ9
   +UmJXf6KIT+5e8stnd80i4/nUaKt19M6TWsGcAXgV+PJTnhes2v4izCTq
   3GaKN996kHfVn+y3wwllFKfuUJ2OcfkRkBHLTbBcfJUA2HID5iGBaPC3Y
   4p8zuQq98cceqoRWuf4JrWX05Cvc7UfL65a+fclcQQaslI/jr0eSXTD3K
   OXMFjLT8EgRIfgm3Tz4D48wHRi7uJeiQYt6MQM5a8N680buxXlBH36Q2c
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="322379574"
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="322379574"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 14:20:25 -0700
X-IronPort-AV: E=Sophos;i="5.90,246,1643702400"; 
   d="scan'208";a="506696178"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 14:20:25 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86/tdp_mmu: extract tdp_mmu_populate_nonleaf()
Date:   Fri,  8 Apr 2022 14:20:10 -0700
Message-Id: <53301fe06478489cd3a60d2dfba75ce61ee4ea56.1649452628.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
hypercall needs to populate non-leaf SPTE to record which GPA, private or
shared, is allowed in the leaf EPT entry.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..1be0e02abd71 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1131,6 +1131,21 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_populate_nonleaf(
+	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
+{
+	struct kvm_mmu_page *sp;
+	int ret;
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
@@ -1139,7 +1154,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1185,13 +1199,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

