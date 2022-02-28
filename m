Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AC04C60DA
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiB1COg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiB1COe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:34 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B19151314;
        Sun, 27 Feb 2022 18:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014435; x=1677550435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BnYSZkDEfNq6qs3O72hE3RitoTLCTuZUmKqrNKDUKzg=;
  b=mMCRaForP8SN4WrfVmnhPnwjDDrsUBEGZg4sr9lMU0o7TFMnlDls7Scv
   mHD6YuPPc89TPTpUddSSVHXdJxlPe0Sqtn/tj+8++FWWMksbXm8TVCtzA
   IMpn6R19AyVuzfA1W4kMXDVn3LUbKi33R0RN4KACIfx8K1EZIuckGud3U
   5eaVPy9xTYFhQSwaydN/WE2K6hs7wT2dc838CVHant50sZxzE5cQFiW7t
   duJFViyNbjL3QdnUp0LfHegihmS2GSevYyvVgteihIo+vC5SHgTOvsrr8
   zjStib/IJnd2w5AEKGZCAUmULrLNB24XnZ1fXLtYGWYgRJI159LC/3tUA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191880"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191880"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:55 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936834"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:51 -0800
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
Subject: [RFC PATCH 03/21] x86/virt/tdx: Implement the SEAMCALL base function
Date:   Mon, 28 Feb 2022 15:12:51 +1300
Message-Id: <67e0161abb0d0363b810d8539ac8aba139ca7403.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
defines a new VMX root operation (SEAM VMX root) and a new VMX non-root
operation (SEAM VMX non-root) which isolate from legacy VMX root and VMX
non-root mode.

A CPU-attested software module (called 'TDX module') runs in SEAM VMX
root to manage the protected VMs running in SEAM VMX non-root.  SEAM VMX
root is also used to host another CPU-attested software module (called
'P-SEAMLDR') to load and update the TDX module.

Host kernel transits to either P-SEAMLDR or TDX module via the new
SEAMCALL instruction.  SEAMCALLs are host-side interface functions
defined by P-SEAMLDR and TDX module around the new SEAMCALL instruction.
They are similar to a hypercall, except they are made by host kernel to
the SEAM software.

SEAMCALLs use an ABI different from the x86-64 system-v ABI.  Instead,
it shares the same ABI with the TDCALL.  %rax is used to carry both the
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
root.  It fails with VMfailInvalid when the SEAM software is not loaded.
The C function __seamcall() returns TDX_SEAMCALL_VMFAILINVALID, which
doesn't conflict with any actual error code of SEAMCALLs, to uniquely
represent this case.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/Makefile   |  2 +-
 arch/x86/virt/vmx/seamcall.S | 53 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx.h      | 11 ++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)
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
index 000000000000..65edec23b5f4
--- /dev/null
+++ b/arch/x86/virt/vmx/seamcall.S
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/frame.h>
+
+#include "../tdxcall.S"
+
+/*
+ * __seamcall()  - Host-side interface functions to SEAM software
+ *		   (P-SEAMLDR or TDX module)
+ *
+ * Transform function call register arguments into the SEAMCALL register
+ * ABI.  Return TDX_SEAMCALL_VMFAILINVALID (when SEAM software is not
+ * loaded or SEAMCALLs are made into P-SEAMLDR concurrently), or the
+ * completion status of the SEAMCALL.  Additional output operands are
+ * saved in @out (if it is provided by the user).
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
+ *                       shared with the TDX module). It
+ *                       can be NULL.
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
2.33.1

