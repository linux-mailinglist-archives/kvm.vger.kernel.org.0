Return-Path: <kvm+bounces-57504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EAF8B56DD6
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 03:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 591207AD805
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 01:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F751F239B;
	Mon, 15 Sep 2025 01:22:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1161A3A80;
	Mon, 15 Sep 2025 01:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757899376; cv=none; b=aXu24RVlXj76b6+D3SZ2RE2vdO9c1+HOCkrTQtWzRiAnBPmJaV5m76GXrWSoiAp7PRAF4V4sKDkxRRsGlDUco56OQGdmIoZcbxdZi4AT4STvPD2yDP/ji8hIl/QJZFrwYJfYAuJ28inY6mJ4npzEZkfWS++X/zeyIkCdt5c8sRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757899376; c=relaxed/simple;
	bh=JLjOoWsie7IviIN5XaPGn5jUoyWaOhpXrhxA9p1LBLs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Yci/R+rUyqAyLu3RwrcuDn6wiPURo593Xajd/WyU/9LntM/PPwvfA6ELZVDOJ5ekvbYkt8vYtZKDN2j8EMKopD7QlqalVzkYQ3PF/7d6yfOWDB1upjV3Bp64q/pxTV9tAXUTvdD/YV+bqkImo7g58ywrkFBIDPKyJDFQvOSZor4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxnr9lasdoe1oKAA--.20950S3;
	Mon, 15 Sep 2025 09:22:45 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDx_8NiasdoN2CWAA--.21338S3;
	Mon, 15 Sep 2025 09:22:45 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250910071429.3925025-1-maobibo@loongson.cn>
 <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <3d3a72c2-7c91-7640-5f0b-7b95bd5f0d2e@loongson.cn>
Date: Mon, 15 Sep 2025 09:20:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H65H_iREuETGU_v9oZdaPFoQj1VZV46XSNTC8ppENXzuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8NiasdoN2CWAA--.21338S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKr1DCr1xtr13AFWDCr4rZwc_yoW3Cw47pF
	WkGF4jyr4rtF17CFW2g3Wqqryj9rsrKF4xAFy7Kw1UGF1UtryUuF18W3yYqF18J34vkayx
	XF4Fqr13W3y7tabCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8cz
	VUUUUUU==



On 2025/9/14 上午9:57, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Sep 10, 2025 at 3:14 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> With PTW disabled system, bit Dirty is HW bit for page writing, however
>> with PTW enabled system, bit Write is HW bit for page writing. Previously
>> bit Write is treated as SW bit to record page writable attribute for fast
>> page fault handling in the secondary MMU, however with PTW enabled machine,
>> this bit is used by HW already.
>>
>> Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that it can
>> work on both PTW disabled and enabled machines. And with HW write bit, both
>> bit Dirty and Write is set or clear.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
>>   arch/loongarch/kvm/mmu.c             |  8 ++++----
>>   2 files changed, 20 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/include/asm/kvm_mmu.h
>> index 099bafc6f797..efcd593c42b1 100644
>> --- a/arch/loongarch/include/asm/kvm_mmu.h
>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
>> @@ -16,6 +16,13 @@
>>    */
>>   #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
>>
>> +/*
>> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
>> + * kernel, on secondary MMU it records page writable in order to fast
>> + * path handling
>> + */
>> +#define KVM_PAGE_SOFT_WRITE    _PAGE_MODIFIED
> KVM_PAGE_WRITEABLE is more suitable.
both are ok for me.
> 
>> +
>>   #define _KVM_FLUSH_PGTABLE     0x1
>>   #define _KVM_HAS_PGMASK                0x2
>>   #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
>> @@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte_t val)
>>          WRITE_ONCE(*ptep, val);
>>   }
>>
>> -static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRITE; }
>> -static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRTY; }
>> +static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & KVM_PAGE_SOFT_WRITE; }
> The same, kvm_pte_mkwriteable() is more suitable.
kvm_pte_writable()  here ?  and kvm_pte_mkwriteable() for the bellowing 
sentense.

If so, that is ok, both are ok for me.
> 
>> +static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRITEABLE; }
> _PAGE_DIRTY and _PAGE_WRITE are always set/cleared at the same time,
> so the old version still works.
Although it is workable, I still want to remove single bit _PAGE_DIRTY 
checking here.

Regards
Bibo Mao
> 
>>   static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCESSED; }
>>   static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE; }
>>
>> +static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
>> +{
>> +       return pte | KVM_PAGE_SOFT_WRITE;
>> +}
>> +
>>   static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>>   {
>>          return pte | _PAGE_ACCESSED;
>> @@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t pte)
>>
>>   static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
>>   {
>> -       return pte | _PAGE_DIRTY;
>> +       return pte | __WRITEABLE;
>>   }
>>
>>   static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
>>   {
>> -       return pte & ~_PAGE_DIRTY;
>> +       return pte & ~__WRITEABLE;
>>   }
>>
>>   static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>> index ed956c5cf2cc..68749069290f 100644
>> --- a/arch/loongarch/kvm/mmu.c
>> +++ b/arch/loongarch/kvm/mmu.c
>> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>>          /* Track access to pages marked old */
>>          new = kvm_pte_mkyoung(*ptep);
>>          if (write && !kvm_pte_dirty(new)) {
>> -               if (!kvm_pte_write(new)) {
>> +               if (!kvm_pte_soft_write(new)) {
>>                          ret = -EFAULT;
>>                          goto out;
>>                  }
>> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>                  prot_bits |= _CACHE_SUC;
>>
>>          if (writeable) {
>> -               prot_bits |= _PAGE_WRITE;
>> +               prot_bits = kvm_pte_mksoft_write(prot_bits);
>>                  if (write)
>> -                       prot_bits |= __WRITEABLE;
>> +                       prot_bits = kvm_pte_mkdirty(prot_bits);
>>          }
>>
>>          /* Disable dirty logging on HugePages */
>> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>          kvm_release_faultin_page(kvm, page, false, writeable);
>>          spin_unlock(&kvm->mmu_lock);
>>
>> -       if (prot_bits & _PAGE_DIRTY)
>> +       if (kvm_pte_dirty(prot_bits))
>>                  mark_page_dirty_in_slot(kvm, memslot, gfn);
>>
>>   out:
> To save time, I just change the whole patch like this, you can confirm
> whether it woks:
> 
> diff --git a/arch/loongarch/include/asm/kvm_mmu.h
> b/arch/loongarch/include/asm/kvm_mmu.h
> index 099bafc6f797..882f60c72b46 100644
> --- a/arch/loongarch/include/asm/kvm_mmu.h
> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> @@ -16,6 +16,13 @@
>    */
>   #define KVM_MMU_CACHE_MIN_PAGES        (CONFIG_PGTABLE_LEVELS - 1)
> 
> +/*
> + * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
> + * kernel, on secondary MMU it records page writable in order to fast
> + * path handling
> + */
> +#define KVM_PAGE_WRITEABLE     _PAGE_MODIFIED
> +
>   #define _KVM_FLUSH_PGTABLE     0x1
>   #define _KVM_HAS_PGMASK                0x2
>   #define kvm_pfn_pte(pfn, prot) (((pfn) << PFN_PTE_SHIFT) |
> pgprot_val(prot))
> @@ -56,6 +63,7 @@ static inline int kvm_pte_write(kvm_pte_t pte) {
> return pte & _PAGE_WRITE; }
>   static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte &
> _PAGE_DIRTY; }
>   static inline int kvm_pte_young(kvm_pte_t pte) { return pte &
> _PAGE_ACCESSED; }
>   static inline int kvm_pte_huge(kvm_pte_t pte) { return pte &
> _PAGE_HUGE; }
> +static inline int kvm_pte_writeable(kvm_pte_t pte) { return pte &
> KVM_PAGE_WRITEABLE; }
> 
>   static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>   {
> @@ -69,12 +77,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t
> pte)
> 
>   static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
>   {
> -       return pte | _PAGE_DIRTY;
> +       return pte | __WRITEABLE;
>   }
> 
>   static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
>   {
> -       return pte & ~_PAGE_DIRTY;
> +       return pte & ~__WRITEABLE;
>   }
> 
>   static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
> @@ -87,6 +95,11 @@ static inline kvm_pte_t kvm_pte_mksmall(kvm_pte_t
> pte)
>          return pte & ~_PAGE_HUGE;
>   }
> 
> +static inline kvm_pte_t kvm_pte_mkwriteable(kvm_pte_t pte)
> +{
> +       return pte | KVM_PAGE_WRITEABLE;
> +}
> +
>   static inline int kvm_need_flush(kvm_ptw_ctx *ctx)
>   {
>          return ctx->flag & _KVM_FLUSH_PGTABLE;
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index ed956c5cf2cc..7c8143e79c12 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu
> *vcpu, unsigned long gpa, bool writ
>          /* Track access to pages marked old */
>          new = kvm_pte_mkyoung(*ptep);
>          if (write && !kvm_pte_dirty(new)) {
> -               if (!kvm_pte_write(new)) {
> +               if (!kvm_pte_writeable(new)) {
>                          ret = -EFAULT;
>                          goto out;
>                  }
> @@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> unsigned long gpa, bool write)
>                  prot_bits |= _CACHE_SUC;
> 
>          if (writeable) {
> -               prot_bits |= _PAGE_WRITE;
> +               prot_bits = kvm_pte_mkwriteable(prot_bits);
>                  if (write)
> -                       prot_bits |= __WRITEABLE;
> +                       prot_bits = kvm_pte_mkdirty(prot_bits);
>          }
> 
>          /* Disable dirty logging on HugePages */
> @@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu,
> unsigned long gpa, bool write)
>          kvm_release_faultin_page(kvm, page, false, writeable);
>          spin_unlock(&kvm->mmu_lock);
> 
> -       if (prot_bits & _PAGE_DIRTY)
> +       if (kvm_pte_dirty(prot_bits))
>                  mark_page_dirty_in_slot(kvm, memslot, gfn);
> 
>   out:
> 
> Huacai
> 
>>
>> base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
>> --
>> 2.39.3
>>
>>


