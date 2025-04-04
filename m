Return-Path: <kvm+bounces-42633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5993A7BAB2
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AAD97A58D6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D5B1C1F21;
	Fri,  4 Apr 2025 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0PEzEih"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82A19E83E
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762395; cv=none; b=Oop1Qc3A1B6Zs3Ny/lCQKIjwlAqUzw9Bt2V3BTQiTU0LE51zDcVF+zxaaPhfFf6JalMOzBKXzn/45bUh1htvmUudaUN4U2Sqi+SozbvjiYtZA8yxMtiH6q4QrPgqF+cI/hDdff2leI7coT3HLFaMnDK3msMCVz86iuxm0jLs6Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762395; c=relaxed/simple;
	bh=K3moIbYzRyWUBKVQrSluOrZf2CdVkSwIGy75O9MCyPQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=EyccAQ0sl8vgDQySQTUABCOBoRVk5B0jmFiEUJmooFkvGs7scp8ziURm4OZ7i6Rf0kK9wUfqQ0p+EbowCVml7kbPUtKh2vu8eBnoPvvwiydU7Cfq+LOauy+SFdoFISs1ZFrh+WVKB/yVLBPp3KrRopDc0V8w2UHKufuZqI8a+dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0PEzEih; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/KCKssr3u1FeopzBRd64eEu1FG8HJvMquEXEGm6in2k=;
	b=L0PEzEihOpeC3pXtxSftfBmGDNHZ3sycynrNCBVZrHxJKlItL1Dwny3mNL9gtFYTA4sTNa
	4zEP4gH0bD4dONPBVXNRnPLK7I9AIAxweDvEMChl1JybD+B8pBiw2QouqnHFgcNCdg8gLU
	8rvWZDxIIbcSqC8c8/d90Dflw9+EGQg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-yWh9pWl6PaWGynKX4fQqgg-1; Fri, 04 Apr 2025 06:26:31 -0400
X-MC-Unique: yWh9pWl6PaWGynKX4fQqgg-1
X-Mimecast-MFC-AGG-ID: yWh9pWl6PaWGynKX4fQqgg_1743762390
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e5dd82d541so1889414a12.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762389; x=1744367189;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/KCKssr3u1FeopzBRd64eEu1FG8HJvMquEXEGm6in2k=;
        b=G2Qka0QvGvRxws5a+bhTtEgc4HSpdTkvVZkddWFpSIGzg/3dXQAIGh9p0F2+mLX0FT
         WyKonQWnCXsoHA89O2TrSKFLcEom1eBkPoP6Zl72gm14Fy+cqimPUxRLpmHwb+jNKvsa
         Xyd3SEFZxt6pFdbVSODEd6k0JxMV24EsSuTUnHMTyRMgU8E0c1Dd1VOqVHmj06/RRawz
         2TBy+UtZA9m2y//tpHZj/qmdmjPQdngX53Lv/wKE9cF7RZMwxLYx+/ODxl3nKAfjbQD3
         URRzTLcxq9bjdcd+RAxiAqamiUHgh/lIZeulmoSpFwsv+cSsuVdlLzkOFX4oZ9harJ3j
         wXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxGh8RjxcATtVujrFRXvCpAKFAVeBA5b74WyQczw7Yefsg5ARwn/eTHvPq1HZEFbf4KLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgSk1MisTCnQkcHY7Jc/bkV9kL/lvep2/8vC/hCqfqYYTn0gfX
	0jOtoWHIz9rbzj2IgOlBl+l244JT/jjQ8AC2BuZ1BRrqi53K2L/yNKxOlWGHYPF7x55IOG2DkW/
	6AAbR5q5hn1QFPVBIz45ntUBmQx53DIu3h65IBMLChh8NEMTvJpKSTGVEsw==
X-Gm-Gg: ASbGncvRaKBTUsZFYWAz2OKiJtYXDMQMz8M2KP/XDPXFABFXpvSAx/Px2P/3Fw/oDBy
	pvLqUSsvFIsS7gbHHEPw0AjYvEX9x0VTcEGvQJ0lsonymw0uVirVtWTEPLoox58PA704RNYrW79
	GG0yLh8fhAALuxXlBJsWwN9g7rffELRE2dEMkVKOv5cd88kg8IOqmUp2Jpt8FcD75tZ7S5syt+T
	Y1o5tPy9w4HjI5oaoKO6SVWgomycL2EpQowLAyrDl6b1XYQGtpn1HajepGkI6GBMUQjOoKNpy9S
	/LEh9+Nl8h+ntDveDSpH
X-Received: by 2002:a05:6402:40c9:b0:5e5:b572:a6d6 with SMTP id 4fb4d7f45d1cf-5f0b3b98ac6mr1932315a12.10.1743762389296;
        Fri, 04 Apr 2025 03:26:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbTioneqwfgXvKpVW4nIF7pThp5etRr7yKZrRWR1NeweXktV4NzzW+LzhHI42jEKYiw0IC2g==
X-Received: by 2002:a05:6402:40c9:b0:5e5:b572:a6d6 with SMTP id 4fb4d7f45d1cf-5f0b3b98ac6mr1932297a12.10.1743762388946;
        Fri, 04 Apr 2025 03:26:28 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.230.224])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5f087715308sm2082176a12.8.2025.04.04.03.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 03:26:28 -0700 (PDT)
Message-ID: <73318898-9f03-4694-831e-b7dbc8812a50@redhat.com>
Date: Fri, 4 Apr 2025 12:26:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Forbid the use of kvm_load_host_xsave_state()
 with guest_state_protected
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250307184125.2947143-1-pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250307184125.2947143-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/25 19:41, Paolo Bonzini wrote:
> kvm_load_host_xsave_state() uses guest save state that is not accessible
> when guest_state_protected is true.  Forbid access to it.
> 
> For consistency, do the same for kvm_load_guest_xsave_state().
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied now.

Paolo
> ---
>   arch/x86/kvm/svm/svm.c | 7 +++++--
>   arch/x86/kvm/x86.c     | 5 ++---
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 2c291f0e89c7..51cfef44b58d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4251,7 +4251,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>   		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
>   
>   	clgi();
> -	kvm_load_guest_xsave_state(vcpu);
> +
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_guest_xsave_state(vcpu);
>   
>   	kvm_wait_lapic_expire(vcpu);
>   
> @@ -4280,7 +4282,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>   	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>   		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>   
> -	kvm_load_host_xsave_state(vcpu);
> +	if (!vcpu->arch.guest_state_protected)
> +		kvm_load_host_xsave_state(vcpu);
>   	stgi();
>   
>   	/* Any pending NMI will happen here */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b416eec5c167..03db366e794a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1182,11 +1182,10 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>   
>   void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->arch.guest_state_protected)
> +	if (WARN_ON_ONCE(vcpu->arch.guest_state_protected))
>   		return;
>   
>   	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> -
>   		if (vcpu->arch.xcr0 != kvm_host.xcr0)
>   			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>   
> @@ -1205,7 +1204,7 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>   
>   void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu->arch.guest_state_protected)
> +	if (WARN_ON_ONCE(vcpu->arch.guest_state_protected))
>   		return;
>   
>   	if (cpu_feature_enabled(X86_FEATURE_PKU) &&


