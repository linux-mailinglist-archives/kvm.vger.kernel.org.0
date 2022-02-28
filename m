Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC984C60DE
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiB1COs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiB1COr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:47 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29EE51314;
        Sun, 27 Feb 2022 18:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014439; x=1677550439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jhP2MPNXG6NQHoTiDclh8J5yavVfUqusf6K/JkKdprM=;
  b=aE8b4RkWqyVyR4I6SVAEmNRdMJH8fRcCvyV3a56/ZZknieGi9kCVL/wq
   Hfmxlm1huvSFgiYABXfLmQK6sVUunqX84VxCUcutY04aZwBzezR5J/6aN
   YT4ssgvTS8GcfbIBB8lbFoKjSpaJiMiiEQaHV4bgDy6Qxml+CZAM0Aj/M
   XlC70IvzzPdIw7XcpG+jJufqLJ89//qxGoDFnjtc90Gn/yJ7tzNcCWyAx
   f3ZFgHrXd4iFF1ixFnvIaS1v69bAaWblPWTBkhZW0E9JH3KlaPFL/D8RA
   Z/zhIbJrdKB0vor7TVW6BHGCAGpG9R8Ce/b6WxsF4LklqDv5b11XKG4XU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191884"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191884"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:59 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936845"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:55 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 04/21] x86/virt/tdx: Add skeleton for detecting and initializing TDX on demand
Date:   Mon, 28 Feb 2022 15:12:52 +1300
Message-Id: <dd31a1f0c9bf5df56c09c58ead0663a5bb53919a.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDX module is essentially a CPU-attested software module running
in the new SEAM mode to protect VMs from malicious host and certain
physical attacks.  The TDX module implements the functions to build,
tear down and start execution of protected VMs called Trusted Domains
(TD).  Before the TDX module can be used to create and run TD guests,
it must be loaded into the SEAMRR and properly initialized.  The TDX
module is expected to be loaded by BIOS before booting to the kernel,
and the kernel is expected to detect and initialize it, using the
SEAMCALLs defined by TDX architecture.

The TDX module can be initialized only once in its lifetime.  Instead
of always initializing it at boot time, this implementation chooses an
on-demand approach to initialize TDX until there is a real need (e.g
when requested by KVM).  This avoids consuming the memory that must be
allocated by kernel and given to the TDX module as metadata (~1/256th of
the TDX-usable memory), and also saves the time of initializing the TDX
module (and the metadata) when TDX is not used at all.

Introduce two placeholders tdx_detect() and tdx_init() to detect and
initialize the TDX module on demand, with a state machine introduced to
orchestrate the entire process (in case of multiple callers).

To start with, tdx_detect() checks SEAMRR and TDX private KeyIDs.  The
TDX module is reported as not-loaded if either SEAMRR is not enabled, or
there is no enough TDX private KeyIDs to create any TD guest.  The TDX
module itself requires one global TDX private KeyID to crypto protect
its metadata.

And tdx_init() is currently empty.  The TDX module will be initialized
in multi-steps defined by the TDX architecture:

  1) Global initialization;
  2) Logical-CPU scope initialization;
  3) Enumerate the TDX module capabilities and platform configuration;
  4) Configure the TDX module about usable memory ranges and global
     KeyID information;
  5) Package-scope configuration for the global KeyID;
  6) Initialize usable memory ranges based on 4).

The TDX module can also be shut down at any time during module's
lifetime.  In case of any error during the initialization process,
shut down the module.  It's pointless to leave the module in some
intermediate state during the initialization.

SEAMCALLs used in the above steps (including shutting down TDX module)
require SEAMRR being enabled and CPU being already in VMX operation
(VMXON has been done).  So far KVM is the only user of TDX, and KVM
already puts all online cpus into VMX operation.  Handling VMXON isn't
something trivial, so this implementation doesn't handle VMXON in both
tdx_detect() and tdx_init(), but requires the user of TDX to put all
cpus into VMX operation before calling them.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/tdx.h |   4 +
 arch/x86/virt/vmx/tdx.c    | 220 +++++++++++++++++++++++++++++++++++++
 2 files changed, 224 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 605d87ab580e..b526d41c4bbf 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -83,8 +83,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
+int tdx_detect(void);
+int tdx_init(void);
 #else
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
+static inline int tdx_detect(void) { return -ENODEV; }
+static inline int tdx_init(void) { return -ENODEV; }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index ba2210001ea8..a85bc52c4690 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -9,6 +9,8 @@
 
 #include <linux/types.h>
 #include <linux/cpumask.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -45,12 +47,33 @@
 		((u32)(((_keyid_part) & 0xffffffffull) + 1))
 #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
 
+/*
+ * TDX module status during initialization
+ */
+enum tdx_module_status_t {
+	/* TDX module status is unknown */
+	TDX_MODULE_UNKNOWN,
+	/* TDX module is not loaded */
+	TDX_MODULE_NONE,
+	/* TDX module is loaded, but not initialized */
+	TDX_MODULE_LOADED,
+	/* TDX module is fully initialized */
+	TDX_MODULE_INITIALIZED,
+	/* TDX module is shutdown due to error during initialization */
+	TDX_MODULE_SHUTDOWN,
+};
+
 /* BIOS must configure SEAMRR registers for all cores consistently */
 static u64 seamrr_base, seamrr_mask;
 
 static u32 tdx_keyid_start;
 static u32 tdx_keyid_num;
 
+static enum tdx_module_status_t tdx_module_status;
+
+/* Prevent concurrent attempts on TDX detection and initialization */
+static DEFINE_MUTEX(tdx_module_lock);
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -172,3 +195,200 @@ void tdx_detect_cpu(struct cpuinfo_x86 *c)
 	detect_seam(c);
 	detect_tdx_keyids(c);
 }
+
+static bool seamrr_enabled(void)
+{
+	/*
+	 * To detect any BIOS misconfiguration among cores, all logical
+	 * cpus must have been brought up at least once.  This is true
+	 * unless 'maxcpus' kernel command line is used to limit the
+	 * number of cpus to be brought up during boot time.  However
+	 * 'maxcpus' is basically an invalid operation mode due to the
+	 * MCE broadcast problem, and it should not be used on a TDX
+	 * capable machine.  Just do paranoid check here and WARN()
+	 * if not the case.
+	 */
+	if (WARN_ON_ONCE(!cpumask_equal(&cpus_booted_once_mask,
+					cpu_present_mask)))
+		return false;
+
+	return __seamrr_enabled();
+}
+
+static bool tdx_keyid_sufficient(void)
+{
+	if (WARN_ON_ONCE(!cpumask_equal(&cpus_booted_once_mask,
+					cpu_present_mask)))
+		return false;
+
+	/*
+	 * TDX requires at least two KeyIDs: one global KeyID to
+	 * protect the metadata of the TDX module and one or more
+	 * KeyIDs to run TD guests.
+	 */
+	return tdx_keyid_num >= 2;
+}
+
+static int __tdx_detect(void)
+{
+	/*
+	 * TDX module cannot be possibly loaded if SEAMRR is disabled.
+	 * Also do not report TDX module as loaded if there's no enough
+	 * TDX private KeyIDs to run any TD guests.
+	 */
+	if (!seamrr_enabled()) {
+		pr_info("SEAMRR not enabled.\n");
+		goto no_tdx_module;
+	}
+
+	if (!tdx_keyid_sufficient()) {
+		pr_info("Number of TDX private KeyIDs too small: %u.\n",
+				tdx_keyid_num);
+		goto no_tdx_module;
+	}
+
+	/* Return -ENODEV until TDX module is detected */
+no_tdx_module:
+	tdx_module_status = TDX_MODULE_NONE;
+	return -ENODEV;
+}
+
+static int init_tdx_module(void)
+{
+	/*
+	 * Return -EFAULT until all steps of TDX module
+	 * initialization are done.
+	 */
+	return -EFAULT;
+}
+
+static void shutdown_tdx_module(void)
+{
+	/* TODO: Shut down the TDX module */
+	tdx_module_status = TDX_MODULE_SHUTDOWN;
+}
+
+static int __tdx_init(void)
+{
+	int ret;
+
+	/*
+	 * Logical-cpu scope initialization requires calling one SEAMCALL
+	 * on all logical cpus enabled by BIOS.  Shutting down TDX module
+	 * also has such requirement.  Further more, configuring the key
+	 * of the global KeyID requires calling one SEAMCALL for each
+	 * package.  For simplicity, disable CPU hotplug in the whole
+	 * initialization process.
+	 *
+	 * It's perhaps better to check whether all BIOS-enabled cpus are
+	 * online before starting initializing, and return early if not.
+	 * But none of 'possible', 'present' and 'online' CPU masks
+	 * represents BIOS-enabled cpus.  For example, 'possible' mask is
+	 * impacted by 'nr_cpus' or 'possible_cpus' kernel command line.
+	 * Just let the SEAMCALL to fail if not all BIOS-enabled cpus are
+	 * online.
+	 */
+	cpus_read_lock();
+
+	ret = init_tdx_module();
+	/*
+	 * Put TDX module to shutdown mode in case of any error during
+	 * the initialization process.  It's meaningless to leave the TDX
+	 * module in any middle state of the initialization process.
+	 */
+	if (ret)
+		shutdown_tdx_module();
+
+	cpus_read_unlock();
+
+	return ret;
+}
+
+/**
+ * tdx_detect - Detect whether the TDX module has been loaded
+ *
+ * Detect whether the TDX module has been loaded and ready for
+ * initialization.  Only call this function when CPU is already
+ * in VMX operation.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return:
+ *
+ * * -0:	TDX module has been loaded and ready for initialization.
+ * * -ENODEV:	TDX module is not loaded.
+ * * -EPERM:	CPU is not in VMX operation.
+ * * -EFAULT:	Other internal fatal errors.
+ */
+int tdx_detect(void)
+{
+	int ret;
+
+	mutex_lock(&tdx_module_lock);
+
+	switch (tdx_module_status) {
+	case TDX_MODULE_UNKNOWN:
+		ret = __tdx_detect();
+		break;
+	case TDX_MODULE_NONE:
+		ret = -ENODEV;
+		break;
+	case TDX_MODULE_LOADED:
+	case TDX_MODULE_INITIALIZED:
+		ret = 0;
+		break;
+	case TDX_MODULE_SHUTDOWN:
+		ret = -EFAULT;
+		break;
+	default:
+		WARN_ON(1);
+		ret = -EFAULT;
+	}
+
+	mutex_unlock(&tdx_module_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_detect);
+
+/**
+ * tdx_init - Initialize the TDX module
+ *
+ * Initialize the TDX module to make it ready to run TD guests.  This
+ * function should be called after tdx_detect() returns successful.
+ * Only call this function when all cpus are online and are in VMX
+ * operation.  CPU hotplug is temporarily disabled internally.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return:
+ *
+ * * -0:	The TDX module has been successfully initialized.
+ * * -ENODEV:	The TDX module is not loaded.
+ * * -EPERM:	The CPU which does SEAMCALL is not in VMX operation.
+ * * -EFAULT:	Other internal fatal errors.
+ */
+int tdx_init(void)
+{
+	int ret;
+
+	mutex_lock(&tdx_module_lock);
+
+	switch (tdx_module_status) {
+	case TDX_MODULE_NONE:
+		ret = -ENODEV;
+		break;
+	case TDX_MODULE_LOADED:
+		ret = __tdx_init();
+		break;
+	case TDX_MODULE_INITIALIZED:
+		ret = 0;
+		break;
+	default:
+		ret = -EFAULT;
+		break;
+	}
+	mutex_unlock(&tdx_module_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_init);
-- 
2.33.1

