Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEEE670E86
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjARAWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjARAWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:22:06 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E6758662
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 15:36:51 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso13937517pjb.6
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 15:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HaUGak2G7cecQv8T9ZdGOoPgbZOZkSx+mC6eBv9kBwQ=;
        b=lfQu6S8OD/g3UTfppdNZjL3V+WH3TrKQ3gxxL1Q4rD8vS+gFz+IU4eah9iTT39t2XG
         1LUE4PY0gteSGFE5jDLQw4hvN6ykTZMti7nj0ZbzzxfGGRrXQpafvvi3aUwDOzfWbmR5
         HKSuPwIwoffbU9hbC79l8nD1r0LcZmvXbLlb2SP0m8NuIsmhJkVio6VQwnbFqLXkkGG8
         pzCB5yz+fTfX0bEtGkTKHuVVxnI18g3A720m6xyJnYItcvOMyHWutJjABIwsqHM9B//r
         n67Vij47S+zooSes0Ns+Q+dljKrIflSygAuc4z6HFtMPrIRkbIXnTV9c8Qew18qXBIaG
         dABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HaUGak2G7cecQv8T9ZdGOoPgbZOZkSx+mC6eBv9kBwQ=;
        b=Aq6SElnKQQbM8TwzIu72UeTmp2gAAbymFm9qeLjfYqMr5rjgJcwsaggQVKKlhRTOnJ
         O+j/q/rxSsE1WEvNy1j7LPPIn7CQYX9v8WN7NSl9j1lfmWmf/or0pX23rCRXT3fK3h2p
         KG1vkYxefX10tkj5SpcF+AKy+7tk+CjrVFHg70+JZcpp2oRGrlOd/kx8oV8jhnqOraHl
         7WYvxcdsNg+2gMoa9wNgB0yH0me8qVwsmpTsBZ/ygNhstf68uzHT3UFHr7fstgnibqF4
         1A/J5mGIT1yZOtOwLFTBnSkYTWV3ntXhDNj/E9a3GXodslO8wim3JhAOTwxbGppegxfO
         72ug==
X-Gm-Message-State: AFqh2kpRLa3qusmWQ4yI/i5AuTDYd9p2LkpWZ93liyBmt9LnpvC2mkS8
        uYo7QJAeUQR4Fr9isPbs9BdQjktOzDjC6li95w==
X-Google-Smtp-Source: AMrXdXs9XtCfW7FcHAYBD8FdwiwULDpulbnJJBgeVPXNRbTxKFmc1P7VLn9MIitOOgcyXZHdLjpw+2N+aFSUUobVHg==
X-Received: from ackerleytng-cloudtop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:b30])
 (user=ackerleytng job=sendgmr) by 2002:aa7:9a5c:0:b0:58d:ce71:97d7 with SMTP
 id x28-20020aa79a5c000000b0058dce7197d7mr321996pfj.76.1673998609046; Tue, 17
 Jan 2023 15:36:49 -0800 (PST)
Date:   Tue, 17 Jan 2023 23:36:44 +0000
In-Reply-To: <b406d6e22a768d7b4faa5f2d9dca338069359f9a.1667110240.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
Message-ID: <diqzcz7cd983.fsf@ackerleytng-cloudtop-sg.c.googlers.com>
Subject: Re: [PATCH v10 067/108] KVM: TDX: Add helper assembly function to TDX vcpu
From:   Ackerley Tng <ackerleytng@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        pbonzini@redhat.com, erdemaktas@google.com, seanjc@google.com,
        sagis@google.com, dmatlack@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> TDX defines an API to run TDX vcpu with its own ABI.  Define an assembly
> helper function to run TDX vcpu to hide the special ABI so that C code can
> call it with function call ABI.

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/vmenter.S | 157 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 157 insertions(+)

> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 8477d8bdd69c..9066eea1ede5 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -3,6 +3,7 @@
>   #include <asm/asm.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/bitsperlong.h>
> +#include <asm/errno.h>
>   #include <asm/kvm_vcpu_regs.h>
>   #include <asm/nospec-branch.h>
>   #include <asm/percpu.h>
> @@ -31,6 +32,13 @@
>   #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
>   #endif

> +#ifdef CONFIG_INTEL_TDX_HOST
> +#define TDENTER 		0
> +#define EXIT_REASON_TDCALL	77
> +#define TDENTER_ERROR_BIT	63
> +#define seamcall		.byte 0x66,0x0f,0x01,0xcf
> +#endif
> +
>   .section .noinstr.text, "ax"

>   /**
> @@ -350,3 +358,152 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
>   	pop %_ASM_BP
>   	RET
>   SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +
> +.pushsection .noinstr.text, "ax"
> +
> +/**
> + * __tdx_vcpu_run - Call SEAMCALL(TDENTER) to run a TD vcpu
> + * @tdvpr:	physical address of TDVPR
> + * @regs:	void * (to registers of TDVCPU)
> + * @gpr_mask:	non-zero if guest registers need to be loaded prior to  
> TDENTER
> + *
> + * Returns:
> + *	TD-Exit Reason
> + *
> + * Note: KVM doesn't support using XMM in its hypercalls, it's the HyperV
> + *	 code's responsibility to save/restore XMM registers on TDVMCALL.
> + */
> +SYM_FUNC_START(__tdx_vcpu_run)
> +	push %rbp
> +	mov  %rsp, %rbp
> +
> +	push %r15
> +	push %r14
> +	push %r13
> +	push %r12
> +	push %rbx
> +
> +	/* Save @regs, which is needed after TDENTER to capture output. */
> +	push %rsi
> +
> +	/* Load @tdvpr to RCX */
> +	mov %rdi, %rcx
> +
> +	/* No need to load guest GPRs if the last exit wasn't a TDVMCALL. */
> +	test %dx, %dx
> +	je 1f
> +
> +	/* Load @regs to RAX, which will be clobbered with $TDENTER anyways. */
> +	mov %rsi, %rax
> +
> +	mov VCPU_RBX(%rax), %rbx
> +	mov VCPU_RDX(%rax), %rdx
> +	mov VCPU_RBP(%rax), %rbp
> +	mov VCPU_RSI(%rax), %rsi
> +	mov VCPU_RDI(%rax), %rdi
> +
> +	mov VCPU_R8 (%rax),  %r8
> +	mov VCPU_R9 (%rax),  %r9
> +	mov VCPU_R10(%rax), %r10
> +	mov VCPU_R11(%rax), %r11
> +	mov VCPU_R12(%rax), %r12
> +	mov VCPU_R13(%rax), %r13
> +	mov VCPU_R14(%rax), %r14
> +	mov VCPU_R15(%rax), %r15
> +
> +	/*  Load TDENTER to RAX.  This kills the @regs pointer! */
> +1:	mov $TDENTER, %rax
> +
> +2:	seamcall
> +
> +	/*
> +	 * Use same return value convention to tdxcall.S.
> +	 * TDX_SEAMCALL_VMFAILINVALID doesn't conflict with any TDX status code.
> +	 */
> +	jnc 3f
> +	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> +	jmp 5f
> +3:
> +
> +	/* Skip to the exit path if TDENTER failed. */
> +	bt $TDENTER_ERROR_BIT, %rax
> +	jc 5f
> +
> +	/* Temporarily save the TD-Exit reason. */
> +	push %rax
> +
> +	/* check if TD-exit due to TDVMCALL */
> +	cmp $EXIT_REASON_TDCALL, %ax
> +
> +	/* Reload @regs to RAX. */
> +	mov 8(%rsp), %rax
> +
> +	/* Jump on non-TDVMCALL */
> +	jne 4f
> +
> +	/* Save all output from SEAMCALL(TDENTER) */
> +	mov %rbx, VCPU_RBX(%rax)
> +	mov %rbp, VCPU_RBP(%rax)
> +	mov %rsi, VCPU_RSI(%rax)
> +	mov %rdi, VCPU_RDI(%rax)
> +	mov %r10, VCPU_R10(%rax)
> +	mov %r11, VCPU_R11(%rax)
> +	mov %r12, VCPU_R12(%rax)
> +	mov %r13, VCPU_R13(%rax)
> +	mov %r14, VCPU_R14(%rax)
> +	mov %r15, VCPU_R15(%rax)
> +
> +4:	mov %rcx, VCPU_RCX(%rax)
> +	mov %rdx, VCPU_RDX(%rax)
> +	mov %r8,  VCPU_R8 (%rax)
> +	mov %r9,  VCPU_R9 (%rax)
> +
> +	/*
> +	 * Clear all general purpose registers except RSP and RAX to prevent
> +	 * speculative use of the guest's values.
> +	 */
> +	xor %rbx, %rbx
> +	xor %rcx, %rcx
> +	xor %rdx, %rdx
> +	xor %rsi, %rsi
> +	xor %rdi, %rdi
> +	xor %rbp, %rbp
> +	xor %r8,  %r8
> +	xor %r9,  %r9
> +	xor %r10, %r10
> +	xor %r11, %r11
> +	xor %r12, %r12
> +	xor %r13, %r13
> +	xor %r14, %r14
> +	xor %r15, %r15
> +
> +	/* Restore the TD-Exit reason to RAX for return. */
> +	pop %rax
> +
> +	/* "POP" @regs. */
> +5:	add $8, %rsp
> +	pop %rbx
> +	pop %r12
> +	pop %r13
> +	pop %r14
> +	pop %r15
> +
> +	pop %rbp
> +	RET
> +
> +6:	cmpb $0, kvm_rebooting
> +	je 1f
> +	mov $TDX_SW_ERROR, %r12

While compiling the tree at
https://github.com/intel/tdx/tree/kvm-upstream, it seems like
compilation was failing because TDX_SW_ERROR was not defined. Perhaps
asm/tdx.h needs to be added.

> +	orq %r12, %rax
> +	jmp 5b
> +1:	ud2
> +	/* Use FAULT version to know what fault happened. */
> +	_ASM_EXTABLE_FAULT(2b, 6b)
> +
> +SYM_FUNC_END(__tdx_vcpu_run)
> +
> +.popsection
> +
> +#endif
> --
> 2.25.1
