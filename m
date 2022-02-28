Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467C54C60D7
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiB1CO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiB1COX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C744C7BC;
        Sun, 27 Feb 2022 18:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014425; x=1677550425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LOtO0u72qJs8GKCMvZlPMhPwFwJeJfyjtjW+xFA1FEM=;
  b=Ee6IRrIo0XmdZKnQtKkzCMoSqQXVahua8rNIaR8xFSXEd6mrSdT2BCyc
   /iaMq52hyv6/wGnU/rMiBxC/BpOHXWXdjKHCUFXpIJm9pggeS0dDc5muI
   5nsXY+FH0f2lHFlJOUJ0E0PYhLSrWj+CzjFbi4T1lnPb2+UUxr0pA2Auq
   N6Te/MQ0niJm/rIdZa+lXJz2jTG4nsvbBfRU7n8pe65K/ff19Y8NKwCiX
   KO9cNoaXWNPXJkKOyDoCRGl0q0lMO92LMsG3oR0cih/SvQ5oQHKIENbNX
   Car9lNjAqpXLBzvx3M7C76YczOeRpfjHxQhzNidcw33oLcMzEmnFxgpjA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="233402443"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="233402443"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936803"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:41 -0800
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
Subject: [RFC PATCH 01/21] x86/virt/tdx: Detect SEAM
Date:   Mon, 28 Feb 2022 15:12:49 +1300
Message-Id: <232d16023c9c017e3d242cc3a118267aec203d6f.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
software module called 'TDX module' which implements functions to manage
crypto protected VMs called Trust Domains (TD).  It is also designed to
additionally host a CPU-attested software module called the 'Intel
Persistent SEAMLDR (Intel P-SEAMLDR)' to load and update the TDX module.

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
detecting TDX private KeyIDs also needs to be done on all cpus to
detect any BIOS misconfiguration.

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
2.33.1

