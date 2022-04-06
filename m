Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C724F6480
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiDFQHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiDFQG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:06:29 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A0944E582;
        Tue,  5 Apr 2022 21:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220598; x=1680756598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WHxeJqE3D4iwmpDphKbul2MIPxVCEPcU/ycrWHIMsbA=;
  b=V3+e5A8HTXcp5sUz3yKTJLzDkKXxTqaXfHBo8TsX0Ney1m8BKRbotx/V
   mCzBi6X52BF6KGHERVHy2AjBG34h5WiGwmhWbw4kFjuEKAoL7fuTBjhOM
   taFdlW1A7JlYNYmD6R4smEj7TO9FGXNpKABpVYnYh8ymJQhMBV6MNN8nA
   8YVq9Ys0QVc2rWFw/fFWLd76S/19rK7EsVjJnjeQR2Emb1WC9rYAHlkpI
   ZIMSwv0x7Cq6oo3g+75v8SXRNoQw+oX2kaQKLra62UlJsQj4QdLdX1BSm
   on5z8JYlCMB4yScjtfBaceN0nWvHRvbkpNpAnCuwb/nl5hhGaOgOlNrJ1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089776"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089776"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302107"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:53 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base function
Date:   Wed,  6 Apr 2022 16:49:15 +1200
Message-Id: <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
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

Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
defines a new VMX root operation (SEAM VMX root) and a new VMX non-root
operation (SEAM VMX non-root) which are isolated from legacy VMX root
and VMX non-root mode.

A CPU-attested software module (called the 'TDX module') runs in SEAM
VMX root to manage the crypto-protected VMs running in SEAM VMX non-root.
SEAM VMX root is also used to host another CPU-attested software module
(called the 'P-SEAMLDR') to load and update the TDX module.

Host kernel transits to either the P-SEAMLDR or the TDX module via the
new SEAMCALL instruction.  SEAMCALL leaf functions are host-side
interface functions defined by the P-SEAMLDR and the TDX module around
the new SEAMCALL instruction.  They are similar to a hypercall, except
they are made by host kernel to the SEAM software.

SEAMCALL leaf functions use an ABI different from the x86-64 system-v
ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
%rax is used to carry both the SEAMCALL leaf function number (input) and
the completion status code (output).  Additional GPRs (%rcx, %rdx,
%r8->%r11) may be further used as both input and output operands in
individual leaf functions.

Implement a C function __seamcall() to do SEAMCALL leaf functions using
the assembly macro used by __tdx_module_call() (the implementation of
TDCALL leaf functions).  The only exception not covered here is TDENTER
leaf function which takes all GPRs and XMM0-XMM15 as both input and
output.  The caller of TDENTER should implement its own logic to call
TDENTER directly instead of using this function.

SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
root, and it can fail with VMfailInvalid, for instance, when the SEAM
software module is not loaded.  The C function __seamcall() returns
TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
code of SEAMCALLs, to uniquely represent this case.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/Makefile   |  2 +-
 arch/x86/virt/vmx/tdx/seamcall.S | 52 ++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      | 11 +++++++
 3 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 1bd688684716..fd577619620e 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
+obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o seamcall.o
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
new file mode 100644
index 000000000000..327961b2dd5a
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#include "tdxcall.S"
+
+/*
+ * __seamcall()  - Host-side interface functions to SEAM software module
+ *		   (the P-SEAMLDR or the TDX module)
+ *
+ * Transform function call register arguments into the SEAMCALL register
+ * ABI.  Return TDX_SEAMCALL_VMFAILINVALID, or the completion status of
+ * the SEAMCALL.  Additional output operands are saved in @out (if it is
+ * provided by caller).
+ *
+ *-------------------------------------------------------------------------
+ * SEAMCALL ABI:
+ *-------------------------------------------------------------------------
+ * Input Registers:
+ *
+ * RAX                 - SEAMCALL Leaf number.
+ * RCX,RDX,R8-R9       - SEAMCALL Leaf specific input registers.
+ *
+ * Output Registers:
+ *
+ * RAX                 - SEAMCALL completion status code.
+ * RCX,RDX,R8-R11      - SEAMCALL Leaf specific output registers.
+ *
+ *-------------------------------------------------------------------------
+ *
+ * __seamcall() function ABI:
+ *
+ * @fn  (RDI)          - SEAMCALL Leaf number, moved to RAX
+ * @rcx (RSI)          - Input parameter 1, moved to RCX
+ * @rdx (RDX)          - Input parameter 2, moved to RDX
+ * @r8  (RCX)          - Input parameter 3, moved to R8
+ * @r9  (R8)           - Input parameter 4, moved to R9
+ *
+ * @out (R9)           - struct tdx_module_output pointer
+ *			 stored temporarily in R12 (not
+ *			 used by the P-SEAMLDR or the TDX
+ *			 module). It can be NULL.
+ *
+ * Return (via RAX) the completion status of the SEAMCALL, or
+ * TDX_SEAMCALL_VMFAILINVALID.
+ */
+SYM_FUNC_START(__seamcall)
+	FRAME_BEGIN
+	TDX_MODULE_CALL host=1
+	FRAME_END
+	ret
+SYM_FUNC_END(__seamcall)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
new file mode 100644
index 000000000000..9d5b6f554c20
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_VIRT_TDX_H
+#define _X86_VIRT_TDX_H
+
+#include <linux/types.h>
+
+struct tdx_module_output;
+u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+	       struct tdx_module_output *out);
+
+#endif
-- 
2.35.1

