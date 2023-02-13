Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C05694514
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjBMMCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbjBMMBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:01:52 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76DF1A645;
        Mon, 13 Feb 2023 04:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289677; x=1707825677;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eUYI2f/G5Hw2W0lMnLcgpoR4LJWm2nSFqPt6Km379wQ=;
  b=Q9/Xk4/iKClrDXbIEf5nuujNzlgKLq6l4Ma0dRZHn2e2iBACSCaRAmkk
   ui/xua6/6czJO+9sGlpCEwv5HlNSV/+1zl74gi5PyutaXTCT53T0oVVoz
   cRnnd9dmnBYFDIJ0MynNtiBfej5Y//94/9NzbXPv3qVPxNz2+wVz4vFz9
   Cg2+6rdvlwhQty7L8sc4xH7x8V6JrAtlJE2jP6fWqgHDLyZucnJIrgjI3
   NqBYq5j9EAjnuQsLzv2BMYBE66AfT/1o+tg6tMwcPYzODEU2mV1EdBeEV
   z/dXznmIvhRe0uh1h4On8zL7bhEdWgn3Y5SfjBNDV2Acxu589dKxM7QRX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283258"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283258"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243252"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243252"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:44 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu initialization
Date:   Tue, 14 Feb 2023 00:59:14 +1300
Message-Id: <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
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

After the SEAMCALL to do TDX module global initialization, a SEAMCALL to
do per-cpu initialization (TDH.SYS.LP.INIT) must be done on one logical
cpu before any other SEAMCALLs can be made on that cpu, including those
involved in the future steps of the module initialization.

To keep things simple, this implementation just chooses to guarantee all
online cpus are "TDX-runnable" (TDH.SYS.LP.INIT has been successfully
done on them).  If the kernel were to allow one cpu to be online while
TDH.SYS.LP.INIT failed on it, the kernel would need to track a cpumask
of "TDX-runnable" cpus, know which task is "TDX workload" and guarantee
such task can only be scheduled to "TDX-runnable" cpus.  For example,
the kernel would need to reject in sched_setaffinity() if the userspace
tries to bind TDX task to any "non-TDX-runnable" cpu.

To guarantee all online cpus are "TDX-runnable", disable the CPU hotplug
during module initialization and do TDH.SYS.LP.INIT for all online cpus
before any further steps of module initialization.  In CPU hotplug, do
TDH.SYS.LP.INIT when TDX has been enabled in the CPU online callback and
reject to online the cpu if the SEAMCALL fails.

Currently only KVM handles VMXON.  Similar to tdx_enable(), only provide
a new helper tdx_cpu_online() but make KVM itself responsible for doing
VMXON and calling tdx_cpu_online() in its own CPU online callback.

Note tdx_enable() can be called multiple times by KVM because KVM module
can be unloaded and reloaded.  New cpus may become online while KVM is
unloaded, and in this case TDH.SYS.LP.INIT won't be called for those new
online cpus because KVM's CPU online callback is removed when KVM is
unloaded.  To make sure all online cpus are "TDX-runnable", always do
the per-cpu initialization for all online cpus in tdx_enable() even the
module has been initialized.

Similar to the per-cpu module initialization, a later step to config the
key for the global KeyID needs to call some SEAMCALL on one cpu for each
CPU package.  The difference is that SEAMCALL cannot run in parallel on
different cpus but TDH.SYS.LP.INIT can.  To avoid duplicated code, add a
helper to call SEAMCALL on all online cpus one by one but with a skip
function to check whether to skip certain cpus, and use that helper to
do the per-cpu initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v8 -> v9:
 - Added this patch back.
 - Handled the relaxed new behaviour of TDH.SYS.LP.INIT

---
 arch/x86/include/asm/tdx.h  |   2 +
 arch/x86/virt/vmx/tdx/tdx.c | 210 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |   1 +
 3 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 5c5ecfddb15b..2b2efaa4bc0e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -107,9 +107,11 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
 int tdx_enable(void);
+int tdx_cpu_online(unsigned int cpu);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_enable(void)  { return -EINVAL; }
+static inline int tdx_cpu_online(unsigned int cpu) { return 0; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 79cee28c51b5..23b2db28726f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,8 @@
 #include <linux/errno.h>
 #include <linux/printk.h>
 #include <linux/mutex.h>
+#include <linux/cpumask.h>
+#include <linux/cpu.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
@@ -26,6 +28,10 @@ static enum tdx_module_status_t tdx_module_status;
 /* Prevent concurrent attempts on TDX module initialization */
 static DEFINE_MUTEX(tdx_module_lock);
 
+/* TDX-runnable cpus.  Protected by cpu_hotplug_lock. */
+static cpumask_t __cpu_tdx_mask;
+static cpumask_t *cpu_tdx_mask = &__cpu_tdx_mask;
+
 /*
  * Use tdx_global_keyid to indicate that TDX is uninitialized.
  * This is used in TDX initialization error paths to take it from
@@ -170,6 +176,63 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	return ret;
 }
 
+/*
+ * Call @func on all online cpus one by one but skip those cpus
+ * when @skip_func is valid and returns true for them.
+ */
+static int tdx_on_each_cpu_cond(int (*func)(void *), void *func_data,
+				bool (*skip_func)(int cpu, void *),
+				void *skip_data)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		int ret;
+
+		if (skip_func && skip_func(cpu, skip_data))
+			continue;
+
+		/*
+		 * SEAMCALL can be time consuming.  Call the @func on
+		 * remote cpu via smp_call_on_cpu() instead of
+		 * smp_call_function_single() to avoid busy waiting.
+		 */
+		ret = smp_call_on_cpu(cpu, func, func_data, true);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int seamcall_lp_init(void)
+{
+	/* All '0's are just unused parameters */
+	return seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
+}
+
+static int smp_func_module_lp_init(void *data)
+{
+	int ret, cpu = smp_processor_id();
+
+	ret = seamcall_lp_init();
+	if (!ret)
+		cpumask_set_cpu(cpu, cpu_tdx_mask);
+
+	return ret;
+}
+
+static bool skip_func_module_lp_init_done(int cpu, void *data)
+{
+	return cpumask_test_cpu(cpu, cpu_tdx_mask);
+}
+
+static int module_lp_init_online_cpus(void)
+{
+	return tdx_on_each_cpu_cond(smp_func_module_lp_init, NULL,
+			skip_func_module_lp_init_done, NULL);
+}
+
 static int init_tdx_module(void)
 {
 	int ret;
@@ -182,10 +245,26 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	/*
+	 * TDX module per-cpu initialization SEAMCALL must be done on
+	 * one cpu before any other SEAMCALLs can be made on that cpu,
+	 * including those involved in further steps to initialize the
+	 * TDX module.
+	 *
+	 * To make sure further SEAMCALLs can be done successfully w/o
+	 * having to consider preemption, disable CPU hotplug during
+	 * rest of module initialization and do per-cpu initialization
+	 * for all online cpus.
+	 */
+	cpus_read_lock();
+
+	ret = module_lp_init_online_cpus();
+	if (ret)
+		goto out;
+
 	/*
 	 * TODO:
 	 *
-	 *  - TDX module per-cpu initialization.
 	 *  - Get TDX module information and TDX-capable memory regions.
 	 *  - Build the list of TDX-usable memory regions.
 	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
@@ -196,7 +275,17 @@ static int init_tdx_module(void)
 	 *
 	 *  Return error before all steps are done.
 	 */
-	return -EINVAL;
+	ret = -EINVAL;
+out:
+	/*
+	 * Clear @cpu_tdx_mask if module initialization fails before
+	 * CPU hotplug is re-enabled.  tdx_cpu_online() uses it to check
+	 * whether the initialization has been successful or not.
+	 */
+	if (ret)
+		cpumask_clear(cpu_tdx_mask);
+	cpus_read_unlock();
+	return ret;
 }
 
 static int __tdx_enable(void)
@@ -220,13 +309,72 @@ static int __tdx_enable(void)
 	return 0;
 }
 
+/*
+ * Disable TDX module after it has been initialized successfully.
+ */
+static void disable_tdx_module(void)
+{
+	/*
+	 * TODO: module clean up in reverse to steps in
+	 * init_tdx_module().  Remove this comment after
+	 * all steps are done.
+	 */
+	cpumask_clear(cpu_tdx_mask);
+}
+
+static int tdx_module_init_online_cpus(void)
+{
+	int ret;
+
+	/*
+	 * Make sure no cpu can become online to prevent
+	 * race against tdx_cpu_online().
+	 */
+	cpus_read_lock();
+
+	/*
+	 * Do per-cpu initialization for any new online cpus.
+	 * If any fails, disable TDX.
+	 */
+	ret = module_lp_init_online_cpus();
+	if (ret)
+		disable_tdx_module();
+
+	cpus_read_unlock();
+
+	return ret;
+
+}
+static int __tdx_enable_online_cpus(void)
+{
+	if (tdx_module_init_online_cpus()) {
+		/*
+		 * SEAMCALL failure has already printed
+		 * meaningful error message.
+		 */
+		tdx_module_status = TDX_MODULE_ERROR;
+
+		/*
+		 * Just return one universal error code.
+		 * For now the caller cannot recover anyway.
+		 */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * tdx_enable - Enable TDX to be ready to run TDX guests
  *
  * Initialize the TDX module to enable TDX.  After this function, the TDX
- * module is ready to create and run TDX guests.
+ * module is ready to create and run TDX guests on all online cpus.
+ *
+ * This function internally calls cpus_read_lock()/unlock() to prevent
+ * any cpu from going online and offline.
  *
  * This function assumes all online cpus are already in VMX operation.
+ *
  * This function can be called in parallel by multiple callers.
  *
  * Return 0 if TDX is enabled successfully, otherwise error.
@@ -247,8 +395,17 @@ int tdx_enable(void)
 		ret = __tdx_enable();
 		break;
 	case TDX_MODULE_INITIALIZED:
-		/* Already initialized, great, tell the caller. */
-		ret = 0;
+		/*
+		 * The previous call of __tdx_enable() may only have
+		 * initialized part of present cpus during module
+		 * initialization, and new cpus may have become online
+		 * since then.
+		 *
+		 * To make sure all online cpus are TDX-runnable, always
+		 * do per-cpu initialization for all online cpus here
+		 * even the module has been initialized.
+		 */
+		ret = __tdx_enable_online_cpus();
 		break;
 	default:
 		/* Failed to initialize in the previous attempts */
@@ -261,3 +418,46 @@ int tdx_enable(void)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdx_enable);
+
+/**
+ * tdx_cpu_online - Enable TDX on a hotplugged local cpu
+ *
+ * @cpu: the cpu to be brought up.
+ *
+ * Do TDX module per-cpu initialization for a hotplugged cpu to make
+ * it TDX-runnable.  All online cpus are initialized during module
+ * initialization.
+ *
+ * This function must be called from CPU hotplug callback which holds
+ * write lock of cpu_hotplug_lock.
+ *
+ * This function assumes local cpu is already in VMX operation.
+ */
+int tdx_cpu_online(unsigned int cpu)
+{
+	int ret;
+
+	/*
+	 * @cpu_tdx_mask is updated in tdx_enable() and is protected
+	 * by cpus_read_lock()/unlock().  If it is empty, TDX module
+	 * either hasn't been initialized, or TDX didn't get enabled
+	 * successfully.
+	 *
+	 * In either case, do nothing but return success.
+	 */
+	if (cpumask_empty(cpu_tdx_mask))
+		return 0;
+
+	WARN_ON_ONCE(cpu != smp_processor_id());
+
+	/* Already done */
+	if (cpumask_test_cpu(cpu, cpu_tdx_mask))
+		return 0;
+
+	ret = seamcall_lp_init();
+	if (!ret)
+		cpumask_set_cpu(cpu, cpu_tdx_mask);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_online);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 55472e085bc8..30413d7fbee8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
   * TDX module SEAMCALL leaf functions
   */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
 
 /* Kernel defined TDX module status during module initialization. */
 enum tdx_module_status_t {
-- 
2.39.1

