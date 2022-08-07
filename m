Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7430A58BD65
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiHGWG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiHGWEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:04:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02364B48C;
        Sun,  7 Aug 2022 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909774; x=1691445774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mFQa8eTHQqRGxpnGOtA/K1vSOToebRgj88qGFnjbHEo=;
  b=cZqYeOS8E4H1Pvk/mA1zWDLQ8XHpfuL5yz9FA804uK6ZcN0SEJ99Nl81
   MU4KrguWT493k8b4GD0ZqBVaAwmCA1nAbvsI/vih07EXrJHQvDjlPNJ8M
   SYT63HZ6OCNCzorzvNjyea6B/HoqIdJb34rsWvmOajCIAI7OtHUb8YtoW
   euHXoyarerwEF1glJUpWKf4anLFNMBtVZMIMRs0mEosGM+pm4tN4aSyY2
   7rCBiIIZV4cnWEaC4MPXsmkCgEWwkmM10j4Y4BNkkha0B1LJ8T76XpuIt
   d1+kdbB9MSC6ByXDnS603xOg8uVn+ic/Mk+5Ody0ra6gp6p05J53Ckaw0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224123"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224123"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682562"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 038/103] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Date:   Sun,  7 Aug 2022 15:01:23 -0700
Message-Id: <021cf72b904933f23743d74b2a67341298ae5328.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/mmu/tdp_mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8bc3a8d1803e..90b468a3a1a2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1145,6 +1145,24 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -1153,7 +1171,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
-	struct kvm_mmu_page *sp;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1199,13 +1216,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

