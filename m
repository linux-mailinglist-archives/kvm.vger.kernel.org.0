Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407BC6127B5
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJ3GYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJ3GYC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:02 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68589AA;
        Sat, 29 Oct 2022 23:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111040; x=1698647040;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IF5t22+jjqwYZmXfcnPQEHlPDHTbwXg0OYhOtId3FpQ=;
  b=Hp30dhW+sUWfGQgU/TmS786iIrHCnuHcZ0wF2QPa2KUgsRsnKOtPn3qW
   3awWkQqQsqMkNmCvJo/Uf330IiEHF1Yjs8GmK+ThU6uR+8CLiWbYG3uw8
   SOQj/eZjp7YDMzqBVj8C7cIwdNO9+0nVNC3jhS7KdSizNqBOhzm0bBM4C
   4b9p3ydPGehdg6eam+OexAUmcU3FhjFLsNZiBGDstMvkSv/Hd5N742TZ6
   OPy7AOmMdUdkv0uYzXCnRUf2Scd0FrrjsxYGBBgxMV4PwqQTmQ/MyC03U
   MSyIjOjrG74Ggwr60mvZJTE/a8TSyCtMD1RtfU8Yv7CydFQud3cn3JFQF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037115"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037115"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392844"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392844"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date:   Sat, 29 Oct 2022 23:22:06 -0700
Message-Id: <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a7d4af73228e..a5cbf3ca2055 100644
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
index 000000000000..6213a5c6b637
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
+	ret = tdx_enable();
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
index 1963b28a2ea5..68aef67c5eb7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2479,6 +2479,35 @@ int vmx_hardware_enable(void)
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
@@ -2499,6 +2528,16 @@ void vmx_hardware_disable(void)
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
index 83efb7f92a58..6196d651a00a 100644
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
index 769b3a9a3151..715a53d4fc3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12244,6 +12244,16 @@ static void hardware_enable(void *arg)
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
@@ -12251,29 +12261,29 @@ static void hardware_disable(void *junk)
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
 
@@ -12288,7 +12298,7 @@ int kvm_arch_drop_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable, NULL, 1);
+	kvm_hardware_disable_all();
 	return 0;
 }
 
-- 
2.25.1

