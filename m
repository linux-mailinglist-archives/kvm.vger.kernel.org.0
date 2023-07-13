Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E323E751AD8
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbjGMIKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjGMIJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:09:42 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29266270F;
        Thu, 13 Jul 2023 01:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u0MMSF1BzosWHENbYjUkiziMMb6fnm98Zn1xzxHch2A=; b=GcPFOkaVfv+4rWtqRq8f5/Hg0C
        x759LYiWrisgCwDLlpY2O5kMsCKvp1CACLcajs6VC/SI7OkTmvqwKDH0vrQBiepAlY9dbKWyTGlq8
        DQ/mhqwAc/Gl9wFClxqPmww6pSrSVBG6ZxSn/f6lNnxdWTRaqr+sPiZc1EQ7tugcBDGY9kyPHGydj
        /Wk5qSXzPmrzLHH6tEYIXOMLDH7yPcp3rr1xelU5HdF+sgT6pT9iL94XLl9SZ76mCLXvhehQ6g/RD
        G3bjvsCIt/qZxgCUmGJuBeqOXvgC4nyfH7WnOt0yN8ntFD3SwIoDJqaRBzlsPjGsDoRdlNKwfbNHF
        7WbIj6pw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJrMY-004YHC-0d;
        Thu, 13 Jul 2023 08:07:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5AF54300222;
        Thu, 13 Jul 2023 10:07:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4476E266877EB; Thu, 13 Jul 2023 10:07:45 +0200 (CEST)
Date:   Thu, 13 Jul 2023 10:07:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org, isaku.yamahata@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH 10/10] x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
Message-ID: <20230713080745.GB3139243@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <d08c5e27dd7377564d69648f3eb7b56d3c95b84b.1689151537.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d08c5e27dd7377564d69648f3eb7b56d3c95b84b.1689151537.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 08:55:24PM +1200, Kai Huang wrote:
> @@ -85,6 +86,7 @@
>  	.endif	/* \saved */
>  
>  	.if \host
> +1:
>  	seamcall
>  	/*
>  	 * SEAMCALL instruction is essentially a VMExit from VMX root
> @@ -99,6 +101,7 @@
>  	 */
>  	mov $TDX_SEAMCALL_VMFAILINVALID, %rdi
>  	cmovc %rdi, %rax
> +2:
>  	.else
>  	tdcall
>  	.endif

This is just wrong, if the thing traps you should not do the return
registers. And at this point the mov/cmovc thing doesn't make much sense
either.

> @@ -185,4 +188,21 @@
>  
>  	FRAME_END
>  	RET
> +
> +	.if \host
> +3:
> +	/*
> +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> +	 * the trap number.  Convert the trap number to the TDX error
> +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
> +	 *
> +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
> +	 * only accepts 32-bit immediate at most.
> +	 */
> +	movq $TDX_SW_ERROR, %r12
> +	orq  %r12, %rax
> +	jmp  2b
> +
> +	_ASM_EXTABLE_FAULT(1b, 3b)
> +	.endif	/* \host */
>  .endm

Also, please used named labels where possible and *please* keep asm
directives unindented.


--- a/arch/x86/virt/vmx/tdx/tdxcall.S
+++ b/arch/x86/virt/vmx/tdx/tdxcall.S
@@ -56,7 +56,7 @@
 	movq	TDX_MODULE_r10(%rsi), %r10
 	movq	TDX_MODULE_r11(%rsi), %r11
 
-	.if \saved
+.if \saved
 	/*
 	 * Move additional input regs from the structure.  For simplicity
 	 * assume that anything needs the callee-saved regs also tramples
@@ -75,18 +75,18 @@
 	movq	TDX_MODULE_r15(%rsi), %r15
 	movq	TDX_MODULE_rbx(%rsi), %rbx
 
-	.if \ret
+.if \ret
 	/* Save the structure pointer as %rsi is about to be clobbered */
 	pushq	%rsi
-	.endif
+.endif
 
 	movq	TDX_MODULE_rdi(%rsi), %rdi
 	/* %rsi needs to be done at last */
 	movq	TDX_MODULE_rsi(%rsi), %rsi
-	.endif	/* \saved */
+.endif	/* \saved */
 
-	.if \host
-1:
+.if \host
+.Lseamcall:
 	seamcall
 	/*
 	 * SEAMCALL instruction is essentially a VMExit from VMX root
@@ -99,15 +99,13 @@
 	 * This value will never be used as actual SEAMCALL error code as
 	 * it is from the Reserved status code class.
 	 */
-	mov $TDX_SEAMCALL_VMFAILINVALID, %rdi
-	cmovc %rdi, %rax
-2:
-	.else
+	jc	.Lseamfail
+.else
 	tdcall
-	.endif
+.endif
 
-	.if \ret
-	.if \saved
+.if \ret
+.if \saved
 	/*
 	 * Restore the structure from stack to saved the output registers
 	 *
@@ -136,7 +134,7 @@
 	movq %r15, TDX_MODULE_r15(%rsi)
 	movq %rbx, TDX_MODULE_rbx(%rsi)
 	movq %rdi, TDX_MODULE_rdi(%rsi)
-	.endif	/* \saved */
+.endif	/* \saved */
 
 	/* Copy output regs to the structure */
 	movq %rcx, TDX_MODULE_rcx(%rsi)
@@ -145,10 +143,11 @@
 	movq %r9,  TDX_MODULE_r9(%rsi)
 	movq %r10, TDX_MODULE_r10(%rsi)
 	movq %r11, TDX_MODULE_r11(%rsi)
-	.endif	/* \ret */
+.endif	/* \ret */
 
-	.if \saved
-	.if \ret
+.Lout:
+.if \saved
+.if \ret
 	/*
 	 * Clear registers shared by guest for VP.ENTER and VP.VMCALL to
 	 * prevent speculative use of values from guest/VMM, including
@@ -170,13 +169,8 @@
 	xorq %r9,  %r9
 	xorq %r10, %r10
 	xorq %r11, %r11
-	xorq %r12, %r12
-	xorq %r13, %r13
-	xorq %r14, %r14
-	xorq %r15, %r15
-	xorq %rbx, %rbx
 	xorq %rdi, %rdi
-	.endif	/* \ret */
+.endif	/* \ret */
 
 	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
 	popq	%r15
@@ -184,13 +178,17 @@
 	popq	%r13
 	popq	%r12
 	popq	%rbx
-	.endif	/* \saved */
+.endif	/* \saved */
 
 	FRAME_END
 	RET
 
-	.if \host
-3:
+.if \host
+.Lseamfail:
+	mov	$TDX_SEAMCALL_VMFAILINVALID, %rax
+	jmp	.Lout
+
+.Lseamtrap:
 	/*
 	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
 	 * the trap number.  Convert the trap number to the TDX error
@@ -201,8 +199,8 @@
 	 */
 	movq $TDX_SW_ERROR, %r12
 	orq  %r12, %rax
-	jmp  2b
+	jmp .Lout
 
-	_ASM_EXTABLE_FAULT(1b, 3b)
-	.endif	/* \host */
+	_ASM_EXTABLE_FAULT(.Lseamcall, .Lseamtrap)
+.endif	/* \host */
 .endm
