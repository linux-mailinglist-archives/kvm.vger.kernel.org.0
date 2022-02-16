Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07034B7EBF
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344124AbiBPDQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344110AbiBPDQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:04 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB8FDCE07;
        Tue, 15 Feb 2022 19:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981353; x=1676517353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DlL2v0Wh9Vt/N3ZHWaxB+6mMkKskQwZNeJemBveuQDU=;
  b=RE2NSGlhGXwKP5G/cKMA1C2M2F3N2iAVly+B7bqz3d8a+80nZfikfAHJ
   RqENGwqsHdaYOFGJmVFvWQDaKxq8jJ87GEKAq9zyKVgtlOVkS9at3gqSn
   AT/Exw0oS+FXPSrzA3oJDA8df6fI2Oxr6qE2N7fVNRzHvuTHqRxDqKOt1
   lnB8RYffwsh2CPdDyEP03YwVlTcB6GELFMsga3j2P8KHeYlvVYyxsDga7
   Y3gTqxIet0Kr3Y0aCaHv0sanWJuWuR28eVniA/OIg2NtBvA4ANOh6TJA4
   7Ii/A1u7vXHUiOaxv65YwxC+XvHPNbYNkccH4u5giPkdefmKYXfMGvAvx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250250418"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250250418"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:15:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798154"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:15:49 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/6] KVM: x86: Move check_processor_compatibility from init ops to runtime ops
Date:   Wed, 16 Feb 2022 11:15:16 +0800
Message-Id: <20220216031528.92558-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
from check_processor_compatibility() and its callees.

use a static_call() to invoke .check_processor_compatibility.

Opportunistically rename {svm,vmx}_check_processor_compat to conform
to the naming convention of fields of kvm_x86_ops.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             |  4 ++--
 arch/x86/kvm/vmx/evmcs.c           |  2 +-
 arch/x86/kvm/vmx/evmcs.h           |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 12 ++++++------
 arch/x86/kvm/x86.c                 |  3 +--
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e37dc3d8863..08494f172e2e 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,6 +125,7 @@ KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
+KVM_X86_OP(check_processor_compatibility)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10815b672a26..7ac393a8dd54 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1315,6 +1315,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	const char *name;
 
+	int (*check_processor_compatibility)(void);
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
@@ -1519,7 +1520,6 @@ struct kvm_x86_nested_ops {
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
-	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4243bb355db0..6244f669f03e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,7 +3907,7 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
+static int svm_check_processor_compatibility(void)
 {
 	return 0;
 }
@@ -4527,6 +4527,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
 	.hardware_unsetup = svm_hardware_unsetup,
+	.check_processor_compatibility = svm_check_processor_compatibility,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
@@ -4899,7 +4900,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
-	.check_processor_compatibility = svm_check_processor_compat,
 
 	.runtime_ops = &svm_x86_ops,
 };
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 87e3dc10edf4..a2a4c87d0558 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -295,7 +295,7 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
 #if IS_ENABLED(CONFIG_HYPERV)
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
+void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 8d70f9aea94b..3fd4cc44d8ad 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -211,7 +211,7 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
+void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 70e7f00362bc..5e1b40e5ad87 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2403,8 +2403,8 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
-static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
+			       u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2422,8 +2422,8 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
-static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-				    struct vmx_capability *vmx_cap)
+static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			     struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 min, opt, min2, opt2;
@@ -7118,7 +7118,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static int __init vmx_check_processor_compat(void)
+static int vmx_check_processor_compatibility(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -7712,6 +7712,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
+	.check_processor_compatibility = vmx_check_processor_compatibility,
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
@@ -8066,7 +8067,6 @@ static __init int hardware_setup(void)
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eaa3b5b89c5e..9b484ed61f37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11512,7 +11512,6 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
@@ -11520,7 +11519,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->check_processor_compatibility();
+	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.25.1

