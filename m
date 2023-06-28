Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E5C741BD0
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjF1WoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A79D2713;
        Wed, 28 Jun 2023 15:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992204; x=1719528204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JlGf3qio/GSOic4b+mRRSLRlEPSFXzbwOCeBFvvFIr0=;
  b=nuixus/BNp34WxSRvhuRqOmzf30X47bSRy2gedoEjC6GjCI1y7N21sQh
   5qPXD1MXi327uJZjVP28QIjduSTFxbHCO+13NjAiXsmJRFZ54JUsgMAAG
   988nLjcC8+M3DkqzuNMD+mUTVp6yVsJUV0EUeW4bQqYmwQdoXdx412Yud
   mwFaXEHrfJYchHv7BRAfDclWU5cf8OMFTxZnIpbVfNILIdB6eCWFkcQrZ
   /fegwMOy9YXklCHMIrpsmd8XgooPs3Hso8PHxYB6LEszg6D9xj39zUbv5
   Dlnf6dtCzKhA6yPeYuEnc1i95KqGEgF+5Ja7f6TpZpFkcauRo7ldxyBF7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699150"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699150"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830299999"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830299999"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:22 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 06/11] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
Date:   Wed, 28 Jun 2023 15:43:05 -0700
Message-Id: <253b10a7bfcb7f9ff7911bc5a4b9971aebf0c4b9.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Changes v2 -> v3:
- Revive PFERR_GUEST_ENC_MASK
- rename struct kvm_page_fault::is_private => private
- Add check KVM_X86_PROTECTED_VM

Changes v1 -> v2:
- Introduced fault type and replaced is_private with fault_type.
- Add kvm_get_fault_type() to encapsulate the difference.
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h | 16 ++++++++++++++--
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ca93e75041f..831bfd1e719a 100644
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
index b8ba7f11c3cb..464c70b35383 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3228,7 +3228,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
 						       fault->gfn, fault->max_level,
-						       fault->is_private);
+						       fault->private);
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4328,7 +4328,7 @@ static int kvm_do_memory_fault_exit(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
-	if (fault->is_private)
+	if (fault->private)
 		vcpu->run->memory.flags = KVM_MEMORY_EXIT_FLAG_PRIVATE;
 	else
 		vcpu->run->memory.flags = 0;
@@ -4386,10 +4386,14 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
-		return kvm_do_memory_fault_exit(vcpu, fault);
+	if (fault->private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		if (vcpu->kvm->arch.vm_type == KVM_X86_PROTECTED_VM)
+			return RET_PF_RETRY;
+		else
+			return kvm_do_memory_fault_exit(vcpu, fault);
+	}
 
-	if (fault->is_private)
+	if (fault->private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f9ec1e5b136..a6e45b39ca90 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -200,10 +200,10 @@ struct kvm_page_fault {
 	const bool present;
 	const bool rsvd;
 	const bool user;
+	const bool private;
 
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
-	const bool is_private;
 	const bool nx_huge_page_workaround_enabled;
 
 	/*
@@ -282,6 +282,18 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline bool kvm_is_fault_private(struct kvm *kvm, gpa_t gpa, u64 error_code)
+{
+	/*
+	 * This is racy with mmu_seq.  If we hit a race, it would result in a
+	 * spurious KVM_EXIT_MEMORY_FAULT.
+	 */
+	if (kvm->arch.vm_type == KVM_X86_PROTECTED_VM)
+		return kvm_mem_is_private(kvm, gpa_to_gfn(gpa));
+
+	return error_code & PFERR_GUEST_ENC_MASK;
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u64 err, bool prefetch, int *emulation_type)
 {
@@ -293,6 +305,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.present = err & PFERR_PRESENT_MASK,
 		.rsvd = err & PFERR_RSVD_MASK,
 		.user = err & PFERR_USER_MASK,
+		.private = kvm_is_fault_private(vcpu->kvm, cr2_or_gpa, err),
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
 		.nx_huge_page_workaround_enabled =
@@ -301,7 +314,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
 	};
 	int r;
 
-- 
2.25.1

