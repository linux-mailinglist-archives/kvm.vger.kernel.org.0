Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86215554830
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356882AbiFVLP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357028AbiFVLPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:15:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474603C488;
        Wed, 22 Jun 2022 04:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896547; x=1687432547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R9Z6rQxB/ViT0g8LFtl7AUDDX/HTHsPS74al1lNK5LQ=;
  b=I4sL8MMZvkm3wSiCbqed7vwn0CiO1fFIVcaNkg/56s8Mqn70KC9kF7al
   meEQOtyyYsErrKfoTD0VTf/b2wBQzGEGHaRDy10WaGfmaanDicCt9ieNa
   haiUnJi22agESyXiuSmmZzk6DNrzpCgpr6ywLx6l9DH9zpG6ZKQavJDEx
   czqRsh5MI2nuhnOUM1hk4Bet0Bw6wNnFXCbA++SMzyAl9d8nX4iR0B26B
   kHXlU3PCVPehDRjbqXRdCEuFs6Z/kjxdVbunFoM1gFsfuuGvVVLzAbjZw
   D0x3PwsRS2MlzZUOS6okm0aIokIgnvf8gOyUQi1wQX7GzvsjWLe3WR887
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="280435982"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="280435982"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:15:43 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="538433157"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:15:39 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 01/22] x86/virt/tdx: Detect TDX during kernel boot
Date:   Wed, 22 Jun 2022 23:15:30 +1200
Message-Id: <062075b36150b119bf2d0a1262de973b0a2b11a7.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
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

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  TDX introduces a new CPU mode called
Secure Arbitration Mode (SEAM) and a new isolated range pointed by the
SEAM Ranger Register (SEAMRR).  A CPU-attested software module called
'the TDX module' runs inside the new isolated range to implement the
functionalities to manage and run protected VMs.

Pre-TDX Intel hardware has support for a memory encryption architecture
called MKTME.  The memory encryption hardware underpinning MKTME is also
used for Intel TDX.  TDX ends up "stealing" some of the physical address
space from the MKTME architecture for crypto-protection to VMs.  BIOS is
responsible for partitioning the "KeyID" space between legacy MKTME and
TDX.  The KeyIDs reserved for TDX are called 'TDX private KeyIDs' or
'TDX KeyIDs' for short.

To enable TDX, BIOS needs to configure SEAMRR (core-scope) and TDX
private KeyIDs (package-scope) consistently for all packages.  TDX
doesn't trust BIOS.  TDX ensures all BIOS configurations are correct,
and if not, refuses to enable SEAMRR on any core.  This means detecting
SEAMRR alone on BSP is enough to check whether TDX has been enabled by
BIOS.

To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
to opt-in TDX host kernel support (to distinguish with TDX guest kernel
support).  So far only KVM is the only user of TDX.  Make the new config
option depend on KVM_INTEL.

Use early_initcall() to detect whether TDX is enabled by BIOS during
kernel boot, and add a function to report that.  Use a function instead
of a new CPU feature bit.  This is because the TDX module needs to be
initialized before it can be used to run any TDX guests, and the TDX
module is initialized at runtime by the caller who wants to use TDX.

Explicitly detect SEAMRR but not just only detect TDX private KeyIDs.
Theoretically, a misconfiguration of TDX private KeyIDs can result in
SEAMRR being disabled, but the BSP can still report the correct TDX
KeyIDs.  Such BIOS bug can be caught when initializing the TDX module,
but it's better to do more detection during boot to provide a more
accurate result.

Also detect the TDX KeyIDs.  This allows userspace to know how many TDX
guests the platform can run w/o needing to wait until TDX is fully
functional.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig               |  13 ++++
 arch/x86/Makefile              |   2 +
 arch/x86/include/asm/tdx.h     |   7 +++
 arch/x86/virt/Makefile         |   2 +
 arch/x86/virt/vmx/Makefile     |   2 +
 arch/x86/virt/vmx/tdx/Makefile |   2 +
 arch/x86/virt/vmx/tdx/tdx.c    | 109 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h    |  47 ++++++++++++++
 8 files changed, 184 insertions(+)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7021ec725dd3..23f21aa3a5c4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1967,6 +1967,19 @@ config X86_SGX
 
 	  If unsure, say N.
 
+config INTEL_TDX_HOST
+	bool "Intel Trust Domain Extensions (TDX) host support"
+	default n
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
index 63d50f65b828..2ca3a2a36dc5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -234,6 +234,8 @@ head-y += arch/x86/kernel/platform-quirks.o
 
 libs-y  += arch/x86/lib/
 
+core-y += arch/x86/virt/
+
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
 drivers-$(CONFIG_PCI)            += arch/x86/pci/
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 020c81a7c729..97511b76c1ac 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -87,5 +87,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
index 000000000000..1bd688684716
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
new file mode 100644
index 000000000000..8275007702e6
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -0,0 +1,109 @@
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
+#include <linux/init.h>
+#include <linux/printk.h>
+#include <asm/cpufeatures.h>
+#include <asm/cpufeature.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/tdx.h>
+#include "tdx.h"
+
+static u32 tdx_keyid_start __ro_after_init;
+static u32 tdx_keyid_num __ro_after_init;
+
+/* Detect whether CPU supports SEAM */
+static int detect_seam(void)
+{
+	u64 mtrrcap, mask;
+
+	/* SEAMRR is reported via MTRRcap */
+	if (!boot_cpu_has(X86_FEATURE_MTRR))
+		return -ENODEV;
+
+	rdmsrl(MSR_MTRRcap, mtrrcap);
+	if (!(mtrrcap & MTRR_CAP_SEAMRR))
+		return -ENODEV;
+
+	/* The MASK MSR reports whether SEAMRR is enabled */
+	rdmsrl(MSR_IA32_SEAMRR_PHYS_MASK, mask);
+	if ((mask & SEAMRR_ENABLED_BITS) != SEAMRR_ENABLED_BITS)
+		return -ENODEV;
+
+	pr_info("SEAMRR enabled.\n");
+	return 0;
+}
+
+static int detect_tdx_keyids(void)
+{
+	u64 keyid_part;
+
+	rdmsrl(MSR_IA32_MKTME_KEYID_PARTITIONING, keyid_part);
+
+	tdx_keyid_num = TDX_KEYID_NUM(keyid_part);
+	tdx_keyid_start = TDX_KEYID_START(keyid_part);
+
+	pr_info("TDX private KeyID range: [%u, %u).\n",
+			tdx_keyid_start, tdx_keyid_start + tdx_keyid_num);
+
+	/*
+	 * TDX guarantees at least two TDX KeyIDs are configured by
+	 * BIOS, otherwise SEAMRR is disabled.  Invalid TDX private
+	 * range means kernel bug (TDX is broken).
+	 */
+	if (WARN_ON(!tdx_keyid_start || tdx_keyid_num < 2)) {
+		tdx_keyid_start = tdx_keyid_num = 0;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Detect TDX via detecting SEAMRR during kernel boot.
+ *
+ * To enable TDX, BIOS must configure SEAMRR consistently across all
+ * CPU cores.  TDX doesn't trust BIOS.  Instead, MCHECK verifies all
+ * configurations from BIOS are correct, and if not, it disables TDX
+ * (SEAMRR is disabled on all cores).  This means detecting SEAMRR on
+ * BSP is enough to determine whether TDX has been enabled by BIOS.
+ */
+static int __init tdx_early_detect(void)
+{
+	int ret;
+
+	ret = detect_seam();
+	if (ret)
+		return ret;
+
+	/*
+	 * TDX private KeyIDs is only accessible by SEAM software.
+	 * Only detect TDX KeyIDs when SEAMRR is enabled.
+	 */
+	ret = detect_tdx_keyids();
+	if (ret)
+		return ret;
+
+	pr_info("TDX enabled by BIOS.\n");
+	return 0;
+}
+early_initcall(tdx_early_detect);
+
+/**
+ * platform_tdx_enabled() - Return whether BIOS has enabled TDX
+ *
+ * Return whether BIOS has enabled TDX regardless whether the TDX module
+ * has been loaded or not.
+ */
+bool platform_tdx_enabled(void)
+{
+	return tdx_keyid_num >= 2;
+}
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
new file mode 100644
index 000000000000..f16055cc25f4
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_VIRT_TDX_H
+#define _X86_VIRT_TDX_H
+
+#include <linux/bits.h>
+
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
+/*
+ * Intel Trusted Domain CPU Architecture Extension spec:
+ *
+ * IA32_MTRRCAP:
+ *   Bit 15:	The support of SEAMRR
+ *
+ * IA32_SEAMRR_PHYS_MASK (core-scope):
+ *   Bit 10:	Lock bit
+ *   Bit 11:	Enable bit
+ */
+#define MTRR_CAP_SEAMRR			BIT_ULL(15)
+
+#define MSR_IA32_SEAMRR_PHYS_MASK	0x00001401
+
+#define SEAMRR_PHYS_MASK_ENABLED	BIT_ULL(11)
+#define SEAMRR_PHYS_MASK_LOCKED		BIT_ULL(10)
+#define SEAMRR_ENABLED_BITS	\
+	(SEAMRR_PHYS_MASK_ENABLED | SEAMRR_PHYS_MASK_LOCKED)
+
+/*
+ * IA32_MKTME_KEYID_PARTIONING:
+ *   Bit [31:0]:	Number of MKTME KeyIDs.
+ *   Bit [63:32]:	Number of TDX private KeyIDs.
+ *
+ * MKTME KeyIDs start from KeyID 1. TDX private KeyIDs start
+ * after the last MKTME KeyID.
+ */
+#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
+
+#define TDX_KEYID_START(_keyid_part)	\
+		((u32)(((_keyid_part) & 0xffffffffull) + 1))
+#define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
+
+#endif
-- 
2.36.1

