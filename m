Return-Path: <kvm+bounces-6582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8634837995
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7688128F33B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1DB5102F;
	Mon, 22 Jan 2024 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mnj/zLJx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CFD4F897;
	Mon, 22 Jan 2024 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967699; cv=none; b=pR2hJFoSA50l9yFeHa8ihMMm5LrzIF3efnX6JFbIMP3XARoeW0ElOe6JB+qh1aAh6D2XCug74NArWZQbL9lYL/XmhmVYUSwZtixzfsnbXN/qglxB3YqzCWPv2kxv8S8n9tmMg8d8iEVE0VucctLvdguhHz3XSsn8uOijiu4u8uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967699; c=relaxed/simple;
	bh=E0vdis4b+ufttVkH77KTfBZATmw5lvhWlGxIIMKiLdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kIHCf/3jMN8WjqZJzNMqprTT7vqyPbYLubhsjvdFVTyRzbopK8+vr+4mo7CyaMnO6ZGdCYUyQ45QimGIZKB5aMEVi43vMiT4W5DeQkabx35dTC2duu87kqFSloYCMCKemDK4OMuHJfilGQpShZzbLfN2LEyMnq6QCpHbNGEF624=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mnj/zLJx; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967697; x=1737503697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E0vdis4b+ufttVkH77KTfBZATmw5lvhWlGxIIMKiLdA=;
  b=Mnj/zLJxxX0eKLLXFuDyDzHsh6SRno1wdXTD3ugDm7YlnhSOLLiLnFNa
   lvv9BChwGQHpJ5bJyOxjIZBMc8Bw8v0hhzXUaZrEgslanU32WV12kwkBh
   KzPNyjtydLtkEkcA6XaKDX5x9cafhcoyqr3T0UigY7Y33CVtreTKUjW3D
   HLZqsur/ERdFPVfSYBPC5AVZV1/8035mxpRHyKr4537gcVMwOhQHRFvd0
   R0cd5ZBhslMG8eNWFRIRaWaJgJtcbSBX8M98AS0PjNchXejme6jYkfWu+
   o7+fzGPfqytaK47Tqm3iQADLQDliOu9j92jAhUcdqTQMOYjmWA/p/HLhi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217833"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217833"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350135"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:56 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 008/121] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date: Mon, 22 Jan 2024 15:52:44 -0800
Message-Id: <9804cc9409d6773115e70bbb3bdc4adb67234cd6.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
v18:
- Added comment in vt_hardware_enable() by Binbin.
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 38 ++++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 ++++
 4 files changed, 129 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 274df24b647f..5b85ef84b2e9 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,6 +24,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 443db8ec5cd5..1e1feaacac59 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,40 @@
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
+		/*
+		 * In error case, we keep the CPU offline in error case.  So
+		 * need to revert VMXON.
+		 */
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
@@ -22,7 +56,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
+	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
@@ -161,7 +195,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index bca2d27b3dfd..b44cb681f74d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -18,6 +18,8 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -133,4 +135,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
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


