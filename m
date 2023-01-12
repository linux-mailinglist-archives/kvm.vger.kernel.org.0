Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15682667B61
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240699AbjALQmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239921AbjALQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3578413E2C;
        Thu, 12 Jan 2023 08:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541238; x=1705077238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xSAK9wzWcakchG9Fpud1zOJr93UJUdp8n4MpTb2Cywk=;
  b=bgnkftLoEkhPq/E+XJjvcGd54bLGeCa3HTYqHda5EHUex+uRhllv7hLP
   +vo3mFoRaGK4tGFg7ch48T6UZDPyz0Pme26ENxPZKSWqkX7gpVYtkdsC9
   rklIK/TrMnu7NveG69sm1VG3x0cVSzPKwxa1LWBJhnUzzu+ckdo2pLw1+
   EiwLa4lPeCOn9DrnMXUQykZ3ObeXTpbFxxakmaBEtW4WXiaPS6zPCXrRi
   1vQAvavIsgnTXXrBF22ezIy+TDuCdJU5ti+R1GN0x7VtpZ/yE0sJsNcTb
   zWsYBQGGLZJJ7NeMrAmoNWJqFJIYh8qH8+HmgiRXn6GzEfyR2VWsuH1Y5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811758"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811758"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151701"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151701"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Date:   Thu, 12 Jan 2023 08:31:31 -0800
Message-Id: <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
structures, partially initialize it.  Allocate pages of TDX vcpu for the
TDX module.  Actual donation TDX vcpu pages to the TDX module is not done
yet.

In the case of the conventional case, cpuid is empty at the initialization.
and cpuid is configured after the vcpu initialization.  Because TDX
supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
on the vcpu initialization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v10 -> v11:
- NULL check of kvmalloc_array() in tdx_vcpu_reset. Move it to
  tdx_vcpu_create()

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 40 ++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 75 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 10 +++++
 arch/x86/kvm/x86.c         |  2 +
 4 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ddf0742f1f67..59813ca05f36 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -63,6 +63,38 @@ static void vt_vm_free(struct kvm *kvm)
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
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_free(vcpu);
+
+	return vmx_vcpu_free(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_reset(vcpu, init_event);
+
+	return vmx_vcpu_reset(vcpu, init_event);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -90,10 +122,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 557a609c5147..099f0737a5aa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -281,6 +281,81 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *e;
+
+	/*
+	 * On cpu creation, cpuid entry is blank.  Forcibly enable
+	 * X2APIC feature to allow X2APIC.
+	 * Because vcpu_reset() can't return error, allocation is done here.
+	 */
+	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
+	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
+	e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
+	if (!e)
+		return -ENOMEM;
+	*e  = (struct kvm_cpuid_entry2) {
+		.function = 1,	/* Features for X2APIC */
+		.index = 0,
+		.eax = 0,
+		.ebx = 0,
+		.ecx = 1ULL << 21,	/* X2APIC */
+		.edx = 0,
+	};
+	vcpu->arch.cpuid_entries = e;
+	vcpu->arch.cpuid_nent = 1;
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
+	struct msr_data apic_base_msr;
+
+	/* TDX doesn't support INIT event. */
+	if (WARN_ON_ONCE(init_event))
+		goto td_bugged;
+
+	/* TDX rquires X2APIC. */
+	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
+	if (kvm_vcpu_is_reset_bsp(vcpu))
+		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
+	apic_base_msr.host_initiated = true;
+	if (WARN_ON_ONCE(kvm_set_apic_base(vcpu, &apic_base_msr)))
+		goto td_bugged;
+
+	/*
+	 * Don't update mp_state to runnable because more initialization
+	 * is needed by TDX_VCPU_INIT.
+	 */
+	return;
+
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 6c40dda1cc2f..37ab2cfd35bc 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -147,7 +147,12 @@ int tdx_offline_cpu(void);
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
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -159,7 +164,12 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
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
index 1fb135e0c98f..e8bc66031a1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -492,6 +492,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -12109,6 +12110,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.25.1

