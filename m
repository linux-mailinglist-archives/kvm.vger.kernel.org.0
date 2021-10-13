Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF4642C9F9
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbhJMT0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 15:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhJMT0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 15:26:48 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE9AC06174E
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:24:45 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d23so3281101pgh.8
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 12:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5MB0GMvdbcH76JCV+SPCf4M7TZGdYon4av7QhoIqffo=;
        b=VII4BHgbMS5R4WVLU+RCIbAJwVooH3iRzjKMsNbhCGpnRSLcVbNZjwGKAlkIK2H6EZ
         1BGTbOqi9B3MNPN8OB7PEo8lYbknF1w4pjP4QuqNd2yUVQMJfBUWUJp2sIqkSGejQ7dE
         mF4gJ5EaMWduZLjBjMYt86tARVCOeOGQUkR/5fxehJPxcMexBUgMJFFWekFWdp5ePPQ7
         59ELZsv4E+YFcR2qxxWUYF5xM2m2nUtC87JiFna+M4X5iOKAvFyBPYTh2KfH7eOQsWsy
         ZeucfAVcXkGeUlJBuLHQR2xzALPOvRwMaG5Hy5r3sXUTsW0g8XW9hisRCmDAsh4Ytui7
         Tfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5MB0GMvdbcH76JCV+SPCf4M7TZGdYon4av7QhoIqffo=;
        b=2uplNtdbDozX5ARErYzq1Y+CEvKZbtRxP2xWgwrspevJMPzP424TY0qlaQfnF06noy
         iO1hTtck1rQILWqdEBR3B3IfD3M48s/jDU5sCia2Vit8S4xk6v+GyCdiOhMfRS+xZcpW
         RHFyzY+IDJXvH/jSzb0hc8y/doEHw0QJJCW/iLRBcdIxVrsiylygQugKAFTFTFZEAj61
         1gt/8NcoGc1DX/bLN+FcJTwl13qCXWfyALG2CkGfAv6bcCwri5HzcbQu7nAHBNZ+beDi
         sy+jYelh85sFEWQbpvv8zTvSqVdsTTKMHFUH2IO5mD6UF8bt8JGdO017yUwD36r4tY1t
         qCkQ==
X-Gm-Message-State: AOAM530LaDRqnnLO1QtlouEnRrj2Yn5BpqELTQ77ynzaqwPJmOG28n4a
        W4lCjWDfoiRQpHhfdRUrOlW5bQ==
X-Google-Smtp-Source: ABdhPJx7Iq1hOdesmUtnVxB8KV2g8XExaAbXqTu+Xd7qWgMcTLk1oV7xcUsL3ap/4bU8SwHXLAbTqw==
X-Received: by 2002:a62:ea04:0:b0:44c:7370:e6d8 with SMTP id t4-20020a62ea04000000b0044c7370e6d8mr1225630pfh.18.1634153084358;
        Wed, 13 Oct 2021 12:24:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e2sm255618pfd.137.2021.10.13.12.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 12:24:43 -0700 (PDT)
Date:   Wed, 13 Oct 2021 19:24:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Improve exception safe wrappers in emulate.c
Message-ID: <YWcyeGk7vOSoQWW4@google.com>
References: <20210917135152.5111-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917135152.5111-1-ubizjak@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 17, 2021, Uros Bizjak wrote:
> Improve exception safe wrappers in emulate.c by converting them to
> ASM GOTO (and ASM GOTO OUTPUT when supported) statements.  Also, convert
> wrappers to inline functions to avoid statement as expression
> GNU extension and to remove weird requirement where user must know
> where the asm argument is being expanded.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson  <seanjc@google.com>
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> ---
>  arch/x86/kvm/emulate.c | 80 ++++++++++++++++++++++++++++++------------
>  1 file changed, 57 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2837110e66ed..2197a3ecc55b 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -464,25 +464,59 @@ FOP_FUNC(salc)
>  FOP_RET(salc)
>  FOP_END;
>  
> -/*
> - * XXX: inoutclob user must know where the argument is being expanded.

I 100% agree that this is a weird requirement, but I actually like the side
effect of forcing the caller to define a name for the input/output.

> - *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
> - */
> -#define asm_safe(insn, inoutclob...) \
> -({ \
> -	int _fault = 0; \
> - \
> -	asm volatile("1:" insn "\n" \
> -	             "2:\n" \
> -	             ".pushsection .fixup, \"ax\"\n" \
> -	             "3: movl $1, %[_fault]\n" \
> -	             "   jmp  2b\n" \
> -	             ".popsection\n" \
> -	             _ASM_EXTABLE(1b, 3b) \
> -	             : [_fault] "+qm"(_fault) inoutclob ); \
> - \
> -	_fault ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE; \
> -})
> +static __always_inline int safe_fwait(void)
> +{
> +	asm_volatile_goto("1: fwait\n\t"
> +			  _ASM_EXTABLE(1b, %l[fault])
> +			  : : : : fault);
> +	return X86EMUL_CONTINUE;
> + fault:
> +	return X86EMUL_UNHANDLEABLE;
> +}

Rather than defining a bunch of safe_() variants, what about providing a generic
helper/macro similar to the existing asm_safe()?  Not just for KVM, but for the
kernel at large.  Asm with output is problematic due to the CONFIG_CC_HAS_ASM_GOTO
dependency, but it wouldn't be the end of the world to state that simply isn't
supported until the min compiler version is raised.

__wrmsr(), native_write_msr_safe(), cpu_vmxoff(), kvm_cpu_vmxon(), and probably
others could use a generic generic asm_safe().  I wouldn't be surprised if there
are other places in the kernel that could take advantage of such a helper, e.g.
kvm_load_ldt() could use a "safe" variant instead of crashing if the sel is bad.
