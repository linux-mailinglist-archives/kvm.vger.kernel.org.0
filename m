Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1044650E4F1
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbiDYQB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiDYQB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:01:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC71154E6
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 08:58:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n33-20020a17090a5aa400b001d28f5ee3f9so6314839pji.4
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 08:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MDoMxagnKQRCVQI2YExt9r1f2Iw0lVqVeN8WwcCneUk=;
        b=H1euJ14fSVUnGo3Cmy1DLPaIPdQEq/svZDc44dnKWhOeMXIGU1OHx1rU0979/zE+Cw
         dZyVVH4JrtVHJedDTZifAimI0lFIoxcfSZkouEEX14ei3RPhuOlkGNwc28mQ2AF0kBB3
         FxcyedYDSXPmdh/e/rKpAYt67DesJdFuKSZT5C8zMMGZujXOOZGNe5Oq/9kSHUFjVglG
         bWVJscdYsP+bKE3VE6WOwuClLnc1YDXJC2aFWu2exxPo4LeB23G8gU0NztRBj3iq9ek0
         CbbJgxuLrXW9Vw1q6aKAZRlOsf1/W+aVpL7a560HKsFsnDiFlfQzdZcM3wxvg8khwhjG
         KvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MDoMxagnKQRCVQI2YExt9r1f2Iw0lVqVeN8WwcCneUk=;
        b=5eR7TAr8SvAtp7I/CFDOCeFwo2mCcJgJ43C7cYn416hAUBAS8pnpkehQH/adnuFmhp
         qJ/FtdPQAySfWlHwxCDl+l+PnGSJmEFPQxSU28djqKT3bfr5AN1mcRQn5u5I7K+bjEGY
         X1kLJfVFAM+ENLw+HyOKVCr0MwrVoxzMHN6DYCF5w5K8UEMkFeK7pfhUAF50fKzcPXma
         lQvxZu6KsDKK4p3fq+vl7K2mZ7Q9ncZUW8YTwey2c7a/Ha92qrmmBsxLdxzwxWEquV2B
         TL6Qg953wrfe4eUUUSFjAOWXV7DxcdvQDOEBSzWoH7lWspgBZLocduUTm/73LbRdPvam
         hvRg==
X-Gm-Message-State: AOAM531FR9zl42WCvhqKpU8akkLMcCJKkchi14Fc9U/uBSVirys1DRqS
        Wa6sadiEj5Na/5DiKPg8vgRKQg==
X-Google-Smtp-Source: ABdhPJynbU9hPSDYVyTqc2z9h2GITnN0aS5gWUfpD7/BIUxdew6NvG6kmyx/cSnE5Suv+0GfVMG14Q==
X-Received: by 2002:a17:90a:a593:b0:1c9:b837:e77d with SMTP id b19-20020a17090aa59300b001c9b837e77dmr20965746pjq.205.1650902331237;
        Mon, 25 Apr 2022 08:58:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j64-20020a62c543000000b0050d260c0ea8sm8037033pfg.110.2022.04.25.08.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:58:50 -0700 (PDT)
Date:   Mon, 25 Apr 2022 15:58:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: replace `int 0x20` with `syscall`
Message-ID: <YmbFN6yKwnLDRdr8@google.com>
References: <20220424070951.106990-1-darcy.sh@antgroup.com>
 <20220424070951.106990-2-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424070951.106990-2-darcy.sh@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 24, 2022, SU Hang wrote:

Why?  As gross as it is, I actually think INTn is a better option because it
doesn't require writing multiple MSRs, and can work for both 64-bit and 32-bit KUT.
The latter is currently a moot point since this code is 64-bit only, but the UMIP
test _does_ support 32-bit, and it's do_ring3() should really be rolled into this
framework.

Furthermore, we really should have a test to verify that KVM correctly emulates
SYSCALL at CPL3 with EFER.SCE=0, and forcing EFER.SCE=1 just to get to CPL3 would
make it impossible to utilize this framework for such a test.

> Signed-off-by: SU Hang <darcy.sh@antgroup.com>
> ---
>  lib/x86/usermode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index 477cb9f..e4cb899 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -12,7 +12,6 @@
>  #include <stdint.h>
>  
>  #define USERMODE_STACK_SIZE	0x2000
> -#define RET_TO_KERNEL_IRQ	0x20
>  
>  static jmp_buf jmpbuf;
>  
> @@ -40,9 +39,11 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  	static unsigned char user_stack[USERMODE_STACK_SIZE];
>  
>  	*raised_vector = 0;
> -	set_idt_entry(RET_TO_KERNEL_IRQ, &ret_to_kernel, 3);
>  	handle_exception(fault_vector,
>  			restore_exec_to_jmpbuf_exception_handler);
> +	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SCE);

Tangentially related, KUT should really explicitly initialize EFER.SCE during boot.
cstart64.S leaves it alone, which means KUT has no defined value for EFER.SCE.
One thought would be to set EFER.SCE=1 during boot (in a separate patch) and remove
the code from the syscall test that forces EFER.SCE.  AFAICT, no existing test
verifies that KVM injects #UD on SYSCALL without EFER.SCE set, though it would be
nice to add one.

> +	wrmsr(MSR_STAR, ((u64)(USER_CS32 << 16) | KERNEL_CS) << 32);

It doesn't matter at this time because this framework doesn't ses SYSRET, but this
should be USER_CS or USER_CS64.

> +	wrmsr(MSR_LSTAR, (u64)&ret_to_kernel);
>  
>  	if (setjmp(jmpbuf) != 0) {
>  		*raised_vector = 1;
> @@ -73,7 +74,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  			"mov %[arg4], %%rcx\n\t"
>  			"call *%[func]\n\t"
>  			/* Return to kernel via system call */
> -			"int %[kernel_entry_vector]\n\t"
> +			"syscall\n\t"
>  			/* Kernel Mode */
>  			"ret_to_kernel:\n\t"
>  			"mov %[rsp0], %%rsp\n\t"
> @@ -89,8 +90,7 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  			[user_ds]"i"(USER_DS),
>  			[user_cs]"i"(USER_CS),
>  			[user_stack_top]"r"(user_stack +
> -					sizeof(user_stack)),
> -			[kernel_entry_vector]"i"(RET_TO_KERNEL_IRQ)
> +					sizeof(user_stack))
>  			:
>  			"rsi", "rdi", "rbx", "rcx", "rdx", "r8", "r9", "r10", "r11");
>  
> -- 
> 2.32.0.3.g01195cf9f
> 
