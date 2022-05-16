Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71117528CB6
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238820AbiEPSQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbiEPSQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:16:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F53465CA
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 11:16:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v10so14811333pgl.11
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 11:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bm1v6ZeBGUty4JiVw77sgclexXnxEpGwczadUOdKNDI=;
        b=pYUjQX4Z42V1zUCNSZS2C5/9a97GCuMtrbX+FCMRo5X3g2Ss90tvj8WCGJ6cx5OwMP
         ln7I3cTfLnk+gLLRA8SbpgAG2TBIkgU8frXjpJWZoc0s2uvsqtzDTSGvFSXMcFevS4WI
         q9Uruk1oMqbW9Wo4/4BlfzaQyN8WngoNJuUxBeWDcL/H0JeAa4uZPTuLqq4VLyPnfDik
         Qi0TbFUnRpsYJM8OYmzeJwwbljlJDEiBshDqJunUZg9COuhNeLxc6emgdddIwJ46npvD
         AF0W4Q7bkHUauE+UqF0+8S/Dwmp3MHSfzvXmXTuTjAyyfAbVLcUQUFvMJaiN7oBo1uny
         Pxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bm1v6ZeBGUty4JiVw77sgclexXnxEpGwczadUOdKNDI=;
        b=Q8WVe7292WHkHzSVt8N+omKy6LFbQN7MKwRH7rsLBnK6hkP87PcE7t5Sr0eeX34mee
         5X4R7dJ3tbtuO1DS3uJIiY2wSW4DAhLyUvjcSqjbuRQslUDilvm3ZdMsEMlZChdpm40D
         udAHvkL0XiLoCBTD98rltK+XbFA7IRkJ0vQuBiCvUoymAnYyPv7t+wP7diGUwkfWOsHS
         o8MHhKluOxCcgu+6mXhhRmMgIOMnGf77sOEYjuDsMKV/c7GRIbgrAy9CIrU/NjSHoUie
         /NT+u8tSeuVznGd9JkqRZaslm6bjtPCulWcnB9pKYUl3TA64BS9FONz0ILlZtpwdOo5N
         Cv5w==
X-Gm-Message-State: AOAM531IlRl6gNvP3PEr+58c7Qc8CtIC2dETzcqLyLFz1Nuf0TstJUrf
        /So23fv03dp+DSSyCKzym8w3OQ==
X-Google-Smtp-Source: ABdhPJzvSbW5eMQ7WNXvxKL9U55yxzz2tu7iPSDNqzyQJqgmVIWgLiO9y991e4+ncpXJSlQ9apoXNA==
X-Received: by 2002:a63:f50:0:b0:3db:48b1:a7e1 with SMTP id 16-20020a630f50000000b003db48b1a7e1mr16130559pgp.579.1652724980674;
        Mon, 16 May 2022 11:16:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902f60b00b0015ec71f72d6sm7351277plg.253.2022.05.16.11.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 11:16:20 -0700 (PDT)
Date:   Mon, 16 May 2022 18:16:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/uaccess: Improve __try_cmpxchg64_user_asm for x86_32
Message-ID: <YoKU8IBa37WwIgex@google.com>
References: <20220515203713.635980-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515203713.635980-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 15, 2022, Uros Bizjak wrote:
> Improve __try_cmpxcgh64_user_asm for !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
> by relaxing the output register constraint from "c" to "q" constraint,
> which allows the compiler to choose between %ecx or %ebx register.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/uaccess.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 35f222aa66bf..9fae2a1cc267 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -448,7 +448,7 @@ do {									\
>  
>  #ifdef CONFIG_X86_32
>  /*
> - * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
> + * Unlike the normal CMPXCHG, use output GPR for both success/fail and error.
>   * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
>   * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
>   * both ESI and EDI for the memory operand, compilation will fail if the error
> @@ -461,11 +461,12 @@ do {									\
>  	__typeof__(*(_ptr)) __new = (_new);				\
>  	asm volatile("\n"						\
>  		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
> -		     "mov $0, %%ecx\n\t"				\
> -		     "setz %%cl\n"					\
> +		     "mov $0, %[result]\n\t"				\
> +		     "setz %b[result]\n"				\
>  		     "2:\n"						\
> -		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
> -		     : [result]"=c" (__result),				\
> +		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
> +					   %[result])			\

Huh.  I remember trying this, but either I could never get one of these formats
correct (most likely) or I got sidetracked by the clang-13 bug and never circled
back to allowing EBX.

Regardless, clang-13 and gcc-11 are happy with this,

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +		     : [result] "=q" (__result),			\
>  		       "+A" (__old),					\
>  		       [ptr] "+m" (*_ptr)				\
>  		     : "b" ((u32)__new),				\
> -- 
> 2.35.1
> 
