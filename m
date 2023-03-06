Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6146ACC58
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 19:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCFSVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 13:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFSV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 13:21:29 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC6164848;
        Mon,  6 Mar 2023 10:20:58 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id f18so14002289lfa.3;
        Mon, 06 Mar 2023 10:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678126856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lK5RGvmDCqRIqfrUYGOYk2Lx6NzzK5dmnQEoPy1tJys=;
        b=e/M0clYEDN3AkPWggOQOOof10QcReTDJ614svbxaKQDTHpYhBo3ZqcDjg2+Y8rzFFd
         avYjA/0PAZMp+kbvCLHcbFnEnTDyhys578VUphy+cwVXLS5TCh7DZFW82Q6oNbNUtRHW
         hOqXD+Y7Rxa+vsdV7gk314/LMdrcUa+TTPfu9I39/cWqAsqbXJaoTEiQl3sqhBbwownt
         qzu3EBO0tamZVHOdSwiB6c1dmFaHCwr7moU18nkHqUvFAM2XMpcvH/Pl86YG4fMuNgoO
         t3ALXgVUVBkWRt+mOfEUsRUCS/TTr2rQipfiw85s9B3twxMu7yHCX3uSQtSU4Z2kZZT6
         Fihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678126856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lK5RGvmDCqRIqfrUYGOYk2Lx6NzzK5dmnQEoPy1tJys=;
        b=PS5PSCoQw3Is9OKednukFVdK7yW+sjwVz7t1kID8rxL/6nQqtEs/YLKCZB5rJs/NKU
         jZhYop1pQOpSB7fq+xKUzvknwgkcpZVUgyTT0tHf07yEXDr4MsdBzOW8R53/dSnWm1O9
         qKlu2U9E2SCUbAfRyyp9vBNx0XFlXapZPOuN6uhT90dYg0qQ3lcaCmpLP1sb3arxnXjQ
         fh0QPgzjBxdpT0XTfPdcLsupvODpqA7w35ev2Rx9VbYrOG+K0VimfxzXexi2MXqP2v41
         t7JUtbYdU2tbvYZH6RCZMB2MrmuZOXdlvEP9hoIbd99ZR03kjoBDVbdFR+NGfuXtM0eQ
         ByVw==
X-Gm-Message-State: AO0yUKWMMNkX+hsT5ck5snCye9e2t2NZC2CgmKbfG2bj+2chL2ooZAX0
        W25Rp7Ag7R3wK/jvatt9Ujw=
X-Google-Smtp-Source: AK7set+8VeDbfle5xoSkxuosj5c9lMVTs5357O0SQzFOCceyACl7n5LIoSsZ24R99NfQo9N4CsFijw==
X-Received: by 2002:ac2:5681:0:b0:4e7:ed3c:68ea with SMTP id 1-20020ac25681000000b004e7ed3c68eamr2410289lfr.5.1678126856366;
        Mon, 06 Mar 2023 10:20:56 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id m17-20020a056512015100b004dc4af9089bsm1724219lfo.231.2023.03.06.10.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 10:20:56 -0800 (PST)
Date:   Mon, 6 Mar 2023 20:20:55 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 17/28] arm64: RME: Runtime faulting of memory
Message-ID: <20230306202055.00000d0b@gmail.com>
In-Reply-To: <20230127112932.38045-18-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-18-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:21 +0000
Steven Price <steven.price@arm.com> wrote:

> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 10 +++++
>  arch/arm64/include/asm/kvm_rme.h     | 12 ++++++
>  arch/arm64/kvm/mmu.c                 | 64 +++++++++++++++++++++++++---
>  arch/arm64/kvm/rme.c                 | 48 +++++++++++++++++++++
>  4 files changed, 128 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 285e62914ca4..3a71b3d2e10a 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -502,6 +502,16 @@ static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>  	return READ_ONCE(kvm->arch.realm.state);
>  }
>  
> +static inline gpa_t kvm_gpa_stolen_bits(struct kvm *kvm)
> +{
> +	if (kvm_is_realm(kvm)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		return BIT(realm->ia_bits - 1);
> +	}
> +	return 0;
> +}
> +

"stolen" seems a little bit vague. Maybe "shared" bit would be better as
SEV-SNP has C bit and TDX has shared bit. It would be nice to align with
the common knowledge.

Also, it would be nice to change the name of gpa_stolen_mask accordingly.

>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
>  	if (static_branch_unlikely(&kvm_rme_is_available))
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 9d1583c44a99..303e4a5e5704 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -50,6 +50,18 @@ void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  int kvm_rec_enter(struct kvm_vcpu *vcpu);
>  int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_status);
>  
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size);
> +int realm_map_protected(struct realm *realm,
> +			unsigned long hva,
> +			unsigned long base_ipa,
> +			struct page *dst_page,
> +			unsigned long map_size,
> +			struct kvm_mmu_memory_cache *memcache);
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache);
>  int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>  			unsigned long addr, unsigned long end,
>  			unsigned long ripas);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f29558c5dcbc..5417c273861b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -235,8 +235,13 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
> -				   may_block));
> +
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, start, size);
> +	else
> +		WARN_ON(stage2_apply_range(kvm, start, end,
> +					   kvm_pgtable_stage2_unmap,
> +					   may_block));
>  }
>  
>  static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
> @@ -250,7 +255,11 @@ static void stage2_flush_memslot(struct kvm *kvm,
>  	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>  	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>  
> -	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_unmap_range(kvm, addr, end - addr);
> +	else
> +		stage2_apply_range_resched(kvm, addr, end,
> +					   kvm_pgtable_stage2_flush);
>  }
>  
>  /**
> @@ -818,6 +827,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	struct kvm_memory_slot *memslot;
>  	int idx, bkt;
>  
> +	/* For realms this is handled by the RMM so nothing to do here */
> +	if (kvm_is_realm(kvm))
> +		return;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	mmap_read_lock(current->mm);
>  	write_lock(&kvm->mmu_lock);
> @@ -840,6 +853,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	pgt = mmu->pgt;
>  	if (kvm_is_realm(kvm) &&
>  	    kvm_realm_state(kvm) != REALM_STATE_DYING) {
> +		unmap_stage2_range(mmu, 0, (~0ULL) & PAGE_MASK);
>  		write_unlock(&kvm->mmu_lock);
>  		kvm_realm_destroy_rtts(&kvm->arch.realm, pgt->ia_bits,
>  				       pgt->start_level);
> @@ -1190,6 +1204,24 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_MTE_ALLOWED;
>  }
>  
> +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa, unsigned long hva,
> +			 kvm_pfn_t pfn, unsigned long map_size,
> +			 enum kvm_pgtable_prot prot,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	struct page *page = pfn_to_page(pfn);
> +
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +
> +	if (!realm_is_addr_protected(realm, ipa))
> +		return realm_map_non_secure(realm, ipa, page, map_size,
> +					    memcache);
> +
> +	return realm_map_protected(realm, hva, ipa, page, map_size, memcache);
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  unsigned long fault_status)
> @@ -1210,9 +1242,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	unsigned long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  
>  	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
>  	write_fault = kvm_is_write_fault(vcpu);
> +
> +	/* Realms cannot map read-only */

Out of curiosity, why? It would be nice to have more explanation in the
comment.

> +	if (vcpu_is_rec(vcpu))
> +		write_fault = true;
> +
>  	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>  	VM_BUG_ON(write_fault && exec_fault);
>  
> @@ -1272,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	mmap_read_unlock(current->mm);
>  
>  	/*
> @@ -1345,7 +1383,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +	/* FIXME: We shouldn't need to disable this for realms */
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device || kvm_is_realm(kvm))) {

Why do we have to disable this temporarily?

>  		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
>  			vma_pagesize = fault_granule;
>  		else
> @@ -1382,6 +1421,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 */
>  	if (fault_status == FSC_PERM && vma_pagesize == fault_granule)
>  		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
> +	else if (kvm_is_realm(kvm))
> +		ret = realm_map_ipa(kvm, fault_ipa, hva, pfn, vma_pagesize,
> +				    prot, memcache);
>  	else
>  		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
>  					     __pfn_to_phys(pfn), prot,
> @@ -1437,6 +1479,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	struct kvm_memory_slot *memslot;
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
> +	gpa_t gpa_stolen_mask = kvm_gpa_stolen_bits(vcpu->kvm);
>  	gfn_t gfn;
>  	int ret, idx;
>  
> @@ -1491,7 +1534,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  
>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = (fault_ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>  	write_fault = kvm_is_write_fault(vcpu);
> @@ -1536,6 +1579,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		 * of the page size.
>  		 */
>  		fault_ipa |= kvm_vcpu_get_hfar(vcpu) & ((1 << 12) - 1);
> +		fault_ipa &= ~gpa_stolen_mask;
>  		ret = io_mem_abort(vcpu, fault_ipa);
>  		goto out_unlock;
>  	}
> @@ -1617,6 +1661,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>

Does the unprotected (shared) region of a realm support aging?
  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>  
>  	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
> @@ -1630,6 +1678,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> +	/* We don't support aging for Realms */
> +	if (kvm_is_realm(kvm))
> +		return true;
> +
>  	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
>  					   range->start << PAGE_SHIFT);
>  }
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 3405b43e1421..3d46191798e5 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -608,6 +608,54 @@ int realm_map_protected(struct realm *realm,
>  	return -ENXIO;
>  }
>  
> +int realm_map_non_secure(struct realm *realm,
> +			 unsigned long ipa,
> +			 struct page *page,
> +			 unsigned long map_size,
> +			 struct kvm_mmu_memory_cache *memcache)
> +{
> +	phys_addr_t rd = virt_to_phys(realm->rd);
> +	int map_level;
> +	int ret = 0;
> +	unsigned long desc = page_to_phys(page) |
> +			     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
> +			     /* FIXME: Read+Write permissions for now */
Why can't we handle the prot from the realm_map_ipa()? Working in progress? :)
> +			     (3 << 6) |
> +			     PTE_SHARED;
> +
> +	if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
> +		return -EINVAL;
> +
> +	switch (map_size) {
> +	case PAGE_SIZE:
> +		map_level = 3;
> +		break;
> +	case RME_L2_BLOCK_SIZE:
> +		map_level = 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +
> +	if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +		/* Create missing RTTs and retry */
> +		int level = RMI_RETURN_INDEX(ret);
> +
> +		ret = realm_create_rtt_levels(realm, ipa, level, map_level,
> +					      memcache);
> +		if (WARN_ON(ret))
> +			return -ENXIO;
> +
> +		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
> +	}
> +	if (WARN_ON(ret))
> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
>  static int populate_par_region(struct kvm *kvm,
>  			       phys_addr_t ipa_base,
>  			       phys_addr_t ipa_end)

