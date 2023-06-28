Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137E1741A88
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjF1VSY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjF1VSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:18:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFDA49E5;
        Wed, 28 Jun 2023 14:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5/5E/q891FPrZXtv6YcYhx0Ywlrki0OCdkRs4r+cVyY=; b=EcWKAFtGBRx80YkIPVc+d1lYqx
        u9sTJpsPvYlmVvp3DNEdiej2s8kn063PSWfmoZp2a5UckZ3VWHb4ijja9H5BrikO09UbWjnYHHb9o
        o2sPLUbf6lH7eG7aWGwe6n2eyzT6plk6LnOjkcTgC1tiolGBlZum/uzbGH7NKkEDjifywKLmJgCTS
        u/zslIX2v0d2y8wgt1PqV65xOyZ3gJUmBacBgzJXrRfCB6N7UptL/iG2wULGLzTSxR/Jm+JmlpRc1
        tY6KHbW927uet/cd5Zli6unvR1G1kGE09D5Fe3hzBoxalUEmqvjs4/yCP4/h/qKsNcoXDJqMHp3ow
        R+IqOj0w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qEcRp-004Dmh-Oo; Wed, 28 Jun 2023 21:11:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 770EB30057E;
        Wed, 28 Jun 2023 23:11:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 55FFE2481AF33; Wed, 28 Jun 2023 23:11:32 +0200 (CEST)
Date:   Wed, 28 Jun 2023 23:11:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230628211132.GS38236@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628203823.GR38236@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 10:38:23PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 28, 2023 at 05:29:01PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > index 49a54356ae99..757b0c34be10 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> > > +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> > > @@ -1,6 +1,7 @@
> > >  /* SPDX-License-Identifier: GPL-2.0 */
> > >  #include <asm/asm-offsets.h>
> > >  #include <asm/tdx.h>
> > > +#include <asm/asm.h>
> > >  
> > >  /*
> > >   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> > > @@ -45,6 +46,7 @@
> > >  	/* Leave input param 2 in RDX */
> > >  
> > >  	.if \host
> > > +1:
> > >  	seamcall
> > 
> > So what registers are actually clobbered by SEAMCALL ? There's a
> > distinct lack of it in SDM Vol.2 instruction list :-(
> 
> With the exception of the abomination that is TDH.VP.ENTER all SEAMCALLs
> seem to be limited to the set presented here (c,d,8,9,10,11) and all
> other registers should be available.
> 
> Can we please make that a hard requirement, SEAMCALL must not use
> registers outside this? We can hardly program to random future
> extentions; we need hard ABI guarantees here.
> 
> That also means we should be able to use si,di for the cmovc below.
> 
> Kirill, back when we did __tdx_hypercall() we got bp removed as a valid
> register, the 1.0 spec still lists that, and it is also listed in
> TDH.VP.ENTER, I'm assuming it will be removed there too?
> 
> bp must not be used -- it violates the pre-existing calling convention.

How's this then? Utterly untested. Not been near a compiler even.

--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -109,10 +109,26 @@ EXPORT_SYMBOL_GPL(tdx_kvm_hypercall);
  * should only be used for calls that have no legitimate reason to fail
  * or where the kernel can not survive the call failing.
  */
-static inline void tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-				   struct tdx_module_output *out)
+static inline void _tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9)
 {
-	if (__tdx_module_call(fn, rcx, rdx, r8, r9, out))
+	struct tdx_module_args args = {
+		.rcx = rcx,
+		.rdx = rdx,
+		.r8  = r8,
+		.r9  = r9,
+	};
+	return __tdx_module_call(fn, &args);
+}
+
+static inline void tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9)
+{
+	if (_tdx_module_call(fn, rcx, rdx, r8, r9))
+		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
+}
+
+static inline void tdx_module_call_ret(u64 fn, struct tdx_module_args *args)
+{
+	if (__tdx_module_call(fn, args))
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
@@ -134,9 +150,9 @@ int tdx_mcall_get_report0(u8 *reportdata
 {
 	u64 ret;
 
-	ret = __tdx_module_call(TDX_GET_REPORT, virt_to_phys(tdreport),
-				virt_to_phys(reportdata), TDREPORT_SUBTYPE_0,
-				0, NULL);
+	ret = _tdx_module_call(TDX_GET_REPORT,
+			       virt_to_phys(tdreport), virt_to_phys(reportdata),
+			       TDREPORT_SUBTYPE_0, 0);
 	if (ret) {
 		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
 			return -EINVAL;
@@ -184,7 +200,7 @@ static void __noreturn tdx_panic(const c
 
 static void tdx_parse_tdinfo(u64 *cc_mask)
 {
-	struct tdx_module_output out;
+	struct tdx_module_args args = {};
 	unsigned int gpa_width;
 	u64 td_attr;
 
@@ -195,7 +211,7 @@ static void tdx_parse_tdinfo(u64 *cc_mas
 	 * Guest-Host-Communication Interface (GHCI), section 2.4.2 TDCALL
 	 * [TDG.VP.INFO].
 	 */
-	tdx_module_call(TDX_GET_INFO, 0, 0, 0, 0, &out);
+	tdx_module_call_ret(TDX_GET_INFO, &args);
 
 	/*
 	 * The highest bit of a guest physical address is the "sharing" bit.
@@ -204,7 +220,7 @@ static void tdx_parse_tdinfo(u64 *cc_mas
 	 * The GPA width that comes out of this call is critical. TDX guests
 	 * can not meaningfully run without it.
 	 */
-	gpa_width = out.rcx & GENMASK(5, 0);
+	gpa_width = args.rcx & GENMASK(5, 0);
 	*cc_mask = BIT_ULL(gpa_width - 1);
 
 	/*
@@ -212,7 +228,7 @@ static void tdx_parse_tdinfo(u64 *cc_mas
 	 * memory.  Ensure that no #VE will be delivered for accesses to
 	 * TD-private memory.  Only VMM-shared memory (MMIO) will #VE.
 	 */
-	td_attr = out.rdx;
+	td_attr = args.rdx;
 	if (!(td_attr & ATTR_SEPT_VE_DISABLE)) {
 		const char *msg = "TD misconfiguration: SEPT_VE_DISABLE attribute must be set.";
 
@@ -620,7 +636,7 @@ __init bool tdx_early_handle_ve(struct p
 
 void tdx_get_ve_info(struct ve_info *ve)
 {
-	struct tdx_module_output out;
+	struct tdx_module_args args = {};
 
 	/*
 	 * Called during #VE handling to retrieve the #VE info from the
@@ -637,15 +653,15 @@ void tdx_get_ve_info(struct ve_info *ve)
 	 * Note, the TDX module treats virtual NMIs as inhibited if the #VE
 	 * valid flag is set. It means that NMI=>#VE will not result in a #DF.
 	 */
-	tdx_module_call(TDX_GET_VEINFO, 0, 0, 0, 0, &out);
+	tdx_module_call_ret(TDX_GET_VEINFO, &args);
 
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
@@ -779,7 +795,7 @@ static bool try_accept_one(phys_addr_t *
 	}
 
 	tdcall_rcx = *start | page_size;
-	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
+	if (_tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0))
 		return false;
 
 	*start += accept_size;
@@ -857,7 +873,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdx_module_call(TDX_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
+	tdx_module_call(TDX_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -37,7 +37,7 @@
  *
  * This is a software only structure and not part of the TDX module/VMM ABI.
  */
-struct tdx_module_output {
+struct tdx_module_args {
 	u64 rcx;
 	u64 rdx;
 	u64 r8;
@@ -67,8 +67,8 @@ struct ve_info {
 void __init tdx_early_init(void);
 
 /* Used to communicate with the TDX module */
-u64 __tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-		      struct tdx_module_output *out);
+u64 __tdx_module_call(u64 fn, struct tdx_module_args *args);
+u64 __tdx_module_call_ret(u64 fn, struct tdx_module_args *args);
 
 void tdx_get_ve_info(struct ve_info *ve);
 
--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -17,37 +17,44 @@
  *            TDX module and hypercalls to the VMM.
  * SEAMCALL - used by TDX hosts to make requests to the
  *            TDX module.
+ *
+ *-------------------------------------------------------------------------
+ * TDCALL/SEAMCALL ABI:
+ *-------------------------------------------------------------------------
+ * Input Registers:
+ *
+ * RAX                 - TDCALL Leaf number.
+ * RCX,RDX,R8-R9       - TDCALL Leaf specific input registers.
+ *
+ * Output Registers:
+ *
+ * RAX                 - TDCALL instruction error code.
+ * RCX,RDX,R8-R11      - TDCALL Leaf specific output registers.
+ *
+ *-------------------------------------------------------------------------
+ *
+ * __tdx_module_call() function ABI:
+ *
+ * @fn   (RDI)         - TDCALL Leaf ID,    moved to RAX
+ * @regs (RSI)         - struct tdx_regs pointer
+ *
+ * Return status of TDCALL via RAX.
  */
-.macro TDX_MODULE_CALL host:req
-	/*
-	 * R12 will be used as temporary storage for struct tdx_module_output
-	 * pointer. Since R12-R15 registers are not used by TDCALL/SEAMCALL
-	 * services supported by this function, it can be reused.
-	 */
+.macro TDX_MODULE_CALL host:req ret:req
+	FRAME_BEGIN
 
-	/* Callee saved, so preserve it */
-	push %r12
+	mov	%rdi, %rax
+	mov	$TDX_SEAMCALL_VMFAILINVALID, %rdi
 
-	/*
-	 * Push output pointer to stack.
-	 * After the operation, it will be fetched into R12 register.
-	 */
-	push %r9
+	mov	TDX_MODULE_rcx(%rsi), %rcx
+	mov	TDX_MODULE_rdx(%rsi), %rdx
+	mov	TDX_MODULE_r8(%rsi),  %r8
+	mov	TDX_MODULE_r9(%rsi),  %r9
+//	mov	TDX_MODULE_r10(%rsi), %r10
+//	mov	TDX_MODULE_r11(%rsi), %r11
 
-	/* Mangle function call ABI into TDCALL/SEAMCALL ABI: */
-	/* Move Leaf ID to RAX */
-	mov %rdi, %rax
-	/* Move input 4 to R9 */
-	mov %r8,  %r9
-	/* Move input 3 to R8 */
-	mov %rcx, %r8
-	/* Move input 1 to RCX */
-	mov %rsi, %rcx
-	/* Leave input param 2 in RDX */
-
-	.if \host
-1:
-	seamcall
+.if \host
+1:	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
 	 * mode to SEAM VMX root mode.  VMfailInvalid (CF=1) indicates
@@ -59,53 +66,30 @@
 	 * This value will never be used as actual SEAMCALL error code as
 	 * it is from the Reserved status code class.
 	 */
-	jnc .Lseamcall_out
-	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
-	jmp .Lseamcall_out
+	cmovc	%rdi, %rax
 2:
-	/*
-	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
-	 * the trap number.  Convert the trap number to the TDX error
-	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
-	 *
-	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
-	 * only accepts 32-bit immediate at most.
-	 */
-	mov $TDX_SW_ERROR, %r12
-	orq %r12, %rax
-
-	_ASM_EXTABLE_FAULT(1b, 2b)
-.Lseamcall_out:
-	.else
+.else
 	tdcall
-	.endif
-
-	/*
-	 * Fetch output pointer from stack to R12 (It is used
-	 * as temporary storage)
-	 */
-	pop %r12
+.endif
 
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
+.if \ret
+	movq %rcx, TDX_MODULE_rcx(%rsi)
+	movq %rdx, TDX_MODULE_rdx(%rsi)
+	movq %r8,  TDX_MODULE_r8(%rsi)
+	movq %r9,  TDX_MODULE_r9(%rsi)
+	movq %r10, TDX_MODULE_r10(%rsi)
+	movq %r11, TDX_MODULE_r11(%rsi)
+.endif
+
+	FRAME_END
+	RET
+
+.if \host
+3:
+	mov	$TDX_SW_ERROR, %rdi
+	or	%rdi, %rax
+	jmp 2b
 
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
+	_ASM_EXTABLE_FAULT(1b, 3b)
+.endif
 .endm
