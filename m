Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB665546B0
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356755AbiFVLRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357323AbiFVLRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:17:01 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799323BFBC;
        Wed, 22 Jun 2022 04:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896618; x=1687432618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0+Ia/Mrs6xjJ9gyYaF6VIrm6VlKPab2Ql2n9Y0pYkTE=;
  b=JsRSGjvDMyYMKyUtAZZgMnaL+RLbzUnDNICooEDatr1fcHzagNB5+gMR
   lUA+aC66nZT28v4iBzKIOM/N83uIGB/2oQcd9P08+jAyzRrdeinJOI5Vu
   k9+A4lXrMpJV1ioRQ2gipQKGIPvFXTv4ANQCOCrWli2T996v/4afgY2ho
   nixYeVE4A4ER5tO1jj5U5AeEV7Sfvbxssr0uW4nkQZdBh5u1RhNZRVnIf
   99fI82vs7kcV8GB4xwlmVeuQX/8xefxFCqvy1UIxkktSyN2hOnnk2Z7p/
   dFgBn97BdoTvY0xPVb8pr/b+xecYdYhHXu5PPrYbdZGHVQAq87c2sSxUE
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="344379984"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="344379984"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:58 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="834065728"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:16:54 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 06/22] x86/virt/tdx: Add skeleton to initialize TDX on demand
Date:   Wed, 22 Jun 2022 23:16:29 +1200
Message-Id: <c751d1ce046ccc139a8bb34e04d70b1d6bc34a8d.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

- v3->v5 (no feedback on v4):

 - Removed the check that SEAMRR and TDX KeyID have been detected on
   all present cpus.
 - Removed tdx_detect().
 - Added num_online_cpus() to MADT-enabled CPUs check within the CPU
   hotplug lock and return early with error message.
 - Improved dmesg printing for TDX module detection and initialization.

---
 arch/x86/include/asm/tdx.h  |   2 +
 arch/x86/virt/vmx/tdx/tdx.c | 153 ++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+)

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
index eb3294bf1b0a..1f9d8108eeea 100644
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
@@ -101,6 +123,84 @@ static int __init tdx_early_detect(void)
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
+	return ret;
+}
+
 /**
  * platform_tdx_enabled() - Return whether BIOS has enabled TDX
  *
@@ -111,3 +211,56 @@ bool platform_tdx_enabled(void)
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
2.36.1

