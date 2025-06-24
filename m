Return-Path: <kvm+bounces-50591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AACE1AE735D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AD0217FE9C
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7DB26B2A1;
	Tue, 24 Jun 2025 23:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ViAxVyTp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014A425B30E
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 23:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750808422; cv=none; b=RSXWzqGWQVarr9WciCrpv8OehAATpqvwsUTWMUhPaPVHjJWHj6Xcl+Q0dPAnZJMkbNWLSO5uDWHG2cAXZJzlNgyDrid5Gnij9FgU4223js/AcoH0s1wZ4zvZTbeaOILQBNB8dN1Eqxn/S5PHXzWhm81I4ItdboBPt2wBcSBqvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750808422; c=relaxed/simple;
	bh=LIdhiyJGm7RTUcB4viLUYQSJXjLC+R/ykcyrk54oCoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p8s0L4Q5cmHfjuvH1Bph+zu33A/Xs3S/AZH45yN5mTxW8KQyln4gD1/jYN48k1fZfGG04tNCWWQ1RspFodI1Rb01yVZ0KHNHWaMmNJXz2mcUduo72lKCYWyy4egIId9ZBJmX6zCAMjh2E6++bS5eDIh17E3byT2sfxGcezIYnTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ViAxVyTp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c36951518so1223728a12.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750808420; x=1751413220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtBKhjYCaIRhlGRFPITFm9XwgDffPGPWmrBo0vWLUKo=;
        b=ViAxVyTp0LVga7Sf78A7UWMIxX0dKWBZZVbJvb5zA2nF4ijVUULjWEbV++Sw9qSCsy
         T2DGuiPKI4xVDzxnyaORFiPN9e4nQud4ebt+2pKj6Ob8LST45Ngrpr5DRjjI663HiJo6
         lQ2xfei3ZJMzmNUy2WfiYhzBLTtoRIHc4wjRdZ4sCQFyLTCmDwgbZ23mVl6XPA3Kg5Pi
         KehOux9cFPt/KviQH9BNuSI/Z7Ba9TiTIP4DrfrZ2ahbWx2bKTt6a+HTfxCaIAembP8A
         iJyzff+K8+T2XJq0x0tDlGV1GEiQlbXeHgHqmIVY092c/3jiRWItfymwbV/LWtn1GjwS
         IJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750808420; x=1751413220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wtBKhjYCaIRhlGRFPITFm9XwgDffPGPWmrBo0vWLUKo=;
        b=ia3pOsbQu+Mo94bx3Plen1R0xEoUkoUSh3XD4pOaQSHxp0IhqknHS8HtuuVkGQ5KXw
         ZGHFbE5Dy3eco6S8xaOh/4UTmZc9rgg9VhC1JwKHnCsUaCscyOtLHTfi+41HmSmRxWr3
         QKc/WDA0K7mIL1lzA7ySr0QZwSPSx4VMSJFLqivwHmnJtt7HloeYIvbo0XWcUJglLSYI
         v+4cIaMi9dw5QLujba3PpHpHFHYNJMRu3PJp/3/TvItlRfqU/NUEnxhQTJAvx++AFUZk
         vafFaFsg1m9aVM07DI9N5TGcz7phbd3uJ0+WrkP0AN/Un/51wwqbnrrXsHi5qTJC/qhB
         nD/w==
X-Gm-Message-State: AOJu0YwC13IESSUwvdNI+/WMoS+Rq+MhyUmuPG4AN09Wj83iNZL6m6io
	4xYd4aKRfS0DCcA2bfkYoTQ8xz5DbszaUhHxeL2YJTeK9Nqh53Tp1O1kwRlHOX9/UZ3+Jlz4Zr9
	xI6iTaJlFQ6iAnhuNoxvsawrWFQ==
X-Google-Smtp-Source: AGHT+IHgSUmIGUTP1cRXfKE/+aw5IRkLF9VVq5UcZdV1pOiUg7sF4uqUMGUdcbKxDyQplXXCwSktIYqGZpB8BdsqFQ==
X-Received: from pfux8.prod.google.com ([2002:a05:6a00:bc8:b0:746:1a7b:a39a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2588:b0:1f5:717b:46dc with SMTP id adf61e73a8af0-2207f25dd7amr1308677637.27.1750808420299;
 Tue, 24 Jun 2025 16:40:20 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:40:18 -0700
In-Reply-To: <aEyhHgwQXW4zbx-k@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com>
Message-ID: <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
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
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 11, 2025, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> For memslots backed by guest_memfd with shared mem support, the KVM MMU
>> must always fault in pages from guest_memfd, and not from the host
>> userspace_addr. Update the fault handler to do so.
>
> And with a KVM_MEMSLOT_GUEST_MEMFD_ONLY flag, this becomes super obvious.
>
>> This patch also refactors related function names for accuracy:
>
> This patch.  And phrase changelogs as commands.
>
>> kvm_mem_is_private() returns true only when the current private/shared
>> state (in the CoCo sense) of the memory is private, and returns false if
>> the current state is shared explicitly or impicitly, e.g., belongs to a
>> non-CoCo VM.
>
> Again, state changes as commands.  For the above, it's not obvious if you're
> talking about the existing code versus the state of things after "this patch".
>
>

Will fix these, thanks!

>> kvm_mmu_faultin_pfn_gmem() is updated to indicate that it can be used to
>> fault in not just private memory, but more generally, from guest_memfd.
>
>> +static inline u8 kvm_max_level_for_order(int order)
>
> Do not use "inline" for functions that are visible only to the local compilation
> unit.  "inline" is just a hint, and modern compilers are smart enough to inline
> functions when appropriate without a hint.
>
> A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com
>

Will fix this!

>> +static inline int kvm_gmem_max_mapping_level(const struct kvm_memory_slot *slot,
>> +					     gfn_t gfn, int max_level)
>> +{
>> +	int max_order;
>>  
>>  	if (max_level == PG_LEVEL_4K)
>>  		return PG_LEVEL_4K;
>
> This is dead code, the one and only caller has *just* checked for this condition.
>>  
>> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
>> -	return min(host_level, max_level);
>> +	max_order = kvm_gmem_mapping_order(slot, gfn);
>> +	return min(max_level, kvm_max_level_for_order(max_order));
>>  }
>
> ...
>
>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>> -					u8 max_level, int gmem_order)
>> +static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
>
> This is comically verbose.  C ain't Java.  And having two separate helpers makes
> it *really* hard to (a) even see there are TWO helpers in the first place, and
> (b) understand how they differ.
>
> Gah, and not your bug, but completely ignoring the RMP in kvm_mmu_max_mapping_level()
> is wrong.  It "works" because guest_memfd doesn't (yet) support dirty logging,
> no one enables the NX hugepage mitigation on AMD hosts.
>
> We could plumb in the pfn and private info, but I don't really see the point,
> at least not at this time.
>
>> +					    struct kvm_page_fault *fault,
>> +					    int order)
>>  {
>> -	u8 req_max_level;
>> +	u8 max_level = fault->max_level;
>>  
>>  	if (max_level == PG_LEVEL_4K)
>>  		return PG_LEVEL_4K;
>>  
>> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>> +	max_level = min(kvm_max_level_for_order(order), max_level);
>>  	if (max_level == PG_LEVEL_4K)
>>  		return PG_LEVEL_4K;
>>  
>> -	req_max_level = kvm_x86_call(private_max_mapping_level)(kvm, pfn);
>> -	if (req_max_level)
>> -		max_level = min(max_level, req_max_level);
>> +	if (fault->is_private) {
>> +		u8 level = kvm_x86_call(private_max_mapping_level)(kvm, fault->pfn);
>
> Hmm, so the interesting thing here is that (IIRC) the RMP restrictions aren't
> just on the private pages, they also apply to the HYPERVISOR/SHARED pages.  (Don't
> quote me on that).
>
> Regardless, I'm leaning toward dropping the "private" part, and making SNP deal
> with the intricacies of the RMP:
>
> 	/* Some VM types have additional restrictions, e.g. SNP's RMP. */
> 	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
> 	if (req_max_level)
> 		max_level = min(max_level, req_max_level);
>
> Then we can get to something like:
>
> static int kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
> 				      struct kvm_page_fault *fault)
> {
> 	int max_level, req_max_level;
>
> 	max_level = kvm_max_level_for_order(order);
> 	if (max_level == PG_LEVEL_4K)
> 		return PG_LEVEL_4K;
>
> 	req_max_level = kvm_x86_call(max_mapping_level)(kvm, fault);
> 	if (req_max_level)
> 		max_level = min(max_level, req_max_level);
>
> 	return max_level;
> }
>
> int kvm_mmu_max_mapping_level(struct kvm *kvm,
> 			      const struct kvm_memory_slot *slot, gfn_t gfn)
> {
> 	int max_level;
>
> 	max_level = kvm_lpage_info_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM);
> 	if (max_level == PG_LEVEL_4K)
> 		return PG_LEVEL_4K;
>
> 	/* TODO: Comment goes here about KVM not supporting this path (yet). */

Which path does KVM not support?

> 	if (kvm_mem_is_private(kvm, gfn))
> 		return PG_LEVEL_4K;
>

Just making sure - this suggestion does take into account that
kvm_mem_is_private() will be querying guest_memfd for memory privacy
status, right? So the check below for kvm_is_memslot_gmem_only() will
only be handling the cases where the memory is shared, and only
guest_memfd is used for this gfn?

> 	if (kvm_is_memslot_gmem_only(slot)) {
> 		int order = kvm_gmem_mapping_order(slot, gfn);
>
> 		return min(max_level, kvm_gmem_max_mapping_level(kvm, order, NULL));
> 	}
>
> 	return min(max_level, host_pfn_mapping_level(kvm, gfn, slot));
> }
>
> static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> 				    struct kvm_page_fault *fault)
> {
> 	struct kvm *kvm = vcpu->kvm;
> 	int order, r;
>
> 	if (!kvm_slot_has_gmem(fault->slot)) {
> 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 		return -EFAULT;
> 	}
>
> 	r = kvm_gmem_get_pfn(kvm, fault->slot, fault->gfn, &fault->pfn,
> 			     &fault->refcounted_page, &order);
> 	if (r) {
> 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> 		return r;
> 	}
>
> 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> 	fault->max_level = kvm_gmem_max_mapping_level(kvm, order, fault);
>
> 	return RET_PF_CONTINUE;
> }
>
> int sev_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault)
> {
> 	int level, rc;
> 	bool assigned;
>
> 	if (!sev_snp_guest(kvm))
> 		return 0;
>
> 	if (WARN_ON_ONCE(!fault) || !fault->is_private)
> 		return 0;
>
> 	rc = snp_lookup_rmpentry(fault->pfn, &assigned, &level);
> 	if (rc || !assigned)
> 		return PG_LEVEL_4K;
>
> 	return level;
> }

I like this. Thanks for the suggestion, I'll pass Fuad some patch(es)
for v13.

>> +/*
>> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
>> + * private.
>> + *
>> + * A return value of false indicates that the gfn is explicitly or implicitly
>> + * shared (i.e., non-CoCo VMs).
>> + */
>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>  {
>> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
>> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>> +	struct kvm_memory_slot *slot;
>> +
>> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
>> +		return false;
>> +
>> +	slot = gfn_to_memslot(kvm, gfn);
>> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
>> +		/*
>> +		 * Without in-place conversion support, if a guest_memfd memslot
>> +		 * supports shared memory, then all the slot's memory is
>> +		 * considered not private, i.e., implicitly shared.
>> +		 */
>> +		return false;
>
> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
> mappable guest_memfd.  You need to do that no matter what. 

Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
out. Where do people think we should check the mutual exclusivity?

In kvm_supported_mem_attributes() I'm thiking that we should still allow
the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
gfn ranges. Or do people think we should just disallow
KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot is
a guest_memfd-only memslot?

If we check mutually exclusivity when handling
kvm_vm_set_memory_attributes(), as long as part of the range where
KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
whose slot is guest_memfd-only, the ioctl will return EINVAL.

> Then you don't need
> to sprinkle special case code all over the place.
>

That's true, thanks.

I guess the special-casing will come back when guest_memfd supports
conversions (and stores shareability). After guest_memfd supports
conversions, if guest_memfd-only memslot, check with guest_memfd. Else,
look up memory attributes with kvm_get_memory_attributes().

>> +	}
>> +
>> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>  }
>>  #else
>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>> -- 
>> 2.50.0.rc0.642.g800a2b2222-goog
>> 





























