Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222D26AC2EE
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCFOSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCFOSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:18:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443130E9E;
        Mon,  6 Mar 2023 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112249; x=1709648249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WsDUIOtagxcjdB7YYb5/nPYU+cZHxidSVv9+ymwBYjg=;
  b=M2Y2jz/vR2kibehlhbl6JCELE5PJLDFnf7khoH2thyZyaA5sL4XZss+v
   jTQiEluFybZ/E4e2qJWZbwSfmBmbgZO8LFCEK28kJ8P9qxHfUUdfwPHer
   03ADBRvG8BG3y8QGp64njBYhj0+D1Z6HYaomWQp89S4JQxinZT44ZIzKl
   oMd4AwvJwrVSZfhh04Vl5vk1uqpabGLNLj+dJ7TKrgbN1tAmhxdWcYbJA
   UO/J+QWoS3mFdrj/baTr2p8+LEGqJ+ndhvEsw4D5DR28NMpQnK/1z9qBH
   c/IizftftqwYGJKZNgH7N+DQVEAckeYBrr4XU2/U6ehJJY85afNQO+rIB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080094"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080094"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232104"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232104"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:51 -0800
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
Subject: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on demand
Date:   Tue,  7 Mar 2023 03:13:50 +1300
Message-Id: <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
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
"on demand" as it also depends on VMX to be enabled.

Add two functions, tdx_enable() and tdx_cpu_enable(), to enable the TDX
module and enable TDX on local cpu respectively.  For now tdx_enable()
is a placeholder.  The TODO list will be pared down as functionality is
added.

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
but assume the caller has disabled CPU hotplug and done VMXON and
tdx_cpu_enable() on all online cpus before calling tdx_enable().

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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

v6 -> v7:
 - No change.

v5 -> v6:
 - Added code to set status to TDX_MODULE_NONE if TDX module is not
   loaded (Chao)
 - Added Chao's Reviewed-by.
 - Improved comments around cpus_read_lock().

- v3->v5 (no feedback on v4):
 - Removed the check that SEAMRR and TDX KeyID have been detected on
   all present cpus.
 - Removed tdx_detect().
 - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
   hotplug lock and return early with error message.
 - Improved dmesg printing for TDX module detection and initialization.

---
 arch/x86/include/asm/tdx.h  |   4 +
 arch/x86/virt/vmx/tdx/tdx.c | 182 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  25 +++++
 3 files changed, 211 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b489b5b9de5d..112a5b9bd5cd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,8 +102,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
+int tdx_cpu_enable(void);
+int tdx_enable(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_cpu_enable(void) { return -EINVAL; }
+static inline int tdx_enable(void)  { return -EINVAL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b65b838f3b5d..29127cb70f51 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,10 @@
 #include <linux/errno.h>
 #include <linux/printk.h>
 #include <linux/smp.h>
+#include <linux/cpu.h>
+#include <linux/spinlock.h>
+#include <linux/percpu-defs.h>
+#include <linux/mutex.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
@@ -22,6 +26,18 @@ static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
+static unsigned int tdx_global_init_status;
+static DEFINE_SPINLOCK(tdx_global_init_lock);
+#define TDX_GLOBAL_INIT_DONE	_BITUL(0)
+#define TDX_GLOBAL_INIT_FAILED	_BITUL(1)
+
+static DEFINE_PER_CPU(unsigned int, tdx_lp_init_status);
+#define TDX_LP_INIT_DONE	_BITUL(0)
+#define TDX_LP_INIT_FAILED	_BITUL(1)
+
+static enum tdx_module_status_t tdx_module_status;
+static DEFINE_MUTEX(tdx_module_lock);
+
 /*
  * Use tdx_global_keyid to indicate that TDX is uninitialized.
  * This is used in TDX initialization error paths to take it from
@@ -159,3 +175,169 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	put_cpu();
 	return ret;
 }
+
+static int try_init_module_global(void)
+{
+	int ret;
+
+	/*
+	 * The TDX module global initialization only needs to be done
+	 * once on any cpu.
+	 */
+	spin_lock(&tdx_global_init_lock);
+
+	if (tdx_global_init_status & TDX_GLOBAL_INIT_DONE) {
+		ret = tdx_global_init_status & TDX_GLOBAL_INIT_FAILED ?
+			-EINVAL : 0;
+		goto out;
+	}
+
+	/* All '0's are just unused parameters. */
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
+
+	tdx_global_init_status = TDX_GLOBAL_INIT_DONE;
+	if (ret)
+		tdx_global_init_status |= TDX_GLOBAL_INIT_FAILED;
+out:
+	spin_unlock(&tdx_global_init_lock);
+
+	return ret;
+}
+
+/**
+ * tdx_cpu_enable - Enable TDX on local cpu
+ *
+ * Do one-time TDX module per-cpu initialization SEAMCALL (and TDX module
+ * global initialization SEAMCALL if not done) on local cpu to make this
+ * cpu be ready to run any other SEAMCALLs.
+ *
+ * Note this function must be called when preemption is not possible
+ * (i.e. via SMP call or in per-cpu thread).  It is not IRQ safe either
+ * (i.e. cannot be called in per-cpu thread and via SMP call from remote
+ * cpu simultaneously).
+ *
+ * Return 0 on success, otherwise errors.
+ */
+int tdx_cpu_enable(void)
+{
+	unsigned int lp_status;
+	int ret;
+
+	if (!platform_tdx_enabled())
+		return -EINVAL;
+
+	lp_status = __this_cpu_read(tdx_lp_init_status);
+
+	/* Already done */
+	if (lp_status & TDX_LP_INIT_DONE)
+		return lp_status & TDX_LP_INIT_FAILED ? -EINVAL : 0;
+
+	/*
+	 * The TDX module global initialization is the very first step
+	 * to enable TDX.  Need to do it first (if hasn't been done)
+	 * before doing the per-cpu initialization.
+	 */
+	ret = try_init_module_global();
+
+	/*
+	 * If the module global initialization failed, there's no point
+	 * to do the per-cpu initialization.  Just mark it as done but
+	 * failed.
+	 */
+	if (ret)
+		goto update_status;
+
+	/* All '0's are just unused parameters */
+	ret = seamcall(TDH_SYS_LP_INIT, 0, 0, 0, 0, NULL, NULL);
+
+update_status:
+	lp_status = TDX_LP_INIT_DONE;
+	if (ret)
+		lp_status |= TDX_LP_INIT_FAILED;
+
+	this_cpu_write(tdx_lp_init_status, lp_status);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_cpu_enable);
+
+static int init_tdx_module(void)
+{
+	/*
+	 * TODO:
+	 *
+	 *  - Get TDX module information and TDX-capable memory regions.
+	 *  - Build the list of TDX-usable memory regions.
+	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
+	 *    all TDX-usable memory regions.
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
+		pr_err("TDX module initialization failed (%d)\n", ret);
+		tdx_module_status = TDX_MODULE_ERROR;
+		/*
+		 * Just return one universal error code.
+		 * For now the caller cannot recover anyway.
+		 */
+		return -EINVAL;
+	}
+
+	pr_info("TDX module initialized.\n");
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
+		return -EINVAL;
+
+	lockdep_assert_cpus_held();
+
+	mutex_lock(&tdx_module_lock);
+
+	switch (tdx_module_status) {
+	case TDX_MODULE_UNKNOWN:
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 48ad1a1ba737..4d6220e86ccf 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -4,6 +4,31 @@
 
 #include <linux/types.h>
 
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
+	TDX_MODULE_UNKNOWN,
+	TDX_MODULE_INITIALIZED,
+	TDX_MODULE_ERROR
+};
+
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
-- 
2.39.2

