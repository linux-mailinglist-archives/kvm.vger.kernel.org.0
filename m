Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F4D210A4C
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 13:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgGAL2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 07:28:45 -0400
Received: from foss.arm.com ([217.140.110.172]:59770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730159AbgGAL2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 07:28:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D39FD30E;
        Wed,  1 Jul 2020 04:28:43 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D8313F73C;
        Wed,  1 Jul 2020 04:28:40 -0700 (PDT)
Subject: Re: [PATCH 03/12] KVM: arm64: Report hardware dirty status of stage2
 PTE if coverred
To:     Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        liangpeng10@huawei.com, Alexios Zavras <alexios.zavras@intel.com>,
        Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
 <20200616093553.27512-4-zhukeqian1@huawei.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <a73952ac-5e81-6c05-9b21-734e25250845@arm.com>
Date:   Wed, 1 Jul 2020 12:28:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616093553.27512-4-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 16/06/2020 10:35, Keqian Zhu wrote:
> kvm_set_pte is called to replace a target PTE with a desired one.
> We always do this without changing the desired one, but if dirty
> status set by hardware is coverred, let caller know it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>   arch/arm64/kvm/mmu.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5ad87bce23c0..27407153121b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -194,11 +194,45 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
>   	put_page(virt_to_page(pmd));
>   }
>   
> -static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +/**
> + * @ret: true if dirty status set by hardware is coverred.

NIT: s/coverred/covered/, this is in several places.

> + */
> +static bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
> +{
> +	pteval_t old_pteval, new_pteval, pteval;
> +	bool old_logging, new_no_write;
> +
> +	old_logging = kvm_hw_dbm_enabled() && !pte_none(*ptep) &&
> +		      kvm_s2pte_dbm(ptep);
> +	new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
> +
> +	if (!old_logging || !new_no_write) {
> +		WRITE_ONCE(*ptep, new_pte);
> +		dsb(ishst);
> +		return false;
> +	}
> +
> +	new_pteval = pte_val(new_pte);
> +	pteval = READ_ONCE(pte_val(*ptep));

This usage of *ptep looks wrong - it's read twice using READ_ONCE (once 
in kvm_s2pte_dbm()) and once without any decoration (in the pte_none() 
call). Which looks a bit dodgy and at the very least needs some 
justification. AFAICT you would be better taking a local copy and using 
that rather than reading from memory repeatedly.

> +	do {
> +		old_pteval = pteval;
> +		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, new_pteval);
> +	} while (pteval != old_pteval);
This look appears to be reinventing xchg_relaxed(). Any reason we can't 
just use xchg_relaxed()? Also we had a dsb() after the WRITE_ONCE but 
you are using the _relaxed variant here. What is the justification for 
not having a barrier?

> +
> +	return !kvm_s2pte_readonly(&__pte(pteval));
> +}
> +#else
> +/**
> + * @ret: true if dirty status set by hardware is coverred.
> + */
> +static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
>   {
>   	WRITE_ONCE(*ptep, new_pte);
>   	dsb(ishst);
> +	return false;
>   }
> +#endif /* CONFIG_ARM64_HW_AFDBM */

You might be able to avoid this #ifdef by redefining old_logging as:

   old_logging = IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && ...

I *think* the compiler should be able to kill the dead code and leave 
you with just the above when the config symbol is off.

Steve

>   
>   static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
>   {
> 

