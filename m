Return-Path: <kvm+bounces-31925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F39B19CDBE5
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 10:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B41FE283900
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 09:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D01B1AD3E5;
	Fri, 15 Nov 2024 09:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJejmrH/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB6F1AAE23;
	Fri, 15 Nov 2024 09:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731664384; cv=none; b=g0iEKYMT/inTZ2MXauF1grSTKsprMKXNvGoovDnmIBIRRXhmc3h2uXohSLw+o5I+xI7S+GfU5QZ0FsB3vgJukS9lIEj5cYPSC7PgMQpOrnlqDsVeVhU0jtbb2ZL008dOSySo/VO7cwF/Ikdgb7iJtxYLkLC1KYeg6Z841blsrEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731664384; c=relaxed/simple;
	bh=YmQqDOSkcImzxsT5qCUaJ8u0PLOHlwKIEADX1Y1QQfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7sb+ibj0cWIMtgMIOeNYdube+38gxub0CyFn/Ze2r8KxQG5ayfqTCoZ2CwmqRhWCKNjnU1OyiUlfPjDuHGqVK840Imk2zWQN3uw4gWxOjI3DcLJD6WZcuIc8JuK+ur+VvgUABg7N/1TgHCLDAQViDYyDOCA2dNAY+L7Vzqha5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJejmrH/; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731664382; x=1763200382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YmQqDOSkcImzxsT5qCUaJ8u0PLOHlwKIEADX1Y1QQfQ=;
  b=HJejmrH/VnoV0UzFCvx0yQNKyOOcF6/+ksQ/pampkeUkTKWQ8mUku7ep
   UK2tiwt9rEeyXQ24GSIJVsAFSw0Yt6JuaZBLsdJZA77sWnHQEA9Fht4bJ
   /ry+nXODu85LKtp90ClxVUIrTg5zaYv9STgcoV70J8VWU1D0R5R4PIWVu
   im8NmieYFfjosu5/Xc/pEYDSPEIfQhe/+K0zrIHcaZ8FUpHv9+yqIxEx1
   q5kCp1HLS5H0TqUVLrYwNU8R/+hS09N7yaWS3NP8eeSBCN0jDP0JyG5QE
   QTy1kdxGYiZLYPu5O2texp3AGO138HhLtNCg+FhY+FsCxZAl+mID91h6e
   g==;
X-CSE-ConnectionGUID: LKn98QP+QSG/4t/7x20ihQ==
X-CSE-MsgGUID: 7Z5kf7QMSmy0iXc+l9Gw2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="31584847"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="31584847"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:53:02 -0800
X-CSE-ConnectionGUID: ZOJ4TKQ3RN+36xkktsY4bw==
X-CSE-MsgGUID: YIhJv9zgQ0GGQAOfWH4iiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="93584352"
Received: from kinlongk-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.135])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 01:52:59 -0800
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: VMX: Initialize TDX during KVM module load
Date: Fri, 15 Nov 2024 22:52:41 +1300
Message-ID: <162f9dee05c729203b9ad6688db1ca2960b4b502.1731664295.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731664295.git.kai.huang@intel.com>
References: <cover.1731664295.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before KVM can use TDX to create and run TDX guests, TDX needs to be
initialized from two perspectives: 1) TDX module must be initialized
properly to a working state; 2) A per-cpu TDX initialization, a.k.a the
TDH.SYS.LP.INIT SEAMCALL must be done on any logical cpu before it can
run any other TDX SEAMCALLs.

The TDX host core-kernel provides two functions to do the above two
respectively: tdx_enable() and tdx_cpu_enable().

There are two options in terms of when to initialize TDX: initialize TDX
at KVM module loading time, or when creating the first TDX guest.

Choose to initialize TDX during KVM module loading time:

Initializing TDX module is both memory and CPU time consuming: 1) the
kernel needs to allocate a non-trivial size(~1/256) of system memory
as metadata used by TDX module to track each TDX-usable memory page's
status; 2) the TDX module needs to initialize this metadata, one entry
for each TDX-usable memory page.

Also, the kernel uses alloc_contig_pages() to allocate those metadata
chunks, because they are large and need to be physically contiguous.
alloc_contig_pages() can fail.  If initializing TDX when creating the
first TDX guest, then there's chance that KVM won't be able to run any
TDX guests albeit KVM _declares_ to be able to support TDX.

This isn't good for the user.

On the other hand, initializing TDX at KVM module loading time can make
sure KVM is providing a consistent view of whether KVM can support TDX
to the user.

Always only try to initialize TDX after VMX has been initialized.  TDX
is based on VMX, and if VMX fails to initialize then TDX is likely to be
broken anyway.  Also, in practice, supporting TDX will require part of
VMX and common x86 infrastructure in working order, so TDX cannot be
enabled alone w/o VMX support.

There are two cases that can result in failure to initialize TDX: 1) TDX
cannot be supported (e.g., because of TDX is not supported or enabled by
hardware, or module is not loaded, or missing some dependency in KVM's
configuration); 2) Any unexpected error during TDX bring-up.  For the
first case only mark TDX is disabled but still allow KVM module to be
loaded.  For the second case just fail to load the KVM module so that
the user can be aware.

Because TDX costs additional memory, don't enable TDX by default.  Add a
new module parameter 'enable_tdx' to allow the user to opt-in.

Note, the name tdx_init() has already been taken by the early boot code.
Use tdx_bringup() for initializing TDX (and tdx_cleanup() since KVM
doesn't actually teardown TDX).  They don't match vt_init()/vt_exit(),
vmx_init()/vmx_exit() etc but it's not end of the world.

Also, once initialized, the TDX module cannot be disabled and enabled
again w/o the TDX module runtime update, which isn't supported by the
kernel.  After TDX is enabled, nothing needs to be done when KVM
disables hardware virtualization, e.g., when offlining CPU, or during
suspend/resume.  TDX host core-kernel code internally tracks TDX status
and can handle "multiple enabling" scenario.

Similar to KVM_AMD_SEV, add a new KVM_INTEL_TDX Kconfig to guide KVM TDX
code.  Make it depend on INTEL_TDX_HOST but not replace INTEL_TDX_HOST
because in the longer term there's a use case that requires making
SEAMCALLs w/o KVM as mentioned by Dan [1].

Link: https://lore.kernel.org/6723fc2070a96_60c3294dc@dwillia2-mobl3.amr.corp.intel.com.notmuch/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/Kconfig    |  10 +++
 arch/x86/kvm/Makefile   |   1 +
 arch/x86/kvm/vmx/main.c |   9 +++
 arch/x86/kvm/vmx/tdx.c  | 153 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h  |  13 ++++
 5 files changed, 186 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d93af5390341..e6da1b4ff3d2 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -128,6 +128,16 @@ config X86_SGX_KVM
 
 	  If unsure, say N.
 
+config KVM_INTEL_TDX
+	bool "Intel Trust Domain Extensions (TDX) support"
+	default y
+	depends on INTEL_TDX_HOST
+	help
+	  Provides support for launching Intel Trust Domain Extensions (TDX)
+	  confidential VMs on Intel processors.
+
+	  If unsure, say N.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index f9dddb8cb466..a5d362c7b504 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -20,6 +20,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
+kvm-intel-$(CONFIG_KVM_INTEL_TDX)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6772e560ac7b..bc690c63e511 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
+#include "tdx.h"
 
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
@@ -171,6 +172,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 static void vt_exit(void)
 {
 	kvm_exit();
+	tdx_cleanup();
 	vmx_exit();
 }
 module_exit(vt_exit);
@@ -183,6 +185,11 @@ static int __init vt_init(void)
 	if (r)
 		return r;
 
+	/* tdx_init() has been taken */
+	r = tdx_bringup();
+	if (r)
+		goto err_tdx_bringup;
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -195,6 +202,8 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
+	tdx_cleanup();
+err_tdx_bringup:
 	vmx_exit();
 	return r;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..d35112758641
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+#include <asm/cpufeature.h>
+#include <asm/tdx.h>
+#include "capabilities.h"
+#include "tdx.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static enum cpuhp_state tdx_cpuhp_state;
+
+static int tdx_online_cpu(unsigned int cpu)
+{
+	unsigned long flags;
+	int r;
+
+	/* Sanity check CPU is already in post-VMXON */
+	WARN_ON_ONCE(!(cr4_read_shadow() & X86_CR4_VMXE));
+
+	local_irq_save(flags);
+	r = tdx_cpu_enable();
+	local_irq_restore(flags);
+
+	return r;
+}
+
+static void __do_tdx_cleanup(void)
+{
+	/*
+	 * Once TDX module is initialized, it cannot be disabled and
+	 * re-initialized again w/o runtime update (which isn't
+	 * supported by kernel).  Only need to remove the cpuhp here.
+	 * The TDX host core code tracks TDX status and can handle
+	 * 'multiple enabling' scenario.
+	 */
+	WARN_ON_ONCE(!tdx_cpuhp_state);
+	cpuhp_remove_state_nocalls(tdx_cpuhp_state);
+	tdx_cpuhp_state = 0;
+}
+
+static int __init __do_tdx_bringup(void)
+{
+	int r;
+
+	/*
+	 * TDX-specific cpuhp callback to call tdx_cpu_enable() on all
+	 * online CPUs before calling tdx_enable(), and on any new
+	 * going-online CPU to make sure it is ready for TDX guest.
+	 */
+	r = cpuhp_setup_state_cpuslocked(CPUHP_AP_ONLINE_DYN,
+					 "kvm/cpu/tdx:online",
+					 tdx_online_cpu, NULL);
+	if (r < 0)
+		return r;
+
+	tdx_cpuhp_state = r;
+
+	r = tdx_enable();
+	if (r)
+		__do_tdx_cleanup();
+
+	return r;
+}
+
+static bool __init kvm_can_support_tdx(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM);
+}
+
+static int __init __tdx_bringup(void)
+{
+	int r;
+
+	/*
+	 * Enabling TDX requires enabling hardware virtualization first,
+	 * as making SEAMCALLs requires CPU being in post-VMXON state.
+	 */
+	r = kvm_enable_virtualization();
+	if (r)
+		return r;
+
+	cpus_read_lock();
+	r = __do_tdx_bringup();
+	cpus_read_unlock();
+
+	if (r)
+		goto tdx_bringup_err;
+
+	/*
+	 * Leave hardware virtualization enabled after TDX is enabled
+	 * successfully.  TDX CPU hotplug depends on this.
+	 */
+	return 0;
+tdx_bringup_err:
+	kvm_disable_virtualization();
+	return r;
+}
+
+void tdx_cleanup(void)
+{
+	if (enable_tdx) {
+		__do_tdx_cleanup();
+		kvm_disable_virtualization();
+	}
+}
+
+int __init tdx_bringup(void)
+{
+	int r;
+
+	enable_tdx = enable_tdx && kvm_can_support_tdx();
+
+	if (!enable_tdx)
+		return 0;
+
+	/*
+	 * Ideally KVM should probe whether TDX module has been loaded
+	 * first and then try to bring it up, because KVM should treat
+	 * them differently.  I.e., KVM should just disable TDX while
+	 * still allow module to be loaded when TDX module is not
+	 * loaded, but fail to load module when it actually fails to
+	 * bring up TDX.
+	 *
+	 * But unfortunately TDX needs to use SEAMCALL to probe whether
+	 * the module is loaded (there is no CPUID or MSR for that),
+	 * and making SEAMCALL requires enabling virtualization first,
+	 * just like the rest steps of bringing up TDX module.
+	 *
+	 * The first SEAMCALL to bring up TDX module returns -ENODEV
+	 * when the module is not loaded.  For simplicity just try to
+	 * bring up TDX and use the return code as the way to probe,
+	 * albeit this is not perfect, i.e., need to make sure
+	 * __tdx_bringup() doesn't return -ENODEV in other cases.
+	 */
+	r = __tdx_bringup();
+	if (r) {
+		enable_tdx = 0;
+		/*
+		 * Disable TDX only but don't fail to load module when
+		 * TDX module is not loaded.  No need to print message
+		 * saying "module is not loaded" because it was printed
+		 * when the first SEAMCALL failed.
+		 */
+		if (r == -ENODEV)
+			r = 0;
+	}
+
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..8aee938a968f
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_TDX_H
+#define __KVM_X86_VMX_TDX_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+int tdx_bringup(void);
+void tdx_cleanup(void);
+#else
+static inline int tdx_bringup(void) { return 0; }
+static inline void tdx_cleanup(void) {}
+#endif
+
+#endif
-- 
2.46.2


