Return-Path: <kvm+bounces-21008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF32992805A
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 419FF2818E7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6D0175AA;
	Fri,  5 Jul 2024 02:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JeTUmJhV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0648120B3E
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146143; cv=none; b=o/YzhozxpOTPNRoie8KNQCTWUkvWDkQExj/iCWbDGazGaKMSOVPbahpDPHBu4UTna7qlrkBkAfOUBLJkhalxc82cDG/Sb0nAzp6UYWKIgj4JmKiOv5EwbYXVMbAw8sbtHrgBkHprV61bEUH7sylaVGkEFrqSEnSxjybGa4YNnEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146143; c=relaxed/simple;
	bh=8Vz+Assp9w3AUUjoHHaXG5VrBL9gUGzXKaRrcaJt9OQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CnTabTF525cVtq77BWP+H0mS9414OSTL5BbgEbPBKC/uyELQk5RSDUjZlkhxPxdEzKx7EVmeugLsQhMyE8i+fUA3JqElrbJ47/DK59VmJlgtk5KZLrv+M52r4wUClFsdYi9LmzstS6jmYWbR9Yge1KZLO2SOygGCJK/6OyT9jmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JeTUmJhV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOGlJ22KOnjJQkplUEx2665OYsRQf3zb4enF9GB5qFA=;
	b=JeTUmJhVTDbJWFApT5tcPqWcgPSojZQvDYdOWCkX/dAYZbE4pQfCqDqGmV9jZWtQU6M/04
	vLDb8eNpK4E874z1/Hc15z1DTb00SH7QlMq3v0pEIcyceO9dvJQp9jBiELwD/iOjY5tAqZ
	Sgb/MXJXAXZdbuZQ/5yHl5TG0Aexsp4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-Ikb8RLmNNT6YE5TQTi1hUw-1; Thu, 04 Jul 2024 22:22:19 -0400
X-MC-Unique: Ikb8RLmNNT6YE5TQTi1hUw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b5e0f00d63so14881406d6.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:22:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146139; x=1720750939;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tOGlJ22KOnjJQkplUEx2665OYsRQf3zb4enF9GB5qFA=;
        b=VTWqvgX7iLlAg0k136uP1JlxhfOSZyCrIiElK1lsGYhMO+68fUvvwl1Pzo08dHO6oR
         M7mtoxYa9PylOxNf84+tjysgozgXuEV4SMg13KBYKDNf3NcDGpBBqDGYRVka6lQFIMKF
         sESepi70W2sDFJvldaxG0AIew3FQ6nY5iJsqY8WbCSInrSSh1nlZnMDtJjUFkruyskti
         L1XmAEt+zQR+9wqkKyGS8CHvgL3aYoD9ejOY0TnSln6f+R5JCf4Ng44REVmR1TCAbc0D
         YqS4FmPMydszXqIXYGVE7GL/ezW4+LgCV5x2u17aGeibm0eGiDGzxgizgGS1mgX6/rNb
         Suuw==
X-Gm-Message-State: AOJu0Yz0qh3i5zPy+rf5avl9jpZzwdRvxd9kLVpHESEe3uSJaWpNN9Iq
	dUI28xRRVYWjcanR0WhFv0k3uXwpnz8gkuuuEQf/CCqvWkhIQdxl+7vuBe1cPIfxnFkYAtUU4yp
	eVwcQWSqVDmrOnVkIDv8Noc7rj0drPbLir9dqHqsaJExRaP3AmA==
X-Received: by 2002:a05:6214:2247:b0:6b0:820f:b833 with SMTP id 6a1803df08f44-6b5ed03479fmr50302336d6.46.1720146139239;
        Thu, 04 Jul 2024 19:22:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIXLooJKok0ZLoGzEO5CWhQzjtKD412s48JN9yDy9jnZEJ8/XP8rVUlQy5nHVM6ecImPZiHQ==
X-Received: by 2002:a05:6214:2247:b0:6b0:820f:b833 with SMTP id 6a1803df08f44-6b5ed03479fmr50302086d6.46.1720146138923;
        Thu, 04 Jul 2024 19:22:18 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e6228b7sm69174026d6.126.2024.07.04.19.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:22:18 -0700 (PDT)
Message-ID: <a52a25faeb180f29a43aa69ad96e46a891d8f288.camel@redhat.com>
Subject: Re: [PATCH v2 41/49] KVM: x86: Avoid double CPUID lookup when
 updating MWAIT at runtime
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:22:17 -0400
In-Reply-To: <20240517173926.965351-42-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-42-seanjc@google.com>
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
> Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
> utilize the lookup done for other CPUID.0x1 features.
> 
> No functional change intended.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8ada1cac8fcb..258c5fce87fc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -343,6 +343,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  
>  		cpuid_entry_change(best, X86_FEATURE_APIC,
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> +
> +		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
> +			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> +					   vcpu->arch.ia32_misc_enable_msr &
> +					   MSR_IA32_MISC_ENABLE_MWAIT);
>  	}
>  
>  	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
> @@ -358,14 +363,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> -
> -	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
> -		best = kvm_find_cpuid_entry(vcpu, 0x1);
> -		if (best)
> -			cpuid_entry_change(best, X86_FEATURE_MWAIT,
> -					   vcpu->arch.ia32_misc_enable_msr &
> -					   MSR_IA32_MISC_ENABLE_MWAIT);
> -	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


