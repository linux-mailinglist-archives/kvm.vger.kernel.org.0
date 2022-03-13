Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7E44D744F
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiCMKvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiCMKvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:51:21 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C3622518;
        Sun, 13 Mar 2022 03:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168613; x=1678704613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lf2BzP5YvhJWmueG/+DT2oFLzUgP7BzLaTzqPwfJCJQ=;
  b=P7fYDsPvVcMu8ROd05kIcK83ZdTOjjiyJ0RtGUfCCWe++9T9ZMiKYgb7
   nK4uTzefkAR8k/lr61/2daIBI0LVK1z9doqyWVgPiR4/vRoz9z/qIDYyB
   3j5S7JqEkyfeLidePR1ZAdkgTWjEOduqb0VWPUqSjKK+JTYGTpFrN4GAB
   NbaN4p9F8pXslzdxwpLAOaj0VjF57kybbuzf+PhAjAdxzkSsHlgDMLrB1
   8Pjm4NhK0SS1WdUUkh9zGC7i7J+qIoIEvw932znxv7XG4XtfPJCQw96xp
   E8d6oxQa9LzbstDe03URIJYaRNZ2/2Jm4voFOBDGgUEwIr7MXDXKYC1jt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255810425"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255810425"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448044"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:10 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
Date:   Sun, 13 Mar 2022 23:49:41 +1300
Message-Id: <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  To support TDX, a new CPU mode called
Secure Arbitration Mode (SEAM) is added to Intel processors.

SEAM is an extension to the VMX architecture to define a new VMX root
operation (SEAM VMX root) and a new VMX non-root operation (SEAM VMX
non-root).  SEAM VMX root operation is designed to host a CPU-attested
software module called the 'TDX module' which implements functions to
manage crypto protected VMs called Trust Domains (TD).  It is also
designed to additionally host a CPU-attested software module called the
'Intel Persistent SEAMLDR (Intel P-SEAMLDR)' to load and update the TDX
module.

Software modules in SEAM VMX root run in a memory region defined by the
SEAM range register (SEAMRR).  So the first thing of detecting Intel TDX
is to detect the validity of SEAMRR.

The presence of SEAMRR is reported via a new SEAMRR bit (15) of the
IA32_MTRRCAP MSR.  The SEAMRR range registers consist of a pair of MSRs:

        IA32_SEAMRR_PHYS_BASE and IA32_SEAMRR_PHYS_MASK

BIOS is expected to configure SEAMRR with the same value across all
cores.  In case of BIOS misconfiguration, detect and compare SEAMRR
on all cpus.

To start to support TDX, create a new arch/x86/virt/vmx/ for non-KVM
host kernel virtualization support for Intel platforms, and create a new
tdx.c under it for TDX host kernel support.

TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
crypto protect TD guests.  Part of MKTME KeyIDs are reserved as "TDX
private KeyID" or "TDX KeyIDs" for short.  Similar to detecting SEAMRR,
detecting TDX private KeyIDs also needs to be done on all cpus to detect
any BIOS misconfiguration.

Add a function to detect all TDX preliminaries (SEAMRR, TDX private
KeyIDs) for a given cpu when it is brought up.  As the first step,
detect the validity of SEAMRR.

Also add a new Kconfig option CONFIG_INTEL_TDX_HOST to opt-in TDX host
kernel support (to distinguish with TDX guest kernel support).

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig            |  12 +++++
 arch/x86/Makefile           |   2 +
 arch/x86/include/asm/tdx.h  |   9 ++++
 arch/x86/kernel/cpu/intel.c |   3 ++
 arch/x86/virt/Makefile      |   2 +
 arch/x86/virt/vmx/Makefile  |   2 +
 arch/x86/virt/vmx/tdx.c     | 102 ++++++++++++++++++++++++++++++++++++
 7 files changed, 132 insertions(+)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fb2706f7f04a..f4c5481cca46 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1956,6 +1956,18 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config INTEL_TDX_HOST
+	bool "Intel Trust Domain Extensions (TDX) host support"
+	default n
+	depends on CPU_SUP_INTEL
+	depends on X86_64
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
index e84cdd409b64..83a6a5a2e244 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -238,6 +238,8 @@ head-y += arch/x86/kernel/platform-quirks.o
 
 libs-y  += arch/x86/lib/
 
+core-y += arch/x86/virt/
+
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
 drivers-$(CONFIG_PCI)            += arch/x86/pci/
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6a97d42b0de9..605d87ab580e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -11,6 +11,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/processor.h>
+
 /*
  * Used to gather the output registers values of the TDCALL and SEAMCALL
  * instructions when requesting services from the TDX module.
@@ -78,5 +80,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 	return -ENODEV;
 }
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
+
+#ifdef CONFIG_INTEL_TDX_HOST
+void tdx_detect_cpu(struct cpuinfo_x86 *c);
+#else
+static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
+#endif /* CONFIG_INTEL_TDX_HOST */
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_TDX_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43554a1..b142a640fb8e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -26,6 +26,7 @@
 #include <asm/resctrl.h>
 #include <asm/numa.h>
 #include <asm/thermal.h>
+#include <asm/tdx.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -715,6 +716,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
+	tdx_detect_cpu(c);
+
 	init_intel_misc_features(c);
 
 	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
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
index 000000000000..1bd688684716
--- /dev/null
+++ b/arch/x86/virt/vmx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
new file mode 100644
index 000000000000..03f35c75f439
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright(c) 2022 Intel Corporation.
+ *
+ * Intel Trusted Domain Extensions (TDX) support
+ */
+
+#define pr_fmt(fmt)	"tdx: " fmt
+
+#include <linux/types.h>
+#include <linux/cpumask.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/cpufeature.h>
+#include <asm/cpufeatures.h>
+#include <asm/tdx.h>
+
+/* Support Intel Secure Arbitration Mode Range Registers (SEAMRR) */
+#define MTRR_CAP_SEAMRR			BIT(15)
+
+/* Core-scope Intel SEAMRR base and mask registers. */
+#define MSR_IA32_SEAMRR_PHYS_BASE	0x00001400
+#define MSR_IA32_SEAMRR_PHYS_MASK	0x00001401
+
+#define SEAMRR_PHYS_BASE_CONFIGURED	BIT_ULL(3)
+#define SEAMRR_PHYS_MASK_ENABLED	BIT_ULL(11)
+#define SEAMRR_PHYS_MASK_LOCKED		BIT_ULL(10)
+
+#define SEAMRR_ENABLED_BITS	\
+	(SEAMRR_PHYS_MASK_ENABLED | SEAMRR_PHYS_MASK_LOCKED)
+
+/* BIOS must configure SEAMRR registers for all cores consistently */
+static u64 seamrr_base, seamrr_mask;
+
+static bool __seamrr_enabled(void)
+{
+	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
+}
+
+static void detect_seam_bsp(struct cpuinfo_x86 *c)
+{
+	u64 mtrrcap, base, mask;
+
+	/* SEAMRR is reported via MTRRcap */
+	if (!boot_cpu_has(X86_FEATURE_MTRR))
+		return;
+
+	rdmsrl(MSR_MTRRcap, mtrrcap);
+	if (!(mtrrcap & MTRR_CAP_SEAMRR))
+		return;
+
+	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
+	if (!(base & SEAMRR_PHYS_BASE_CONFIGURED)) {
+		pr_info("SEAMRR base is not configured by BIOS\n");
+		return;
+	}
+
+	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
+	if ((mask & SEAMRR_ENABLED_BITS) != SEAMRR_ENABLED_BITS) {
+		pr_info("SEAMRR is not enabled by BIOS\n");
+		return;
+	}
+
+	seamrr_base = base;
+	seamrr_mask = mask;
+}
+
+static void detect_seam_ap(struct cpuinfo_x86 *c)
+{
+	u64 base, mask;
+
+	/*
+	 * Don't bother to detect this AP if SEAMRR is not
+	 * enabled after earlier detections.
+	 */
+	if (!__seamrr_enabled())
+		return;
+
+	rdmsrl(MSR_IA32_SEAMRR_PHYS_BASE, base);
+	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
+
+	if (base == seamrr_base && mask == seamrr_mask)
+		return;
+
+	pr_err("Inconsistent SEAMRR configuration by BIOS\n");
+	/* Mark SEAMRR as disabled. */
+	seamrr_base = 0;
+	seamrr_mask = 0;
+}
+
+static void detect_seam(struct cpuinfo_x86 *c)
+{
+	if (c == &boot_cpu_data)
+		detect_seam_bsp(c);
+	else
+		detect_seam_ap(c);
+}
+
+void tdx_detect_cpu(struct cpuinfo_x86 *c)
+{
+	detect_seam(c);
+}
-- 
2.35.1

