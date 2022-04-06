Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440884F64A2
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbiDFQGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbiDFQGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:06:06 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BB344E58F;
        Tue,  5 Apr 2022 21:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220602; x=1680756602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEIhYcTJLuTC3eAzOL6jHXASDcVWPWVlc0lPGEOqWdc=;
  b=iyToUJNNH2E0tvhlT+XJqZhvv0w4m6Pa7NwmzHM+L1x7eX6gI4KRipIC
   VhtA0rD4cxW0F5I7QcpTokFgmmbGvVjryhrrQGPh/XFHQ/pxBm4FB6nBs
   WFSDdqanOO1pospxbw2/cAm+WF5Q4nUgcsq4A1PoLc7qK5rb5esfsawvm
   fCdrFj/87laNvIULGtXB9vWObzRL1SXl18UEi9NohbrYK7MazFe78uimb
   lZrPJjFGFi71FxxModQXFH99RjZacv7ohNCWNoOCaJlRsGdOaNCQjtI73
   DbY0MmVAp3uadZnuKHnr0GP9J/6rr0CGWazN/QJraZD5mjLxTXztsu7xH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089786"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089786"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302116"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:57 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and initializing TDX on demand
Date:   Wed,  6 Apr 2022 16:49:16 +1200
Message-Id: <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDX module is essentially a CPU-attested software module running
in the new Secure Arbitration Mode (SEAM) to protect VMs from malicious
host and certain physical attacks.  The TDX module implements the
functions to build, tear down and start execution of the protected VMs
called Trusted Domains (TD).  Before the TDX module can be used to
create and run TD guests, it must be loaded into the SEAM Range Register
(SEAMRR) and properly initialized.  The TDX module is expected to be
loaded by BIOS before booting to the kernel, and the kernel is expected
to detect and initialize it, using the SEAMCALLs defined by TDX
architecture.

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

Introduce two placeholders tdx_detect() and tdx_init() to detect and
initialize the TDX module on demand, with a state machine introduced to
orchestrate the entire process (in case of multiple callers).

To start with, tdx_detect() checks SEAMRR and TDX private KeyIDs.  The
TDX module is reported as not loaded if either SEAMRR is not enabled, or
there are no enough TDX private KeyIDs to create any TD guest.  The TDX
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

The TDX module can also be shut down at any time during its lifetime.
In case of any error during the initialization process, shut down the
module.  It's pointless to leave the module in any intermediate state
during the initialization.

SEAMCALL requires SEAMRR being enabled and CPU being already in VMX
operation (VMXON has been done), otherwise it generates #UD.  So far
only KVM handles VMXON/VMXOFF.  Choose to not handle VMXON/VMXOFF in
tdx_detect() and tdx_init() but depend on the caller to guarantee that,
since so far KVM is the only user of TDX.  In the long term, more kernel
components are likely to use VMXON/VMXOFF to support TDX (i.e. TDX
module runtime update), so a reference-based approach to do VMXON/VMXOFF
is likely needed.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/tdx.h  |   4 +
 arch/x86/virt/vmx/tdx/tdx.c | 222 ++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1f29813b1646..c8af2ba6bb8a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -92,8 +92,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ba2210001ea8..53093d4ad458 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
@@ -172,3 +195,202 @@ void tdx_detect_cpu(struct cpuinfo_x86 *c)
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
+	 * capable machine.  Just do paranoid check here and do not
+	 * report SEAMRR as enabled in this case.
+	 */
+	if (!cpumask_equal(&cpus_booted_once_mask,
+					cpu_present_mask))
+		return false;
+
+	return __seamrr_enabled();
+}
+
+static bool tdx_keyid_sufficient(void)
+{
+	if (!cpumask_equal(&cpus_booted_once_mask,
+					cpu_present_mask))
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
+	/* The TDX module is not loaded if SEAMRR is disabled */
+	if (!seamrr_enabled()) {
+		pr_info("SEAMRR not enabled.\n");
+		goto no_tdx_module;
+	}
+
+	/*
+	 * Also do not report the TDX module as loaded if there's
+	 * no enough TDX private KeyIDs to run any TD guests.
+	 */
+	if (!tdx_keyid_sufficient()) {
+		pr_info("Number of TDX private KeyIDs too small: %u.\n",
+				tdx_keyid_num);
+		goto no_tdx_module;
+	}
+
+	/* Return -ENODEV until the TDX module is detected */
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
+	 * on all logical cpus enabled by BIOS.  Shutting down the TDX
+	 * module also has such requirement.  Further more, configuring
+	 * the key of the global KeyID requires calling one SEAMCALL for
+	 * each package.  For simplicity, disable CPU hotplug in the whole
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
+
+	/*
+	 * Shut down the TDX module in case of any error during the
+	 * initialization process.  It's meaningless to leave the TDX
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
+ * initialization.  Only call this function when all cpus are
+ * already in VMX operation.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return:
+ *
+ * * -0:	The TDX module has been loaded and ready for
+ *		initialization.
+ * * -ENODEV:	The TDX module is not loaded.
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
2.35.1

