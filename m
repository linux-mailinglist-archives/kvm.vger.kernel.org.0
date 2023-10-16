Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DAF7CAFDF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbjJPQj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbjJPQh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7FE8264;
        Mon, 16 Oct 2023 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473396; x=1729009396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dYyJaAe9NtV/9+vuz7+dWQkffsVxT4JQowmTNSzwnc4=;
  b=acnqcyAcsGH88RUJ6ZGHnaNbI1YDoePvdDBEfRAKxSnls7Ihf7nxNzmF
   IFq4iYIagjQ5vqFHs5ONGesV+zgWjFso0qUA3+bEp0IJ1ZbBppO/4QeT2
   mUam914r1luNWhOQPfmrZF7dkELmFk6hHPe1PVsTrT5tnBsMpvcn7bScZ
   t7aQN22cdcwxPvPWRehNjcK9VRE8E/r9W1Q0463lSViatnNria3s/4TGA
   t9Kv7GQOyI9xIZsbvzBdgVgCNjw991EpxDy415SAY5MOdqMlaQZG967Fh
   gviyLVtXi1A4fkDQLRWn4HuOYPaAniYg36rVpc3JDItblQohOL/tMEifO
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793172"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793172"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569242"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569242"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:15 -0700
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
Subject: [RFC PATCH v5 09/16] KVM: TDX: Pass desired page level in err code for page fault handler
Date:   Mon, 16 Oct 2023 09:21:00 -0700
Message-Id: <b37fa7827ab9344eae8c72c5507a49a93b0a2908.1697473009.git.isaku.yamahata@intel.com>
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
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/common.h       |  2 +-
 arch/x86/kvm/vmx/tdx.c          |  7 ++++++-
 arch/x86/kvm/vmx/tdx.h          | 19 -------------------
 arch/x86/kvm/vmx/tdx_arch.h     | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bcdc2afe88c..bb2b4f8c0c57 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -278,6 +278,8 @@ enum x86_intercept_stage;
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
index 0558faee5b19..2c760947ab21 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2762,6 +2762,7 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx_init_mem_region region;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
+	u64 error_code;
 	int idx, ret = 0;
 	bool added = false;
 
@@ -2819,7 +2820,11 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
index b0bc3ee89e03..796ff0a4bcbf 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -73,25 +73,6 @@ union tdx_exit_reason {
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
index 8d02a315724a..93934851610b 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -227,6 +227,25 @@ union tdx_sept_level_state {
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
 #define TDX_MD_CLASS_GLOBAL_VERSION		8
 
 #define TDX_MD_FID_GLOBAL_FEATURES0		0x0A00000300000008
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fadb89346635..17b44731d0e7 100644
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

