Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEFA694510
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBMMBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjBMMBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:01:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185A818B1E;
        Mon, 13 Feb 2023 04:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289641; x=1707825641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mskoA6wmBALGpNDsQmfVYNazTJkiGatfzDIRABme0ow=;
  b=csePHMdj9qgsy0jx0xzHri/JXnFYNwxmybh1XOfHAK6cmIQIMbgVqZOo
   ncebNSp3FI18uGujULbFp5N7JWJ9ug4s8Tu728yN6UUKibKqOAO05dMOW
   BQObtlmL5mELBxmfvxDff5rxQ0DkXAyDsr6CpEAABqHaxHIAotOXFs9JM
   xjNeJJovlGZZcHkgCgwzzREhlZN+Tu6QcImjjk7C1CV2jSZJvmDVgryYt
   TDCRqIigUd9KJXXaPeToXs6MdDpVFTSyszFW5spEFXQRnHNmjZ8O7y6X3
   VfQeqGvvgbfvA7Djw/i/N9bJTk1MgD/paj5fpKcQWudl7Hv08RmsvMdTg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283183"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283183"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243226"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243226"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:33 -0800
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
Subject: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Date:   Tue, 14 Feb 2023 00:59:12 +1300
Message-Id: <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
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

TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).  This
mode runs only the TDX module itself or other code to load the TDX
module.

The host kernel communicates with SEAM software via a new SEAMCALL
instruction.  This is conceptually similar to a guest->host hypercall,
except it is made from the host to SEAM software instead.  The TDX
module establishes a new SEAMCALL ABI which allows the host to
initialize the module and to manage VMs.

Add infrastructure to make SEAMCALLs.  The SEAMCALL ABI is very similar
to the TDCALL ABI and leverages much TDCALL infrastructure.

SEAMCALL instruction causes #GP when TDX isn't BIOS enabled, and #UD
when CPU is not in VMX operation.  The current TDX_MODULE_CALL macro
doesn't handle any of them.  There's no way to check whether the CPU is
in VMX operation or not.

Initializing the TDX module is done at runtime on demand, and it depends
on the caller to ensure CPU is in VMX operation before making SEAMCALL.
To avoid getting Oops when the caller mistakenly tries to initialize the
TDX module when CPU is not in VMX operation, extend the TDX_MODULE_CALL
macro to handle #UD (and opportunistically #GP since they share the same
assembly).

Introduce two new TDX error codes for #UD and #GP respectively so the
caller can distinguish.  Also, Opportunistically put the new TDX error
codes and the existing TDX_SEAMCALL_VMFAILINVALID into INTEL_TDX_HOST
Kconfig option as they are only used when it is on.

Any failure during the module initialization is not recoverable for now.
Print out error message when SEAMCALL failed depending on the error code
to help the user to understand what went wrong.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v8 -> v9:
 - Changed patch title (Dave).
 - Enhanced seamcall() to include the cpu id to the error message when
   SEAMCALL fails.

v7 -> v8:
 - Improved changelog (Dave):
   - Trim down some sentences (Dave).
   - Removed __seamcall() and seamcall() function name and changed
     accordingly (Dave).
   - Improved the sentence explaining why to handle #GP (Dave).
 - Added code to print out error message in seamcall(), following
   the idea that tdx_enable() to return universal error and print out
   error message to make clear what's going wrong (Dave).  Also mention
   this in changelog.

v6 -> v7:
 - No change.

v5 -> v6:
 - Added code to handle #UD and #GP (Dave).
 - Moved the seamcall() wrapper function to this patch, and used a
   temporary __always_unused to avoid compile warning (Dave).

- v3 -> v5 (no feedback on v4):
 - Explicitly tell TDX_SEAMCALL_VMFAILINVALID is returned if the
   SEAMCALL itself fails.
 - Improve the changelog.

---
 arch/x86/include/asm/tdx.h       |  9 +++++
 arch/x86/virt/vmx/tdx/Makefile   |  2 +-
 arch/x86/virt/vmx/tdx/seamcall.S | 52 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c      | 60 ++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |  5 +++
 arch/x86/virt/vmx/tdx/tdxcall.S  | 19 ++++++++--
 6 files changed, 144 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4a3ee64c1ca7..5c5ecfddb15b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -8,6 +8,10 @@
 #include <asm/ptrace.h>
 #include <asm/shared/tdx.h>
 
+#ifdef CONFIG_INTEL_TDX_HOST
+
+#include <asm/trapnr.h>
+
 /*
  * SW-defined error codes.
  *
@@ -18,6 +22,11 @@
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
 
+#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
+#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
+
+#endif
+
 #ifndef __ASSEMBLY__
 
 /* TDX supported page sizes from the TDX module ABI. */
diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 93ca8b73e1f1..38d534f2c113 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y += tdx.o
+obj-y += tdx.o seamcall.o
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
new file mode 100644
index 000000000000..f81be6b9c133
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
+ * __seamcall() - Host-side interface functions to SEAM software module
+ *		  (the P-SEAMLDR or the TDX module).
+ *
+ * Transform function call register arguments into the SEAMCALL register
+ * ABI.  Return TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself fails,
+ * or the completion status of the SEAMCALL leaf function.  Additional
+ * output operands are saved in @out (if it is provided by the caller).
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
+	RET
+SYM_FUNC_END(__seamcall)
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5a20d56097c..5ae3d71b70b4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -110,6 +110,66 @@ bool platform_tdx_enabled(void)
 	return !!tdx_global_keyid;
 }
 
+/*
+ * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
+ * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
+ * leaf function return code and the additional output respectively if
+ * not NULL.
+ */
+static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+				    u64 *seamcall_ret,
+				    struct tdx_module_output *out)
+{
+	int cpu, ret = 0;
+	u64 sret;
+
+	/* Need a stable CPU id for printing error message */
+	cpu = get_cpu();
+
+	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
+
+	/* Save SEAMCALL return code if the caller wants it */
+	if (seamcall_ret)
+		*seamcall_ret = sret;
+
+	/* SEAMCALL was successful */
+	if (!sret)
+		goto out;
+
+	switch (sret) {
+	case TDX_SEAMCALL_GP:
+		/*
+		 * tdx_enable() has already checked that BIOS has
+		 * enabled TDX at the very beginning before going
+		 * forward.  It's likely a firmware bug if the
+		 * SEAMCALL still caused #GP.
+		 */
+		pr_err_once("[firmware bug]: TDX is not enabled by BIOS.\n");
+		ret = -ENODEV;
+		break;
+	case TDX_SEAMCALL_VMFAILINVALID:
+		pr_err_once("TDX module is not loaded.\n");
+		ret = -ENODEV;
+		break;
+	case TDX_SEAMCALL_UD:
+		pr_err_once("SEAMCALL failed: CPU %d is not in VMX operation.\n",
+				cpu);
+		ret = -EINVAL;
+		break;
+	default:
+		pr_err_once("SEAMCALL failed: CPU %d: leaf %llu, error 0x%llx.\n",
+				cpu, fn, sret);
+		if (out)
+			pr_err_once("additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx.\n",
+					out->rcx, out->rdx, out->r8,
+					out->r9, out->r10, out->r11);
+		ret = -EIO;
+	}
+out:
+	put_cpu();
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 881cca276956..931a50f0f44c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,8 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H
 
+#include <linux/types.h>
+
 /* Kernel defined TDX module status during module initialization. */
 enum tdx_module_status_t {
 	TDX_MODULE_UNKNOWN,
@@ -9,4 +11,7 @@ enum tdx_module_status_t {
 	TDX_MODULE_ERROR
 };
 
+struct tdx_module_output;
+u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+	       struct tdx_module_output *out);
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 49a54356ae99..757b0c34be10 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/asm-offsets.h>
 #include <asm/tdx.h>
+#include <asm/asm.h>
 
 /*
  * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
@@ -45,6 +46,7 @@
 	/* Leave input param 2 in RDX */
 
 	.if \host
+1:
 	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -57,10 +59,23 @@
 	 * This value will never be used as actual SEAMCALL error code as
 	 * it is from the Reserved status code class.
 	 */
-	jnc .Lno_vmfailinvalid
+	jnc .Lseamcall_out
 	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-.Lno_vmfailinvalid:
+	jmp .Lseamcall_out
+2:
+	/*
+	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
+	 * the trap number.  Convert the trap number to the TDX error
+	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
+	 *
+	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
+	 * only accepts 32-bit immediate at most.
+	 */
+	mov $TDX_SW_ERROR, %r12
+	orq %r12, %rax
 
+	_ASM_EXTABLE_FAULT(1b, 2b)
+.Lseamcall_out:
 	.else
 	tdcall
 	.endif
-- 
2.39.1

