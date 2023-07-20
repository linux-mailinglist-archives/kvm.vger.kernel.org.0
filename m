Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499F275BB37
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjGTXdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGTXdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E9271E;
        Thu, 20 Jul 2023 16:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895993; x=1721431993;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ax6ORuGmO7dyoYVgLyCg1s0HQk7F5KLKTu96xRoFvXU=;
  b=PqyrxRRG9Wyao9T3c/Wn5MRCW2ZofQrWwWzFLDKRcQYucXnojhh/623z
   tGMxK+inQiwJOHOEANuxVSMtL9TWA9ZkGFmOv4/rU/QDlhgyBtf41IoF3
   TqJQIQb5AxYu51Ris7XAfdfLJVB+Eqbn0DGMOy6gslhVZFMdCtbO/qwkn
   czhN9XUwma/4l0YSC3tF/DVOIniIL/DVi46zbkJ49dhOCn9bwvOrarN1O
   FAX2bCYeYFhWpaiZo+DFkipdsih7zpNEWkg7uE9y2jXnSgpDmLFGrQ3AS
   vn1+L1bDXUpi5i8y9GuTc5DQca3PX1dqannP/+lhE/45bC6NA7fZ7fZQi
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355928"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355928"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891789"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891789"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:11 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 04/10] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
Date:   Thu, 20 Jul 2023 16:32:50 -0700
Message-Id: <f474282d701aca7af00e4f7171445abb5e734c6f.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1689893403.git.isaku.yamahata@intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add two PFERR codes to designate that the page fault is private and that
it requires looking up memory attributes.  The vendor kvm page fault
handler should set PFERR_GUEST_ENC_MASK bit based on their fault
information.  It may or may not use the hardware value directly or
parse the hardware value to set the bit.

For KVM_X86_PROTECTED_VM, ask memory attributes for the fault privateness.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v3 -> v4:
- rename back struct kvm_page_fault::private => is_private
- catch up rename: KVM_X86_PROTECTED_VM => KVM_X86_SW_PROTECTED_VM

Changes v2 -> v3:
- Revive PFERR_GUEST_ENC_MASK
- rename struct kvm_page_fault::is_private => private
- Add check KVM_X86_PROTECTED_VM

Changes v1 -> v2:
- Introduced fault type and replaced is_private with fault_type.
- Add kvm_get_fault_type() to encapsulate the difference.
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          |  8 ++++++--
 arch/x86/kvm/mmu/mmu_internal.h | 14 +++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c9350aa0da4..ab7d080bf544 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -255,6 +255,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
 #define PFERR_IMPLICIT_ACCESS_BIT 48
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
@@ -266,6 +267,7 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a2fe091e327a..d2ebe26fb822 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4399,8 +4399,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
-		return kvm_do_memory_fault_exit(vcpu, fault);
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		if (vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
+			return RET_PF_RETRY;
+		else
+			return kvm_do_memory_fault_exit(vcpu, fault);
+	}
 
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f9ec1e5b136..4f8f83546c37 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -282,6 +282,18 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline bool kvm_is_fault_private(struct kvm *kvm, gpa_t gpa, u64 error_code)
+{
+	/*
+	 * This is racy with mmu_seq.  If we hit a race, it would result in a
+	 * spurious KVM_EXIT_MEMORY_FAULT.
+	 */
+	if (kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM)
+		return kvm_mem_is_private(kvm, gpa_to_gfn(gpa));
+
+	return error_code & PFERR_GUEST_ENC_MASK;
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u64 err, bool prefetch, int *emulation_type)
 {
@@ -295,13 +307,13 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.is_private = kvm_is_fault_private(vcpu->kvm, cr2_or_gpa, err),
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
 	};
 	int r;
 
-- 
2.25.1

