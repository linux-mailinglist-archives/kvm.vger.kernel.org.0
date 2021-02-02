Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20730CA0B
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbhBBSgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhBBSfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:35:14 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4B4C061786
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:34:34 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id my11so2091300pjb.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SRQsPU+8cINOtXYJC77LcCM6FVLCXTrqA6tOxDVoZko=;
        b=IHk8vWUEEUgdoQEqoP/XXTqMnSFwMtXjG73bdIJmszSyk4i14Oqe6dbgKgkq9mGO3i
         wKJUxbzL6hONGQTVPUCLPSmilqYwJnAhGZ6q7/SN1Jw/IhxsgOCnGMF1yMwZJbxswxsd
         0VRS5c35HuFh82OksksSJD8goP6feADzHnlYpSt3Fx4Rf1JtO1RzZPjxRwAPLdvm8S9z
         RhfyViw8heopA2eN/jDkzOitCCGKk6MUmzNaK6kN0384YKDlKptkpukqYQ2E+gnN2zDT
         /HQpUYUba3eSs6k2IS3rs05HP+kjTBgH/zdet4v9iT0/5Wgt8GURDQ9fKjX5ZIygZCxs
         7U2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRQsPU+8cINOtXYJC77LcCM6FVLCXTrqA6tOxDVoZko=;
        b=StghyTPIRJmvQj7weXd1tmcI49AjJdo0rY3XfUAIX0/ZD/JKv4+o8dJwY8JxoFGmdm
         lmaTA0Ooz/lFfCHhwHbX+fnViwlTCyu5fR3s7intqgetcEaOQg1wQFwRdM7O6fYJa/ly
         CdzveCzSpbNqvDdiMVTNwgt3+uncr6cWI7ZKEkrswmFEjHwPDSgycWjNDr94BU35eRK+
         PasvYIrr0FBSVN474HpDLp66uVnUlBmDFXUjZqNAf8NN4Ut5pW+EK469wBF5UDfwEYT8
         dSgk+u5viuLhRpi6LfcpDBlFgGwtr586ZWIKjtA/GcyQz/zk0Ym5Liz3aiAlX0aaeS6k
         l/rw==
X-Gm-Message-State: AOAM5332hsZmd3kJjPD+RM/ERTww0T97SHC/zNKPvo6+a0C8kFjH7q1L
        M2XaD26rpTKtSW8kr7YozKaPLA==
X-Google-Smtp-Source: ABdhPJzBjXGyAEW3TNQ+QcdbZViBQoQQxzzhFQMUEU1TNQKTkGQcMeedqdqygFVf0+S43eL0onCuGQ==
X-Received: by 2002:a17:90a:c404:: with SMTP id i4mr5801933pjt.57.1612290873583;
        Tue, 02 Feb 2021 10:34:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id cq2sm3250564pjb.55.2021.02.02.10.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 10:34:32 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:34:27 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: cleanup CR3 reserved bits checks
Message-ID: <YBmbM8PToDWr9ti/@google.com>
References: <20210202170244.89334-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202170244.89334-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Paolo Bonzini wrote:
> If not in long mode, the low bits of CR3 are reserved but not enforced to
> be zero, so remove those checks.  If in long mode, however, the MBZ bits
> extend down to the highest physical address bit of the guest, excluding
> the encryption bit.
> 
> Make the checks consistent with the above, and match them between
> nested_vmcb_checks and KVM_SET_SREGS.
> 

Fixes + Cc:stable@?

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 

> ---
>  arch/x86/kvm/svm/nested.c | 12 ++----------
>  arch/x86/kvm/svm/svm.h    |  3 ---
>  arch/x86/kvm/x86.c        |  2 ++
>  3 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index eecb548bdda6..9ee542ea3f56 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -244,18 +244,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
>  
>  	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
>  
> -	if (!vmcb12_lma) {
> -		if (vmcb12->save.cr4 & X86_CR4_PAE) {
> -			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> -				return false;
> -		} else {
> -			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> -				return false;
> -		}
> -	} else {
> +	if (vmcb12_lma) {
>  		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
>  		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
> -		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
> +		    (vmcb12->save.cr3 & svm->vcpu.arch.cr3_lm_rsvd_bits))

Gah, I was too slow as usual.  I have a series to clean up GPA validity checks,
this one included.  I'll base that series on this patch, if I get it sent before
this hits kvm/queue...

>  			return false;
>  	}
>  	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0fe874ae5498..6e7d070f8b86 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -403,9 +403,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
>  }
>  
>  /* svm.c */
> -#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
> -#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
> -#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
>  #define MSR_INVALID				0xffffffffU
>  
>  extern int sev;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b748bf0d6d33..97674204bf44 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9660,6 +9660,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  		 */
>  		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
>  			return false;
> +		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
> +			return false;
>  	} else {
>  		/*
>  		 * Not in 64-bit mode: EFER.LMA is clear and the code
> -- 
> 2.26.2
> 
