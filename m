Return-Path: <kvm+bounces-50933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC679AEAC76
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96C571BC80F2
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 163CC189513;
	Fri, 27 Jun 2025 02:00:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B23D2F1FC4;
	Fri, 27 Jun 2025 02:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750989629; cv=none; b=haZw+kGSi5lzrfq0jAB51YSpUU+uUPk0nc4sm7CBX2vTzwT/R1J0Ro8hUldoBs6hmF2ejCpEdFc0yBAK1SLufn5HvsgeXZzEHibhx2Sn3hH3Lfu5EHvU1q+ITgpIFO5RUNwY68xmqZuSD4UOuZ8JZ1nMZlYIZb3ylWbSd86JZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750989629; c=relaxed/simple;
	bh=8pfx7o+jP061JxfRlafuH62c2GtBr5C7HiHxOY1JtUE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TbMSjxWpuBEJ+x7+3h33izZN4rqIArEeMpVTS5gCkO5yM4VaAMG4JhVqHogoETxt+h+DYRhHjI5R9g++j74ENILAFqn6Gtf7F2X9cVS6tDcoz9aItmJ/fHpvEDqD4VE/pzsy6mZf52R44uF7TOAqH5GqCr3i+n99scDDcMTNSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxPOI0+11opP8dAQ--.25563S3;
	Fri, 27 Jun 2025 10:00:20 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxLcUw+11ogkUsAQ--.708S3;
	Fri, 27 Jun 2025 10:00:19 +0800 (CST)
Subject: Re: [PATCH v3 9/9] LoongArch: KVM: INTC: Add address alignment check
To: Huacai Chen <chenhuacai@kernel.org>,
 David Laight <david.laight.linux@gmail.com>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250611014651.3042734-1-maobibo@loongson.cn>
 <20250611015145.3042884-1-maobibo@loongson.cn>
 <CAAhV-H6Eru5e6+_i+4DY9qwshibY43hjbS-QC-fhLD04-4mOGw@mail.gmail.com>
 <20250621122059.6caf299a@pumpkin>
 <CAAhV-H7Wnk7j1ukDLT+KZ6+tJuxMFv5qG-YGsJsXfB=2-eC=Ow@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <6068ef0b-bf04-03f7-b867-02d8a450d392@loongson.cn>
Date: Fri, 27 Jun 2025 09:58:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7Wnk7j1ukDLT+KZ6+tJuxMFv5qG-YGsJsXfB=2-eC=Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxLcUw+11ogkUsAQ--.708S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxWrWUuw47KF45CF47Jr4rXrc_yoWrXw18pr
	WUAFs0ka15Xry7Jw1qqwnYgFnrtw4vqr18XryDta4a9F4vvF17Jry8ArWj9Fyjkw1fKF40
	qF4YgrWfuFWYy3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU70PfDUUU
	U



On 2025/6/21 下午9:04, Huacai Chen wrote:
> Hi, David,
> 
> On Sat, Jun 21, 2025 at 7:21 PM David Laight
> <david.laight.linux@gmail.com> wrote:
>>
>> On Thu, 19 Jun 2025 16:47:22 +0800
>> Huacai Chen <chenhuacai@kernel.org> wrote:
>>
>>> Hi, Bibo,
>>>
>>> On Wed, Jun 11, 2025 at 9:51 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> IOCSR instruction supports 1/2/4/8 bytes access, the address should
>>>> be naturally aligned with its access size. Here address alignment
>>>> check is added in eiointc kernel emulation.
>>>>
>>>> At the same time len must be 1/2/4/8 bytes from iocsr exit emulation
>>>> function kvm_emu_iocsr(), remove the default case in switch case
>>>> statements.
>>> Robust code doesn't depend its callers do things right, so I suggest
>>> keeping the default case, which means we just add the alignment check
>>> here.
>>
>> kernel code generally relies on callers to DTRT - except for values
>> that come from userspace.
>>
>> Otherwise you get unreadable and slow code that continuously checks
>> for things that can't happen.
> Generally you are right - but this patch is not the case.
> 
> Adding a "default" case here doesn't make code slower or unreadable,
> and the code becomes more robust.
By my understanding, the default case cannot happen never with iocsr 
emulation function kvm_emu_iocsr() in kernel in the previous patch.

David suggests that default case can be removed since it will not 
happen. It actually makes code quicker if compared with assembly 
language, since there is one if-else comparison reduction.

Regards
Bibo Mao

> 
> Huacai
> 
>>
>>          David
>>
>>>
>>> And I think this patch should also Cc stable and add a Fixes tag.
>>>
>>>
>>> Huacai
>>>
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>   arch/loongarch/kvm/intc/eiointc.c | 21 +++++++++++++--------
>>>>   1 file changed, 13 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>>>> index 8b0d9376eb54..4e9d12300cc4 100644
>>>> --- a/arch/loongarch/kvm/intc/eiointc.c
>>>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>>>> @@ -311,6 +311,12 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>>>>                  return -EINVAL;
>>>>          }
>>>>
>>>> +       /* len must be 1/2/4/8 from function kvm_emu_iocsr() */
>>>> +       if (addr & (len - 1)) {
>>>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>>          vcpu->stat.eiointc_read_exits++;
>>>>          spin_lock_irqsave(&eiointc->lock, flags);
>>>>          switch (len) {
>>>> @@ -323,12 +329,9 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
>>>>          case 4:
>>>>                  ret = loongarch_eiointc_readl(vcpu, eiointc, addr, val);
>>>>                  break;
>>>> -       case 8:
>>>> +       default:
>>>>                  ret = loongarch_eiointc_readq(vcpu, eiointc, addr, val);
>>>>                  break;
>>>> -       default:
>>>> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
>>>> -                                               __func__, addr, len);
>>>>          }
>>>>          spin_unlock_irqrestore(&eiointc->lock, flags);
>>>>
>>>> @@ -682,6 +685,11 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>>>>                  return -EINVAL;
>>>>          }
>>>>
>>>> +       if (addr & (len - 1)) {
>>>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>>>> +               return -EINVAL;
>>>> +       }
>>>> +
>>>>          vcpu->stat.eiointc_write_exits++;
>>>>          spin_lock_irqsave(&eiointc->lock, flags);
>>>>          switch (len) {
>>>> @@ -694,12 +702,9 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
>>>>          case 4:
>>>>                  ret = loongarch_eiointc_writel(vcpu, eiointc, addr, val);
>>>>                  break;
>>>> -       case 8:
>>>> +       default:
>>>>                  ret = loongarch_eiointc_writeq(vcpu, eiointc, addr, val);
>>>>                  break;
>>>> -       default:
>>>> -               WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
>>>> -                                               __func__, addr, len);
>>>>          }
>>>>          spin_unlock_irqrestore(&eiointc->lock, flags);
>>>>
>>>> --
>>>> 2.39.3
>>>>
>>>
>>


