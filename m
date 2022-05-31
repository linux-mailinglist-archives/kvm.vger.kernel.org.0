Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86ED653971E
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346210AbiEaTky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347363AbiEaTkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:40:43 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D39BACE;
        Tue, 31 May 2022 12:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026037; x=1685562037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rneaAB7YoEFPYCSlSG5kdBpmyJTZLwUT5WrQRfBeX00=;
  b=lOG3NDOUPdPRWiFJDeP23HiOGTa+rjc2il1Pq56yiAAmcC3uMUQiUc7l
   /y2ZVJRqaGtOKn7GOsvkVjrT6yv90cjqeMHaoRH/ayUkgf5tVliw88a35
   6MPrAE/eM4eh0fmRODqLgMe/mE7L9qy6vsEddZ4fbSgDpNXz5Lzq64ODt
   VRY2DwVY2EXKb3KeSHAt82cI7py4JQipjTcbDKki3ckHwu6uAhhv/DVNo
   /QMVpP5fuAM2+uBiz2sEATbeUgboswBdGvR0AleBgr7CG3HQgXj7ETZ8+
   hYtmr47PwDDZE8+riEG1vaIB/CerTWvYADbq2aamgVkPD1fYHnB7gqs6S
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935048"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935048"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164271"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:13 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 06/22] x86/virt/tdx: Add skeleton to initialize TDX on demand
Date:   Wed,  1 Jun 2022 07:39:29 +1200
Message-Id: <abb781ae65f84c0f379c1fb8b9d1fb31eb021f09.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before the TDX module can be used to create and run TD guests, it must
be loaded into the isolated region pointed by the SEAMRR and properly
initialized.  The TDX module is expected to be loaded by BIOS before
booting to the kernel, and the kernel is expected to detect and
initialize it.

The TDX module can be initialized only once in its lifetime.  Instead
of always initializing it at boot time, this implementation chooses an
on-demand approach to initialize TDX until there is a real need (e.g
when requested by KVM).  This avoids consuming the memory that must be
allocated by kernel and given to the TDX module as metadata (~1/256th of
the TDX-usable memory), and also saves the time of initializing the TDX
module (and the metadata) when TDX is not used at all.  Initializing the
TDX module at runtime on-demand also is more flexible to support TDX
module runtime updating in the future (after updating the TDX module, it
needs to be initialized again).

Add a placeholder tdx_init() to detect and initialize the TDX module on
demand, with a state machine protected by mutex to support concurrent
calls from multiple callers.

The TDX module will be initialized in multi-steps defined by the TDX
architecture:

  1) Global initialization;
  2) Logical-CPU scope initialization;
  3) Enumerate the TDX module capabilities and platform configuration;
  4) Configure the TDX module about usable memory ranges and global
     KeyID information;
  5) Package-scope configuration for the global KeyID;
  6) Initialize usable memory ranges based on 4).

The TDX module can also be shut down at any time during its lifetime.
In case of any error during the initialization process, shut down the
module.  It's pointless to leave the module in any intermediate state
during the initialization.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3->v4:

 - Removed the check that SEAMRR and TDX KeyID have been detected on
   all present cpus.
 - Removed tdx_detect().
 - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
   hotplug lock and return early with error message.

---
 arch/x86/include/asm/tdx.h  |   2 +
 arch/x86/virt/vmx/tdx/tdx.c | 157 ++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 97511b76c1ac..801f6e10b2db 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -90,8 +90,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
+int tdx_init(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_init(void)  { return -ENODEV; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eb3294bf1b0a..77e1ec219625 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -10,17 +10,39 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/printk.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/smp.h>
 #include <asm/tdx.h>
 #include <asm/coco.h>
 #include "tdx.h"
 
+/*
+ * TDX module status during initialization
+ */
+enum tdx_module_status_t {
+	/* TDX module hasn't been detected and initialized */
+	TDX_MODULE_UNKNOWN,
+	/* TDX module is not loaded */
+	TDX_MODULE_NONE,
+	/* TDX module is initialized */
+	TDX_MODULE_INITIALIZED,
+	/* TDX module is shut down due to initialization error */
+	TDX_MODULE_SHUTDOWN,
+};
+
 static u32 tdx_keyid_start __ro_after_init;
 static u32 tdx_keyid_num __ro_after_init;
 
+static enum tdx_module_status_t tdx_module_status;
+/* Prevent concurrent attempts on TDX detection and initialization */
+static DEFINE_MUTEX(tdx_module_lock);
+
 /* Detect whether CPU supports SEAM */
 static int detect_seam(void)
 {
@@ -101,6 +123,88 @@ static int __init tdx_early_detect(void)
 }
 early_initcall(tdx_early_detect);
 
+/*
+ * Detect and initialize the TDX module.
+ *
+ * Return -ENODEV when the TDX module is not loaded, 0 when it
+ * is successfully initialized, or other error when it fails to
+ * initialize.
+ */
+static int init_tdx_module(void)
+{
+	/* The TDX module hasn't been detected */
+	return -ENODEV;
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
+	 * Initializing the TDX module requires running some code on
+	 * all MADT-enabled CPUs.  If not all MADT-enabled CPUs are
+	 * online, it's not possible to initialize the TDX module.
+	 *
+	 * For simplicity temporarily disable CPU hotplug to prevent
+	 * any CPU from going offline during the initialization.
+	 */
+	cpus_read_lock();
+
+	/*
+	 * Check whether all MADT-enabled CPUs are online and return
+	 * early with an explicit message so the user can be aware.
+	 *
+	 * Note ACPI CPU hotplug is prevented when TDX is enabled, so
+	 * num_processors always reflects all present MADT-enabled
+	 * CPUs during boot when disabled_cpus is 0.
+	 */
+	if (disabled_cpus || num_online_cpus() != num_processors) {
+		pr_err("Unable to initialize the TDX module when there's offline CPU(s).\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = init_tdx_module();
+	if (ret == -ENODEV) {
+		pr_info("TDX module is not loaded.\n");
+		goto out;
+	}
+
+	/*
+	 * Shut down the TDX module in case of any error during the
+	 * initialization process.  It's meaningless to leave the TDX
+	 * module in any middle state of the initialization process.
+	 *
+	 * Shutting down the module also requires running some code on
+	 * all MADT-enabled CPUs.  Do it while CPU hotplug is disabled.
+	 *
+	 * Return all errors during initialization as -EFAULT as
+	 * the TDX module is always shut down in such cases.
+	 */
+	if (ret) {
+		pr_info("Failed to initialize TDX module.  Shut it down.\n");
+		shutdown_tdx_module();
+		ret = -EFAULT;
+		goto out;
+	}
+
+	pr_info("TDX module initialized.\n");
+out:
+	cpus_read_unlock();
+
+	/*
+	 * Return all error during initialization as -EFAULT as
+	 * the TDX module is always shut down in such case.
+	 */
+	return ret;
+}
+
 /**
  * platform_tdx_enabled() - Return whether BIOS has enabled TDX
  *
@@ -111,3 +215,56 @@ bool platform_tdx_enabled(void)
 {
 	return tdx_keyid_num >= 2;
 }
+
+/**
+ * tdx_init - Initialize the TDX module
+ *
+ * Initialize the TDX module to make it ready to run TD guests.
+ *
+ * Caller to make sure all CPUs are online before calling this function.
+ * CPU hotplug is temporarily disabled internally to prevent any cpu
+ * from going offline.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return:
+ *
+ * * 0:		The TDX module has been successfully initialized.
+ * * -ENODEV:	The TDX module is not loaded, or TDX is not supported.
+ * * -EINVAL:	The TDX module cannot be initialized due to certain
+ *		conditions are not met (i.e. when not all MADT-enabled
+ *		CPUs are not online).
+ * * -EFAULT:	Other internal fatal errors, or the TDX module is in
+ *		shutdown mode due to it failed to initialize in previous
+ *		attempts.
+ */
+int tdx_init(void)
+{
+	int ret;
+
+	if (!platform_tdx_enabled())
+		return -ENODEV;
+
+	mutex_lock(&tdx_module_lock);
+
+	switch (tdx_module_status) {
+	case TDX_MODULE_UNKNOWN:
+		ret = __tdx_init();
+		break;
+	case TDX_MODULE_NONE:
+		ret = -ENODEV;
+		break;
+	case TDX_MODULE_INITIALIZED:
+		ret = 0;
+		break;
+	default:
+		WARN_ON_ONCE(tdx_module_status != TDX_MODULE_SHUTDOWN);
+		ret = -EFAULT;
+		break;
+	}
+
+	mutex_unlock(&tdx_module_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_init);
-- 
2.35.3

