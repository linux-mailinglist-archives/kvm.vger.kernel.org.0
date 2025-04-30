Return-Path: <kvm+bounces-44973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2673AA545A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E03DF1C018F7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7447266B41;
	Wed, 30 Apr 2025 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TtR5vtTF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E143264637
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039518; cv=none; b=GPH3S5YEg/h6MRf1gX+KyF4RmFs5mFZWdNeJrKnyHv6ffPDEWpnQqTkTQjlhOpogJqkZ3wpDwSrym8QvADbPdSnvf0M2+wuVqX8TbXKcYNZNnPQtBFw9OSUEF6VGeotjsCgrLqsJDfr6klQzfkr1DLtcaPVAvH1hb3cr3YTD5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039518; c=relaxed/simple;
	bh=2xOOv/MCcyIAPDTupoMOfmGNIh9AOWzT0nGARV0C06I=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pzfYVZ04rQNidreGyE+UKpxTnIBUkPMad0Kmsquq7ZySlpWj4eU9xmrJ5DuUlmBfZENCliTqf1jdScHV7e3Q0J1yCpQECHW+skpf8evzKD0JNvIMgmwimBSmt3ucHqVZLDsWo9yn5RR6iIkI9qzB6TWsqHIxkA7Cjuq5Us3k6aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TtR5vtTF; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2242ce15cc3so1676915ad.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746039516; x=1746644316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9fxPskNZofSZePK1/+4gGlwKg7DgccpEf2CnNOiWW54=;
        b=TtR5vtTFVGTQ190UJvJlcwAF1I1R8FNGYILi+YGpTC5OUEknuOuVGbyKhHItWDKiai
         VJrohcNRdn3tfWTAscraD+ddxFoq/X9drq6UURcxEWTxrz61mjLleAxUf0QkaK+xCccQ
         MPzrSTsG1/ofjGewpxiukjn2OLo2Q4Afp299SnECcjmIogzMUxGFIMCdoD5iAGiVRv7T
         e9mFmcfdlDAg+8C76GPi4bepLtac7HlPuxu61UEQgwUX0/E/qRDmp3fwLs/Py8o0ljP3
         SYumr5V+sYaQKg9o/WtxffFemFk/TRBglUcbFXJ78qwtX9mNGjSigzbfOvuxXY6t1Iwt
         CNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746039516; x=1746644316;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fxPskNZofSZePK1/+4gGlwKg7DgccpEf2CnNOiWW54=;
        b=HULGfOlabq3aydxhTC4sHx39+bJmSCuYhi04sPvfkhp6Ki+2v28NHXn+61Cb+tiVZp
         y1ZMfa1g/DrugCkDm9NujGPxsRuARamP1YZFIWBmu1BsxbEY4HFdDX5FBvDesHUO6/Fb
         c2WyygAJ1MdrzJYwPdFY7ZV5Dg892m75DD3OrFOmhqTQlVLGlkNoeT3tcTBKUVbEumCW
         gdxEMyEK89yUzzOcfy8jUjTdIEIxrgYKit7pq4ExJ96y+AI+AvBZgjnUZTZkQQH0myVG
         a0jypDByyYhcpqwOr7EuyEzTaPyuY9jE1ripPKwhOTcFT0t9PPMx1B/fZfCXSGETAZQZ
         JErQ==
X-Gm-Message-State: AOJu0YwzvaGojXP2RIzUsMNBaqBAA24tfG9Q7p66sLz8TQyCJ6Y6L5er
	+bi2S2jMTx7ZZ7nPcVxitiDcqbUagzJXR+zcgVqP4la8IkSscZyBVXBrTWX8kzfE5w5MUoPYmPl
	BAKeWwG5oMavA0SoZsIUVqg==
X-Google-Smtp-Source: AGHT+IHodHWuK0AUHmI1CfG6FAG4mDv2udQakmxdt0HnbC2aAg1MwCYAsZE64s6Z76O6H15e9JHN6nTHctRoqbalpQ==
X-Received: from plch19.prod.google.com ([2002:a17:902:f2d3:b0:227:e538:4d17])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:910:b0:223:432b:593d with SMTP id d9443c01a7336-22df3576684mr62110065ad.42.1746039516391;
 Wed, 30 Apr 2025 11:58:36 -0700 (PDT)
Date: Wed, 30 Apr 2025 11:58:35 -0700
In-Reply-To: <20250430165655.605595-7-tabba@google.com> (message from Fuad
 Tabba on Wed, 30 Apr 2025 17:56:48 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
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
	pankaj.gupta@amd.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Until now, faults to private memory backed by guest_memfd are always
> consumed from guest_memfd whereas faults to shared memory are consumed
> from anonymous memory. Subsequent patches will allow sharing guest_memfd
> backed memory in-place, and mapping it by the host. Faults to in-place
> shared memory should be consumed from guest_memfd as well.
>
> In order to facilitate that, generalize the fault lookups. Currently,
> only private memory is consumed from guest_memfd and therefore as it
> stands, this patch does not change the behavior.
>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 19 +++++++++----------
>  include/linux/kvm_host.h |  6 ++++++
>  2 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d5dd869c890..08eebd24a0e1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3258,7 +3258,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>
>  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  				       const struct kvm_memory_slot *slot,
> -				       gfn_t gfn, int max_level, bool is_private)
> +				       gfn_t gfn, int max_level, bool is_gmem)
>  {
>  	struct kvm_lpage_info *linfo;
>  	int host_level;
> @@ -3270,7 +3270,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			break;
>  	}
>
> -	if (is_private)
> +	if (is_gmem)
>  		return max_level;

I think this renaming isn't quite accurate.

IIUC in __kvm_mmu_max_mapping_level(), we skip considering
host_pfn_mapping_level() if the gfn is private because private memory
will not be mapped to userspace, so there's no need to query userspace
page tables in host_pfn_mapping_level().

Renaming is_private to is_gmem in this function implies that as long as
gmem is used, especially for shared pages from gmem, lpage_info will
always be updated and there's no need to query userspace page tables.

>
>  	if (max_level == PG_LEVEL_4K)
> @@ -3283,10 +3283,9 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	bool is_private = kvm_slot_has_gmem(slot) &&
> -			  kvm_mem_is_private(kvm, gfn);
> +	bool is_gmem = kvm_slot_has_gmem(slot) && kvm_mem_from_gmem(kvm, gfn);

This renaming should probably be undone too.

>
> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> +	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_gmem);
>  }
>
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> @@ -4465,7 +4464,7 @@ static inline u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +static u8 kvm_max_gmem_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>  					u8 max_level, int gmem_order)
>  {
>  	u8 req_max_level;
> @@ -4491,7 +4490,7 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>  				 r == RET_PF_RETRY, fault->map_writable);
>  }
>
> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>  				       struct kvm_page_fault *fault)
>  {
>  	int max_order, r;
> @@ -4509,8 +4508,8 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  	}
>
>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
> -							 fault->max_level, max_order);
> +	fault->max_level = kvm_max_gmem_mapping_level(vcpu->kvm, fault->pfn,
> +						      fault->max_level, max_order);
>
>  	return RET_PF_CONTINUE;
>  }
> @@ -4521,7 +4520,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>  	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>
>  	if (fault->is_private)
> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>
>  	foll |= FOLL_NOWAIT;
>  	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d9616ee6acc7..cdcd7ac091b5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2514,6 +2514,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>
> +static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
> +{
> +	/* For now, only private memory gets consumed from guest_memfd. */
> +	return kvm_mem_is_private(kvm, gfn);
> +}

Can I understand this function as "should fault from gmem"? And hence
also "was faulted from gmem"?

After this entire patch series, for arm64, KVM will always service stage
2 faults from gmem.

Perhaps this function should retain your suggested name of
kvm_mem_from_gmem() but only depend on
kvm_arch_gmem_supports_shared_mem(), since this patch series doesn't
update the MMU in X86. So something like this,

+static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
+{
+	return kvm_arch_gmem_supports_shared_mem(kvm);
+}

with the only usage in arm64.

When the MMU code for X86 is updated, we could then update the above
with 

static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
{
-	return kvm_arch_gmem_supports_shared_mem(kvm);
+	return kvm_arch_gmem_supports_shared_mem(kvm) ||
+              kvm_gmem_should_always_use_gmem(gfn_to_memslot(kvm, gfn)->gmem.file) ||
+              kvm_mem_is_private(kvm, gfn);
}

where kvm_gmem_should_always_use_gmem() will read a guest_memfd flag? 

> +
>  #ifdef CONFIG_KVM_GMEM
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,

