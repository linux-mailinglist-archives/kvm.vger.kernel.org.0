Return-Path: <kvm+bounces-53421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56054B11487
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 01:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E6D918883D6
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 23:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C221E500C;
	Thu, 24 Jul 2025 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GjkEOyAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFA519343B
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753399886; cv=none; b=L0b196bk1VDP7e46xZlzvOfknJg4xevAp8LJ6imgUTF53pK9UkgDrTKYTGA33cmtwcAhsAQdxV+cZl/S/Q/LaqpfuPmQZPFXW11mdFHCfsZLAf1UUIeErF6baUBsUdmaNQzrrddOXWuRz0TgmK7KJHTbt5nTGT493XUQhe4vB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753399886; c=relaxed/simple;
	bh=4YxjfcNcYvreHz0gcqwGyKeW+nB4cpITSY9v+XvC0Hc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BdDBKCUW7582tNonuJZffbtLYDRtlnIxANRv3yOuWX+BxLweldQ9+VKamED8miPXTbenWGTJBAdQGQk2jBWjiyYzp/08RWDN37EOXoEO0NRoVQAOZNGC4wR6G5YDTNmsqKZbR9XCwfz6S3qVSD5K46TRHa8cmjGEdyUid9MOpUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GjkEOyAD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2363bb41664so13073775ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753399884; x=1754004684; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp627SOn/U3DKHH0cx4CozafOSeA3JpbkyrsZdpeeic=;
        b=GjkEOyADgbBIJ+BFjfeLJe8hTghJ/YhDu+m3viRUA6xrKvOFjv9aX+IeZC9B5REjra
         AArBHqLRNsYNZvCp7UZwLnRbpQRfYLqDTH+Y0NFEU7Tu8oVXrbduTw1iVzYom3eptu6f
         N1td+B2ZTqHwQHQs/OL03lceSfx5UnqBAqUkFKonF0AuSowHX++MicjooHcNXoybbmR8
         kazIAXw+W1Q8VA7uLOAGRs7BjP9WiUP649TpSfOdDed2Du+Ous8kC41FPQdWhImBxoDm
         yb+oGJwx2DWK7rxHq2NyhdN3LC31oJnHmlkqs3Fw8r+h7Nr0tryyHhDkEQ6h4uEDfSDU
         rMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753399884; x=1754004684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp627SOn/U3DKHH0cx4CozafOSeA3JpbkyrsZdpeeic=;
        b=MOwi91qWeLthsECfIMpTqW+cznX/BkMhpFbZR3Xc/GRVKm/mz30FLLSCMUkGO90oEH
         FUsZhpdLHTySwlKdvf9KuyJk33/OvYysPqAhY0mdy07Z48H2bfj0YKpISx6nd3x0ZHH1
         wg7uW0HIPY32uzmKS/ZzIw748mNRpJDv9EftnaqecgGDeRMtr6ytI+ffQAd+B1RyWrOx
         PMNCxClPEWwwunBJTcePlwMh87qKwKIa/NmOD8klf8ijDthp8+FFAoZ+YO4DfGGj7/A7
         zissoEFJk620wbq7E/ZtfSdZyBsISrHc1HhraU+qMjPpMsvbUbzoVZjhTcUZz9J9NAuZ
         IMuQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3l6EnFEzsINKYpqVeowAZe53d00bNGMkz2klxv+i3Hxt61EnaSSaoTxN7glIZuwA4qLo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl0jWCrAhQmM5r8xDT6qEWjpBr+c+D7xzpMPwi3lV093WMioRS
	bSYXYyATQcl3I5O3ujnQTV3m4lc5Ua+ZS5SZS9xlcmFM0Xr4YqEVOaJCeC7GLcofTn0REWkGy4N
	YXlsxzUfA0xIhmxYreBJZBsHvbA==
X-Google-Smtp-Source: AGHT+IFvui1Pst0YKPd1yfVqz+NO19tPVE9VTZojkGV++wZpfN6iqbBP+KKwokgJWixSu42pVoJTFycmKkH5wKz+CA==
X-Received: from plei4.prod.google.com ([2002:a17:902:e484:b0:235:e734:e93e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84a:b0:234:986c:66cf with SMTP id d9443c01a7336-23fa5d33199mr56305505ad.16.1753399883467;
 Thu, 24 Jul 2025 16:31:23 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:31:22 -0700
In-Reply-To: <20250723104714.1674617-16-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
Message-ID: <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
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
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
> not just private mappings, so that hugepage support plays nice with the
> upcoming support for backing non-private memory with guest_memfd.
>
> In addition to getting the max order from guest_memfd for gmem-only
> memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
> restrictions on page size only apply to Secure EPT mappings.  Do nothing
> for SNP, as RMP restrictions apply to both private and shared memory.
>
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
>  arch/x86/kvm/svm/sev.c          |  2 +-
>  arch/x86/kvm/svm/svm.h          |  4 ++--
>  arch/x86/kvm/vmx/main.c         |  5 +++--
>  arch/x86/kvm/vmx/tdx.c          |  5 ++++-
>  arch/x86/kvm/vmx/x86_ops.h      |  2 +-
>  7 files changed, 29 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c0a739bf3829..c56cc54d682a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> -	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
> +	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6148cc96f7d4..57c18ab91646 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,12 +3302,13 @@ static u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> -					const struct kvm_memory_slot *slot, gfn_t gfn)
> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +				     const struct kvm_memory_slot *slot, gfn_t gfn,
> +				     bool is_private)
>  {
> +	u8 max_level, coco_level;
>  	struct page *page;
>  	kvm_pfn_t pfn;
> -	u8 max_level;
>  
>  	/* For faults, use the gmem information that was resolved earlier. */
>  	if (fault) {
> @@ -3331,8 +3332,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
>  	if (max_level == PG_LEVEL_4K)
>  		return max_level;
>  
> -	return min(max_level,
> -		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
> +	/*
> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +	 * restrictions.  A return of '0' means "no additional restrictions", to
> +	 * allow for using an optional "ret0" static call.
> +	 */
> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> +	if (coco_level)
> +		max_level = min(max_level, coco_level);
> +
> +	return max_level;
>  }
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	if (is_private)
> -		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +	if (is_private || kvm_memslot_is_gmem_only(slot))
> +		host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +							is_private);
>  	else
>  		host_level = host_pfn_mapping_level(kvm, gfn, slot);

No change required now, would like to point out that in this change
there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
shared pages, guest_memfd will be the only source of truth.

This holds now because shared pages are always split to 4K, but if
shared pages become larger, might mapping in the host actually turn out
to be smaller?

>  	return min(host_level, max_level);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index be1c80d79331..807d4b70327a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>  	}
>  }
>  
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>  	int level, rc;
>  	bool assigned;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d84a83ae18a1..70df7c6413cf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>  void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
> @@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>  	return 0;
>  }
>  static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> -static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dd7687ef7e2d..bb5f182f6788 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -831,10 +831,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return tdx_vcpu_ioctl(vcpu, argp);
>  }
>  
> -static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +				     bool is_private)
>  {
>  	if (is_td(kvm))
> -		return tdx_gmem_max_mapping_level(kvm, pfn);
> +		return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0d84fe0d2be4..ff44f4bd76b5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3338,8 +3338,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return ret;
>  }
>  
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
> +	if (!is_private)
> +		return 0;
> +
>  	return PG_LEVEL_4K;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 6037d1708485..4c70f56c57c8 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> -- 
> 2.50.1.470.g6ba607880d-goog

