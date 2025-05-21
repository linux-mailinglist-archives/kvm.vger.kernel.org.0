Return-Path: <kvm+bounces-47240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2C7ABED86
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D572171937
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9568235058;
	Wed, 21 May 2025 08:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqNi3ofP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799BF23535A
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747814736; cv=none; b=eCfYclwzivP2YkTNYo4IMXyRGsxxVWL7XaHw7cndIGlVr5fT4hphR7ZNR9HKSgFSkuoEOa5/HeZNt1jC7lH8FxkDcVNvVsqO38kASy9XExB37qkxxjzZx5cEaUvnc33qezMQKMi0at38wjkG7SvL6OUWHZNwMUNOd+jdncga+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747814736; c=relaxed/simple;
	bh=IqSXhdcylfUdFSUYg1eVv17kUPET5mNhT3rIMuowAz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuONmz4Xoiw/G/VdXJSGZkQEIaKi201J6koa8elsvJGBQl61lPKaiQTYlRcsoCcDtnOfEXX2pmUSiVaERxxT5EgbnzYzrUj+15HZ/rLpqwD2jbhzQwv18FKI+6G13ohVgdc7rEaAs9ocK3JploLedtAMhWI0FBIX/Lx76885qEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqNi3ofP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747814733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ktDN8IFxo8qOxs2cL7Zqg2ZDvx2QPyH7DDMGrarR9w=;
	b=eqNi3ofPhY5F7hXVDsCNgPzQXGq3SuIjWgld6dlG7dcZys3FckeXH2cG2xAKKO+67EmmmN
	N+Jw1UU3OjBibr79B3XdAHgDFVB/feEcyyiGeANDrgI6vJY57aLw5e5JvpsG6P2uwrlS/9
	drToDLCd7wfnWJZGggXUgJ8680lr+to=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-qPR5ozihMaWFBRKXtfSeOw-1; Wed, 21 May 2025 04:05:31 -0400
X-MC-Unique: qPR5ozihMaWFBRKXtfSeOw-1
X-Mimecast-MFC-AGG-ID: qPR5ozihMaWFBRKXtfSeOw_1747814730
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43f251dc364so14418115e9.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 01:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747814730; x=1748419530;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6ktDN8IFxo8qOxs2cL7Zqg2ZDvx2QPyH7DDMGrarR9w=;
        b=S1t+TUTbiwlPcVMKeFLGSE7KAwU/qFZGHECwSPtRLFdvJiR1TwjEKFJP4Pe7jzMBbV
         GJ4/Sfex2uGURFWdCQabeZV9szFE4U/3N2+PhAR1pNpBTQV5nDn+8ZfZa5UZ/08Ieljl
         lsz0cjxMHrzuiCqhzi1pG/WfWdXOMPYIbpG8E2vx1wYfI0iax6O4uj+ZeueC1mkAJ/H2
         la74gYOO3aHzA6Gq4LR3aMe58/mXa/7jj4x4Ty3ZcnIAfBoxjD9ETeSRrTzbpJ5qpQud
         JsiyiB+T8TqwZMujjOQyqvbjUOopJsut1ZFPcCkRy0gPuCFbodBNZV3LgP8EZK9OEA/T
         WTWg==
X-Forwarded-Encrypted: i=1; AJvYcCXWuWj0zJOYyVgIUoYOAPujJjbB95MbZEQltTRBf2BmDuqrnER+2/rQEWcoQ4sgANZQhQI=@vger.kernel.org
X-Gm-Message-State: AOJu0YybyGc5bgj5e8VSzw8NtnvJYkjdJzR2ex+9LoB/gK+5fsAtb0cp
	0QHxpGrk1TetEqZt4gwRuH3dW67WOgjj976w1lTcexyWjcUw2hd14H3uyyNFVm1DRKvtzEsCL5F
	Ur6b1joYTLAxz6hSiiA2WC2jjjiKEDhGbVMHQmrizIvshu/mAdd0kvwUZJ/h482Sc
X-Gm-Gg: ASbGncvqJzvUj9WIsTJFmG4PWtTdKxzArPfJ+ZaK4BT1dXm6CQQh1pDFqMmFpaeGYgr
	jvo89knqJkco62HyFET62/lSI2mNve4/7RBqjCLeoFp011dAt/tgir7GeN7aZGpQX54hS5qpKF0
	WdRM7UPmTymiD2o4BAuDMNM0F7r/D87vVkJ3twXZU4NYeDMKjpK9mOqqZyqZXFp5WbJYG43z1Gw
	dUPv7hIva0TG2JGXpQH0Vjc9zdUJYP60nsd9l24pLubNe+wofgroVxuCgrjrRGP0LIIIFnNxn9e
	8okTaEqZj3vJN5dyU837qyBSehIQ8Feq7GJuOxUtOFM5JR+AOX4sXPKdNZzQtojSVu3xqtan8Aq
	2P9I5s/Y8/0P2LytZfYlyAAfKilLjRJRatRG6oYI=
X-Received: by 2002:a05:600c:45c3:b0:43e:a7c9:8d2b with SMTP id 5b1f17b1804b1-442fd664965mr174297675e9.24.1747814730406;
        Wed, 21 May 2025 01:05:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzsKxIQPqCqHfI33s0xEr+R76Aln2UZbHko71i4zE6cECnJJjGxCyo8b53fGN2nGMzHJPc4w==
X-Received: by 2002:a05:600c:45c3:b0:43e:a7c9:8d2b with SMTP id 5b1f17b1804b1-442fd664965mr174297285e9.24.1747814729916;
        Wed, 21 May 2025 01:05:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a367205338sm15379116f8f.98.2025.05.21.01.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 01:05:29 -0700 (PDT)
Message-ID: <2084504e-2a11-404a-bbe8-930384106f53@redhat.com>
Date: Wed, 21 May 2025 10:05:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-15-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250513163438.3942405-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.05.25 18:34, Fuad Tabba wrote:
> Enable mapping guest_memfd in arm64. For now, it applies to all
> VMs in arm64 that use guest_memfd. In the future, new VM types
> can restrict this via kvm_arch_gmem_supports_shared_mem().
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>   arch/arm64/kvm/Kconfig            |  1 +
>   2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 08ba91e6fb03..2514779f5131 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
>   	return true;
>   }
>   
> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> +{
> +	return IS_ENABLED(CONFIG_KVM_GMEM);
> +}
> +
> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +	return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
> +}
> +
>   #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 096e45acadb2..8c1e1964b46a 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>   	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>   	select SCHED_INFO
>   	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select KVM_GMEM_SHARED_MEM
>   	help
>   	  Support hosting virtualized guest machines.
>   

Do we have to reject somewhere if we are given a guest_memfd that was 
*not* created using the SHARED flag? Or will existing checks already 
reject that?

-- 
Cheers,

David / dhildenb


