Return-Path: <kvm+bounces-45238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE576AA75B7
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 17:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F45E1C06597
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:11:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5322571C7;
	Fri,  2 May 2025 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsLsLQu8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847C52566FA
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746198678; cv=none; b=CBvoS3lnVezfyIMy8l2fTNUoK5WRPgvZmgy8PlvZdQekkb7Mt4zeMYWDWneCRb/e0dunD8QeUwStXs+ItgzhC+joMMH1xVZEc4kuKdEbXEz763tRPQqusP+xWDH2Wlhso2qx591nM4mzAMGDgGUSkt2JirBXpHCAUuOBx5RfyZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746198678; c=relaxed/simple;
	bh=+f8fcTvqKdw0saUdjQpi1xadkwmQDthuwD77UPE6f9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=og+EItzTtekkITNl0xJmLZJwrL7+7NARjKeQq+bHpMGfeR3XT6pb1h3JhzPxPxbAWGsnA3odhj2IcV2iI0YdTo41q36g4Xz+FdIcbgnd0xOX2QcEneVEn6iVyE0liiUYRoDUDfnrVM6D1J1m7i/Y3sEb1avOlD/fybuyz7c+OhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsLsLQu8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746198675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oeOSoQEbtfOeQHIFORR+tFUtREhNLe4f74iiBENG5lw=;
	b=YsLsLQu8HAHfaaFGlcWBjC5MLjxJVnACfzZQO6FtZWzxPAaUobU6Rbh3a/t2uBFucOsbcR
	ZKQYYqx/IO6Abz0gc+mdrA6/9eiGL4C3maJpGNLtxU1nZP5wckS2dh6LD3Vrx9XXjHuebz
	fkVOUqAA2zJjJkCmrJdxRXWxLMYUZXc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-moWuHU5pNoKp-D2nMB_j1A-1; Fri, 02 May 2025 11:11:13 -0400
X-MC-Unique: moWuHU5pNoKp-D2nMB_j1A-1
X-Mimecast-MFC-AGG-ID: moWuHU5pNoKp-D2nMB_j1A_1746198673
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so10868325e9.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 08:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746198672; x=1746803472;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oeOSoQEbtfOeQHIFORR+tFUtREhNLe4f74iiBENG5lw=;
        b=oUu24JtHLV5tyJM/gbECSW/hGEt3eabSSZ+tsTb/PICQKW5VG+xJeazuRsTh609XF0
         LBybbA52ffZpYmWCuHd/6GxWSf1JlqxyYo/oAoWXqnyWi+Tgt9yowC3fQiMP646qs9Er
         jllqUk23SkvOZrhEoOwyyJtxP2yXMnDedlOQf+sdajRtUAGLrH3fJAGTtiFXruqvHWwR
         SuRD2DDqyIkyGDQMLW0fv/V8vf6SMJ+wRdaurYCvc5fLDtaRJ2HF8teHE5gAnScQCQHD
         QaatnRovCAUkkvVkycnCSFdmjWRqjlTtmmdfPwFBeV2FABQJ4vlbmmNUqeoHWL02XjZZ
         r4Jw==
X-Forwarded-Encrypted: i=1; AJvYcCV0q4KyQM7U69ZVsW1MtbXA3CZsrNZDSRX6lNosu8GzygOaqMLjUhzUGwJilr0Va0yJ0mE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPbnfS4t9ukEWZX7DPMiD/plij5G9JjQM1rAeUG4QOpPnDFk7U
	aTREEYj9hH1kyFGNV6SrGG/SWc1Lagg77w6lk4DrROUVD7wdPkbvuy72qB/xskH2lFe/YGJsjBS
	4o+rSRg52TuoTWl7b/SfiQYVxmTRMsbfQz4bPVr92n+kYPt+ACQ==
X-Gm-Gg: ASbGncvMLl9eD8VKeCI0IofzgAsBE0aMhqriZETTYsUuzp35a0PKEDLSwIiuAG8cCZ2
	HKqRtjuCz8gwN3p1e+CSoDYHoWf3tpS3mQwn9SkvOj+cELb8fvmdW2dISh2ctTMw/vPM3Excbtb
	iWWpD6CmCJPCZALhLOFq+zRbDpN0tc+KlPHLPqhdZZKZTowq5gv3jshZ2iFpKg42hV2Vd0/dQJM
	TjTuO0pjuGs6OM4QeetWoJqz15Uh60TDoMni8HSjoAqUsKbsrCWHXCZ1iOCvfInEcABytd4NmGL
	upPM3Mcu8tJJsSvUzwvhqiVdmgudKrwH7BTG7PY568p4tKztF8GcqyVxbBYaPx51ddWYTXgDtDl
	XxXhl7Il+dkeDaYVQcDP5EqhDoPxB33keG63Ia+g=
X-Received: by 2002:a05:600c:4fc4:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-441bbf2b0bamr22741705e9.22.1746198672532;
        Fri, 02 May 2025 08:11:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0q+1cwx8IrPw5X6nPiyFCm3Io+OO0rmrCF4BJr19jrVpzkKwi7wU2NccqcFmYZatAHG5a7g==
X-Received: by 2002:a05:600c:4fc4:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-441bbf2b0bamr22740975e9.22.1746198672077;
        Fri, 02 May 2025 08:11:12 -0700 (PDT)
Received: from ?IPV6:2003:cb:c713:d600:afc5:4312:176f:3fb0? (p200300cbc713d600afc54312176f3fb0.dip0.t-ipconnect.de. [2003:cb:c713:d600:afc5:4312:176f:3fb0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441c0dfc537sm1328385e9.16.2025.05.02.08.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 08:11:11 -0700 (PDT)
Message-ID: <cd426cb8-e758-4028-adf6-9426884f6f7d@redhat.com>
Date: Fri, 2 May 2025 17:11:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-9-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250430165655.605595-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.04.25 18:56, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
> 
> This patch introduces the configuration option KVM_GMEM_SHARED_MEM,
> which enables support for in-place shared memory.
> 
> It also introduces the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that the host can create VMs that support shared memory.
> Supporting shared memory implies that memory can be mapped when shared
> with the host.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 15 ++++++-
>   include/uapi/linux/kvm.h |  1 +
>   virt/kvm/Kconfig         |  5 +++
>   virt/kvm/guest_memfd.c   | 92 ++++++++++++++++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c      |  4 ++
>   5 files changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9419fb99f7c2..f3af6bff3232 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,17 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>   }
>   #endif
>   
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
> +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> @@ -2516,7 +2527,9 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   
>   static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
>   {
> -	/* For now, only private memory gets consumed from guest_memfd. */
> +	if (kvm_arch_gmem_supports_shared_mem(kvm))
> +		return true;

After our discussion yesterday, am I correct that we will not be 
querying the KVM capability, but instead the "SHARED_TRACKING" (or 
however that flag is called) on the underlying guest_memfd instead?

I assume the function would then look something like

if (!kvm_supports_gmem(kvm))
	return false;
if (kvm_arch_gmem_supports_shared_mem(kvm))
	return .. TBD, test the gmem flag for the slot via gfn
return kvm_mem_is_private(kvm, gfn);

> +
>   	return kvm_mem_is_private(kvm, gfn);
>   }
>   
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..8bc8046c7f3a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> +#define KVM_CAP_GMEM_SHARED_MEM 240
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..f4e469a62a60 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> +       prompt "Enables in-place shared memory for guest_memfd"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..8bc8fc991d58 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,99 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +/*
> + * Returns true if the folio is shared with the host and the guest.
> + */
> +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	/* For now, VMs that support shared memory share all their memory. */
> +	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);

Similar here: likely we want to check the guest_memfd flag.

-- 
Cheers,

David / dhildenb


