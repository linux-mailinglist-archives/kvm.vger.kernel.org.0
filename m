Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8926B7217B6
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjFDOad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjFDOab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C72ED;
        Sun,  4 Jun 2023 07:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889021; x=1717425021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iXQb3oNLsE/536KzWnCsa3zkzug3E3baHvO4z/XvFhw=;
  b=csdM3nlaI4gg31zVcguPbVtAVI+puSZp/RGwZm65mMLO5C6+APPw/5Rd
   0nfBNZADi0TYhid3X8TBWFuYWrkfkCRz2QZSgdTPxqyM61geY8lpT9mRt
   UuEJdBp5nkN8DDOnrJFZKXLzaOOi+ohfHjNl5cN84dxyDQP0dt6bPqhCH
   +WOiUlNLrRgg9k7XsNMnba26fTQ9ysXRgjw7zrDPtS7BC3TRvnCif4tWJ
   DeMlM6mLxMdPDplt56eUaFzeqCvfaZTMa8ibe0J0EdsoKndMIYEPKEJ+j
   7MQGeBUfOlpG7GkAymzheQYaTmls1tTULZ9X7vJ833Toix5GkCbOb8UyB
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683503"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683503"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501088"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501088"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:28:27 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 07/20] x86/virt/tdx: Add skeleton to enable TDX on demand
Date:   Mon,  5 Jun 2023 02:27:20 +1200
Message-Id: <21b3a45cb73b4e1917c1eba75b7769781a15aa14.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
"on demand" as it also depends on VMX being enabled.

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
but assume the caller has disabled CPU hotplug, done VMXON and
tdx_cpu_enable() on all online cpus before calling tdx_enable().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 179 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  13 +++
 3 files changed, 196 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b489b5b9de5d..03f74851608f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -102,8 +102,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
+int tdx_cpu_enable(void);
+int tdx_enable(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_cpu_enable(void) { return -ENODEV; }
+static inline int tdx_enable(void)  { return -ENODEV; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e62e978eba1b..bcf2b2d15a2e 100644
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
 #include <asm/archrandom.h>
@@ -23,6 +27,18 @@ static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
+static unsigned int tdx_global_init_status;
+static DEFINE_RAW_SPINLOCK(tdx_global_init_lock);
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
  * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
  * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
@@ -89,6 +105,169 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	return ret;
 }
 
+static int try_init_module_global(void)
+{
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * The TDX module global initialization only needs to be done
+	 * once on any cpu.
+	 */
+	raw_spin_lock_irqsave(&tdx_global_init_lock, flags);
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
+	raw_spin_unlock_irqrestore(&tdx_global_init_lock, flags);
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
+		return ret;
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
+		return -ENODEV;
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
+
 static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
 					    u32 *nr_tdx_keyids)
 {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 55dbb1b8c971..9fb46033c852 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,11 +16,24 @@
  */
 #define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
 
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
  */
 
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
2.40.1

