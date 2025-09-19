Return-Path: <kvm+bounces-58109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23256B879F9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31DC7E6E8F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BFF247284;
	Fri, 19 Sep 2025 01:40:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB55E34BA29;
	Fri, 19 Sep 2025 01:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758246002; cv=none; b=T5YMHkZWK3TMBDJRxRMQxDTX3If8eIdd2f6XuOdYedGTXpNt/HXCSMENhHhQSQZivizn0CDXVOQb7impUrHRlSMk4MhdI1H4iCvL4VvCqbXHn8cK3kkx2Eq9tkY2gsT4eP5skoOjb3l42exgdWHMlQM6jm687R6JrTKTyaZ0tU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758246002; c=relaxed/simple;
	bh=QkVwto4FoSVDUqJ7/ZjcZwZ0G2bU4P9E42N+ULx1FxQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D17rmAoKrdv2vrJCvuPrArdEp/8xxMssG1Yvx3ieA9vTMexaiiCoywJ/p92YTAmZ4x9x2byF79jO0XSWg0X6IGwBTiizijQlT99LvlRnKPCSw7jpW795JYYwv0xWrCrTg+IYFwf0BPnvT8uzAlfMslmHZ52eFTs0/tD9Gj2spkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxE9BktMxoMREMAA--.25550S3;
	Fri, 19 Sep 2025 09:39:48 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxrcFgtMxoxb2eAA--.23502S3;
	Fri, 19 Sep 2025 09:39:46 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250910071429.3925025-1-maobibo@loongson.cn>
 <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
 <3d3a72c2-7c91-7640-5f0b-7b95bd5f0d2e@loongson.cn>
 <CAAhV-H4bEyeV7WkfSNBJnicMhhnSwj3PEr9K4ZpXwto1=JyWUw@mail.gmail.com>
 <ff12ec30-b0df-aedd-a713-4fb77a4e092a@loongson.cn>
 <CAAhV-H7AhUijxaW5oS6s4hCtWyEOgx8iaku2KhbK_6mZbRHYHQ@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <dc654dc5-e00a-9599-2238-40366942cc9c@loongson.cn>
Date: Fri, 19 Sep 2025 09:37:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7AhUijxaW5oS6s4hCtWyEOgx8iaku2KhbK_6mZbRHYHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxrcFgtMxoxb2eAA--.23502S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3ZF1rAFW8Zr1xXw15Gr1xWFX_yoWDur47pF
	W8GF4UAr48Jr17GrW2g3WqqrnrtrsrKF1xXF1UKw1UGF1Dtr1UZF18WrWY9F18J348G3W7
	XF45Jry3W3y3tabCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU25EfUUUU
	U



On 2025/9/18 下午6:54, Huacai Chen wrote:
> On Wed, Sep 17, 2025 at 9:11 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/9/16 下午10:21, Huacai Chen wrote:
>>> On Mon, Sep 15, 2025 at 9:22 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2025/9/14 上午9:57, Huacai Chen wrote:
>>>>> Hi, Bibo,
>>>>>
>>>>> On Wed, Sep 10, 2025 at 3:14 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>> With PTW disabled system, bit Dirty is HW bit for page writing, however
>>>>>> with PTW enabled system, bit Write is HW bit for page writing. Previously
>>>>>> bit Write is treated as SW bit to record page writable attribute for fast
>>>>>> page fault handling in the secondary MMU, however with PTW enabled machine,
>>>>>> this bit is used by HW already.
>>>>>>
>>>>>> Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that it can
>>>>>> work on both PTW disabled and enabled machines. And with HW write bit, both
>>>>>> bit Dirty and Write is set or clear.
>>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>>     arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
>>>>>>     arch/loongarch/kvm/mmu.c             |  8 ++++----
>>>>>>     2 files changed, 20 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/include/asm/kvm_mmu.h
>>>>>> index 099bafc6f797..efcd593c42b1 100644
>>>>>> --- a/arch/loongarch/include/asm/kvm_mmu.h
>>>>>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
>>>>>> @@ -16,6 +16,13 @@
>>>>>>      */
>>>>>>     #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
>>>>>>
>>>>>> +/*
>>>>>> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
>>>>>> + * kernel, on secondary MMU it records page writable in order to fast
>>>>>> + * path handling
>>>>>> + */
>>>>>> +#define KVM_PAGE_SOFT_WRITE    _PAGE_MODIFIED
>>>>> KVM_PAGE_WRITEABLE is more suitable.
>>>> both are ok for me.
>>>>>
>>>>>> +
>>>>>>     #define _KVM_FLUSH_PGTABLE     0x1
>>>>>>     #define _KVM_HAS_PGMASK                0x2
>>>>>>     #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
>>>>>> @@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte_t val)
>>>>>>            WRITE_ONCE(*ptep, val);
>>>>>>     }
>>>>>>
>>>>>> -static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRITE; }
>>>>>> -static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRTY; }
>>>>>> +static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & KVM_PAGE_SOFT_WRITE; }
>>>>> The same, kvm_pte_mkwriteable() is more suitable.
>>>> kvm_pte_writable()  here ?  and kvm_pte_mkwriteable() for the bellowing
>>>> sentense.
>>>>
>>>> If so, that is ok, both are ok for me.
>>> Yes.
>>>
>>>>>
>>>>>> +static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRITEABLE; }
>>>>> _PAGE_DIRTY and _PAGE_WRITE are always set/cleared at the same time,
>>>>> so the old version still works.
>>>> Although it is workable, I still want to remove single bit _PAGE_DIRTY
>>>> checking here.
>>> I want to check a single bit because "kvm_pte_write() return
>>> _PAGE_WRITE and kvm_pte_dirty() return _PAGE_DIRTY" looks more
>>> natural.
>> kvm_pte_write() is not needed any more and removed here. This is only
>> kvm_pte_writable() to check software writable bit, kvm_pte_dirty() to
>> check HW write bit.
>>
>> There is no reason to check single bit with _PAGE_WRITE or _PAGE_DIRTY,
>> since there is different meaning on machines with/without HW PTW.
> Applied together with other patches, you can test it.
> https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git/log/?h=loongarch-next
yes, this branch passes to migrate on PTW enabled machines such as 3C6000.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> You may argue that kvm_pte_mkdirty() set both _PAGE_WRITE and
>>> _PAGE_DIRTY so kvm_pte_dirty() should also return both. But I think
>>> kvm_pte_mkdirty() in this patch is just a "reasonable optimization".
>>> Because strictly speaking, we need both kvm_pte_mkdirty() and
>>> kvm_pte_mkwrite() and call the pair when needed.
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>>>     static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCESSED; }
>>>>>>     static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE; }
>>>>>>
>>>>>> +static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
>>>>>> +{
>>>>>> +       return pte | KVM_PAGE_SOFT_WRITE;
>>>>>> +}
>>>>>> +
>>>>>>     static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>>>>>>     {
>>>>>>            return pte | _PAGE_ACCESSED;
>>>>>> @@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t pte)
>>>>>>
>>>>>>     static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
>>>>>>     {
>>>>>> -       return pte | _PAGE_DIRTY;
>>>>>> +       return pte | __WRITEABLE;
>>>>>>     }
>>>>>>
>>>>>>     static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
>>>>>>     {
>>>>>> -       return pte & ~_PAGE_DIRTY;
>>>>>> +       return pte & ~__WRITEABLE;
>>>>>>     }
>>>>>>
>>>>>>     static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
>>>>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>>>>>> index ed956c5cf2cc..68749069290f 100644
>>>>>> --- a/arch/loongarch/kvm/mmu.c
>>>>>> +++ b/arch/loongarch/kvm/mmu.c
>>>>>> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>>>>>>            /* Track access to pages marked old */
>>>>>>            new = kvm_pte_mkyoung(*ptep);
>>>>>>            if (write && !kvm_pte_dirty(new)) {
>>>>>> -               if (!kvm_pte_write(new)) {
>>>>>> +               if (!kvm_pte_soft_write(new)) {
>>>>>>                            ret = -EFAULT;
>>>>>>                            goto out;
>>>>>>                    }
>>>>>> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>>>>>                    prot_bits |= _CACHE_SUC;
>>>>>>
>>>>>>            if (writeable) {
>>>>>> -               prot_bits |= _PAGE_WRITE;
>>>>>> +               prot_bits = kvm_pte_mksoft_write(prot_bits);
>>>>>>                    if (write)
>>>>>> -                       prot_bits |= __WRITEABLE;
>>>>>> +                       prot_bits = kvm_pte_mkdirty(prot_bits);
>>>>>>            }
>>>>>>
>>>>>>            /* Disable dirty logging on HugePages */
>>>>>> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>>>>>            kvm_release_faultin_page(kvm, page, false, writeable);
>>>>>>            spin_unlock(&kvm->mmu_lock);
>>>>>>
>>>>>> -       if (prot_bits & _PAGE_DIRTY)
>>>>>> +       if (kvm_pte_dirty(prot_bits))
>>>>>>                    mark_page_dirty_in_slot(kvm, memslot, gfn);
>>>>>>
>>>>>>     out:
>>>>> To save time, I just change the whole patch like this, you can confirm
>>>>> whether it woks:
>>>>>
>>>>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h
>>>>> b/arch/loongarch/include/asm/kvm_mmu.h
>>>>> index 099bafc6f797..882f60c72b46 100644
>>>>> --- a/arch/loongarch/include/asm/kvm_mmu.h
>>>>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
>>>>> @@ -16,6 +16,13 @@
>>>>>      */
>>>>>     #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
>>>>>
>>>>> +/*
>>>>> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
>>>>> + * kernel, on secondary MMU it records page writable in order to fast
>>>>> + * path handling
>>>>> + */
>>>>> +#define KVM_PAGE_WRITEABLE     _PAGE_MODIFIED
>>>>> +
>>>>>     #define _KVM_FLUSH_PGTABLE     0x1
>>>>>     #define _KVM_HAS_PGMASK                0x2
>>>>>     #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) |
>>>>> pgprot_val(prot))
>>>>> @@ -56,6 +63,7 @@ static inline int kvm_pte_write(kvm_pte_t pte) {
>>>>> return pte & _PAGE_WRITE; }
>>>>>     static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte &
>>>>> _PAGE_DIRTY; }
>>>>>     static inline int kvm_pte_young(kvm_pte_t pte) { return pte &
>>>>> _PAGE_ACCESSED; }
>>>>>     static inline int kvm_pte_huge(kvm_pte_t pte) { return pte &
>>>>> _PAGE_HUGE; }
>>>>> +static inline int kvm_pte_writeable(kvm_pte_t pte) { return pte &
>>>>> KVM_PAGE_WRITEABLE; }
>>>>>
>>>>>     static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>>>>>     {
>>>>> @@ -69,12 +77,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t
>>>>> pte)
>>>>>
>>>>>     static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
>>>>>     {
>>>>> -       return pte | _PAGE_DIRTY;
>>>>> +       return pte | __WRITEABLE;
>>>>>     }
>>>>>
>>>>>     static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
>>>>>     {
>>>>> -       return pte & ~_PAGE_DIRTY;
>>>>> +       return pte & ~__WRITEABLE;
>>>>>     }
>>>>>
>>>>>     static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
>>>>> @@ -87,6 +95,11 @@ static inline kvm_pte_t kvm_pte_mksmall(kvm_pte_t
>>>>> pte)
>>>>>            return pte & ~_PAGE_HUGE;
>>>>>     }
>>>>>
>>>>> +static inline kvm_pte_t kvm_pte_mkwriteable(kvm_pte_t pte)
>>>>> +{
>>>>> +       return pte | KVM_PAGE_WRITEABLE;
>>>>> +}
>>>>> +
>>>>>     static inline int kvm_need_flush(kvm_ptw_ctx *ctx)
>>>>>     {
>>>>>            return ctx->flag & _KVM_FLUSH_PGTABLE;
>>>>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>>>>> index ed956c5cf2cc..7c8143e79c12 100644
>>>>> --- a/arch/loongarch/kvm/mmu.c
>>>>> +++ b/arch/loongarch/kvm/mmu.c
>>>>> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu
>>>>> *vcpu, unsigned long gpa, bool writ
>>>>>            /* Track access to pages marked old */
>>>>>            new = kvm_pte_mkyoung(*ptep);
>>>>>            if (write && !kvm_pte_dirty(new)) {
>>>>> -               if (!kvm_pte_write(new)) {
>>>>> +               if (!kvm_pte_writeable(new)) {
>>>>>                            ret = -EFAULT;
>>>>>                            goto out;
>>>>>                    }
>>>>> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
>>>>> unsigned long gpa, bool write)
>>>>>                    prot_bits |= _CACHE_SUC;
>>>>>
>>>>>            if (writeable) {
>>>>> -               prot_bits |= _PAGE_WRITE;
>>>>> +               prot_bits = kvm_pte_mkwriteable(prot_bits);
>>>>>                    if (write)
>>>>> -                       prot_bits |= __WRITEABLE;
>>>>> +                       prot_bits = kvm_pte_mkdirty(prot_bits);
>>>>>            }
>>>>>
>>>>>            /* Disable dirty logging on HugePages */
>>>>> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
>>>>> unsigned long gpa, bool write)
>>>>>            kvm_release_faultin_page(kvm, page, false, writeable);
>>>>>            spin_unlock(&kvm->mmu_lock);
>>>>>
>>>>> -       if (prot_bits & _PAGE_DIRTY)
>>>>> +       if (kvm_pte_dirty(prot_bits))
>>>>>                    mark_page_dirty_in_slot(kvm, memslot, gfn);
>>>>>
>>>>>     out:
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>>>
>>>>
>>
>>


