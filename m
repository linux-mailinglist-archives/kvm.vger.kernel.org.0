Return-Path: <kvm+bounces-53418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D3958B11451
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE741C21BA8
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4705323BCE2;
	Thu, 24 Jul 2025 23:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wtI5yAxM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3561FFE
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753398262; cv=none; b=Rc0X5e1uMvGJuoTTQOOKGBB23Uj8ZRSPbz5Dgf0ilPDmyajZQOX9AawqVpGYkOId+WGE4lECoIM6He3kV2aEI8ALER+oFINahjrRxGb/FoTCAPruUk59fqGD/CdRIsKw2yWejzuOyfyOuze1pn+6x83vCRD29EQIINH1n0UQbi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753398262; c=relaxed/simple;
	bh=2sbW1GuqiejMnWPX0tGyJH2t7C0wXl4RdCi38/ric3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q6tLM7y32l3zgdja7YyVnFZBlYLxGAnoJCs9rQPR2y3odXBgvSKoZh8956kmOnBCOijGSdP4ed+TsyjH0HJTZn/SaVFNHQAZOLkeloNHz4wPUgoA8r1x3iKvt9fbDfLxXQuqxXK8mtorFerSAN83LpBmnyOrCnPDDpLYETzLVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wtI5yAxM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso1431965a91.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753398260; x=1754003060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTJvoVT99m3CIaUayqF3P9earEQjE3s9Azx4PZBgqLw=;
        b=wtI5yAxMwbK0SC7lij8uo7zqJ1KiLQFMXI/69RVrnxErENo7l3FDRGr5OqKR2fo48k
         ZyGYrwTXvNDoKD458z4rv+8qn5FA4v5CnyqPT+mp32rs0BBLbD+M1iRWkXxDj1Z5vyi5
         jDJPgUeS2KViJAdZH/zZqvk4kVEI4Eh7jWkIjmPG/iHkk9WFp4JM2kv3dRcKokWtr0E3
         9NET09tsgBQ4YfyQnD4+CRVO3ulvb0KMsmrV5at0f2XggjJPP6tm4V3it5CW4f2Cp9u8
         7vKMBMW2eSzBpoHV4hYsSeS8LD9Tb53qbqjQyiIQlCNh6TVkVH/xJ3oiL+QRlUfz67Jc
         eLhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398260; x=1754003060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NTJvoVT99m3CIaUayqF3P9earEQjE3s9Azx4PZBgqLw=;
        b=NXSDIK3NgqnTIUIC3hlbMIOF3h8dBTq2eehyTt1s5fl+JwR8nrqxjHQn7OBBmRQ0o9
         +UJEB2bcpUpJ7DYmI2+1oGiV/0HRUA1aKwI4GgoTmK4vxX329GnpWVsU5SXRRqwU6g7f
         zPBeuBgkhSWJEPC2ru8GLuDr89W0m16iNGrRNr7dTYdGe4KYPpYaCtm9t0yuUMRitpWT
         2H/fp8XxTnfZ5T6WsYxldO2ykbWiHhhb9cKzcULk8c/r+VcQ+/xb606fz7iLl4lGpUNV
         dlkcI1sStYAyWO7cKlzDMN8x9SGUkMwRANm8ivwHlmK6MUxaANpJQr93xRjlSdLIyVNg
         n0+w==
X-Forwarded-Encrypted: i=1; AJvYcCU2oW1AfS8PwXJ4UIOH+sjsZvHHvccJW5ZHm1O3beb3zfljZFx6ehds+LjcUpfLyXiSwWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmMvp34ZieGCcbroDPAQYShUEr5HqCd9fbeNEA2RF3hh1+eKsy
	uV6pKw+Ek3PtXStS4pspocaoLDg/+f3HWT7SU+os8EyUpCeh45b1x3YZQt6IZZtrT+iKRRKvLSt
	GTmdO5NaoUc8ZXmksT9tVyUr/hg==
X-Google-Smtp-Source: AGHT+IE+Py7qsCB31cPaqiCQRQWGyNOq4FjwR+05A19/Rt6iIKCBE8SZxnpYdzgkdn8Fx+/T4+FL2T1bJ7x1sq1aHQ==
X-Received: from pjbrr3.prod.google.com ([2002:a17:90b:2b43:b0:311:eb65:e269])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52c7:b0:30a:9feb:1e15 with SMTP id 98e67ed59e1d1-31e6624301cmr5597762a91.8.1753398260233;
 Thu, 24 Jul 2025 16:04:20 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:04:18 -0700
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-14-tabba@google.com>
Message-ID: <diqzikjhdwct.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
> mmu.c so that they can be used by __kvm_mmu_max_mapping_level().
>
> Opportunistically drop the "inline" from kvm_max_level_for_order().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b735611e8fcd..20dd9f64156e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>  	return level;
>  }
>  
> +static u8 kvm_max_level_for_order(int order)
> +{
> +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +		return PG_LEVEL_1G;
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +					u8 max_level, int gmem_order)
> +{
> +	u8 req_max_level;
> +
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (req_max_level)
> +		max_level = min(max_level, req_max_level);
> +
> +	return max_level;
> +}
> +
>  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  				       const struct kvm_memory_slot *slot,
>  				       gfn_t gfn, int max_level, bool is_private)
> @@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		vcpu->stat.pf_fixed++;
>  }
>  
> -static inline u8 kvm_max_level_for_order(int order)
> -{
> -	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> -
> -	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> -		return PG_LEVEL_1G;
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> -		return PG_LEVEL_2M;
> -
> -	return PG_LEVEL_4K;
> -}
> -
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> -{
> -	u8 req_max_level;
> -
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> -
> -	return max_level;
> -}
> -
>  static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>  				      struct kvm_page_fault *fault, int r)
>  {
> -- 
> 2.50.1.470.g6ba607880d-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

