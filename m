Return-Path: <kvm+bounces-24864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A93495C438
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 06:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 427A528506A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 04:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D82446AB;
	Fri, 23 Aug 2024 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1Rs73fd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3137A259C;
	Fri, 23 Aug 2024 04:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724387450; cv=none; b=uSYrDw8mx3Vpih0LrdihbtolcoenkIjnYa0VgM5CZFBMSyS/qRYkcaE5uNKIgTacqKCJX/4nrTHTpPeROtqZWYtltxu++3aGL+mTx7C2U8UZCgaRu1aYJCBBUSiEVSskGtwodPCpPk/ohbGMkWnaUd4VSWXuLOMIaZOfCDZptrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724387450; c=relaxed/simple;
	bh=nq+M6koVXgKtdGqZpO/26KqtCn0/nlKteLdQ3/OHu2k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rBo9RcWtOU1Etr5C1SSDWKeYuEA5Jku9y0lfHH6WCXO8S8wYZ71LkJWJBYk2W8ZL5hSc/20bbqZkX/twmoNj+/pYZPixWGQwqOJ+vtwA0sQiq2MqpX36jJu4FCzeV/747F3nHowEjna+sBHYcK1MtAo0ySdgMdbbq+r3Pnkrhcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1Rs73fd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21B9C32786;
	Fri, 23 Aug 2024 04:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724387449;
	bh=nq+M6koVXgKtdGqZpO/26KqtCn0/nlKteLdQ3/OHu2k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=m1Rs73fd3fFvem1Gacqg1IBqpKU+TJBCkK4on+Hy/p0NKfW0Vuw54XiC2jrR650Dt
	 EutOjSiTQoSZReEmcAAAPYFYPHA0X7cwjEdTofIoWO/fRkhcafqzsGjDJopWvo7bIc
	 9S8cHddHdvMajCwjSyg2KjITsQGEdc+PUOxewW7vsLUr6G2PqiW5pORsVXDe60ZEnR
	 hgCimAt8cqTs1Et1ovC8fA6U80Bc3/7UWTtPV/3fV9oepoAviWVwWnHPtFTqpAfoCe
	 lyE1tEat0meji36b+bPPmDF+3AwzFogB0tKXQAyj3EO2doE4XA85f3XAl2Kai+ZXoM
	 436h255HqkJKA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <80e2dc67-9dca-4e90-8a42-21ddea329c53@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-22-steven.price@arm.com>
 <yq5acym12p3c.fsf@kernel.org>
 <80e2dc67-9dca-4e90-8a42-21ddea329c53@arm.com>
Date: Fri, 23 Aug 2024 10:00:37 +0530
Message-ID: <yq5azfp3274i.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> On 22/08/2024 04:50, Aneesh Kumar K.V wrote:
>> Steven Price <steven.price@arm.com> writes:
>>
>>> At runtime if the realm guest accesses memory which hasn't yet been
>>> mapped then KVM needs to either populate the region or fault the guest.
>>>
>>> For memory in the lower (protected) region of IPA a fresh page is
>>> provided to the RMM which will zero the contents. For memory in the
>>> upper (shared) region of IPA, the memory from the memslot is mapped
>>> into the realm VM non secure.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v2:
>>>  * Avoid leaking memory if failing to map it in the realm.
>>>  * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>>  * Adapt to changes in previous patches.
>>> ---
>>>  arch/arm64/include/asm/kvm_emulate.h |  10 ++
>>>  arch/arm64/include/asm/kvm_rme.h     |  10 ++
>>>  arch/arm64/kvm/mmu.c                 | 120 +++++++++++++++-
>>>  arch/arm64/kvm/rme.c                 | 205 +++++++++++++++++++++++++--
>>>  4 files changed, 325 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>> index 7430c77574e3..0b50572d3719 100644
>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>> @@ -710,6 +710,16 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>>>  	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>>>  }
>>>
>>> +static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
>>> +{
>>> +	if (kvm_is_realm(kvm)) {
>>> +		struct realm *realm = &kvm->arch.realm;
>>> +
>>> +		return BIT(realm->ia_bits - 1);
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>>>  {
>>>  	if (static_branch_unlikely(&kvm_rme_is_available))
>>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
>>> index 0e44b20cfa48..c50854f44674 100644
>>> --- a/arch/arm64/include/asm/kvm_rme.h
>>> +++ b/arch/arm64/include/asm/kvm_rme.h
>>> @@ -103,6 +103,16 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>>  			   unsigned long ipa,
>>>  			   u64 size,
>>>  			   bool unmap_private);
>>> +int realm_map_protected(struct realm *realm,
>>> +			unsigned long base_ipa,
>>> +			struct page *dst_page,
>>> +			unsigned long map_size,
>>> +			struct kvm_mmu_memory_cache *memcache);
>>> +int realm_map_non_secure(struct realm *realm,
>>> +			 unsigned long ipa,
>>> +			 struct page *page,
>>> +			 unsigned long map_size,
>>> +			 struct kvm_mmu_memory_cache *memcache);
>>>  int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>>>  			unsigned long addr, unsigned long end,
>>>  			unsigned long ripas,
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 620d26810019..eb8b8d013f3e 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -325,8 +325,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>>>
>>>  	lockdep_assert_held_write(&kvm->mmu_lock);
>>>  	WARN_ON(size & ~PAGE_MASK);
>>> -	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
>>> -				   may_block));
>>> +
>>> +	if (kvm_is_realm(kvm))
>>> +		kvm_realm_unmap_range(kvm, start, size, !only_shared);
>>> +	else
>>> +		WARN_ON(stage2_apply_range(mmu, start, end,
>>> +					   kvm_pgtable_stage2_unmap,
>>> +					   may_block));
>>>  }
>>>
>>>  void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
>>> @@ -345,7 +350,10 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>>>
>>> -	kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>> +	if (kvm_is_realm(kvm))
>>> +		kvm_realm_unmap_range(kvm, addr, end - addr, false);
>>> +	else
>>> +		kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>>  }
>>>
>>>  /**
>>> @@ -1037,6 +1045,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>>  	struct kvm_memory_slot *memslot;
>>>  	int idx, bkt;
>>>
>>> +	/* For realms this is handled by the RMM so nothing to do here */
>>> +	if (kvm_is_realm(kvm))
>>> +		return;
>>> +
>>>  	idx = srcu_read_lock(&kvm->srcu);
>>>  	mmap_read_lock(current->mm);
>>>  	write_lock(&kvm->mmu_lock);
>>> @@ -1062,6 +1074,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>  	if (kvm_is_realm(kvm) &&
>>>  	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>>  	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>>> +		kvm_stage2_unmap_range(mmu, 0, (~0ULL) & PAGE_MASK);
>>>  		write_unlock(&kvm->mmu_lock);
>>>  		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>>>  		return;
>>> @@ -1428,6 +1441,71 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>>>  	return vma->vm_flags & VM_MTE_ALLOWED;
>>>  }
>>>
>>> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>>> +			 kvm_pfn_t pfn, unsigned long map_size,
>>> +			 enum kvm_pgtable_prot prot,
>>> +			 struct kvm_mmu_memory_cache *memcache)
>>> +{
>>> +	struct realm *realm = &kvm->arch.realm;
>>> +	struct page *page = pfn_to_page(pfn);
>>> +
>>> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>>> +		return -EFAULT;
>>> +
>>> +	if (!realm_is_addr_protected(realm, ipa))
>>> +		return realm_map_non_secure(realm, ipa, page, map_size,
>>> +					    memcache);
>>> +
>>> +	return realm_map_protected(realm, ipa, page, map_size, memcache);
>>> +}
>>> +
>>> +static int private_memslot_fault(struct kvm_vcpu *vcpu,
>>> +				 phys_addr_t fault_ipa,
>>> +				 struct kvm_memory_slot *memslot)
>>> +{
>>> +	struct kvm *kvm = vcpu->kvm;
>>> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
>>> +	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>>> +	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
>>> +	bool priv_exists = kvm_mem_is_private(kvm, gfn);
>>> +	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>>> +	kvm_pfn_t pfn;
>>> +	int ret;
>>> +
>>> +	if (priv_exists != is_priv_gfn) {
>>> +		kvm_prepare_memory_fault_exit(vcpu,
>>> +					      fault_ipa & ~gpa_stolen_mask,
>>> +					      PAGE_SIZE,
>>> +					      kvm_is_write_fault(vcpu),
>>> +					      false, is_priv_gfn);
>>> +
>>> +		return 0;
>>> +	}
>>> +
>>> +	if (!is_priv_gfn) {
>>> +		/* Not a private mapping, handling normally */
>>> +		return -EAGAIN;
>>> +	}
>>>
>>
>> Instead of that EAGAIN, it better to handle as below?
>
> I'm not finding the below easier to read.
>
>>  arch/arm64/kvm/mmu.c | 24 ++++++++++++++++--------
>>  1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 1eddbc7d7156..33ef95b5c94a 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1480,11 +1480,6 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
>>  		return 0;
>>  	}
>>
>> -	if (!is_priv_gfn) {
>> -		/* Not a private mapping, handling normally */
>> -		return -EAGAIN;
>> -	}
>> -
>>  	ret = kvm_mmu_topup_memory_cache(memcache,
>>  					 kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>>  	if (ret)
>> @@ -1925,12 +1920,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>>
>> -	if (kvm_slot_can_be_private(memslot)) {
>> -		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
>> -		if (ret != -EAGAIN)
>> +	if (kvm_slot_can_be_private(memslot) &&
>> +	    kvm_is_private_gpa(vcpu->kvm, ipa)) {
>
> I presume kvm_is_private_gpa() is defined as something like:
>
> static bool kvm_is_private_gpa(kvm, phys_addr_t ipa)
> {
> 	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
> 	return  !((ipa & gpa_stolen_mask) == gpa_stolen_mask);
> }
>
>> +		ret = private_memslot_fault(vcpu, ipa, memslot);
>
> So this handles the case in private_memslot_fault() where is_priv_gfn is
> true. So there's a little bit of simplification in
> private_memslot_fault().
>
>>  			goto out;
>>  	}
>> +	/* attribute msimatch. shared access fault on a mem with private attribute */
>> +	if (kvm_mem_is_private(vcpu->kvm, gfn)) {
>> +		/* let VMM fixup the memory attribute */
>> +		kvm_prepare_memory_fault_exit(vcpu,
>> +					      kvm_gpa_from_fault(vcpu->kvm, ipa),
>> +					      PAGE_SIZE,
>> +					      kvm_is_write_fault(vcpu),
>> +					      false, false);
>
> And then we have to duplicate the code here for calling
> kvm_prepare_memory_fault_exit(). Which seems a bit ugly to me. Am I
> missing something? Your patch doesn't seem complete.
>


What confused me was I was looking at EAGAIN as retry access. But here
it is not a retry. It is an error condition for handling the fault as a
shared access fault. IMHO having that check in the caller makes it
simpler. ie,

if it is a private fault private_memslot_fault handle it with the fault
exit condition that indicates an attribute mismatch

if it is a shared fault the existing fault handling code handles it with
the fault exit condition indicating an attribute mismatch.

If you find the change not clean, can we rename the error to EINVAL?

>
>> +
>> +		ret =  0;
>> +		goto out;
>> +	}
>>
>> +	/* Slot can be be private, but fault addr is not, handle that as normal fault */
>>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>  	write_fault = kvm_is_write_fault(vcpu);
>>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>
>
> Note your email had a signature line "--" here which causes my email
> client to remove the rest of your reply - it's worth dropping that from
> the git output when sending diffs. I've attempted to include your
> second diff below manually.
>
>> Instead of referring this as stolen bits is it better to do
>>
>>  arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++++++---
>>  arch/arm64/kvm/mmu.c                 | 21 ++++++++-------------
>>  2 files changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 0b50572d3719..790412fd53b8 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -710,14 +710,28 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>>  	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>>  }
>>
>> -static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
>> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t fault_addr)
>>  {
>> +	gpa_t addr_mask;
>> +
>>  	if (kvm_is_realm(kvm)) {
>>  		struct realm *realm = &kvm->arch.realm;
>>
>> -		return BIT(realm->ia_bits - 1);
>> +		addr_mask = BIT(realm->ia_bits - 1);
>> +		/* clear shared bit and return */
>> +		return fault_addr & ~addr_mask;
>>  	}
>> -	return 0;
>> +	return fault_addr;
>> +}
>> +
>> +static inline bool kvm_is_private_gpa(struct kvm *kvm, phys_addr_t fault_addr)
>> +{
>> +	/*
>> +	 * For Realms, the shared address is an alias of the private GPA
>> +	 * with top bit set and we have a single address space. Thus if the
>> +	 * fault address matches the GPA, it is the private GPA
>> +	 */
>> +	return fault_addr == kvm_gpa_from_fault(kvm, fault_addr);
>>  }
>
> Ah, so here's the missing function from above.
>
>>
>>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index eb8b8d013f3e..1eddbc7d7156 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1464,20 +1464,18 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
>>  				 struct kvm_memory_slot *memslot)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
>> -	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>> -	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
>> -	bool priv_exists = kvm_mem_is_private(kvm, gfn);
>> +	gfn_t gfn = kvm_gpa_from_fault(kvm, fault_ipa) >> PAGE_SHIFT;
>>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>>  	kvm_pfn_t pfn;
>>  	int ret;
>>
>> -	if (priv_exists != is_priv_gfn) {
>> +	if (!kvm_mem_is_private(kvm, gfn)) {
>> +		/* let VMM fixup the memory attribute */
>>  		kvm_prepare_memory_fault_exit(vcpu,
>> -					      fault_ipa & ~gpa_stolen_mask,
>> +					      kvm_gpa_from_fault(kvm, fault_ipa),
>>  					      PAGE_SIZE,
>>  					      kvm_is_write_fault(vcpu),
>> -					      false, is_priv_gfn);
>> +					      false, true);
>>
>>  		return 0;
>>  	}
>> @@ -1527,7 +1525,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	long vma_pagesize, fault_granule;
>>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>>  	struct kvm_pgtable *pgt;
>> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>>
>>  	if (fault_is_perm)
>>  		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>> @@ -1640,7 +1637,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>>  		fault_ipa &= ~(vma_pagesize - 1);
>>
>> -	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>>  	mte_allowed = kvm_vma_mte_allowed(vma);
>>
>>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
>> @@ -1835,7 +1832,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  	struct kvm_memory_slot *memslot;
>>  	unsigned long hva;
>>  	bool is_iabt, write_fault, writable;
>> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>>  	gfn_t gfn;
>>  	int ret, idx;
>>
>> @@ -1926,7 +1922,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  		nested = &nested_trans;
>>  	}
>>
>> -	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>> +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>>
>>  	if (kvm_slot_can_be_private(memslot)) {
>> @@ -1978,8 +1974,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  		 * of the page size.
>>  		 */
>>  		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
>> -		ipa &= ~gpa_stolen_mask;
>> -		ret = io_mem_abort(vcpu, ipa);
>> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>>  		goto out_unlock;
>>  	}
>
> I can see your point that kvm_gpa_from_fault() makes sense. I'm still
> not convinced about the duplication of the kvm_prepare_memory_fault_exit()
> call though.
>
> How about the following (untested):
>
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 0b50572d3719..fa03520d7933 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -710,14 +710,14 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>  	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>  }
>
> -static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
> +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t fault_ipa)
>  {
>  	if (kvm_is_realm(kvm)) {
>  		struct realm *realm = &kvm->arch.realm;
>
> -		return BIT(realm->ia_bits - 1);
> +		return fault_ipa & ~BIT(realm->ia_bits - 1);
>  	}
> -	return 0;
> +	return fault_ipa;
>  }
>
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d7e8b0c4f2a3..c0a3054201a9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1468,9 +1468,9 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
>  				 struct kvm_memory_slot *memslot)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(kvm);
> -	gfn_t gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
> -	bool is_priv_gfn = !((fault_ipa & gpa_stolen_mask) == gpa_stolen_mask);
> +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	bool is_priv_gfn = (gpa == fault_ipa);
>  	bool priv_exists = kvm_mem_is_private(kvm, gfn);
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>  	kvm_pfn_t pfn;
> @@ -1478,7 +1478,7 @@ static int private_memslot_fault(struct kvm_vcpu *vcpu,
>
>  	if (priv_exists != is_priv_gfn) {
>

Can we also have a helper with document for this?

static inline bool kvm_is_private_gpa(struct kvm *kvm, phys_addr_t fault_addr)
{
	/*
	 * For Realms, the shared address is an alias of the private GPA
	 * with top bit set and we have a single address space. Thus if the
	 * fault address matches the GPA, it is the private GPA
	 */
	return fault_addr == kvm_gpa_from_fault(kvm, fault_addr);
}


>  		kvm_prepare_memory_fault_exit(vcpu,
> -					      fault_ipa & ~gpa_stolen_mask,
> +					      gpa,
>  					      PAGE_SIZE,
>  					      kvm_is_write_fault(vcpu),
>  					      false, is_priv_gfn);
> @@ -1531,7 +1531,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>
>  	if (fault_is_perm)
>  		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> @@ -1648,7 +1647,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>
> -	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(kvm, ipa) >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>
>  	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> @@ -1843,7 +1842,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	struct kvm_memory_slot *memslot;
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
> -	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  	gfn_t gfn;
>  	int ret, idx;
>
> @@ -1934,7 +1932,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		nested = &nested_trans;
>  	}
>
> -	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
> +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>
>  	if (kvm_slot_can_be_private(memslot)) {
> @@ -1986,8 +1984,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * of the page size.
>  		 */
>  		ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> -		ipa &= ~gpa_stolen_mask;
> -		ret = io_mem_abort(vcpu, ipa);
> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
>  		goto out_unlock;
>  	}
>
>
> Thanks,
> Steve

