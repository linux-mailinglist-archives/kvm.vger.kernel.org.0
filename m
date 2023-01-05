Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52A65EDE9
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbjAENz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 08:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbjAENzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 08:55:08 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363285930F
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 05:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672926718; x=1704462718;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8OsvX0gnhUntOK4J/R1lVQBcNEpVQeekdJdPROQOjiU=;
  b=jsuYdN12OiJ5zkYAI03cuNpmX3v0Z/Jgg8WauhC0Y/2nczG/C1w+snQd
   5hM+DEnK74ngAqAE5VuGXh5G6nOH4DbBUOwcAITQkHBSO24xJUQPAPCFn
   nEG/gmMfdWmCwzm9T96GBkP1ZyOISIelKZDcXEEglaolokCLWlC5kWrhO
   AsKisjByLLfTsZs8viO5FqgK0RBmyg1XVvxDrX1bHbVFS/N4pibjsXm8c
   ALat84Nx64N6mK5PL3fIWdYNyLxZhVGwEhyZ0Q7Yk2KIWbfO/WIL3DYCb
   aTZZjuxBe3eP0mzj36Fcy4/a6D2eCK18SVaMmTa7EhAhgj0Kzp3jS3eaz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="309976721"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="309976721"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 05:51:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="655576290"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="655576290"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga002.jf.intel.com with ESMTP; 05 Jan 2023 05:51:54 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, paul@xen.org
Subject: [PATCH v5] KVM: MMU: Make the definition of 'INVALID_GPA' common
Date:   Thu,  5 Jan 2023 21:01:27 +0800
Message-Id: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in kvm_types.h,
and it is used by ARM code. We do not need another definition of
'INVALID_GPA' for X86 specifically.

Instead of using the common 'GPA_INVALID' for X86, replace it with
'INVALID_GPA', and change the users of 'GPA_INVALID' so that the diff
can be smaller. Also because the name 'INVALID_GPA' tells the user we
are using an invalid GPA, while the name 'GPA_INVALID' is emphasizing
the GPA is an invalid one.

No functional change intended.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
V5:
- No need to add the 'INVALID_GFN' as 'KVM_XEN_INVALID_GPA' and 
'KVM_XEN_INVALID_GFN' were added.
V4:
- Put the addition of 'INVALID_GFN' into a seperate patch.
V3:
- Added 'INVALID_GFN' and use it.
v2:
- Renamed 'GPA_INVALID' to 'INVALID_GPA' and modify _those_ users. 
v1:
https://lore.kernel.org/lkml/20221209023622.274715-1-yu.c.zhang@linux.intel.com/
---
 arch/arm64/include/asm/kvm_host.h | 4 ++--
 arch/arm64/kvm/hypercalls.c       | 2 +-
 arch/arm64/kvm/pvtime.c           | 8 ++++----
 arch/x86/include/asm/kvm_host.h   | 2 --
 include/linux/kvm_types.h         | 2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..37766e57c8f2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -916,12 +916,12 @@ void kvm_arm_vmid_clear_active(void);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
-	vcpu_arch->steal.base = GPA_INVALID;
+	vcpu_arch->steal.base = INVALID_GPA;
 }
 
 static inline bool kvm_arm_is_pvtime_enabled(struct kvm_vcpu_arch *vcpu_arch)
 {
-	return (vcpu_arch->steal.base != GPA_INVALID);
+	return (vcpu_arch->steal.base != INVALID_GPA);
 }
 
 void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index c9f401fa01a9..64c086c02c60 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -198,7 +198,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		gpa = kvm_init_stolen_time(vcpu);
-		if (gpa != GPA_INVALID)
+		if (gpa != INVALID_GPA)
 			val[0] = gpa;
 		break;
 	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 78a09f7a6637..4ceabaa4c30b 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -19,7 +19,7 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 	u64 steal = 0;
 	int idx;
 
-	if (base == GPA_INVALID)
+	if (base == INVALID_GPA)
 		return;
 
 	idx = srcu_read_lock(&kvm->srcu);
@@ -40,7 +40,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
 	switch (feature) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
 	case ARM_SMCCC_HV_PV_TIME_ST:
-		if (vcpu->arch.steal.base != GPA_INVALID)
+		if (vcpu->arch.steal.base != INVALID_GPA)
 			val = SMCCC_RET_SUCCESS;
 		break;
 	}
@@ -54,7 +54,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	u64 base = vcpu->arch.steal.base;
 
-	if (base == GPA_INVALID)
+	if (base == INVALID_GPA)
 		return base;
 
 	/*
@@ -89,7 +89,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	if (!IS_ALIGNED(ipa, 64))
 		return -EINVAL;
-	if (vcpu->arch.steal.base != GPA_INVALID)
+	if (vcpu->arch.steal.base != INVALID_GPA)
 		return -EEXIST;
 
 	/* Check the address is in a valid memslot */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c70690b2c82d..f18ab36ad684 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -134,8 +134,6 @@
 #define INVALID_PAGE (~(hpa_t)0)
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
 
-#define INVALID_GPA (~(gpa_t)0)
-
 /* KVM Hugepage definitions for x86 */
 #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
 #define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 76de36e56cdf..2728d49bbdf6 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -40,7 +40,7 @@ typedef unsigned long  gva_t;
 typedef u64            gpa_t;
 typedef u64            gfn_t;
 
-#define GPA_INVALID	(~(gpa_t)0)
+#define INVALID_GPA	(~(gpa_t)0)
 
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
-- 
2.25.1

