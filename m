Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225DA75022C
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbjGLI5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjGLI4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:56:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD9719BA;
        Wed, 12 Jul 2023 01:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152171; x=1720688171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ovAXgE0iduALdm2xZDumA4iTxtpbRs5qa/cZGbUS3A=;
  b=mDPciT4L6RITnAfTTUk9WwBlmxztClAaaBN4b0PKGYa+R2uRmld6FA2o
   uYDRXAau0ySIae0f2/wD6w7tifny6GD2yHLGi74P9EMzwZrgAjENHYgIW
   AGg+nVyV7ytooN8Z92Ub2osobLnINPAzRxjj1XVgiUSWIJocxUUHJyIR2
   JLgyHaWHx0JVRrKWYamx2Efc3T3A1hTwpWKjoIP/PKSIJIkX7DS3L6rTH
   ROyj2fbLN4+ZMW5c8da2lQXnhwFYcIGg96p2Xy5iao33GLNYmW28QuNH0
   k8GLLScaK7vyap8vf+lKjEPt7SUDbGpp4IHbcOtZJwkiBsxSh/98X7by7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439327"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439327"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573414"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573414"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:06 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 09/10] x86/virt/tdx: Wire up basic SEAMCALL functions
Date:   Wed, 12 Jul 2023 20:55:23 +1200
Message-ID: <41b7e5503a3e6057dc168b3c5a9693651c501d22.1689151537.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1689151537.git.kai.huang@intel.com>
References: <cover.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  A CPU-attested software module
called 'the TDX module' runs inside a new isolated memory range as a
trusted hypervisor to manage and run protected VMs.

TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
mode runs only the TDX module itself or other code to load the TDX
module.

The host kernel communicates with SEAM software via a new SEAMCALL
instruction.  This is conceptually similar to a guest->host hypercall,
except it is made from the host to SEAM software instead.  The TDX
module establishes a new SEAMCALL ABI which allows the host to
initialize the module and to manage VMs.

The SEAMCALL ABI is very similar to the TDCALL ABI and leverages much
TDCALL infrastructure.  Wire up basic functions to make SEAMCALLs for
the basic TDX support: __seamcall(), __seamcall_ret() and
__seamcall_saved_ret() which is for TDH.VP.ENTER leaf function.

To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
to opt-in TDX host kernel support (to distinguish with TDX guest kernel
support).  So far only KVM uses TDX.  Make the new config option depend
on KVM_INTEL.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/Kconfig                 | 12 +++++++
 arch/x86/Makefile                |  2 ++
 arch/x86/include/asm/tdx.h       |  7 +++++
 arch/x86/virt/Makefile           |  2 ++
 arch/x86/virt/vmx/Makefile       |  2 ++
 arch/x86/virt/vmx/tdx/Makefile   |  2 ++
 arch/x86/virt/vmx/tdx/seamcall.S | 54 ++++++++++++++++++++++++++++++++
 7 files changed, 81 insertions(+)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 53bab123a8ee..191587f75810 100644
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
+	  support in the host kernel to run confidential VMs.
+
+	  If unsure, say N.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b39975977c03..ec0e71d8fa30 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -252,6 +252,8 @@ archheaders:
 
 libs-y  += arch/x86/lib/
 
+core-y += arch/x86/virt/
+
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
 drivers-$(CONFIG_PCI)            += arch/x86/pci/
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9b0ad0176e58..a82e5249d079 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -74,5 +74,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 	return -ENODEV;
 }
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
+
+#ifdef CONFIG_INTEL_TDX_HOST
+u64 __seamcall(u64 fn, struct tdx_module_args *args);
+u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
+u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
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
index 000000000000..46ef8f73aebb
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-y += seamcall.o
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
new file mode 100644
index 000000000000..650a40843afe
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#include "tdxcall.S"
+
+/*
+ * __seamcall() - Host-side interface functions to SEAM software
+ *                (the P-SEAMLDR or the TDX module).
+ *
+ * __seamcall() function ABI:
+ *
+ * @fn   (RDI)  - SEAMCALL Leaf number, moved to RAX
+ * @args (RSI)  - struct tdx_module_args for input
+ *
+ * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
+ * fails, or the completion status of the SEAMCALL leaf function.
+ */
+SYM_FUNC_START(__seamcall)
+	TDX_MODULE_CALL host=1 ret=0 saved=0
+SYM_FUNC_END(__seamcall)
+
+/*
+ * __seamcall_ret() - Host-side interface functions to SEAM software
+ *                    (the P-SEAMLDR or the TDX module).
+ *
+ * __seamcall_ret() function ABI:
+ *
+ * @fn   (RDI)  - SEAMCALL Leaf number, moved to RAX
+ * @args (RSI)  - struct tdx_module_args for input and output
+ *
+ * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
+ * fails, or the completion status of the SEAMCALL leaf function.
+ */
+SYM_FUNC_START(__seamcall_ret)
+	TDX_MODULE_CALL host=1 ret=1 saved=0
+SYM_FUNC_END(__seamcall_ret)
+
+/*
+ * __seamcall_saved_ret() - Host-side interface functions to SEAM software
+ *                          (the P-SEAMLDR or the TDX module) with extra
+ *                          "callee-saved" registers as input/output.
+ *
+ * __seamcall_saved_ret() function ABI:
+ *
+ * @fn   (RDI)          - SEAMCALL Leaf number, moved to RAX
+ * @args (RSI)          - struct tdx_module_args for input and output
+ *
+ * Return (via RAX) TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself
+ * fails, or the completion status of the SEAMCALL leaf function.
+ */
+SYM_FUNC_START(__seamcall_saved_ret)
+	TDX_MODULE_CALL host=1 ret=1 saved=0
+SYM_FUNC_END(__seamcall_saved_ret)
-- 
2.41.0

