Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64E7625BE
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjGYWPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjGYWPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7592FE63;
        Tue, 25 Jul 2023 15:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323337; x=1721859337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5a2WKImnOiYyHHrWolihB7s+ZRh5ja5wue/MjhxUwd0=;
  b=Gj952pRt8vOYTci5SPjYrU8ImY6I4e/FI42/hjXUukuAVzaMTnRZncKr
   BTPKwFulon3j7SvYZeJ5aXngDrDGG/+wA08TN34X9ul4oZiKElqV1EIQI
   MOOIPJzYbz+puXkxtKaLczR53OAAaDMeSHrz9MrXg7mkjCroBu8r3qHte
   ZEcFSmBR2mB32fu9lqDP2SQ3q4+U7KuF5iAbDS4LVK4UONBDKDh+Jls+n
   SRsTsLQbpapw7HJfBy/Hx0svOyDftss0xvFLB669q8D5hrHIKaeDftFyZ
   ysBV1mK6gb9SJEvOMD8VRYl8TNZCkrdyoOPxQMA+UNFi9rxXSW4ibjN3y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863036"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863036"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938778"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938778"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 005/115] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date:   Tue, 25 Jul 2023 15:13:16 -0700
Message-Id: <e1036403220bd7b945bf9dc711432e12691207a7.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX) on all online CPUs,
detect the TDX module availability, initialize it and disable VMX.

To enable/disable VMX on all online CPUs, utilize
vmx_hardware_enable/disable().  The method also initializes each CPU for
TDX.  TDX requires calling a TDX initialization function per logical
processor (LP) before the LP uses TDX.  When the CPU is becoming online,
call the TDX LP initialization API.  If it fails to initialize TDX, refuse
CPU online for simplicity instead of TDX avoiding the failed LP.

There are several options on when to initialize the TDX module.  A.) kernel
module loading time, B.) the first guest TD creation time.  A.) was chosen.
With B.), a user may hit an error of the TDX initialization when trying to
create the first guest TD.  The machine that fails to initialize the TDX
module can't boot any guest TD further.  Such failure is undesirable and a
surprise because the user expects that the machine can accommodate guest
TD, but not.  So A.) is better than B.).

Introduce a module parameter, kvm_intel.tdx, to explicitly enable TDX KVM
support.  It's off by default to keep the same behavior for those who don't
use TDX.  Implement hardware_setup method to detect TDX feature of CPU and
initialize TDX module.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 34 ++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 ++++
 4 files changed, 125 insertions(+), 2 deletions(-)
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
index deaba44c6bdf..8eb5b77d3043 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,36 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static int vt_hardware_enable(void)
+{
+	int ret;
+
+	ret = vmx_hardware_enable();
+	if (ret || !enable_tdx)
+		return ret;
+
+	ret = tdx_cpu_enable();
+	if (ret)
+		vmx_hardware_disable();
+	return ret;
+}
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -22,7 +52,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
+	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
@@ -158,7 +188,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..8a378fb6f1d4
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
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
+	return 0;
+}
+
+struct vmx_tdx_enabled {
+	cpumask_var_t vmx_enabled;
+	atomic_t err;
+};
+
+static void __init vmx_tdx_on(void *_vmx_tdx)
+{
+	struct vmx_tdx_enabled *vmx_tdx = _vmx_tdx;
+	int r;
+
+	r = vmx_hardware_enable();
+	if (!r) {
+		cpumask_set_cpu(smp_processor_id(), vmx_tdx->vmx_enabled);
+		r = tdx_cpu_enable();
+	}
+	if (r)
+		atomic_set(&vmx_tdx->err, r);
+}
+
+static void __init vmx_off(void *_vmx_enabled)
+{
+	cpumask_var_t *vmx_enabled = (cpumask_var_t *)_vmx_enabled;
+
+	if (cpumask_test_cpu(smp_processor_id(), *vmx_enabled))
+		vmx_hardware_disable();
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	struct vmx_tdx_enabled vmx_tdx = {
+		.err = ATOMIC_INIT(0),
+	};
+	int r = 0;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
+	cpus_read_lock();
+	on_each_cpu(vmx_tdx_on, &vmx_tdx, true);	/* TDX requires vmxon. */
+	r = atomic_read(&vmx_tdx.err);
+	if (!r)
+		r = tdx_module_setup();
+	else
+		r = -EIO;
+	on_each_cpu(vmx_off, &vmx_tdx.vmx_enabled, true);
+	cpus_read_unlock();
+	free_cpumask_var(vmx_tdx.vmx_enabled);
+
+out:
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 41ae943c62cb..ab1b50dcf178 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -20,6 +20,8 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -134,4 +136,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

