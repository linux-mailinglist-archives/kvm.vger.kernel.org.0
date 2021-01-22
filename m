Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0839F2FFF87
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbhAVJtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 04:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbhAVJqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 04:46:10 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045AE22DBF;
        Fri, 22 Jan 2021 09:45:29 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l2t0Q-009NVo-MF; Fri, 22 Jan 2021 09:45:26 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 22 Jan 2021 09:45:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
Subject: Re: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device
 MMIO
In-Reply-To: <20210122083650.21812-1-zhukeqian1@huawei.com>
References: <20210122083650.21812-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <09d89355cdbbd19c456699774a9a980a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, robin.murphy@arm.com, joro@8bytes.org, daniel.lezcano@linaro.org, tglx@linutronix.de, suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com, akpm@linux-foundation.org, alexios.zavras@intel.com, wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-22 08:36, Keqian Zhu wrote:
> The MMIO region of a device maybe huge (GB level), try to use block
> mapping in stage2 to speedup both map and unmap.
> 
> Especially for unmap, it performs TLBI right after each invalidation
> of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
> GB level range.

This is only on VM teardown, right? Or do you unmap the device more 
ofet?
Can you please quantify the speedup and the conditions this occurs in?

I have the feeling that we are just circling around another problem,
which is that we could rely on a VM-wide TLBI when tearing down the
guest. I worked on something like that[1] a long while ago, and parked
it for some reason. Maybe it is worth reviving.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/elide-cmo-tlbi

> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
>  arch/arm64/kvm/mmu.c                 | 12 ++++++++----
>  3 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> index 52ab38db04c7..2266ac45f10c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
>  	const enum kvm_pgtable_walk_flags	flags;
>  };
> 
> +/**
> + * kvm_supported_pgsize() - Get the max supported page size of a 
> mapping.
> + * @pgt:	Initialised page-table structure.
> + * @addr:	Virtual address at which to place the mapping.
> + * @end:	End virtual address of the mapping.
> + * @phys:	Physical address of the memory to map.
> + *
> + * The smallest return value is PAGE_SIZE.
> + */
> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, 
> u64 phys);
> +
>  /**
>   * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 
> page-table.
>   * @pgt:	Uninitialised page-table structure to initialise.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c 
> b/arch/arm64/kvm/hyp/pgtable.c
> index bdf8e55ed308..ab11609b9b13 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr,
> u64 end, u64 phys, u32 level)
>  	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
>  }
> 
> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, 
> u64 phys)
> +{
> +	u32 lvl;
> +	u64 pgsize = PAGE_SIZE;
> +
> +	for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
> +		if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
> +			pgsize = kvm_granule_size(lvl);
> +			break;
> +		}
> +	}
> +
> +	return pgsize;
> +}
> +
>  static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 
> level)
>  {
>  	u64 shift = kvm_granule_shift(level);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d2257cc5438..80b403fc8e64 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable)
>  {
> -	phys_addr_t addr;
> +	phys_addr_t addr, end;
> +	unsigned long pgsize;
>  	int ret = 0;
>  	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
>  	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> @@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm,
> phys_addr_t guest_ipa,
> 
>  	size += offset_in_page(guest_ipa);
>  	guest_ipa &= PAGE_MASK;
> +	end = guest_ipa + size;
> 
> -	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
> +	for (addr = guest_ipa; addr < end; addr += pgsize) {
>  		ret = kvm_mmu_topup_memory_cache(&cache,
>  						 kvm_mmu_cache_min_pages(kvm));
>  		if (ret)
>  			break;
> 
> +		pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
> +
>  		spin_lock(&kvm->mmu_lock);
> -		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> +		ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
>  					     &cache);
>  		spin_unlock(&kvm->mmu_lock);
>  		if (ret)
>  			break;
> 
> -		pa += PAGE_SIZE;
> +		pa += pgsize;
>  	}
> 
>  	kvm_mmu_free_memory_cache(&cache);

This otherwise looks neat enough.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
