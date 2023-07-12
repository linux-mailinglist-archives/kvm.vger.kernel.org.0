Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054B875022A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjGLI5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjGLI4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:56:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A09B1;
        Wed, 12 Jul 2023 01:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152168; x=1720688168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vG2JNtFiqBw6/tfeYgvXlyb9RCe8dntFQ3qoN0xOBI=;
  b=IpH5/9dg0hNXu9/mFIKzRk9v/wSvhbvrkX+LZPgg+Rh9vw7AjX0Kt8Z6
   1T4PgsYBbSKh/bLlhS68oKynsuUkxxAAfRnU3RsNH0C+QQPuR7c+WtInS
   PeoB9+tWOx9GPHeralYJckhJBWD6Z9/vPhSjfwH4ELm9ZZ02pMW1k2o6l
   uXn+LU/nSwZEOs12tUU2xDEYJ8Q8pXRuYlgukQchiI9ejS1Nycu0NpFkn
   p6Nx4YmulsL/Oq2olA5+dXwkUzQr1b1xbfmeIOjPkGPQXophkiL5XbtUq
   yeJUI1wWwn9dEBYOH0tEvvAurrIBfL1mbsKiNrqBmGZ2HiU9oa1RaWD+F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439300"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439300"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573404"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573404"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:02 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL assembly
Date:   Wed, 12 Jul 2023 20:55:22 +1200
Message-ID: <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
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

Now TDX_HYPERCALL macro shares very similar code pattern with the
TDX_MODULE_CALL macro, except that TDX_HYPERCALL handles below
additional things:

1) Sets RAX to 0 (TDG.VP.VMCALL leaf) internally;
2) Sets RCX to the (fixed) bitmap of shared registers;
3) Panics internally if the TDCALL return code is not zero;
4) After TDCALL, moves R10 to RAX for returning the return code of the
   TDVMCALL itself, regardless the "\ret" parameter;
5) Clears shared registers to prevent speculative use of VMM's values.

Using the TDX_MODULE_CALL macro, 1) - 3) can be moved out to the C code.
4) can be done by always turning on the TDX_MODULE_CALL macro's "\ret"
parameter, and moving it to the C function.  5) is already covered by
the TDH.VP.ENTER in the TDX_MODULE_CALL.

In other words, the TDX_HYPERCALL macro is redundant now and should be
removed to use TDX_MODULE_CALL macro instead.

TDVMCALL always uses the extra "callee-saved" registers.  Replace the
existing __tdx_hypercall{_ret}() assembly functions with a new
__tdcall_saved_ret(), as mentioned above TDVMCALL relies on saving R10
to the register structure so that the caller (C function) can use it as
the return code of the TDVMCALL itself.

As a result, reimplement the existing __tdx_hypercall() using the
__tdcall_saved_ret() function.  __tdx_hypercall_ret() isn't necessary
anymore because __tdx_hypercall() always turns on the "\ret" parameter.

Also remove the 'struct tdx_hypercall_args', which has the exact members
as the 'struct tdx_module_args' (except the RCX which isn't used as
shared register).  It's not worth to keep the structure just for one
member.

With this change, the __tdx_hypercall() variants are not implemented in
tdcall.S anymore thus not available to the compressed code.  Implement
the __tdx_hypercall() variants in the compressed code directly using the
__tdcall_saved_ret().

Opportunistically fix a checkpatch error complaining using space around
parenthesis '(' and ')' while moving the bitmap of shared registers to
<asm/shared/tdx.h>.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/boot/compressed/tdx.c    |  26 +++-
 arch/x86/coco/tdx/tdcall.S        | 194 ++++--------------------------
 arch/x86/coco/tdx/tdx.c           |  62 ++++++----
 arch/x86/include/asm/shared/tdx.h |  48 ++++++--
 arch/x86/include/asm/tdx.h        |  25 ----
 arch/x86/kernel/asm-offsets.c     |  14 ---
 arch/x86/virt/vmx/tdx/tdxcall.S   |  10 +-
 7 files changed, 127 insertions(+), 252 deletions(-)

diff --git a/arch/x86/boot/compressed/tdx.c b/arch/x86/boot/compressed/tdx.c
index 8841b945a1e2..4df2259f9f7f 100644
--- a/arch/x86/boot/compressed/tdx.c
+++ b/arch/x86/boot/compressed/tdx.c
@@ -11,14 +11,32 @@
 #include <asm/shared/tdx.h>
 
 /* Called from __tdx_hypercall() for unrecoverable failure */
-void __tdx_hypercall_failed(void)
+static inline void __tdx_hypercall_failed(void)
 {
 	error("TDVMCALL failed. TDX module bug?");
 }
 
+static inline u64 __tdx_hypercall(struct tdx_module_args *args)
+{
+	u64 ret;
+
+	args->rcx = TDVMCALL_EXPOSE_REGS_MASK;
+	ret = __tdcall_saved_ret(TDG_VP_VMCALL, args);
+
+	/*
+	 * RAX!=0 indicates a failure of the TDVMCALL mechanism itself and that
+	 * something has gone horribly wrong with the TDX module.
+	 */
+	if (ret)
+		__tdx_hypercall_failed();
+
+	/* The return status of the hypercall itself is in R10. */
+	return args->r10;
+}
+
 static inline unsigned int tdx_io_in(int size, u16 port)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_IO_INSTRUCTION),
 		.r12 = size,
@@ -26,7 +44,7 @@ static inline unsigned int tdx_io_in(int size, u16 port)
 		.r14 = port,
 	};
 
-	if (__tdx_hypercall_ret(&args))
+	if (__tdx_hypercall(&args))
 		return UINT_MAX;
 
 	return args.r11;
@@ -34,7 +52,7 @@ static inline unsigned int tdx_io_in(int size, u16 port)
 
 static inline void tdx_io_out(int size, u16 port, u32 value)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_IO_INSTRUCTION),
 		.r12 = size,
diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index d5693330ee9b..6f3c9028577b 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -10,38 +10,11 @@
 
 #include "../../virt/vmx/tdx/tdxcall.S"
 
-/*
- * Bitmasks of exposed registers (with VMM).
- */
-#define TDX_RDX		BIT(2)
-#define TDX_RBX		BIT(3)
-#define TDX_RSI		BIT(6)
-#define TDX_RDI		BIT(7)
-#define TDX_R8		BIT(8)
-#define TDX_R9		BIT(9)
-#define TDX_R10		BIT(10)
-#define TDX_R11		BIT(11)
-#define TDX_R12		BIT(12)
-#define TDX_R13		BIT(13)
-#define TDX_R14		BIT(14)
-#define TDX_R15		BIT(15)
-
-/*
- * These registers are clobbered to hold arguments for each
- * TDVMCALL. They are safe to expose to the VMM.
- * Each bit in this mask represents a register ID. Bit field
- * details can be found in TDX GHCI specification, section
- * titled "TDCALL [TDG.VP.VMCALL] leaf".
- */
-#define TDVMCALL_EXPOSE_REGS_MASK	\
-	( TDX_RDX | TDX_RBX | TDX_RSI | TDX_RDI | TDX_R8  | TDX_R9  | \
-	  TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13 | TDX_R14 | TDX_R15 )
-
 .section .noinstr.text, "ax"
 
 /*
  * __tdcall()  - Used by TDX guests to request services from the TDX
- * module (does not include VMM services) using TDCALL instruction.
+ * module using TDCALL instruction.
  *
  * __tdcall() function ABI:
  *
@@ -56,7 +29,7 @@ SYM_FUNC_END(__tdcall)
 
 /*
  * __tdcall_ret() - Used by TDX guests to request services from the TDX
- * module (does not include VMM services) using TDCALL instruction.
+ * module using TDCALL instruction.
  *
  * __tdcall_ret() function ABI:
  *
@@ -70,156 +43,33 @@ SYM_FUNC_START(__tdcall_ret)
 SYM_FUNC_END(__tdcall_ret)
 
 /*
- * TDX_HYPERCALL - Make hypercalls to a TDX VMM using TDVMCALL leaf of TDCALL
- * instruction
+ * __tdcall_saved() - Used by the TDX guests to request services from the
+ * TDX module using TDCALL instruction with additional callee-saved
+ * registers as input.
  *
- * Transforms values in  function call argument struct tdx_hypercall_args @args
- * into the TDCALL register ABI. After TDCALL operation, VMM output is saved
- * back in @args, if \ret is 1.
+ * __tdcall_saved() function ABI:
  *
- *-------------------------------------------------------------------------
- * TD VMCALL ABI:
- *-------------------------------------------------------------------------
+ * @fn   (RDI)	- TDCALL leaf ID, moved to RAX
+ * @args (RSI)	- struct 'struct tdx_module_args' for input
  *
- * Input Registers:
- *
- * RAX                 - TDCALL instruction leaf number (0 - TDG.VP.VMCALL)
- * RCX                 - BITMAP which controls which part of TD Guest GPR
- *                       is passed as-is to the VMM and back.
- * R10                 - Set 0 to indicate TDCALL follows standard TDX ABI
- *                       specification. Non zero value indicates vendor
- *                       specific ABI.
- * R11                 - VMCALL sub function number
- * RBX, RDX, RDI, RSI  - Used to pass VMCALL sub function specific arguments.
- * R8-R9, R12-R15      - Same as above.
- *
- * Output Registers:
- *
- * RAX                 - TDCALL instruction status (Not related to hypercall
- *                        output).
- * RBX, RDX, RDI, RSI  - Hypercall sub function specific output values.
- * R8-R15              - Same as above.
- *
- */
-.macro TDX_HYPERCALL ret:req
-	FRAME_BEGIN
-
-	/* Save callee-saved GPRs as mandated by the x86_64 ABI */
-	push %r15
-	push %r14
-	push %r13
-	push %r12
-	push %rbx
-
-	/* Free RDI to be used as TDVMCALL arguments */
-	movq %rdi, %rax
-
-	/* Copy hypercall registers from arg struct: */
-	movq TDX_HYPERCALL_r8(%rax),  %r8
-	movq TDX_HYPERCALL_r9(%rax),  %r9
-	movq TDX_HYPERCALL_r10(%rax), %r10
-	movq TDX_HYPERCALL_r11(%rax), %r11
-	movq TDX_HYPERCALL_r12(%rax), %r12
-	movq TDX_HYPERCALL_r13(%rax), %r13
-	movq TDX_HYPERCALL_r14(%rax), %r14
-	movq TDX_HYPERCALL_r15(%rax), %r15
-	movq TDX_HYPERCALL_rdi(%rax), %rdi
-	movq TDX_HYPERCALL_rsi(%rax), %rsi
-	movq TDX_HYPERCALL_rbx(%rax), %rbx
-	movq TDX_HYPERCALL_rdx(%rax), %rdx
-
-	push %rax
-
-	/* Mangle function call ABI into TDCALL ABI: */
-	/* Set TDCALL leaf ID (TDVMCALL (0)) in RAX */
-	xor %eax, %eax
-
-	movl $TDVMCALL_EXPOSE_REGS_MASK, %ecx
-
-	tdcall
-
-	/*
-	 * RAX!=0 indicates a failure of the TDVMCALL mechanism itself and that
-	 * something has gone horribly wrong with the TDX module.
-	 *
-	 * The return status of the hypercall operation is in a separate
-	 * register (in R10). Hypercall errors are a part of normal operation
-	 * and are handled by callers.
-	 */
-	testq %rax, %rax
-	jne .Lpanic\@
-
-	pop %rax
-
-	.if \ret
-	movq %r8,  TDX_HYPERCALL_r8(%rax)
-	movq %r9,  TDX_HYPERCALL_r9(%rax)
-	movq %r10, TDX_HYPERCALL_r10(%rax)
-	movq %r11, TDX_HYPERCALL_r11(%rax)
-	movq %r12, TDX_HYPERCALL_r12(%rax)
-	movq %r13, TDX_HYPERCALL_r13(%rax)
-	movq %r14, TDX_HYPERCALL_r14(%rax)
-	movq %r15, TDX_HYPERCALL_r15(%rax)
-	movq %rdi, TDX_HYPERCALL_rdi(%rax)
-	movq %rsi, TDX_HYPERCALL_rsi(%rax)
-	movq %rbx, TDX_HYPERCALL_rbx(%rax)
-	movq %rdx, TDX_HYPERCALL_rdx(%rax)
-	.endif
-
-	/* TDVMCALL leaf return code is in R10 */
-	movq %r10, %rax
-
-	/*
-	 * Zero out registers exposed to the VMM to avoid speculative execution
-	 * with VMM-controlled values. This needs to include all registers
-	 * present in TDVMCALL_EXPOSE_REGS_MASK, except RBX, and R12-R15 which
-	 * will be restored.
-	 */
-	xor %r8d,  %r8d
-	xor %r9d,  %r9d
-	xor %r10d, %r10d
-	xor %r11d, %r11d
-	xor %rdi,  %rdi
-	xor %rsi,  %rsi
-	xor %rdx,  %rdx
-
-	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
-	pop %rbx
-	pop %r12
-	pop %r13
-	pop %r14
-	pop %r15
-
-	FRAME_END
-
-	RET
-.Lpanic\@:
-	call __tdx_hypercall_failed
-	/* __tdx_hypercall_failed never returns */
-	REACHABLE
-	jmp .Lpanic\@
-.endm
-
-/*
- *
- * __tdx_hypercall() function ABI:
- *
- * @args  (RDI)        - struct tdx_hypercall_args for input
- *
- * On successful completion, return the hypercall error code.
+ * Return the TDCALL return code (RAX)
  */
-SYM_FUNC_START(__tdx_hypercall)
-	TDX_HYPERCALL ret=0
-SYM_FUNC_END(__tdx_hypercall)
+SYM_FUNC_START(__tdcall_saved)
+	TDX_MODULE_CALL host=0 ret=0 saved=1
+SYM_FUNC_END(__tdcall_saved)
 
 /*
+ * __tdcall_saved_ret() - Used by the TDX guests to request services from the
+ * TDX module using TDCALL instruction with additional callee-saved registers
+ * as input/output.
  *
- * __tdx_hypercall_ret() function ABI:
+ * __tdcall_saved_ret() function ABI:
  *
- * @args  (RDI)        - struct tdx_hypercall_args for input and output
+ * @fn   (RDI)	- TDCALL leaf ID, moved to RAX
+ * @args (RDI)	- struct 'struct tdx_module_args' for input and output
  *
- * On successful completion, return the hypercall error code.
+ * Return the TDCALL return code (RAX)
  */
-SYM_FUNC_START(__tdx_hypercall_ret)
-	TDX_HYPERCALL ret=1
-SYM_FUNC_END(__tdx_hypercall_ret)
+SYM_FUNC_START(__tdcall_saved_ret)
+	TDX_MODULE_CALL host=0 ret=1 saved=1
+SYM_FUNC_END(__tdcall_saved_ret)
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 0f16ba52ae62..a5e77893b2c0 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -51,13 +51,38 @@
 
 #define TDREPORT_SUBTYPE_0	0
 
+/* Called from __tdx_hypercall() for unrecoverable failure */
+static noinstr void __tdx_hypercall_failed(void)
+{
+	instrumentation_begin();
+	panic("TDVMCALL failed. TDX module bug?");
+}
+
+static inline u64 __tdx_hypercall(struct tdx_module_args *args)
+{
+	u64 ret;
+
+	args->rcx = TDVMCALL_EXPOSE_REGS_MASK;
+	ret = __tdcall_saved_ret(TDG_VP_VMCALL, args);
+
+	/*
+	 * RAX!=0 indicates a failure of the TDVMCALL mechanism itself and that
+	 * something has gone horribly wrong with the TDX module.
+	 */
+	if (ret)
+		__tdx_hypercall_failed();
+
+	/* The return status of the hypercall itself is in R10. */
+	return args->r10;
+}
+
 /*
- * Wrapper for standard use of __tdx_hypercall with no output aside from
- * return code.
+ * Wrapper for standard use of __tdx_hypercall() w/o needing any output
+ * register except the return code.
  */
 static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = fn,
 		.r12 = r12,
@@ -69,18 +94,11 @@ static inline u64 _tdx_hypercall(u64 fn, u64 r12, u64 r13, u64 r14, u64 r15)
 	return __tdx_hypercall(&args);
 }
 
-/* Called from __tdx_hypercall() for unrecoverable failure */
-noinstr void __tdx_hypercall_failed(void)
-{
-	instrumentation_begin();
-	panic("TDVMCALL failed. TDX module bug?");
-}
-
 #ifdef CONFIG_KVM_GUEST
 long tdx_kvm_hypercall(unsigned int nr, unsigned long p1, unsigned long p2,
 		       unsigned long p3, unsigned long p4)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = nr,
 		.r11 = p1,
 		.r12 = p2,
@@ -140,7 +158,7 @@ EXPORT_SYMBOL_GPL(tdx_mcall_get_report0);
 
 static void __noreturn tdx_panic(const char *msg)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = TDVMCALL_REPORT_FATAL_ERROR,
 		.r12 = 0, /* Error code: 0 is Panic */
@@ -262,7 +280,7 @@ static int ve_instr_len(struct ve_info *ve)
 
 static u64 __cpuidle __halt(const bool irq_disabled)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_HLT),
 		.r12 = irq_disabled,
@@ -306,7 +324,7 @@ void __cpuidle tdx_safe_halt(void)
 
 static int read_msr(struct pt_regs *regs, struct ve_info *ve)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_MSR_READ),
 		.r12 = regs->cx,
@@ -317,7 +335,7 @@ static int read_msr(struct pt_regs *regs, struct ve_info *ve)
 	 * can be found in TDX Guest-Host-Communication Interface
 	 * (GHCI), section titled "TDG.VP.VMCALL<Instruction.RDMSR>".
 	 */
-	if (__tdx_hypercall_ret(&args))
+	if (__tdx_hypercall(&args))
 		return -EIO;
 
 	regs->ax = lower_32_bits(args.r11);
@@ -327,7 +345,7 @@ static int read_msr(struct pt_regs *regs, struct ve_info *ve)
 
 static int write_msr(struct pt_regs *regs, struct ve_info *ve)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_MSR_WRITE),
 		.r12 = regs->cx,
@@ -347,7 +365,7 @@ static int write_msr(struct pt_regs *regs, struct ve_info *ve)
 
 static int handle_cpuid(struct pt_regs *regs, struct ve_info *ve)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_CPUID),
 		.r12 = regs->ax,
@@ -371,7 +389,7 @@ static int handle_cpuid(struct pt_regs *regs, struct ve_info *ve)
 	 * ABI can be found in TDX Guest-Host-Communication Interface
 	 * (GHCI), section titled "VP.VMCALL<Instruction.CPUID>".
 	 */
-	if (__tdx_hypercall_ret(&args))
+	if (__tdx_hypercall(&args))
 		return -EIO;
 
 	/*
@@ -389,7 +407,7 @@ static int handle_cpuid(struct pt_regs *regs, struct ve_info *ve)
 
 static bool mmio_read(int size, unsigned long addr, unsigned long *val)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_EPT_VIOLATION),
 		.r12 = size,
@@ -398,7 +416,7 @@ static bool mmio_read(int size, unsigned long addr, unsigned long *val)
 		.r15 = *val,
 	};
 
-	if (__tdx_hypercall_ret(&args))
+	if (__tdx_hypercall(&args))
 		return false;
 	*val = args.r11;
 	return true;
@@ -517,7 +535,7 @@ static int handle_mmio(struct pt_regs *regs, struct ve_info *ve)
 
 static bool handle_in(struct pt_regs *regs, int size, int port)
 {
-	struct tdx_hypercall_args args = {
+	struct tdx_module_args args = {
 		.r10 = TDX_HYPERCALL_STANDARD,
 		.r11 = hcall_func(EXIT_REASON_IO_INSTRUCTION),
 		.r12 = size,
@@ -532,7 +550,7 @@ static bool handle_in(struct pt_regs *regs, int size, int port)
 	 * in TDX Guest-Host-Communication Interface (GHCI) section titled
 	 * "TDG.VP.VMCALL<Instruction.IO>".
 	 */
-	success = !__tdx_hypercall_ret(&args);
+	success = !__tdx_hypercall(&args);
 
 	/* Update part of the register affected by the emulated instruction */
 	regs->ax &= ~mask;
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index b415a24f0d48..f2a6e76dd773 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -13,32 +13,60 @@
 #ifndef __ASSEMBLY__
 
 /*
- * Used in __tdx_hypercall() to pass down and get back registers' values of
- * the TDCALL instruction when requesting services from the VMM.
+ * Used to gather input/output registers of the TDCALL and SEAMCALL
+ * instructions when requesting services from the TDX module.
  *
  * This is a software only structure and not part of the TDX module/VMM ABI.
  */
-struct tdx_hypercall_args {
+struct tdx_module_args {
+	/* callee-clobbered */
+	u64 rcx;
+	u64 rdx;
 	u64 r8;
 	u64 r9;
+	/* extra callee-clobbered */
 	u64 r10;
 	u64 r11;
+	/* callee-saved + rdi/rsi */
 	u64 r12;
 	u64 r13;
 	u64 r14;
 	u64 r15;
+	u64 rbx;
 	u64 rdi;
 	u64 rsi;
-	u64 rbx;
-	u64 rdx;
 };
 
-/* Used to request services from the VMM */
-u64 __tdx_hypercall(struct tdx_hypercall_args *args);
-u64 __tdx_hypercall_ret(struct tdx_hypercall_args *args);
+#define TDG_VP_VMCALL	0
 
-/* Called from __tdx_hypercall() for unrecoverable failure */
-void __tdx_hypercall_failed(void);
+/*
+ * Bitmasks of exposed registers (with VMM).
+ */
+#define TDX_RDX		BIT(2)
+#define TDX_RBX		BIT(3)
+#define TDX_RSI		BIT(6)
+#define TDX_RDI		BIT(7)
+#define TDX_R8		BIT(8)
+#define TDX_R9		BIT(9)
+#define TDX_R10		BIT(10)
+#define TDX_R11		BIT(11)
+#define TDX_R12		BIT(12)
+#define TDX_R13		BIT(13)
+#define TDX_R14		BIT(14)
+#define TDX_R15		BIT(15)
+
+/*
+ * These registers are clobbered to hold arguments for each
+ * TDVMCALL. They are safe to expose to the VMM.
+ * Each bit in this mask represents a register ID. Bit field
+ * details can be found in TDX GHCI specification, section
+ * titled "TDCALL [TDG.VP.VMCALL] leaf".
+ */
+#define TDVMCALL_EXPOSE_REGS_MASK	\
+	(TDX_RDX | TDX_RBX | TDX_RSI | TDX_RDI | TDX_R8  | TDX_R9  | \
+	 TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13 | TDX_R14 | TDX_R15)
+
+u64 __tdcall_saved_ret(u64 fn, struct tdx_module_args *args);
 
 /*
  * The TDG.VP.VMCALL-Instruction-execution sub-functions are defined
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a549bcc77f4f..9b0ad0176e58 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -20,31 +20,6 @@
 
 #ifndef __ASSEMBLY__
 
-/*
- * Used to gather input/output registers of the TDCALL and SEAMCALL
- * instructions when requesting services from the TDX module.
- *
- * This is a software only structure and not part of the TDX module/VMM ABI.
- */
-struct tdx_module_args {
-	/* callee-clobbered */
-	u64 rcx;
-	u64 rdx;
-	u64 r8;
-	u64 r9;
-	/* extra callee-clobbered */
-	u64 r10;
-	u64 r11;
-	/* callee-saved + rdi/rsi */
-	u64 r12;
-	u64 r13;
-	u64 r14;
-	u64 r15;
-	u64 rbx;
-	u64 rdi;
-	u64 rsi;
-};
-
 /*
  * Used by the #VE exception handler to gather the #VE exception
  * info from the TDX module. This is a software only structure
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 1581564a67b7..6913b372ccf7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -82,20 +82,6 @@ static void __used common(void)
 	OFFSET(TDX_MODULE_rdi, tdx_module_args, rdi);
 	OFFSET(TDX_MODULE_rsi, tdx_module_args, rsi);
 
-	BLANK();
-	OFFSET(TDX_HYPERCALL_r8,  tdx_hypercall_args, r8);
-	OFFSET(TDX_HYPERCALL_r9,  tdx_hypercall_args, r9);
-	OFFSET(TDX_HYPERCALL_r10, tdx_hypercall_args, r10);
-	OFFSET(TDX_HYPERCALL_r11, tdx_hypercall_args, r11);
-	OFFSET(TDX_HYPERCALL_r12, tdx_hypercall_args, r12);
-	OFFSET(TDX_HYPERCALL_r13, tdx_hypercall_args, r13);
-	OFFSET(TDX_HYPERCALL_r14, tdx_hypercall_args, r14);
-	OFFSET(TDX_HYPERCALL_r15, tdx_hypercall_args, r15);
-	OFFSET(TDX_HYPERCALL_rdi, tdx_hypercall_args, rdi);
-	OFFSET(TDX_HYPERCALL_rsi, tdx_hypercall_args, rsi);
-	OFFSET(TDX_HYPERCALL_rbx, tdx_hypercall_args, rbx);
-	OFFSET(TDX_HYPERCALL_rdx, tdx_hypercall_args, rdx);
-
 	BLANK();
 	OFFSET(BP_scratch, boot_params, scratch);
 	OFFSET(BP_secure_boot, boot_params, secure_boot);
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 389f4ec5eee8..e4e90ebf5dad 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -145,11 +145,11 @@
 	.endif	/* \ret */
 
 	.if \saved
-	.if \ret && \host
+	.if \ret
 	/*
-	 * Clear registers shared by guest for VP.ENTER to prevent
-	 * speculative use of guest's values, including those are
-	 * restored from the stack.
+	 * Clear registers shared by guest for VP.ENTER and VP.VMCALL to
+	 * prevent speculative use of values from guest/VMM, including
+	 * those are restored from the stack.
 	 *
 	 * See arch/x86/kvm/vmx/vmenter.S:
 	 *
@@ -173,7 +173,7 @@
 	xorq %r15, %r15
 	xorq %rbx, %rbx
 	xorq %rdi, %rdi
-	.endif	/* \ret && \host */
+	.endif	/* \ret */
 
 	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
 	popq	%r15
-- 
2.41.0

