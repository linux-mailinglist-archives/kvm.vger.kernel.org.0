Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F743545C7
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 19:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhDERDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhDERDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 13:03:22 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0D3C061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 10:03:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s11so8556500pfm.1
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 10:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H6rn7p+vVu7v3cm9ggHsAaaGPQfvah3STH9aVY90oQ0=;
        b=sPm3lazYQmNyXZyNZwqe3R9UHhfNsl5/ShT7hPs3TtJJhgVVYq8UgkcXx2rAi/Dcfa
         V/fxOlwOjx3j/UhDO8hOJfR9dFnx+psTIUzKtGNIzps+yoYpP5ruuljEl4pGNCcWXYOh
         iImfIRnO/mX63IgjMHuI8b6cZ+ajICxv/9f+e+eAgCyE40Pjl+/09AEP7xxNg4o09aY9
         SASbcyBaPTgS0V0iwbtvXB8XKL5AfBauJR+IAqlDbtnvo76br0fAQOGODJK+zcEMnKrA
         GTzev8aA0OHMthRZQRn6Ip5JNcVHZ8atYPOYVn4qB+K2yFZJcKFwv0KQSg3glhzvhsMw
         OY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H6rn7p+vVu7v3cm9ggHsAaaGPQfvah3STH9aVY90oQ0=;
        b=eEdnfayRg6EppLaUvHe7h3o+/TOOoG6qRJ6MpoQW7yF6LE4DMobCEWbw1OhMc1fc4L
         gFmk9JYk6e5bivCgWXoIttO6q4r4eWjAisVwsuqD2c4ojkDNvgW4s5NCyOpH/KvCOih1
         YIPxYp+jumJcfN9GxVLQJoFvaMlpAA61d3mZyHLPCXIWAU6z5PAxDi1Z+eCBmcSW3YEC
         ifOlxdNPbGW9qusNQ6CBxyFpE6mss/uba0Fyj2ii8ee5mx740rvo0zKMHeeBEMkF5akO
         6wPe2Rjou4Kp4yzD82gJbeJjFsjVqUJOmLKP9XvFgpLhfIReALefaqAmmPAclpeZeukI
         8zBQ==
X-Gm-Message-State: AOAM531pSx6gCXVfMgCKSlTr6W1DsML5BJ1QvnvBhNusXrEiE8gqQCHS
        HpNvfmgdKXd9lverSBVxKDMYng==
X-Google-Smtp-Source: ABdhPJzHaUJR34DNX2bq1apPA9eX7C5JcfO8192VNXCy3QSvBk/c9bga925ePSoKMGO8XMoOp5DIGA==
X-Received: by 2002:a63:4547:: with SMTP id u7mr6253524pgk.351.1617642194450;
        Mon, 05 Apr 2021 10:03:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h19sm16586915pfc.172.2021.04.05.10.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 10:03:13 -0700 (PDT)
Date:   Mon, 5 Apr 2021 17:03:10 +0000
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
Subject: Re: [PATCH 3/6] KVM: x86: introduce kvm_register_clear_available
Message-ID: <YGtCzhDbnAQVgI+8@google.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
 <20210401141814.1029036-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401141814.1029036-4-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> Small refactoring that will be used in the next patch.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/kvm_cache_regs.h | 7 +++++++
>  arch/x86/kvm/svm/svm.c        | 6 ++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 2e11da2f5621..07d607947805 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -55,6 +55,13 @@ static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
>  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>  }
>  
> +static inline void kvm_register_clear_available(struct kvm_vcpu *vcpu,

I don't love the name, because it makes me think too hard about available vs.
dirty.  :-)   If we drop the optimizations, what if we also drop this patch to
avoid bikeshedding the name?

> +					       enum kvm_reg reg)
> +{
> +	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> +	__clear_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> +}
> +
>  static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>  					   enum kvm_reg reg)
>  {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 271196400495..2843732299a2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3880,10 +3880,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  		vcpu->arch.apf.host_apf_flags =
>  			kvm_read_and_reset_apf_flags();
>  
> -	if (npt_enabled) {
> -		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
> -		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
> -	}
> +	if (npt_enabled)
> +		kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
>  
>  	/*
>  	 * We need to handle MC intercepts here before the vcpu has a chance to
> -- 
> 2.26.2
> 
