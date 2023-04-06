Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3C6DA451
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 23:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbjDFVC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240516AbjDFVCO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 17:02:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89A97695;
        Thu,  6 Apr 2023 14:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3hwN/YQlmfu+j1gvDC0ozNOHSiaSepyoqpyTVyTKngc=; b=DUYMZP3I6MAIdN+RaNwDZ2GO2M
        5NAnKV9hWWYVWs/YitgvsXX6dYPXVrEmh2Zwb0IwaETdO29FjClCC3FbCdSijw6piJkmtoy4RhXpT
        k2SmpsJWtKgEe+bbcNekOFVcTYWimPIqglnBi7AagNQzuAmIl4rhHCXWD2xn2RQCU7ppq9ABLNJa+
        B14hrLYbBZTH32p5BAoxzhH/9/pyJg9I25GMEh5NkRCqumVuDlM70Z3KC9iCXscPjcJdXoXuy+xCy
        cPaXvFWTreAX9Y8z/N/bUupIxRySGoylhHq87LnPsGjZHI2PlXsJOO3Me86hbJOYd0BSR1aSOTsg5
        krH13tbQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pkWjO-00AfU4-35;
        Thu, 06 Apr 2023 21:01:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 92276300274;
        Thu,  6 Apr 2023 23:01:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 669982692D852; Thu,  6 Apr 2023 23:01:16 +0200 (CEST)
Date:   Thu, 6 Apr 2023 23:01:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 3/7] x86/entry: Implement atomic-IST-entry
Message-ID: <20230406210116.GG405948@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <20230403140605.540512-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140605.540512-4-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 10:06:01PM +0800, Lai Jiangshan wrote:

> diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
> index ca2fe186994b..7cc1254ca519 100644
> --- a/arch/x86/entry/Makefile
> +++ b/arch/x86/entry/Makefile
> @@ -8,11 +8,14 @@ UBSAN_SANITIZE := n
>  KCOV_INSTRUMENT := n
>  
>  CFLAGS_REMOVE_common.o		= $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_ist_entry.o	= $(CC_FLAGS_FTRACE) $(RETHUNK_CFLAGS)

This ^^^


> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 49ddc4dd3117..50a24cc83581 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -443,6 +443,184 @@ SYM_CODE_END(\asmsym)

> +.macro idtentry_ist vector asmsym cfunc user_cfunc has_error_code:req, stack_offset:req
> +SYM_CODE_START(\asmsym)
> +	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
> +	ENDBR
> +
> +	/*
> +	 * Clear X86_EFLAGS_AC, X86_EFLAGS_DF and set a default ORIG_RAX.
> +	 *
> +	 * The code setting ORIG_RAX will not be replicated if interrupted.
> +	 */
> +	ASM_CLAC
> +	cld
> +
> +	.if \has_error_code == 0
> +		pushq	$-1		/* ORIG_RAX: no syscall to restart */
> +	.endif
> +
> +	/*
> +	 * No register can be touched except %rsp,%rflags,%rip before
> +	 * pushing all the registers.  It is indispensable for nested
> +	 * atomic-IST-entry to replicate pushing the registers.
> +	 */
> +	PUSH_REGS
> +
> +	/*
> +	 * Finished pushing register, all registers can be touched by now.
> +	 *
> +	 * Clear registers for the C function ist_copy_regs_to_main_stack()
> +	 * and the handler to avoid any possible exploitation of any
> +	 * speculation attack.
> +	 */
> +	CLEAR_REGS
> +
> +	/*
> +	 * Copy the pt_regs to the IST main stack including the pt_regs of
> +	 * the interrupted atomic-IST-entris, if any, by replicating.
> +	 */
> +	movq	%rsp, %rdi				/* pt_regs pointer on its own IST stack */
> +	leaq	PTREGS_SIZE-\stack_offset(%rsp), %rsi	/* struct cea_exception_stacks pointer */
> +	call	ist_copy_regs_to_main_stack

IIUC you do a CALL+RET here, before you call paranoid_entry ...

> +
> +	/*
> +	 * Commit stage.
> +	 */
> +SYM_INNER_LABEL(start_commit_\asmsym, SYM_L_GLOBAL)
> +	/*
> +	 * Switches to the IST main stack.  Before the switching is done,
> +	 * %rax is the copied pt_regs pointer in IST main stack.
> +	 */
> +	movq	%rax, %rsp
> +
> +	/*
> +	 * The label should be immediate after the instruction that switches
> +	 * the stack since there is code assuming there is only one single
> +	 * instruction in the commit stage and the code assumes "%rsp in the
> +	 * IST main stack is also the sign of ending a atomic-IST-entry".
> +	 * (The code will be removed in future when %rip-based identifying
> +	 * is added.)
> +	 */
> +SYM_INNER_LABEL(commit_\asmsym, SYM_L_GLOBAL)
> +
> +	/*
> +	 * Now, it is on the IST main stack.  For the whole kernel, the entries
> +	 * of the IST exceptions can be seen from here because the inside
> +	 * of the atomic-IST-entry can not be seen from the whole kernel
> +	 * except in the atomic-IST-entry or #DF.
> +	 */
> +	UNWIND_HINT_REGS
> +	ENCODE_FRAME_POINTER
> +
> +	/*
> +	 * The code setting ORIG_RAX will not be replicated if interrupted.
> +	 * So redo it here.
> +	 */
> +	.if \has_error_code == 0
> +		movq	$-1, ORIG_RAX(%rsp)	/* ORIG_RAX: no syscall to restart */
> +	.endif
> +
> +	/*
> +	 * If the entry is from userspace, switch stacks and treat it as
> +	 * a normal entry.
> +	 */
> +	testb	$3, CS(%rsp)
> +	jnz	.Lfrom_usermode_switch_stack_\@
> +
> +	/*
> +	 * paranoid_entry returns GS/CR3/SPEC_CTL information for
> +	 * paranoid_exit in RBX/R14/R15.
> +	 */
> +	call	paranoid_entry

... all the way down here, which will do:

  IBRS_ENTER;
  UNTRAIN_RET_FROM_CALL;

Which thus breaks the whole RetBleed mess, since that must not do RET
before that happens.
