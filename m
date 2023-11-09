Return-Path: <kvm+bounces-1326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2887E6A05
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A5AAB2141F
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E971DDCF;
	Thu,  9 Nov 2023 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hK/k4p0v"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BAA1DDC3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE1130DC;
	Thu,  9 Nov 2023 03:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531020; x=1731067020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rFyFgkPvmsh8ltzVL+i3w5NdUV/5bxYgmU15lvsiNn4=;
  b=hK/k4p0vuU9ZWu+hYRyTodZKOcj6oNmkJHBh8GiRxuZkJ7xQAgFOEOdM
   oiDNRXaaL6s41sd4SIaxwwpZPLpYCozqIAYAeMBAEoS0XesrdeCC7qi/0
   90yApxiIDRyIlX1f2clKbz7VkifL8qQSO8/jnfggLrmKQ+/ABt/dfkQp6
   04YP6894C0Nn273VFhbI9puMnLaBxP/zTj1tvx2AEuI/CCXFWLc90VL3k
   N1ZbqGw42/GeOp33eOV/XpLBABKlvSIT9rlWaV59thdv8Up/kPlV0kHFv
   JDk3WT2WcGzoteqwZyqnVTgvG9G0j7/GL0oX2uJw8Gd7yNyEvQIcbXdT+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936428"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936428"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976696"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976696"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:56:53 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 07/23] x86/virt/tdx: Add skeleton to enable TDX on demand
Date: Fri, 10 Nov 2023 00:55:44 +1300
Message-ID: <2fa98b5d532b36182b76a59a4d18eabea3d53b06.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To enable TDX the kernel needs to initialize TDX from two perspectives:
1) Do a set of SEAMCALLs to initialize the TDX module to make it ready
to create and run TDX guests; 2) Do the per-cpu initialization SEAMCALL
on one logical cpu before the kernel wants to make any other SEAMCALLs
on that cpu (including those involved during module initialization and
running TDX guests).

The TDX module can be initialized only once in its lifetime.  Instead
of always initializing it at boot time, this implementation chooses an
"on demand" approach to initialize TDX until there is a real need (e.g
when requested by KVM).  This approach has below pros:

1) It avoids consuming the memory that must be allocated by kernel and
given to the TDX module as metadata (~1/256th of the TDX-usable memory),
and also saves the CPU cycles of initializing the TDX module (and the
metadata) when TDX is not used at all.

2) The TDX module design allows it to be updated while the system is
running.  The update procedure shares quite a few steps with this "on
demand" initialization mechanism.  The hope is that much of "on demand"
mechanism can be shared with a future "update" mechanism.  A boot-time
TDX module implementation would not be able to share much code with the
update mechanism.

3) Making SEAMCALL requires VMX to be enabled.  Currently, only the KVM
code mucks with VMX enabling.  If the TDX module were to be initialized
separately from KVM (like at boot), the boot code would need to be
taught how to muck with VMX enabling and KVM would need to be taught how
to cope with that.  Making KVM itself responsible for TDX initialization
lets the rest of the kernel stay blissfully unaware of VMX.

Similar to module initialization, also make the per-cpu initialization
"on demand" as it also depends on VMX being enabled.

Add two functions, tdx_enable() and tdx_cpu_enable(), to enable the TDX
module and enable TDX on local cpu respectively.  For now tdx_enable()
is a placeholder.  The TODO list will be pared down as functionality is
added.

Export both tdx_cpu_enable() and tdx_enable() for KVM use.

In tdx_enable() use a state machine protected by mutex to make sure the
initialization will only be done once, as tdx_enable() can be called
multiple times (i.e. KVM module can be reloaded) and may be called
concurrently by other kernel components in the future.

The per-cpu initialization on each cpu can only be done once during the
module's life time.  Use a per-cpu variable to track its status to make
sure it is only done once in tdx_cpu_enable().

Also, a SEAMCALL to do TDX module global initialization must be done
once on any logical cpu before any per-cpu initialization SEAMCALL.  Do
it inside tdx_cpu_enable() too (if hasn't been done).

tdx_enable() can potentially invoke SEAMCALLs on any online cpus.  The
per-cpu initialization must be done before those SEAMCALLs are invoked
on some cpu.  To keep things simple, in tdx_cpu_enable(), always do the
per-cpu initialization regardless of whether the TDX module has been
initialized or not.  And in tdx_enable(), don't call tdx_cpu_enable()
but assume the caller has disabled CPU hotplug, done VMXON and
tdx_cpu_enable() on all online cpus before calling tdx_enable().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---

v14 -> v15:
 - Added Nikolay's tag.

v13 -> v14:
 - Use lockdep_assert_irqs_off() in try_init_model_global() (Nikolay),
   but still keep the comment (Kirill).
 - Add code to print "module not loaded" in the first SEAMCALL.
 - If SYS.INIT fails, stop calling LP.INIT in other tdx_cpu_enable()s.
 - Added Kirill's tag

v12 -> v13:
 - Made tdx_cpu_enable() always be called with IRQ disabled via IPI
   funciton call (Peter, Kirill).

v11 -> v12:
 - Simplified TDX module global init and lp init status tracking (David).
 - Added comment around try_init_module_global() for using
   raw_spin_lock() (Dave).
 - Added one sentence to changelog to explain why to expose tdx_enable()
   and tdx_cpu_enable() (Dave).
 - Simplifed comments around tdx_enable() and tdx_cpu_enable() to use
   lockdep_assert_*() instead. (Dave)
 - Removed redundent "TDX" in error message (Dave).

v10 -> v11:
 - Return -NODEV instead of -EINVAL when CONFIG_INTEL_TDX_HOST is off.
 - Return the actual error code for tdx_enable() instead of -EINVAL.
 - Added Isaku's Reviewed-by.

v9 -> v10:
 - Merged the patch to handle per-cpu initialization to this patch to
   tell the story better.
 - Changed how to handle the per-cpu initialization to only provide a
   tdx_cpu_enable() function to let the user of TDX to do it when the
   user wants to run TDX code on a certain cpu.
 - Changed tdx_enable() to not call cpus_read_lock() explicitly, but
   call lockdep_assert_cpus_held() to assume the caller has done that.
 - Improved comments around tdx_enable() and tdx_cpu_enable().
 - Improved changelog to tell the story better accordingly.

v8 -> v9:
 - Removed detailed TODO list in the changelog (Dave).
 - Added back steps to do module global initialization and per-cpu
   initialization in the TODO list comment.
 - Moved the 'enum tdx_module_status_t' from tdx.c to local tdx.h

v7 -> v8:
 - Refined changelog (Dave).
 - Removed "all BIOS-enabled cpus" related code (Peter/Thomas/Dave).
 - Add a "TODO list" comment in init_tdx_module() to list all steps of
   initializing the TDX Module to tell the story (Dave).
 - Made tdx_enable() unverisally return -EINVAL, and removed nonsense
   comments (Dave).
 - Simplified __tdx_enable() to only handle success or failure.
 - TDX_MODULE_SHUTDOWN -> TDX_MODULE_ERROR
 - Removed TDX_MODULE_NONE (not loaded) as it is not necessary.
 - Improved comments (Dave).
 - Pointed out 'tdx_module_status' is software thing (Dave).

 ...


---
 arch/x86/include/asm/tdx.h  |   4 +
 arch/x86/virt/vmx/tdx/tdx.c | 167 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  30 +++++++
 3 files changed, 201 insertions(+)
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9c35cd4ae0dc..26b7fdbcbdb3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -112,8 +112,12 @@ static inline u64 sc_retry(sc_func_t func, u64 fn,
 #define seamcall_saved_ret(_fn, _args)	sc_retry(__seamcall_saved_ret, (_fn), (_args))
 
 bool platform_tdx_enabled(void);
+int tdx_cpu_enable(void);
+int tdx_enable(void);
 #else
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_cpu_enable(void) { return -ENODEV; }
+static inline int tdx_enable(void)  { return -ENODEV; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 12e519c5c45c..e7739e15d47a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -12,14 +12,24 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/printk.h>
+#include <linux/cpu.h>
+#include <linux/spinlock.h>
+#include <linux/percpu-defs.h>
+#include <linux/mutex.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
+#include "tdx.h"
 
 static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
+static DEFINE_PER_CPU(bool, tdx_lp_initialized);
+
+static enum tdx_module_status_t tdx_module_status;
+static DEFINE_MUTEX(tdx_module_lock);
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -63,6 +73,163 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
 #define seamcall_prerr_ret(__fn, __args)					\
 	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
 
+/*
+ * Do the module global initialization once and return its result.
+ * It can be done on any cpu.  It's always called with interrupts
+ * disabled.
+ */
+static int try_init_module_global(void)
+{
+	struct tdx_module_args args = {};
+	static DEFINE_RAW_SPINLOCK(sysinit_lock);
+	static bool sysinit_done;
+	static int sysinit_ret;
+
+	lockdep_assert_irqs_disabled();
+
+	raw_spin_lock(&sysinit_lock);
+
+	if (sysinit_done)
+		goto out;
+
+	/* RCX is module attributes and all bits are reserved */
+	args.rcx = 0;
+	sysinit_ret = seamcall_prerr(TDH_SYS_INIT, &args);
+
+	/*
+	 * The first SEAMCALL also detects the TDX module, thus
+	 * it can fail due to the TDX module is not loaded.
+	 * Dump message to let the user know.
+	 */
+	if (sysinit_ret == -ENODEV)
+		pr_err("module not loaded\n");
+
+	sysinit_done = true;
+out:
+	raw_spin_unlock(&sysinit_lock);
+	return sysinit_ret;
+}
+
+/**
+ * tdx_cpu_enable - Enable TDX on local cpu
+ *
+ * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
+ * global initialization SEAMCALL if not done) on local cpu to make this
+ * cpu be ready to run any other SEAMCALLs.
+ *
+ * Always call this function via IPI function calls.
+ *
+ * Return 0 on success, otherwise errors.
+ */
+int tdx_cpu_enable(void)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	if (!platform_tdx_enabled())
+		return -ENODEV;
+
+	lockdep_assert_irqs_disabled();
+
+	if (__this_cpu_read(tdx_lp_initialized))
+		return 0;
+
+	/*
+	 * The TDX module global initialization is the very first step
+	 * to enable TDX.  Need to do it first (if hasn't been done)
+	 * before the per-cpu initialization.
+	 */
+	ret = try_init_module_global();
+	if (ret)
+		return ret;
+
+	ret = seamcall_prerr(TDH_SYS_LP_INIT, &args);
+	if (ret)
+		return ret;
+
+	__this_cpu_write(tdx_lp_initialized, true);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_enable);
+
+static int init_tdx_module(void)
+{
+	/*
+	 * TODO:
+	 *
+	 *  - Build the list of TDX-usable memory regions.
+	 *  - Get TDX module "TD Memory Region" (TDMR) global metadata.
+	 *  - Construct a list of TDMRs to cover all TDX-usable memory
+	 *    regions.
+	 *  - Configure the TDMRs and the global KeyID to the TDX module.
+	 *  - Configure the global KeyID on all packages.
+	 *  - Initialize all TDMRs.
+	 *
+	 *  Return error before all steps are done.
+	 */
+	return -EINVAL;
+}
+
+static int __tdx_enable(void)
+{
+	int ret;
+
+	ret = init_tdx_module();
+	if (ret) {
+		pr_err("module initialization failed (%d)\n", ret);
+		tdx_module_status = TDX_MODULE_ERROR;
+		return ret;
+	}
+
+	pr_info("module initialized\n");
+	tdx_module_status = TDX_MODULE_INITIALIZED;
+
+	return 0;
+}
+
+/**
+ * tdx_enable - Enable TDX module to make it ready to run TDX guests
+ *
+ * This function assumes the caller has: 1) held read lock of CPU hotplug
+ * lock to prevent any new cpu from becoming online; 2) done both VMXON
+ * and tdx_cpu_enable() on all online cpus.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return 0 if TDX is enabled successfully, otherwise error.
+ */
+int tdx_enable(void)
+{
+	int ret;
+
+	if (!platform_tdx_enabled())
+		return -ENODEV;
+
+	lockdep_assert_cpus_held();
+
+	mutex_lock(&tdx_module_lock);
+
+	switch (tdx_module_status) {
+	case TDX_MODULE_UNINITIALIZED:
+		ret = __tdx_enable();
+		break;
+	case TDX_MODULE_INITIALIZED:
+		/* Already initialized, great, tell the caller. */
+		ret = 0;
+		break;
+	default:
+		/* Failed to initialize in the previous attempts */
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&tdx_module_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_enable);
+
 static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 					    u32 *nr_tdx_keyids)
 {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
new file mode 100644
index 000000000000..a3c52270df5b
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_VIRT_TDX_H
+#define _X86_VIRT_TDX_H
+
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
+
+/*
+ * Do not put any hardware-defined TDX structure representations below
+ * this comment!
+ */
+
+/* Kernel defined TDX module status during module initialization. */
+enum tdx_module_status_t {
+	TDX_MODULE_UNINITIALIZED,
+	TDX_MODULE_INITIALIZED,
+	TDX_MODULE_ERROR
+};
+
+#endif
-- 
2.41.0


