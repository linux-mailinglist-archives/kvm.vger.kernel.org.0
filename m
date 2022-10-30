Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945876127EA
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiJ3GZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiJ3GYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C81126;
        Sat, 29 Oct 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111049; x=1698647049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NKuth91WRs/SZEoHEI1aWkm/ClHWtQ+fWSUlO4AXg5k=;
  b=E6dgYF4EjrMxHT4FncLk7ukclniLDARsZlKM/48gxe4zMcnLbPr65ovR
   DnDM/bzzfe1T839BbYEBXMmmQeftG0R41wZoYSi6ikSc9APWSm8FXJZv+
   3sekp4mOXlNSMCmik8pc2i7vp1uCionK0d0/u/Y8Ol/6ZiOonq2emZE1L
   sZCDzRO1xUUagEVs11DCl76b2jJfgSlEM7pZOpwz89UKMxf4H8IV2KDX+
   2yxgmdTCksrFCySFa6+TlwNGgz/RCh3xr0BPGFfxh3hdmwQf6qCJhQ4C3
   9iZ4bqdhI/meKMXhe/9q/KMA3GkBPmyKEy6YfJiMCG/s1WEoE4s8hqs/S
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037153"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037153"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392978"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392978"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:03 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 041/108] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Date:   Sat, 29 Oct 2022 23:22:42 -0700
Message-Id: <ae532ffde75be94062f03dab8b538fa64d1dfc74.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 3325633b1cb5..11b0ec8aebe2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1157,6 +1157,24 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_iter *iter,
+				    bool account_nx)
+{
+	struct kvm_mmu_page *sp;
+	int ret;
+
+	KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), vcpu->kvm);
+	KVM_BUG_ON(is_removed_spte(iter->old_spte), vcpu->kvm);
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
@@ -1165,7 +1183,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1211,13 +1228,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

