Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3E64B2CE
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 10:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiLMJyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 04:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiLMJyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 04:54:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04011759B
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 01:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670925245; x=1702461245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/BzMonbaZLg9HWyWtCqLnFMunRlN6gCUqtVy54FVaAc=;
  b=IHdkZRG0OUeDY1qhrSc0Q69C+tYrwVILEE8au3pPb2JokOgeEAkBUuL9
   3R2GA1+7a7Q+mQYZDDDPJ5CwEKLKG2v5moRmmYy2to/IbI/JH0JNlrrZt
   kP26cWU5L16imdt2w1n2T03xIyeCNVaNaA+eRc5raMXiqK8P/zyKZOQGk
   McUpYz39CFT4yJQM0XmBHfTi5XA/dMSJDXVJ3FgFmN2wsMFkUA0HSiLNa
   UzfDGoZzfn26mqSf7+SNgvppaUt9VXedQ3HiaPoNPESdIMLNYEICxyLqj
   D4htaiRwY05lWv0h4iIGXIg83PahYV6lsS50PBlNJfJxZvdKB18QbDqU9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="301506930"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="301506930"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 01:54:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="642064399"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="642064399"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga007.jf.intel.com with ESMTP; 13 Dec 2022 01:54:01 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, dwmw2@infradead.org,
        paul@xen.org
Subject: [PATCH v2] KVM: MMU: Make the definition of 'INVALID_GPA' common.
Date:   Tue, 13 Dec 2022 17:04:05 +0800
Message-Id: <20221213090405.762350-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in
kvm_types.h, and it is used by ARM and X86 xen code. We do
not need a specific definition of 'INVALID_GPA' for X86.

Instead of using the common 'GPA_INVALID' for X86, replace
the definition of 'GPA_INVALID' with 'INVALID_GPA', and
change the users of 'GPA_INVALID', so that the diff can be
smaller. Also because the name 'INVALID_GPA' tells the user
we are using an invalid GPA, while the name 'GPA_INVALID'
is emphasizing the GPA is an *invalid* one.

Tested by rebuilding KVM for x86 and for ARM64.

No functional change intended.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
v2:
Followed Sean's comments to rename GPA_INVALID to INVALID_GPA
and modify _those_ users. Also, changed the commit message.
v1:
https://lore.kernel.org/lkml/20221209023622.274715-1-yu.c.zhang@linux.intel.com/
---
 arch/arm64/include/asm/kvm_host.h |  4 ++--
 arch/arm64/kvm/hypercalls.c       |  2 +-
 arch/arm64/kvm/pvtime.c           |  8 ++++----
 arch/x86/include/asm/kvm_host.h   |  2 --
 arch/x86/kvm/xen.c                | 14 +++++++-------
 include/linux/kvm_types.h         |  2 +-
 6 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 001c8abe87fc..fcf96e9cc8cd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -906,12 +906,12 @@ void kvm_arm_vmid_clear_active(void);
 
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
index f35f1ff4427b..46e50cb6c9ca 100644
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
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d7af40240248..988d2d7762f3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -41,7 +41,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (gfn == GPA_INVALID) {
+	if (gfn == INVALID_GPA) {
 		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
@@ -659,7 +659,7 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		if (kvm->arch.xen.shinfo_cache.active)
 			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
 		else
-			data->u.shared_info.gfn = GPA_INVALID;
+			data->u.shared_info.gfn = INVALID_GPA;
 		r = 0;
 		break;
 
@@ -705,7 +705,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
 			     offsetof(struct compat_vcpu_info, time));
 
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == INVALID_GPA) {
 			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
 			r = 0;
 			break;
@@ -719,7 +719,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO:
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == INVALID_GPA) {
 			kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_time_info_cache);
 			r = 0;
 			break;
@@ -739,7 +739,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 			r = -EOPNOTSUPP;
 			break;
 		}
-		if (data->u.gpa == GPA_INVALID) {
+		if (data->u.gpa == INVALID_GPA) {
 			r = 0;
 		deactivate_out:
 			kvm_gpc_deactivate(&vcpu->arch.xen.runstate_cache);
@@ -937,7 +937,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		if (vcpu->arch.xen.vcpu_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_info_cache.gpa;
 		else
-			data->u.gpa = GPA_INVALID;
+			data->u.gpa = INVALID_GPA;
 		r = 0;
 		break;
 
@@ -945,7 +945,7 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		if (vcpu->arch.xen.vcpu_time_info_cache.active)
 			data->u.gpa = vcpu->arch.xen.vcpu_time_info_cache.gpa;
 		else
-			data->u.gpa = GPA_INVALID;
+			data->u.gpa = INVALID_GPA;
 		r = 0;
 		break;
 
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

