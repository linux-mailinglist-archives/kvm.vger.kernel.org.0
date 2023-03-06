Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026CE6AC2EB
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCFOSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjCFOSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:18:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E56311FE;
        Mon,  6 Mar 2023 06:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112246; x=1709648246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uMLzOji59KFUFjV3UhCeXK4DQopRTel++Injo387Ruk=;
  b=f90L4DGVKeksQuuEoWGodoHJ8sksBBuDuPXWoMGZEwGoQBXRA+VL+ryF
   rUftKEzhhHWpBc1Wq8y2ol3zp389idOBcGZxHTCHFPL8uwL/vvqbNZVLb
   NSphPgU2HzxNRfabB7ALP+oWr/07kjhKlv1WjShbBYO/L9VoKJIdZAfeA
   JNeqmBHj74G0wDyzYR3MC0jxQsibtgptYeQ5sSaYyM2shqlrfpXJtEMZs
   RjWdGQUT2AgX2pLCEITGThEcjLe7bfdsaQqGaN32wf9+g8KqlTM7qfdpx
   1wWUsvLSov2DD2jksN9NuUu7lyD2ntIknNanM7BXO5FUS01V4HKul7dG1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080070"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080070"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232089"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232089"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:14:44 -0800
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
Subject: [PATCH v10 04/16] x86/virt/tdx: Add SEAMCALL infrastructure
Date:   Tue,  7 Mar 2023 03:13:49 +1300
Message-Id: <fdd2f7f9e1ff3d8655c7c70eee06de44095f61fd.1678111292.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
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
when CPU is not in VMX operation.  Currently, only KVM code mocks with
VMX enabling, and KVM is the only user of TDX.  This implementation
chooses to make KVM itself responsible for enabling VMX before using
TDX and let the rest of the kernel stay blissfully unaware of VMX.

The current TDX_MODULE_CALL macro handles neither #GP nor #UD.  The
kernel would hit Oops if SEAMCALL were mistakenly made w/o enabling VMX
first.  Architecturally, there is no CPU flag to check whether the CPU
is in VMX operation.  Also, if a BIOS were buggy, it could still report
valid TDX private KeyIDs when TDX actually couldn't be enabled.

Extend the TDX_MODULE_CALL macro to handle #UD and #GP to return error
codes.  Introduce two new TDX error codes for them respectively so the
caller can distinguish.

Also add a wrapper function of SEAMCALL to convert SEAMCALL error code
to the kernel error code, and print out SEAMCALL error code to help the
user to understand what went wrong.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v9 -> v10:
 - Make the TDX_SEAMCALL_{GP|UD} error codes unconditional but doesn't
   define them when INTEL_TDX_HOST is enabled. (Dave)
 - Slightly improved changelog to explain why add assembly code to handle
   #UD and #GP.

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
 arch/x86/include/asm/tdx.h       |  5 +++
 arch/x86/virt/vmx/tdx/Makefile   |  2 +-
 arch/x86/virt/vmx/tdx/seamcall.S | 52 +++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c      | 56 ++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      | 10 ++++++
 arch/x86/virt/vmx/tdx/tdxcall.S  | 19 +++++++++--
 6 files changed, 141 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4dfe2e794411..b489b5b9de5d 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -8,6 +8,8 @@
 #include <asm/ptrace.h>
 #include <asm/shared/tdx.h>
 
+#include <asm/trapnr.h>
+
 /*
  * SW-defined error codes.
  *
@@ -18,6 +20,9 @@
 #define TDX_SW_ERROR			(TDX_ERROR | GENMASK_ULL(47, 40))
 #define TDX_SEAMCALL_VMFAILINVALID	(TDX_SW_ERROR | _UL(0xFFFF0000))
 
+#define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
+#define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
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
index a600b5d0879d..b65b838f3b5d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -12,9 +12,11 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/printk.h>
+#include <linux/smp.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
+#include "tdx.h"
 
 static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
@@ -103,3 +105,57 @@ bool platform_tdx_enabled(void)
 {
 	return !!tdx_global_keyid;
 }
+
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
new file mode 100644
index 000000000000..48ad1a1ba737
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_VIRT_TDX_H
+#define _X86_VIRT_TDX_H
+
+#include <linux/types.h>
+
+struct tdx_module_output;
+u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+	       struct tdx_module_output *out);
+#endif
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
2.39.2

