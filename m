Return-Path: <kvm+bounces-50953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C13E9AEB064
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 09:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D3C41C21D07
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 07:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5730A21E08A;
	Fri, 27 Jun 2025 07:44:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA48E21C9E5;
	Fri, 27 Jun 2025 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751010278; cv=none; b=F4Cp19cxDJGU9bFSzpekAW+UpdIX55DhBTj3o8Iv3YviCKX9jndoZPvBdCaCBzzYEgnLoV7BceyHCfC0Wl+sKj1Q1whFLqy+SWbPA9TaNl3f5u0JAqFs2K4Akju0OFOkiBOsJe0mBHLw0h+eFWrryUXgI/7ILLWdEVT+lcIulsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751010278; c=relaxed/simple;
	bh=jXG93fc3rFPQgN+mMO0U62dZxXk94xTclsVcEKGc8Wo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=u5vIRVKcJbhz4ikoa/m5BLhcFnoYIeuMNHlZsAnW9bKPvdvAZAbmbrEs139m4MwKxTngZo/c9Q/J2xz2yPalKu/ELiTFisapN/V7rTMy3gXdeHuZo+YzSFgDDwiW2wuQyDGa6CV1OrYMK6BdANMRTNRvBpKs5qa6Zydp4uO5mls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxQK_gS15o9iceAQ--.32219S3;
	Fri, 27 Jun 2025 15:44:33 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxZOTXS15o8BgAAA--.645S3;
	Fri, 27 Jun 2025 15:44:31 +0800 (CST)
Subject: Re: [PATCH v3 4/9] LoongArch: KVM: INTC: Check validation of num_cpu
 from user space
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250611014651.3042734-1-maobibo@loongson.cn>
 <20250611014651.3042734-5-maobibo@loongson.cn>
 <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com>
 <5f1b9068-2d3d-2f89-4f72-85b021537f58@loongson.cn>
 <CAAhV-H4PKb=BKRQpaqAN7QDu+2PWTinipCAfu13YkaQ0UExuig@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <d197255b-9165-adc5-8ba1-a6d96579fc38@loongson.cn>
Date: Fri, 27 Jun 2025 15:42:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4PKb=BKRQpaqAN7QDu+2PWTinipCAfu13YkaQ0UExuig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxZOTXS15o8BgAAA--.645S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJFWrKF1DurWxAr4rWFy8Zwc_yoWrXrykpr
	W8AFs8CF4rXryxGrn2qwn8GFnxtrn7Wrn7Xr17Ka4a9rZ0qFn3GFykArWjkF1Fk34rCF10
	vFWayay3u3WDt3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5WrAU
	UUUU=



On 2025/6/20 下午10:43, Huacai Chen wrote:
> On Fri, Jun 20, 2025 at 9:43 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/6/19 下午4:46, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Wed, Jun 11, 2025 at 9:47 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
>>>> irqchip eiointc, here add validation about cpu number to avoid array
>>>> pointer overflow.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/kvm/intc/eiointc.c | 18 +++++++++++++-----
>>>>    1 file changed, 13 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>>>> index b48511f903b5..ed80bf290755 100644
>>>> --- a/arch/loongarch/kvm/intc/eiointc.c
>>>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>>>> @@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
>>>>           int ret = 0;
>>>>           unsigned long flags;
>>>>           unsigned long type = (unsigned long)attr->attr;
>>>> -       u32 i, start_irq;
>>>> +       u32 i, start_irq, val;
>>>>           void __user *data;
>>>>           struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
>>>>
>>>> @@ -806,7 +806,12 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
>>>>           spin_lock_irqsave(&s->lock, flags);
>>>>           switch (type) {
>>>>           case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
>>>> -               if (copy_from_user(&s->num_cpu, data, 4))
>>>> +               if (copy_from_user(&val, data, 4) == 0) {
>>>> +                       if (val < EIOINTC_ROUTE_MAX_VCPUS)
>>>> +                               s->num_cpu = val;
>>>> +                       else
>>>> +                               ret = -EINVAL;
>>> Maybe it is better to set s->num_cpu to EIOINTC_ROUTE_MAX_VCPUS (or
>>> other value) rather than keep it uninitialized. Because in other
>>> places we need to check s->num_cpu and an uninitialized value may
>>> cause undefined behavior.
>> There is error return value -EINVAL, VMM should stop running and exit
>> immediately if there is error return value with the ioctl command.
>>
>> num_cpu is not uninitialized and it is zero by default. If VMM does not
>> care about the return value, VMM will fail to get coreisr information in
>> future.
> If you are sure you can keep it as is. Then please resend patch
> 1,2,3,4,5,9 as a series because they are all bug fixes that should be
> merged as soon as possible. And in my own opinion, "INTC" can be
> dropped in the title.
Ok, will do in this way.

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
>>>
>>> Huacai
>>>> +               } else
>>>>                           ret = -EFAULT;
>>>>                   break;
>>>>           case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
>>>> @@ -835,7 +840,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>>>                                           struct kvm_device_attr *attr,
>>>>                                           bool is_write)
>>>>    {
>>>> -       int addr, cpuid, offset, ret = 0;
>>>> +       int addr, cpu, offset, ret = 0;
>>>>           unsigned long flags;
>>>>           void *p = NULL;
>>>>           void __user *data;
>>>> @@ -843,7 +848,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>>>
>>>>           s = dev->kvm->arch.eiointc;
>>>>           addr = attr->attr;
>>>> -       cpuid = addr >> 16;
>>>> +       cpu = addr >> 16;
>>>>           addr &= 0xffff;
>>>>           data = (void __user *)attr->addr;
>>>>           switch (addr) {
>>>> @@ -868,8 +873,11 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>>>                   p = &s->isr.reg_u32[offset];
>>>>                   break;
>>>>           case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
>>>> +               if (cpu >= s->num_cpu)
>>>> +                       return -EINVAL;
>>>> +
>>>>                   offset = (addr - EIOINTC_COREISR_START) / 4;
>>>> -               p = &s->coreisr.reg_u32[cpuid][offset];
>>>> +               p = &s->coreisr.reg_u32[cpu][offset];
>>>>                   break;
>>>>           case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>>>>                   offset = (addr - EIOINTC_COREMAP_START) / 4;
>>>> --
>>>> 2.39.3
>>>>
>>


