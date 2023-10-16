Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC17CAF42
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjJPQbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjJPQa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:30:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4D0825F;
        Mon, 16 Oct 2023 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=76HvwvivJxanOflJfCGymJ5o3a4H7yOPOQNDRzjrHPY=;
  b=T66XB0Yt+lgIGrEwQMpHj46R6srEAT+gWjilhmLYYZ0C7HaZc5+dPsGB
   nFpN5UfNar/jiGzc8SVD9dMdqehjXKbo6cNEOrjyVqBU3plYxBDVsKxbf
   NzgYNIupZarSbfPTBptOmkywlK3dLub2DGhdOCXnYsKk0PSyYwCv6muaw
   PxOzIS0e28KU1qXnOjS36K2iO3t/AHPweq5BUgRfihdG1d4bhVTKS/Kcb
   RH0yrDi6gTHtX1kpy5sr4C7cWj8dqbEvL5zwoh+SkV+OD4/F4485tPgb5
   khZJ02QRx0fp3dD2olTi/5/13+K3gShkij0Wez9VXIDvAUqqA/qLPxJC0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793157"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793157"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569235"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569235"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 07/16] KVM: MMU: Introduce level info in PFERR code
Date:   Mon, 16 Oct 2023 09:20:58 -0700
Message-Id: <194ae75b2eff5da9e1729e5f5711407ca56d7c0e.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 8ac6f0555ac3..7bcdc2afe88c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -254,6 +254,8 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_LEVEL_START_BIT 29
+#define PFERR_LEVEL_END_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_GUEST_ENC_BIT 34
@@ -266,6 +268,7 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
 #define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
+#define PFERR_LEVEL_MASK	GENMASK_ULL(PFERR_LEVEL_END_BIT, PFERR_LEVEL_START_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 26bad5c646fe..55574993a13a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4593,6 +4593,11 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 
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
index 027aa4175d2c..bb00433932ee 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -67,7 +67,8 @@ static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 }
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
-					     unsigned long exit_qualification)
+					     unsigned long exit_qualification,
+					     int err_page_level)
 {
 	u64 error_code;
 
@@ -90,6 +91,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	if (kvm_is_private_gpa(vcpu->kvm, gpa))
 		error_code |= PFERR_GUEST_ENC_MASK;
 
+	if (err_page_level > 0)
+		error_code |= (err_page_level << PFERR_LEVEL_START_BIT) & PFERR_LEVEL_MASK;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 992cf3ed02f2..c37b66f9a52a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1802,7 +1802,20 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 
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
+		err_page_level = tdx_sept_level_to_pg_level(ext_exit_qual.req_sept_level);
+	}
 
 	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
 		/*
@@ -1829,7 +1842,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
-	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual, err_page_level);
 }
 
 static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 796ff0a4bcbf..b0bc3ee89e03 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -73,6 +73,25 @@ union tdx_exit_reason {
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
index 18b374b3f940..fadb89346635 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5753,7 +5753,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, 0);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

