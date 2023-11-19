Return-Path: <kvm+bounces-2019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 387A37F081F
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E399B2090D
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5102747A;
	Sun, 19 Nov 2023 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kvb/rKxd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F7DF2
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xliBDg8pP7F2Yj3xf/oIT4SDk7CsfUP0pIU9lszae9E=;
	b=Kvb/rKxdWeZHOi0RcTJ394E8Hbnph0VSl+XYO54WqIr7C3x7RrCkr7W2CIOw3vCWHV6WM1
	J2aPUxHcKz+QRvbzFLHE4UfLXj5wZIyhjoyLwRbIbQb8XhNpft5nsdAh6c6naWTWbUOY43
	TpSEawWNryKwEMucjYobyVtWtqMiaAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-Wo7LiqaROWO2Oo1SstEf9w-1; Sun, 19 Nov 2023 12:35:34 -0500
X-MC-Unique: Wo7LiqaROWO2Oo1SstEf9w-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-332c4179b73so278726f8f.3
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:35:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415332; x=1701020132;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xliBDg8pP7F2Yj3xf/oIT4SDk7CsfUP0pIU9lszae9E=;
        b=lu2xhf3CW7iVLhRposcm/dzcMPszEXhdgA/BmJXl6txkkE3ehjxwiNjy1BgRu8AeRM
         vSoys9x2JNsBBhkqpTb6zoNHQBHetOO5WMkbSrRZ0vXr8PblitliI4NvVyTrsFEA+Aft
         vP/U7xxmYaANF3H65Ss6ZgXSWntJ1dpfd2FmlTJXEulnGRlXmhcxiuP/vcRTUlNUXHGp
         EAprds/QID+4vJV9NTCKzAP7T1D0DytJrsXISiwriLkotYW55o4DyrvOrIZarAilVUUY
         0ZeNbbH35pOJ5jtupM316XZA9RDmvbhkBCLE/R/mXuPDvryEdqy277nCW1LIFqDv3Sav
         cacw==
X-Gm-Message-State: AOJu0YxDSYCdwtu3CfYZ75Ssj1RU6Gy6GsSDgcNNGFmyL95MwPzaqzxm
	bDoOyB00vnA7l4w+jmXPUmyHYARdyG3s3PwxqafJX1kwBO93OIcx4PHLJ2CDozWIMgnREK2+awa
	aQi3cN9hTrW/tWeTAM6Ra
X-Received: by 2002:a5d:4522:0:b0:32f:9a76:ea05 with SMTP id j2-20020a5d4522000000b0032f9a76ea05mr3191869wra.60.1700415332711;
        Sun, 19 Nov 2023 09:35:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3wQ6H0c7WartGxUG52lOv9rIoPhr1Jr9gv/ApKkb6QVMccTdXF4/SmX9o9Nygal15t5LUJg==
X-Received: by 2002:a5d:4522:0:b0:32f:9a76:ea05 with SMTP id j2-20020a5d4522000000b0032f9a76ea05mr3191859wra.60.1700415332352;
        Sun, 19 Nov 2023 09:35:32 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id m10-20020a5d4a0a000000b00331702ab6acsm5861099wrq.7.2023.11.19.09.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:35:32 -0800 (PST)
Message-ID: <4484647425e2dbf92c76a173b7b14e346f60362d.camel@redhat.com>
Subject: Re: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:35:30 +0200
In-Reply-To: <20231110235528.1561679-7-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-11-10 at 15:55 -0800, Sean Christopherson wrote:
> When updating guest CPUID entries to emulate runtime behavior, e.g. when
> the guest enables a CR4-based feature that is tied to a CPUID flag, also
> update the vCPU's cpu_caps accordingly.  This will allow replacing all
> usage of guest_cpuid_has() with guest_cpu_cap_has().
> 
> Take care not to update guest capabilities when KVM is updating CPUID
> entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
> bogus CPUID information.  No extra call to update cpu_caps is needed as
> the cpu_caps are initialized from the incoming guest CPUID, i.e. will
> automatically get the updated values.
> 
> Note, none of the features in question use guest_cpu_cap_has() at this
> time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 36bd04030989..37a991439fe6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> +						       struct kvm_cpuid_entry2 *entry,
> +						       unsigned int x86_feature,
> +						       bool has_feature)
> +{
> +	if (entry)
> +		cpuid_entry_change(entry, x86_feature, has_feature);
> +
> +	if (vcpu)
> +		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> +}
> +
>  static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>  				       int nent)
>  {
>  	struct kvm_cpuid_entry2 *best;
> +	struct kvm_vcpu *caps = vcpu;
> +
> +	/*
> +	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
> +	 * are coming in from userspace!
> +	 */
> +	if (entries != vcpu->arch.cpuid_entries)
> +		caps = NULL;

I think that this should be decided by the caller. Just a boolean will suffice.

Or even better: since the userspace CPUID update is really not important in terms of performance,
why to special case it? 

Even if these guest caps are later overwritten, I don't see why we
need to avoid updating them, and in fact introduce a small risk of them not being consistent
with the other cpu caps.

With this we can avoid having the 'cap' variable which is *very* confusing as well.


>  
>  	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
> -	if (best) {
> -		/* Update OSXSAVE bit */
> -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> +
> +	if (boot_cpu_has(X86_FEATURE_XSAVE))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
>  					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
>  
> -		cpuid_entry_change(best, X86_FEATURE_APIC,
> -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
> +				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>  
> -		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> -	}
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
> +					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);
>  
>  	best = cpuid_entry2_find(entries, nent, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU))
> -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> +	if (boot_cpu_has(X86_FEATURE_PKU))
> +		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSPKE,
> +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  
>  	best = cpuid_entry2_find(entries, nent, 0xD, 0);
>  	if (best)
> @@ -353,6 +370,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
>  	 * honor userspace's definition for features that don't require KVM or
>  	 * hardware management/support (or that KVM simply doesn't care about).
> +	 *
> +	 * Note, KVM has already done runtime updates on guest CPUID, i.e. this
> +	 * will also correctly set runtime features in guest CPU capabilities.
>  	 */
>  	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
>  		const struct cpuid_reg cpuid = reverse_cpuid[i];


Best regards,
	Maxim Levitsky


