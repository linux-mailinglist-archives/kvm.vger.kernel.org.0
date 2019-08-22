Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11A2F995F1
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbfHVOJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 10:09:44 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:4515 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfHVOJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 10:09:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566482981; x=1598018981;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eCn/K9P5qGMkwzO+Xm7KYd8V50DjivDXIT1JFbq88cA=;
  b=KsEW5ooZKR/kjxCTj2JHaI0PAtZT+oa340ps0V1sipJwenShzwYDuPIH
   tqg/axM/CKUVJFz2a9LEFsg0pfyuGCxl8mkro6V/d7e+nExLFAzHsxv4y
   u6MZyhyhdXAMQO7dqXsDuEio80yYixt2AZUN9cvEuwUyYMKKvGtWe4Y7o
   o=;
X-IronPort-AV: E=Sophos;i="5.64,416,1559520000"; 
   d="scan'208";a="411115419"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Aug 2019 14:09:39 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id EEF1DA2A00;
        Thu, 22 Aug 2019 14:09:38 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 14:09:38 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.160.167) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 22 Aug 2019 14:09:34 +0000
Subject: Re: [PATCH v5 13/20] RISC-V: KVM: Implement stage2 page table
 programming
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <20190822084131.114764-14-anup.patel@wdc.com>
 <77b9ff3c-292f-ee17-ddbb-134c0666fde7@amazon.com>
 <CAAhSdy1h+m0gA2pro-XAb4qhe0Q+8knjW+8+6jaz3efOdKWskA@mail.gmail.com>
 <a44f86ac-8902-0aa3-1eee-013ac97d667b@amazon.com>
 <CAAhSdy20D=t5hbeWDi=1XmNAe5rwvNyjMth-WUwrVe+HcagVpg@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <58899115-88a3-5167-2ed4-886498648f63@amazon.com>
Date:   Thu, 22 Aug 2019 16:09:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy20D=t5hbeWDi=1XmNAe5rwvNyjMth-WUwrVe+HcagVpg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.167]
X-ClientProxiedBy: EX13D24UWB001.ant.amazon.com (10.43.161.93) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.08.19 15:58, Anup Patel wrote:
> On Thu, Aug 22, 2019 at 6:57 PM Alexander Graf <graf@amazon.com> wrote:
>>
>>
>>
>> On 22.08.19 14:38, Anup Patel wrote:
>>> On Thu, Aug 22, 2019 at 5:58 PM Alexander Graf <graf@amazon.com> wrote:
>>>>
>>>> On 22.08.19 10:45, Anup Patel wrote:
>>>>> This patch implements all required functions for programming
>>>>> the stage2 page table for each Guest/VM.
>>>>>
>>>>> At high-level, the flow of stage2 related functions is similar
>>>>> from KVM ARM/ARM64 implementation but the stage2 page table
>>>>> format is quite different for KVM RISC-V.
>>>>>
>>>>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
>>>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>>>> ---
>>>>>     arch/riscv/include/asm/kvm_host.h     |  10 +
>>>>>     arch/riscv/include/asm/pgtable-bits.h |   1 +
>>>>>     arch/riscv/kvm/mmu.c                  | 637 +++++++++++++++++++++++++-
>>>>>     3 files changed, 638 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>>>>> index 3b09158f80f2..a37775c92586 100644
>>>>> --- a/arch/riscv/include/asm/kvm_host.h
>>>>> +++ b/arch/riscv/include/asm/kvm_host.h
>>>>> @@ -72,6 +72,13 @@ struct kvm_mmio_decode {
>>>>>         int shift;
>>>>>     };
>>>>>
>>>>> +#define KVM_MMU_PAGE_CACHE_NR_OBJS   32
>>>>> +
>>>>> +struct kvm_mmu_page_cache {
>>>>> +     int nobjs;
>>>>> +     void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
>>>>> +};
>>>>> +
>>>>>     struct kvm_cpu_context {
>>>>>         unsigned long zero;
>>>>>         unsigned long ra;
>>>>> @@ -163,6 +170,9 @@ struct kvm_vcpu_arch {
>>>>>         /* MMIO instruction details */
>>>>>         struct kvm_mmio_decode mmio_decode;
>>>>>
>>>>> +     /* Cache pages needed to program page tables with spinlock held */
>>>>> +     struct kvm_mmu_page_cache mmu_page_cache;
>>>>> +
>>>>>         /* VCPU power-off state */
>>>>>         bool power_off;
>>>>>
>>>>> diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
>>>>> index bbaeb5d35842..be49d62fcc2b 100644
>>>>> --- a/arch/riscv/include/asm/pgtable-bits.h
>>>>> +++ b/arch/riscv/include/asm/pgtable-bits.h
>>>>> @@ -26,6 +26,7 @@
>>>>>
>>>>>     #define _PAGE_SPECIAL   _PAGE_SOFT
>>>>>     #define _PAGE_TABLE     _PAGE_PRESENT
>>>>> +#define _PAGE_LEAF      (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC)
>>>>>
>>>>>     /*
>>>>>      * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
>>>>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>>>>> index 2b965f9aac07..9e95ab6769f6 100644
>>>>> --- a/arch/riscv/kvm/mmu.c
>>>>> +++ b/arch/riscv/kvm/mmu.c
>>>>> @@ -18,6 +18,432 @@
>>>>>     #include <asm/page.h>
>>>>>     #include <asm/pgtable.h>
>>>>>
>>>>> +#ifdef CONFIG_64BIT
>>>>> +#define stage2_have_pmd              true
>>>>> +#define stage2_gpa_size              ((phys_addr_t)(1ULL << 39))
>>>>> +#define stage2_cache_min_pages       2
>>>>> +#else
>>>>> +#define pmd_index(x)         0
>>>>> +#define pfn_pmd(x, y)                ({ pmd_t __x = { 0 }; __x; })
>>>>> +#define stage2_have_pmd              false
>>>>> +#define stage2_gpa_size              ((phys_addr_t)(1ULL << 32))
>>>>> +#define stage2_cache_min_pages       1
>>>>> +#endif
>>>>> +
>>>>> +static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
>>>>> +                           int min, int max)
>>>>> +{
>>>>> +     void *page;
>>>>> +
>>>>> +     BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
>>>>> +     if (pcache->nobjs >= min)
>>>>> +             return 0;
>>>>> +     while (pcache->nobjs < max) {
>>>>> +             page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
>>>>> +             if (!page)
>>>>> +                     return -ENOMEM;
>>>>> +             pcache->objects[pcache->nobjs++] = page;
>>>>> +     }
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
>>>>> +{
>>>>> +     while (pcache && pcache->nobjs)
>>>>> +             free_page((unsigned long)pcache->objects[--pcache->nobjs]);
>>>>> +}
>>>>> +
>>>>> +static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
>>>>> +{
>>>>> +     void *p;
>>>>> +
>>>>> +     if (!pcache)
>>>>> +             return NULL;
>>>>> +
>>>>> +     BUG_ON(!pcache->nobjs);
>>>>> +     p = pcache->objects[--pcache->nobjs];
>>>>> +
>>>>> +     return p;
>>>>> +}
>>>>> +
>>>>> +struct local_guest_tlb_info {
>>>>> +     struct kvm_vmid *vmid;
>>>>> +     gpa_t addr;
>>>>> +};
>>>>> +
>>>>> +static void local_guest_tlb_flush_vmid_gpa(void *info)
>>>>> +{
>>>>> +     struct local_guest_tlb_info *infop = info;
>>>>> +
>>>>> +     __kvm_riscv_hfence_gvma_vmid_gpa(READ_ONCE(infop->vmid->vmid_version),
>>>>> +                                      infop->addr);
>>>>> +}
>>>>> +
>>>>> +static void stage2_remote_tlb_flush(struct kvm *kvm, gpa_t addr)
>>>>> +{
>>>>> +     struct local_guest_tlb_info info;
>>>>> +     struct kvm_vmid *vmid = &kvm->arch.vmid;
>>>>> +
>>>>> +     /* TODO: This should be SBI call */
>>>>> +     info.vmid = vmid;
>>>>> +     info.addr = addr;
>>>>> +     preempt_disable();
>>>>> +     smp_call_function_many(cpu_all_mask, local_guest_tlb_flush_vmid_gpa,
>>>>> +                            &info, true);
>>>>
>>>> This is all nice and dandy on the toy 4 core systems we have today, but
>>>> it will become a bottleneck further down the road.
>>>>
>>>> How many VMIDs do you have? Could you just allocate a new one every time
>>>> you switch host CPUs? Then you know exactly which CPUs to flush by
>>>> looking at all your vcpu structs and a local field that tells you which
>>>> pCPU they're on at this moment.
>>>>
>>>> Either way, it's nothing that should block inclusion. For today, we're fine.
>>>
>>> We are not happy about this either.
>>>
>>> Other two options, we have are:
>>> 1. Have SBI calls for remote HFENCEs
>>> 2. Propose RISC-V ISA extension for remote FENCEs
>>>
>>> Option1 is mostly extending SBI spec and implementing it in runtime
>>> firmware.
>>>
>>> Option2 is ideal solution but requires consensus among wider audience
>>> in RISC-V foundation.
>>>
>>> At this point, we are fine with a simple solution.
>>
>> It's fine to explicitly IPI other CPUs to flush their TLBs. What is not
>> fine is to IPI *all* CPUs to flush their TLBs.
> 
> Ahh, this should have been cpu_online_mask instead of cpu_all_mask
> 
> I will update this in next revision.

What I was trying to say is that you only want to flush currently 
running other vcpus and add a hint for all the others saying "please 
flush the next time you come up".

I think we had a mechanism for that somewhere in the EVENT magic.

But as I said, this is a performance optimization - that's something I'm 
happy to delay. Security and user space ABI are the bits I'm worried 
about at this stage.


Alex
