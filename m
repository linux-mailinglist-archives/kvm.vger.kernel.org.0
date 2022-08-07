Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7911458BD33
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbiHGWCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiHGWCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8934064D9;
        Sun,  7 Aug 2022 15:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909753; x=1691445753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TubSQa/W4GT6nMyC+Wd6QVRPoUgj6OyrX1UEHIPxpCM=;
  b=km9bEJ+Hn1F7N78nd0BH+N7hwJGfcD0A4jcqBjh3koW9178YfbWLzVc1
   bq977IsRYGcYaZo/0fsugLvWyheaPTJICrOnWnvjrQA4qZuDBfkGh+KaD
   K/cQXWQvzERGevAhOgbGZpXd2MoAyfHMGGo0PVeFRKQHVx3/3WWfJjoEN
   jAME5hBbPbjx9xlolvmYQuqmycmqZ1qVQnUWdWT8p3qFTAzA+A3K26vTR
   b9W0dP3EvPG8rgm/HqXsaOnVrfN2tRHwDQcwVs0hYsNS4NYsLuyky+k8T
   IFf5ktpWy1Z0l5I+tzESwPYhoyn+xGXF5hTWvgWNJapOATp7/OnVNL+7r
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224057"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682463"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 009/103] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date:   Sun,  7 Aug 2022 15:00:54 -0700
Message-Id: <b6f8588f51f530e3904d2b98199aba6547032ea4.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/Makefile           |  1 +
 arch/x86/kvm/vmx/main.c         | 29 ++++++++++-
 arch/x86/kvm/vmx/tdx.c          | 89 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  4 ++
 arch/x86/kvm/vmx/x86_ops.h      |  6 +++
 arch/x86/kvm/x86.c              |  8 +++
 arch/x86/virt/vmx/tdx/tdx.c     |  1 +
 8 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d000f060077..f432ad32515c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1659,6 +1659,7 @@ struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
 	int (*hardware_setup)(void);
+	int (*post_hardware_enable_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
 
 	struct kvm_x86_ops *runtime_ops;
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
index a0252cc0b48d..ac788af17d92 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,6 +7,32 @@
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
+static int __init vt_post_hardware_enable_setup(void)
+{
+	enable_tdx = enable_tdx && !tdx_module_setup();
+	/*
+	 * Even if it failed to initialize TDX module, conventional VMX is
+	 * available.  Keep VMX usable.
+	 */
+	return 0;
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -148,7 +174,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
+	.post_hardware_enable_setup = vt_post_hardware_enable_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..e9a17f3666de
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+#include "tdx.h"
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
+int __init tdx_module_setup(void)
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
+	return 0;
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!platform_tdx_enabled()) {
+		pr_warn("Cannot enable TDX on TDX disabled platform\n");
+		return -ENODEV;
+	}
+
+	pr_info("kvm: TDX is supported. x86 phys bits %d\n",
+		boot_cpu_data.x86_phys_bits);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 060bf48ec3d6..54d7a26ed9ee 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,8 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+int tdx_module_setup(void);
+
 struct kvm_tdx {
 	struct kvm kvm;
 	/* TDX specific members follow. */
@@ -37,6 +39,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 #else
+static inline int tdx_module_setup(void) { return -ENODEV; };
+
 struct kvm_tdx {
 	struct kvm kvm;
 };
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 90a8c6824833..f318a6258a24 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -128,4 +128,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
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
index e533cce7a70b..32a2ef718112 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11983,6 +11983,14 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
+int kvm_arch_post_hardware_enable_setup(void *opaque)
+{
+	struct kvm_x86_init_ops *ops = opaque;
+	if (ops->post_hardware_enable_setup)
+		return ops->post_hardware_enable_setup();
+	return 0;
+}
+
 void kvm_arch_hardware_unsetup(void)
 {
 	kvm_unregister_perf_callbacks();
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b9567a2217df..918e79159bbf 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1283,6 +1283,7 @@ bool platform_tdx_enabled(void)
 {
 	return tdx_keyid_num >= 2;
 }
+EXPORT_SYMBOL_GPL(platform_tdx_enabled);
 
 /**
  * tdx_init - Initialize the TDX module
-- 
2.25.1

