Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3E86BBFAD
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjCOWSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 18:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjCOWSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 18:18:04 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D39F18B26
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:18:03 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t30-20020a056a00139e00b006228307e71bso52829pfg.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678918682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MvteDYHsbT9OEr0aq2wdfkYZ5XUVGpFjX1APZCsfOXA=;
        b=ZPYt8KMXd0uMxI+PxwCFJKwxxitCAIk9LSlZwyGS1P4qAdlt02cvhT0FiokxNE3ARR
         jhFxSwtS7FIpkh9eWW3mh7Kuqjwlc0ME2MSHiF3jxNJpEcAHV2n2sgVBFhk/wVYdu7th
         iCETTFBtT8vPh/Lq6MWh1SF6j5hoHTd0NJYZkFsbYy/AE+BvpDnKJLqBZbZcMuMdN6Jo
         tM5FhSxpATFTHI6PBxsZLs1dQCgLGDS5gHD3b85i3CFfAy+Rm5iI/7GdTbwo0xyK292o
         1oIq/xNjyYt4OjmM8FBVfAc4bumO0zLPEfN2yyE/GahPpoMejypjJdMS7MUF2DqBpNm8
         /pMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678918682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MvteDYHsbT9OEr0aq2wdfkYZ5XUVGpFjX1APZCsfOXA=;
        b=RO3ew9YexaQooR1dH3F5C7lCf34GIT9vQELJlNw47x6vXnz+KTJHZCXgQZBWXDldyW
         rdZfjyC6yk2ooRk/FM2LxsWyqTryYt30lyZAq5jgKb4sYIwYOTtJ62Pvk/mXz7XJnKVM
         nyBYtvoMgAyNsXKA4popU3ajaXx8fzplkORlK5TpLNwQJXXtywtoclmFyXqA62VZRkPR
         BpDPympX1LXZQD0fVg33jNu9tH7XHahz2iM96GMXk6Gth270nmKyvF4vxiseVsLcwh3V
         IENRPUyEu658drFuSrk2uy9ml/jrvROEaLnLILkiYSeFVsVDZfLPdf6jFSsU0pY5WaH8
         /L3g==
X-Gm-Message-State: AO0yUKW+TSoKVKq//N1AlwYaH8R9CvG6YZiDrYNV7gq0sci+saCzmtvk
        h0RjZkT7rVSKNvIaYTFWbmiCwOg88HQ=
X-Google-Smtp-Source: AK7set88u7q7Wr8ez/4JnUvQ+fnn1pMvVwVXQbEbFK6+/7ZjhsMDk40RDVANoVxJ/gAQEunDlMAsjdK7+A0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:61a9:0:b0:4fd:72f3:5859 with SMTP id
 i9-20020a6561a9000000b004fd72f35859mr401818pgv.2.1678918682510; Wed, 15 Mar
 2023 15:18:02 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:18:01 -0700
In-Reply-To: <20230201194604.11135-5-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230201194604.11135-1-minipli@grsecurity.net> <20230201194604.11135-5-minipli@grsecurity.net>
Message-ID: <ZBJEGfmv42MA6bKh@google.com>
Subject: Re: [PATCH v3 4/6] KVM: x86: Make use of kvm_read_cr*_bits() when
 testing bits
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023, Mathias Krause wrote:
> Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
> want to know the state of certain bits instead of the whole register.
> 
> This not only makes the intend cleaner, it also avoids a VMREAD in case
> the tested bits aren't guest owned.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/pmu.c     | 4 ++--
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d939d3b84e6f..d9922277df67 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -439,9 +439,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	if (!pmc)
>  		return 1;
>  
> -	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
> +	if (!(kvm_read_cr4_bits(vcpu, X86_CR4_PCE)) &&

Purely as an FYI, I proposed adding helpers to query single CR0/CR4 bits in a
separate thread[*].  No need to do anything on your end, I'll plan on applying
this patch first and will handle whatever conflicts arise.

[*] https://lore.kernel.org/all/ZAuRec2NkC3+4jvD@google.com
