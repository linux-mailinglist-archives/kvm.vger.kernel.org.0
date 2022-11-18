Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6314062EA26
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 01:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiKRAVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 19:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiKRAU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 19:20:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE67697CA
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 16:20:54 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w23so3124110ply.12
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 16:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F+McP8D/0SjXb58auK1GbMTzUTBSyxcFhDKrgcY8D1w=;
        b=hk4a32ijZFO5lQs6sn1ncFanPXFOkOJztOA4YErcIQjVBw+jw22lXMwxGzbcwxUiP+
         ZN/sjziVqOiJfLaj+B+idBcMR9RF0wt6INu2ajneAMdZl4vydkprrmPsK5SOZtZsysgf
         sTOjSb59GGfDr8Fjnk4XNQDAUQuJKQ+J1jNK2/60ce8H37Zy9f9htF3fFPwo/mC3Dwut
         kuY4InnOsnwj3H25PlLdvkUUGfLsSfMKD6HTOmgjFShFl+pNaOdanINHyxnDkVJvQi2t
         8plvFbVKA0Xou3QORSUgFjx/RsY6yQXUmkmoaFASJsk8fOWDPhoNBx3+hpltDX6TjdTK
         fMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+McP8D/0SjXb58auK1GbMTzUTBSyxcFhDKrgcY8D1w=;
        b=bsM8elnfF6kECxL+sHSEeoMZyANtGEFhH8Zmbs7NIlhwu4L/IgS0Lw0c/HWJWWDTvD
         QXO1E265n2mK7YzN11QNxWvbBlso4Ho51O4YN/9QKgoc7k5guEKuHnUQ9kPGkWZaIzGH
         hcR6u7PfYGK4b55VezHb8YfO0TScEN8quFJj/PS/yjmtUKsjtZKg5t1ibQRTUsKGVHq/
         HiezbTZwr+lmmRGBqMIWgokM7n0hdxT6aFuF7f45MTWFzNHf6i2CqN4+6BITUr073m9o
         0gE3E66/XM4AIhqt8QJCzVOuGFNJpckllYukWULB1+dR0uNFrdKFswixpSmmcN3e8swZ
         3igA==
X-Gm-Message-State: ANoB5pk9SOoVJU2eZEucIW2IIBDJ1HfMWGxTiT++0HAlLaXMcczAQcUT
        ZZAkrFNFfJJK+cKEAesRY1SP5w==
X-Google-Smtp-Source: AA0mqf48QOtx/abOdCcb9asZFk8M64cAwKKqMvd16XdNnfracMJIIQs/iFkkLuHGPg+4Z1wdg7ZJ+Q==
X-Received: by 2002:a17:90a:ae0f:b0:20d:b124:33b1 with SMTP id t15-20020a17090aae0f00b0020db12433b1mr5015527pjq.202.1668730853703;
        Thu, 17 Nov 2022 16:20:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik28-20020a170902ab1c00b00186c41bd213sm1993193plb.177.2022.11.17.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 16:20:53 -0800 (PST)
Date:   Fri, 18 Nov 2022 00:20:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] vmx: use mov instead of lea in __vmx_vcpu_run()
Message-ID: <Y3bP4U0X3MZvr0zc@google.com>
References: <Y3abPTOAxbLOpnVN@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3abPTOAxbLOpnVN@p183>
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

KVM: VMX: for the shortlog please.

On Thu, Nov 17, 2022, Alexey Dobriyan wrote:
> "mov rsi, rsp" is equivalent to "lea rsi, [rsp]" but 1 byte shorter.

Eww, Intel syntax ;-)

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/x86/kvm/vmx/vmenter.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -72,7 +72,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	/* Copy @flags to BL, _ASM_ARG3 is volatile. */
>  	mov %_ASM_ARG3B, %bl
>  
> -	lea (%_ASM_SP), %_ASM_ARG2
> +	mov %_ASM_SP, %_ASM_ARG2

I don't have a strong preference.  It's probably worth converting, e.g. move
elimination on modern CPUs might shave a whole uop.

I'm pretty sure LEA is a holdover from when this code pre-calculated RSP before
a series of pushes.

>  	call vmx_update_host_rsp
>  
>  	ALTERNATIVE "jmp .Lspec_ctrl_done", "", X86_FEATURE_MSR_SPEC_CTRL
