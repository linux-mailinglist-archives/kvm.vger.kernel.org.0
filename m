Return-Path: <kvm+bounces-20345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72213913FB2
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD3D21C20F70
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013DD4409;
	Mon, 24 Jun 2024 01:12:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6A917D2;
	Mon, 24 Jun 2024 01:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719191567; cv=none; b=JPnxLc15U/WXvmjTJ8dSW+2vUuj4Aieuqi8nKV4McT3ZOLUmcOTfYGB1vQRuKVxDBWLvFYXt3G7jbihob8L0xzGo8bmAsL1mtWV68HtIbErVhv6N785z/y5+mFNSrehklnx9bCJibIWpgYrEH1IXGbKKJqQm1oVNzSQEKOfNQ8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719191567; c=relaxed/simple;
	bh=w3YljmizhmvbMqLLtZngR0vRAwTtI0FvHeu1xjYrDN8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=O1Q/KnbTrXiebOUtxydQ0jld4lkGGeEDKGrvXLN1DLdVYS2t6hc+Kx04GXPDzWH1fibS6ro44UOFt9LwI6sxOwWIoSuugeew9+AAqjiaj6R/KPDuHtnf3H1q2w5XnO1P081l3hKyDkzV1pV/kSXMnb56aM++GGhlcMhfyzVemtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Bxa+oDyHhm8V8JAA--.37933S3;
	Mon, 24 Jun 2024 09:12:36 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxBMUAyHhmH4EuAA--.35171S3;
	Mon, 24 Jun 2024 09:12:34 +0800 (CST)
Subject: Re: [PATCH v2 6/6] LoongArch: KVM: Mark page accessed and dirty with
 page ref added
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240619080940.2690756-1-maobibo@loongson.cn>
 <20240619080940.2690756-7-maobibo@loongson.cn>
 <CAAhV-H4YHBMG=YYatmmUKBm==53czOdrOoze3a_+CTNXF52N2g@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <a0a695cb-8fe7-b68b-8d39-8be0e32f9f4d@loongson.cn>
Date: Mon, 24 Jun 2024 09:12:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4YHBMG=YYatmmUKBm==53czOdrOoze3a_+CTNXF52N2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxBMUAyHhmH4EuAA--.35171S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGFy3GrW5ZF1kAr4fGr47ZFc_yoW5WFWUpr
	WSyF4DGr4xtrnIkrZIvw1DZr1F9rs3Kr4xJF47J34rCFnxWw1qqw18WrW3uFykA3s2yFWS
	vFyrt3W7WFn0k3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==



On 2024/6/22 下午1:21, Huacai Chen wrote:
> Hi, Bibo,
> 
> What is the relationship between this patch and the below one?
> https://lore.kernel.org/loongarch/20240611034609.3442344-1-maobibo@loongson.cn/T/#u

It is updated version about the patch listed at this website, I put all 
migration relative patches into one patch set, to prevent that it is 
lost in so many mail threads:)

Regards
Bibo Mao
> 
> 
> Huacai
> 
> On Wed, Jun 19, 2024 at 4:09 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Function kvm_map_page_fast() is fast path of secondary mmu page fault
>> flow, pfn is parsed from secondary mmu page table walker. However
>> the corresponding page reference is not added, it is dangerious to
>> access page out of mmu_lock.
>>
>> Here page ref is added inside mmu_lock, function kvm_set_pfn_accessed()
>> and kvm_set_pfn_dirty() is called with page ref added, so that the
>> page will not be freed by others.
>>
>> Also kvm_set_pfn_accessed() is removed here since it is called in
>> the following function kvm_release_pfn_clean().
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/mmu.c | 23 +++++++++++++----------
>>   1 file changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>> index 3b862f3a72cb..5a820a81fd97 100644
>> --- a/arch/loongarch/kvm/mmu.c
>> +++ b/arch/loongarch/kvm/mmu.c
>> @@ -557,6 +557,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>>          gfn_t gfn = gpa >> PAGE_SHIFT;
>>          struct kvm *kvm = vcpu->kvm;
>>          struct kvm_memory_slot *slot;
>> +       struct page *page;
>>
>>          spin_lock(&kvm->mmu_lock);
>>
>> @@ -599,19 +600,22 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
>>          if (changed) {
>>                  kvm_set_pte(ptep, new);
>>                  pfn = kvm_pte_pfn(new);
>> +               page = kvm_pfn_to_refcounted_page(pfn);
>> +               if (page)
>> +                       get_page(page);
>>          }
>>          spin_unlock(&kvm->mmu_lock);
>>
>> -       /*
>> -        * Fixme: pfn may be freed after mmu_lock
>> -        * kvm_try_get_pfn(pfn)/kvm_release_pfn pair to prevent this?
>> -        */
>> -       if (kvm_pte_young(changed))
>> -               kvm_set_pfn_accessed(pfn);
>> +       if (changed) {
>> +               if (kvm_pte_young(changed))
>> +                       kvm_set_pfn_accessed(pfn);
>>
>> -       if (kvm_pte_dirty(changed)) {
>> -               mark_page_dirty(kvm, gfn);
>> -               kvm_set_pfn_dirty(pfn);
>> +               if (kvm_pte_dirty(changed)) {
>> +                       mark_page_dirty(kvm, gfn);
>> +                       kvm_set_pfn_dirty(pfn);
>> +               }
>> +               if (page)
>> +                       put_page(page);
>>          }
>>          return ret;
>>   out:
>> @@ -920,7 +924,6 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>                  kvm_set_pfn_dirty(pfn);
>>          }
>>
>> -       kvm_set_pfn_accessed(pfn);
>>          kvm_release_pfn_clean(pfn);
>>   out:
>>          srcu_read_unlock(&kvm->srcu, srcu_idx);
>> --
>> 2.39.3
>>


