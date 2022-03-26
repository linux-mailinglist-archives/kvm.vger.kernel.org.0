Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1534E7B41
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiCZAQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 20:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiCZAQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 20:16:48 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A06520596B
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 17:15:12 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b15so7871404pfm.5
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 17:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FQC7h1s3zGX5GsUNU5SzN2ybagH0IG2NIZcge3j4zR8=;
        b=cX0k5vpCCINgqk/XWr7uhcEBno8PpNyK3xCVWey4nAgzH3x7TjTqPgtCnn9eNmOtOx
         dj598b5tiak3WM/RgD6OXJrvcb+VwYMN6vypMLGvDGpYIXXwRvBABhhfBiVnMvYrVcKs
         ZrbczYRTRW3kq4Jkt2hIqtPAMfdsDQsbLHEwrvNktQUgobgH0TWAytBeMbWW+M/19MPE
         JcmyfRTUncHfaNXhjXVukeFEnrMAFHG17jB4+AnmxRb+7HrNj9M+2mbEZBejg/rTMRAz
         09kqtCu5DNd1KwmQdqmUvEz3h7rehEviLOISQtWWiNzafgH2q+AbVobcRhFg4l+AjbAs
         3srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FQC7h1s3zGX5GsUNU5SzN2ybagH0IG2NIZcge3j4zR8=;
        b=eo45wK+1FPNQw3/5WRJmoUh/9DB06I07ghz4rGYrbL8dWnD1esz9/8+OwHZL/idVjS
         e+GtX9DZ0fZp2iHQmh9dEdV0/HHKKTKJQP+075MyxfZ0YRPktAo3LptKV7Eyzbw4JRBE
         gegRPF3EajWmJxB2nsXQG/R3hWK71PksmximrsgaOGMKVPEl/A27YBLwI9z8v/l6YK7J
         ciNh/iwBxJPJTAlH2CA8DGFMRz4WgwCLXyYK3EivyJiTF/oMjcwlu1+CQABjeqt3RUjh
         As6q5XyV91khv0mzMx1CDGaAj2jq3iYQQ/wmMr1zKnWaAr7kVxQv5NvoilH2TQ31yAGN
         s3/A==
X-Gm-Message-State: AOAM532p9qPq25dTmxVv7fTO07nMZklNsfraXMktlVMgoB1NaT1BVuvE
        ZmRCC98ZSIdWRXZks9Mghg7IhQ==
X-Google-Smtp-Source: ABdhPJz7Zd+S4ualUAy9FGz5K65CXMsHQ4ZW4z+SUIX3w3/c+14i5OyEW+DZJt0AjOPrSGJeheWkSQ==
X-Received: by 2002:a63:742:0:b0:382:2684:dd41 with SMTP id 63-20020a630742000000b003822684dd41mr1611016pgh.38.1648253711595;
        Fri, 25 Mar 2022 17:15:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l23-20020a17090a071700b001c67a95e7fbsm6987733pjl.47.2022.03.25.17.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 17:15:10 -0700 (PDT)
Date:   Sat, 26 Mar 2022 00:15:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Message-ID: <Yj5bCw0q5n4ZgSuU@google.com>
References: <20220324004439.6709-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324004439.6709-1-jon@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022, Jon Kohler wrote:
> kvm_load_{guest|host}_xsave_state handles xsave on vm entry and exit,
> part of which is managing memory protection key state. The latest
> arch.pkru is updated with a rdpkru, and if that doesn't match the base
> host_pkru (which about 70% of the time), we issue a __write_pkru.
> 
> To improve performance, implement the following optimizations:
>  1. Reorder if conditions prior to wrpkru in both
>     kvm_load_{guest|host}_xsave_state.
> 
>     Flip the ordering of the || condition so that XFEATURE_MASK_PKRU is
>     checked first, which when instrumented in our environment appeared
>     to be always true and less overall work than kvm_read_cr4_bits.

If it's always true, then it should be checked last, not first.  And if
kvm_read_cr4_bits() is more expensive then we should address that issue, not
try to micro-optimize this stuff.  X86_CR4_PKE can't be guest-owned, and so
kvm_read_cr4_bits() should be optimized down to:

	return vcpu->arch.cr4 & X86_CR4_PKE;

If the compiler isn't smart enough to do that on its own then we should rework
kvm_read_cr4_bits() as that will benefit multiple code paths.

>     For kvm_load_guest_xsave_state, hoist arch.pkru != host_pkru ahead
>     one position. When instrumented, I saw this be true roughly ~70% of
>     the time vs the other conditions which were almost always true.
>     With this change, we will avoid 3rd condition check ~30% of the time.

If the guest uses PKRU...  If PKRU is used by the host but not the guest, the
early comparison is pure overhead because it will almost always be true (guest
will be zero, host will non-zero), 

>  2. Wrap PKU sections with CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS,
>     as if the user compiles out this feature, we should not have
>     these branches at all.

Not that it really matters, since static_cpu_has() will patch out all the branches,
and in practice who cares about a JMP or NOP(s)?  But...

#ifdeffery is the wrong way to handle this.  Replace static_cpu_has() with
cpu_feature_enabled(); that'll boil down to a '0' and omit all the code when
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=n, without the #ifdef ugliness.

> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  arch/x86/kvm/x86.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6db3a506b402..2b00123a5d50 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -950,11 +950,13 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>  			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>  	}
> 
> +#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
>  	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
> -	    vcpu->arch.pkru != vcpu->arch.host_pkru)
> +	    vcpu->arch.pkru != vcpu->arch.host_pkru &&
> +	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
>  		write_pkru(vcpu->arch.pkru);
> +#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
>  }
>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
> 
> @@ -963,13 +965,15 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.guest_state_protected)
>  		return;
> 
> +#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
>  	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> -	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
> +	    ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> +	     kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
>  		vcpu->arch.pkru = rdpkru();
>  		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>  			write_pkru(vcpu->arch.host_pkru);
>  	}
> +#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
> 
>  	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
> 
> --
> 2.30.1 (Apple Git-130)
> 
