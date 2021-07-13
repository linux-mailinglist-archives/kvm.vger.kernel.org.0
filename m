Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCD83C743B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhGMQVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:21:31 -0400
Received: from foss.arm.com ([217.140.110.172]:46556 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhGMQVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:21:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CD206D;
        Tue, 13 Jul 2021 09:18:40 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C11E03F7D8;
        Tue, 13 Jul 2021 09:18:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Fix detection of shared VMAs on guest fault
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210713114804.594993-1-maz@kernel.org>
From:   Steven Price <steven.price@arm.com>
Message-ID: <017a25b0-d706-df97-dbba-80d5b21d1779@arm.com>
Date:   Tue, 13 Jul 2021 17:18:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713114804.594993-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/2021 12:48, Marc Zyngier wrote:
> When merging the KVM MTE support, the blob that was interposed between
> the chair and the keyboard experienced a neuronal accident (also known
> as a brain fart), turning a check for VM_SHARED into VM_PFNMAP as it
> was reshuffling some of the code.
> 
> The blob having now come back to its senses, let's restore the
> initial check that the original author got right the first place.
> 
> Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
> Cc: Steven Price <steven.price@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Steven Price <steven.price@arm.com>

Somehow this blob missed it too while reviewing the changes you'd made.

Thanks,

Steve

> ---
>  arch/arm64/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3155c9e778f0..0625bf2353c2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -947,7 +947,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		vma_shift = get_vma_page_shift(vma, hva);
>  	}
>  
> -	shared = (vma->vm_flags & VM_PFNMAP);
> +	shared = (vma->vm_flags & VM_SHARED);
>  
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
> 

