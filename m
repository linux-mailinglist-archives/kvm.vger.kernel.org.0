Return-Path: <kvm+bounces-21011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10743928069
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3207E1C231FB
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334671D688;
	Fri,  5 Jul 2024 02:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBPzyc7m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6378D17995
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146372; cv=none; b=on0CLMB+OzRakEo+pyuRDltUzkBZ3BMujXRarXQONWRJpv2sATPV++euWSXUlhIIJ0ofiJa/GMLM8YCy7RWVwHA8ARxm+AhHGGfxEeTMxuPWWn23VgKMS+3n+8DJkIOkORu0sGgwzooEw5/tDzPJJZ99fXMUAcNxvWVX/9kZbc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146372; c=relaxed/simple;
	bh=rYJ++bZa0yA7ojMloercr3EzmWnX61lwyq1O/PwAfbg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TzxB+8ghaENsZXEBY4Mika0yKNsJNNNX63R3lSmh3tRPhQQoLWozs6TMuWdIcist5LfXrJII6gdoJjuX0LyjE289mUgdr7jjmT10AOZ3sOL+d2KtggitQBwxWLF7bXQ6wW5px/W0XUdK/tcpdxz7GzjVpgZhFLho/WsLb7ZwIGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBPzyc7m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2D8qhNLzDbP+EEHFtyIRTsK/xaD/vUNpkVgaMqqlnoY=;
	b=bBPzyc7mEgKyYGaq1hyzkQdkfRflL05Ne2I7d0mfcECJh7GmRf3nCvDtcxTrB4pinme1qa
	f7BKkWsf3/zzyZ160FFipXKcWwfRn+kPtYJu6k18D4mP8DYgtGargD097JJt+i30G4grXo
	s+bcgsI1oX5qmAlfVeQ3EOkMpcgYgl0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-ARBqJqA0Ol2Zf4ONds3Nbw-1; Thu, 04 Jul 2024 22:26:05 -0400
X-MC-Unique: ARBqJqA0Ol2Zf4ONds3Nbw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-44504a0d3c3so24083071cf.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:26:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146364; x=1720751164;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2D8qhNLzDbP+EEHFtyIRTsK/xaD/vUNpkVgaMqqlnoY=;
        b=WXEG+HUJnyEny7dWOqpz+gf4AJhNiiteIO6ZbQVIgbuLBOn2/4K20DNlhUw+Lq1ijP
         curj6TTEc07nhyYnuGP/1ET+Rz59JPICA+RYDMDaZv20iW3+dWdrNFLbJy1NSxlNFqFL
         W5e0bATG43KDf+9NaiJvNf08VdjzZJpsli3cahxUfokoJbILz+cYEBVN/1qLHGLSBept
         x26GZzKaqbSbuuQ7H1UdJn0heenlCNAkuOQjWMmF3hyD6RbiDXJ2jlNb7h0+4qrlpdKM
         Qld8SyJfZWsvPHTdnzXtqF0dzGZCIhbh4Ugo4BJiNT9XmaPAPT2ODaptTG/iO2nWHukZ
         Wkkw==
X-Gm-Message-State: AOJu0YzAmOplmM9EmkjGhy/HgrJCJK57A8HJuCf2ZGX6h6VbL8D93wYz
	+kzb7m5o0b9VxoKjwp64Qo4v2MWTe4Y1wCzG912m8B2mvYWYAzjgyp60QEOyUu7AAqzKYf5y58S
	v6Ynv6G3yA6lqHBTtrdtdCEA5VIy100JO7uVNmo809fx0kM0fkg==
X-Received: by 2002:a05:622a:1445:b0:444:f6d2:be89 with SMTP id d75a77b69052e-447cce878bcmr57375821cf.5.1720146364616;
        Thu, 04 Jul 2024 19:26:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAVNN2j3ROliZOTWzuYp/UeB1ud6wiWQz8FpAPeEJr12P4ax65uTSkWLAQX0+lJrZFMhA1Vw==
X-Received: by 2002:a05:622a:1445:b0:444:f6d2:be89 with SMTP id d75a77b69052e-447cce878bcmr57375651cf.5.1720146364274;
        Thu, 04 Jul 2024 19:26:04 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4465149d530sm65325471cf.77.2024.07.04.19.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:26:04 -0700 (PDT)
Message-ID: <2d554577722d30605ecd0f920f4777129fff3951.camel@redhat.com>
Subject: Re: [PATCH v2 44/49] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:26:03 -0400
In-Reply-To: <20240517173926.965351-45-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-45-seanjc@google.com>
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
> When updating guest CPUID entries to emulate runtime behavior, e.g. when
> the guest enables a CR4-based feature that is tied to a CPUID flag, also
> update the vCPU's cpu_caps accordingly.  This will allow replacing all
> usage of guest_cpuid_has() with guest_cpu_cap_has().
> 
> Note, this relies on kvm_set_cpuid() taking a snapshot of cpu_caps before
> invoking kvm_update_cpuid_runtime(), i.e. when KVM is updating CPUID
> entries that *may* become the vCPU's CPUID, so that unwinding to the old
> cpu_caps is possible if userspace tries to set bogus CPUID information.
> 
> Note #2, none of the features in question use guest_cpu_cap_has() at this
> time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.
> 
> Cc: Yang Weijiang <weijiang.yang@intel.com>
> Cc: Robert Hoo <robert.hoo.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 552e65ba5efa..1424a9d4eb17 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -330,28 +330,38 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> +static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
> +						       struct kvm_cpuid_entry2 *entry,
> +						       unsigned int x86_feature,
> +						       bool has_feature)
> +{
> +	cpuid_entry_change(entry, x86_feature, has_feature);
> +	guest_cpu_cap_change(vcpu, x86_feature, has_feature);
> +}
> +
>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *best;
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best) {
> -		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
> +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSXSAVE,
> +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
>  
> -		cpuid_entry_change(best, X86_FEATURE_APIC,
> -			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_APIC,
> +					   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
>  
>  		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> +			kvm_update_feature_runtime(vcpu, best, X86_FEATURE_MWAIT,
> +						   vcpu->arch.ia32_misc_enable_msr &
> +						   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  
>  	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
>  	if (best)
> -		cpuid_entry_change(best, X86_FEATURE_OSPKE,
> -				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> +		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
> +					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
> +
>  
>  	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
>  	if (best)


I am not 100% sure that we need to do this.

Runtime cpuid changes are a hack that Intel did back then,
due to various reasons, These changes don't really change the feature set
that CPU supports, but merly as you like to say 'massage' the output of
the CPUID instruction to make the unmodified OS happy usually.

Thus it feels to me that CPU caps should not include the dynamic features, and neither
KVM should use the value of these as a source for truth, but rather the underlying
source of the truth (e.g CR4).

But if you insist, I don't really have a very strong reason to object this.

Best regards,
	Maxim Levitsky




