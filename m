Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66371FBB48
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 18:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731411AbgFPQSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 12:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732173AbgFPQSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 12:18:14 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C81D208D5;
        Tue, 16 Jun 2020 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592324293;
        bh=v5Sj0/W7MtjRrwZAvkLObkjzwoc3n0cYPg8rAVInY3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mdQ4BO7YQCZj7QvOntSivuktFmpERfCFOg9s2NLJbfRUPSzSOkKfTLjZNsI13cWOb
         F1jGT7Kr0BzT5nqBhw8oF9AW99F0f7oq6tVbUOP1Fd6PdpIJvE5BJGGB/tukkHmCvn
         XawWKe7tJYlcqn2DvK3W33JhaZ7ZyUBOIH93WEnc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jlEHr-003UeY-Sa; Tue, 16 Jun 2020 17:18:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 16 Jun 2020 17:18:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
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
Subject: Re: [PATCH v2 01/17] KVM: arm64: Factor out stage 2 page table data
 from struct kvm
In-Reply-To: <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-2-maz@kernel.org>
 <17d37bde-2fc8-d165-ee02-7640fc561167@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <9c0044564885d3356f76b55f35426987@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, gcherian@marvell.com, prime.zeng@hisilicon.com, ascull@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 2020-06-16 16:59, Alexandru Elisei wrote:
> Hi,
> 
> IMO, this patch does two different things: adds a new structure, 
> kvm_s2_mmu, and
> converts the memory management code to use the 4 level page table API. 
> I realize
> it's painful to convert the MMU code to use the p4d functions, and then 
> modify
> everything to use kvm_s2_mmu in a separate patch, but I believe
> splitting it into
> 2 would be better in the long run. The resulting patches will be
> smaller and both
> will have a better chance of being reviewed by the right people.

I'm not sure how you want me to do this. The whole p4d mess is already 
in mainline (went via akpm directly to Linus), and I can't really revert 
it.

> Either way, there were still some suggestions left over from v1, I 
> don't know if
> they were were too minor/subjective to implement, or they were 
> overlooked. I'll
> re-post them here and I'll try to review the patch again once I figure
> out how the  p4d changes fit in.

Sorry, I must have dropped the ball on your comments.

> 
> On 6/15/20 2:27 PM, Marc Zyngier wrote:
>> From: Christoffer Dall <christoffer.dall@arm.com>
>> 
>> As we are about to reuse our stage 2 page table manipulation code for
>> shadow stage 2 page tables in the context of nested virtualization, we
>> are going to manage multiple stage 2 page tables for a single VM.
>> 
>> This requires some pretty invasive changes to our data structures,
>> which moves the vmid and pgd pointers into a separate structure and
>> change pretty much all of our mmu code to operate on this structure
>> instead.
>> 
>> The new structure is called struct kvm_s2_mmu.
>> 
>> There is no intended functional change by this patch alone.
>> 
>> Reviewed-by: James Morse <james.morse@arm.com>
>> [Designed data structure layout in collaboration]
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> Co-developed-by: Marc Zyngier <maz@kernel.org>
>> [maz: Moved the last_vcpu_ran down to the S2 MMU structure as well]
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h  |   7 +-
>>  arch/arm64/include/asm/kvm_host.h |  32 +++-
>>  arch/arm64/include/asm/kvm_mmu.h  |  16 +-
>>  arch/arm64/kvm/arm.c              |  36 ++--
>>  arch/arm64/kvm/hyp/switch.c       |   8 +-
>>  arch/arm64/kvm/hyp/tlb.c          |  52 +++---
>>  arch/arm64/kvm/mmu.c              | 278 
>> +++++++++++++++++-------------
>>  7 files changed, 233 insertions(+), 196 deletions(-)
>> 
>> [..]
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 90cb90561446..360396ecc6d3 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
> 
> There's still one comment in the file that refers to arch.vmid:
> 
> static bool need_new_vmid_gen(struct kvm_vmid *vmid)
> {
>     u64 current_vmid_gen = atomic64_read(&kvm_vmid_gen);
>     smp_rmb(); /* Orders read of kvm_vmid_gen and kvm->arch.vmid */
>     return unlikely(READ_ONCE(vmid->vmid_gen) != current_vmid_gen);
> }
> 
> The comment could be rephrased to remove the reference to
> kvm->arch.vmid: "Orders
> read of kvm_vmid_gen and kvm_s2_mmu->vmid".

Yup, definitely useful.

> 
>> [..]
>> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 8c0035cab6b6..4a4437be4bc5 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> 
>> [..]
>> 
>>  /**
>> - * kvm_alloc_stage2_pgd - allocate level-1 table for stage-2 
>> translation.
>> - * @kvm:	The KVM struct pointer for the VM.
>> + * kvm_init_stage2_mmu - Initialise a S2 MMU strucrure
>> + * @kvm:	The pointer to the KVM structure
>> + * @mmu:	The pointer to the s2 MMU structure
>>   *
>>   * Allocates only the stage-2 HW PGD level table(s) of size defined 
>> by
>> - * stage2_pgd_size(kvm).
>> + * stage2_pgd_size(mmu->kvm).
>>   *
>>   * Note we don't need locking here as this is only called when the VM 
>> is
>>   * created, which can only be done once.
>>   */
>> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
>> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>>  {
>>  	phys_addr_t pgd_phys;
>>  	pgd_t *pgd;
>> +	int cpu;
>> 
>> -	if (kvm->arch.pgd != NULL) {
>> +	if (mmu->pgd != NULL) {
>>  		kvm_err("kvm_arch already initialized?\n");
>>  		return -EINVAL;
>>  	}
>> @@ -1024,8 +1040,20 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>>  	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
>>  		return -EINVAL;
> 
> We don't free the pgd if we get the error above, but we do free it 
> below, if
> allocating last_vcpu_ran fails. Shouldn't we free it in both cases?

Worth investigating. This code gets majorly revamped in the NV series, 
so it is likely that I missed something in the middle.

Thanks for the heads up!

         M.
-- 
Jazz is not dead. It just smells funny...
