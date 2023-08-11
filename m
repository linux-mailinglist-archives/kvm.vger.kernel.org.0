Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B80779613
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbjHKR2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbjHKR2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1530D7;
        Fri, 11 Aug 2023 10:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 122A261231;
        Fri, 11 Aug 2023 17:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FE8C433C7;
        Fri, 11 Aug 2023 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691774893;
        bh=Cbt4HG7vCUbmItNF5qMZySg8QnQ54QSDlQ6h4NUDREE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kG2VCt4ycGnc748iyJGlbNGZ7qFjvSjO3on0PdwXBy4dmpySywbD4Qv44+h8+Sus3
         4P4Edjl0mUnnudxsNdGnVmgxHRSJY5bI2b5Szt7QN8thk5SQM+F+wHxfE7PkYgwwOR
         68YX2xYJcbOapYlQ0jIMPDCBOb8CmRk67v2Fzy6I0nHeOBKhzIs8WKIjo7fOPQ0w5o
         mphC/NjCwHN26/xNLJwGsWvjuift+fk5BZ2GNqGxfuLdElRveX0p03/kM96fJlHO4k
         uLcSYpH/TO/WTBjHo1rJFq+Juos5hqvIi4ACA62Cdd+85Qwm2oTAelgDQ+1ZCxWRAx
         XVffzP+AGRiHw==
Date:   Fri, 11 Aug 2023 10:28:11 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Srikanth Aithal <sraithal@amd.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/retpoline: Don't clobber RFLAGS during
 srso_safe_ret()
Message-ID: <20230811172811.GA3551@dev-arch.thelio-3990X>
References: <20230811155255.250835-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811155255.250835-1-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 08:52:55AM -0700, Sean Christopherson wrote:
> Use 'lea' instead of 'add' when adjusting %rsp in srso_safe_ret() so as to
> avoid clobbering flags.  Drop one of the INT3 instructions to account for
> the LEA consuming one more byte than the ADD.
> 
> KVM's emulator makes indirect calls into a jump table of sorts, where
> the destination of each call is a small blob of code that performs fast
> emulation by executing the target instruction with fixed operands.
> 
> E.g. to emulate ADC, fastop() invokes adcb_al_dl():
> 
>   adcb_al_dl:
>       0xffffffff8105f5f0 <+0>:  adc    %dl,%al
>       0xffffffff8105f5f2 <+2>:  jmp    0xffffffff81a39270 <__x86_return_thunk>
> 
> A major motivation for doing fast emulation is to leverage the CPU to
> handle consumption and manipulation of arithmetic flags, i.e. RFLAGS is
> both an input and output to the target of the call.  fastop() collects
> the RFLAGS result by pushing RFLAGS onto the stack and popping them back
> into a variable (held in RDI in this case)
> 
>   asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
> 
>       0xffffffff81062be7 <+71>: mov    0xc0(%r8),%rdx
>       0xffffffff81062bee <+78>: mov    0x100(%r8),%rcx
>       0xffffffff81062bf5 <+85>: push   %rdi
>       0xffffffff81062bf6 <+86>: popf
>       0xffffffff81062bf7 <+87>: call   *%rsi
>       0xffffffff81062bf9 <+89>: nop
>       0xffffffff81062bfa <+90>: nop
>       0xffffffff81062bfb <+91>: nop
>       0xffffffff81062bfc <+92>: pushf
>       0xffffffff81062bfd <+93>: pop    %rdi
> 
> and then propagating the arithmetic flags into the vCPU's emulator state:
> 
>     ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
> 
>       0xffffffff81062be0 <+64>:  and    $0xfffffffffffff72a,%r9
>       0xffffffff81062bfe <+94>:  and    $0x8d5,%edi
>       0xffffffff81062c0d <+109>: or     %rdi,%r9
>       0xffffffff81062c1a <+122>: mov    %r9,0x10(%r8)
> 
> The failures can be most easily reproduced by running the "emulator" test
> in KVM-Unit-Tests.
> 
> If you're feeling a bit of deja vu, see commit b63f20a778c8
> ("x86/retpoline: Don't clobber RFLAGS during CALL_NOSPEC on i386").
> 
> Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Closes: https://lore.kernel.org/all/de474347-122d-54cd-eabf-9dcc95ab9eae@amd.com
> Cc: stable@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This resolves the issue I reported at [1].

Tested-by: Nathan Chancellor <nathan@kernel.org>

[1]: https://lore.kernel.org/20230810013334.GA5354@dev-arch.thelio-3990X/

> ---
> 
> Those that fail to learn from history are doomed to repeat it. :-D
> 
>  arch/x86/lib/retpoline.S | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
> index 2cff585f22f2..132cedbf9e57 100644
> --- a/arch/x86/lib/retpoline.S
> +++ b/arch/x86/lib/retpoline.S
> @@ -164,7 +164,7 @@ __EXPORT_THUNK(srso_untrain_ret_alias)
>  /* Needs a definition for the __x86_return_thunk alternative below. */
>  SYM_START(srso_safe_ret_alias, SYM_L_GLOBAL, SYM_A_NONE)
>  #ifdef CONFIG_CPU_SRSO
> -	add $8, %_ASM_SP
> +	lea 8(%_ASM_SP), %_ASM_SP
>  	UNWIND_HINT_FUNC
>  #endif
>  	ANNOTATE_UNRET_SAFE
> @@ -239,7 +239,7 @@ __EXPORT_THUNK(zen_untrain_ret)
>   * SRSO untraining sequence for Zen1/2, similar to zen_untrain_ret()
>   * above. On kernel entry, srso_untrain_ret() is executed which is a
>   *
> - * movabs $0xccccccc308c48348,%rax
> + * movabs $0xccccc30824648d48,%rax
>   *
>   * and when the return thunk executes the inner label srso_safe_ret()
>   * later, it is a stack manipulation and a RET which is mispredicted and
> @@ -252,11 +252,10 @@ SYM_START(srso_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
>  	.byte 0x48, 0xb8
>  
>  SYM_INNER_LABEL(srso_safe_ret, SYM_L_GLOBAL)
> -	add $8, %_ASM_SP
> +	lea 8(%_ASM_SP), %_ASM_SP
>  	ret
>  	int3
>  	int3
> -	int3
>  	lfence
>  	call srso_safe_ret
>  	int3
> 
> base-commit: 25aa0bebba72b318e71fe205bfd1236550cc9534
> -- 
> 2.41.0.694.ge786442a9b-goog
> 
