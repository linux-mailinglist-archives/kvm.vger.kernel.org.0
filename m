Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07D6647E0C
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiLIGxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLIGxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:53:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620D3264BA;
        Thu,  8 Dec 2022 22:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568801; x=1702104801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LYSwgfSkyHyPWSC3nXmZTAwd1hEPHDYubQaUW0uEPEM=;
  b=k7JO4GsQfT7Bx6rwI0e22mzLivH8YQr7WMKLXO92gyFnLjoH7B+5dGFo
   84ovYe/dpLiwEZM9l6h29nTkhz9hab+etBYrF1cLM+vlqIKWkRrmcmOdg
   NEMFh1u32WXl0dSyO2kio8LhhrdN2rxJ2L4AfXJVydJCltFsYV04sEk94
   nY69aoBBYEWpOzjbvOmW6MlBgfhyeyowk2LpiSLP4qeieDycde2ZSuhvo
   Dh3lKQE+BO6S/NDh3ZMWJzX/+izl3hY5+W5rJwCH4wETKCtc6xSGkZQsb
   DJwU3j4+W4nYCRkyNr1bjBo52m8rY7bFJ1E+A+a/ez3s0d42pyNCyzGEK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551303"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551303"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679836829"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679836829"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:16 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 04/16] x86/virt/tdx: Add skeleton to initialize TDX on demand
Date:   Fri,  9 Dec 2022 19:52:25 +1300
Message-Id: <5ea3f199c0d6f9f3e1738fa5c211c52d4d618e84.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
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

Before the TDX module can be used to create and run TDX guests, it must
be loaded and properly initialized.  The TDX module is expected to be
loaded by the BIOS, and to be initialized by the kernel.

TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  The host
kernel communicates with the TDX module via a new SEAMCALL instruction.
The TDX module implements a set of SEAMCALL leaf functions to allow the
host kernel to initialize it.

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
demand" loading mechanism.  The hope is that much of "on demand"
mechanism can be shared with a future "update" mechanism.  A boot-time
TDX module implementation would not be able to share much code with the
update mechanism.

3) Loading the TDX module requires VMX to be enabled.  Currently, only
the kernel KVM code mucks with VMX enabling.  If the TDX module were to
be initialized separately from KVM (like at boot), the boot code would
need to be taught how to muck with VMX enabling and KVM would need to be
taught how to cope with that.  Making KVM itself responsible for TDX
initialization lets the rest of the kernel stay blissfully unaware of
VMX.

Add a placeholder tdx_enable() to initialize the TDX module on demand.
Use a state machine protected by mutex to make sure the initialization
will only be done once, as it can be called multiple times (i.e. KVM
module can be reloaded) and be called concurrently by other kernel
components in the future.

The TDX module will be initialized in multi-steps defined by the TDX
module and most of those steps involve a specific SEAMCALL:

 1) Get the TDX module information and TDX-capable memory regions
    (TDH.SYS.INFO).
 2) Build the list of TDX-usable memory regions.
 3) Construct a list of "TD Memory Regions" (TDMRs) to cover all
    TDX-usable memory regions.
 4) Pick up one TDX private KeyID as the global KeyID.
 5) Configure the TDMRs and the global KeyID to the TDX module
    (TDH.SYS.CONFIG).
 6) Configure the global KeyID on all packages (TDH.SYS.KEY.CONFIG).
 7) Initialize all TDMRs (TDH.SYS.TDMR.INIT).

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/include/asm/tdx.h  |  2 +
 arch/x86/virt/vmx/tdx/tdx.c | 93 +++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4dfe2e794411..4a3ee64c1ca7 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -97,8 +97,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
+int tdx_enable(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_enable(void)  { return -EINVAL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 292852773ced..ace9770e5e08 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -12,13 +12,25 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/printk.h>
+#include <linux/mutex.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
+/* Kernel defined TDX module status during module initialization. */
+enum tdx_module_status_t {
+	TDX_MODULE_UNKNOWN,
+	TDX_MODULE_INITIALIZED,
+	TDX_MODULE_ERROR
+};
+
 static u32 tdx_keyid_start __ro_after_init;
 static u32 nr_tdx_keyids __ro_after_init;
 
+static enum tdx_module_status_t tdx_module_status;
+/* Prevent concurrent attempts on TDX detection and initialization */
+static DEFINE_MUTEX(tdx_module_lock);
+
 /*
  * tdx_keyid_start and nr_tdx_keyids indicate that TDX is uninitialized.
  * This is used in TDX initialization error paths to take it from
@@ -88,3 +100,84 @@ bool platform_tdx_enabled(void)
 {
 	return !!nr_tdx_keyids;
 }
+
+static int init_tdx_module(void)
+{
+	/*
+	 * TODO:
+	 *
+	 *  - Get TDX module information and TDX-capable memory regions.
+	 *  - Build the list of TDX-usable memory regions.
+	 *  - Construct a list of TDMRs to cover all TDX-usable memory
+	 *    regions.
+	 *  - Pick up one TDX private KeyID as the global KeyID.
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
+		pr_err_once("initialization failed (%d)\n", ret);
+		tdx_module_status = TDX_MODULE_ERROR;
+		/*
+		 * Just return one universal error code.
+		 * For now the caller cannot recover anyway.
+		 */
+		return -EINVAL;
+	}
+
+	pr_info_once("TDX module initialized.\n");
+	tdx_module_status = TDX_MODULE_INITIALIZED;
+
+	return 0;
+}
+
+/**
+ * tdx_enable - Enable TDX by initializing the TDX module
+ *
+ * The caller must make sure all online cpus are in VMX operation before
+ * calling this function.
+ *
+ * This function can be called in parallel by multiple callers.
+ *
+ * Return 0 if TDX is enabled successfully, otherwise error.
+ */
+int tdx_enable(void)
+{
+	int ret;
+
+	if (!platform_tdx_enabled()) {
+		pr_err_once("initialization failed: TDX is disabled.\n");
+		return -EINVAL;
+	}
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
-- 
2.38.1

