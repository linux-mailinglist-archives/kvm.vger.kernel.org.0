Return-Path: <kvm+bounces-2020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3187F0821
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 18:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CC471C209AC
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 17:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC4E1945A;
	Sun, 19 Nov 2023 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDjifv/R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB72139
	for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700415347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3okOyMxyER+1UcLcyJrkl/ivMZnxpI75V+9VEqz4llI=;
	b=FDjifv/RCC5q+NrNRL3qeQ//LxNoyd+ON6kThRaAfikqbS2OmuWXOmTQ+krzuTgaq/JVW8
	FOIcquIHM85v5uRDCG6b836d0bmzc0BBYGiveOl8sVGCJeLMKlxg2VwKq5BWBeY9PamY94
	aL3Reiure6SR/YDFn9fpEHm/ktwDmRk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-VNACcGjpN6K0rRenXUuewQ-1; Sun, 19 Nov 2023 12:35:44 -0500
X-MC-Unique: VNACcGjpN6K0rRenXUuewQ-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c52cbb64c9so32112091fa.1
        for <kvm@vger.kernel.org>; Sun, 19 Nov 2023 09:35:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415343; x=1701020143;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3okOyMxyER+1UcLcyJrkl/ivMZnxpI75V+9VEqz4llI=;
        b=MCf3Y5IsaSeRKDFO/yeTezZKITKy+wqqnEvg3/sSuMLOriHT3DWMmy3FIkeGww2Lyv
         fzs3zKYfRw0G2N/kEeupMjasmxde9NJEjLcY04X6HQL4UJqIvRszbJxSjsIRDn6oiSlG
         Y5xexsdxkTFqjvi/2Y29ZGoR4WwGrGrML9XJegVpEAuICdmGdzpnzIL6Yfy1lVj8Hz0w
         0hS5W08qUxG3whzD3vXQ8tbynJqYPiIpEHfdtI75snX2OLldVcCaX1FXg25HT0e/AJJ2
         Abwm1csw+d+0a/q4EeFxXjgp7jn1TtVzsrA6cJBK+DvXMpK8P9gy8E7YtA71zkj2FhUY
         TB6A==
X-Gm-Message-State: AOJu0Yxaoj/Q4y8nKW+B6P1Z3dMD3lZ7PAM6ADsl9ZRGgpxshzbVwqUy
	VLfzQGk5aqTNZYKydWuOnkaJX8P2e1Og7y2ytFPx71WjsDZ6g8cx2YE8bPnL+jFMmwRAtImm4Il
	WHgsrHwqcaaMB
X-Received: by 2002:a2e:9b18:0:b0:2c8:7192:800 with SMTP id u24-20020a2e9b18000000b002c871920800mr3134541lji.51.1700415343495;
        Sun, 19 Nov 2023 09:35:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1D/pZYBnGnvh++rCaYFlneml3ZmOhl6osF8W+ugDq2SFLA+hrWYaO4SLyH2RCXs8cFD5JUg==
X-Received: by 2002:a2e:9b18:0:b0:2c8:7192:800 with SMTP id u24-20020a2e9b18000000b002c871920800mr3134533lji.51.1700415343158;
        Sun, 19 Nov 2023 09:35:43 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id c20-20020a7bc854000000b0040a43d458c9sm14662541wml.25.2023.11.19.09.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:35:42 -0800 (PST)
Message-ID: <325fd3126a72c926b9d8d0ee060f90ce6d8a582e.camel@redhat.com>
Subject: Re: [PATCH 7/9] KVM: x86: Shuffle code to prepare for dropping
 guest_cpuid_has()
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 19 Nov 2023 19:35:40 +0200
In-Reply-To: <20231110235528.1561679-8-seanjc@google.com>
References: <20231110235528.1561679-1-seanjc@google.com>
	 <20231110235528.1561679-8-seanjc@google.com>
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
> Move the implementations of guest_has_{spec_ctrl,pred_cmd}_msr() down
> below guest_cpu_cap_has() so that their use of guest_cpuid_has() can be
> replaced with calls to guest_cpu_cap_has().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.h | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 1707ef10b269..bebf94a69630 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -163,21 +163,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
>  	return x86_stepping(best->eax);
>  }
>  
> -static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
> -{
> -	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
> -}
> -
> -static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
> -{
> -	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
> -		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
> -}
> -
>  static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
>  {
>  	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
> @@ -298,4 +283,19 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
>  	return vcpu->arch.cpu_caps[x86_leaf] & __feature_bit(x86_feature);
>  }
>  
> +static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
> +{
> +	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
> +}
> +
> +static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
> +{
> +	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
> +		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
> +}
> +
>  #endif
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


