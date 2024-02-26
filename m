Return-Path: <kvm+bounces-9647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B38866C6E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:35:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 027DBB230F4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E88E56463;
	Mon, 26 Feb 2024 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hzyl8gCv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3964B54760;
	Mon, 26 Feb 2024 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936075; cv=none; b=rtvOsN3eoTcekuJ/cUckUc5zV+756TVq0yeCU7neXjnCBFSxjxAuBrWlbl/LtgfiZuvn6RQmzmJeZ2FvkxNr5OvE88pgxoSOuSTbSIfV/DD7fzQqR9dGwbXLlaMBPAbLiU02eNRb3mGX7E+apiKufl8f8a78GhzRfRfPS+y9X9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936075; c=relaxed/simple;
	bh=O0sWvFfgIW927Ww+UNgjiWxMLfLIE4xsplwGoeS5rss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hKJhWlO4IKMzH57omB8vVQvUU9VBR3dn0diouN6pdl7qB2laNMoxg3UJPkT2TYwu7ydf3l0wCPpykVIVR3wbU/fOR198dIF2DZt6+KggiXewxc7E9MKwNjgBU7m5/K0PLWPQFOZ61M4c349w3xrLuYRrbUXYR0FPb6WqcrloMiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hzyl8gCv; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936072; x=1740472072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O0sWvFfgIW927Ww+UNgjiWxMLfLIE4xsplwGoeS5rss=;
  b=Hzyl8gCvpIY4cxae7ng9qWu2z4RQLUI/4umtGR/m2G7cZMId8OW4osC0
   ff4VXcRb20wSJSAz+9r6TWiZNNheRyaaG3MsPSxlsjx9wK4zXhEYRVXy3
   5qp9f4jZwwW88QQOR02wEqvTD2AxJq+NIxlC4BqJnCVBW4a9BNlnPMydB
   RhSwB5PmFQ+sNHE6/DpNDridg1Hz7iZPkVNQ6xJwCyXEX5BRN/hiXO4v8
   Ozbb8Sx101C642iE5Pq24q+gWxDsHeGkhT4XVn++qVaQ5GLmqZvSehqT9
   l63Vre1W9MXNhQq8TjN3SvHfUFiazMLdrEl6az6L1uYAder1LsGcupEEX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155236"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155236"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615437"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:51 -0800
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
Subject: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
Date: Mon, 26 Feb 2024 00:25:25 -0800
Message-Id: <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
v19:
- fixed vt_hardware_enable() to use vmx_hardware_enable()
- renamed vmx_tdx_enabled => tdx_enabled
- renamed vmx_tdx_on() => tdx_on()

v18:
- Added comment in vt_hardware_enable() by Binbin.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 19 ++++++++-
 arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 +++
 4 files changed, 109 insertions(+), 1 deletion(-)
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
index 18cecf12c7c8..18aef6e23aab 100644
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
+	/* TDX cpu enablement is done by tdx_hardware_setup(). */
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
@@ -161,7 +178,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..43c504fb4fed
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
+struct tdx_enabled {
+	cpumask_var_t enabled;
+	atomic_t err;
+};
+
+static void __init tdx_on(void *_enable)
+{
+	struct tdx_enabled *enable = _enable;
+	int r;
+
+	r = vmx_hardware_enable();
+	if (!r) {
+		cpumask_set_cpu(smp_processor_id(), enable->enabled);
+		r = tdx_cpu_enable();
+	}
+	if (r)
+		atomic_set(&enable->err, r);
+}
+
+static void __init vmx_off(void *_enabled)
+{
+	cpumask_var_t *enabled = (cpumask_var_t *)_enabled;
+
+	if (cpumask_test_cpu(smp_processor_id(), *enabled))
+		vmx_hardware_disable();
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	struct tdx_enabled enable = {
+		.err = ATOMIC_INIT(0),
+	};
+	int r = 0;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!zalloc_cpumask_var(&enable.enabled, GFP_KERNEL)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
+	cpus_read_lock();
+	on_each_cpu(tdx_on, &enable, true); /* TDX requires vmxon. */
+	r = atomic_read(&enable.err);
+	if (!r)
+		r = tdx_module_setup();
+	else
+		r = -EIO;
+	on_each_cpu(vmx_off, &enable.enabled, true);
+	cpus_read_unlock();
+	free_cpumask_var(enable.enabled);
+
+out:
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b936388853ab..346289a2a01c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -135,4 +135,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
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


