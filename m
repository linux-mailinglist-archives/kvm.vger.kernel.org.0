Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58940427B
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348447AbhIIBBA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbhIIBA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:00:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA7C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 17:59:50 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w8so91931pgf.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 17:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+skelFXIoWIkrKLr6CZhOX3+XRhfx0jAypY81q8tXes=;
        b=bDXtLAxc0QTEGwuPB4BpV5MwfOExqCh6SOcn6sl78G0rk2KyS/7t/43bkeMa42c7hT
         WS5wDE+COtY9/oeShxIinKm/YYKeBosOPiq33KYtUsGH1/wfHqGRHAivyzCWPSGSsvIs
         ogAUuO8rIqac1QwMasp/Uyd923UlRu2mLxHnX97Uo+aGfnFs79fvBtD+e6soYgRTPHyL
         XtEMYM3n6Su4mpgA1x2UC67i8YguJEE09sAYwGP5fqo9gqnfgOziwSp1ro+On5Cr+wAm
         bwUZReVStJwa0+YinWRK3IQQy8Z4KSmp3SEZsiH6GHpFCj/ZQ39uzhRC3F4mMqg+KLBM
         1lfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+skelFXIoWIkrKLr6CZhOX3+XRhfx0jAypY81q8tXes=;
        b=UljlOrJObD4vMC6Z8LGKChMjD0AsHqM1uqrVLhbJyrmDpCvL7ASvpVG34I/36+Xe85
         lsXg/j2+ySYDFUulLescPAOG5jZUlOBpEt5/E2818dpabwbwvt43GftRIiYUOPCoAcW3
         eeA8vJM2r0pQdGk0R/KxNjzOv5yuly1rFroYjk6QYMbP/UiqLex5mZcEZ3Z6nTDMSiZ/
         O3pGWOKNtYB4YA29Jqry8TONSLRznT+tbAf4k04ksTl2fHz0/tGzYGW1xzFlB77qpkac
         9La8McxsEEed0DIYRwBjUllDgp118s5JMBgoyxet1MW5/WSfn9Wr8PspGC5vEstZW7kP
         SeMg==
X-Gm-Message-State: AOAM530nXiVvsxpGWuFDZIVdGbN0nUnNPxtggr586w8PET9guf/oGWzm
        L8SL2Cz9VgvPhH4q010DFYR8Zg==
X-Google-Smtp-Source: ABdhPJzFGMI7uROSNy8dgOLtor1ehcyy8X2z5pKcJg5Vnt52TiX0g1lTWhuXMIAx3VAns+bYKPHe2w==
X-Received: by 2002:a62:76c8:0:b0:3f2:6a5:b8eb with SMTP id r191-20020a6276c8000000b003f206a5b8ebmr480442pfc.58.1631149189425;
        Wed, 08 Sep 2021 17:59:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h191sm96640pfe.78.2021.09.08.17.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 17:59:48 -0700 (PDT)
Date:   Thu, 9 Sep 2021 00:59:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: nSVM: call KVM_REQ_GET_NESTED_STATE_PAGES on
 exit from SMM mode
Message-ID: <YTlcgQHLmkjtvVks@google.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
 <20210823114618.1184209-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823114618.1184209-4-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021, Maxim Levitsky wrote:
> This allows nested SVM code to be more similar to nested VMX code.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 9 ++++++---
>  arch/x86/kvm/svm/svm.c    | 8 +++++++-
>  arch/x86/kvm/svm/svm.h    | 3 ++-
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5e13357da21e..678fd21f6077 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -572,7 +572,7 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
>  }
>  
>  int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
> -			 struct vmcb *vmcb12)
> +			 struct vmcb *vmcb12, bool from_entry)

from_vmrun would be a better name.  VMX uses the slightly absstract from_vmentry
because of the VMLAUNCH vs. VMRESUME silliness.  If we want to explicitly follow
VMX then from_vmentry would be more appropriate, but I don't see any reason not
to be more precise.

>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	int ret;
> @@ -602,13 +602,16 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>  	nested_vmcb02_prepare_save(svm, vmcb12);
>  
>  	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
> -				  nested_npt_enabled(svm), true);
> +				  nested_npt_enabled(svm), from_entry);
>  	if (ret)
>  		return ret;
>  
>  	if (!npt_enabled)
>  		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
>  
> +	if (!from_entry)
> +		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +
>  	svm_set_gif(svm, true);
>  
>  	return 0;
> @@ -674,7 +677,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  
>  	svm->nested.nested_run_pending = 1;
>  
> -	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12))
> +	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
>  		goto out_exit_err;
>  
>  	if (nested_svm_vmrun_msrpm(svm))
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ea7a4dacd42f..76ee15af8c48 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4354,6 +4354,12 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  			if (svm_allocate_nested(svm))
>  				return 1;
>  
> +			/* Exit from the SMM to the non root mode also uses
> +			 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
> +			 * but in this case the pdptrs must be always reloaded
> +			 */
> +			vcpu->arch.pdptrs_from_userspace = false;

Hmm, I think this belongs in the previous patch.  And I would probably go so far
as to say it belongs in emulator_leave_smm(), i.e. pdptrs_from_userspace should
be cleared on RSM regardless of what mode is being resumed.

> +
>  			/*
>  			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
>  			 * used during SMM (see svm_enter_smm())
> @@ -4368,7 +4374,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  
>  			vmcb12 = map.hva;
>  			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> -			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
> +			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
>  
>  			kvm_vcpu_unmap(vcpu, &map, true);
>  			kvm_vcpu_unmap(vcpu, &map_save, true);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 524d943f3efc..51ffa46ab257 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -459,7 +459,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>  	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
>  }
>  
> -int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
> +int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
> +		u64 vmcb_gpa, struct vmcb *vmcb12, bool from_entry);

Alignment is funky, it can/should match the definition, e.g.

int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
			 struct vmcb *vmcb12, bool from_entry);

>  void svm_leave_nested(struct vcpu_svm *svm);
>  void svm_free_nested(struct vcpu_svm *svm);
>  int svm_allocate_nested(struct vcpu_svm *svm);
> -- 
> 2.26.3
> 
