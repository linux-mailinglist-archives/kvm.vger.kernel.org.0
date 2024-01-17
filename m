Return-Path: <kvm+bounces-6395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1C88308D8
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 15:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D7ED288616
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 14:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCD32136A;
	Wed, 17 Jan 2024 14:53:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A246D21103
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705503212; cv=none; b=dOcgesuquz7VcGYYSaqOfA3k7cSyWkSU+NfvOz5TvC7RzLZE1JV9jqL1NEgzYnNRg/r1kQTz1V1pDkiNgIcEH8LkQNqfF1l2ZcYKjaRxMIJtQUtWtY9mhlxCiW15JoJiQg/23dNupxU4JrgvaUNrEKXlMva0uopv3QlSg5TaT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705503212; c=relaxed/simple;
	bh=UQZv9R5R44pjsYklVFLVGdfBf8OGFpGGbP7oXjVdzdg=;
	h=Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To; b=SNg1UP8nBY+apLYWuFWrTKfY+ovWG/dDBAxKhyA3DYs+duUOxj9L6ZpySGdkvajYsajk39OMUD+Y35JJPUQbQ/K7MFSJMRRqapvwRi1tJCEYi8r8mVoJW+utgWcffuppuIiHgWW3P4eYAtu9oRc/oN8Ppa2Dx708dfwpQ+mwG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 586A111FB;
	Wed, 17 Jan 2024 06:54:10 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28EB93F5A1;
	Wed, 17 Jan 2024 06:53:22 -0800 (PST)
Date: Wed, 17 Jan 2024 14:53:16 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v11 19/43] KVM: arm64: nv: Handle shadow stage 2 page
 faults
Message-ID: <20240117145316.GA398843@e124191.cambridge.arm.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <20231120131027.854038-20-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120131027.854038-20-maz@kernel.org>

Hi Marc,

Drive by thing I spotted.

On Mon, Nov 20, 2023 at 01:10:03PM +0000, Marc Zyngier wrote:
> If we are faulting on a shadow stage 2 translation, we first walk the
> guest hypervisor's stage 2 page table to see if it has a mapping. If
> not, we inject a stage 2 page fault to the virtual EL2. Otherwise, we
> create a mapping in the shadow stage 2 page table.
> 
> Note that we have to deal with two IPAs when we got a shadow stage 2
> page fault. One is the address we faulted on, and is in the L2 guest
> phys space. The other is from the guest stage-2 page table walk, and is
> in the L1 guest phys space.  To differentiate them, we rename variables
> so that fault_ipa is used for the former and ipa is used for the latter.
> 
> Co-developed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: rewrote this multiple times...]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  7 +++
>  arch/arm64/include/asm/kvm_nested.h  | 19 ++++++
>  arch/arm64/kvm/mmu.c                 | 89 ++++++++++++++++++++++++----
>  arch/arm64/kvm/nested.c              | 48 +++++++++++++++
>  4 files changed, 153 insertions(+), 10 deletions(-)
> 
[.. snip ..]
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 588ce46c0ad0..41de7616b735 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1412,14 +1412,16 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
>  }
>  
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> -			  struct kvm_memory_slot *memslot, unsigned long hva,
> -			  unsigned long fault_status)
> +			  struct kvm_s2_trans *nested,
> +			  struct kvm_memory_slot *memslot,
> +			  unsigned long hva, unsigned long fault_status)
>  {
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
>  	bool exec_fault, mte_allowed;
>  	bool device = false;
>  	unsigned long mmu_seq;
> +	phys_addr_t ipa = fault_ipa;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>  	struct vm_area_struct *vma;
> @@ -1504,10 +1506,38 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	}
>  
>  	vma_pagesize = 1UL << vma_shift;
> +
> +	if (nested) {
> +		unsigned long max_map_size;
> +
> +		max_map_size = force_pte ? PUD_SIZE : PAGE_SIZE;

This seems like the wrong way around, presumably you want PAGE_SIZE for force_pte?

> +
> +		ipa = kvm_s2_trans_output(nested);
> +
> +		/*
> +		 * If we're about to create a shadow stage 2 entry, then we
> +		 * can only create a block mapping if the guest stage 2 page
> +		 * table uses at least as big a mapping.
> +		 */
> +		max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
> +
> +		/*
> +		 * Be careful that if the mapping size falls between
> +		 * two host sizes, take the smallest of the two.
> +		 */
> +		if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
> +			max_map_size = PMD_SIZE;
> +		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
> +			max_map_size = PAGE_SIZE;
> +
> +		force_pte = (max_map_size == PAGE_SIZE);
> +		vma_pagesize = min(vma_pagesize, (long)max_map_size);
> +	}
> +
>  	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>  		fault_ipa &= ~(vma_pagesize - 1);
>  
> -	gfn = fault_ipa >> PAGE_SHIFT;
> +	gfn = ipa >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>  
>  	/* Don't use the VMA after the unlock -- it may have vanished */
[.. snip ..]

Thanks,
Joey

