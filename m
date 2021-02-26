Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26383264FC
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 16:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhBZPwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 10:52:05 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3034 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhBZPv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 10:51:59 -0500
Received: from dggeme752-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DnDcP5R8dzR9gd;
        Fri, 26 Feb 2021 23:49:41 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme752-chm.china.huawei.com (10.3.19.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Fri, 26 Feb 2021 23:51:10 +0800
Subject: Re: [RFC PATCH 1/4] KVM: arm64: Move the clean of dcache to the map
 handler
To:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
CC:     <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-2-wangyanan55@huawei.com>
 <871rd41ngf.wl-maz@kernel.org> <43f05bfa-6b8b-a7d3-4355-0f1486aa6634@arm.com>
 <87wnuwyp90.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <8894b54e-e6fb-dcc2-c46e-8210949a31c4@huawei.com>
Date:   Fri, 26 Feb 2021 23:51:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87wnuwyp90.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggeme752-chm.china.huawei.com (10.3.19.98)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Alex,

On 2021/2/26 2:30, Marc Zyngier wrote:
> On Thu, 25 Feb 2021 17:39:00 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 2/25/21 9:55 AM, Marc Zyngier wrote:
>>> Hi Yanan,
>>>
>>> On Mon, 08 Feb 2021 11:22:47 +0000,
>>> Yanan Wang <wangyanan55@huawei.com> wrote:
>>>> We currently uniformly clean dcache in user_mem_abort() before calling the
>>>> fault handlers, if we take a translation fault and the pfn is cacheable.
>>>> But if there are concurrent translation faults on the same page or block,
>>>> clean of dcache for the first time is necessary while the others are not.
>>>>
>>>> By moving clean of dcache to the map handler, we can easily identify the
>>>> conditions where CMOs are really needed and avoid the unnecessary ones.
>>>> As it's a time consuming process to perform CMOs especially when flushing
>>>> a block range, so this solution reduces much load of kvm and improve the
>>>> efficiency of creating mappings.
>>> That's an interesting approach. However, wouldn't it be better to
>>> identify early that there is already something mapped, and return to
>>> the guest ASAP?
>> Wouldn't that introduce overhead for the common case, when there's
>> only one VCPU that faults on an address? For each data abort caused
>> by a missing stage 2 entry we would now have to determine if the IPA
>> isn't already mapped and that means walking the stage 2 tables.
> The problem is that there is no easy to define "common case". It all
> depends on what you are running in the guest.
>
>> Or am I mistaken and either:
>>
>> (a) The common case is multiple simultaneous translation faults from
>> different VCPUs on the same IPA. Or
>>
>> (b) There's a fast way to check if an IPA is mapped at stage 2 and
>> the overhead would be negligible.
> Checking that something is mapped is simple enough: walk the S2 PT (in
> SW or using AT/PAR), and return early if there is *anything*. You
> already have taken the fault, which is the most expensive part of the
> handling.
I think maybe it could be better to move CMOs (both dcache and icache) 
to the fault handlers.
The map path and permission path are actually a page table walk, and we 
can easily distinguish
between conditions that need CMOs and the ones that don't in the paths 
now.  Why do we have
to add one more PTW early just for identifying the cases of CMOs and 
ignore the existing one?

Besides, if we know in advance there is already something mapped (page 
table is valid), maybe it's
not appropriate to just return early in all cases. What if we are going 
to change the output address(OA)
of the existing table entry? We can't just return in this case. I'm not 
sure whether this is a correct example :).

Actually, moving CMOs to the fault handlers will not ruin the existing 
stage2 page table framework,
and there will not be so much code change. Please see below.
>>> Can you quantify the benefit of this patch alone?
> And this ^^^ part is crucial to evaluating the merit of this patch,
> specially outside of the micro-benchmark space.
The following test results represent the benefit of this patch alone, 
and it's
indicated that the benefit increase as the page table granularity 
increases.
Selftest: 
https://lore.kernel.org/lkml/20210208090841.333724-1-wangyanan55@huawei.com/ 


---
hardware platform: HiSilicon Kunpeng920 Server(FWB not supported)
host kernel: Linux mainline v5.11-rc6 (with series of 
https://lore.kernel.org/r/20210114121350.123684-4-wangyanan55@huawei.com 
applied)

(1) multiple vcpus concurrently access 1G memory.
     execution time of: a) KVM create new page mappings(normal 4K), b) 
update the mappings from RO to RW.

cmdline: ./kvm_page_table_test -m 4 -t 0 -g 4K -s 1G -v 50
            (50 vcpus, 1G memory, page mappings(normal 4K))
a) Before patch: KVM_CREATE_MAPPINGS: 62.752s 62.123s 61.733s 62.562s 
61.847s
    After  patch: KVM_CREATE_MAPPINGS: 58.800s 58.364s 58.163s 58.370s 
58.677s *average 7% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 49.083s 49.920s 49.484s 49.551s 
49.410s
    After  patch: KVM_UPDATE_MAPPINGS: 48.723s 49.259s 49.204s 48.207s 
49.112s *no change*

cmdline: ./kvm_page_table_test -m 4 -t 0 -g 4K -s 1G -v 100
            (100 vcpus, 1G memory, page mappings(normal 4K))
a) Before patch: KVM_CREATE_MAPPINGS: 129.70s 129.66s 126.78s 126.07s 
130.21s
    After  patch: KVM_CREATE_MAPPINGS: 120.69s 120.28s 120.68s 121.09s 
121.34s *average 9% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 94.097s 94.501s 92.589s 93.957s 
94.317s
    After  patch: KVM_UPDATE_MAPPINGS: 93.677s 93.701s 93.036s 93.484s 
93.584s *no change*

(2) multiple vcpus concurrently access 20G memory.
     execution time of: a) KVM create new block mappings(THP 2M), b) 
split the blocks in dirty logging, c) reconstitute the blocks after 
dirty logging.

cmdline: ./kvm_page_table_test -m 4 -t 1 -g 2M -s 20G -v 20
            (20 vcpus, 20G memory, block mappings(THP 2M))
a) Before patch: KVM_CREATE_MAPPINGS: 12.546s 13.300s 12.448s 12.496s 
12.420s
    After  patch: KVM_CREATE_MAPPINGS:  5.679s  5.773s  5.759s 5.698s  
5.835s *average 54% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 78.510s 78.026s 80.813s 80.681s 
81.671s
    After  patch: KVM_UPDATE_MAPPINGS: 52.820s 57.652s 51.390s 56.468s 
60.070s *average 30% improvement*
c) Before patch: KVM_ADJUST_MAPPINGS: 82.617s 83.551s 83.839s 83.844s 
85.416s
    After  patch: KVM_ADJUST_MAPPINGS: 61.208s 57.212s 58.473s 57.521s 
64.364s *average 30% improvement*

cmdline: ./kvm_page_table_test -m 4 -t 1 -g 2M -s 20G -v 40
            (40 vcpus, 20G memory, block mappings(THP 2M))
a) Before patch: KVM_CREATE_MAPPINGS: 13.226s 13.986s 13.671s 13.697s 
13.077s
    After  patch: KVM_CREATE_MAPPINGS:  7.274s  7.139s  7.257s 7.012s  
7.076s *average 48% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 173.70s 177.45s 178.68s 175.45s 
175.50s
    After  patch: KVM_UPDATE_MAPPINGS: 129.62s 131.61s 131.36s 123.58s 
131.73s *average 28% improvement*
c) Before patch: KVM_ADJUST_MAPPINGS: 179.96s 179.61s 182.01s 181.35s 
181.11s
    After  patch: KVM_ADJUST_MAPPINGS: 137.74s 139.92s 139.79s 132.52s 
140.30s *average 25% improvement*

(3) multiple vcpus concurrently access 20G memory.
     execution time of: a) KVM create new block mappings(HUGETLB 1G), b) 
split the blocks in dirty logging, c) reconstitute the blocks after 
dirty logging.

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 20
            (20 vcpus, 20G memory, block mappings(HUGETLB 1G))
a) Before patch: KVM_CREATE_MAPPINGS: 52.808s 52.814s 52.826s 52.833s 
52.809s
    After  patch: KVM_CREATE_MAPPINGS:  3.701s  3.700s  3.702s 3.701s  
3.706s *average 93% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 80.886s 80.582s 78.190s 79.964s 
80.561s
    After  patch: KVM_UPDATE_MAPPINGS: 55.546s 53.800s 57.103s 56.278s 
56.372s *average 30% improvement*
c) Before patch: KVM_ADJUST_MAPPINGS: 52.027s 52.031s 52.026s 52.027s 
52.024s
    After  patch: KVM_ADJUST_MAPPINGS:  2.881s  2.883s  2.885s 2.879s  
2.882s *average 95% improvement*

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 40
            (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
a) Before patch: KVM_CREATE_MAPPINGS: 104.51s 104.53s 104.52s 104.53s 
104.52s
    After  patch: KVM_CREATE_MAPPINGS:  3.698s  3.699s  3.726s 3.700s  
3.697s *average 96% improvement*
b) Before patch: KVM_UPDATE_MAPPINGS: 171.75s 173.73s 172.11s 173.39s 
170.69s
    After  patch: KVM_UPDATE_MAPPINGS: 126.66s 128.69s 126.59s 120.54s 
127.08s *average 28% improvement*
c) Before patch: KVM_ADJUST_MAPPINGS: 103.93s 103.94s 103.90s 103.78s 
103.78s
    After  patch: KVM_ADJUST_MAPPINGS:  2.954s  2.955s  2.949s 2.951s  
2.953s *average 97% improvement*
>>>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>>>> ---
>>>>   arch/arm64/include/asm/kvm_mmu.h | 16 --------------
>>>>   arch/arm64/kvm/hyp/pgtable.c     | 38 ++++++++++++++++++++------------
>>>>   arch/arm64/kvm/mmu.c             | 14 +++---------
>>>>   3 files changed, 27 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>>>> index e52d82aeadca..4ec9879e82ed 100644
>>>> --- a/arch/arm64/include/asm/kvm_mmu.h
>>>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>>>> @@ -204,22 +204,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>>>>   	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>>>>   }
>>>>   
>>>> -static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>>> -{
>>>> -	void *va = page_address(pfn_to_page(pfn));
>>>> -
>>>> -	/*
>>>> -	 * With FWB, we ensure that the guest always accesses memory using
>>>> -	 * cacheable attributes, and we don't have to clean to PoC when
>>>> -	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
>>>> -	 * PoU is not required either in this case.
>>>> -	 */
>>>> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>>>> -		return;
>>>> -
>>>> -	kvm_flush_dcache_to_poc(va, size);
>>>> -}
>>>> -
>>>>   static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>>>>   						  unsigned long size)
>>>>   {
>>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>>> index 4d177ce1d536..2f4f87021980 100644
>>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>>> @@ -464,6 +464,26 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>>>>   	return 0;
>>>>   }
>>>>   
>>>> +static bool stage2_pte_cacheable(kvm_pte_t pte)
>>>> +{
>>>> +	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>>>> +	return memattr == PAGE_S2_MEMATTR(NORMAL);
>>>> +}
>>>> +
>>>> +static void stage2_flush_dcache(void *addr, u64 size)
>>>> +{
>>>> +	/*
>>>> +	 * With FWB, we ensure that the guest always accesses memory using
>>>> +	 * cacheable attributes, and we don't have to clean to PoC when
>>>> +	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
>>>> +	 * PoU is not required either in this case.
>>>> +	 */
>>>> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>>>> +		return;
>>>> +
>>>> +	__flush_dcache_area(addr, size);
>>>> +}
>>>> +
>>>>   static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>>>   				      kvm_pte_t *ptep,
>>>>   				      struct stage2_map_data *data)
>>>> @@ -495,6 +515,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>>>>   		put_page(page);
>>>>   	}
>>>>   
>>>> +	/* Flush data cache before installation of the new PTE */
>>>> +	if (stage2_pte_cacheable(new))
>>>> +		stage2_flush_dcache(__va(phys), granule);
>>>> +
>>>>   	smp_store_release(ptep, new);
>>>>   	get_page(page);
>>>>   	data->phys += granule;
>>>> @@ -651,20 +675,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>>>   	return ret;
>>>>   }
>>>>   
>>>> -static void stage2_flush_dcache(void *addr, u64 size)
>>>> -{
>>>> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
>>>> -		return;
>>>> -
>>>> -	__flush_dcache_area(addr, size);
>>>> -}
>>>> -
>>>> -static bool stage2_pte_cacheable(kvm_pte_t pte)
>>>> -{
>>>> -	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
>>>> -	return memattr == PAGE_S2_MEMATTR(NORMAL);
>>>> -}
>>>> -
>>>>   static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>>>   			       enum kvm_pgtable_walk_flags flag,
>>>>   			       void * const arg)
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 77cb2d28f2a4..d151927a7d62 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -609,11 +609,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>>>   	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>>>>   }
>>>>   
>>>> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>>> -{
>>>> -	__clean_dcache_guest_page(pfn, size);
>>>> -}
>>>> -
>>>>   static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>>>>   {
>>>>   	__invalidate_icache_guest_page(pfn, size);
>>>> @@ -882,9 +877,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>   	if (writable)
>>>>   		prot |= KVM_PGTABLE_PROT_W;
>>>>   
>>>> -	if (fault_status != FSC_PERM && !device)
>>>> -		clean_dcache_guest_page(pfn, vma_pagesize);
>>>> -
>>>>   	if (exec_fault) {
>>>>   		prot |= KVM_PGTABLE_PROT_X;
>>>>   		invalidate_icache_guest_page(pfn, vma_pagesize);
>>> It seems that the I-side CMO now happens *before* the D-side, which
>>> seems odd. What prevents the CPU from speculatively fetching
>>> instructions in the interval? I would also feel much more confident if
>>> the two were kept close together.
>> I noticed yet another thing which I don't understand. When the CPU
>> has the ARM64_HAS_CACHE_DIC featue (CTR_EL0.DIC = 1), which means
>> instruction invalidation is not required for data to instruction
>> coherence, we still do the icache invalidation. I am wondering if
>> the invalidation is necessary in this case.
> It isn't, and DIC is already taken care of in the leaf functions (see
> __flush_icache_all() and invalidate_icache_range()).
Then it will be more simple to also move icache invalidation to both the 
map path and permission path.
We can check whether the executable permission is going to be added to 
the old mapping through the
new PTE, and perform CMO of the icache if it is. The diff like below may 
work, what do you think ?

---

diff --git a/arch/arm64/include/asm/kvm_mmu.h 
b/arch/arm64/include/asm/kvm_mmu.h
index 4ec9879e82ed..534d42da2065 100644
  - - - a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -204,21 +204,6 @@ static inline bool vcpu_has_cache_enabled(struct 
kvm_vcpu *vcpu)
         return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
  }

-static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
-                                                 unsigned long size)
-{
-       if (icache_is_aliasing()) {
-               /* any kind of VIPT cache */
-               __flush_icache_all();
-       } else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
-               /* PIPT or VPIPT at EL2 (see comment in 
__kvm_tlb_flush_vmid_ipa) */
-               void *va = page_address(pfn_to_page(pfn));
-
-               invalidate_icache_range((unsigned long)va,
-                                       (unsigned long)va + size);
-       }
-}
-
  void kvm_set_way_flush(struct kvm_vcpu *vcpu);
  void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 308c36b9cd21..950102077676 100644
  - - - a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -120,7 +120,6 @@ static bool kvm_pte_valid(kvm_pte_t pte)
  {
         return pte & KVM_PTE_VALID;
  }
-
  static bool kvm_pte_table(kvm_pte_t pte, u32 level)
  {
         if (level == KVM_PGTABLE_MAX_LEVELS - 1)
@@ -485,6 +484,18 @@ static void stage2_flush_dcache(void *addr, u64 size)
         __flush_dcache_area(addr, size);
  }

+static void stage2_invalidate_icache(void *addr, u64 size)
+{
+       if (icache_is_aliasing()) {
+               /* Flush any kind of VIPT icache */
+               __flush_icache_all();
+       } else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
+               /* Flush PIPT or VPIPT icache at EL2 */
+               invalidate_icache_range((unsigned long)addr,
+                                       (unsigned long)addr + size);
+       }
+}
+
  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
                                       kvm_pte_t *ptep,
                                       struct stage2_map_data *data)
@@ -516,7 +527,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 
end, u32 level,
                 put_page(page);
         }

  -       /* Flush data cache before installation of the new PTE */
+       /* Perform CMOs before installation of the new PTE */
+       if (!(new & KVM_PTE_LEAF_ATTR_HI_S2_XN))
+               stage2_invalidate_icache(__va(phys), granule);
+
         if (stage2_pte_cacheable(new))
                 stage2_flush_dcache(__va(phys), granule);

@@ -769,8 +783,16 @@ static int stage2_attr_walker(u64 addr, u64 end, 
u32 level, kvm_pte_t *ptep,
          * but worst-case the access flag update gets lost and will be
          * set on the next access instead.
          */
  -       if (data->pte != pte)
+       if (data->pte != pte) {
+               /*
+                * Invalidate the instruction cache before updating
+                * if we are going to add the executable permission.
+                */
+               if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
+ stage2_invalidate_icache(kvm_pte_follow(pte),
+ kvm_granule_size(level));
                 WRITE_ONCE(*ptep, pte);
+       }

         return 0;
  }

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d151927a7d62..1eec9f63bc6f 100644
  - - - a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -609,11 +609,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct 
kvm *kvm,
         kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
  }

-static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long 
size)
-{
-       __invalidate_icache_guest_page(pfn, size);
-}
-
  static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
  {
         send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, 
current);
@@ -877,10 +872,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
         if (writable)
                 prot |= KVM_PGTABLE_PROT_W;

  -       if (exec_fault) {
+       if (exec_fault)
                 prot |= KVM_PGTABLE_PROT_X;
-               invalidate_icache_guest_page(pfn, vma_pagesize);
-       }

         if (device)
                 prot |= KVM_PGTABLE_PROT_DEVICE;

---

Thanks,

Yanan
>> If it's not, then I think it's correct (and straightforward) to move
>> the icache invalidation to stage2_map_walker_try_leaf() after the
>> dcache clean+inval and make it depend on the new mapping being
>> executable *and* !cpus_have_const_cap(ARM64_HAS_CACHE_DIC).
> It would also need to be duplicated on the permission fault path.
>
> Thanks,
>
> 	M.
>
