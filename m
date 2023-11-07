Return-Path: <kvm+bounces-969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC137E42AA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:05:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4DDDB2313C
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4572636AFF;
	Tue,  7 Nov 2023 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UtkTsLTQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF91347C0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:48 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C2A618F;
	Tue,  7 Nov 2023 07:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369321; x=1730905321;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ycbt3t1b2wsaF+TK1M5DAhXRxNfTAEnLJ2demb3PXfM=;
  b=UtkTsLTQM3rWPSis3Z4r7ccK0g4uJFGvPyZVoHhxIrawta4qw93BmIJz
   5p7vmYLQQ9R/xW2oZBW21pSjxF5Q5yvA4MeNvCvpI7FChlF49rW5iZEvz
   4OD8PQR7gTNE13Ysv+fYvoww/NEJ3+o5wdfctxpeAU1nY8uAQcBNkCzfc
   nW0Br7zlzNH3F9tBsjDu9sScLcXY5y097fBrSUXjFOh8b+/6NYhc01lvL
   lrVZoz33Dd93xoFYFgX1poc51uhu/VT9uJVu3qwP3OIclQygGbJbqZzpG
   2jjypUDe2o9uxijhMPGqR2XpjMwp4N0OKWcQ4t3Tn0fLm1H7llEqYzWFr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="388397596"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="388397596"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10446827"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 07:00:58 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 09/16] KVM: TDX: Pass desired page level in err code for page fault handler
Date: Tue,  7 Nov 2023 07:00:36 -0800
Message-Id: <71943490df987be8a3a3e131b12750e8c6d82afc.1699368363.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368363.git.isaku.yamahata@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/common.h       |  2 +-
 arch/x86/kvm/vmx/tdx.c          |  7 ++++++-
 arch/x86/kvm/vmx/tdx.h          | 19 -------------------
 arch/x86/kvm/vmx/tdx_arch.h     | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eed36c1eedb7..c16823f3326e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -285,6 +285,8 @@ enum x86_intercept_stage;
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
+#define PFERR_LEVEL(err_code)	(((err_code) & PFERR_LEVEL_MASK) >> PFERR_LEVEL_START_BIT)
+
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index bb00433932ee..787f59c44abc 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -91,7 +91,7 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (kvm_is_private_gpa(vcpu->kvm, gpa))
 		error_code |= PFERR_GUEST_ENC_MASK;
 
-	if (err_page_level > 0)
+	if (err_page_level > PG_LEVEL_NONE)
 		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7b81811eb404..c614ab20c191 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2713,6 +2713,7 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx_init_mem_region region;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	u64 error_code;
 	int idx, ret = 0;
 	bool added = false;
 
@@ -2770,7 +2771,11 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 		kvm_tdx->source_pa = pfn_to_hpa(page_to_pfn(page)) |
 				     (cmd->flags & KVM_TDX_MEASURE_MEMORY_REGION);
 
-		ret = kvm_mmu_map_tdp_page(vcpu, region.gpa, TDX_SEPT_PFERR,
+		/* TODO: large page support. */
+		error_code = TDX_SEPT_PFERR;
+		error_code |= (PG_LEVEL_4K << PFERR_LEVEL_START_BIT) &
+			PFERR_LEVEL_MASK;
+		ret = kvm_mmu_map_tdp_page(vcpu, region.gpa, error_code,
 					   PG_LEVEL_4K);
 		put_page(page);
 		if (ret)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 37ee944c36a1..54c3f6b83571 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -72,25 +72,6 @@ union tdx_exit_reason {
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
index 9f93250d22b9..ba41fefa47ee 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -218,4 +218,23 @@ union tdx_sept_level_state {
 	u64 raw;
 };
 
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
index ae9ba0731521..fb3913df6a5d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5753,7 +5753,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, PG_LEVEL_NONE);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1


