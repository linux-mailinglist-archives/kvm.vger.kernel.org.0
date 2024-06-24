Return-Path: <kvm+bounces-20349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09260914020
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 03:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AEE01C21C52
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 01:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6F14A31;
	Mon, 24 Jun 2024 01:37:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CD01FAA;
	Mon, 24 Jun 2024 01:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719193040; cv=none; b=DgVHfpisreaS/4Iv76bUY5YAs7TGfBJ6HZgjS7QcPukPMOQoGcFz/m+/GpAVMPaOf722A/lPJhySqAG3iVx1/82ISmRXiB5TLKhdCbH49gDPJy566f55QUXUDxh2JVxSfgruIWmSbRqvMRqtZxweaReMw96OkooftGw1uOi3Cbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719193040; c=relaxed/simple;
	bh=OlatsLJ07m207ro1biI6ooU0BKX5ADw7TM9VnLtFbwo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=J816fzra9zDn319ixpuyH1rseCfKA54Njk/soQMscEdDtkqIhNR/0c3bkXYhlBdf4JjfVFtwPtOIk7WWGu0dwb3ZoqdUXtlvqz5YLydxALVwe1mRY0TbWx1gKTFOnQEVwGYlYCZDsRZrHBLxWXgsUrr/itapP0smd9e6Pp43mVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxnOrMzXhm_GIJAA--.37709S3;
	Mon, 24 Jun 2024 09:37:16 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMfJzXhmmYcuAA--.45539S3;
	Mon, 24 Jun 2024 09:37:15 +0800 (CST)
Subject: Re: [PATCH v2 4/6] LoongArch: KVM: Add memory barrier before update
 pmd entry
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240619080940.2690756-1-maobibo@loongson.cn>
 <20240619080940.2690756-5-maobibo@loongson.cn>
 <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <58d34b7d-eaad-8aa8-46c3-9212664431be@loongson.cn>
Date: Mon, 24 Jun 2024 09:37:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H74raJ9eEWEHr=aN6LhVvNUyP6TLEDH006M6AnoE8tkPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMfJzXhmmYcuAA--.45539S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zw17urW5JF43Xr4rGF48uFX_yoW8Zr4kpF
	ZrAF1DKrs5GrnFg3Z7X3Z0gr42qrZ7KFyxXFy3u34DCrZIqw1093W8JrZa9F18A34rCa1F
	qa1rKan8Zay5AacCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
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
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4AhLUUUUU



On 2024/6/23 下午6:18, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 19, 2024 at 4:09 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> When updating pmd entry such as allocating new pmd page or splitting
>> huge page into normal page, it is necessary to firstly update all pte
>> entries, and then update pmd entry.
>>
>> It is weak order with LoongArch system, there will be problem if other
>> vcpus sees pmd update firstly however pte is not updated. Here smp_wmb()
>> is added to assure this.
> Memory barriers should be in pairs in most cases. That means you may
> lose smp_rmb() in another place.
The idea adding smp_wmb() comes from function __split_huge_pmd_locked()
in file mm/huge_memory.c, and the explanation is reasonable.

                 ...
                 set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
         }
         ...
         smp_wmb(); /* make pte visible before pmd */
         pmd_populate(mm, pmd, pgtable);

It is strange that why smp_rmb() should be in pairs with smp_wmb(),
I never hear this rule -:(

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/mmu.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
>> index 1690828bd44b..7f04edfbe428 100644
>> --- a/arch/loongarch/kvm/mmu.c
>> +++ b/arch/loongarch/kvm/mmu.c
>> @@ -163,6 +163,7 @@ static kvm_pte_t *kvm_populate_gpa(struct kvm *kvm,
>>
>>                          child = kvm_mmu_memory_cache_alloc(cache);
>>                          _kvm_pte_init(child, ctx.invalid_ptes[ctx.level - 1]);
>> +                       smp_wmb(); /* make pte visible before pmd */
>>                          kvm_set_pte(entry, __pa(child));
>>                  } else if (kvm_pte_huge(*entry)) {
>>                          return entry;
>> @@ -746,6 +747,7 @@ static kvm_pte_t *kvm_split_huge(struct kvm_vcpu *vcpu, kvm_pte_t *ptep, gfn_t g
>>                  val += PAGE_SIZE;
>>          }
>>
>> +       smp_wmb();
>>          /* The later kvm_flush_tlb_gpa() will flush hugepage tlb */
>>          kvm_set_pte(ptep, __pa(child));
>>
>> --
>> 2.39.3
>>


