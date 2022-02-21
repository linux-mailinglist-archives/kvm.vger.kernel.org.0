Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFDE4BDF1A
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358014AbiBUMdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 07:33:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358005AbiBUMdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 07:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C8EE15A0C
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 04:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645446800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shdZPAdKixSR65xoDRGdlm8dprYC8n8jO7XaRNiILE0=;
        b=TcDyZY6+ItH6vHgLGrG0EgcNS9XC/sZDoPMDu2TM4JDxjGGAvE0Jnpm267e9oJGGUsqiIB
        rIIajdtRSyrJ2xvER8GP1I+WNO73lohBIbMHsTkDhFB4n+lWeGZ1fCdTsvTSQY9zItszNh
        ClbaeECEhdnEpH5FwuS2uxZSyS0t+hw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-v50ghHtfO9WfchWYsTTcHw-1; Mon, 21 Feb 2022 07:33:17 -0500
X-MC-Unique: v50ghHtfO9WfchWYsTTcHw-1
Received: by mail-ed1-f70.google.com with SMTP id bq19-20020a056402215300b0040f276105a4so10084552edb.2
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 04:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=shdZPAdKixSR65xoDRGdlm8dprYC8n8jO7XaRNiILE0=;
        b=xUUF41TzYnrTfBNl6KT4UXNMwJIDht+Iy8Dweim23YS2CFUo9M6vMytvKeBzJcmfxv
         4FE3jqxB5YtxB/6bsaCngqUgZAOWdafIR5/A6apnt4WNv8fVilinchvfy9Dj67/sfqBf
         t27wqRMKUsfkTjyScX6qQmtJ44RakX0tmB7aerH382aWSYe81XFd6YyuUQIm8/HMljtV
         Xf1KEEKi4QW1T9/CgkN3X8s+/zta2RK9cobiTqLYx6gVtCDtWq9megWgLd4e26SQpHJ9
         BOl0AY298LjT+YsRJuN7edGp7bnzdmvkYNqd91/peyS025UfOBsi4pO3wK07LitQ2sz1
         dZsQ==
X-Gm-Message-State: AOAM532LsNissstWg2dRrHZpORqptaYp3+fYUZVEJQso3JPloDOljmp5
        7LboekHN/Xr6tFDnOVdRta0HvPu1BUlocSXyqrfKAbzKbSnAQP2loUoE5SW0wb2EMiyY3Oc0SD8
        KzS7iVotJXQ8Y
X-Received: by 2002:a17:907:7618:b0:6cf:5756:26c4 with SMTP id jx24-20020a170907761800b006cf575626c4mr15431641ejc.492.1645446795891;
        Mon, 21 Feb 2022 04:33:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAwRMB80aGegelnclPGNxrWxMk5t1WkcOGbK1qKbIEQgnnRqPmh3qRCNgNi4hGfXky91N3DA==
X-Received: by 2002:a17:907:7618:b0:6cf:5756:26c4 with SMTP id jx24-20020a170907761800b006cf575626c4mr15431626ejc.492.1645446795640;
        Mon, 21 Feb 2022 04:33:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ci16sm5113729ejb.128.2022.02.21.04.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 04:33:15 -0800 (PST)
Message-ID: <44604447-9686-24b3-4216-71d52eb1a6c2@redhat.com>
Date:   Mon, 21 Feb 2022 13:33:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: nSVM: fix nested tsc scaling when not enabled but
 MSR_AMD64_TSC_RATIO set
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
References: <0a0b61c5c071415f213a4704ebd73e65761ec1a3.camel@redhat.com>
 <20220221103331.58956-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220221103331.58956-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/22 11:33, Maxim Levitsky wrote:
> For compatibility with userspace the MSR_AMD64_TSC_RATIO can be set
> even when the feature is not exposed to the guest, which breaks assumptions
> that it has the default value in this case.
> 
> Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
> Cc: stable@vger.kernel.org
> 
> Reported-by: Dāvis Mosāns <davispuh@gmail.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

It's not clear how QEMU ends up writing MSR_AMD64_TSC_RATIO_DEFAULT 
rather than 0, but we clearly have a bug in KVM.  It should not allow 
writing 0 in the first place if tsc-ratio is not available in the VM.

If QEMU really can get itself in this situation, we cannot fix this 
except with KVM_CAP_DISABLE_QUIRKS (a quirk that would accept and ignore 
host-initiated writes if the CPUID bit is not available) or perhaps with 
a pr_warn_ratelimited and a quick deprecation cycle, until some time 
after 6.2.1 is released.

Hmmm... maybe the issue is actually that KVM *returns* 0 from 
KVM_GET_MSRS?  And in this case, fixing KVM would also prevent QEMU from 
sending the bogus KVM_SET_MSRS?

Thanks,

Paolo

> ---
>   arch/x86/kvm/svm/nested.c | 10 ++++------
>   arch/x86/kvm/svm/svm.c    |  5 +++--
>   arch/x86/kvm/svm/svm.h    |  1 +
>   3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 1218b5a342fc..a2e2436057dc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -574,14 +574,12 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
>   			vcpu->arch.l1_tsc_offset,
>   			svm->nested.ctl.tsc_offset,
> -			svm->tsc_ratio_msr);
> +			svm_get_l2_tsc_multiplier(vcpu));
>   
>   	svm->vmcb->control.tsc_offset = vcpu->arch.tsc_offset;
>   
> -	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
> -		WARN_ON(!svm->tsc_scaling_enabled);
> +	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio)
>   		nested_svm_update_tsc_ratio_msr(vcpu);
> -	}
>   
>   	svm->vmcb->control.int_ctl             =
>   		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
> @@ -867,8 +865,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>   		vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
>   	}
>   
> -	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
> -		WARN_ON(!svm->tsc_scaling_enabled);
> +	if (svm_get_l2_tsc_multiplier(vcpu) != kvm_default_tsc_scaling_ratio) {
>   		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
>   		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
>   	}
> @@ -1264,6 +1261,7 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> +	WARN_ON_ONCE(!svm->tsc_scaling_enabled);
>   	vcpu->arch.tsc_scaling_ratio =
>   		kvm_calc_nested_tsc_multiplier(vcpu->arch.l1_tsc_scaling_ratio,
>   					       svm->tsc_ratio_msr);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 975be872cd1a..5cf6bb5bfd3e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -911,11 +911,12 @@ static u64 svm_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
>   	return svm->nested.ctl.tsc_offset;
>   }
>   
> -static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
> +u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> -	return svm->tsc_ratio_msr;
> +	return svm->tsc_scaling_enabled ? svm->tsc_ratio_msr :
> +	       kvm_default_tsc_scaling_ratio;
>   }
>   
>   static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 852b12aee03d..006571dd30df 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -542,6 +542,7 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>   			       bool has_error_code, u32 error_code);
>   int nested_svm_exit_special(struct vcpu_svm *svm);
>   void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
> +u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>   void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
>   void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
>   				       struct vmcb_control_area *control);

