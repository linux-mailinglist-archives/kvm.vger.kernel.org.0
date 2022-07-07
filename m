Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0211C56AC24
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 21:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiGGTra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 15:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiGGTr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 15:47:26 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E235C96D
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 12:47:24 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 145so20335511pga.12
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 12:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wYQ800eqwpu2fPAkSKvWHrzDSIMg2+p71H5ky/Bd6zg=;
        b=imcqetEL9JvDBADGN8tKcjm7KKJn7Yx0sKKQaGSANVC9iXk8TJ88Q8mMsgMzAXN7Dw
         vcu3tTnYMvuSisZ1aJC3BC628/9mMgLjpo1obHm5HsV801DMBi+wOzft9gOOlopUx/Wr
         p2ARYlLmkmKJYj87CBoGbCL4pbiKAo//1FTznVmFYH+ojjLXdU2J4VyJk9BC7wlID2Lc
         IQjVI8EUcD28yLlr7YSTCIkcI/9iGLP3nARIgbVKMWmLIk1vg2aycVRiThk9lyIbmWRJ
         61/dllSqFZ6LLHHl+9Io1w2C5cFjFNsqVxyOu5xKHW30uTslzwh3VvFl0vcwbJb1fIZq
         4QEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wYQ800eqwpu2fPAkSKvWHrzDSIMg2+p71H5ky/Bd6zg=;
        b=d94Pye6u1QX5Ox6LgVG+swewD8PxKB8L4ASICCRmR6ZhFgC1GlgxQsTmqOMwt/4+GM
         n1CTtzYAr/9gEZu0/lsCe0IIUEtNQcTi2Hj9CiFcmUDVX4EnxBLv0vAs3wvNjFJjvLv6
         8quxL59cCV5a/wokwjQLWE9oWZaH0Yg97PIepIoeRdk3p8Cuwe8713K2JJYk09U8TOKw
         1A+PYIuOfwqRbdsiqT3raX+k5sWZbV4q1CpfDVwGD3VFTayBKbxtQy0K+1/Km61SKOPq
         fczVVRhnngzxpv6PbOiuqzaAv+Hz8fwiE9oLbzsTZq00LAQIQMNKcGmkT3o+Fh7Iw1ig
         brCQ==
X-Gm-Message-State: AJIora9T+pRlaImBEDjB6W9qC74lYVouGBnjFTaY4daF3J2yz92G/5h0
        fwMMf2noh1D0pJE1x7p4V7yRaA==
X-Google-Smtp-Source: AGRyM1seOimHaIGaLza/MlXpk0vUD0uoJe5sBB5cIN+LlfbPMDV0RL/QjCbwKAjkbVX0wDEZu9nGPA==
X-Received: by 2002:a17:902:7049:b0:16b:bf58:ded2 with SMTP id h9-20020a170902704900b0016bbf58ded2mr36990649plt.98.1657223243653;
        Thu, 07 Jul 2022 12:47:23 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id 132-20020a62198a000000b0051bc5f4df1csm27301291pfz.154.2022.07.07.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 12:47:23 -0700 (PDT)
Date:   Thu, 7 Jul 2022 19:47:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] KVM: VMX: Move VM-exit RSB stuffing out of line
Message-ID: <Ysc4R3JDqnIFUfZ6@google.com>
References: <20220630225424.1389578-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630225424.1389578-1-jmattson@google.com>
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

On Thu, Jun 30, 2022, Jim Mattson wrote:
> RSB-stuffing after VM-exit is only needed for legacy CPUs without
> eIBRS. Move the RSB-stuffing code out of line to avoid the JMP on
> modern CPUs.

The shortlog and this sentence need to be updated, the stuffing code is still
in-line, but the JMP is being dropped.

> Note that CPUs that are subject to SpectreRSB attacks need
> RSB-stuffing on VM-exit whether or not RETPOLINE is in use as a
> SpectreBTB mitigation. However, I am leaving the existing mitigation
> strategy alone.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/vmenter.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index 435c187927c4..ea5986b96004 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -76,7 +76,8 @@ SYM_FUNC_END(vmx_vmenter)
>   */
>  SYM_FUNC_START(vmx_vmexit)
>  #ifdef CONFIG_RETPOLINE
> -	ALTERNATIVE "jmp .Lvmexit_skip_rsb", "", X86_FEATURE_RETPOLINE
> +	ALTERNATIVE "RET", "", X86_FEATURE_RETPOLINE
> +
>  	/* Preserve guest's RAX, it's used to stuff the RSB. */
>  	push %_ASM_AX
>  
> @@ -87,7 +88,6 @@ SYM_FUNC_START(vmx_vmexit)
>  	or $1, %_ASM_AX
>  
>  	pop %_ASM_AX
> -.Lvmexit_skip_rsb:
>  #endif
>  	RET
>  SYM_FUNC_END(vmx_vmexit)
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
