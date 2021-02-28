Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A959327204
	for <lists+kvm@lfdr.de>; Sun, 28 Feb 2021 12:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhB1LMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Feb 2021 06:12:43 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3454 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhB1LMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Feb 2021 06:12:41 -0500
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DpLK54CSsz5XW2;
        Sun, 28 Feb 2021 19:10:17 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Sun, 28 Feb 2021 19:11:56 +0800
Subject: Re: [RFC PATCH 3/4] KVM: arm64: Install the block entry before
 unmapping the page mappings
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, kvm <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-4-wangyanan55@huawei.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <97be4a95-de4f-96f9-1eca-142e9fee8ff6@huawei.com>
Date:   Sun, 28 Feb 2021 19:11:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210208112250.163568-4-wangyanan55@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/8 19:22, Yanan Wang wrote:
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
BTW: Here show the benefit of this patch alone for reference (testing 
based on patch1) .
This patch aims to speed up the reconstruction of block 
mappings(especially for 1G blocks)
after they have been split, and the following test results represent the 
significant change.
Selftest: 
https://lore.kernel.org/lkml/20210208090841.333724-1-wangyanan55@huawei.com/ 


---

hardware platform: HiSilicon Kunpeng920 Server(FWB not supported)
host kernel: Linux mainline v5.11-rc6 (with series of 
https://lore.kernel.org/r/20210114121350.123684-4-wangyanan55@huawei.com 
applied)

multiple vcpus concurrently access 20G memory.
execution time of KVM reconstituting the block mappings after dirty 
logging.

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 20
            (20 vcpus, 20G memory, block mappings(HUGETLB 1G))
Before patch: KVM_ADJUST_MAPPINGS: 2.881s 2.883s 2.885s 2.879s 2.882s
After  patch: KVM_ADJUST_MAPPINGS: 0.310s 0.301s 0.312s 0.299s 0.306s  
*average 89% improvement*

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 40
            (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
Before patch: KVM_ADJUST_MAPPINGS: 2.954s 2.955s 2.949s 2.951s 2.953s
After  patch: KVM_ADJUST_MAPPINGS: 0.381s 0.366s 0.381s 0.380s 0.378s  
*average 87% improvement*

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 60
            (60 vcpus, 20G memory, block mappings(HUGETLB 1G))
Before patch: KVM_ADJUST_MAPPINGS: 3.118s 3.112s 3.130s 3.128s 3.119s
After  patch: KVM_ADJUST_MAPPINGS: 0.524s 0.534s 0.536s 0.525s 0.539s  
*average 83% improvement*

---

Thanks,

Yanan
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
>   1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 78a560446f80..308c36b9cd21 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -434,6 +434,7 @@ struct stage2_map_data {
>   	kvm_pte_t			attr;
>   
>   	kvm_pte_t			*anchor;
> +	kvm_pte_t			*follow;
>   
>   	struct kvm_s2_mmu		*mmu;
>   	struct kvm_mmu_memory_cache	*memcache;
> @@ -553,15 +554,14 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>   	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
>   		return 0;
>   
> -	kvm_set_invalid_pte(ptep);
> -
>   	/*
> -	 * Invalidate the whole stage-2, as we may have numerous leaf
> -	 * entries below us which would otherwise need invalidating
> -	 * individually.
> +	 * If we need to coalesce existing table entries into a block here,
> +	 * then install the block entry first and the sub-level page mappings
> +	 * will be unmapped later.
>   	 */
> -	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
>   	data->anchor = ptep;
> +	data->follow = kvm_pte_follow(*ptep);
> +	stage2_coalesce_tables_into_block(addr, level, ptep, data);
>   	return 0;
>   }
>   
> @@ -614,20 +614,18 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
>   				      kvm_pte_t *ptep,
>   				      struct stage2_map_data *data)
>   {
> -	int ret = 0;
> -
>   	if (!data->anchor)
>   		return 0;
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
>   		data->anchor = NULL;
> -		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
>   	}
>   
> -	return ret;
> +	return 0;
>   }
>   
>   /*
