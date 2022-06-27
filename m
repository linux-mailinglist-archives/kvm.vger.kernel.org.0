Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFDC55C9FC
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbiF0PIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiF0PIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:08:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1015B140D5
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:08:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so2093489pjs.1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FK2nqQdZE1Um0F/qxp1XsLlBofTMHtWjQfVQbrn0Hnk=;
        b=MqgUMvc6tGx7MX9oFXOfvA5N4Z6rQRxRYs8lDvjNQOn0P2Cygjx/96UVqoNCU8r5ae
         RM4A2SkI6YBd8YdLYec9bd/aBeAnfmqSOcOLPeQ4j6SXbNU2ZXrzN048H9Mjjtp5puWU
         vA+lmqwBGuP0FAckANKmlA8ecTq0CTnuj+h0qlLxvSVQsIWkwSGzbH6f2/pe3TU6ySeT
         +m0Tot3AWYMhPOO2sX5jZZIZMWWTxhd4Gg+Xx0UqlR/QzyZDlPN1Pa/pr7crF6QpNLOJ
         AHN9E0rM0EfRWPQQbyvmWvwiuNVgWIDdMdm5oSRcHxSt3b3ChCbYyWVcgjOeVoB7u90l
         4aew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FK2nqQdZE1Um0F/qxp1XsLlBofTMHtWjQfVQbrn0Hnk=;
        b=CvWmms7t7pLGYXi7S7jqt/cCTzx+SQ/k7R5Ss8yMlF2uCTXrTPzTefK+8Jdo6yJeRU
         /za98DtyQHXrD4L3TkSFmFtSz2Ab6PC5lrZ6ySqYPtksq2BwyKMdxyexfCLzIRz+o6bw
         Rurh58OUtjNJ43TLrANK0LL55tps7D2FcIhpSBif0yMjlCbVzEalfpvJaOLAJfzwwMTG
         7YdCedg/AD4MaM30iFj458fgc6HihZqpZp3sX9sTmxBO32tsruZEVqcwJtNSQ/gXNW44
         qdiytiWpVqt2CRbOHBX4ngtrJf047gjyfuMI93iaDFTINUm0sqT1sKxiVMZ0PBu0GZJv
         4Sfw==
X-Gm-Message-State: AJIora9I9f7AwwnBN2OjNOXcVZM9zxfnKfY5YjSIQ44vxV9YrI0SbnN2
        lQ/gk54PIpqEqmxEn8h9P3lb6g==
X-Google-Smtp-Source: AGRyM1v9zsr08Ftlq4BLT3RaTt/0BEimTJmPBA7tzfixVIKdBfuipz5Q8KQkPI7RIsAKY4sS/MrLsQ==
X-Received: by 2002:a17:90b:341:b0:1e0:cf43:df4f with SMTP id fh1-20020a17090b034100b001e0cf43df4fmr16356064pjb.126.1656342527345;
        Mon, 27 Jun 2022 08:08:47 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b00168aed83c63sm7354236pln.237.2022.06.27.08.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:08:46 -0700 (PDT)
Date:   Mon, 27 Jun 2022 15:08:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: VMX: Move VM-exit RSB stuffing out of line
Message-ID: <YrnH+nhnbhDFAMas@google.com>
References: <20220622222408.518889-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622222408.518889-1-jmattson@google.com>
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

On Wed, Jun 22, 2022, Jim Mattson wrote:
> RSB-stuffing after VM-exit is only needed for legacy CPUs without
> eIBRS. Move the RSB-stuffing code out of line.

I assume the primary justification is purely to avoid the JMP on modern CPUs?

> Preserve the non-sensical correlation of RSB-stuffing with retpoline.

Either omit the blurb about retpoline, or better yet expand on why it's nonsensical
and speculate a bit on why it got tied to retpoline? 

> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 435c187927c4..39009a4c86bd 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -76,7 +76,12 @@ SYM_FUNC_END(vmx_vmenter)
>   */
>  SYM_FUNC_START(vmx_vmexit)
>  #ifdef CONFIG_RETPOLINE
> -	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
> +	ALTERNATIVE "", "jmp .Lvmexit_stuff_rsb", X86_FEATURE_RETPOLINE
> +#endif
> +.Lvmexit_return:
> +	RET
> +#ifdef CONFIG_RETPOLINE
> +.Lvmexit_stuff_rsb:
>  	/* Preserve guest's RAX, it's used to stuff the RSB. */
>  	push %_ASM_AX

There's a comment in the code here about stuffiing before RET, I think it makes
sense to keep that before the RET, i.e. hoist it out of the actual stuffing
sequence so that it looks like:

#ifdef CONFIG_RETPOLINE
	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
	ALTERNATIVE "", "jmp .Lvmexit_stuff_rsb", X86_FEATURE_RETPOLINE
#endif
.Lvmexit_return:
	RET

Ha!  Better idea.  Rather than have a bunch of nops to eat through before the
!RETPOLINE case gets to the RET, encode the RET as the default.  That allows using
a single #ifdef and avoids both the JMP over the RET as well as the JMP back to the
RET, and saves 4 nops to boot.

SYM_FUNC_START(vmx_vmexit)
#ifdef CONFIG_RETPOLINE
	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
	ALTERNATIVE "RET", "", X86_FEATURE_RETPOLINE

	/* Preserve guest's RAX, it's used to stuff the RSB. */
	push %_ASM_AX

	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE

	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
	or $1, %_ASM_AX

	pop %_ASM_AX
#endif
	RET
SYM_FUNC_END(vmx_vmexit)
