Return-Path: <kvm+bounces-52114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E35E7B0182B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7343B1898456
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE4727A903;
	Fri, 11 Jul 2025 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CT7VU5KF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C72586DA
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 09:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752226749; cv=none; b=Uh6UGLX+sdXqISTM0Q4XMPfFOWzZ3K8QcJ6Jkcu8/gSBS+rL1TtD3hwzX1FAnv6WrAeRBdBpi+rejtZmvQeONvHeddgZSRoSr0VwhntcCNuXoXyXPoNB7iyes0uQIQKQzhyI0BZ+78wY7iojaPYevpE95iEZhUklBq20PryQiRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752226749; c=relaxed/simple;
	bh=vY/001+f5o8pVVDfNEyy6yYui6CQQ2+0NkOOLOagp5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCZaFGesQBjx9xdR6J9HxxGSoKQL5ZWBHR6rrEvzVahMWk7PL/BBq9VT+oZnOwgYwf5L+zzKCnWdgxvdFHAAnd0PnqrYez2MsFJUUGfzc6yhVraNGvMdU4ed8v8mFt01hAG0Dk0g1wyI8q27ty8SFwC0W2KoYmQ7NHAUxUxxUwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CT7VU5KF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752226746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wQecZyWmWsgHDALYGnZ4BgAt7aKBzE7knExhR/Vkoxc=;
	b=CT7VU5KFMxkVYCdPdmm5lom+9jmJ69BWOEAKBhWo2/LxAeJlSWoQJaJMQhnwSlh9o2wsZa
	uohvALNaWjQ++REALwPrQ3gSDqfkBSJh9ODGNLKAY56WJ/EkHjkq9f22BjodzuKRfYv1dp
	Ulri6OEUGTvjBj22P6Sr6YxDdj0JoPs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-27BVOMISPqSwOl0tnQVdgQ-1; Fri, 11 Jul 2025 05:39:02 -0400
X-MC-Unique: 27BVOMISPqSwOl0tnQVdgQ-1
X-Mimecast-MFC-AGG-ID: 27BVOMISPqSwOl0tnQVdgQ_1752226741
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-454e25b2b83so6313875e9.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 02:39:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752226741; x=1752831541;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wQecZyWmWsgHDALYGnZ4BgAt7aKBzE7knExhR/Vkoxc=;
        b=n4Atsng0rnF4Nm47Cm3+Cvu902oiSukrJUbsS02gxNVWxhp5dLNaFG4id+flHAEX1o
         /jWGoLBbPsW9PKjtpTuwdi9z90cCPC3OaP3Zj3uPnFDuPj9BYGBNGvY1vKSm0QETa02k
         KSiunWlg/mDKkARfYqddr+dawJ74mI7ySdvW/a5ekElLZqbe6013zsCPG7DBTTi7KZh6
         BlGoIcAhNXhFkRALwdzcnvbas2l+OZjsS+QylbtoxQeK1bAJ1r1wUKwdbnWE98N6easZ
         fXbR0xf7sT3lTKrW1ggbMWp4pKnxVUJ/+Btr0rh70KA/Y6xLN1dMsevDi43MJCl1B+/T
         T3BQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNExUmESrQ/UOg8ccZY+CDTS05y3ujvuXeWIA2otH2CecBeZLEsU4BNo89x7zIsPxIvKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyED/ouL8b6wYcKTVQd1WP0TI2E4/GXgxB7G+RPLMieNuEB9ZI5
	ZjZaNd+lBf8ToKY8N8RHtbdAhhPJAKJ6WBHxi9W9vTFAE9xu43RJWFVxOlipqv9vpLtTOjGYicz
	wzxsWBLZL3710nI10zdVbjBOW199LrDhQ4/9Rc1OGNpoI2yF2cKyx1Q==
X-Gm-Gg: ASbGncusFYT9aZ+Xa/dOFuTxERNa7N2D0ASEaN0L6XOhjPGBw36N1u6HY6lAlW4fMGa
	swzGi8lfc5iePe1sZDU/yh5fSAY1cmHgJM8VmQhgsMpaK/V9QFub0Fh7k+naUui/zZGHGt5eZGW
	62jRWvKAbc8ivKiMsMOzG8SJcOnuh1TFDZFSvGLbWjsQ5wYoIzqrccsy3TDZDlFWSvZtXNPzsJI
	ZcP6PbgzwqRfaAVVEoGPf3Fk2KT4E/oSBV1aAsSGbbiqcGhivniM5wXQQ/Z8o1S5wWSMcQ+ro+6
	d8ihH0fNQI+/3QCeK4321kaNaNh/9weNtA7AuWJFUdvkh3E1EmQT9XbR0/mIPxXuPKOcXMliUMy
	Oyz5ndclDknV5Wmmgc8zTwY06YNWdM91zW9WAdawe3TKbk02LTg7nBH7MZk1lf4RS8hc=
X-Received: by 2002:a05:600c:4ecf:b0:453:dda:a52e with SMTP id 5b1f17b1804b1-454ec27e3b9mr16495235e9.33.1752226741128;
        Fri, 11 Jul 2025 02:39:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExWIvCiETlaLEh+tomf4x2EEMzXLfA9UvWDVsAMK1xk9DaBUTK6aJcyWeSpLnlgw09g/FhNA==
X-Received: by 2002:a05:600c:4ecf:b0:453:dda:a52e with SMTP id 5b1f17b1804b1-454ec27e3b9mr16494695e9.33.1752226740563;
        Fri, 11 Jul 2025 02:39:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3c:3a00:5662:26b3:3e5d:438e? (p200300d82f3c3a00566226b33e5d438e.dip0.t-ipconnect.de. [2003:d8:2f3c:3a00:5662:26b3:3e5d:438e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454dd54115bsm42810775e9.31.2025.07.11.02.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 02:39:00 -0700 (PDT)
Message-ID: <f76653bf-c170-4d21-b7cf-b1d2eb8f723e@redhat.com>
Date: Fri, 11 Jul 2025 11:38:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 11/20] KVM: x86/mmu: Allow NULL-able fault in
 kvm_max_private_mapping_level
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250709105946.4009897-1-tabba@google.com>
 <20250709105946.4009897-12-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250709105946.4009897-12-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.07.25 12:59, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
> pointer and rename it to kvm_gmem_max_mapping_level().
> 
> The max_mapping_level x86 operation (previously private_max_mapping_level)
> is designed to potentially be called without an active page fault, for
> instance, when kvm_mmu_max_mapping_level() is determining the maximum
> mapping level for a gfn proactively.
> 
> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
> safely handle a NULL fault argument. This aligns its interface with the
> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
> called with NULL.
> 
> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
> the function's scope is for guest_memfd-backed memory, which can be
> either private or non-private, removing any remaining "private"
> connotation from its name.
> 
> Optimize max_level checks: Introduce a check in the caller to skip
> querying for max_mapping_level if the current max_level is already
> PG_LEVEL_4K, as no further reduction is possible.
> 
> Suggested-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bb925994cbc5..495dcedaeafa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
> -					struct kvm_page_fault *fault,
> -					int gmem_order)
> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> +				     struct kvm_page_fault *fault)
>   {
> -	u8 max_level = fault->max_level;
>   	u8 req_max_level;
> +	u8 max_level;
>   
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	max_level = kvm_max_level_for_order(order);
>   	if (max_level == PG_LEVEL_4K)
>   		return PG_LEVEL_4K;
>   
> @@ -4513,7 +4509,10 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   	}
>   
>   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
> +	if (fault->max_level >= PG_LEVEL_4K) {
> +		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
> +							      max_order, fault);
> +	}

Could drop {}

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


