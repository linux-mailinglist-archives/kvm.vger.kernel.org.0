Return-Path: <kvm+bounces-49536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A8DAD980E
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EAF516A524
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E15828DB4F;
	Fri, 13 Jun 2025 22:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w/zGhW61"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060AA244676
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749852523; cv=none; b=TlBTRtT/vpR2zu7iBkgSXw0hakElcZ6ZQZ8nw8DkkF5phE0ctTN1U1urc5S89d472rNSy5V5hqRWDVyO4690U87EJO9jmSpk1y9wvAGfUxT31bjh1YVjdc7Ma28oOCe7UVc5ufG+61Gsb3m3gCk3/PaLcyejcWtQsIupcY0apfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749852523; c=relaxed/simple;
	bh=fkr4HJOJpy9exfwJGhkn9TQt7LDzat+z9jZTC9JW58k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aF9sKTFwWF2m4EFsrZUt8HMTAknVSxkRwUjBmDAfUfh3iat1UDHqshsVpWWsKHpEHZWbORXA1VncMvXba2TvxBwBGJQU7M1B4PdG+9Uq+iPr6jcJ/SL01vVDSRroQ4JcLXNNs74Hi54ZbVsvVda/ESiGcLTE7+ybiu2ks6bQWyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w/zGhW61; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eeff19115so3167038a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749852521; x=1750457321; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wb4jmnBC8sBuVz3+2UsGpTIRs7ejQyw5kumAZcoTVsA=;
        b=w/zGhW612IneXYWqSauec6dm1JkmppkTq+tvPkjqI1dabh6Qj1kWY7NvngMmdTpvp1
         KJ3ZI9816d8frQBROoTx2twtKLYGTSuvq6SjjMmZVUpn3izLquME2UtKHqvcGX32vaf3
         Oe6x1PtWuXl77OmCU/1hFFOiWE5YyqEd3w4iSgAX9txMgxlXMUn8G4u794akQcguX2xA
         +VOJLbp24eMr0T8zS2Csmnbe4Iyybkc6QNQfR4YeWCFbeLDOpBb9w5SIFxUcKu9kt0W8
         ZJH4t92OR/wjR1Q71U3tReyjYqXVS1ceovZIsz7CstqzilKPw5xyDFrAn06bUV1aGNEE
         /szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749852521; x=1750457321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wb4jmnBC8sBuVz3+2UsGpTIRs7ejQyw5kumAZcoTVsA=;
        b=k1FRIxGYVlI1Sm+hETfj8wh0SyvOLVXx5vKlAUuup68rQPx+5tPhbDkTSbOC2u33Qd
         Q6A8W05In4T3FJj0FUaFAo9315aGUNlyB7tg6IDNqqQDkczVCYsW+LXsqYmgzeT7wKs1
         6XSKxw8Oj1MVrIXJs5Ha7Cd072VyjJB3mNPzUOaHcphe4D9M3S8iGvJp1aPy7vbnV+FP
         osUIAy5SAuoxKjEnBoj2bomfoZesOnWkmye54Ff2JPUzM2/NvBbnAZrtKvUUE18D5Iwc
         lEWezJZB5ANpxa+XvdxEhrhTkWQ5dLz2r3lhMFWsxhQGDOsZEoCLtZ76TZ7PLxVeuam/
         CL0A==
X-Gm-Message-State: AOJu0YyxuaoIbvg99+4ZkAB62Foh9Q8qhEnf+c9252YpzPBPhOlMHV3O
	W2tPdfIJcIO4cPBwUTOLT2fSv99AcCHrcGE0wbqKeTrNirDu1RZhMjTLmqboUVO3cgkHW/rj/65
	ICJlZPw==
X-Google-Smtp-Source: AGHT+IGdSPExuUA1/ibuJO19NsPM4/rKLVlAf2LsB0b+mN/T6vNzkkutRovkAexiqJtYBe7+n13vgpVYIl8=
X-Received: from pfm6.prod.google.com ([2002:a05:6a00:726:b0:746:19fc:f077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7316:b0:21f:8817:f695
 with SMTP id adf61e73a8af0-21fbd5590a9mr1355927637.25.1749852521334; Fri, 13
 Jun 2025 15:08:41 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:08:39 -0700
In-Reply-To: <20250611133330.1514028-11-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
Message-ID: <aEyhHgwQXW4zbx-k@google.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 11, 2025, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> For memslots backed by guest_memfd with shared mem support, the KVM MMU
> must always fault in pages from guest_memfd, and not from the host
> userspace_addr. Update the fault handler to do so.

And with a KVM_MEMSLOT_GUEST_MEMFD_ONLY flag, this becomes super obvious.

> This patch also refactors related function names for accuracy:

This patch.  And phrase changelogs as commands.

> kvm_mem_is_private() returns true only when the current private/shared
> state (in the CoCo sense) of the memory is private, and returns false if
> the current state is shared explicitly or impicitly, e.g., belongs to a
> non-CoCo VM.

Again, state changes as commands.  For the above, it's not obvious if you're
talking about the existing code versus the state of things after "this patch".


> kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used to
> fault in not just private memory, but more generally, from guest_memfd.

> +static inline u8 kvm_max_level_for_order(int order)

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

> +static inline int kvm_gmem_max_mapping_level(const struct kvm_memory_slot *slot,
> +					     gfn_t gfn, int max_level)
> +{
> +	int max_order;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;

This is dead code, the one and only caller has *just* checked for this condition.
>  
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> -	return min(host_level, max_level);
> +	max_order = kvm_gmem_mapping_order(slot, gfn);
> +	return min(max_level, kvm_max_level_for_order(max_order));
>  }

...

> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,

This is comically verbose.  C ain't Java.  And having two separate helpers makes
it *really* hard to (a) even see there are TWO helpers in the first place, and
(b) understand how they differ.

Gah, and not your bug, but completely ignoring the RMP in kvm_mmu_max_mapping_level()
is wrong.  It "works" because guest_memfd doesn't (yet) support dirty logging,
no one enables the NX hugepage mitigation on AMD hosts.

We could plumb in the pfn and private info, but I don't really see the point,
at least not at this time.

> +					    struct kvm_page_fault *fault,
> +					    int order)
>  {
> -	u8 req_max_level;
> +	u8 max_level = fault->max_level;
>  
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	max_level = min(kvm_max_level_for_order(order), max_level);
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +	if (fault->is_private) {
> +		u8 level = kvm_x86_call(private_max_mapping_level)(kvm, fault->pfn);

Hmm, so the interesting thing here is that (IIRC) the RMP restrictions aren't
just on the private pages, they also apply to the HYPERVISOR/SHARED pages.  (Don't
quote me on that).

Regardless, I'm leaning toward dropping the "private" part, and making SNP deal
with the intricacies of the RMP:

	/* Some VM types have additional restrictions, e.g. SNP's RMP. */
	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

Then we can get to something like:

static int kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
				      struct kvm_page_fault *fault)
{
	int max_level, req_max_level;

	max_level = kvm_max_level_for_order(order);
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

	return max_level;
}

int kvm_mmu_max_mapping_level(struct kvm *kvm,
			      const struct kvm_memory_slot *slot, gfn_t gfn)
{
	int max_level;

	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
	if (max_level == PG_LEVEL_4K)
		return PG_LEVEL_4K;

	/* TODO: Comment goes here about KVM not supporting this path (yet). */
	if (kvm_mem_is_private(kvm, gfn))
		return PG_LEVEL_4K;

	if (kvm_is_memslot_gmem_only(slot)) {
		int order = kvm_gmem_mapping_order(slot, gfn);

		return min(max_level, kvm_gmem_max_mapping_level(kvm, order, NULL));
	}

	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
}

static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
				    struct kvm_page_fault *fault)
{
	struct kvm *kvm = vcpu->kvm;
	int order, r;

	if (!kvm_slot_has_gmem(fault->slot)) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return -EFAULT;
	}

	r = kvm_gmem_get_pfn(kvm, fault->slot, fault->gfn, &fault->pfn,
			     &fault->refcounted_page, &order);
	if (r) {
		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
		return r;
	}

	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
	fault->max_level = kvm_gmem_max_mapping_level(kvm, order, fault);

	return RET_PF_CONTINUE;
}

int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
{
	int level, rc;
	bool assigned;

	if (!sev_snp_guest(kvm))
		return 0;

	if (WARN_ON_ONCE(!fault) || !fault->is_private)
		return 0;

	rc = snp_lookup_rmpentry(fault->pfn, &assigned, &level);
	if (rc || !assigned)
		return PG_LEVEL_4K;

	return level;
}
> +/*
> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
> + * private.
> + *
> + * A return value of false indicates that the gfn is explicitly or implicitly
> + * shared (i.e., non-CoCo VMs).
> + */
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	struct kvm_memory_slot *slot;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
> +		return false;
> +
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
> +		/*
> +		 * Without in-place conversion support, if a guest_memfd memslot
> +		 * supports shared memory, then all the slot's memory is
> +		 * considered not private, i.e., implicitly shared.
> +		 */
> +		return false;

Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
mappable guest_memfd.  You need to do that no matter what.  Then you don't need
to sprinkle special case code all over the place.

> +	}
> +
> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  }
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> -- 
> 2.50.0.rc0.642.g800a2b2222-goog
> 

