Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D46F667C50
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbjALROK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbjALRNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:13:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FA37F463;
        Thu, 12 Jan 2023 08:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542153; x=1705078153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PKWxzTF+/6yrpBpODoBjtY86+OW4eflEqnhC9tXJfI4=;
  b=hl5UePxDo3mhN/7ykay0MTA3xLVXGDK/YrsmH0109pjshUe8e4fNjAk9
   nDRdCBVsNlmd6ihf28EHE3kSYDDLoMz0BpvTu3VJ9uTsF3dMew8n5qla6
   R2xC4W+h3W/v3+FbEJw6jAltK6euMRzz50WLCDeCU0kO8xZQZubjqS9S1
   ARujDboSgUCqfUxuSjLKWcdDjnOhPZlMRb4oylMml/9aihOH2cY2HxHIA
   MYBnvm5wpNmOZjZVWAbp4tSlSc9BdRLUMj0SgdVxXlNb/co9EyvnLZwIG
   fnzbk98/fnPW5Mnceak4AyhqAmD4XjSzq49z6XDL1MvgTGpQjbdqo/Wa+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816318"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816318"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658349"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658349"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 09/16] KVM: TDX: Pass desired page level in err code for page fault handler
Date:   Thu, 12 Jan 2023 08:44:01 -0800
Message-Id: <630fb8898357d2cbb01e47ca1dff702653afeef4.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/common.h       |  2 +-
 arch/x86/kvm/vmx/tdx.c          |  7 ++++++-
 arch/x86/kvm/vmx/tdx.h          | 19 -------------------
 arch/x86/kvm/vmx/tdx_arch.h     | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 92d935eec2f5..9687d8c8031c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -279,6 +279,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define PFERR_LEVEL(err_code)	(((err_code) & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 995cf22f47cf..69464ae0f7e8 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -99,7 +99,7 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
-	if (err_page_level > 0)
+	if (err_page_level > PG_LEVEL_NONE)
 		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 177f98f7c9c2..bdfcbd0db531 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2360,6 +2360,7 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx_init_mem_region region;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	u64 error_code;
 	kvm_pfn_t pfn;
 	int idx, ret = 0;
 
@@ -2412,7 +2413,11 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
 				     (cmd->flags & KVM_TDX_MEASURE_MEMORY_REGION);
 
-		pfn = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+		/* TODO: large page support. */
+		error_code = TDX_SEPT_PFERR;
+		error_code |= (PG_LEVEL_4K << PFERR_LEVEL_START_BIT) &
+			PFERR_LEVEL_MASK;
+		pfn = kvm_mmu_map_tdp_page(vcpu, region.gpa, error_code,
 					   PG_LEVEL_4K);
 		if (is_error_noslot_pfn(pfn) || kvm->vm_bugged)
 			ret = -EFAULT;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index a647cc36fcee..01e97d6886d5 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -57,25 +57,6 @@ union tdx_exit_reason {
 	u64 full;
 };
 
-union tdx_ext_exit_qualification {
-	struct {
-		u64 type		: 4;
-		u64 reserved0		: 28;
-		u64 req_sept_level	: 3;
-		u64 err_sept_level	: 3;
-		u64 err_sept_state	: 8;
-		u64 err_sept_is_leaf	: 1;
-		u64 reserved1		: 17;
-	};
-	u64 full;
-};
-
-enum tdx_ext_exit_qualification_type {
-	EXT_EXIT_QUAL_NONE,
-	EXT_EXIT_QUAL_ACCEPT,
-	NUM_EXT_EXIT_QUAL,
-};
-
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 18604734fb14..471a9f61fc81 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -163,4 +163,23 @@ struct td_params {
 #define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
 
+union tdx_ext_exit_qualification {
+	struct {
+		u64 type		:  4;
+		u64 reserved0		: 28;
+		u64 req_sept_level	:  3;
+		u64 err_sept_level	:  3;
+		u64 err_sept_state	:  8;
+		u64 err_sept_is_leaf	:  1;
+		u64 reserved1		: 17;
+	};
+	u64 full;
+};
+
+enum tdx_ext_exit_qualification_type {
+	EXT_EXIT_QUAL_NONE = 0,
+	EXT_EXIT_QUAL_ACCEPT,
+	NUM_EXT_EXIT_QUAL,
+};
+
 #endif /* __KVM_X86_TDX_ARCH_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 16ef0f9844c7..b0f16c6f735b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5791,7 +5791,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, PG_LEVEL_NONE);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

