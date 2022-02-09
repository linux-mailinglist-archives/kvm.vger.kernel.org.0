Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F914AEB49
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 08:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbiBIHli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 02:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238886AbiBIHlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 02:41:35 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62CC0613CA;
        Tue,  8 Feb 2022 23:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644392499; x=1675928499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vaTrRgufDi0pw8hbdS+IY/vlRc9TqpU/H7WiltbW1KY=;
  b=mKBGBQGVijIeNgNrhyeQIPMihM8caiIShjR/BdneqMvIxHCdmL/8kSCY
   aw5WMiQWohMex43f4fJ2Hnafcx2fhIfj9GBZuJfTmCEzHSs2mLAT+D15s
   VFG2j3bYGIm0tVdGiiH4pWNKYwbtC09rwTD96tPZJtSZyXbMtG7dwS5fJ
   ub2+Ywq6/cJYGtTej5AkMC0hIxttCpkbZ1pWmFClscX1LSF+LqY4bv7f2
   BaGbcHCvHWqEAjQAsmki/JNK15lnsP3v3+UGlt41UnrRxyHI1/2j/wUQO
   OYauMc6+9EiKBBXJp26UBGLSVu8XUbtS1d2ciVmmxdcp1qEIFD6ogUdWc
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="247980724"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="247980724"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:41:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="540984552"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 23:41:35 -0800
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
Subject: [PATCH v3 1/5] KVM: x86: Move check_processor_compatibility from init ops to runtime ops
Date:   Wed,  9 Feb 2022 15:41:02 +0800
Message-Id: <20220209074109.453116-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209074109.453116-1-chao.gao@intel.com>
References: <20220209074109.453116-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index c371ee7e45f7..f65ccb5597bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1314,6 +1314,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	const char *name;
 
+	int (*check_processor_compatibility)(void);
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
@@ -1518,7 +1519,6 @@ struct kvm_x86_nested_ops {
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
-	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
 
 	struct kvm_x86_ops *runtime_ops;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 975be872cd1a..df20d50526ce 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3858,7 +3858,7 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
+static int svm_check_processor_compatibility(void)
 {
 	return 0;
 }
@@ -4468,6 +4468,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
 	.hardware_unsetup = svm_hardware_unsetup,
+	.check_processor_compatibility = svm_check_processor_compatibility,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
@@ -4839,7 +4840,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
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
index 8ac5a6fa7720..fc94d7139f69 100644
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
@@ -7116,7 +7116,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static int __init vmx_check_processor_compat(void)
+static int vmx_check_processor_compatibility(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -7709,6 +7709,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
+	.check_processor_compatibility = vmx_check_processor_compatibility,
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
@@ -8043,7 +8044,6 @@ static __init int hardware_setup(void)
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
 
 	.runtime_ops = &vmx_x86_ops,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f69f3e3635e..b71549a52ae0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11551,7 +11551,6 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
@@ -11559,7 +11558,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->check_processor_compatibility();
+	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.25.1

