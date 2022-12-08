Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D25647A18
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiLHXgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiLHXf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9FB6BC9E;
        Thu,  8 Dec 2022 15:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542556; x=1702078556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8wumzRDYjXgIUi2sy8Lc0u3WG0A4Eh8mHFht+xhL328=;
  b=C8lPjx1H5ypeXKRYnHzpgSfx4ReR+eVvbEoWIkbDDLrlT7w7UAWVPM9j
   qXguh44sbeExFp+BEK9fq0mcm5p+HYzlP/7APsbDNm8Aemb9qYHe2Y/mO
   3eLooNJqHNbM4jaL5QIiLANYvvUz3IMTsC8UQ53i3SsdURnfIuvpicPfX
   6D0ZYC9NNiPX8HMWMrXkT6Gye2Y3Tr3kyIcU47VUmDtvZs2sBtWNkhEV2
   0Uq5D2jAz025GrnigLU17gKoRiWVA77voRdoQS/gjQaqZy3mcL95ejjXa
   t/cb1vOldwvBBezmm2CrrDrAJmMbzS1EK2G19DVt9AVTIRQFCRL/8ma5w
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586514"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586514"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950944"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950944"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:55 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 07/15] KVM: MMU: Introduce level info in PFERR code
Date:   Thu,  8 Dec 2022 15:35:42 -0800
Message-Id: <e1f7b929a02c0c28e4703430103d3adf925e6b85.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

For TDX, EPT violation can happen when TDG.MEM.PAGE.ACCEPT.
And TDG.MEM.PAGE.ACCEPT contains the desired accept page level of TD guest.

1. KVM can map it with 4KB page while TD guest wants to accept 2MB page.

  TD geust will get TDX_PAGE_SIZE_MISMATCH and it should try to accept
  4KB size.

2. KVM can map it with 2MB page while TD guest wants to accept 4KB page.

  KVM needs to honor it because
  a) there is no way to tell guest KVM maps it as 2MB size. And
  b) guest accepts it in 4KB size since guest knows some other 4KB page
     in the same 2MB range will be used as shared page.

For case 2, it need to pass desired page level to MMU's
page_fault_handler. Use bit 29:31 of kvm PF error code for this purpose.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/mmu/mmu.c          |  5 +++++
 arch/x86/kvm/vmx/common.h       |  6 +++++-
 arch/x86/kvm/vmx/tdx.c          | 15 ++++++++++++++-
 arch/x86/kvm/vmx/tdx.h          | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a2126bd85d2..f9d64775193b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -257,6 +257,8 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_LEVEL_START_BIT 29
+#define PFERR_LEVEL_END_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
@@ -268,6 +270,7 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
 #define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_LEVEL_MASK	GENMASK_ULL(PFERR_LEVEL_END_BIT, PFERR_LEVEL_START_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 630e36bbd61f..02adc3c23627 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4554,6 +4554,11 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
+	u8 err_level = (fault->error_code & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT;
+
+	if (err_level)
+		fault->max_level = min(fault->max_level, err_level);
+
 	/*
 	 * If the guest's MTRRs may be used to compute the "real" memtype,
 	 * restrict the mapping level to ensure KVM uses a consistent memtype
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 65abda49debe..995cf22f47cf 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -78,7 +78,8 @@ static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 }
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
-					     unsigned long exit_qualification)
+					     unsigned long exit_qualification,
+					     int err_page_level)
 {
 	u64 error_code;
 
@@ -98,6 +99,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (err_page_level > 0)
+		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d5f93115f3ba..51b9e250437e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1606,7 +1606,20 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
+	union tdx_ext_exit_qualification ext_exit_qual;
 	unsigned long exit_qual;
+	int err_page_level = 0;
+
+	ext_exit_qual.full = tdexit_ext_exit_qual(vcpu);
+
+	if (ext_exit_qual.type >= NUM_EXT_EXIT_QUAL) {
+		pr_err("EPT violation at gpa 0x%lx, with invalid ext exit qualification type 0x%x\n",
+			tdexit_gpa(vcpu), ext_exit_qual.type);
+		kvm_vm_bugged(vcpu->kvm);
+		return 0;
+	} else if (ext_exit_qual.type == EXT_EXIT_QUAL_ACCEPT) {
+		err_page_level = ext_exit_qual.req_sept_level + 1;
+	}
 
 	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
 		/*
@@ -1633,7 +1646,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
-	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual, err_page_level);
 }
 
 static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 6eca8bf4d9e1..e09757acc6f9 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -62,6 +62,25 @@ union tdx_exit_reason {
 	u64 full;
 };
 
+union tdx_ext_exit_qualification {
+	struct {
+		u64 type		: 4;
+		u64 reserved0		: 28;
+		u64 req_sept_level	: 3;
+		u64 err_sept_level	: 3;
+		u64 err_sept_state	: 8;
+		u64 err_sept_is_leaf	: 1;
+		u64 reserved1		: 17;
+	};
+	u64 full;
+};
+
+enum tdx_ext_exit_qualification_type {
+	EXT_EXIT_QUAL_NONE,
+	EXT_EXIT_QUAL_ACCEPT,
+	NUM_EXT_EXIT_QUAL,
+};
+
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c74477b3b358..30a715c22647 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5784,7 +5784,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, 0);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

