Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0913832A77F
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449236AbhCBQQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:16:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13457 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447957AbhCBNyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 08:54:36 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dqbjs4k32zjVL7;
        Tue,  2 Mar 2021 20:17:37 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 20:19:09 +0800
Subject: Re: [RFC PATCH] kvm: arm64: Try stage2 block mapping for host device
 MMIO
To:     Marc Zyngier <maz@kernel.org>
References: <20210122083650.21812-1-zhukeqian1@huawei.com>
 <09d89355cdbbd19c456699774a9a980a@kernel.org>
 <e4836dbc-4f7f-15fe-7b2c-e70bd2909bb7@huawei.com>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <8fda1c07-7f6e-065b-c3a1-5f6fa1aeb316@huawei.com>
Date:   Tue, 2 Mar 2021 20:19:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <e4836dbc-4f7f-15fe-7b2c-e70bd2909bb7@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Do you have further suggestion on this? Block mapping do bring obvious benefit.

Thanks,
Keqian

On 2021/1/25 19:25, Keqian Zhu wrote:
> Hi Marc,
> 
> On 2021/1/22 17:45, Marc Zyngier wrote:
>> On 2021-01-22 08:36, Keqian Zhu wrote:
>>> The MMIO region of a device maybe huge (GB level), try to use block
>>> mapping in stage2 to speedup both map and unmap.
>>>
>>> Especially for unmap, it performs TLBI right after each invalidation
>>> of PTE. If all mapping is of PAGE_SIZE, it takes much time to handle
>>> GB level range.
>>
>> This is only on VM teardown, right? Or do you unmap the device more ofet?
>> Can you please quantify the speedup and the conditions this occurs in?
> 
> Yes, and there are some other paths (includes what your patch series handles) will do the unmap action:
> 
> 1、guest reboot without S2FWB: stage2_unmap_vm（）which only unmaps guest regular RAM.
> 2、userspace deletes memslot: kvm_arch_flush_shadow_memslot().
> 3、rollback of device MMIO mapping: kvm_arch_prepare_memory_region().
> 4、rollback of dirty log tracking: If we enable hugepage for guest RAM, after dirty log is stopped,
>                                    the newly created block mappings will unmap all page mappings.
> 5、mmu notifier: kvm_unmap_hva_range(). AFAICS, we will use this path when VM teardown or guest resets pass-through devices.
>                                         The bugfix[1] gives the reason for unmapping MMIO region when guest resets pass-through devices.
> 
> unmap related to MMIO region, as this patch solves:
> point 1 is not applied.
> point 2 occurs when userspace unplug pass-through devices.
> point 3 can occurs, but rarely.
> point 4 is not applied.
> point 5 occurs when VM teardown or guest resets pass-through devices.
> 
> And I had a look at your patch series, it can solve:
> For VM teardown, elide CMO and perform VMALL instead of individually (But current kernel do not go through this path when VM teardown).
> For rollback of dirty log tracking, elide CMO.
> For kvm_unmap_hva_range, if event is MMU_NOTIFY_UNMAP. elide CMO.
> 
> (But I doubt the CMOs in unmap. As we perform CMOs in user_mem_abort when install new stage2 mapping for VM,
>  maybe the CMO in unmap is unnecessary under all conditions :-) ?)
> 
> So it shows that we are solving different parts of unmap, so they are not conflicting. At least this patch can
> still speedup map of device MMIO region, and speedup unmap of device MMIO region even if we do not need to perform
> CMO and TLBI ;-).
> 
> speedup: unmap 8GB MMIO on FPGA.
> 
>            before            after opt
> cost    30+ minutes            949ms
> 
> Thanks,
> Keqian
> 
>>
>> I have the feeling that we are just circling around another problem,
>> which is that we could rely on a VM-wide TLBI when tearing down the
>> guest. I worked on something like that[1] a long while ago, and parked
>> it for some reason. Maybe it is worth reviving.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/elide-cmo-tlbi
>>
>>>
>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>>>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++++++++++
>>>  arch/arm64/kvm/mmu.c                 | 12 ++++++++----
>>>  3 files changed, 34 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h
>>> b/arch/arm64/include/asm/kvm_pgtable.h
>>> index 52ab38db04c7..2266ac45f10c 100644
>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>> @@ -82,6 +82,17 @@ struct kvm_pgtable_walker {
>>>      const enum kvm_pgtable_walk_flags    flags;
>>>  };
>>>
>>> +/**
>>> + * kvm_supported_pgsize() - Get the max supported page size of a mapping.
>>> + * @pgt:    Initialised page-table structure.
>>> + * @addr:    Virtual address at which to place the mapping.
>>> + * @end:    End virtual address of the mapping.
>>> + * @phys:    Physical address of the memory to map.
>>> + *
>>> + * The smallest return value is PAGE_SIZE.
>>> + */
>>> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys);
>>> +
>>>  /**
>>>   * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
>>>   * @pgt:    Uninitialised page-table structure to initialise.
>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>> index bdf8e55ed308..ab11609b9b13 100644
>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>> @@ -81,6 +81,21 @@ static bool kvm_block_mapping_supported(u64 addr,
>>> u64 end, u64 phys, u32 level)
>>>      return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
>>>  }
>>>
>>> +u64 kvm_supported_pgsize(struct kvm_pgtable *pgt, u64 addr, u64 end, u64 phys)
>>> +{
>>> +    u32 lvl;
>>> +    u64 pgsize = PAGE_SIZE;
>>> +
>>> +    for (lvl = pgt->start_level; lvl < KVM_PGTABLE_MAX_LEVELS; lvl++) {
>>> +        if (kvm_block_mapping_supported(addr, end, phys, lvl)) {
>>> +            pgsize = kvm_granule_size(lvl);
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    return pgsize;
>>> +}
>>> +
>>>  static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>>>  {
>>>      u64 shift = kvm_granule_shift(level);
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 7d2257cc5438..80b403fc8e64 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -499,7 +499,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>>                phys_addr_t pa, unsigned long size, bool writable)
>>>  {
>>> -    phys_addr_t addr;
>>> +    phys_addr_t addr, end;
>>> +    unsigned long pgsize;
>>>      int ret = 0;
>>>      struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
>>>      struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>>> @@ -509,21 +510,24 @@ int kvm_phys_addr_ioremap(struct kvm *kvm,
>>> phys_addr_t guest_ipa,
>>>
>>>      size += offset_in_page(guest_ipa);
>>>      guest_ipa &= PAGE_MASK;
>>> +    end = guest_ipa + size;
>>>
>>> -    for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
>>> +    for (addr = guest_ipa; addr < end; addr += pgsize) {
>>>          ret = kvm_mmu_topup_memory_cache(&cache,
>>>                           kvm_mmu_cache_min_pages(kvm));
>>>          if (ret)
>>>              break;
>>>
>>> +        pgsize = kvm_supported_pgsize(pgt, addr, end, pa);
>>> +
>>>          spin_lock(&kvm->mmu_lock);
>>> -        ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
>>> +        ret = kvm_pgtable_stage2_map(pgt, addr, pgsize, pa, prot,
>>>                           &cache);
>>>          spin_unlock(&kvm->mmu_lock);
>>>          if (ret)
>>>              break;
>>>
>>> -        pa += PAGE_SIZE;
>>> +        pa += pgsize;
>>>      }
>>>
>>>      kvm_mmu_free_memory_cache(&cache);
>>
>> This otherwise looks neat enough.
>>
>> Thanks,
>>
>>         M.
> .
> 
