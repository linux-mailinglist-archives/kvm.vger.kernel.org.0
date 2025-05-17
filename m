Return-Path: <kvm+bounces-46933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EBFABAA11
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 14:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4937C7A9CCC
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 12:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548CF1FF1C8;
	Sat, 17 May 2025 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OwoWElN2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76262D052
	for <kvm@vger.kernel.org>; Sat, 17 May 2025 12:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747485387; cv=none; b=rc4y/Z9ImqKRYil4fQ5qDzM8KoP9pt9IqlVibZA8WvlTuP1K92qQgfuQsROAacz9sMHLh/MFC1gkcV71zGzToStCQCCwOR8LQvL6mlDKJUjk1llbeYmiDnm+dVkB0L/JCIV6KlDAL3WxzecX6T9Kz5LUqMblW5PC5pKTwERRsS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747485387; c=relaxed/simple;
	bh=etuUqgZDekTPWc1mywUqKCAieD6k+Xk2ltdLNLatqW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjvmSSZ5H1m3mHTmf8S746W0exUo9lpDQ4gkN9Hy3ddQWHOwblomo+W/09AzJvDehJ8yKOSdbzLt9f95WxRBk0YpWKie0hd1rqlCOXpdYd0bsvdfFRBwL/EFuLxAK5/YwZ4f6+imTnx0kanWE/HXp2OmCVEbJ1yLOIhInwtwxGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OwoWElN2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747485384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3hCuTfjsNu5ACQNXXwWH9knQPQhUx7u9apSg60b7GQc=;
	b=OwoWElN2UvNTTwhO2GI4ftBSHnLKj1O46jlM6eODfba0DmTxCgfnPqooAK7qP7V0QIupTf
	wQGlFuGHjOqgf313dvkQypsmsI29btVxJdXHbXqGzXzz4w7nqt65poEuW6vFhuPq2wMtTu
	8fWxE7QPSa4KrY9f2YCM/CeKesiULws=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-e5yUCcPJNI2yp-QX5stYlA-1; Sat, 17 May 2025 08:36:23 -0400
X-MC-Unique: e5yUCcPJNI2yp-QX5stYlA-1
X-Mimecast-MFC-AGG-ID: e5yUCcPJNI2yp-QX5stYlA_1747485383
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4768656f608so62582781cf.1
        for <kvm@vger.kernel.org>; Sat, 17 May 2025 05:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747485382; x=1748090182;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3hCuTfjsNu5ACQNXXwWH9knQPQhUx7u9apSg60b7GQc=;
        b=D/9b8ERkZ8LWQ6hBCmidRck8Oul0k9/KO9dRzx3t+umnre4e/WDOaV7DR6b/QvEqHh
         JKUmC6RxvqDcLvxMoezZnFT59iRwg+017nRamhwJ/Js2HnnBcIRuroVQnuy0/wgX+ZYW
         lIO9CVctE5fVYH1Oq0AZvLbgd9UFgvaRwoodbfdzXYhrVmglSzf/hG+ddeRWYubZhpv3
         nmpS3jlcV70oBwkoyfa65C2TXSAWKGITbmohWkbjrbCR165GzR7vRJCpdSo938b19KsM
         XxaNjXaYIPmq7t2WanH6VwbI3COpks91Zc2sdOuVua6VH9A4mY6GXhm+JuR1CJmrk9BU
         LJ0Q==
X-Gm-Message-State: AOJu0YwEVaJZ9zS9ki15En8oWSImwlMNnqfbX5Vw2iOcfx47HLk1EFVX
	P4CnK3Lew8yijeYQ4cUZ8Rz7qno0QTBdvCtlT2kUr8beknX1lG4PNWlyu5DVLSHBKmYImVwDaJw
	9UeORHOc4DUxYH0+/p9NUItB0vvsfKwcHTiffKaEPnXlsD4wmqhipUcmvI3soig==
X-Gm-Gg: ASbGncuMd5Q/DJtEgIPsFLKHLNQaXLos3V3Nf1zOBVF/f9cbnPM9mWuBO+xJgkwYvnk
	GKEKqhelh+Vj5UFhisDTRv2FqTEGklK4J0zN2vfgMke4mwY9KEc7QMJ4DsaxRbW0go+VfiGRyWp
	rgPw5BaEI0mzqmmoJDoopPKgVCltVAcpQduZuJT649npvSvftWP2ujNKDl4jGaxrXjyVF5SUj0K
	J/USoIm6ou2vYHAoVhUhwnTpWFD9TRhgVR40cEDPu6mDFrWRvnGOwAL+LUwoDpDDLT733HY7bNL
	Ft9TyzDcr7EmnJRbLQ==
X-Received: by 2002:a05:620a:25c6:b0:7c9:253d:f226 with SMTP id af79cd13be357-7cd467c0968mr1016119485a.51.1747485372489;
        Sat, 17 May 2025 05:36:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM609SyUfzUqo4OLsFLuxdNV4/x0HRlr8FVHAUN/Func1h8j8Ce5B7Setm7CTwZNs7enaEbQ==
X-Received: by 2002:a05:6214:f23:b0:6f8:aa6f:438b with SMTP id 6a1803df08f44-6f8b08352f5mr117405936d6.3.1747485361377;
        Sat, 17 May 2025 05:36:01 -0700 (PDT)
Received: from [192.168.21.214] ([69.164.134.123])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6f8b08afb37sm25011526d6.49.2025.05.17.05.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 May 2025 05:36:00 -0700 (PDT)
Message-ID: <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
Date: Sat, 17 May 2025 14:35:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>
References: <20250516215422.2550669-1-seanjc@google.com>
 <20250516215422.2550669-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250516215422.2550669-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/25 23:54, Sean Christopherson wrote:
> Allocate VM structs via kvzalloc(), i.e. try to use a contiguous physical
> allocation before falling back to __vmalloc(), to avoid the overhead of
> establishing the virtual mappings.  For non-debug builds, The SVM and VMX
> (and TDX) structures are now just below 7000 bytes in the worst case
> scenario (see below), i.e. are order-1 allocations, and will likely remain
> that way for quite some time.
> 
> Add compile-time assertions in vendor code to ensure the size of the
> structures, sans the memslos hash tables, are order-0 allocations, i.e.
> are less than 4KiB.  There's nothing fundamentally wrong with a larger
> kvm_{svm,vmx,tdx} size, but given that the size of the structure (without
> the memslots hash tables) is below 2KiB after 18+ years of existence,
> more than doubling the size would be quite notable.
> 
> Add sanity checks on the memslot hash table sizes, partly to ensure they
> aren't resized without accounting for the impact on VM structure size, and
> partly to document that the majority of the size of VM structures comes
> from the memslots.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/svm/svm.c          |  2 ++
>   arch/x86/kvm/vmx/main.c         |  2 ++
>   arch/x86/kvm/vmx/vmx.c          |  2 ++
>   arch/x86/kvm/x86.h              | 22 ++++++++++++++++++++++
>   5 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9667d6b929ee..3a985825a945 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1961,7 +1961,7 @@ void kvm_x86_vendor_exit(void);
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   static inline struct kvm *kvm_arch_alloc_vm(void)
>   {
> -	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	return kvzalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT);
>   }
>   
>   #define __KVM_HAVE_ARCH_VM_FREE
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0ad1a6d4fb6d..d13e475c3407 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5675,6 +5675,8 @@ static int __init svm_init(void)
>   {
>   	int r;
>   
> +	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_svm);
> +
>   	__unused_size_checks();
>   
>   	if (!kvm_is_svm_supported())
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d1e02e567b57..e18dfada2e90 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -64,6 +64,8 @@ static __init int vt_hardware_setup(void)
>   		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
>   	}
>   
> +	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_tdx);

I would put either both or no checks in main.c.

Or if you use static_assert, you can also place the macro invocation 
close to the struct definition.

Paolo

> + */
> +#define KVM_SANITY_CHECK_VM_STRUCT_SIZE(x)						\
> +do {											\
> +	BUILD_BUG_ON(get_order(sizeof(struct x) - SIZE_OF_MEMSLOTS_HASHTABLE) &&	\
> +		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
> +	BUILD_BUG_ON(get_order(sizeof(struct x)) < 2 &&					\
> +		     !IS_ENABLED(CONFIG_DEBUG_KERNEL) && !IS_ENABLED(CONFIG_KASAN));	\
> +} while (0)
>   #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
>   ({									\
>   	bool failed = (consistency_check);				\


