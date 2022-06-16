Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8243A54DD6E
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376538AbiFPItj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376379AbiFPIsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEA54756F;
        Thu, 16 Jun 2022 01:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369267; x=1686905267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=axZQXpthMwv42bC9pB1QFXId7O4Vr4FbCohL9wqJtaU=;
  b=PVKk0g00E6Li2JnQ6ZKvZkiYSLZqGCmq7EqcFXCBrLA33bCJieAZatja
   PhcmulDrqHk6RIJ/KxVdSs8vsLBWrP+Rh5Wc9YzCMXUfJImTfEAkCow6I
   a6EpN4iAve38vtpMVsHYSxSbKvJcTB6OQLZ8rWfyScUjdllvRsvvzW2QP
   L3oHPOP2J2dnf5VzCMtvy2cZup/uXVth84fL6KGViidX/ofjD1Bl3FzDl
   h+y4VLY6iSaXxWcr8bLlQUTx15VObV7nnkdoC7JmDnPdv43UzaqF8Rfl3
   PJtjuokr975YNPYcwzmjhhJ/9+vdn4/U4CeegP+uJGfudc/BFg6uQ0f9y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664555"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664555"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083152"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH 09/19] KVM: x86: Add #CP support in guest exception classification.
Date:   Thu, 16 Jun 2022 04:46:33 -0400
Message-Id: <20220616084643.19564-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
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

Add handling for Control Protection (#CP) exceptions, vector 21, used
and introduced by Intel's Control-Flow Enforcement Technology (CET).
relevant CET violation case.  See Intel's SDM for details.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20210203113421.5759-5-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              | 10 +++++++---
 arch/x86/kvm/x86.h              | 13 ++++++++++---
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 50a4e787d5e6..69146e7436af 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -32,6 +32,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8cd0ebcc75..01fe23c6fa49 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2819,7 +2819,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
 		/* VM-entry interruption-info field: deliver error code */
 		should_have_error_code =
 			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-			x86_exception_has_error_code(vector);
+			x86_exception_has_error_code(vcpu, vector);
 		if (CC(has_error_code != should_have_error_code))
 			return -EINVAL;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 506454e17afc..40749e47cda7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -511,11 +511,15 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
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
@@ -659,8 +663,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 		return;
 	}
-	class1 = exception_class(prev_nr);
-	class2 = exception_class(nr);
+	class1 = exception_class(vcpu, prev_nr);
+	class2 = exception_class(vcpu, nr);
 	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
 		|| (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
 		/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 501b884b8cc4..b9b1fff6d97a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -148,13 +148,20 @@ static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
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

