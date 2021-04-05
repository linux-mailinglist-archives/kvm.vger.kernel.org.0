Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8269C3545BF
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 19:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhDERCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 13:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhDERB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 13:01:59 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08230C061793
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 10:01:52 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m11so5910426pfc.11
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JofV4HZR03mpEzOFKM8Vp0AM9IHnnmscM74M1/661Ws=;
        b=N7R1edXpxKL54f3bqcC4+fLaznKqZCYbSZF1GAwC07lVtY84OP/Df1x2DMzuOGNgCo
         yOu40YToRKkKizUbxXdtxPDWw8P3nQjBjVvcQMLPuROTezkMlTcc/94SJBfsuJXTLy27
         WbVIkuKGD5lMPFqKlzDY2owZdM22Hnpqk/ofiPRO2HPtdgtXbJVpNlA929FXsl8uk+eq
         5Ngyrh208REL+TSmLbAIcIhEXSKb/GV6PDojObJWQqxxPhvAUPBd07AdYN9UsncgBYyw
         Ow3ys6peXSccRXxAkKHV7+hEx4qALubJCSVz0pjM1Hm4UvRBMbxViUEexXfidfTdRopB
         s7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JofV4HZR03mpEzOFKM8Vp0AM9IHnnmscM74M1/661Ws=;
        b=jIbkj7wXNKOBkxTyOz1EM0vaC3B5a6/CYKaAlfLGbagv/mYHd+3s1jLGRHq5VtXUFU
         0bsoZivUBp7z4R/wxdDdf9Yj6mFw8VuAGYhy8tTyhE4llObnITAhiFadOleUWcq/ivCk
         H5du07LwIvwFBogdZAhwKlzda0A7jUt5DcCef2IX9jYWB4z0g0cNRvS3fJBHZkAGQKUp
         GBaXl/z8Yf0lpHJ3i7EXhhWJDYsf5FB0lNWhWB6zeLoOcgLryDHWwCPWRgCQty81xILp
         eRPcCbgytURP0+dOi+dpplwAhKuV5cr53s4WwvvG4H85rBm8wOXoAcQQ8ATMV93G5Ar6
         PG1A==
X-Gm-Message-State: AOAM531ScU3ZVsCi9tS2uNO6GhTgmUJLlZ+47GfqO7/ooPLuAcWSwelz
        tpPjBY2OHgNn8uVY+UklgJZh7gRU15dnjQ==
X-Google-Smtp-Source: ABdhPJzQtcO+BROgFlDuCeD6hIX35J0fel0VCwBvQ4Mnht7T6GdfpnRLM+P5x0v6rDGPYoODFISPTw==
X-Received: by 2002:a63:67c7:: with SMTP id b190mr23173450pgc.162.1617642111369;
        Mon, 05 Apr 2021 10:01:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d6sm16016464pfn.197.2021.04.05.10.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 10:01:50 -0700 (PDT)
Date:   Mon, 5 Apr 2021 17:01:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: nSVM: avoid loading PDPTRs after migration when
 possible
Message-ID: <YGtCeiyzUrRbbNKG@google.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401141814.1029036-6-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
> part of the migration state and thus are loaded
> by those ioctls.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index ac5e3e17bda4..b94916548cfa 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -373,10 +373,9 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>  		return -EINVAL;
>  
>  	if (!nested_npt && is_pae_paging(vcpu) &&
> -	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
> +	    (cr3 != kvm_read_cr3(vcpu) || !kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR)))
>  		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))

What if we ditch the optimizations[*] altogether and just do:

	if (!nested_npt && is_pae_paging(vcpu) &&
	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
		return -EINVAL;

Won't that obviate the need for KVM_{GET|SET}_SREGS2 since KVM will always load
the PDPTRs from memory?  IMO, nested migration with shadowing paging doesn't
warrant this level of optimization complexity.

[*] For some definitions of "optimization", since the extra pdptrs_changed()
    check in the existing code is likely a net negative.

>  			return -EINVAL;
> -	}
>  
>  	/*
>  	 * TODO: optimize unconditional TLB flush/MMU sync here and in
