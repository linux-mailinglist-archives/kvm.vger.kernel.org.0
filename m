Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED95E694508
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjBMMAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjBMMAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:00:39 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92489199D0;
        Mon, 13 Feb 2023 04:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289623; x=1707825623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9DkaKZwWOo0jCrvOqpLGFqKxtauaAnf7axqkLLshL0Q=;
  b=i8b10z0uIqZKO5MryRxu5D7BOYleLPNmT0XRvQiqX2z3vvfa1voMwTxW
   BFgaBk5ybh1FvXaqAtCaEe7SI2umUVLYOu04gbBx+3qG4WHqAknh2DAIs
   3lu9HwZ9iClW49J4Px67Di+5OMKXhPkX970+nKsgu9+ne0si3oFo4ByaN
   NmJeoC3GRrytmnK91NjXgZV/SRSHDAb+DNg8XCsD3P9JqeANgvznL/XIj
   olUyJZaCpO1/lT8y4DTJYIfTPyRryy5p+dXjKhm4Kb4XK6dZuVKAE45tv
   J8qMs0gx+hGz5TPeDW3jGV6YQka3QjjgL+kHHGmgPUQkdsDFPLV7XQ74N
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283056"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283056"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243154"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243154"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:17 -0800
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
Subject: [PATCH v9 02/18] x86/virt/tdx: Detect TDX during kernel boot
Date:   Tue, 14 Feb 2023 00:59:09 +1300
Message-Id: <b4eb14e7b7ef052657fe454c1cb5832ad321164f.1676286526.git.kai.huang@intel.com>
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

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  A CPU-attested software module
called 'the TDX module' runs inside a new isolated memory range as a
trusted hypervisor to manage and run protected VMs.

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto-protection to VMs.  The
BIOS is responsible for partitioning the "KeyID" space between legacy
MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
KeyIDs' or 'TDX KeyIDs' for short.

TDX doesn't trust the BIOS.  During machine boot, TDX verifies the TDX
private KeyIDs are consistently and correctly programmed by the BIOS
across all CPU packages before it enables TDX on any CPU core.  A valid
TDX private KeyID range on BSP indicates TDX has been enabled by the
BIOS, otherwise the BIOS is buggy.

The TDX module is expected to be loaded by the BIOS when it enables TDX,
but the kernel needs to properly initialize it before it can be used to
create and run any TDX guests.  The TDX module will be initialized by
the KVM subsystem when KVM wants to use TDX.

Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
private KeyIDs.  Also add a function to report whether TDX is enabled by
the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
cache flush is needed.

The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
own protection.  Just use the first TDX KeyID as the global KeyID and
leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
disable TDX as initializing the TDX module alone is useless.

To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
to opt-in TDX host kernel support (to distinguish with TDX guest kernel
support).  So far only KVM uses TDX.  Make the new config option depend
on KVM_INTEL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v8 -> v9:
 - Moved MSR macro from local tdx.h to <asm/msr-index.h> (Dave).
 - Moved reserving the TDX global KeyID from later patch to here.
 - Changed 'tdx_keyid_start' and 'nr_tdx_keyids' to
   'tdx_guest_keyid_start' and 'tdx_nr_guest_keyids' to represent KeyIDs
   can be used by guest. (Dave)
 - Slight changelog update according to above changes.

v7 -> v8: (address Dave's comments)
 - Improved changelog:
    - "KVM user" -> "The TDX module will be initialized by KVM when ..."
    - Changed "tdx_int" part to "Just say what this patch is doing"
    - Fixed the last sentence of "kexec()" paragraph
  - detect_tdx() -> record_keyid_partitioning()
  - Improved how to calculate tdx_keyid_start.
  - tdx_keyid_num -> nr_tdx_keyids.
  - Improved dmesg printing.
  - Add comment to clear_tdx().

v6 -> v7:
 - No change.

v5 -> v6:
 - Removed SEAMRR detection to make code simpler.
 - Removed the 'default N' in the KVM_TDX_HOST Kconfig (Kirill).
 - Changed to use 'obj-y' in arch/x86/virt/vmx/tdx/Makefile (Kirill).

---
 arch/x86/Kconfig                 |  12 ++++
 arch/x86/Makefile                |   2 +
 arch/x86/include/asm/msr-index.h |   3 +
 arch/x86/include/asm/tdx.h       |   7 +++
 arch/x86/virt/Makefile           |   2 +
 arch/x86/virt/vmx/Makefile       |   2 +
 arch/x86/virt/vmx/tdx/Makefile   |   2 +
 arch/x86/virt/vmx/tdx/tdx.c      | 105 +++++++++++++++++++++++++++++++
 8 files changed, 135 insertions(+)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3604074a878b..fc010973a6ff 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1952,6 +1952,18 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config INTEL_TDX_HOST
+	bool "Intel Trust Domain Extensions (TDX) host support"
+	depends on CPU_SUP_INTEL
+	depends on X86_64
+	depends on KVM_INTEL
+	help
+	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
+	  host and certain physical attacks.  This option enables necessary TDX
+	  support in host kernel to run protected VMs.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9cf07322875a..972b5a64ce38 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -252,6 +252,8 @@ archheaders:
 
 libs-y  += arch/x86/lib/
 
+core-y += arch/x86/virt/
+
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
 drivers-$(CONFIG_PCI)            += arch/x86/pci/
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 37ff47552bcb..952374ddb167 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -512,6 +512,9 @@
 #define MSR_RELOAD_PMC0			0x000014c1
 #define MSR_RELOAD_FIXED_CTR0		0x00001309
 
+/* KeyID partitioning between MKTME and TDX */
+#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
+
 /*
  * AMD64 MSRs. Not complete. See the architecture manual for a more
  * complete list.
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 25fd6070dc0b..4dfe2e794411 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -94,5 +94,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 	return -ENODEV;
 }
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
+
+#ifdef CONFIG_INTEL_TDX_HOST
+bool platform_tdx_enabled(void);
+#else	/* !CONFIG_INTEL_TDX_HOST */
+static inline bool platform_tdx_enabled(void) { return false; }
+#endif	/* CONFIG_INTEL_TDX_HOST */
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_TDX_H */
diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
new file mode 100644
index 000000000000..1e36502cd738
--- /dev/null
+++ b/arch/x86/virt/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-y	+= vmx/
diff --git a/arch/x86/virt/vmx/Makefile b/arch/x86/virt/vmx/Makefile
new file mode 100644
index 000000000000..feebda21d793
--- /dev/null
+++ b/arch/x86/virt/vmx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx/
diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
new file mode 100644
index 000000000000..93ca8b73e1f1
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-y += tdx.o
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
new file mode 100644
index 000000000000..a600b5d0879d
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2023 Intel Corporation.
+ *
+ * Intel Trusted Domain Extensions (TDX) support
+ */
+
+#define pr_fmt(fmt)	"tdx: " fmt
+
+#include <linux/types.h>
+#include <linux/cache.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/printk.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/tdx.h>
+
+static u32 tdx_global_keyid __ro_after_init;
+static u32 tdx_guest_keyid_start __ro_after_init;
+static u32 tdx_nr_guest_keyids __ro_after_init;
+
+/*
+ * Use tdx_global_keyid to indicate that TDX is uninitialized.
+ * This is used in TDX initialization error paths to take it from
+ * initialized -> uninitialized.
+ */
+static void __init clear_tdx(void)
+{
+	tdx_global_keyid = 0;
+}
+
+static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
+					    u32 *nr_tdx_keyids)
+{
+	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
+	int ret;
+
+	/*
+	 * IA32_MKTME_KEYID_PARTIONING:
+	 *   Bit [31:0]:	Number of MKTME KeyIDs.
+	 *   Bit [63:32]:	Number of TDX private KeyIDs.
+	 */
+	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
+			&_nr_tdx_keyids);
+	if (ret)
+		return -ENODEV;
+
+	if (!_nr_tdx_keyids)
+		return -ENODEV;
+
+	/* TDX KeyIDs start after the last MKTME KeyID. */
+	_tdx_keyid_start = _nr_mktme_keyids + 1;
+
+	*tdx_keyid_start = _tdx_keyid_start;
+	*nr_tdx_keyids = _nr_tdx_keyids;
+
+	return 0;
+}
+
+static int __init tdx_init(void)
+{
+	u32 tdx_keyid_start, nr_tdx_keyids;
+	int err;
+
+	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
+	if (err)
+		return err;
+
+	pr_info("BIOS enabled: private KeyID range [%u, %u)\n",
+			tdx_keyid_start, tdx_keyid_start + nr_tdx_keyids);
+
+	/*
+	 * The TDX module itself requires one 'TDX global KeyID' to
+	 * protect its metadata.  Just use the first one.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+	tdx_keyid_start++;
+	nr_tdx_keyids--;
+
+	/*
+	 * If there's no more TDX KeyID left, KVM won't be able to run
+	 * any TDX guest.  Disable TDX in this case as initializing the
+	 * TDX module alone is meaningless.
+	 */
+	if (!nr_tdx_keyids) {
+		pr_info("initialization failed: too few private KeyIDs available.\n");
+		goto no_tdx;
+	}
+
+	tdx_guest_keyid_start = tdx_keyid_start;
+	tdx_nr_guest_keyids = nr_tdx_keyids;
+
+	return 0;
+no_tdx:
+	clear_tdx();
+	return -ENODEV;
+}
+early_initcall(tdx_init);
+
+/* Return whether the BIOS has enabled TDX */
+bool platform_tdx_enabled(void)
+{
+	return !!tdx_global_keyid;
+}
-- 
2.39.1

