Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E86651C745
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiEESXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383187AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFDA1D0E5;
        Thu,  5 May 2022 11:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774551; x=1683310551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJEMN3KdJzcgA289GLYEQLBDGgstxFVCGT3Pqq31q48=;
  b=ivbB6Hc/lw3vPqeClb9Bud+Pf1stkhTk44G/MqwimXi+CXRdQz3rU62B
   zv+pPa1/ajIghz7YI7rajZo3Y6wZdaKdM4VVp+ihZleqZUXRd2Sj3ZBLp
   T8zL8e6CsGDPRlMwvANVeEBw50Gc8DLUhfh+3Ib9jo9OC0PIar9MiB/Gq
   hglFXnbNaEqOUAEZntlId1R8uapX3Qd2s2ENs7OTukVrtWyXraGO+5df9
   zEqGWzskWtRX0vTSw7cPb2IFTdFuSW6kdn7erRbzo8jz14ov3iOckcMk2
   878FQ1pBdr67748ERGGnG0VXh/iN6NoGjWAwyOwn/wyRbq7NVumyApG6Y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248741981"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248741981"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:40 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083144"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:39 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 006/104] KVM: TDX: Detect CPU feature on kernel module initialization
Date:   Thu,  5 May 2022 11:14:00 -0700
Message-Id: <eb5d2891a3ff55d88545221c588ba87e4c811878.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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
Detect CPU feature, enable VMX (TDX is based on VMX), detect TDX module
availability, and initialize TDX module.  This patch implements the first
step to detect CPU feature.  Because VMX isn't enabled yet by VMXON
instruction on KVM kernel module initialization, defer further
initialization step until VMX is enabled by hardware_enable callback.

Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
support.  It's off by default to keep same behavior for those who don't use
TDX.  Implement CPU feature detection at KVM kernel module initialization
as hardware_setup callback to check if CPU feature is available and get
some CPU parameters.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/Makefile       |  1 +
 arch/x86/kvm/vmx/main.c     | 18 ++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c      | 39 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h  |  6 ++++++
 arch/x86/virt/vmx/tdx/tdx.c |  3 ++-
 6 files changed, 67 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 513b9ce9a870..f8f459e28254 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -91,11 +91,13 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+bool __seamrr_enabled(void);
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
 int tdx_detect(void);
 int tdx_init(void);
 bool platform_has_tdx(void);
 #else
+static inline bool __seamrr_enabled(void) { return false; }
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
 static inline int tdx_init(void) { return -ENODEV; }
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
index 636768f5b985..fabf5f22c94f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,22 @@
 #include "nested.h"
 #include "pmu.h"
 
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
 
@@ -147,7 +163,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..9e26e3fa60ee
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+static u64 hkid_mask __ro_after_init;
+static u8 hkid_start_pos __ro_after_init;
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	u32 max_pa;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!platform_has_tdx()) {
+		if (__seamrr_enabled())
+			pr_warn("Cannot enable TDX with SEAMRR disabled\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
+		return -EIO;
+
+	max_pa = cpuid_eax(0x80000008) & 0xff;
+	hkid_start_pos = boot_cpu_data.x86_phys_bits;
+	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
+	pr_info("hkid start pos %d mask 0x%llx\n", hkid_start_pos, hkid_mask);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 1d5dff7c0d96..7a885dc84183 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -122,4 +122,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b6c82e64ad54..e8044114079d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -126,10 +126,11 @@ static int __init tdx_host_setup(char *s)
 }
 __setup("tdx_host=", tdx_host_setup);
 
-static bool __seamrr_enabled(void)
+bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
 }
+EXPORT_SYMBOL_GPL(__seamrr_enabled);
 
 static void detect_seam_bsp(struct cpuinfo_x86 *c)
 {
-- 
2.25.1

