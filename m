Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDFB32B56C
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhCCHOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:14:38 -0500
Received: from foss.arm.com ([217.140.110.172]:55268 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343571AbhCBRPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 12:15:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 950BB31B;
        Tue,  2 Mar 2021 09:13:39 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D24793F7D7;
        Tue,  2 Mar 2021 09:13:37 -0800 (PST)
Subject: Re: [RFC PATCH 3/4] KVM: arm64: Install the block entry before
 unmapping the page mappings
To:     Yanan Wang <wangyanan55@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-4-wangyanan55@huawei.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <33a9999e-2cc5-52ca-3da8-38f7e7702529@arm.com>
Date:   Tue, 2 Mar 2021 17:13:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210208112250.163568-4-wangyanan55@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 2/8/21 11:22 AM, Yanan Wang wrote:
> When KVM needs to coalesce the normal page mappings into a block mapping,
> we currently invalidate the old table entry first followed by invalidation
> of TLB, then unmap the page mappings, and install the block entry at last.
>
> It will cost a long time to unmap the numerous page mappings, which means
> there will be a long period when the table entry can be found invalid.
> If other vCPUs access any guest page within the block range and find the
> table entry invalid, they will all exit from guest with a translation fault
> which is not necessary. And KVM will make efforts to handle these faults,
> especially when performing CMOs by block range.
>
> So let's quickly install the block entry at first to ensure uninterrupted
> memory access of the other vCPUs, and then unmap the page mappings after
> installation. This will reduce most of the time when the table entry is
> invalid, and avoid most of the unnecessary translation faults.

I'm not convinced I've fully understood what is going on yet, but it seems to me
that the idea is sound. Some questions and comments below.

>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 78a560446f80..308c36b9cd21 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -434,6 +434,7 @@ struct stage2_map_data {
>  	kvm_pte_t			attr;
>  
>  	kvm_pte_t			*anchor;
> +	kvm_pte_t			*follow;
>  
>  	struct kvm_s2_mmu		*mmu;
>  	struct kvm_mmu_memory_cache	*memcache;
> @@ -553,15 +554,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>  	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
>  		return 0;
>  
> -	kvm_set_invalid_pte(ptep);
> -
>  	/*
> -	 * Invalidate the whole stage-2, as we may have numerous leaf
> -	 * entries below us which would otherwise need invalidating
> -	 * individually.
> +	 * If we need to coalesce existing table entries into a block here,
> +	 * then install the block entry first and the sub-level page mappings
> +	 * will be unmapped later.
>  	 */
> -	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>  	data->anchor = ptep;
> +	data->follow = kvm_pte_follow(*ptep);
> +	stage2_coalesce_tables_into_block(addr, level, ptep, data);

Here's how stage2_coalesce_tables_into_block() is implemented from the previous
patch (it might be worth merging it with this patch, I found it impossible to
judge if the function is correct without seeing how it is used and what is replacing):

static void stage2_coalesce_tables_into_block(u64 addr, u32 level,
                          kvm_pte_t *ptep,
                          struct stage2_map_data *data)
{
    u64 granule = kvm_granule_size(level), phys = data->phys;
    kvm_pte_t new = kvm_init_valid_leaf_pte(phys, data->attr, level);

    kvm_set_invalid_pte(ptep);

    /*
     * Invalidate the whole stage-2, as we may have numerous leaf entries
     * below us which would otherwise need invalidating individually.
     */
    kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
    smp_store_release(ptep, new);
    data->phys += granule;
}

This works because __kvm_pgtable_visit() saves the *ptep value before calling the
pre callback, and it visits the next level table based on the initial pte value,
not the new value written by stage2_coalesce_tables_into_block().

Assuming the first patch in the series is merged ("KVM: arm64: Move the clean of
dcache to the map handler"), this function is missing the CMOs from
stage2_map_walker_try_leaf(). I can think of the following situation where they
are needed:

1. The 2nd level (PMD) table that will be turned into a block is mapped at stage 2
because one of the pages in the 3rd level (PTE) table it points to is accessed by
the guest.

2. The kernel decides to turn the userspace mapping into a transparent huge page
and calls the mmu notifier to remove the mapping from stage 2. The 2nd level table
is still valid.

3. Guest accesses a page which is not the page it accessed at step 1, which causes
a translation fault. KVM decides we can use a PMD block mapping to map the address
and we end up in stage2_coalesce_tables_into_block(). We need CMOs in this case
because the guest accesses memory it didn't access before.

What do you think, is that a valid situation?

>  	return 0;
>  }
>  
> @@ -614,20 +614,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>  				      kvm_pte_t *ptep,
>  				      struct stage2_map_data *data)
>  {
> -	int ret = 0;
> -
>  	if (!data->anchor)
>  		return 0;
>  
> -	free_page((unsigned long)kvm_pte_follow(*ptep));
> -	put_page(virt_to_page(ptep));
> -
> -	if (data->anchor == ptep) {
> +	if (data->anchor != ptep) {
> +		free_page((unsigned long)kvm_pte_follow(*ptep));
> +		put_page(virt_to_page(ptep));
> +	} else {
> +		free_page((unsigned long)data->follow);
>  		data->anchor = NULL;
> -		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);

stage2_map_walk_leaf() -> stage2_map_walker_try_leaf() calls put_page() and
get_page() once in our case (valid old mapping). It looks to me like we're missing
a put_page() call when the function is called for the anchor. Have you found the
call to be unnecessary?

>  	}
>  
> -	return ret;
> +	return 0;

I think it's correct for this function to succeed unconditionally. The error was
coming from stage2_map_walk_leaf() -> stage2_map_walker_try_leaf(). The function
can return an error code if block mapping is not supported, which we know is
supported because we have an anchor, and if only the permissions are different
between the old and the new entry, but in our case we've changed both the valid
and type bits.

Thanks,

Alex

>  }
>  
>  /*
