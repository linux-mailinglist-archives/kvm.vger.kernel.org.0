Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B39B750226
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjGLI4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjGLI4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:56:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0641BFA;
        Wed, 12 Jul 2023 01:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152160; x=1720688160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jmIeDORn+BMdd9A4WMNT2APZizZ1It678+a9F5J7Dg=;
  b=O9IKDU/8Yy0L117tuTVhNIaBLP8cbbnbvv1cEtX4wmT9dPI5086upInE
   dvvjKCSb8Jk252unvrvQKjbKGg7H8knVHGRdxrDIFGPUpJxuPNo3xIPRD
   knZWARaOctkt8R7gfCT7cYxQUX1fvXJxu97m9CZ7qaJ5kYKWK+wOnlVdJ
   3baxMCpv2Ae3OVAv1P3i1aLLkx3YO7hzUFcI8HBSZC40tC+iQkLyFut5z
   IE2DS930yLTN1FuUx/MFJq+v7SsBKECCu58HeFC7WdnMORZ9Cng2OEOeE
   UtA6Z6IFDoFaJAsMrDPz9OLPlXoN6FM1gfx8atytaSMpOQP1PGDYBBOoo
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439223"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439223"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573387"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573387"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:55 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 06/10] x86/tdx: Pass TDCALL/SEAMCALL input/output registers via a structure
Date:   Wed, 12 Jul 2023 20:55:20 +1200
Message-ID: <b9271899586f5e0f5e028ff69d8f55e9b1b792a6.1689151537.git.kai.huang@intel.com>
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

Currently, the TDX_MODULE_CALL asm macro, which handles both TDCALL and
SEAMCALL, takes one parameter for each input register and an optional
'struct tdx_module_output' (a collection of output registers) as output.
This is different from the TDX_HYPERCALL macro which uses a single
'struct tdx_hypercall_args' to carry all input/output registers.

The newer TDX versions introduce more TDCALLs/SEAMCALLs which use more
input/output registers.  Also, the TDH.VP.ENTER (which isn't covered
by the current TDX_MODULE_CALL macro) basically can use all registers
that the TDX_HYPERCALL does.  The current TDX_MODULE_CALL macro isn't
extendible to cover those cases.

Similar to the TDX_HYPERCALL macro, simplify the TDX_MODULE_CALL macro
to use a single structure 'struct tdx_module_args' to carry all the
input/output registers.

Currently, the TDX_MODULE_CALL macro depends on the caller to pass a
non-NULL 'struct tdx_module_output' to get additional output registers.
Similar to the TDX_HYPERCALL macro, change the TDX_MODULE_CALL macro to
take a new 'ret' parameter to indicate whether to save the additional
output registers to the 'struct tdx_module_args'.  Also introduce a new
__tdcall_ret() for that purpose, similar to the __tdx_hypercall_ret().

Note the tdcall(), which is a wrapper of __tdcall(), is called by three
callers: tdx_parse_tdinfo(), tdx_get_ve_info() and tdx_early_init().
The former two need the additional output but the last one doesn't.  For
simplicity, make tdcall() always call __tdcall_ret() to avoid another
"_ret()" wrapper.  The last caller tdx_early_init() isn't performance
critical anyway.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/tdx/tdcall.S      | 48 ++++++++-----------
 arch/x86/coco/tdx/tdx.c         | 50 +++++++++++---------
 arch/x86/include/asm/tdx.h      | 10 ++--
 arch/x86/kernel/asm-offsets.c   | 12 ++---
 arch/x86/virt/vmx/tdx/tdxcall.S | 82 +++++++++++++--------------------
 5 files changed, 89 insertions(+), 113 deletions(-)

diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index 6aebac08f2bf..46847e85c372 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -43,44 +43,32 @@
  * __tdcall()  - Used by TDX guests to request services from the TDX
  * module (does not include VMM services) using TDCALL instruction.
  *
- * Transforms function call register arguments into the TDCALL register ABI.
- * After TDCALL operation, TDX module output is saved in @out (if it is
- * provided by the user).
- *
- *-------------------------------------------------------------------------
- * TDCALL ABI:
- *-------------------------------------------------------------------------
- * Input Registers:
- *
- * RAX                 - TDCALL Leaf number.
- * RCX,RDX,R8-R9       - TDCALL Leaf specific input registers.
- *
- * Output Registers:
- *
- * RAX                 - TDCALL instruction error code.
- * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
- *
- *-------------------------------------------------------------------------
- *
  * __tdcall() function ABI:
  *
- * @fn  (RDI)          - TDCALL Leaf ID,    moved to RAX
- * @rcx (RSI)          - Input parameter 1, moved to RCX
- * @rdx (RDX)          - Input parameter 2, moved to RDX
- * @r8  (RCX)          - Input parameter 3, moved to R8
- * @r9  (R8)           - Input parameter 4, moved to R9
- *
- * @out (R9)           - struct tdx_module_output pointer
- *                       stored temporarily in R12 (not
- *                       shared with the TDX module). It
- *                       can be NULL.
+ * @fn   (RDI)          - TDCALL Leaf ID, moved to RAX
+ * @args (RSI)          - struct tdx_module_args for input
  *
  * Return status of TDCALL via RAX.
  */
 SYM_FUNC_START(__tdcall)
-	TDX_MODULE_CALL host=0
+	TDX_MODULE_CALL host=0 ret=0
 SYM_FUNC_END(__tdcall)
 
+/*
+ * __tdcall_ret() - Used by TDX guests to request services from the TDX
+ * module (does not include VMM services) using TDCALL instruction.
+ *
+ * __tdcall_ret() function ABI:
+ *
+ * @fn   (RDI)          - TDCALL Leaf ID, moved to RAX
+ * @args (RSI)          - struct tdx_module_args for input and output
+ *
+ * Return status of TDCALL via RAX.
+ */
+SYM_FUNC_START(__tdcall_ret)
+	TDX_MODULE_CALL host=0 ret=1
+SYM_FUNC_END(__tdcall_ret)
+
 /*
  * TDX_HYPERCALL - Make hypercalls to a TDX VMM using TDVMCALL leaf of TDCALL
  * instruction
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 268f812ff595..0f16ba52ae62 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -98,10 +98,9 @@ EXPORT_SYMBOL_GPL(tdx_kvm_hypercall);
  * should only be used for calls that have no legitimate reason to fail
  * or where the kernel can not survive the call failing.
  */
-static inline void tdcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-			  struct tdx_module_output *out)
+static inline void tdcall(u64 fn, struct tdx_module_args *args)
 {
-	if (__tdcall(fn, rcx, rdx, r8, r9, out))
+	if (__tdcall_ret(fn, args))
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
@@ -121,11 +120,14 @@ static inline void tdcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
  */
 int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
 {
+	struct tdx_module_args args = {
+		.rcx = virt_to_phys(tdreport),
+		.rdx = virt_to_phys(reportdata),
+		.r8 = TDREPORT_SUBTYPE_0,
+	};
 	u64 ret;
 
-	ret = __tdcall(TDG_MR_REPORT, virt_to_phys(tdreport),
-			virt_to_phys(reportdata), TDREPORT_SUBTYPE_0,
-			0, NULL);
+	ret = __tdcall(TDG_MR_REPORT, &args);
 	if (ret) {
 		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
 			return -EINVAL;
@@ -173,7 +175,7 @@ static void __noreturn tdx_panic(const char *msg)
 
 static void tdx_parse_tdinfo(u64 *cc_mask)
 {
-	struct tdx_module_output out;
+	struct tdx_module_args args = {};
 	unsigned int gpa_width;
 	u64 td_attr;
 
@@ -184,7 +186,7 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	 * Guest-Host-Communication Interface (GHCI), section 2.4.2 TDCALL
 	 * [TDG.VP.INFO].
 	 */
-	tdcall(TDG_VP_INFO, 0, 0, 0, 0, &out);
+	tdcall(TDG_VP_INFO, &args);
 
 	/*
 	 * The highest bit of a guest physical address is the "sharing" bit.
@@ -193,7 +195,7 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	 * The GPA width that comes out of this call is critical. TDX guests
 	 * can not meaningfully run without it.
 	 */
-	gpa_width = out.rcx & GENMASK(5, 0);
+	gpa_width = args.rcx & GENMASK(5, 0);
 	*cc_mask = BIT_ULL(gpa_width - 1);
 
 	/*
@@ -201,7 +203,7 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	 * memory.  Ensure that no #VE will be delivered for accesses to
 	 * TD-private memory.  Only VMM-shared memory (MMIO) will #VE.
 	 */
-	td_attr = out.rdx;
+	td_attr = args.rdx;
 	if (!(td_attr & ATTR_SEPT_VE_DISABLE)) {
 		const char *msg = "TD misconfiguration: SEPT_VE_DISABLE attribute must be set.";
 
@@ -609,7 +611,7 @@ __init bool tdx_early_handle_ve(struct pt_regs *regs)
 
 void tdx_get_ve_info(struct ve_info *ve)
 {
-	struct tdx_module_output out;
+	struct tdx_module_args args = {};
 
 	/*
 	 * Called during #VE handling to retrieve the #VE info from the
@@ -626,15 +628,15 @@ void tdx_get_ve_info(struct ve_info *ve)
 	 * Note, the TDX module treats virtual NMIs as inhibited if the #VE
 	 * valid flag is set. It means that NMI=>#VE will not result in a #DF.
 	 */
-	tdcall(TDG_VP_VEINFO_GET, 0, 0, 0, 0, &out);
+	tdcall(TDG_VP_VEINFO_GET, &args);
 
 	/* Transfer the output parameters */
-	ve->exit_reason = out.rcx;
-	ve->exit_qual   = out.rdx;
-	ve->gla         = out.r8;
-	ve->gpa         = out.r9;
-	ve->instr_len   = lower_32_bits(out.r10);
-	ve->instr_info  = upper_32_bits(out.r10);
+	ve->exit_reason = args.rcx;
+	ve->exit_qual   = args.rdx;
+	ve->gla         = args.r8;
+	ve->gpa         = args.r9;
+	ve->instr_len   = lower_32_bits(args.r10);
+	ve->instr_info  = upper_32_bits(args.r10);
 }
 
 /*
@@ -738,7 +740,7 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 			  enum pg_level pg_level)
 {
 	unsigned long accept_size = page_level_size(pg_level);
-	u64 tdcall_rcx;
+	struct tdx_module_args args = {};
 	u8 page_size;
 
 	if (!IS_ALIGNED(*start, accept_size))
@@ -767,8 +769,8 @@ static bool try_accept_one(phys_addr_t *start, unsigned long len,
 		return false;
 	}
 
-	tdcall_rcx = *start | page_size;
-	if (__tdcall(TDG_MEM_PAGE_ACCEPT, tdcall_rcx, 0, 0, 0, NULL))
+	args.rcx = *start | page_size;
+	if (__tdcall(TDG_MEM_PAGE_ACCEPT, &args))
 		return false;
 
 	*start += accept_size;
@@ -855,6 +857,10 @@ static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
 
 void __init tdx_early_init(void)
 {
+	struct tdx_module_args args = {
+		.rdx = TDCS_NOTIFY_ENABLES,
+		.r9 = -1ULL,
+	};
 	u64 cc_mask;
 	u32 eax, sig[3];
 
@@ -870,7 +876,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdcall(TDG_VM_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
+	tdcall(TDG_VM_WR, &args);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f19e329c4044..e353c7ec5f24 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -21,16 +21,18 @@
 #ifndef __ASSEMBLY__
 
 /*
- * Used to gather the output registers values of the TDCALL and SEAMCALL
+ * Used to gather input/output registers of the TDCALL and SEAMCALL
  * instructions when requesting services from the TDX module.
  *
  * This is a software only structure and not part of the TDX module/VMM ABI.
  */
-struct tdx_module_output {
+struct tdx_module_args {
+	/* input/output */
 	u64 rcx;
 	u64 rdx;
 	u64 r8;
 	u64 r9;
+	/* additional output */
 	u64 r10;
 	u64 r11;
 };
@@ -56,8 +58,8 @@ struct ve_info {
 void __init tdx_early_init(void);
 
 /* Used to communicate with the TDX module */
-u64 __tdcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-	     struct tdx_module_output *out);
+u64 __tdcall(u64 fn, struct tdx_module_args *args);
+u64 __tdcall_ret(u64 fn, struct tdx_module_args *args);
 
 void tdx_get_ve_info(struct ve_info *ve);
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index dc3576303f1a..50383bc46dd7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -68,12 +68,12 @@ static void __used common(void)
 #endif
 
 	BLANK();
-	OFFSET(TDX_MODULE_rcx, tdx_module_output, rcx);
-	OFFSET(TDX_MODULE_rdx, tdx_module_output, rdx);
-	OFFSET(TDX_MODULE_r8,  tdx_module_output, r8);
-	OFFSET(TDX_MODULE_r9,  tdx_module_output, r9);
-	OFFSET(TDX_MODULE_r10, tdx_module_output, r10);
-	OFFSET(TDX_MODULE_r11, tdx_module_output, r11);
+	OFFSET(TDX_MODULE_rcx, tdx_module_args, rcx);
+	OFFSET(TDX_MODULE_rdx, tdx_module_args, rdx);
+	OFFSET(TDX_MODULE_r8,  tdx_module_args, r8);
+	OFFSET(TDX_MODULE_r9,  tdx_module_args, r9);
+	OFFSET(TDX_MODULE_r10, tdx_module_args, r10);
+	OFFSET(TDX_MODULE_r11, tdx_module_args, r11);
 
 	BLANK();
 	OFFSET(TDX_HYPERCALL_r8,  tdx_hypercall_args, r8);
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index b5ab919c7fa8..0af1374ad8f5 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -17,34 +17,33 @@
  *            TDX module and hypercalls to the VMM.
  * SEAMCALL - used by TDX hosts to make requests to the
  *            TDX module.
+ *
+ *-------------------------------------------------------------------------
+ * TDCALL/SEAMCALL ABI:
+ *-------------------------------------------------------------------------
+ * Input Registers:
+ *
+ * RAX                 - TDCALL/SEAMCALL Leaf number.
+ * RCX,RDX,R8-R9       - TDCALL/SEAMCALL Leaf specific input registers.
+ *
+ * Output Registers:
+ *
+ * RAX                 - TDCALL/SEAMCALL instruction error code.
+ * RCX,RDX,R8-R11      - TDCALL/SEAMCALL Leaf specific output registers.
+ *
+ *-------------------------------------------------------------------------
  */
-.macro TDX_MODULE_CALL host:req
+.macro TDX_MODULE_CALL host:req ret:req
 	FRAME_BEGIN
-	/*
-	 * R12 will be used as temporary storage for struct tdx_module_output
-	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
-	 * services supported by this function, it can be reused.
-	 */
 
-	/* Callee saved, so preserve it */
-	push %r12
-
-	/*
-	 * Push output pointer to stack.
-	 * After the operation, it will be fetched into R12 register.
-	 */
-	push %r9
-
-	/* Mangle function call ABI into TDCALL/SEAMCALL ABI: */
 	/* Move Leaf ID to RAX */
 	mov %rdi, %rax
-	/* Move input 4 to R9 */
-	mov %r8,  %r9
-	/* Move input 3 to R8 */
-	mov %rcx, %r8
-	/* Move input 1 to RCX */
-	mov %rsi, %rcx
-	/* Leave input param 2 in RDX */
+
+	/* Move other input regs from 'struct tdx_module_args' */
+	movq	TDX_MODULE_rcx(%rsi), %rcx
+	movq	TDX_MODULE_rdx(%rsi), %rdx
+	movq	TDX_MODULE_r8(%rsi), %r8
+	movq	TDX_MODULE_r9(%rsi), %r9
 
 	.if \host
 	seamcall
@@ -65,34 +64,15 @@
 	tdcall
 	.endif
 
-	/*
-	 * Fetch output pointer from stack to R12 (It is used
-	 * as temporary storage)
-	 */
-	pop %r12
-
-	/*
-	 * Since this macro can be invoked with NULL as an output pointer,
-	 * check if caller provided an output struct before storing output
-	 * registers.
-	 *
-	 * Update output registers, even if the call failed (RAX != 0).
-	 * Other registers may contain details of the failure.
-	 */
-	test %r12, %r12
-	jz .Lno_output_struct
-
-	/* Copy result registers to output struct: */
-	movq %rcx, TDX_MODULE_rcx(%r12)
-	movq %rdx, TDX_MODULE_rdx(%r12)
-	movq %r8,  TDX_MODULE_r8(%r12)
-	movq %r9,  TDX_MODULE_r9(%r12)
-	movq %r10, TDX_MODULE_r10(%r12)
-	movq %r11, TDX_MODULE_r11(%r12)
-
-.Lno_output_struct:
-	/* Restore the state of R12 register */
-	pop %r12
+	.if \ret
+	/* Copy output regs to the structure */
+	movq %rcx, TDX_MODULE_rcx(%rsi)
+	movq %rdx, TDX_MODULE_rdx(%rsi)
+	movq %r8,  TDX_MODULE_r8(%rsi)
+	movq %r9,  TDX_MODULE_r9(%rsi)
+	movq %r10, TDX_MODULE_r10(%rsi)
+	movq %r11, TDX_MODULE_r11(%rsi)
+	.endif
 
 	FRAME_END
 	RET
-- 
2.41.0

