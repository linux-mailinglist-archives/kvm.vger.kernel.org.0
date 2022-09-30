Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED9A5F0860
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbiI3KT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiI3KS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6888E166F07;
        Fri, 30 Sep 2022 03:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533136; x=1696069136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JnFXrC+6aqQ8dcetgBc+3o8D+CJRWBcwhKWhQqdhSrg=;
  b=FLCZVETmGdgyvdAO7n2c+BN9v1YRz1sSdUIabzyQ+97lPGQ2ISefU7/Y
   ibQ0MLVVpyMvfG0aIW11YYPUIOa/RLa+tFvMXdylBmPj23KpzvVAjUAVP
   LTBUZc9YkJBWaKi5uLl1YOlJ6coIB1Q7iPYacR0fgFC3elT5xXPvK8KHQ
   dV1h9Y6jQOHGLaO49MYFkK7E5VrXD2fgo6rL3TlE/YfpGe+hUKWJnLg75
   +WzJuzOe2PfV6VDWGX9xrS2EEExGHOvr1q5MckDEhP31fpnlpaSrtZsg5
   kyk/7Wbd6E/U6AL94Udsd8c5SweLK/kQcoaBJAQOqifdccLntu+ClORaV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="366207477"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="366207477"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:52 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807518"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807518"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 005/105] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date:   Fri, 30 Sep 2022 03:16:59 -0700
Message-Id: <9b5afc53b5ba35d04a666eaa31939bdb2dc3ec66.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX module
availability, and initialize it.  This patch implements those steps.

There are several options on when to initialize the TDX module.  A.) kernel
module loading time, B.) the first guest TD creation time.  A.) was chosen.
With B.), a user may hit an error of the TDX initialization when trying to
create the first guest TD.  The machine that fails to initialize the TDX
module can't boot any guest TD further.  Such failure is undesirable and a
surprise because the user expects that the machine can accommodate guest
TD, but actually not.  So A.) is better than B.).

Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
support.  It's off by default to keep same behavior for those who don't use
TDX.  Implement hardware_setup method to detect TDX feature of CPU.
Because TDX requires all present CPUs to enable VMX (VMXON).  The x86
specific kvm_arch_post_hardware_enable_setup overrides the existing weak
symbol of kvm_arch_post_hardware_enable_setup which is called at the KVM
module initialization.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 18 ++++++-
 arch/x86/kvm/vmx/tdx.c     | 99 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 39 +++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  9 ++++
 arch/x86/kvm/x86.c         | 32 +++++++-----
 6 files changed, 186 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index ee4d0999f20f..e2c05195cb95 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,6 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c8e8b0212a2a..1535f55fc312 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,6 +7,22 @@
 #include "pmu.h"
 #include "tdx.h"
 
+static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
+
+	return 0;
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -148,7 +164,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..6f8451ff8980
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+#include "tdx.h"
+#include "x86.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+#define TDX_MAX_NR_CPUID_CONFIGS					\
+	((sizeof(struct tdsysinfo_struct) -				\
+		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
+		/ sizeof(struct tdx_cpuid_config))
+
+struct tdx_capabilities {
+	u8 tdcs_nr_pages;
+	u8 tdvpx_nr_pages;
+
+	u64 attrs_fixed0;
+	u64 attrs_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+
+	u32 nr_cpuid_configs;
+	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
+};
+
+/* Capabilities of KVM + the TDX module. */
+static struct tdx_capabilities tdx_caps;
+
+static int __init tdx_module_setup(void)
+{
+	const struct tdsysinfo_struct *tdsysinfo;
+	int ret = 0;
+
+	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
+	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
+
+	ret = tdx_init();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
+	tdsysinfo = tdx_get_sysinfo();
+	if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
+		return -EIO;
+
+	tdx_caps = (struct tdx_capabilities) {
+		.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
+		/*
+		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
+		 * -1 for TDVPR.
+		 */
+		.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
+		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
+		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
+		.xfam_fixed0 =	tdsysinfo->xfam_fixed0,
+		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
+		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
+	};
+	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
+			tdsysinfo->num_cpuid_config *
+			sizeof(struct tdx_cpuid_config)))
+		return -EIO;
+
+	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
+		boot_cpu_data.x86_phys_bits);
+
+	return 0;
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	int r;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	/* MOVDIR64B instruction is needed. */
+	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {
+		pr_warn("Cannot enable TDX with MOVDIR64B supported ");
+		return -ENODEV;
+	}
+
+	/* TDX requires VMX. */
+	r = vmxon_all();
+	if (!r)
+		r = tdx_module_setup();
+	vmxoff_all();
+
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7bad73d5822e..fb626adc347d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2464,6 +2464,35 @@ int vmx_hardware_enable(void)
 	return 0;
 }
 
+static void __init vmxon(void *arg)
+{
+	int cpu = raw_smp_processor_id();
+	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
+	atomic_t *failed = arg;
+	int r;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE) {
+		r = -EBUSY;
+		goto out;
+	}
+
+	r = kvm_cpu_vmxon(phys_addr);
+out:
+	if (r)
+		atomic_inc(failed);
+}
+
+int __init vmxon_all(void)
+{
+	atomic_t failed = ATOMIC_INIT(0);
+
+	on_each_cpu(vmxon, &failed, 1);
+
+	if (atomic_read(&failed))
+		return -EBUSY;
+	return 0;
+}
+
 static void vmclear_local_loaded_vmcss(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -2484,6 +2513,16 @@ void vmx_hardware_disable(void)
 	intel_pt_handle_vmx(0);
 }
 
+static void __init vmxoff(void *junk)
+{
+	cpu_vmxoff();
+}
+
+void __init vmxoff_all(void)
+{
+	on_each_cpu(vmxoff, NULL, 1);
+}
+
 /*
  * There is no X86_FEATURE for SGX yet, but anyway we need to query CPUID
  * directly instead of going through cpu_has(), to ensure KVM is trapping
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c0ff4b88e8f9..1f46fbae346c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -17,6 +17,9 @@ __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
 __init int vmx_hardware_setup(void);
 
+int __init vmxon_all(void);
+void __init vmxoff_all(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -127,4 +130,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 694c25d1381b..8d0df3527944 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11975,6 +11975,16 @@ static void hardware_enable(void *arg)
 		atomic_inc(failed);
 }
 
+static int kvm_hardware_enable_all(void)
+{
+	atomic_t failed = ATOMIC_INIT(0);
+
+	on_each_cpu(hardware_enable, &failed, 1);
+	if (atomic_read(&failed))
+		return -EBUSY;
+	return 0;
+}
+
 static void hardware_disable(void *junk)
 {
 	WARN_ON_ONCE(preemptible());
@@ -11982,29 +11992,29 @@ static void hardware_disable(void *junk)
 	drop_user_return_notifiers();
 }
 
+static void kvm_hardware_disable_all(void)
+{
+	on_each_cpu(hardware_disable, NULL, 1);
+}
+
 /*
  * Called after the VM is otherwise initialized, but just before adding it to
  * the vm_list.
  */
 int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 {
-	atomic_t failed = ATOMIC_INIT(0);
-	int r = 0;
+	int r;
 
 	if (usage_count != 1)
 		return kvm_mmu_post_init_vm(kvm);
 
-	on_each_cpu(hardware_enable, &failed, 1);
-
-	if (atomic_read(&failed)) {
-		r = -EBUSY;
-		goto err;
-	}
+	r = kvm_hardware_enable_all();
+	if (r)
+		return r;
 
 	r = kvm_mmu_post_init_vm(kvm);
-err:
 	if (r)
-		on_each_cpu(hardware_disable, NULL, 1);
+		kvm_hardware_disable_all();
 	return r;
 }
 
@@ -12013,7 +12023,7 @@ int kvm_arch_del_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable, NULL, 1);
+	kvm_hardware_disable_all();
 	return 0;
 }
 
-- 
2.25.1

