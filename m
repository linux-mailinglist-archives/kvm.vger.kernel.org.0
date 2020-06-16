Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1831FB8BD
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbgFPP6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 11:58:33 -0400
Received: from foss.arm.com ([217.140.110.172]:40872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730932AbgFPP6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 11:58:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70E8A1F1;
        Tue, 16 Jun 2020 08:58:31 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A36E3F73C;
        Tue, 16 Jun 2020 08:58:29 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
Message-ID: <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
Date:   Tue, 16 Jun 2020 16:59:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615132719.1932408-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

IMO, this patch does two different things: adds a new structure, kvm_s2_mmu, and
converts the memory management code to use the 4 level page table API. I realize
it's painful to convert the MMU code to use the p4d functions, and then modify
everything to use kvm_s2_mmu in a separate patch, but I believe splitting it into
2 would be better in the long run. The resulting patches will be smaller and both
will have a better chance of being reviewed by the right people.

Either way, there were still some suggestions left over from v1, I don't know if
they were were too minor/subjective to implement, or they were overlooked. I'll
re-post them here and I'll try to review the patch again once I figure out how the
p4d changes fit in.

On 6/15/20 2:27 PM, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
>
> As we are about to reuse our stage 2 page table manipulation code for
> shadow stage 2 page tables in the context of nested virtualization, we
> are going to manage multiple stage 2 page tables for a single VM.
>
> This requires some pretty invasive changes to our data structures,
> which moves the vmid and pgd pointers into a separate structure and
> change pretty much all of our mmu code to operate on this structure
> instead.
>
> The new structure is called struct kvm_s2_mmu.
>
> There is no intended functional change by this patch alone.
>
> Reviewed-by: James Morse <james.morse@arm.com>
> [Designed data structure layout in collaboration]
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Co-developed-by: Marc Zyngier <maz@kernel.org>
> [maz: Moved the last_vcpu_ran down to the S2 MMU structure as well]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h  |   7 +-
>  arch/arm64/include/asm/kvm_host.h |  32 +++-
>  arch/arm64/include/asm/kvm_mmu.h  |  16 +-
>  arch/arm64/kvm/arm.c              |  36 ++--
>  arch/arm64/kvm/hyp/switch.c       |   8 +-
>  arch/arm64/kvm/hyp/tlb.c          |  52 +++---
>  arch/arm64/kvm/mmu.c              | 278 +++++++++++++++++-------------
>  7 files changed, 233 insertions(+), 196 deletions(-)
>
> [..]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 90cb90561446..360396ecc6d3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

There's still one comment in the file that refers to arch.vmid:

static bool need_new_vmid_gen(struct kvm_vmid *vmid)
{
    u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
    smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
    return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
}

The comment could be rephrased to remove the reference to kvm->arch.vmid: "Orders
read of kvm_vmid_gen and kvm_s2_mmu->vmid".

> [..]
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c0035cab6b6..4a4437be4bc5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
>
> [..]
>  
>  /**
> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 translation.
> - * @kvm:	The KVM struct pointer for the VM.
> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
> + * @kvm:	The pointer to the KVM structure
> + * @mmu:	The pointer to the s2 MMU structure
>   *
>   * Allocates only the stage-2 HW PGD level table(s) of size defined by
> - * stage2_pgd_size(kvm).
> + * stage2_pgd_size(mmu->kvm).
>   *
>   * Note we don't need locking here as this is only called when the VM is
>   * created, which can only be done once.
>   */
> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  {
>  	phys_addr_t pgd_phys;
>  	pgd_t *pgd;
> +	int cpu;
>  
> -	if (kvm->arch.pgd != NULL) {
> +	if (mmu->pgd != NULL) {
>  		kvm_err("kvm_arch already initialized?\n");
>  		return -EINVAL;
>  	}
> @@ -1024,8 +1040,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>  		return -EINVAL;

We don't free the pgd if we get the error above, but we do free it below, if
allocating last_vcpu_ran fails. Shouldn't we free it in both cases?

> -	kvm->arch.pgd = pgd;
> -	kvm->arch.pgd_phys = pgd_phys;
> +	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
> +	if (!mmu->last_vcpu_ran) {
> +		free_pages_exact(pgd, stage2_pgd_size(kvm));
> +		return -ENOMEM;
> +	}
>
> [..]

Thanks,
Alex
