Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1496FEC7F
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbjEKHOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbjEKHOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3032E83FE;
        Thu, 11 May 2023 00:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789232; x=1715325232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Gy8eU5+LniX8iosDzLMeEn4dijCELzPhyiVmQLWZWc=;
  b=a+2mNCrj7hitKNIqaLIou45VVrQOI/BfyYfdRyjrERAY6ArXtD2FJwdY
   63YnGL9qaWb+HTba2CWI3dtLRAIF2FEVonsix9TRHelxlwd/76hDAQgk/
   +OUKYzblycxPIQy4qpb0fsnfFG0Jf/lffNcqtgDqMGSqV+1LwT8YXUIuX
   7wPZdlQ8jeB8cCh/V6IYnnvfdM+VID/QQQoB/srIV2vjBKCuUEHQ/o+LL
   kfSJu54/VhMW5qiK9tlMVzqjk09AfwglXNEj0gG9ROAIl9ACtQHUgrJNX
   DjUdxg1wRsZQKC5ntvn68vyiJ6NIPgxDT14mD9DIpK1aSY6UFTTExQDhq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896624"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896624"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512370"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512370"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:24 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception classification
Date:   Thu, 11 May 2023 00:08:46 -0400
Message-Id: <20230511040857.6094-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add handling for Control Protection (#CP) exceptions(vector 21).
The new vector is introduced for Intel's Control-Flow Enforcement
Technology (CET) relevant violation cases.

Although #CP belongs contributory exception class, but the actual
effect is conditional on CET being exposed to guest. If CET is not
available to guest, #CP falls back to non-contributory and doesn't
have an error code. The rational is used to fix one unit test failure
encountered in L1. Although the issue now is fixed in unit test case,
keep the handling is reasonable. cr4_guest_rsvd_bits is used to avoid
guest_cpuid_has() lookups.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 10 +++++++---
 arch/x86/kvm/x86.h              | 13 ++++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7f467fe05d42..1c002abe2be8 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -33,6 +33,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 96ede74a6067..7bc62cd72748 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2850,7 +2850,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		/* VM-entry interruption-info field: deliver error code */
 		should_have_error_code =
 			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
+			x86_exception_has_error_code(vcpu, vector);
 		if (CC(has_error_code != should_have_error_code))
 			return -EINVAL;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7788646bbf1f..a768cbf3fbb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -520,11 +520,15 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 #define EXCPT_CONTRIBUTORY	1
 #define EXCPT_PF		2
 
-static int exception_class(int vector)
+static int exception_class(struct kvm_vcpu *vcpu, int vector)
 {
 	switch (vector) {
 	case PF_VECTOR:
 		return EXCPT_PF;
+	case CP_VECTOR:
+		if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
+			return EXCPT_BENIGN;
+		return EXCPT_CONTRIBUTORY;
 	case DE_VECTOR:
 	case TS_VECTOR:
 	case NP_VECTOR:
@@ -707,8 +711,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		return;
 	}
-	class1 = exception_class(prev_nr);
-	class2 = exception_class(nr);
+	class1 = exception_class(vcpu, prev_nr);
+	class2 = exception_class(vcpu, nr);
 	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY) ||
 	    (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
 		/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..2ba7c7fc4846 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -171,13 +171,20 @@ static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
 	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
 }
 
-static inline bool x86_exception_has_error_code(unsigned int vector)
+static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
+						unsigned int vector)
 {
 	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
 			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
-			BIT(PF_VECTOR) | BIT(AC_VECTOR);
+			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
 
-	return (1U << vector) & exception_has_error_code;
+	if (!((1U << vector) & exception_has_error_code))
+		return false;
+
+	if (vector == CP_VECTOR)
+		return !(vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET);
+
+	return true;
 }
 
 static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
-- 
2.27.0

