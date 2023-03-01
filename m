Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5E6A64A7
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 02:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjCABT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 20:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCABTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 20:19:48 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BFC6590;
        Tue, 28 Feb 2023 17:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677633585; x=1709169585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sCnaWKJVoDQfEgLdcpa7EQVCmkGidZhXadVH6hYb8Ys=;
  b=D6n9DSVfWJ7gj4YQ/V79IMVI9g+b5OcJi6kbwMMqByqBj+9lh9Om53T1
   uJRtoe5/tWL0LRkltF5YKnKEcFuvgfbDIhkWniqcm8lRxxyLdigtKyM8t
   fas6MnVOosRA/LqA1PdA7RunLQJJGRdff8S1R9yqHQXJGSNCsHc70qafx
   oNwwlGV28KPUjRvDfkt1Vlq8cLzgg01A8QNM6VRe0K5t3o+8RKBa7MxYY
   QiEatMVUNNPE5TK670GhbryJeMVfTZP47Ci8m1aZBOW7Ie15ZkkfmM8Z5
   GN+g4xOeR8lzZPSmOtrZrDxjq0QeMExaujEzckST8PXqCM57EGntrtfiW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="361867114"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="361867114"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 17:19:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="798242336"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="798242336"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 17:19:37 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 3/6] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date:   Tue, 28 Feb 2023 17:19:13 -0800
Message-Id: <64a9c956f265c625ea600fe70f6223a43747e3d2.1677632938.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b17eee6a7d5379bf16419c0b38ed99433afbf62f.1677632938.git.isaku.yamahata@intel.com>
References: <b17eee6a7d5379bf16419c0b38ed99433afbf62f.1677632938.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX module
availability, and initialize it.

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
Because TDX requires all present CPUs to enable VMX (VMXON), the x86
specific kvm_arch_post_hardware_enable_setup overrides the existing weak
symbol of kvm_arch_post_hardware_enable_setup which is called at the KVM
module initialization.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 18 +++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 44 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 39 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
 5 files changed, 111 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 0e894ae23cbc..4b01ab842ab7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,6 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o svm/hyperv.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3f49e8e38b6b..5c9f5e00b3c4 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,22 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool enable_tdx __ro_after_init;
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
 #define VMX_REQUIRED_APICV_INHIBITS		       \
 (						       \
        BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
@@ -159,7 +175,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..d7a276118940
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,44 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static int __init tdx_module_setup(void)
+{
+	int ret;
+
+	ret = tdx_enable();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
+	pr_info("TDX is supported.\n");
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
+	/* TDX requires VMX. */
+	r = vmxon_all();
+	if (!r)
+		r = tdx_module_setup();
+	vmxoff_all();
+
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d6845db3ab3f..bddbdd2988f4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8104,6 +8104,45 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	return 1;
 }
 
+static __init void vmxon(void *arg)
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
+__init int vmxon_all(void)
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
+static __init void vmxoff(void *junk)
+{
+	cpu_vmxoff();
+}
+
+__init void vmxoff_all(void)
+{
+	on_each_cpu(vmxoff, NULL, 1);
+}
+
 static __init void vmx_setup_user_return_msrs(void)
 {
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 051b5c4b5c2f..0f200aead411 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -20,6 +20,10 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmxon_all(void);
+__init void vmxoff_all(void);
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -133,4 +137,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

