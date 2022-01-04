Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138ED484948
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiADUYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiADUYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 15:24:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC318C06137C
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 12:24:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso783940pjc.4
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 12:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sp4h6mNteJvQsGGemPAgFdl7QgNUEHOBWbhu7Dn9sPM=;
        b=H1RFIZqleJZQlzRH7il0JNjNDZw/4hqE4Rmnzwzn9kr4i5ElDkNTaSwZC0FDVAogMx
         RwEwpZ9qThHJllDcTv2mFQQqXZ3V8Rct9dg/TjVOkzakkdpFZfr53pNP3Q3O9ClCg5eY
         TWbQh2rK+wTiUhYSYJqT9gqJbHOitzkDwvmGUZJDK6UvQWA7TFQ2yr+BvilnPwitTe3d
         X99EjD6npYtyNRgqS/mIP4TOWqx+as71r6trCcFr+GglH5MWpPl8u50G8j+8b+q4T+wE
         rhQyMqQ5Ji/2jU1vkzRgMLUV9oNmsrSiLfBVQsrG7A6RqCyntotJgpxx+F3km7WoVAKT
         5gjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sp4h6mNteJvQsGGemPAgFdl7QgNUEHOBWbhu7Dn9sPM=;
        b=KqLIrAqUbKzfqrDqcPE4a00ZaY9BlX30pUlyejYVYrd3OAznwjY8d7XDpvk7oWvPtO
         axsP5J1N9wk0ilUpcqXH77zcfhlhEW31QRmYWkm3cWck9tSDuaCGcOQvixWXd+A6TfSI
         TUNz7FwkyVneurIWnyLPcLbismSPaYa5R9vXh+4hFimS86e4a99Wj0x7tA4BKMo4QBqu
         2m5eUaSBiVniP/MYsEwPKiUjRH5NkiH2Gnvn440bV55saumLaPxJAhs5U1i8ViNJIwm/
         XcJ19tdDH7dhcDo2QUy5A3T5JOPrg0xVECfcoud2RWG2f6gMK19TlpdjgReCyxC4zCdL
         Q0nQ==
X-Gm-Message-State: AOAM532ZPzH8V7IzZduGbbi2kzDIlqaTiVRIpDdkn1iDVebJdKNz5YMG
        mfmYanK0yYN/a02QTSGrnnVY9w==
X-Google-Smtp-Source: ABdhPJzJymv40G7eZ/5gTaFXTW+l58FMhoIFIlaAxGAd4DjGkNGFbyn1HaTIyqbkyyh0yf3aaTzfwA==
X-Received: by 2002:a17:902:ea0a:b0:149:1f26:bce1 with SMTP id s10-20020a170902ea0a00b001491f26bce1mr51396836plg.92.1641327858272;
        Tue, 04 Jan 2022 12:24:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e15sm43814047pfv.23.2022.01.04.12.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:24:17 -0800 (PST)
Date:   Tue, 4 Jan 2022 20:24:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 1/6] KVM: X86: Check root_level only in
 fast_pgd_switch()
Message-ID: <YdSs7ocQoy6txrMu@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210092508.7185-2-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> If root_level >= 4, shadow_root_level must be >= 4 too.

Please explain why so that it's explicitly clear why this ok, e.g.

  Drop the shadow_root_level check when determining if a "fast" PGD switch
  is allowed, as KVM never shadows 64-bit guest pages tables with PAE paging
  (32-bit KVM doesn't support 64-bit guests).

with that:

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Checking only root_level can reduce a check.
>
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 11b06d536cc9..846a2e426e0b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4136,8 +4136,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
>  	 * later if necessary.
>  	 */
> -	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> -	    mmu->root_level >= PT64_ROOT_4LEVEL)
> +	if (mmu->root_level >= PT64_ROOT_4LEVEL)
>  		return cached_root_available(vcpu, new_pgd, new_role);
>  
>  	return false;
> -- 
> 2.19.1.6.gb485710b
> 
