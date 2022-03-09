Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4934D2FBE
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiCINN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiCINN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:13:56 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C387710A7C8;
        Wed,  9 Mar 2022 05:12:56 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r10so2989113wrp.3;
        Wed, 09 Mar 2022 05:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pfyYykHjxrLm7TI65zNbRgH0big2KedF7YuccyrnveI=;
        b=DI27C8UYjpWIrC9nmE+cQjsLu24yCR2g67UiBwdv36USOSBBM70AbZkdG9amasF+nZ
         tVF5EDraK0ml5Quh+8KVlNT7k3kZOkqv9TiieJy0k+LeGv2aL4bLGlQmRxNAZIXUNoXM
         B6R6nmXg1TKls4EHtGksX4xTKDhCBhSlRHhdZeOJbPbZEHy0A81mNP3sx6XtpALPFQmy
         RNK3HX42c+iu9DXxg4Vi957Al+mva4ewWRTXnMYyUBzvpYjHWafjWsn8iBJXSWvUz1je
         /6leVgwm2MMVvKhpaNgo/wBSqy9hDfbhyisRwJDjvy1z9vmrazq9wT01A+406PHM5evA
         aLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pfyYykHjxrLm7TI65zNbRgH0big2KedF7YuccyrnveI=;
        b=N7IHeWMvMCNWJE9HoH5z8tetg7LVIZDlCQhqCqsPTLsB3qqUGHAo4G1Uk41232N/7t
         qPfRCi2Mul/SNei1/GjCTVh2XEZjynd/KFdiTkylagw+XZ7GxPamMX7NI10Pp9U54+iD
         sM18Q0nxTkx1BdB29SGmo46X+coa+mmskTP34BH/9/u6I1idQkmjOF58XJpPpnk+aFDq
         hcZA+0xx4mgcSxB+tV+VMaT/gi9xaWnAQjT/iT91KLPruK7wG4Doh5u04Id5NFNDTHGv
         X5EH7ccxI0Tj39kCmZZ8NCDU7Olbf5h4H81B9QsbZJ7rDvYGgZD6JxMdfshz8KC1wTlA
         m0Sg==
X-Gm-Message-State: AOAM5307sSP41rY5wtEtbzuHkH5Gk9nL8gZ7mSm3a2zYuSpucSjkUq8O
        uv+x6OGr3ZXWWxPTzgn/yvA=
X-Google-Smtp-Source: ABdhPJzTky0CXdrII5RNjyQSvU6YcmYbOn1mgrM9buvP6zTC9hvCzfaSy39VP/cXdne/ieUpx37pMA==
X-Received: by 2002:a5d:404b:0:b0:1f1:f880:7aca with SMTP id w11-20020a5d404b000000b001f1f8807acamr11488947wrp.179.1646831575243;
        Wed, 09 Mar 2022 05:12:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b15-20020adfc74f000000b001e888b871a0sm1697959wrh.87.2022.03.09.05.12.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:12:54 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a235df4f-ba06-1b01-c588-06f12d8341b7@redhat.com>
Date:   Wed, 9 Mar 2022 14:12:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 4/7] KVM: x86: nSVM: support PAUSE filter threshold and
 count when cpu_pm=on
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-5-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 15:36, Maxim Levitsky wrote:
> Allow L1 to use these settings if L0 disables PAUSE interception
> (AKA cpu_pm=on)
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/nested.c |  6 ++++++
>   arch/x86/kvm/svm/svm.c    | 17 +++++++++++++++++
>   arch/x86/kvm/svm/svm.h    |  2 ++
>   3 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 37510cb206190..4cb0bc49986d5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -664,6 +664,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	if (!nested_vmcb_needs_vls_intercept(svm))
>   		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>   
> +	if (svm->pause_filter_enabled)
> +		svm->vmcb->control.pause_filter_count = svm->nested.ctl.pause_filter_count;
> +
> +	if (svm->pause_threshold_enabled)
> +		svm->vmcb->control.pause_filter_thresh = svm->nested.ctl.pause_filter_thresh;

I think this should be

	if (kvm_pause_in_guest(vcpu->kvm)) {
		/* copy from VMCB12 if guest has CPUID, else set to 0 */
	} else {
		/* copy from VMCB01, unconditionally */
	}

and likewise it should be copied back to VMCB01 unconditionally on 
vmexit if !kvm_pause_in_guest(vcpu->kvm).

>   	nested_svm_transition_tlb_flush(vcpu);
>   
>   	/* Enter Guest-Mode */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6a571eed32ef4..52198e63c5fc4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4008,6 +4008,17 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   
>   	svm->v_vmload_vmsave_enabled = vls && guest_cpuid_has(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>   
> +	if (kvm_pause_in_guest(vcpu->kvm)) {
> +		svm->pause_filter_enabled = pause_filter_count > 0 &&
> +					    guest_cpuid_has(vcpu, X86_FEATURE_PAUSEFILTER);
> +
> +		svm->pause_threshold_enabled = pause_filter_thresh > 0 &&
> +					    guest_cpuid_has(vcpu, X86_FEATURE_PFTHRESHOLD);

Why only if the module parameters are >0?  The module parameter is 
unused if pause-in-guest is active.

> +	} else {
> +		svm->pause_filter_enabled = false;
> +		svm->pause_threshold_enabled = false;
> +	}
> +
>   	svm_recalc_instruction_intercepts(vcpu, svm);
>   
>   	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
> @@ -4763,6 +4774,12 @@ static __init void svm_set_cpu_caps(void)
>   		if (vls)
>   			kvm_cpu_cap_set(X86_FEATURE_V_VMSAVE_VMLOAD);
>   
> +		if (pause_filter_count)
> +			kvm_cpu_cap_set(X86_FEATURE_PAUSEFILTER);
> +
> +		if (pause_filter_thresh)
> +			kvm_cpu_cap_set(X86_FEATURE_PFTHRESHOLD);

Likewise, this should be set using just boot_cpu_has, not the module 
parameters.

Paolo

>   		/* Nested VM can receive #VMEXIT instead of triggering #GP */
>   		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>   	}
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index a3c93f9c02847..6fa81eb3ffb78 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -234,6 +234,8 @@ struct vcpu_svm {
>   	bool tsc_scaling_enabled          : 1;
>   	bool lbrv_enabled                 : 1;
>   	bool v_vmload_vmsave_enabled      : 1;
> +	bool pause_filter_enabled         : 1;
> +	bool pause_threshold_enabled      : 1;
>   
>   	u32 ldr_reg;
>   	u32 dfr_reg;

