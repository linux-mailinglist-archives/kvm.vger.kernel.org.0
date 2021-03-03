Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D176732C5E5
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344554AbhCDA05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:26:57 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4643 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhCCL2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 06:28:38 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4DrB1M205DzYFZ6;
        Wed,  3 Mar 2021 19:03:03 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 3 Mar 2021 19:04:35 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Wed, 3 Mar 2021 19:04:34 +0800
Subject: Re: [RFC PATCH 3/4] KVM: arm64: Install the block entry before
 unmapping the page mappings
To:     Alexandru Elisei <alexandru.elisei@arm.com>
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-4-wangyanan55@huawei.com>
 <33a9999e-2cc5-52ca-3da8-38f7e7702529@arm.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Quentin Perret <qperret@google.com>,
        "Gavin Shan" <gshan@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <93c13a04-6fcc-7544-d6ed-2ebb81d209fe@huawei.com>
Date:   Wed, 3 Mar 2021 19:04:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <33a9999e-2cc5-52ca-3da8-38f7e7702529@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2021/3/3 1:13, Alexandru Elisei wrote:
> Hello,
>
> On 2/8/21 11:22 AM, Yanan Wang wrote:
>> When KVM needs to coalesce the normal page mappings into a block mapping,
>> we currently invalidate the old table entry first followed by invalidation
>> of TLB, then unmap the page mappings, and install the block entry at last.
>>
>> It will cost a long time to unmap the numerous page mappings, which means
>> there will be a long period when the table entry can be found invalid.
>> If other vCPUs access any guest page within the block range and find the
>> table entry invalid, they will all exit from guest with a translation fault
>> which is not necessary. And KVM will make efforts to handle these faults,
>> especially when performing CMOs by block range.
>>
>> So let's quickly install the block entry at first to ensure uninterrupted
>> memory access of the other vCPUs, and then unmap the page mappings after
>> installation. This will reduce most of the time when the table entry is
>> invalid, and avoid most of the unnecessary translation faults.
> I'm not convinced I've fully understood what is going on yet, but it seems to me
> that the idea is sound. Some questions and comments below.
What I am trying to do in this patch is to adjust the order of 
rebuilding block mappings from page mappings.
Take the rebuilding of 1G block mappings as an example.
Before this patch, the order is like:
1) invalidate the table entry of the 1st level(PUD)
2) flush TLB by VMID
3) unmap the old PMD/PTE tables
4) install the new block entry to the 1st level(PUD)

So entry in the 1st level can be found invalid by other vcpus in 1), 2), 
and 3), and it's a long time in 3) to unmap
the numerous old PMD/PTE tables, which means the total time of the entry 
being invalid is long enough to
affect the performance.

After this patch, the order is like:
1) invalidate the table ebtry of the 1st level(PUD)
2) flush TLB by VMID
3) install the new block entry to the 1st level(PUD)
4) unmap the old PMD/PTE tables

The change ensures that period of entry in the 1st level(PUD) being 
invalid is only in 1) and 2),
so if other vcpus access memory within 1G, there will be less chance to 
find the entry invalid
and as a result trigger an unnecessary translation fault.
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
>>   1 file changed, 12 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 78a560446f80..308c36b9cd21 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -434,6 +434,7 @@ struct stage2_map_data {
>>   	kvm_pte_t			attr;
>>   
>>   	kvm_pte_t			*anchor;
>> +	kvm_pte_t			*follow;
>>   
>>   	struct kvm_s2_mmu		*mmu;
>>   	struct kvm_mmu_memory_cache	*memcache;
>> @@ -553,15 +554,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>>   	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
>>   		return 0;
>>   
>> -	kvm_set_invalid_pte(ptep);
>> -
>>   	/*
>> -	 * Invalidate the whole stage-2, as we may have numerous leaf
>> -	 * entries below us which would otherwise need invalidating
>> -	 * individually.
>> +	 * If we need to coalesce existing table entries into a block here,
>> +	 * then install the block entry first and the sub-level page mappings
>> +	 * will be unmapped later.
>>   	 */
>> -	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>>   	data->anchor = ptep;
>> +	data->follow = kvm_pte_follow(*ptep);
>> +	stage2_coalesce_tables_into_block(addr, level, ptep, data);
> Here's how stage2_coalesce_tables_into_block() is implemented from the previous
> patch (it might be worth merging it with this patch, I found it impossible to
> judge if the function is correct without seeing how it is used and what is replacing):
Ok, will do this if v2 is going to be post.
> static void stage2_coalesce_tables_into_block(u64 addr, u32 level,
>                            kvm_pte_t *ptep,
>                            struct stage2_map_data *data)
> {
>      u64 granule = kvm_granule_size(level), phys = data->phys;
>      kvm_pte_t new = kvm_init_valid_leaf_pte(phys, data->attr, level);
>
>      kvm_set_invalid_pte(ptep);
>
>      /*
>       * Invalidate the whole stage-2, as we may have numerous leaf entries
>       * below us which would otherwise need invalidating individually.
>       */
>      kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>      smp_store_release(ptep, new);
>      data->phys += granule;
> }
>
> This works because __kvm_pgtable_visit() saves the *ptep value before calling the
> pre callback, and it visits the next level table based on the initial pte value,
> not the new value written by stage2_coalesce_tables_into_block().
Right. So before replacing the initial pte value with the new value, we 
have to use
*data->follow = kvm_pte_follow(*ptep)* in stage2_map_walk_table_pre() to 
save
the initial pte value in advance. And data->follow will be used when  we 
start to
unmap the old sub-level tables later.
>
> Assuming the first patch in the series is merged ("KVM: arm64: Move the clean of
> dcache to the map handler"), this function is missing the CMOs from
> stage2_map_walker_try_leaf().
Yes, the CMOs are not performed in stage2_coalesce_tables_into_block() 
currently,
because I thought they were not needed when we rebuild the block 
mappings from
normal page mappings.

At least, they are not needed if we rebuild the block mappings backed by 
hugetlbfs
pages, because we must have built the new block mappings for the first 
time before
and now need to rebuild them after they were split in dirty logging. Can 
we agree on this?
Then let's see the following situation.
> I can think of the following situation where they
> are needed:
>
> 1. The 2nd level (PMD) table that will be turned into a block is mapped at stage 2
> because one of the pages in the 3rd level (PTE) table it points to is accessed by
> the guest.
>
> 2. The kernel decides to turn the userspace mapping into a transparent huge page
> and calls the mmu notifier to remove the mapping from stage 2. The 2nd level table
> is still valid.
I have a question here. Won't the PMD entry been invalidated too in this 
case?
If remove of the stage2 mapping by mmu notifier is an unmap operation of 
a range,
then it's correct and reasonable to both invalidate the PMD entry and 
free the PTE table.
As I know, kvm_pgtable_stage2_unmap() does so when unmapping a range.

And if I was right about this, we will not end up in 
stage2_coalesce_tables_into_block()
like step 3 describes, but in stage2_map_walker_try_leaf() instead. 
Because the PMD entry
is invalid, so KVM will create the new 2M block mapping.

If I'm wrong about this, then I think this is a valid situation.
> 3. Guest accesses a page which is not the page it accessed at step 1, which causes
> a translation fault. KVM decides we can use a PMD block mapping to map the address
> and we end up in stage2_coalesce_tables_into_block(). We need CMOs in this case
> because the guest accesses memory it didn't access before.
>
> What do you think, is that a valid situation?
>>   	return 0;
>>   }
>>   
>> @@ -614,20 +614,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>>   				      kvm_pte_t *ptep,
>>   				      struct stage2_map_data *data)
>>   {
>> -	int ret = 0;
>> -
>>   	if (!data->anchor)
>>   		return 0;
>>   
>> -	free_page((unsigned long)kvm_pte_follow(*ptep));
>> -	put_page(virt_to_page(ptep));
>> -
>> -	if (data->anchor == ptep) {
>> +	if (data->anchor != ptep) {
>> +		free_page((unsigned long)kvm_pte_follow(*ptep));
>> +		put_page(virt_to_page(ptep));
>> +	} else {
>> +		free_page((unsigned long)data->follow);
>>   		data->anchor = NULL;
>> -		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> stage2_map_walk_leaf() -> stage2_map_walk_table_post calls put_page() and
> get_page() once in our case (valid old mapping). It looks to me like we're missing
> a put_page() call when the function is called for the anchor. Have you found the
> call to be unnecessary?
Before this patch:
When we find data->anchor == ptep, put_page() has been called once in 
advance for the anchor
in stage2_map_walk_table_post(). Then we call stage2_map_walk_leaf() -> 
stage2_map_walker_try_leaf()
to install the block entry, and only get_page() will be called once in 
stage2_map_walker_try_leaf().
There is a put_page() followed by a get_page() for the anchor, and there 
will not be a problem about
page_counts.

After this patch:
Before we find data->anchor == ptep and after it, there is not a 
put_page() call for the anchor.
This is because that we didn't call get_page() either in 
stage2_coalesce_tables_into_block() when
install the block entry. So I think there will not be a problem too.

Is above the right answer for your point?
>>   	}
>>   
>> -	return ret;
>> +	return 0;
> I think it's correct for this function to succeed unconditionally. The error was
> coming from stage2_map_walk_leaf() -> stage2_map_walker_try_leaf(). The function
> can return an error code if block mapping is not supported, which we know is
> supported because we have an anchor, and if only the permissions are different
> between the old and the new entry, but in our case we've changed both the valid
> and type bits.
Agreed. Besides, we will definitely not end up updating an old valid 
entry for the anchor
in stage2_map_walker_try_leaf(), because *anchor has already been 
invalidated in
stage2_map_walk_table_pre() before set the anchor, so it will look like 
a build of new mapping.

Thanks,

Yanan
> Thanks,
>
> Alex
>
>>   }
>>   
>>   /*
> .
