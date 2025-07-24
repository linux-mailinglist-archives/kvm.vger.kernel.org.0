Return-Path: <kvm+bounces-53417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 602EEB1144E
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 857C0547EFA
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E85C23BF91;
	Thu, 24 Jul 2025 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZPoPGnvS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC2223336
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753398225; cv=none; b=AlSI5ht/RSaKmNaSobogvuUO5aBNkM66yXdLuWtMPp2/kRJ4DNA5QmWf5be6vdaq2f6aIqlAZPEertX1InGW9J4Ji/UfTRfoowbynBoO2XK9AHRRxykIJtIPWx7Mg/egkDV5SmTsPFg5S7HJPOl86OZlAqtjEvHVMqkdGyIBpYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753398225; c=relaxed/simple;
	bh=Lbu1j2VeC+YUlaGAQB1et29Lmaxg0KeQQE+Hwd4SVNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i/J74UuSlOnX8/+MCAvFZM4PWZ34qa3YumE2GyNK/9sNU/tWsnDC5Cd4/z1m0+SuZASmUSoRyVWNwWntftQWWfnLJG//KUDH4FeCbqz9HU067TcKHMme36WLQiA5LCaXn/oPsM3EnPi+Rspc9iliQHzaZ8QxS5Y95FdR7Ip/OvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZPoPGnvS; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31bd4c3359so925544a12.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753398223; x=1754003023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=ZPoPGnvSB4QdnL8MbpJiIt9jGiso63W9ix9nXn6jnjeGQuzuki4MKNgB15QD/4oFRV
         HdRIplcHwsRPsFFiv1EBLC2dFQqMDu+oTXtwJNEr7x1jlZBxhaXVRyoST8KoSSWL3UZ2
         FlRZuxm/cSduGGmB9xL2rQO82Y4K3ucf17REmgEjHeBI6EqxIWn3TnhiwN7g5sOgCfhx
         LN4hx8XeyHGvKxp4zjMGMqwJO3aIuM5Yu8WOUsLtLGGpmopl3cCIohXZfcXzEx6U6UX/
         1Qj55vpr+66/l3gJ3fmxKis2XI3HNUDHHkpQu9F2LJ8Oe84YM/xfy7zUiWr3nSFkAvdE
         M49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398223; x=1754003023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=oymhzUGpX5fBc6/JfdKoR8jITPBrwvxi9aM8uMSoZQUslzqqImdLPb1MzjokiuYWvd
         Ukqzq0SUi/OTxNqSmURkj8z0ZzmXB163pMaJIoor1ihFFlIKntMbJojUI2r4oZwcbPnC
         hZQJFOtmIKob0V58Zn03S0/JtArLckM/K7nnVGueZ15NCOiGE8qdv4yT1fdsTbrIPZNE
         4PgbYEzRrVbAtZrAB1WPVsC4O3e4eBASaImsrT42LDvUmYVVn/ZnFEornwnJYzTqeb8Q
         SPzda4gpeQReqBHsSoL5Hf434e3Ke0ogN4QXyXKsLvJym6sHYOP9Md9l7Pe97T/pqAjQ
         6ydg==
X-Forwarded-Encrypted: i=1; AJvYcCVL5UGN+ej1MpNR7R4gCfVTJy5aerjnd5U5ulZBeXSKRmltlIONqvV98S6Axt52IaZ3/HM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJnYj4dy3RQ81vQDd9gGLRhxE61EmswN9cMUW0JTYkxR2RokH6
	4k0/h7fU5JMhM+sWd7RrgCNsbDp2aT8ABryXqe7UmXxYhzSNQKJlPtS9t6py8Xr8kDxrOt+Y7SQ
	yd8dwHJxcvFGNC3HucQ42kuAy7g==
X-Google-Smtp-Source: AGHT+IHz2z61bSSBHE5WkJFRSn/f5Uz7Cdl50VxK06WJGcmxGFRErbOEdHF7gB/snCT71JrhZi9xeqGE6W9rTkxcyA==
X-Received: from pgam17.prod.google.com ([2002:a05:6a02:2b51:b0:b2f:5023:640d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:998f:b0:239:eed:43a6 with SMTP id adf61e73a8af0-23d491220ecmr15740822637.22.1753398223391;
 Thu, 24 Jul 2025 16:03:43 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:03:41 -0700
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-14-tabba@google.com>
Message-ID: <diqzldoddwdu.fsf@ackerleytng-ctop.c.googlers.com>
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

Reviewed-by: 

