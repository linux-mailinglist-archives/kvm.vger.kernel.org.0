Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C753D7D22
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhG0SLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0SLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D7C60E08;
        Tue, 27 Jul 2021 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409473;
        bh=Ur9pPprRGIm8RpSOIFYLtAZgxXBn8A4m1Hk9iN9rkZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/ICnhp6aRMvqV04av0WLSCRwkFNQARS2FeYE73O8FFruDTT08mE1JSXZRCFs9oGE
         er58B9wzWaHOMFVXzixU1Cpzxc4HLo8nXU5ZVCbrAwtsB4WvrBLEBVg1S8Y/4UUsxT
         WX5J+1jZA/oiK9jV2Uy55Efn9cAKule7OT2mBjrixbZfAlr8WE7+nC4ufK1ldFNVd6
         SET5afmktu2rLx5qD8oIt15eXdgWbIaBS0a7bLNSY02wrzeU0giD99SlI2+HM3hDql
         Z6Kb/5pXpTKND+qlOZEFh7NpLyWNuTOA1RBiDrEASbAdtd2Toti/IFGZchJnWldb2K
         Pzslq2gLCrdXA==
Date:   Tue, 27 Jul 2021 19:11:08 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <20210727181107.GC19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-5-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:47PM +0100, Marc Zyngier wrote:
> Introduce the infrastructure required to identify an IPA region
> that is expected to be used as an MMIO window.
> 
> This include mapping, unmapping and checking the regions. Nothing
> calls into it yet, so no expected functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   2 +
>  arch/arm64/include/asm/kvm_mmu.h  |   5 ++
>  arch/arm64/kvm/mmu.c              | 115 ++++++++++++++++++++++++++++++
>  3 files changed, 122 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4add6c27251f..914c1b7bb3ad 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -125,6 +125,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
>  	/* Memory Tagging Extension enabled for the guest */
>  #define KVM_ARCH_FLAG_MTE_ENABLED			1
> +	/* Gues has bought into the MMIO guard extension */
> +#define KVM_ARCH_FLAG_MMIO_GUARD			2
>  	unsigned long flags;
>  
>  	/*
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index b52c5c4b9a3d..f6b8fc1671b3 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -170,6 +170,11 @@ phys_addr_t kvm_mmu_get_httbr(void);
>  phys_addr_t kvm_get_idmap_vector(void);
>  int kvm_mmu_init(u32 *hyp_va_bits);
>  
> +/* MMIO guard */
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_remove_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa);
> +
>  static inline void *__kvm_vector_slot2addr(void *base,
>  					   enum arm64_hyp_spectre_vector slot)
>  {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..638827c8842b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1120,6 +1120,121 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pte_pfn(pte));
>  }
>  
> +#define MMIO_NOTE	('M' << 24 | 'M' << 16 | 'I' << 8 | '0')

Although this made me smile, maybe we should carve up the bit space a bit
more carefully ;) Also, you know somebody clever will "fix" that typo to
'O'!

Quentin, as the other user of this stuff at the moment, how do you see the
annotation space being allocated? Feels like we should have some 'type'
bits which decide how to parse the rest of the entry.

> +
> +bool kvm_install_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct kvm_mmu_memory_cache *memcache;
> +	struct kvm_memory_slot *memslot;
> +	int ret, idx;
> +
> +	if (!test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> +		return false;
> +
> +	/* Must be page-aligned */
> +	if (ipa & ~PAGE_MASK)
> +		return false;
> +
> +	/*
> +	 * The page cannot be in a memslot. At some point, this will
> +	 * have to deal with device mappings though.
> +	 */
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	memslot = gfn_to_memslot(vcpu->kvm, ipa >> PAGE_SHIFT);
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);

What does this memslot check achieve? A new memslot could be added after
you've checked, no?

> +/* Assumes mmu_lock taken */

You can use a lockdep assertion for that!

Will
