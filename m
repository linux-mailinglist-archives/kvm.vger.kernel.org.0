Return-Path: <kvm+bounces-20348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB281913FF9
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D90201C21C94
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EC1442C;
	Mon, 24 Jun 2024 01:28:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BF41396;
	Mon, 24 Jun 2024 01:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719192524; cv=none; b=peACqwFre7lwQ+6y0ji9uajqKMyJaiySJK/NisZ1fsxvgbOIOWIYwInmqOAUVQr6uG3dSJwx/zWMNRvPeDO9XQ6EYRgN/2npw85H+o67/sw4rbMOICd0QbSaOiAIUZHSoh/Q+jnNv00S/Y/Gj3XSbLWYsuqCC/8RFtoC+w9tm3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719192524; c=relaxed/simple;
	bh=mOEcdBvkXT2vbHlpiHCcXOJg4SoK5g8RzrZjipiVECI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TtC502s/lpBUe9cPsS1kjcoNRKVKRY91FR3QTjTzBCaSWm58Krahf2oneAyBuuGvtfF4vgXlenT1OCys5Bn/E9kajPS8Q8igshkEu91zsCDkcTzFTkitrC3cKwX3SH6dE3LBex4iL9wE2JPAC4sfMQ28kKS/FO122sKHaA6tqQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnOrHy3hmLWIJAA--.37696S3;
	Mon, 24 Jun 2024 09:28:39 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxTcfEy3hmqYUuAA--.46119S3;
	Mon, 24 Jun 2024 09:28:38 +0800 (CST)
Subject: Re: [PATCH v2 2/6] LoongArch: KVM: Select huge page only if secondary
 mmu supports it
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240619080940.2690756-1-maobibo@loongson.cn>
 <20240619080940.2690756-3-maobibo@loongson.cn>
 <CAAhV-H7YXHwfdy-DFAd6_qPXdqbBVUSHq0U8Hu1eEgdtN_b+OA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <d6ab6374-717a-6de1-ef21-dbe65bd6f4de@loongson.cn>
Date: Mon, 24 Jun 2024 09:28:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7YXHwfdy-DFAd6_qPXdqbBVUSHq0U8Hu1eEgdtN_b+OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxTcfEy3hmqYUuAA--.46119S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw1xZw1rWr1DWF4DWw1UCFX_yoW5AFyUpF
	Z3AFn8urWkKrnxGrZrtw1qyryYyrs3KF4xZ3W7K348AFnrXr1j9F4ku398ZFyUC3yrAa1I
	vF4rXr13ua17tagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4AhLUUUUU



On 2024/6/23 下午3:55, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 19, 2024 at 4:09 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Currently page level selection about secondary mmu depends on memory
>> slot and page level about host mmu. There will be problem if page level
>> of secondary mmu is zero already. So page level selection should depend
>> on the following three conditions.
>>   1. Memslot is aligned for huge page and vm is not migrating.
>>   2. Page level of host mmu is huge page also.
>>   3. Page level of secondary mmu is suituable for huge page, it cannot
>> be normal page since it is not supported to merge normal pages into
>> huge page now.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_mmu.h |  2 +-
>>   arch/loongarch/kvm/mmu.c             | 16 +++++++++++++---
>>   2 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/include/asm/kvm_mmu.h
>> index 099bafc6f797..d06ae0e0dde5 100644
>> --- a/arch/loongarch/include/asm/kvm_mmu.h
>> +++ b/arch/loongarch/include/asm/kvm_mmu.h
>> @@ -55,7 +55,7 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte_t val)
>>   static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRITE; }
>>   static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRTY; }
>>   static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCESSED; }
>> -static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE; }
>> +static inline int kvm_pte_huge(kvm_pte_t pte)  { return !!(pte & _PAGE_HUGE); }
> Why do we need this change?
In later there is such usage like !kvm_pte_huge(*ptep)
       if (ptep && !kvm_pte_huge(*ptep))

I had thought it should be 0/1 if !kvm_pte_huge() is used. However the 
original is ok by test.

I will remove this modification.

Regards
Bibo Mao


> 
> Huacai
> 
>>
>>   static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>>   {
>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>> index 9e39d28fec35..c6351d13ca1b 100644
>> --- a/arch/loongarch/kvm/mmu.c
>> +++ b/arch/loongarch/kvm/mmu.c
>> @@ -858,10 +858,20 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
>>
>>          /* Disable dirty logging on HugePages */
>>          level = 0;
>> -       if (!fault_supports_huge_mapping(memslot, hva, write)) {
>> -               level = 0;
>> -       } else {
>> +       if (fault_supports_huge_mapping(memslot, hva, write)) {
>> +               /* Check page level about host mmu*/
>>                  level = host_pfn_mapping_level(kvm, gfn, memslot);
>> +               if (level == 1) {
>> +                       /*
>> +                        * Check page level about secondary mmu
>> +                        * Disable hugepage if it is normal page on
>> +                        * secondary mmu already
>> +                        */
>> +                       ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
>> +                       if (ptep && !kvm_pte_huge(*ptep))
>> +                               level = 0;
>> +               }
>> +
>>                  if (level == 1) {
>>                          gfn = gfn & ~(PTRS_PER_PTE - 1);
>>                          pfn = pfn & ~(PTRS_PER_PTE - 1);
>> --
>> 2.39.3
>>


