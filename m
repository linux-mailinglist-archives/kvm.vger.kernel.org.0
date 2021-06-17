Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62633AB3F0
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFQMsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 08:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhFQMsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 08:48:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D6DD610CA;
        Thu, 17 Jun 2021 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623933963;
        bh=7qOj++G8f7HBqpudTlVSPdk49xIpm6jF4dp4gG131hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BsKqjiuEZJFdx1tzoQh4H02boL1lqjLg0qo5P92kukhKvHa/z2pQUh3XcXY87rYYW
         PsnwyXusiLXSSThp1+HzYdvv6G0IBqSilnlbBh+8Z34+6YVi/quFPGJ+LD/joh15k8
         ZeEuryqaErAHbqj+Jxq+G8CO+/O9wp1EGLmmPlQzjHxJUNQhZh94zv99j2TJeyOUzW
         G9sNGwyluJHeJIRWXvqGxsrIxZpCZao+MvePiCIbx1+R9o6/BKPjZIkHkSrUVhExaM
         ZmiQOuJjJiQhVqmFWNTFiTNCwddi8VehgAcbwk4QRl54zNucgOH5GP3+zYhuf8nH9c
         nRm23EO1cftyg==
Date:   Thu, 17 Jun 2021 13:45:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Marc Zyngier <maz@kernel.org>, Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, wanghaibin.wang@huawei.com,
        zhukeqian1@huawei.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 4/4] KVM: arm64: Move guest CMOs to the fault handlers
Message-ID: <20210617124557.GB24457@willie-the-truck>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-5-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617105824.31752-5-wangyanan55@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 06:58:24PM +0800, Yanan Wang wrote:
> We currently uniformly permorm CMOs of D-cache and I-cache in function
> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
> 
> By moving CMOs to the fault handlers, we can easily identify conditions
> where they are really needed and avoid the unnecessary ones. As it's a
> time consuming process to perform CMOs especially when flushing a block
> range, so this solution reduces much load of kvm and improve efficiency
> of the stage-2 page table code.
> 
> We can imagine two specific scenarios which will gain much benefit:
> 1) In a normal VM startup, this solution will improve the efficiency of
> handling guest page faults incurred by vCPUs, when initially populating
> stage-2 page tables.
> 2) After live migration, the heavy workload will be resumed on the
> destination VM, however all the stage-2 page tables need to be rebuilt
> at the moment. So this solution will ease the performance drop during
> resuming stage.
> 
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 38 +++++++++++++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c         | 37 ++++++++++++++---------------------
>  2 files changed, 46 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d99789432b05..760c551f61da 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -577,12 +577,24 @@ static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>  	mm_ops->put_page(ptep);
>  }
>  
> +static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
> +{
> +	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> +	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
> +}
> +
> +static bool stage2_pte_executable(kvm_pte_t pte)
> +{
> +	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
> +}
> +
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  				      kvm_pte_t *ptep,
>  				      struct stage2_map_data *data)
>  {
>  	kvm_pte_t new, old = *ptep;
>  	u64 granule = kvm_granule_size(level), phys = data->phys;
> +	struct kvm_pgtable *pgt = data->mmu->pgt;
>  	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
>  
>  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> @@ -606,6 +618,14 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
>  	}
>  
> +	/* Perform CMOs before installation of the guest stage-2 PTE */
> +	if (mm_ops->clean_invalidate_dcache && stage2_pte_cacheable(pgt, new))
> +		mm_ops->clean_invalidate_dcache(kvm_pte_follow(new, mm_ops),
> +						granule);
> +
> +	if (mm_ops->invalidate_icache && stage2_pte_executable(new))
> +		mm_ops->invalidate_icache(kvm_pte_follow(new, mm_ops), granule);

One thing I'm missing here is why we need the indirection via mm_ops. Are
there cases where we would want to pass a different function pointer for
invalidating the icache? If not, why not just call the function directly?

Same for the D side.

Will
