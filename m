Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48DF4CDE74
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiCDUFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiCDUFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:05:10 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1474324C416;
        Fri,  4 Mar 2022 12:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424023; x=1677960023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jcFgk/ua3c3j/x1mPL+LlmAehuUJ6toQSVwf7H8Lbco=;
  b=MreKRWNAKer9DV6wUERnJrBd81EMqIOoEnu5RuuS8pNnXUfZmy+3AlKd
   IgbLC2/MkPVRR38+FaFq8YMQJRvoxnb79LDzNG8SSPXzg+gCXRvtL+izE
   YJ/Qrd2wx0Mle4BtGjrK4nVCwpcUIHswyh4RzZDEAgJ1Jd7VHjq+tZJHj
   Sprciz0SSEUpTon+kRNRv/ivgQfu+3CSbOGdV/GZdvJNQKArs97/g5Bqb
   y9SrQIwN2p10bX3DDXJz0VGhxfVtYoQr3rn/qtp8DpLr+viGDKEqIW9PC
   B6fRmnToFuGboWUmCIdWcLHekrYd9PPahgcOj7ed3MNtmO7r/vUN3vPng
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983282"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983282"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:03 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344063"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:02 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 003/104] KVM: TDX: Detect CPU feature on kernel module initialization
Date:   Fri,  4 Mar 2022 11:48:19 -0800
Message-Id: <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx/main.c    | 15 ++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 53 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 +++++
 4 files changed, 74 insertions(+), 1 deletion(-)
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
index 000000000000..1acf08c310c4
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,53 @@
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
+	if (!platform_has_tdx()) {
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

