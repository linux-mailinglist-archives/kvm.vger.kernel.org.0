Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B5A7625F4
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjGYWQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbjGYWQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA7726BB;
        Tue, 25 Jul 2023 15:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323347; x=1721859347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VpOzptfsxF3R9fDSCTV2aFECXUdM5I95VrP/+dTQHbU=;
  b=V6OqX24zGAFU9EIsh8MFqWrcn/cEcCMnA7ZjT5BK9BI+8f2u39/yTw/8
   HER1BdhT5msl91iDVKEJl/2wcVX55O6rhW1skuwYR3JunHXUfnOqkUdLt
   EqMq01d6EAMLmI4zPlh4xK8uAbmhLk3K8rSOJ1Z10vmGsGuArQB6pT+qS
   Cm5XGVjr/2BHiQTZl9Hh2ginrLwwVRo2KmhMqT2cagZtUomt+SF2UrPRF
   v29e7DARJD+eQ0GAkKN0p+QITppnlt27S5XctT7O46+0SblRAGqRyH3GW
   sjAL6XHMq5l5WaqnR2yL7fiOFn+QRTdQiYPcThgohbWxtik0HgUc1aoCf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863161"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863161"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938848"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938848"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:25 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 025/115] KVM: TDX: allocate/free TDX vcpu structure
Date:   Tue, 25 Jul 2023 15:13:36 -0700
Message-Id: <8e54ce03a43838906ceae5866cc0c57d0e112eee.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
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

The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
structures, initialize it that doesn't require TDX SEAMCALL.  TDX specific
vcpu initialization will be implemented as independent KVM_TDX_INIT_VCPU
so that when error occurs it's easy to determine which component has the
issue, KVM or TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 44 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
 arch/x86/kvm/x86.c         |  2 ++
 4 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d9c8becfe749..6ed9116f1b5c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -98,6 +98,42 @@ static void vt_vm_free(struct kvm *kvm)
 		tdx_vm_free(kvm);
 }
 
+static int vt_vcpu_precreate(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_vcpu_precreate(kvm);
+}
+
+static int vt_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_create(vcpu);
+
+	return vmx_vcpu_create(vcpu);
+}
+
+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_free(vcpu);
+		return;
+	}
+
+	vmx_vcpu_free(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_reset(vcpu, init_event);
+		return;
+	}
+
+	vmx_vcpu_reset(vcpu, init_event);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -136,10 +172,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vm_destroy = vt_vm_destroy,
 	.vm_free = vt_vm_free,
 
-	.vcpu_precreate = vmx_vcpu_precreate,
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
+	.vcpu_precreate = vt_vcpu_precreate,
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 36d687e7c3f3..5f5e451b201a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -316,6 +316,50 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * On cpu creation, cpuid entry is blank.  Forcibly enable
+	 * X2APIC feature to allow X2APIC.
+	 * Because vcpu_reset() can't return error, allocation is done here.
+	 */
+	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
+	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
+
+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
+
+	return 0;
+}
+
+void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	/* This is stub for now.  More logic will come. */
+}
+
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+
+	/* Ignore INIT silently because TDX doesn't support INIT event. */
+	if (init_event)
+		return;
+
+	/* This is stub for now. More logic will come here. */
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9394a7148c5e..aaa419363276 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -145,7 +145,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -159,7 +164,12 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29a71f722fbb..4afe24f50dcb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -498,6 +498,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -12268,6 +12269,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.25.1

