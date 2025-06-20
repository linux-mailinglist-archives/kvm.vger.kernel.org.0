Return-Path: <kvm+bounces-50003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D90FCAE10CD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED98419E1BA2
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 01:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC3B128816;
	Fri, 20 Jun 2025 01:43:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C427D098;
	Fri, 20 Jun 2025 01:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383813; cv=none; b=Q9rjj18R7D8KEr95XJneHWm/JS7yuPoIlPEURDlX6K3D33nYFPfFDm2FqaLLFVQx8hR8sCGk+ta8wXJpbmfYEXSZ2AnFESrHZBzIoG6QHh0Ox8wU3YpFZt0GfVxC73xGdoj8bEQl3wyW60+RGAqlJCshnpBcJ0Zm+g+x5vkVdx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383813; c=relaxed/simple;
	bh=zOswJx4rDMm0i1hayjKroOfpk7Su2D1HHPjfiTqZxQY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TUtuuwif7V9DbMTS07pHLNzU+2hYViP56s5FI34DmEgayTbiZp8zsZCvE5bfT5iXYeZKOSy9TY9s4VxYbHezwCLG0HNjF14XdgwC7nowZk5myAt8hRPuUxjeEB1oscLpM/ahabT+QRDAkQ1cK1EAQ1KJ2OVVClJsiXtRPP1EEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxHHK_vFRoqiEaAQ--.59488S3;
	Fri, 20 Jun 2025 09:43:27 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxPse9vFRoic0hAQ--.40170S3;
	Fri, 20 Jun 2025 09:43:27 +0800 (CST)
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
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <5f1b9068-2d3d-2f89-4f72-85b021537f58@loongson.cn>
Date: Fri, 20 Jun 2025 09:42:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7ehdkKwzsFNAaX+r5eXLknvskyXLPDKei2A55LoSiJMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxPse9vFRoic0hAQ--.40170S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxur4fCw47GryrCrWUAFW3CFX_yoW5ur4Upr
	W8Aa98KFWFqryxWw1vqw1DGFyrKrn7WrySyry7KFya9rZ0qwn5CFyvkrZ0kFyak34rAF1I
	vF4ay3W3uw1DtacCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4
	CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jUsqXU
	UUUU=



On 2025/6/19 下午4:46, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Wed, Jun 11, 2025 at 9:47 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> The maximum supported cpu number is EIOINTC_ROUTE_MAX_VCPUS about
>> irqchip eiointc, here add validation about cpu number to avoid array
>> pointer overflow.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/kvm/intc/eiointc.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>> index b48511f903b5..ed80bf290755 100644
>> --- a/arch/loongarch/kvm/intc/eiointc.c
>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>> @@ -798,7 +798,7 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
>>          int ret = 0;
>>          unsigned long flags;
>>          unsigned long type = (unsigned long)attr->attr;
>> -       u32 i, start_irq;
>> +       u32 i, start_irq, val;
>>          void __user *data;
>>          struct loongarch_eiointc *s = dev->kvm->arch.eiointc;
>>
>> @@ -806,7 +806,12 @@ static int kvm_eiointc_ctrl_access(struct kvm_device *dev,
>>          spin_lock_irqsave(&s->lock, flags);
>>          switch (type) {
>>          case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_NUM_CPU:
>> -               if (copy_from_user(&s->num_cpu, data, 4))
>> +               if (copy_from_user(&val, data, 4) == 0) {
>> +                       if (val < EIOINTC_ROUTE_MAX_VCPUS)
>> +                               s->num_cpu = val;
>> +                       else
>> +                               ret = -EINVAL;
> Maybe it is better to set s->num_cpu to EIOINTC_ROUTE_MAX_VCPUS (or
> other value) rather than keep it uninitialized. Because in other
> places we need to check s->num_cpu and an uninitialized value may
> cause undefined behavior.
There is error return value -EINVAL, VMM should stop running and exit 
immediately if there is error return value with the ioctl command.

num_cpu is not uninitialized and it is zero by default. If VMM does not 
care about the return value, VMM will fail to get coreisr information in 
future.

Regards
Bibo Mao
> 
> 
> Huacai
>> +               } else
>>                          ret = -EFAULT;
>>                  break;
>>          case KVM_DEV_LOONGARCH_EXTIOI_CTRL_INIT_FEATURE:
>> @@ -835,7 +840,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>                                          struct kvm_device_attr *attr,
>>                                          bool is_write)
>>   {
>> -       int addr, cpuid, offset, ret = 0;
>> +       int addr, cpu, offset, ret = 0;
>>          unsigned long flags;
>>          void *p = NULL;
>>          void __user *data;
>> @@ -843,7 +848,7 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>
>>          s = dev->kvm->arch.eiointc;
>>          addr = attr->attr;
>> -       cpuid = addr >> 16;
>> +       cpu = addr >> 16;
>>          addr &= 0xffff;
>>          data = (void __user *)attr->addr;
>>          switch (addr) {
>> @@ -868,8 +873,11 @@ static int kvm_eiointc_regs_access(struct kvm_device *dev,
>>                  p = &s->isr.reg_u32[offset];
>>                  break;
>>          case EIOINTC_COREISR_START ... EIOINTC_COREISR_END:
>> +               if (cpu >= s->num_cpu)
>> +                       return -EINVAL;
>> +
>>                  offset = (addr - EIOINTC_COREISR_START) / 4;
>> -               p = &s->coreisr.reg_u32[cpuid][offset];
>> +               p = &s->coreisr.reg_u32[cpu][offset];
>>                  break;
>>          case EIOINTC_COREMAP_START ... EIOINTC_COREMAP_END:
>>                  offset = (addr - EIOINTC_COREMAP_START) / 4;
>> --
>> 2.39.3
>>


