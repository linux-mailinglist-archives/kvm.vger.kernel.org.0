Return-Path: <kvm+bounces-20991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5738927FC3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 170F71C217EF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7887A101CE;
	Fri,  5 Jul 2024 01:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i1H+8Obu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB1279F3
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142891; cv=none; b=G2+aeNbe6m/jOhKyI5AXVVM0p/lElMPCw5ynuta6AtDv8HsZJ2U2b2H1EOE28Y56YBmDkOEu6tmF59zLhduhCOBG5sLfYDewojoX8J5Iv97AC0ny2BlNjqKFejIrNiZapbrGiauU8h0CiKNw0kuRM6AARyOm2xAAcW/JQVvsFGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142891; c=relaxed/simple;
	bh=8d3X7jloJVsxIqnIQ2n7HT26l8XO4hDrFSZO3CzWwvs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TIOiiu/IrMW+EXZbvPWMDxkqaJKPgw8XQTIqm6yw4lpmtt2U9eGMzVdhHY+2ki5rzR7xyRm7T90VfZCX7IVfqOKOlTaJgS60rGL0Im3jJVKeqDs3rpw5kgT+tGbneGU48PgKtInMZVW31n1NroG1/sM05aCad3Sj3VckD4FXVjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i1H+8Obu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720142889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5Yvv1zL/+xull2WV0MPTGd2UvoP7ctDnqloseQIZEs=;
	b=i1H+8ObuMe+V5vrvgLlR9rF/Vy6mpHCT9z/5jYrALqN/EWHCVybrvg0kMcHR8tXciQFVIm
	k4lFsISPWqWY9gYCXwzM6HdQE9SEa9IkZy4sidq+bJD9KY9msfx1+PvF5qjot+xBFVnotl
	StkNY5nEqZ0y7fnt6sUAVBszVscZsD4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-LPuXs9AsPaa-8ip6HV3GVQ-1; Thu, 04 Jul 2024 21:28:08 -0400
X-MC-Unique: LPuXs9AsPaa-8ip6HV3GVQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79d7db4f63aso97242885a.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 18:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720142887; x=1720747687;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5Yvv1zL/+xull2WV0MPTGd2UvoP7ctDnqloseQIZEs=;
        b=VO1MxkjddVSBzQVUDWMRJkjwYce69FIDLrrhMzOFL66I2M15Sc1JtJThF+j6Vv+UI5
         nCKXG5Z4aUAaEdPGdd8Y5b4ZqRU0sfWIRQmMCbH336tGxaNGUXAFi9yTIKDIumgyNjr6
         NlWVGMiQja4R9QQFXXA78tNVS4v5DqWhBi9sCl19kjsHu6QpcnZDoxmQnHLxcR1orNrx
         7zO8fo/lryyitCKRJ++yClz0/oEqmmNAXlXw0w4jydSFE5O2F447pbsG4Vh0xpi+Xgcf
         Ae2mTXwlzinEq01K5n5dfAOtHQ0qqBh8HTrAVav5OdWDmhpIPXpl43mXL3qKUCrQJ7q8
         SpSw==
X-Gm-Message-State: AOJu0YxK1YIAp5JfPiFNp8NK75SwFOqlrD4Oti/oQcwcot99I8miKqn2
	KLzCU8c/bCHNAVk2WiaHHtWCbFmjRB+oKGHCcedN7wTNLUIj3K5AafM4kIHQTq/o6y1MQZjLEvd
	+zELIxEcMOZeSD4eFEoTuTYVFrabe7zCUnPyegrNmbP7yvmuFhA==
X-Received: by 2002:ae9:f209:0:b0:79d:599a:6a21 with SMTP id af79cd13be357-79eee1a58b1mr338814085a.16.1720142887524;
        Thu, 04 Jul 2024 18:28:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKj36amB3N2YUrbYuD9epXksGerEuKO794hrP1luv/pajo+qeLaEbwHBElZ3x3KgWWkYv40Q==
X-Received: by 2002:ae9:f209:0:b0:79d:599a:6a21 with SMTP id af79cd13be357-79eee1a58b1mr338812585a.16.1720142887194;
        Thu, 04 Jul 2024 18:28:07 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692f2705sm727483585a.91.2024.07.04.18.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 18:28:06 -0700 (PDT)
Message-ID: <7bf9838f2df676398f7b22f793b3478addde6ff0.camel@redhat.com>
Subject: Re: [PATCH v2 23/49] KVM: x86: Handle kernel- and KVM-defined CPUID
 words in a single helper
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 21:28:06 -0400
In-Reply-To: <20240517173926.965351-24-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-24-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Merge kvm_cpu_cap_init() and kvm_cpu_cap_init_kvm_defined() into a single
> helper.  The only advantage of separating the two was to make it somewhat
> obvious that KVM directly initializes the KVM-defined words, whereas using
> a common helper will allow for hardening both kernel- and KVM-defined
> CPUID words without needing copy+paste.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 44 +++++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f2bd2f5c4ea3..8efffd48cdf1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -622,37 +622,23 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
>  	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
>  }
>  
> -/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
> -static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
> +static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
>  {
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>  
> -	reverse_cpuid_check(leaf);
> +	/*
> +	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
> +	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
> +	 * and only authority.
> +	 */
> +	if (leaf < NCAPINTS)
> +		kvm_cpu_caps[leaf] &= mask;
> +	else
> +		kvm_cpu_caps[leaf] = mask;

Hi,

I have an idea,
how about we just initialize the kvm only leafs to 0xFFFFFFFF and then treat them exactly in the same way as kernel regular leafs?

Then the user won't have to figure out (assuming that the user doesn't read the comment, who does?) why we use mask as init value.

But if you prefer to leave it this way, I won't object either.

Best regards,
	Maxim Levitsky



>  
>  	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
>  }
>  
> -static __always_inline
> -void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
> -{
> -	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
> -	BUILD_BUG_ON(leaf < NCAPINTS);
> -
> -	kvm_cpu_caps[leaf] = mask;
> -
> -	__kvm_cpu_cap_mask(leaf);
> -}
> -
> -static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
> -{
> -	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
> -	BUILD_BUG_ON(leaf >= NCAPINTS);
> -
> -	kvm_cpu_caps[leaf] &= mask;
> -
> -	__kvm_cpu_cap_mask(leaf);
> -}
> -
>  void kvm_set_cpu_caps(void)
>  {
>  	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
> @@ -740,12 +726,12 @@ void kvm_set_cpu_caps(void)
>  		F(AMX_FP16) | F(AVX_IFMA) | F(LAM)
>  	);
>  
> -	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
> +	kvm_cpu_cap_init(CPUID_7_1_EDX,
>  		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI) |
>  		F(AMX_COMPLEX)
>  	);
>  
> -	kvm_cpu_cap_init_kvm_defined(CPUID_7_2_EDX,
> +	kvm_cpu_cap_init(CPUID_7_2_EDX,
>  		F(INTEL_PSFD) | F(IPRED_CTRL) | F(RRSBA_CTRL) | F(DDPD_U) |
>  		F(BHI_CTRL) | F(MCDT_NO)
>  	);
> @@ -755,7 +741,7 @@ void kvm_set_cpu_caps(void)
>  		X86_64_F(XFD)
>  	);
>  
> -	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
> +	kvm_cpu_cap_init(CPUID_12_EAX,
>  		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
>  	);
>  
> @@ -781,7 +767,7 @@ void kvm_set_cpu_caps(void)
>  	if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
>  		kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
>  
> -	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
> +	kvm_cpu_cap_init(CPUID_8000_0007_EDX,
>  		SF(CONSTANT_TSC)
>  	);
>  
> @@ -835,7 +821,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
>  
> -	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
> +	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
>  		F(PERFMON_V2)
>  	);
>  



