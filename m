Return-Path: <kvm+bounces-21010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F21192805F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0834B254A4
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC786219ED;
	Fri,  5 Jul 2024 02:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQun+9x3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E7D45C07
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720146161; cv=none; b=KmBAoopNWbS7/o90MQjIQLOSNK0a0MChsxlBskh6CPm6NQ6odaC1Yk6eAVf3YFJAgl9t60XV3J45V/2RjE14K5sr0ce88ISY5Wtlsd6TFjvdLuEUUrmHafth/aCrnjVI71VY++KWUzH5/Jzbi9nM2MCOltpnamIJZJZlf5Q8p1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720146161; c=relaxed/simple;
	bh=iP4PTnc+JwqINZP62JEJfVsRzgiEnD/hVYcU9FxHyW0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R4FfU7Tseul6YOVC8LFnlF4ybS94oeL0Lw07XMZ9XQne2h4/zxszwhXG/ZqR+8ehk36qWxgPq5WtWpbBS2lDuHIbUHM+uy7/cvBiK/eW5c+ue9Z/O0od4EiPNu/EtUKMBN3h9NLbNBUV7gUVamNW75Y5baOSJhq2h2tDKTOgsmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQun+9x3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720146159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q7szSx4tLcUjlj9JqAzakCICbYrgWRQ4USIrs5Qy/W0=;
	b=CQun+9x3IUnnFIXRGD19v4ILV6s4snrPWzN7lO84aKgOspVRLEZQ3re724iJayfvJWgnU1
	wBo3EjsEhUNjZQx3BxJbn/0Cuddt9C2XpIs77p+1L5NFw7TNAd6VWGDMm+nLIro2jDa9WS
	IkjrmTBKZhHBanSQPiOobdu4ScLcSoU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-TJQxLxb8Nm-EG4e6_lY3Og-1; Thu, 04 Jul 2024 22:22:36 -0400
X-MC-Unique: TJQxLxb8Nm-EG4e6_lY3Og-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b057a9690bso15620236d6.2
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720146155; x=1720750955;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q7szSx4tLcUjlj9JqAzakCICbYrgWRQ4USIrs5Qy/W0=;
        b=X3Ohk5UjvLBUiS7Pme3OKzE/MZiQJQ/Pdb5Y0KcLrSfpkMZi/yURbmRjvma1ebJc2y
         OCDsMohElaSMuQkiCPAaexPvdl45C9/rgpn6bXVmEAyKzKSXPn79ryMope5/maWQd8Hx
         M5NjZpL6rH8EkvBZMAHyCZYErjYM0zXSXrN+MgUtHoHaL/bQylnGzwU/zLIMlibA3Iyb
         n0PA4dYUbNxwZqc9sEN8vXS8bI+T8iON4fi4+FP+dfofHxPAyo8YlsxKTIB8sNHD2vFW
         tib4vvZvYNijnCU/0Sv+PY5zuQOGwTf3qkebaMjB/R1Vk1MnXDttdmJeTnZK7ZxqkDxj
         V9iA==
X-Gm-Message-State: AOJu0YxAdZ4ijHZedseGZKUVOno3U9V2rZ4WFMjZ6dt3iY1lZnBR2xGA
	3qXbxD58hA+O9V8RXUrhphV/pcfXnQacT96HTfBAyKE5IeF6OWmSIaJJCjKSAxHeuEAsEMUH/Dn
	ChjyVVbVctzT5foRVLSpJTBlGWKr4qJFezjPupZBNr06+O8dnmQ==
X-Received: by 2002:ad4:5c41:0:b0:6b5:e006:11ae with SMTP id 6a1803df08f44-6b5ecfa7b1amr47128666d6.22.1720146154663;
        Thu, 04 Jul 2024 19:22:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4kbA/ede2RPQS5+pjM2192rg6QuAOX6Y2+jKIqVrkNbdROoUJYoeZzed5aZNbNVR6IXzYfg==
X-Received: by 2002:ad4:5c41:0:b0:6b5:e006:11ae with SMTP id 6a1803df08f44-6b5ecfa7b1amr47128396d6.22.1720146154383;
        Thu, 04 Jul 2024 19:22:34 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b59e564455sm68955926d6.42.2024.07.04.19.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:22:34 -0700 (PDT)
Message-ID: <d51310e1a43a1310f8b910f0a2fd7ef0ba886e4a.camel@redhat.com>
Subject: Re: [PATCH v2 43/49] KVM: x86: Update OS{XSAVE,PKE} bits in guest
 CPUID irrespective of host support
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:22:33 -0400
In-Reply-To: <20240517173926.965351-44-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-44-seanjc@google.com>
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
> When making runtime CPUID updates, change OSXSAVE and OSPKE even if their
> respective base features (XSAVE, PKU) are not supported by the host.  KVM
> already incorporates host support in the vCPU's effective reserved CR4 bits.
> I.e. OSXSAVE and OSPKE can be set if and only if the host supports them.
> 
> And conversely, since KVM's ABI is that KVM owns the dynamic OS feature
> flags, clearing them when they obviously aren't supported and thus can't
> be enabled is arguably a fix.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8256fc657c6b..552e65ba5efa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -336,10 +336,8 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best) {
> -		/* Update OSXSAVE bit */
> -		if (boot_cpu_has(X86_FEATURE_XSAVE))
> -			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> -					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
> +		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
> +				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
>  
>  		cpuid_entry_change(best, X86_FEATURE_APIC,
>  			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
> @@ -351,7 +349,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU))
> +	if (best)
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
>  

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


