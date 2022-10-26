Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456CD60EC1D
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiJZXRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiJZXR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B94A8CC3;
        Wed, 26 Oct 2022 16:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826241; x=1698362241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yXwc6jTjMwns9GX2w5ezw+Ruptz8C7nbbXbypLtPhJg=;
  b=jRgoWi88q4QXL/e9TurE7MqHvMvU2DIQpyKGenpvEMCfSrOL9DT/eHom
   h/aVUyNr+KoIFAVwQhNdIGe2zTYQu/Lcdyq3nbTN4X0nepxFuujnRutyZ
   vOWAlOfxeN/bEI0poRIV9kGB8JZ36BJ7iskjFFfZ94byZGcdIPK2JRYNl
   WzA7jcvvGrkBg7fwV0/gRhTjlKafXUoQPiLCLyWRqk+St5kRCFrZIcfoT
   pi61WTAASMKBrsJRD/Ulddspze6OXkeJa8hU41OVMS4fMCOG7m5R5WCFd
   DT7jSGONr5SQma7CgLKp3MCJhS2RxDXuvm/FZ1G5QNv+t0Cxvxbt0fhn1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306814233"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306814233"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:21 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446288"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446288"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:17 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 05/21] x86/virt/tdx: Add skeleton to initialize TDX on demand
Date:   Thu, 27 Oct 2022 12:16:04 +1300
Message-Id: <e65e5a47223e137c6c8bed5e3beaa68f7013a883.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before the TDX module can be used to create and run TDX guests, it must
be loaded into the isolated region pointed by the SEAMRR and properly
initialized.  The TDX module is expected to be loaded by the BIOS before
booting to the kernel, and the kernel is expected to detect and
initialize it.

The host kernel communicates with the TDX module via a new SEAMCALL
instruction.  The TDX module implements a set of SEAMCALL leaf functions
to allow the host kernel to initialize it.

The TDX module can be initialized only once in its lifetime.  Instead
of always initializing it at boot time, this implementation chooses an
"on demand" approach to initialize TDX until there is a real need (e.g
when requested by KVM).  This approach has below pros:

1) It avoids consuming the memory that must be allocated by kernel and
given to the TDX module as metadata (~1/256th of the TDX-usable memory),
and also saves the CPU cycles of initializing the TDX module (and the
metadata) when TDX is not used at all.

2) It is more flexible to support TDX module runtime updating in the
future (after updating the TDX module, it needs to be initialized
again).

3) It avoids having to do a "temporary" solution to handle VMXON in the
core (non-KVM) kernel for now.  This is because SEAMCALL requires CPU
being in VMX operation (VMXON is done), but currently only KVM handles
VMXON.  Adding VMXON support to the core kernel isn't trivial.  More
importantly, from long-term a reference-based approach is likely needed
in the core kernel as more kernel components are likely needed to
support TDX as well.  Allow KVM to initialize the TDX module avoids
having to handle VMXON during kernel boot for now.

Add a placeholder tdx_enable() to detect and initialize the TDX module
on demand, with a state machine protected by mutex to support concurrent
calls from multiple callers.

The TDX module will be initialized in multi-steps defined by the TDX
module:

  1) Global initialization;
  2) Logical-CPU scope initialization;
  3) Enumerate the TDX module capabilities and platform configuration;
  4) Configure the TDX module about TDX usable memory ranges and global
     KeyID information;
  5) Package-scope configuration for the global KeyID;
  6) Initialize usable memory ranges based on 4).

The TDX module can also be shut down at any time during its lifetime.
In case of any error during the initialization process, shut down the
module.  It's pointless to leave the module in any intermediate state
during the initialization.

Also, as mentioned above, tdx_enable() relies on the caller to guarantee
CPU is already in VMX operation before calling SEAMCALL, but doesn't
explicitly handle VMXON.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/include/asm/tdx.h  |   2 +
 arch/x86/virt/vmx/tdx/tdx.c | 152 ++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9b63f33e9c91..80c76b426adf 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -123,8 +123,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
+int tdx_enable(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
+static inline int tdx_enable(void)  { return -ENODEV; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c5d260e27cad..a137350d5d0e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -12,6 +12,9 @@
 #include <linux/printk.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -25,12 +28,30 @@ struct tdx_memblock {
 	int nid;
 };
 
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
 
 /* All TDX-usable memory regions */
 static LIST_HEAD(tdx_memlist);
 
+static enum tdx_module_status_t tdx_module_status;
+/* Prevent concurrent attempts on TDX detection and initialization */
+static DEFINE_MUTEX(tdx_module_lock);
+
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
  * BIOS.  Both initializing the TDX module and running TDX guest require
@@ -245,3 +266,134 @@ bool platform_tdx_enabled(void)
 {
 	return !!tdx_keyid_num;
 }
+
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
+}
+
+static int __tdx_enable(void)
+{
+	int ret;
+
+	/*
+	 * Initializing the TDX module requires doing SEAMCALL on all
+	 * boot-time present CPUs.  For simplicity temporarily disable
+	 * CPU hotplug to prevent any CPU from going offline during
+	 * the initialization.
+	 */
+	cpus_read_lock();
+
+	/*
+	 * Check whether all boot-time present CPUs are online and
+	 * return early with a message so the user can be aware.
+	 *
+	 * Note a non-buggy BIOS should never support physical (ACPI)
+	 * CPU hotplug when TDX is enabled, and all boot-time present
+	 * CPU should be enabled in MADT, so there should be no
+	 * disabled_cpus and num_processors won't change at runtime
+	 * either.
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
+		tdx_module_status = TDX_MODULE_NONE;
+		goto out;
+	}
+
+	/*
+	 * Shut down the TDX module in case of any error during the
+	 * initialization process.  It's meaningless to leave the TDX
+	 * module in any middle state of the initialization process.
+	 *
+	 * Shutting down the module also requires doing SEAMCALL on all
+	 * MADT-enabled CPUs.  Do it while CPU hotplug is disabled.
+	 *
+	 * Return all errors during the initialization as -EFAULT as the
+	 * module is always shut down.
+	 */
+	if (ret) {
+		pr_info("Failed to initialize TDX module.  Shut it down.\n");
+		shutdown_tdx_module();
+		tdx_module_status = TDX_MODULE_SHUTDOWN;
+		ret = -EFAULT;
+		goto out;
+	}
+
+	pr_info("TDX module initialized.\n");
+	tdx_module_status = TDX_MODULE_INITIALIZED;
+out:
+	cpus_read_unlock();
+
+	return ret;
+}
+
+/**
+ * tdx_enable - Enable TDX by initializing the TDX module
+ *
+ * Caller to make sure all CPUs are online and in VMX operation before
+ * calling this function.  CPU hotplug is temporarily disabled internally
+ * to prevent any cpu from going offline.
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
+int tdx_enable(void)
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
+		ret = __tdx_enable();
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
+EXPORT_SYMBOL_GPL(tdx_enable);
-- 
2.37.3

