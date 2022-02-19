Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3A4BCA3C
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbiBSSuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242082AbiBSSuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:14 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D826E783;
        Sat, 19 Feb 2022 10:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296595; x=1676832595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YH4D2PdxJvZoiYSTklg4Jn9q8UBa/9gVf9RehbWLD2g=;
  b=QJe6uRGEzRiIYulhyxlzMNBZL/PZpBhE9azfl0UpMAkMvv4Bx5oKArYB
   jqox1H0vjXmt48EQbNGy8GfcdDFisfrcssxRXXQYB69W7962KKUm7U86T
   e9LTBQkD5Efk7WEJheOnAxcrHfRYv//vkFRC0FgLuSk8yaYqp615nQth3
   iQoWrip/rim696+RxvJhtyCU4afs1iE9Q30BMqkYCbvU95mP+tLHh4++F
   BmOkulo+BqgRZ7OAW6nrj93hPxrebOYdjv4/nrXpzSN9BT4U7CD8+lD2Q
   hK5Y60Hk+qb4Rdm+diGjQISk0uWr/SyfOhVAGu8dpN9rsF9AyHaBgprc4
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312058994"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312058994"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137026"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:54 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 2/8] KVM: TDX: Detect CPU feature on kernel module initialization
Date:   Sat, 19 Feb 2022 10:49:47 -0800
Message-Id: <117f88da7f76e8cd4615eb4c2cf1ffb332f16d7a.1645266955.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645266955.git.isaku.yamahata@intel.com>
References: <cover.1645266955.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 15 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 61 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 4 files changed, 82 insertions(+), 1 deletion(-)
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
index b08ea9c42a11..b79fcc8d81dd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,19 @@
 #include "nested.h"
 #include "pmu.h"
 
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	tdx_hardware_setup(&vt_x86_ops);
+
+	return 0;
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -147,7 +160,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.check_processor_compatibility = vmx_check_processor_compat,
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..65ca8f330d2c
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+/*
+ * workaround to compile.
+ * TODO: once the TDX module initiation code in x86 host is merged, remove this.
+ */
+#if __has_include(<asm/seam.h>)
+bool seamrr_enabled(void);
+#else
+static inline bool seamrr_enabled(void) { return false; }
+#endif
+
+static bool __read_mostly enable_tdx = true;
+module_param_named(tdx, enable_tdx, bool, 0644);
+
+static u64 hkid_mask __ro_after_init;
+static u8 hkid_start_pos __ro_after_init;
+
+static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	u32 max_pa;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!seamrr_enabled()) {
+		pr_warn("Cannot enable TDX with SEAMRR disabled\n");
+		return -ENODEV;
+	}
+
+	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
+		return -EIO;
+
+	max_pa = cpuid_eax(0x80000008) & 0xff;
+	hkid_start_pos = boot_cpu_data.x86_phys_bits;
+	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
+
+	return 0;
+}
+
+void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	/*
+	 * This function is called at the initialization.  No need to protect
+	 * enable_tdx.
+	 */
+	if (!enable_tdx)
+		return;
+
+	if (__tdx_hardware_setup(&vt_x86_ops))
+		enable_tdx = false;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 40c64fb1f505..ccf98e79d8c3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -123,4 +123,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

