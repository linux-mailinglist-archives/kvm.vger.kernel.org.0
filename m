Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31A750228
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjGLI4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 04:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjGLI4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 04:56:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA431993;
        Wed, 12 Jul 2023 01:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689152163; x=1720688163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dQUJSU99KKlbHrc4ZNlpXglKGmrFI7B3CBl27zrZ6rU=;
  b=h19YC7hlMMbfCqwyJafUEPZSQVHakiPgsIJozpgv5EBixiQdYor5D16n
   P2DRBkv+wqa0Ynj6Z87adM+OUwgznIMhMdAhKf5eXVVPSpW0U4aI2X0Fx
   Xr2gMxyAVL6JmtQHSKPGnh1VvHkVnqL0DHS/17L3qvh1Mxg0TF/2VG1uR
   Ni1++Z9+HGMxzs4qKu7pUrV5UOIImQcOUx7GAHAm/9U1c4A4tPAfDLMvR
   rGYo0ccSWhzcpoLnZAieYcEga1C948ZubdY16cFrfFMBHanJJGtxARpsx
   sOEHjsz0uaQ4kYY7+qPH6+HdHtjAuRjeNDX2p3iqirdLP9XSqj4rgqMeC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="344439257"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="344439257"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:56:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="845573394"
X-IronPort-AV: E=Sophos;i="6.01,199,1684825200"; 
   d="scan'208";a="845573394"
Received: from mjamatan-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.168.102])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 01:55:59 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     peterz@infradead.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, kai.huang@intel.com
Subject: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more TDCALL/SEAMCALL leafs
Date:   Wed, 12 Jul 2023 20:55:21 +1200
Message-ID: <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
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

The TDX guest live migration support (TDX 1.5) adds new TDCALL/SEAMCALL
leaf functions.  Those new TDCALLs/SEAMCALLs take additional registers
for input (R10-R13) and output (R12-R13).  TDG.SERVTD.RD is an example.

Also, the current TDX_MODULE_CALL doesn't aim to handle TDH.VP.ENTER
SEAMCALL, which monitors the TDG.VP.VMCALL in input/output registers
when it returns in case of VMCALL from TDX guest.

With those new TDCALLs/SEAMCALLs and the TDH.VP.ENTER covered, the
TDX_MODULE_CALL macro basically needs to handle the same input/output
registers as the TDX_HYPERCALL does.  And as a result, they also share
similar logic in the assembly, thus should be unified to use one common
assembly.

Extend the TDX_MODULE_CALL asm to support the new TDCALLs/SEAMCALLs and
also the TDH.VP.ENTER SEAMCALL.  Eventually it will be unified with the
TDX_HYPERCALL.

The new input/output registers fit with the "callee-saved" registers in
the x86 calling convention.  Add a new "saved" parameter to support
those new TDCALLs/SEAMCALLs and TDH.VP.ENTER and keep the existing
TDCALLs/SEAMCALLs minimally impacted.

For TDH.VP.ENTER, after it returns the registers shared by the guest
contain guest's values.  Explicitly clear them to prevent speculative
use of guest's values.

Note most TDX live migration related SEAMCALLs may also clobber AVX*
state ("AVX, AVX2 and AVX512 state: may be reset to the architectural
INIT state" -- see TDH.EXPORT.MEM for example).  And TDH.VP.ENTER also
clobbers XMM0-XMM15 when the corresponding bit is set in RCX.  Don't
handle them in the TDX_MODULE_CALL macro but let the caller save and
restore when needed.

This is basically based on Peter's code.

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/coco/tdx/tdcall.S      |   4 +-
 arch/x86/include/asm/tdx.h      |  12 +++-
 arch/x86/kernel/asm-offsets.c   |   7 ++
 arch/x86/virt/vmx/tdx/tdxcall.S | 121 ++++++++++++++++++++++++++++++--
 4 files changed, 134 insertions(+), 10 deletions(-)

diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index 46847e85c372..d5693330ee9b 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -51,7 +51,7 @@
  * Return status of TDCALL via RAX.
  */
 SYM_FUNC_START(__tdcall)
-	TDX_MODULE_CALL host=0 ret=0
+	TDX_MODULE_CALL host=0 ret=0 saved=0
 SYM_FUNC_END(__tdcall)
 
 /*
@@ -66,7 +66,7 @@ SYM_FUNC_END(__tdcall)
  * Return status of TDCALL via RAX.
  */
 SYM_FUNC_START(__tdcall_ret)
-	TDX_MODULE_CALL host=0 ret=1
+	TDX_MODULE_CALL host=0 ret=1 saved=0
 SYM_FUNC_END(__tdcall_ret)
 
 /*
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e353c7ec5f24..a549bcc77f4f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -27,14 +27,22 @@
  * This is a software only structure and not part of the TDX module/VMM ABI.
  */
 struct tdx_module_args {
-	/* input/output */
+	/* callee-clobbered */
 	u64 rcx;
 	u64 rdx;
 	u64 r8;
 	u64 r9;
-	/* additional output */
+	/* extra callee-clobbered */
 	u64 r10;
 	u64 r11;
+	/* callee-saved + rdi/rsi */
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u64 rbx;
+	u64 rdi;
+	u64 rsi;
 };
 
 /*
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 50383bc46dd7..1581564a67b7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -74,6 +74,13 @@ static void __used common(void)
 	OFFSET(TDX_MODULE_r9,  tdx_module_args, r9);
 	OFFSET(TDX_MODULE_r10, tdx_module_args, r10);
 	OFFSET(TDX_MODULE_r11, tdx_module_args, r11);
+	OFFSET(TDX_MODULE_r12, tdx_module_args, r12);
+	OFFSET(TDX_MODULE_r13, tdx_module_args, r13);
+	OFFSET(TDX_MODULE_r14, tdx_module_args, r14);
+	OFFSET(TDX_MODULE_r15, tdx_module_args, r15);
+	OFFSET(TDX_MODULE_rbx, tdx_module_args, rbx);
+	OFFSET(TDX_MODULE_rdi, tdx_module_args, rdi);
+	OFFSET(TDX_MODULE_rsi, tdx_module_args, rsi);
 
 	BLANK();
 	OFFSET(TDX_HYPERCALL_r8,  tdx_hypercall_args, r8);
diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
index 0af1374ad8f5..389f4ec5eee8 100644
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -23,17 +23,25 @@
  *-------------------------------------------------------------------------
  * Input Registers:
  *
- * RAX                 - TDCALL/SEAMCALL Leaf number.
- * RCX,RDX,R8-R9       - TDCALL/SEAMCALL Leaf specific input registers.
+ * RAX                        - TDCALL/SEAMCALL Leaf number.
+ * RCX,RDX,RDI,RSI,RBX,R8-R15 - TDCALL/SEAMCALL Leaf specific input registers.
  *
  * Output Registers:
  *
- * RAX                 - TDCALL/SEAMCALL instruction error code.
- * RCX,RDX,R8-R11      - TDCALL/SEAMCALL Leaf specific output registers.
+ * RAX                        - TDCALL/SEAMCALL Leaf number.
+ * RCX,RDX,RDI,RSI,RBX,R8-R15 - TDCALL/SEAMCALL Leaf specific output registers.
  *
  *-------------------------------------------------------------------------
+ *
+ * So while the common core (RAX,RCX,RDX,R8-R11) fits nicely in the
+ * callee-clobbered registers and even leaves RDI,RSI free to act as a
+ * base pointer, some leafs (e.g., VP.ENTER) make a giant mess of things.
+ *
+ * For simplicity, assume that anything that needs the callee-saved regs
+ * also tramples on RDI,RSI.  This isn't strictly true, see for example
+ * TDH.EXPORT.MEM.
  */
-.macro TDX_MODULE_CALL host:req ret:req
+.macro TDX_MODULE_CALL host:req ret:req saved:req
 	FRAME_BEGIN
 
 	/* Move Leaf ID to RAX */
@@ -44,6 +52,37 @@
 	movq	TDX_MODULE_rdx(%rsi), %rdx
 	movq	TDX_MODULE_r8(%rsi), %r8
 	movq	TDX_MODULE_r9(%rsi), %r9
+	movq	TDX_MODULE_r10(%rsi), %r10
+	movq	TDX_MODULE_r11(%rsi), %r11
+
+	.if \saved
+	/*
+	 * Move additional input regs from the structure.  For simplicity
+	 * assume that anything needs the callee-saved regs also tramples
+	 * on %rdi/%rsi (see VP.ENTER).
+	 */
+	/* Save those callee-saved GPRs as mandated by the x86_64 ABI */
+	pushq	%rbx
+	pushq	%r12
+	pushq	%r13
+	pushq	%r14
+	pushq	%r15
+
+	movq	TDX_MODULE_r12(%rsi), %r12
+	movq	TDX_MODULE_r13(%rsi), %r13
+	movq	TDX_MODULE_r14(%rsi), %r14
+	movq	TDX_MODULE_r15(%rsi), %r15
+	movq	TDX_MODULE_rbx(%rsi), %rbx
+
+	.if \ret
+	/* Save the structure pointer as %rsi is about to be clobbered */
+	pushq	%rsi
+	.endif
+
+	movq	TDX_MODULE_rdi(%rsi), %rdi
+	/* %rsi needs to be done at last */
+	movq	TDX_MODULE_rsi(%rsi), %rsi
+	.endif	/* \saved */
 
 	.if \host
 	seamcall
@@ -65,6 +104,37 @@
 	.endif
 
 	.if \ret
+	.if \saved
+	/*
+	 * Restore the structure from stack to saved the output registers
+	 *
+	 * In case of VP.ENTER returns due to TDVMCALL, all registers are
+	 * valid thus no register can be used as spare to restore the
+	 * structure from the stack (see "TDH.VP.ENTER Output Operands
+	 * Definition on TDCALL(TDG.VP.VMCALL) Following a TD Entry").
+	 * For this case, need to make one register as spare by saving it
+	 * to the stack and then manually load the structure pointer to
+	 * the spare register.
+	 *
+	 * Note for other TDCALLs/SEAMCALLs there are spare registers
+	 * thus no need for such hack but just use this for all for now.
+	 */
+	pushq	%rax		/* save the TDCALL/SEAMCALL return code */
+	movq	8(%rsp), %rax	/* restore the structure pointer */
+	movq	%rsi, TDX_MODULE_rsi(%rax)	/* save %rsi */
+	movq	%rax, %rsi	/* use %rsi as structure pointer */
+	popq	%rax		/* restore the return code */
+	popq	%rsi		/* pop the structure pointer */
+
+	/* Copy additional output regs to the structure  */
+	movq %r12, TDX_MODULE_r12(%rsi)
+	movq %r13, TDX_MODULE_r13(%rsi)
+	movq %r14, TDX_MODULE_r14(%rsi)
+	movq %r15, TDX_MODULE_r15(%rsi)
+	movq %rbx, TDX_MODULE_rbx(%rsi)
+	movq %rdi, TDX_MODULE_rdi(%rsi)
+	.endif	/* \saved */
+
 	/* Copy output regs to the structure */
 	movq %rcx, TDX_MODULE_rcx(%rsi)
 	movq %rdx, TDX_MODULE_rdx(%rsi)
@@ -72,7 +142,46 @@
 	movq %r9,  TDX_MODULE_r9(%rsi)
 	movq %r10, TDX_MODULE_r10(%rsi)
 	movq %r11, TDX_MODULE_r11(%rsi)
-	.endif
+	.endif	/* \ret */
+
+	.if \saved
+	.if \ret && \host
+	/*
+	 * Clear registers shared by guest for VP.ENTER to prevent
+	 * speculative use of guest's values, including those are
+	 * restored from the stack.
+	 *
+	 * See arch/x86/kvm/vmx/vmenter.S:
+	 *
+	 * In theory, a L1 cache miss when restoring register from stack
+	 * could lead to speculative execution with guest's values.
+	 *
+	 * Note: RBP/RSP are not used as shared register.  RSI has been
+	 * restored already.
+	 *
+	 * XOR is cheap, thus unconditionally do for all leafs.
+	 */
+	xorq %rcx, %rcx
+	xorq %rdx, %rdx
+	xorq %r8,  %r8
+	xorq %r9,  %r9
+	xorq %r10, %r10
+	xorq %r11, %r11
+	xorq %r12, %r12
+	xorq %r13, %r13
+	xorq %r14, %r14
+	xorq %r15, %r15
+	xorq %rbx, %rbx
+	xorq %rdi, %rdi
+	.endif	/* \ret && \host */
+
+	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
+	popq	%r15
+	popq	%r14
+	popq	%r13
+	popq	%r12
+	popq	%rbx
+	.endif	/* \saved */
 
 	FRAME_END
 	RET
-- 
2.41.0

