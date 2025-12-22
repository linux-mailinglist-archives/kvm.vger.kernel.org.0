Return-Path: <kvm+bounces-66478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 436B4CD65BF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 15:24:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 719C3304D9EB
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 14:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB082F28E3;
	Mon, 22 Dec 2025 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbMTN0ue";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="p41nYGkY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE642F39B9
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766413425; cv=none; b=m1sjTYH7GDy0mDeReqX5Yg4Y1YR7b4PEjxCMW4Fqwmx+gucmOED1rR4hYx/amsFmJ1R05TmVkNv9m/sEh27M1NX0OUiDxYHSd83N+JeFkUAYWuXjcOT2n6RulJS5A3dZI/CtYOHbYiEkpY9ydR/YBJLeZD9J5hJsVCC69CO3Bjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766413425; c=relaxed/simple;
	bh=4ZKM2fdHl/XRUuoxVNN0r4f3OFOyr2WZq4J+hL3UKtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DiwbMMRpFpEgW5kxBWD5O/8cXiEMPwoqkrgvQGJx6FlGf5vR46oe2EtZqbu4uq8nbmOgfDjxmu932arF5WqWqK2FB3rM4ttYcJ0SoYOwGufik9WAqN1T3YXU363nhzurSTlDyWdCl/THaoBp9cx5LvZCdUZqmj9OLRjfkr6ruv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UbMTN0ue; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=p41nYGkY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766413423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OhXGmJaPc5Ot2K4U5ZtUk2BMgjH6MHZD5EOU8o2kc44=;
	b=UbMTN0ueqKlRKdyHz+z9ER3bx+/CdoX6mHiqBbC0Geie4rSp42RD+y0kNNuZpAtwN1/CGf
	UsfrkGZR7AREnz3CfPhaUtBMsc6PehPRClOiSdHU/hX8PzcJy8vyBR4x8w+4//b6DNec4H
	u3l6nT1/CiHl15jCatxSJAqO0BkpyBk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-8IZRPTkXMbSEzfxvwkKZZQ-1; Mon, 22 Dec 2025 09:23:41 -0500
X-MC-Unique: 8IZRPTkXMbSEzfxvwkKZZQ-1
X-Mimecast-MFC-AGG-ID: 8IZRPTkXMbSEzfxvwkKZZQ_1766413420
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fc153d50so3274534f8f.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 06:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766413420; x=1767018220; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OhXGmJaPc5Ot2K4U5ZtUk2BMgjH6MHZD5EOU8o2kc44=;
        b=p41nYGkY9f/dhMWQ85HKbyHY4aF7YiKSPGnqEQ2w1jVilbzESaucGVltupMhWD/gL+
         0PWa7X7xoHTUDVIfPJvQ4hpnAjhocwPGLiohWANbMXGtUEspxIckvtFwMjEVxy/+Iaro
         FUBK3WfLK7f7SR0EsWLk4dj8Z5O48TG4k+jJRUSG5PofNbYtTbwQi26OfJ2UviGU5EyN
         WaLTHhTdBdz6tOUCWQEwQTNVh8h+8f6t9Hf7ArVL2PDYKyAYgp9mzT1oJREaVQe3Ap6r
         578W5Hk2teGGqfgt9J9h55Nnfx/96jCm099h6jSQFST/LjbiNhVvHj6U7qdwHqIwC/9T
         VXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766413420; x=1767018220;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhXGmJaPc5Ot2K4U5ZtUk2BMgjH6MHZD5EOU8o2kc44=;
        b=YAlLuqvtdCTB1WkACObQleb0YGZ/DGUt+jl1Aslk/HsLAppSKBPffaFNMQClCBhiBP
         S7ORQpMCjG58YrNC/Mi7vMyfatCBB8nrxS5rAXFA0C8z5QNQbSGE4w4d/vBApJmV1WDQ
         lZ+WNtGzwF5s+uK6AG3yclhS/uxiwDLEyB3xR2OiBa5ll1K+2nrUSDe6/Rejt1cWx1Og
         5h0l/CEozhBLrXmqZtp5HyNNLtvvUY5YYCO/wGWVuoFhkHcZn4De49Ydz2pM5serHwhQ
         cEsERAbB9Iw2tRp0SS+tsTiVAsW+XOSsEN9eOxhbmCEcm+XqOzjzHuPwBrgJPxKBKrjA
         G+ww==
X-Gm-Message-State: AOJu0Yx/Z6RBZRvjyjhoToPmQpyyQ+lBif3hwTVXo/76/d2zO5VkYYyd
	k8bTLuI5IMwq8fd/WwOQDf6tmV8PXW15lnHXkcXQDXjAkYkl4IdTGGADqcsmIV/6iy48wny+UXM
	nxwln08PHxrQl5yGUJSVdtwNVndCHfa24ZzDCu9p0hzwrTW6gAl+DJQ==
X-Gm-Gg: AY/fxX6JVlaxki31xuVHrPTf+0hd5Z/TstjA2nAcdLQ/kO7sGMi2N19NREY0BJbphSi
	VZMJX/02TLG7KAbXGB2nkrKisNS6/xmCU7uXqdszJxuciy+vkdPn952sltl6WDz2cE8DS/t003S
	RqkGxzbqFHK8SRojjaYccBeIVA1VSn2hTNlhyrBYABse2F/MFWBF/fmP0a8TT9o6mI5AvHFwGxU
	q5pOCcm8rQEbZ7zOf/w0owb2JfXlXDQsaeIvqrnOM3g1+tNxwe9cRMa84V3AF/sio9y9/1EEB1w
	V3MoZYYFgyBSH4PSPAQgVa95NsB/hfR7+Ei/7W2YDC7S2qgVw6pt8KtvKcOOWGt+fDfn7YgBcM1
	mN+oMWJm1Q9oumDDsGb0Xfe8J7vvivxs46xRvteurnkfJkZVlrFabx2U8+13BiMpImYpcTihOXa
	R+9/GzQ5NyMmEUlAQ=
X-Received: by 2002:a5d:63d1:0:b0:432:58c8:b90e with SMTP id ffacd0b85a97d-43258c8bbbfmr6367041f8f.15.1766413417042;
        Mon, 22 Dec 2025 06:23:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyImw4XMhTBxJUfL84ZDk9vS70CrNcVF3MfALYeuhb7Kn9/DgoXQ0ZDP0UtmBpBPiEUrFQzA==
X-Received: by 2002:a5d:63d1:0:b0:432:58c8:b90e with SMTP id ffacd0b85a97d-43258c8bbbfmr6367022f8f.15.1766413416606;
        Mon, 22 Dec 2025 06:23:36 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4324eab33f5sm22705400f8f.41.2025.12.22.06.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 06:23:36 -0800 (PST)
Message-ID: <3607fba6-a519-41a2-9cbb-0d90ef3e6cb7@redhat.com>
Date: Mon, 22 Dec 2025 15:23:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] KVM: x86: Implement accessors for extended GPRs
To: "Chang S. Bae" <chang.seok.bae@intel.com>, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com
References: <20251221040742.29749-1-chang.seok.bae@intel.com>
 <20251221040742.29749-4-chang.seok.bae@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20251221040742.29749-4-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/21/25 05:07, Chang S. Bae wrote:
> Add helpers to directly read and write EGPRs (R16–R31).
> 
> Unlike legacy GPRs, EGPRs are not cached in vcpu->arch.regs[]. Their
> contents remain live in hardware. If preempted, the EGPR state is
> preserved in the guest XSAVE buffer.
> 
> The Advanced Performance Extensions (APX) feature introduces EGPRs as an
> XSAVE-managed state component. The new helpers access the registers
> directly between kvm_fpu_get() and kvm_fpu_put().
> 
> Callers should ensure that EGPRs are enabled before using these helpers.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> ---
> No change since last version
> ---
>   arch/x86/kvm/fpu.h | 80 ++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
> index f2613924532d..f132cad4b49e 100644
> --- a/arch/x86/kvm/fpu.h
> +++ b/arch/x86/kvm/fpu.h
> @@ -148,6 +148,61 @@ static inline void _kvm_write_mmx_reg(int reg, const u64 *data)
>   	}
>   }
>   
> +#ifdef CONFIG_X86_64
> +/*
> + * Accessors for extended general-purpose registers. binutils >= 2.43 can
> + * recognize those register symbols.
> + */
> +
> +static inline void _kvm_read_egpr(int reg, unsigned long *data)
> +{
> +	/* mov %r16..%r31, %rax */
> +	switch (reg) {
> +	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x48, 0x89, 0xc0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x48, 0x89, 0xc8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x48, 0x89, 0xd0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x48, 0x89, 0xd8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x48, 0x89, 0xe0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x48, 0x89, 0xe8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x48, 0x89, 0xf0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x48, 0x89, 0xf8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x4c, 0x89, 0xc0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x4c, 0x89, 0xc8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x4c, 0x89, 0xd0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x4c, 0x89, 0xd8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x4c, 0x89, 0xe0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x4c, 0x89, 0xe8" : "=a"(*data)); break;
> +	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x4c, 0x89, 0xf0" : "=a"(*data)); break;
> +	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x4c, 0x89, 0xf8" : "=a"(*data)); break;
> +	default: BUG();
> +	}
> +}
> +
> +static inline void _kvm_write_egpr(int reg, unsigned long *data)
> +{
> +	/* mov %rax, %r16...%r31*/
> +	switch (reg) {
> +	case __VCPU_XREG_R16: asm(".byte 0xd5, 0x18, 0x89, 0xc0" : : "a"(*data)); break;
> +	case __VCPU_XREG_R17: asm(".byte 0xd5, 0x18, 0x89, 0xc1" : : "a"(*data)); break;
> +	case __VCPU_XREG_R18: asm(".byte 0xd5, 0x18, 0x89, 0xc2" : : "a"(*data)); break;
> +	case __VCPU_XREG_R19: asm(".byte 0xd5, 0x18, 0x89, 0xc3" : : "a"(*data)); break;
> +	case __VCPU_XREG_R20: asm(".byte 0xd5, 0x18, 0x89, 0xc4" : : "a"(*data)); break;
> +	case __VCPU_XREG_R21: asm(".byte 0xd5, 0x18, 0x89, 0xc5" : : "a"(*data)); break;
> +	case __VCPU_XREG_R22: asm(".byte 0xd5, 0x18, 0x89, 0xc6" : : "a"(*data)); break;
> +	case __VCPU_XREG_R23: asm(".byte 0xd5, 0x18, 0x89, 0xc7" : : "a"(*data)); break;
> +	case __VCPU_XREG_R24: asm(".byte 0xd5, 0x19, 0x89, 0xc0" : : "a"(*data)); break;
> +	case __VCPU_XREG_R25: asm(".byte 0xd5, 0x19, 0x89, 0xc1" : : "a"(*data)); break;
> +	case __VCPU_XREG_R26: asm(".byte 0xd5, 0x19, 0x89, 0xc2" : : "a"(*data)); break;
> +	case __VCPU_XREG_R27: asm(".byte 0xd5, 0x19, 0x89, 0xc3" : : "a"(*data)); break;
> +	case __VCPU_XREG_R28: asm(".byte 0xd5, 0x19, 0x89, 0xc4" : : "a"(*data)); break;
> +	case __VCPU_XREG_R29: asm(".byte 0xd5, 0x19, 0x89, 0xc5" : : "a"(*data)); break;
> +	case __VCPU_XREG_R30: asm(".byte 0xd5, 0x19, 0x89, 0xc6" : : "a"(*data)); break;
> +	case __VCPU_XREG_R31: asm(".byte 0xd5, 0x19, 0x89, 0xc7" : : "a"(*data)); break;
> +	default: BUG();
> +	}
> +}
> +#endif

These are also way too big for inlining; move them in x86.c.  Already in 
patch 2,

+#ifdef CONFIG_X86_64
+static inline unsigned long kvm_read_egpr(int reg) { return 0; }
+static inline void kvm_write_egpr(int reg, unsigned long data) { }
+#endif

can be in x86.c.

Paolo

>   static inline void kvm_fpu_get(void)
>   {
>   	fpregs_lock();
> @@ -205,8 +260,29 @@ static inline void kvm_write_mmx_reg(int reg, const u64 *data)
>   }
>   
>   #ifdef CONFIG_X86_64
> -static inline unsigned long kvm_read_egpr(int reg) { return 0; }
> -static inline void kvm_write_egpr(int reg, unsigned long data) { }
> +static inline unsigned long kvm_read_egpr(int reg)
> +{
> +	unsigned long data;
> +
> +	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
> +		return 0;
> +
> +	kvm_fpu_get();
> +	_kvm_read_egpr(reg, &data);
> +	kvm_fpu_put();
> +
> +	return data;
> +}
> +
> +static inline void kvm_write_egpr(int reg, unsigned long data)
> +{
> +	if (WARN_ON_ONCE(!cpu_has_xfeatures(XFEATURE_MASK_APX, NULL)))
> +		return;
> +
> +	kvm_fpu_get();
> +	_kvm_write_egpr(reg, &data);
> +	kvm_fpu_put();
> +}
>   #endif
>   
>   #endif


