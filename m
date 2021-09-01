Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA63FE49B
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245159AbhIAVNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245267AbhIAVNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:13:12 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9B1C061760
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:12:15 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so780997pga.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=egGMiPBBKlMbvE9KfJkUfu/tC90iKtmhmrZtESxeA28=;
        b=ncreY0Gm4kTVQgl+kXCW0CKEReUCKnUK13+j8VNBk3y9UZw+yTehvdd/AY70Kv2rhM
         1Cdw1qYid5Nd/nyvRZ5m48JFj44/RkoiiV9o82xeVWF4q3aE1f5qX22OSK40jCSy2BAY
         hc/66Mxogl+2uVO+FcHPtfoCXVMoNAEsiGlKdJd0gLmxQXO62S6JRtvPZfK5GfpQlnXg
         aY70KSzqfqfEMBfimNc6hBVUHSYO29XSZ65jwxHwc/4Ds6HliyWNgw1tZRPl/6geHSW+
         AOVWvfND7s1JWPMF+7XKgIf8OXGQwS+QCvMfH0JB6TbPXDs7aZmymFSaZQBU0eH58nhp
         2USg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=egGMiPBBKlMbvE9KfJkUfu/tC90iKtmhmrZtESxeA28=;
        b=pRmlfirVpXOiupl0OQDwHrrlS/PUgAl77oz4qPpPhC7pUVZHlvDuAPcee1cL2tYZ3a
         IBMxOZnwj+VF1KyEN5mgOp37+QDw2NV/yx/5EZW6zop8+OiYdU7hBOJp5xXK/qfjWfOi
         mTKdR3D++/NDe9vSJ8l6s1F1dwE2yTB5HVdA6j7g9s5Z8psKuOJrUDmW3tR7CQsoagrl
         id517z6gCPerVjH/gj+tR/RQWZXW9mWt8D6fEn380lFbbOUDCWUyOaTtUM/qRS1rEZXn
         eU2Ktnrpt21SbnnKSyhBSULMdRzOO4w+tOcpwD6erNPPZMJMolP8yxrbcFefQ5ysobdB
         XlKA==
X-Gm-Message-State: AOAM533v1sR26uD0UiMBTqU+NFwXIVjJFdjUgpcnrfk2dKifJ3InpUFY
        S997TVf+bsdNjNqzSBNJcefEBA==
X-Google-Smtp-Source: ABdhPJy3VX9/rugZqsvUuY11nVn0KvcSxu495Gm1ySWZOt0bryjTUs7dumso/OrB8JrD71zF4IUzcA==
X-Received: by 2002:a05:6a00:15c4:b0:3eb:2447:97bd with SMTP id o4-20020a056a0015c400b003eb244797bdmr1343500pfu.4.1630530734724;
        Wed, 01 Sep 2021 14:12:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y12sm550751pgl.65.2021.09.01.14.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:12:14 -0700 (PDT)
Date:   Wed, 1 Sep 2021 21:12:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2 1/4] KVM: SVM: Get rid of *ghcb_msr_bits() functions
Message-ID: <YS/sqmgbS6ACRfSD@google.com>
References: <20210722115245.16084-1-joro@8bytes.org>
 <20210722115245.16084-2-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722115245.16084-2-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 22, 2021, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Replace the get function with macros and the set function with
> hypercall specific setters. This will avoid preserving any previous
> bits in the GHCB-MSR and improved code readability.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/sev-common.h |  9 +++++++
>  arch/x86/kvm/svm/sev.c            | 41 +++++++++++--------------------
>  2 files changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 2cef6c5a52c2..8540972cad04 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -50,6 +50,10 @@
>  		(GHCB_MSR_CPUID_REQ | \
>  		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
>  		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
> +#define GHCB_MSR_CPUID_FN(msr)		\
> +	(((msr) >> GHCB_MSR_CPUID_FUNC_POS) & GHCB_MSR_CPUID_FUNC_MASK)
> +#define GHCB_MSR_CPUID_REG(msr)		\
> +	(((msr) >> GHCB_MSR_CPUID_REG_POS) & GHCB_MSR_CPUID_REG_MASK)
>  
>  /* AP Reset Hold */
>  #define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
> @@ -67,6 +71,11 @@
>  #define GHCB_SEV_TERM_REASON(reason_set, reason_val)						  \
>  	(((((u64)reason_set) &  GHCB_MSR_TERM_REASON_SET_MASK) << GHCB_MSR_TERM_REASON_SET_POS) | \
>  	((((u64)reason_val) & GHCB_MSR_TERM_REASON_MASK) << GHCB_MSR_TERM_REASON_POS))
> +#define GHCB_MSR_TERM_REASON_SET(msr)	\
> +	(((msr) >> GHCB_MSR_TERM_REASON_SET_POS) & GHCB_MSR_TERM_REASON_SET_MASK)
> +#define GHCB_MSR_TERM_REASON(msr)	\
> +	(((msr) >> GHCB_MSR_TERM_REASON_POS) & GHCB_MSR_TERM_REASON_MASK)
> +
>  
>  #define GHCB_SEV_ES_REASON_GENERAL_REQUEST	0
>  #define GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED	1
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6710d9ee2e4b..d7b3557b8dbb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2342,16 +2342,15 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  	return true;
>  }
>  
> -static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
> -			      unsigned int pos)
> +static void set_ghcb_msr_cpuid_resp(struct vcpu_svm *svm, u64 reg, u64 value)
>  {
> -	svm->vmcb->control.ghcb_gpa &= ~(mask << pos);
> -	svm->vmcb->control.ghcb_gpa |= (value & mask) << pos;
> -}
> +	u64 msr;
>  
> -static u64 get_ghcb_msr_bits(struct vcpu_svm *svm, u64 mask, unsigned int pos)
> -{
> -	return (svm->vmcb->control.ghcb_gpa >> pos) & mask;
> +	msr  = GHCB_MSR_CPUID_RESP;
> +	msr |= (reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS;
> +	msr |= (value & GHCB_MSR_CPUID_VALUE_MASK) << GHCB_MSR_CPUID_VALUE_POS;
> +
> +	svm->vmcb->control.ghcb_gpa = msr;

I would rather have the get/set pairs be roughly symmetric, i.e. both functions
or both macros, and both work on svm->vmcb->control.ghcb_gpa or both be purely
functional (that may not be the correct word).

I don't have a strong preference on function vs. macro.  But for the second one,
my preference would be to have the helper generate the value as opposed to taken
and filling a pointer, e.g. to yield something like:

		cpuid_reg = GHCB_MSR_CPUID_REG(control->ghcb_gpa);

		if (cpuid_reg == 0)
			cpuid_value = vcpu->arch.regs[VCPU_REGS_RAX];
		else if (cpuid_reg == 1)
			cpuid_value = vcpu->arch.regs[VCPU_REGS_RBX];
		else if (cpuid_reg == 2)
			cpuid_value = vcpu->arch.regs[VCPU_REGS_RCX];
		else
			cpuid_value = vcpu->arch.regs[VCPU_REGS_RDX];

		control->ghcb_gpa = MAKE_GHCB_MSR_RESP(cpuid_reg, cpuid_value);


The advantage is that it's obvious from the code that control->ghcb_gpa is being
read _and_ written.

>  	case GHCB_MSR_TERM_REQ: {
>  		u64 reason_set, reason_code;
>  
> -		reason_set = get_ghcb_msr_bits(svm,
> -					       GHCB_MSR_TERM_REASON_SET_MASK,
> -					       GHCB_MSR_TERM_REASON_SET_POS);
> -		reason_code = get_ghcb_msr_bits(svm,
> -						GHCB_MSR_TERM_REASON_MASK,
> -						GHCB_MSR_TERM_REASON_POS);
> +		reason_set  = GHCB_MSR_TERM_REASON_SET(control->ghcb_gpa);
> +		reason_code = GHCB_MSR_TERM_REASON(control->ghcb_gpa);
> +
>  		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>  			reason_set, reason_code);
> +
>  		fallthrough;

Not related to this patch, but why use fallthrough and more importantly, why is
this an -EINVAL return?  Why wouldn't KVM forward the request to userspace instead
of returning an opaque -EINVAL?

>  	}
>  	default:
> -- 
> 2.31.1
> 
