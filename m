Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7665554025B
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbiFGP0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243190AbiFGP0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:26:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 126DCB226F
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654615571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HuCZf+EG4tjlRlQ6eyt+b3Zz/g4UZvXSEMkRpd1yJXs=;
        b=MF9Zp8r0nqAt5feT5CsBNq4kVsMiFLgKH47HgQxTg6/PHbtX9+hLO9BJIhZz9U4rDoHq0l
        v/JQoHzhGzDFgtEwB2vGkxFpYEMkkZ5B8tYqh9CftuTkEhAzzKJ/t5UFCvQm87L5HMtvhl
        3rxPRLTsOd8plQ4RxZWir7bSHOttkDY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-Sa4BSHxOOZCK6eRv9HDPAA-1; Tue, 07 Jun 2022 11:26:10 -0400
X-MC-Unique: Sa4BSHxOOZCK6eRv9HDPAA-1
Received: by mail-wr1-f69.google.com with SMTP id i10-20020a5d55ca000000b002103d76ffcaso4058112wrw.17
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 08:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HuCZf+EG4tjlRlQ6eyt+b3Zz/g4UZvXSEMkRpd1yJXs=;
        b=lxSuE6E62M+2htgK37Z7JWft8XlhN1ddto0x7yVw2EArCBlT+PS+u6xp/fTUKTavPT
         QCOG2gz7th2/aEuroQn1N9CulkPLDnOBoqWEkEN/hbRz7NKdmy6nBUaCE+D2sCmSAsVs
         Xzx4lAVGAcrncu3H0T632/caoI9iRSdapKqO2nGvxCgCFe8b7rh24NGhaUSuFCNd0maP
         /uqEkOKMMzdQnpxCbtaexk0ZFv4TOSgcPMYu3IFIGvCD17A8cAKOryVJ3Q8dpNpALXR4
         5WPVJZSn7KTh/AhbdaGzQcuU7uXC4taqvZAUEudtCrKAV7U257wmRSNFIQbMR7RPhXSx
         Ojmg==
X-Gm-Message-State: AOAM5339m+xp1yeYQA+YpPl8sl1sDBzhuf/KoTf52FWYod1U4cmmoXeU
        O3c20lrGhXhPab+zju97suFYXvz8lSfwSYuSxMLbBhfnKlmivgzy0kRm6nbURZSuSY2p0JUpU7x
        lrTU8KfzBoVSF
X-Received: by 2002:a05:600c:2e48:b0:39c:55ba:e4e9 with SMTP id q8-20020a05600c2e4800b0039c55bae4e9mr7834494wmf.180.1654615568692;
        Tue, 07 Jun 2022 08:26:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzURo0IvLNNJyb01U71GmD/UPNpY1M0FxVGqPYO6LI3DeN+Bfbg+IXG3677DlNpT4wuUumYJw==
X-Received: by 2002:a05:600c:2e48:b0:39c:55ba:e4e9 with SMTP id q8-20020a05600c2e4800b0039c55bae4e9mr7834445wmf.180.1654615568293;
        Tue, 07 Jun 2022 08:26:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h1-20020a05600c414100b0039c5cecf206sm1000625wmm.4.2022.06.07.08.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 08:26:07 -0700 (PDT)
Message-ID: <f6b48819-9c0e-69f7-de07-2d49cd0aa1c1@redhat.com>
Date:   Tue, 7 Jun 2022 17:26:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: SVM: fix tsc scaling cache logic
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Ilias Stamatis <ilstam@amazon.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
References: <20220606181149.103072-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220606181149.103072-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/22 20:11, Maxim Levitsky wrote:
> SVM uses a per-cpu variable to cache the current value of the
> tsc scaling multiplier msr on each cpu.
> 
> Commit 1ab9287add5e2
> ("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
> broke this caching logic.
> 
> Refactor the code so that all TSC scaling multiplier writes go through
> a single function which checks and updates the cache.
> 
> This fixes the following scenario:
> 
> 1. A CPU runs a guest with some tsc scaling ratio.
> 
> 2. New guest with different tsc scaling ratio starts on this CPU
>     and terminates almost immediately.
> 
>     This ensures that the short running guest had set the tsc scaling ratio just
>     once when it was set via KVM_SET_TSC_KHZ. Due to the bug,
>     the per-cpu cache is not updated.
> 
> 3. The original guest continues to run, it doesn't restore the msr
>     value back to its own value, because the cache matches,
>     and thus continues to run with a wrong tsc scaling ratio.
> 
> 
> Fixes: 1ab9287add5e2 ("KVM: X86: Add vendor callbacks for writing the TSC multiplier")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c |  4 ++--
>   arch/x86/kvm/svm/svm.c    | 32 ++++++++++++++++++++------------
>   arch/x86/kvm/svm/svm.h    |  2 +-
>   3 files changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 88da8edbe1e1f..83bae1f2eeb8a 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1037,7 +1037,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
>   		WARN_ON(!svm->tsc_scaling_enabled);
>   		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> -		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
> +		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
>   	}
>   
>   	svm->nested.ctl.nested_cr3 = 0;
> @@ -1442,7 +1442,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
>   	vcpu->arch.tsc_scaling_ratio =
>   		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
>   					       svm->tsc_ratio_msr);
> -	svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
> +	__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
>   }
>   
>   /* Inverse operation of nested_copy_vmcb_control_to_cache(). asid is copied too. */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4aea82f668fb1..5c873db9432e5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -512,11 +512,24 @@ static int has_svm(void)
>   	return 1;
>   }
>   
> +void __svm_write_tsc_multiplier(u64 multiplier)
> +{
> +	preempt_disable();
> +
> +	if (multiplier == __this_cpu_read(current_tsc_ratio))
> +		goto out;
> +
> +	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
> +	__this_cpu_write(current_tsc_ratio, multiplier);
> +out:
> +	preempt_enable();
> +}
> +
>   static void svm_hardware_disable(void)
>   {
>   	/* Make sure we clean up behind us */
>   	if (tsc_scaling)
> -		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
> +		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
>   
>   	cpu_svm_disable();
>   
> @@ -562,8 +575,7 @@ static int svm_hardware_enable(void)
>   		 * Set the default value, even if we don't use TSC scaling
>   		 * to avoid having stale value in the msr
>   		 */
> -		wrmsrl(MSR_AMD64_TSC_RATIO, SVM_TSC_RATIO_DEFAULT);
> -		__this_cpu_write(current_tsc_ratio, SVM_TSC_RATIO_DEFAULT);
> +		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
>   	}
>   
>   
> @@ -1046,11 +1058,12 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>   	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
>   }
>   
> -void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
> +static void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
>   {
> -	wrmsrl(MSR_AMD64_TSC_RATIO, multiplier);
> +	__svm_write_tsc_multiplier(multiplier);
>   }
>   
> +
>   /* Evaluate instruction intercepts that depend on guest CPUID features. */
>   static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
>   					      struct vcpu_svm *svm)
> @@ -1410,13 +1423,8 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>   		sev_es_prepare_switch_to_guest(hostsa);
>   	}
>   
> -	if (tsc_scaling) {
> -		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
> -		if (tsc_ratio != __this_cpu_read(current_tsc_ratio)) {
> -			__this_cpu_write(current_tsc_ratio, tsc_ratio);
> -			wrmsrl(MSR_AMD64_TSC_RATIO, tsc_ratio);
> -		}
> -	}
> +	if (tsc_scaling)
> +		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);
>   
>   	if (likely(tsc_aux_uret_slot >= 0))
>   		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index cd92f43437539..2495fe548b5e9 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -594,7 +594,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   			       bool has_error_code, u32 error_code);
>   int nested_svm_exit_special(struct vcpu_svm *svm);
>   void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
> -void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
> +void __svm_write_tsc_multiplier(u64 multiplier);
>   void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
>   				       struct vmcb_control_area *control);
>   void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,

Queued, thanks.

Paolo

