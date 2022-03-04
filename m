Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5104CDE8D
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiCDUHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiCDUGg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE0B23D18F;
        Fri,  4 Mar 2022 12:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424081; x=1677960081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5BZUTlHKmzsMfusRelz30l9Tcv0uhy3GghA6B//HIv8=;
  b=Fhg48MRRnZShbzn6W8kBXCVRPuG/XBmCf6dN7oUaRmNHBD52BMnvea4q
   iJNIbS2YU5VkwIizuTQPzU5OaJw74Sxj3iGz09DUKBjl/HxKNlet0a4nR
   CUR/FbzIRf1gk/vKqtLefCALYUiIft6DCRdew93K+9/2LUyxj5bwEZP1F
   GGjAD/JJHhecUqWmtcSCo1lWgCYS4NP8i9nBFD4poaZjWYViu0iOR6ldh
   5CryvVs7owb9Dgw3C/obdjnFUUcfXPRILJXiMqj0bo0/YaLUrO2myadr5
   cHEWC46gOiijQ9jJVBFgyZfaT3R7Rtf7x7d3tVpEKWZbn4ZORoZ48WyvW
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983344"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983344"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:09 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344153"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:09 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 014/104] KVM: TDX: Add a function for KVM to invoke SEAMCALL
Date:   Fri,  4 Mar 2022 11:48:30 -0800
Message-Id: <355f08931d2b1917fd7230393de6f1052bf6f0c9.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add an assembly function for KVM to call the TDX module because __seamcall
defined in arch/x86/virt/vmx/seamcall.S doesn't fit for the KVM use case.

TDX module API returns extended error information in registers, rcx, rdx,
r8, r9, r10, and r11 in addition to success case.  KVM uses those extended
error information in addition to the status code returned in RAX.  Update
the assembly code to optionally return those outputs even in the error case
and define the specific version for KVM to call the TDX module.

SEAMCALL to the SEAM module (P-SEAMLDR or TDX module) can result in the
error of VmFailInvalid indicated by CF=1 when VMX isn't enabled by VMXON
instruction.  Because KVM guarantees that VMX is enabled, VmFailInvalid
error won't happen.  Don't check the error for KVM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile       |  2 +-
 arch/x86/kvm/vmx/seamcall.S | 55 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/tdxcall.S     |  8 ++++--
 3 files changed, 62 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/seamcall.S

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index e2c05195cb95..e8f83a7d0dc3 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -24,7 +24,7 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
-kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o vmx/seamcall.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
diff --git a/arch/x86/kvm/vmx/seamcall.S b/arch/x86/kvm/vmx/seamcall.S
new file mode 100644
index 000000000000..4a15017fc7dd
--- /dev/null
+++ b/arch/x86/kvm/vmx/seamcall.S
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/linkage.h>
+#include <asm/export.h>
+#include <asm/frame.h>
+
+#include "../../virt/tdxcall.S"
+
+/*
+ * kvm_seamcall()  - Host-side interface functions to SEAM software (TDX module)
+ *
+ * Transform function call register arguments into the SEAMCALL register
+ * ABI.  Return the completion status of the SEAMCALL.  Additional output
+ * operands are saved in @out (if it is provided by the user).
+ * It doesn't check TDX_SEAMCALL_VMFAILINVALID unlike __semcall() because KVM
+ * guarantees that VMX is enabled so that TDX_SEAMCALL_VMFAILINVALID doesn't
+ * happen.  In the case of error completion status code, extended error code may
+ * be stored in leaf specific output registers.
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
+ * kvm_seamcall() function ABI:
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
+ * Return (via RAX) the completion status of the SEAMCALL
+ */
+SYM_FUNC_START(kvm_seamcall)
+        FRAME_BEGIN
+        TDX_MODULE_CALL host=1 error_check=0
+        FRAME_END
+        ret
+SYM_FUNC_END(kvm_seamcall)
+EXPORT_SYMBOL_GPL(kvm_seamcall)
diff --git a/arch/x86/virt/tdxcall.S b/arch/x86/virt/tdxcall.S
index 90569faedacc..2e614b6b5f1e 100644
--- a/arch/x86/virt/tdxcall.S
+++ b/arch/x86/virt/tdxcall.S
@@ -13,7 +13,7 @@
 #define tdcall		.byte 0x66,0x0f,0x01,0xcc
 #define seamcall	.byte 0x66,0x0f,0x01,0xcf
 
-.macro TDX_MODULE_CALL host:req
+.macro TDX_MODULE_CALL host:req error_check=1
 	/*
 	 * R12 will be used as temporary storage for struct tdx_module_output
 	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
@@ -51,9 +51,11 @@
 	 *
 	 * Set %rax to TDX_SEAMCALL_VMFAILINVALID for VMfailInvalid.
 	 * This value will never be used as actual SEAMCALL error code.
-	 */
+	*/
+	.if \error_check
 	jnc .Lno_vmfailinvalid
 	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
+	.endif
 .Lno_vmfailinvalid:
 	.else
 	tdcall
@@ -66,8 +68,10 @@
 	pop %r12
 
 	/* Check for success: 0 - Successful, otherwise failed */
+	.if \error_check
 	test %rax, %rax
 	jnz .Lno_output_struct
+	.endif
 
 	/*
 	 * Since this function can be initiated without an output pointer,
-- 
2.25.1

