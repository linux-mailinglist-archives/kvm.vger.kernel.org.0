Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5514D745A
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiCMKvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiCMKv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:51:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D46A27CC8;
        Sun, 13 Mar 2022 03:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168620; x=1678704620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PG8VyH23JZNbCrMdgalMLg3FQhVHGCQzLN//xYisa14=;
  b=MiX1YyKFUpHnfxPbytG875ziQXTdmcM3Dy7kEPgFPyejKMmjopKbtNLL
   ZVvbjcUug9qBlqjwMkBtAyUbovVgmRGmok/UP9Tifm4HjihXc5hXqEp7O
   oyTTF5wjohyhtaAxVeSFfCIp7EulHvy+hZZn69yMWTPWuaxG2PjAhn1aj
   jVB13fY9ObXuGFsI/3zHoEumJWtk4P73Qs9zxw+GFIhmpdzcyTqOUaCzI
   gZfSlzi+MPm6qazkG/IEUV9vC+BcJCajEcan/+Flmq6DP49pGFc45tFeg
   lpQGhzaiJA7ivoziHdp5yIujotIYWNxjSNxkwBYPdYlbbFSyyTeOXVTVp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255810433"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255810433"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448067"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:17 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base function
Date:   Sun, 13 Mar 2022 23:49:43 +1300
Message-Id: <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
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

Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
defines a new VMX root operation (SEAM VMX root) and a new VMX non-root
operation (SEAM VMX non-root) which isolate from legacy VMX root and VMX
non-root mode.

A CPU-attested software module (called the 'TDX module') runs in SEAM
VMX root to manage the crypto protected VMs running in SEAM VMX non-root.
SEAM VMX root is also used to host another CPU-attested software module
(called the 'P-SEAMLDR') to load and update the TDX module.

Host kernel transits to either the P-SEAMLDR or the TDX module via the
new SEAMCALL instruction.  SEAMCALLs are host-side interface functions
defined by the P-SEAMLDR and the TDX module around the new SEAMCALL
instruction.  They are similar to a hypercall, except they are made by
host kernel to the SEAM software.

SEAMCALLs use an ABI different from the x86-64 system-v ABI.  Instead,
they share the same ABI with the TDCALL.  %rax is used to carry both the
SEAMCALL leaf function number (input) and the completion status code
(output).  Additional GPRs (%rcx, %rdx, %r8->%r11) may be further used
as both input and output operands in individual leaf SEAMCALLs.

Implement a C function __seamcall() to do SEAMCALL using the assembly
macro used by __tdx_module_call() (the implementation of TDCALL).  The
only exception not covered here is TDENTER leaf function which takes
all GPRs and XMM0-XMM15 as both input and output.  The caller of TDENTER
should implement its own logic to call TDENTER directly instead of using
this function.

SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
root, and it can fail with VMfailInvalid, for instance, when the SEAM
software module is not loaded.  The C function __seamcall() returns
TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
code of SEAMCALLs, to uniquely represent this case.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/Makefile   |  2 +-
 arch/x86/virt/vmx/seamcall.S | 52 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx.h      | 11 ++++++++
 3 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/vmx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx.h

diff --git a/arch/x86/virt/vmx/Makefile b/arch/x86/virt/vmx/Makefile
index 1bd688684716..fd577619620e 100644
--- a/arch/x86/virt/vmx/Makefile
+++ b/arch/x86/virt/vmx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
+obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o seamcall.o
diff --git a/arch/x86/virt/vmx/seamcall.S b/arch/x86/virt/vmx/seamcall.S
new file mode 100644
index 000000000000..f31a717c00e0
--- /dev/null
+++ b/arch/x86/virt/vmx/seamcall.S
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#include "../tdxcall.S"
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
+ *                       stored temporarily in R12 (not
+ *                       used by the P-SEAMLDR or the TDX
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
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
new file mode 100644
index 000000000000..9d5b6f554c20
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx.h
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

