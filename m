Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA35D491F80
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 07:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiARGtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 01:49:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:49404 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243179AbiARGte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 01:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642488574; x=1674024574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zeKFisLcTn3SYsHCdtM4J/tldathG8abND9ZUmvW4CI=;
  b=Ngs0frGhR/FVWz90tZ6EJcgVYUR9xoq53L2JxWf/oISgaQwR0J3GRjyl
   i9ruqN8daXpajqwbSndubuu8UGr5Lhdiq7URgBU0xt2zgs1IFcyklKtZF
   o5kMXXapI/uev78ge+0WwAwrNafmSH/AKWnLNFvLl0pNjzt6J8szUZguk
   0AxfE0gC48URkKdF1ZaipIZYy5e0woytpXRyXtRLgOR+cu5HYoZnYYdyw
   XdP1WoQ2lGWMA5VkawtmwuhWjgeNCJ35Zpx+0oKPFlyor9xn1b2Gpucb8
   ec5s0UKzlZpQmDfFOZpleDqSZQrqEI/rOLeYQhKlhOFT6qwMV4r7uAJeb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="305484651"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="305484651"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="531648568"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:30 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: x86: Move check_processor_compatibility from init ops to runtime ops
Date:   Tue, 18 Jan 2022 14:44:24 +0800
Message-Id: <20220118064430.3882337-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118064430.3882337-1-chao.gao@intel.com>
References: <20220118064430.3882337-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
from check_processor_compatibility() and its callees.

Use a static_call() to invoke .check_processor_compatibility().

Signed-off-by: Chao Gao <chao.gao@intel.com>
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
index f658bb4dbb74..ab9b4eca56be 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -123,6 +123,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(check_processor_compatibility)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 89d1fdb39c46..a916b16edd89 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1314,6 +1314,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	const char *name;
 
+	int (*check_processor_compatibility)(void);
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
@@ -1526,7 +1527,6 @@ struct kvm_x86_nested_ops {
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
-	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
 
 	struct kvm_x86_ops *runtime_ops;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c3d9006478a4..5725fed5ced7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4064,7 +4064,7 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
+static int svm_check_processor_compat(void)
 {
 	return 0;
 }
@@ -4613,6 +4613,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
 	.hardware_unsetup = svm_hardware_teardown,
+	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
@@ -4746,7 +4747,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
-	.check_processor_compatibility = svm_check_processor_compat,
 
 	.runtime_ops = &svm_x86_ops,
 };
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index ba6f99f584ac..50f923e9917e 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -296,7 +296,7 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
+void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 16731d2cf231..17a7c956396b 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -181,7 +181,7 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
+void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 15e30602782b..364348e134df 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2402,8 +2402,8 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
-static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
+			       u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2421,8 +2421,8 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
-static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-				    struct vmx_capability *vmx_cap)
+static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			     struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 min, opt, min2, opt2;
@@ -7051,7 +7051,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static int __init vmx_check_processor_compat(void)
+static int vmx_check_processor_compat(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -7663,6 +7663,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_unsetup = hardware_unsetup,
 
+	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
@@ -7999,7 +8000,6 @@ static __init int hardware_setup(void)
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
 
 	.runtime_ops = &vmx_x86_ops,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 60da2331ec32..f8bc1948a8b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11473,7 +11473,6 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
@@ -11481,7 +11480,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->check_processor_compatibility();
+	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.25.1

