Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26464DA5B9
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 23:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbiCOWvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 18:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352393AbiCOWvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 18:51:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5A05D1A2;
        Tue, 15 Mar 2022 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647384618; x=1678920618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AoL+AQKyb3WLrBNANBB4c8DGr0XOP5pxqBpjs6Zn37k=;
  b=OoBFAhblftbHGfQ88LcYHUWNVM0yrOoFFMpHa3+abHvgnuiYr2WNOYxe
   CkM7Az3p1R6oX3Hxs2nsEeZcfGrWQ5ocSM8njQWAyYi3IPsTKi1v/xSEl
   p5Z/2hxPUzS8l2y6Q1EbmB221eCXXpABfZiqt2H3l/RUOl2CPN4t7pjmB
   bY8yFIdBazHfvBRdWXs9nSrfM68ZPVa2ky1TWa5Xco0aBIigj6pcPOLJY
   HnHLM4EidL0CBIx7UF3rpyPWV65aQVlyu4u0wFxm1vXhAhz5NvlXEHP/B
   XKA1iM9iM4aSsp8bnYg1jMNzR1RKUOZ8Y3dLldo5C44rO29+/mBgSkD/E
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256390620"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="256390620"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="690368472"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6/6] KVM: TDX: Make TDX VM type supported
Date:   Tue, 15 Mar 2022 15:50:10 -0700
Message-Id: <c4c6bffb4502df9059f1033e07a702b6de37160d.1647384148.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647384147.git.isaku.yamahata@intel.com>
References: <cover.1647384147.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

As first step TDX VM support, return that TDX VM type supported to device
model, e.g. qemu.  The callback to create guest TD is vm_init callback for
KVM_CREATE_VM.  Add a place holder function and call a function to
initialize TDX module on demand because in that callback VMX is enabled by
hardware_enable callback (vmx_hardware_enable).

Although guest TD isn't functional at this point, it's possible for
KVM developer to exercise (partially implemented) TDX KVM code.  Introduce
X86_TDX_KVM_EXPERIMENTAL to allow TDX KVM code to be exercised.  Once TDX
KVM is functional, the config will be removed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig       | 14 ++++++++++++++
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    |  7 ++++++-
 arch/x86/kvm/vmx/tdx.c     | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     |  5 -----
 arch/x86/kvm/vmx/x86_ops.h |  7 ++++++-
 6 files changed, 44 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2b1548da00eb..a3287440aa9e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -98,6 +98,20 @@ config X86_SGX_KVM
 
 	  If unsure, say N.
 
+config X86_TDX_KVM_EXPERIMENTAL
+	bool "EXPERIMENTAL Trust Domian Extensions (TDX) KVM support"
+	default n
+	depends on INTEL_TDX_HOST
+	depends on KVM_INTEL
+	help
+	  Enable experimental TDX KVM support.  TDX KVM needs many patches and
+	  the patches will be merged step by step, not at once. Even if TDX KVM
+	  support is incomplete, enable TDX KVM support so that developper can
+	  exercise TDX KVM code.  TODO: Remove this configuration once the
+	  (first step of) TDX KVM support is complete.
+
+	  If unsure, say N.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
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
index 459087fcf7b7..086b5106c15a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,6 +7,11 @@
 #include "pmu.h"
 #include "tdx.h"
 
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM || tdx_is_vm_type_supported(type);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -17,7 +22,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.is_vm_type_supported = vmx_is_vm_type_supported,
+	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..02271a3e2733
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "x86_ops.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+static bool __read_mostly enable_tdx = true;
+module_param_named(tdx, enable_tdx, bool, 0644);
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+#ifdef CONFIG_X86_TDX_KVM_EXPERIMENTAL
+	return type == KVM_X86_TDX_VM && READ_ONCE(enable_tdx);
+#else
+	return false;
+#endif
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 191e653355dd..538b91380c06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7085,11 +7085,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-bool vmx_is_vm_type_supported(unsigned long type)
-{
-	return type == KVM_X86_DEFAULT_VM;
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e0a4c6438c88..2fb5df625bb1 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
 bool report_flexpriority(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -127,4 +126,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+bool tdx_is_vm_type_supported(unsigned long type);
+#else
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

