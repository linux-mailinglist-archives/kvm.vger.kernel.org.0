Return-Path: <kvm+bounces-20354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B0991406F
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 04:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A15501F210A4
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 02:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB094C97;
	Mon, 24 Jun 2024 02:21:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90242D26D;
	Mon, 24 Jun 2024 02:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719195710; cv=none; b=tNBRjZSV0ku2WTcZpVMYZVgaMAu5iX3+7VVoltCVNu9G4JFdaqgn6gvxFZcs77CC3EmnPZw8vU6WmPvBZ+t12+x3Mou+JnEc37VeIhCRoNX6BzC9abAMKcOCA5aQtY9hNkoRD7ewyTB0J8tKH9W8uH+aTltfTPCPxlj4ySLdk+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719195710; c=relaxed/simple;
	bh=o2yuqQo2UjhBB4By8pQIsvFhK/mIbByD/vCWbZUSYjU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gUdFKXcj4U3m0l653hA3DRCmn4OxD9AVnZl5q4KVEmrWk/cfSvbMWMFEYlUmEnAlCFgAzdswpAT5D6oB7WLMMJB8yS6gFWsdMQUs0NFlkhMJlpqShVxMm+1ojdKg+zyhwXYLnbQ6iDrW2pfnE5rXA64AAiyrJrQXV7TPMmw8qpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxe+o52HhmkWUJAA--.38170S3;
	Mon, 24 Jun 2024 10:21:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxfcc22HhmvZIuAA--.46073S3;
	Mon, 24 Jun 2024 10:21:44 +0800 (CST)
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240619080940.2690756-1-maobibo@loongson.cn>
 <20240619080940.2690756-5-maobibo@loongson.cn>
 <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
 <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn>
 <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <379d63cc-375f-3e97-006c-edf7edb4b202@loongson.cn>
Date: Mon, 24 Jun 2024 10:21:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6CzPAxwymk16NfjPGO=oi+iBZJYsdSMiyp2N2cDsw54g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxfcc22HhmvZIuAA--.46073S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFyxKw1rZw18XFWDCw4xZrc_yoW5urW8pr
	ZrAFZ2yFs5Jr9rKws2q3Wjvr10qrWkKF18XFyfWa48ArZIqw1ayr1UJrWakryUCryrCa18
	Xa1DK3Zxu3WUA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8vApUUUUUU==



On 2024/6/24 上午9:56, Huacai Chen wrote:
> On Mon, Jun 24, 2024 at 9:37 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/6/23 下午6:18, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Wed, Jun 19, 2024 at 4:09 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> When updating pmd entry such as allocating new pmd page or splitting
>>>> huge page into normal page, it is necessary to firstly update all pte
>>>> entries, and then update pmd entry.
>>>>
>>>> It is weak order with LoongArch system, there will be problem if other
>>>> vcpus sees pmd update firstly however pte is not updated. Here smp_wmb()
>>>> is added to assure this.
>>> Memory barriers should be in pairs in most cases. That means you may
>>> lose smp_rmb() in another place.
>> The idea adding smp_wmb() comes from function __split_huge_pmd_locked()
>> in file mm/huge_memory.c, and the explanation is reasonable.
>>
>>                   ...
>>                   set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
>>           }
>>           ...
>>           smp_wmb(); /* make pte visible before pmd */
>>           pmd_populate(mm, pmd, pgtable);
>>
>> It is strange that why smp_rmb() should be in pairs with smp_wmb(),
>> I never hear this rule -:(
> https://docs.kernel.org/core-api/wrappers/memory-barriers.html
> 
> SMP BARRIER PAIRING
> -------------------
> 
> When dealing with CPU-CPU interactions, certain types of memory barrier should
> always be paired.  A lack of appropriate pairing is almost certainly an error.
    CPU 1                 CPU 2
         ===============       ===============
         WRITE_ONCE(a, 1);
         <write barrier>
         WRITE_ONCE(b, 2);     x = READ_ONCE(b);
                               <read barrier>
                               y = READ_ONCE(a);

With split_huge scenery to update pte/pmd entry, there is no strong 
relationship between address ptex and pmd.
CPU1
      WRITE_ONCE(pte0, 1);
      WRITE_ONCE(pte511, 1);
      <write barrier>
      WRITE_ONCE(pmd, 2);

However with page table walk scenery, address ptep depends on the 
contents of pmd, so it is not necessary to add smp_rmb().
         ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
         if (!ptep)
                 return no_page_table(vma, flags, address);
         pte = ptep_get(ptep);
         if (!pte_present(pte))

It is just my option, or do you think where smp_rmb() barrier should be 
added in page table reader path?

Regards
Bibo Mao
> 
> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/kvm/mmu.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>>>> index 1690828bd44b..7f04edfbe428 100644
>>>> --- a/arch/loongarch/kvm/mmu.c
>>>> +++ b/arch/loongarch/kvm/mmu.c
>>>> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *kvm,
>>>>
>>>>                           child = kvm_mmu_memory_cache_alloc(cache);
>>>>                           _kvm_pte_init(child, ctx.invalid_ptes[ctx.level - 1]);
>>>> +                       smp_wmb(); /* make pte visible before pmd */
>>>>                           kvm_set_pte(entry, __pa(child));
>>>>                   } else if (kvm_pte_huge(*entry)) {
>>>>                           return entry;
>>>> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu *vcpu, kvm_pte_t *ptep, gfn_t g
>>>>                   val += PAGE_SIZE;
>>>>           }
>>>>
>>>> +       smp_wmb();
>>>>           /* The later kvm_flush_tlb_gpa() will flush hugepage tlb */
>>>>           kvm_set_pte(ptep, __pa(child));
>>>>
>>>> --
>>>> 2.39.3
>>>>
>>
>>


