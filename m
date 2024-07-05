Return-Path: <kvm+bounces-21035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36389928157
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 07:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 308CB1C23C93
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 05:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FAE1339A2;
	Fri,  5 Jul 2024 05:05:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE25335C0;
	Fri,  5 Jul 2024 05:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720155957; cv=none; b=tg329HPUGyNccrKzJuUENzDByMoZp2YNhc8v8hEITN3naODzL/qdn01l4qqo3WzrmtDYf8nvh33jjyZn/KsxMEGw6VkUzZWNbkZuWE8fN+NEVTxtZz0k+7iLT+Bu3Kw9g4atbuA5iE7eQcMkrTRymLr7xJjZZBkaDSo86jjfTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720155957; c=relaxed/simple;
	bh=cMMrd4R0LOJOM1zRLuRFlhObo/jo8pYbo4hcL/x/EU0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RwCSJxpAa10JQibm5M5pj45MS/EMgRUc/QSUpGHl7gATfT6fIQkhtXBOrDKmr8sDPOOkXy8gLxJFBk2qTBmnM3Vquhdu81N/b2zB83/vnReLeOft0o29MtDrvd1gQ/Jlx6aExPPK2nUUgCmkEp18nven3XhFV2SisPJ/YuTqYRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxvfAxf4dmdCoBAA--.3836S3;
	Fri, 05 Jul 2024 13:05:53 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxmsYuf4dmYu47AA--.8023S3;
	Fri, 05 Jul 2024 13:05:52 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xuerui Wang <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
 <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
 <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn>
 <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
 <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
 <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
 <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
 <bdcc9ec4-31a8-1438-25c0-be8ba7f49ed0@loongson.cn>
 <ecb6df72-543c-4458-ba27-0ef8340c1eb3@flygoat.com>
 <554b10e8-a7ab-424a-f987-ea679859a220@loongson.cn>
 <01eb9efd-ca7a-4d4c-a29d-cfc2f6cfbb86@app.fastmail.com>
 <9316cde1-26d0-54d5-43c3-1284288c685f@loongson.cn>
 <4cfc5292-6f1a-4409-b229-2433e18f012f@app.fastmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <a2f1b226-addf-673a-13c6-907021fc2bc2@loongson.cn>
Date: Fri, 5 Jul 2024 13:05:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4cfc5292-6f1a-4409-b229-2433e18f012f@app.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxmsYuf4dmYu47AA--.8023S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxur15JF15tryUJry8uw1kXrc_yoW5ur15pa
	48KFWY9F4DtryIy3y8ta1xWr1vy3s2yw4aqryrKrykGFn8GFyDZF1YkF4F93WUXrW8Z340
	vF40qFyxuas8uFgCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9ab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r1q6r43MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU8vApUUUUUU==



On 2024/7/5 下午12:09, Jiaxun Yang wrote:
> 
> 
> 在2024年7月5日七月 上午11:46，maobibo写道：
>> On 2024/7/5 上午11:19, Jiaxun Yang wrote:
>>>
>>>
>>> 在2024年7月5日七月 上午9:21，maobibo写道：
>>> [...]
>>>>> for you.
>>>> On the other hand, can you list benefits or disadvantage of approaches
>>>> on different architecture?
>>>
>>> So the obvious benefit of scratch vCPU would be maintaining consistency and simpleness
>>> for UAPI.
>> I do not find the simpleness, for the same feature function, both VM
>> feature and CPU feature is define as follows.  Do you think it is for
>> simple :)
> 
> So they made a mistake here :-(
> 
> We don't even need vCPU flag, just probing CPUCFG bits is sufficient.
> 
> Note that in Arm's case, some CPU features have system dependencies, that's why
> they need to be entitled twice.
> 
> For us, we don't have such burden.
> 
> If Arm doesn't set a good example here, please check RISC-V's CONFIG reg on dealing
> ISA extensions. We don't even need such register because our CPUCFG can perfectly
> describe ISA status.
> 
>>
>> VM CAPBILITY:
>>       KVM_CAP_ARM_PTRAUTH_ADDRESS
>>       KVM_CAP_ARM_PTRAUTH_GENERIC
>>       KVM_CAP_ARM_EL1_32BIT
>>       KVM_CAP_ARM_PMU_V3
>>       KVM_CAP_ARM_SVE
>>       KVM_CAP_ARM_PSCI
>>       KVM_CAP_ARM_PSCI_0_2
>>
>> CPU:
>>       KVM_ARM_VCPU_POWER_OFF
>>       KVM_ARM_VCPU_EL1_32BIT
>>       KVM_ARM_VCPU_PSCI_0_2
>>       KVM_ARM_VCPU_PMU_V3
>>       KVM_ARM_VCPU_SVE
>>       KVM_ARM_VCPU_PTRAUTH_ADDRESS
>>       KVM_ARM_VCPU_PTRAUTH_GENERIC
>>       KVM_ARM_VCPU_HAS_EL2
>>
>> Also why scratch vcpu is created and tested on host cpu type rather than
>> other cpu type?  It wastes much time for host cpu type to detect capability.
> 
> To maximize supported features, on Arm there is KVM_ARM_VCPU_INIT ioctl.
> For us that's unnecessary, our kernel does not need to be aware of CPU type,
> only CPUCFG bits are necessary. RISC-V is following the same convention.
> 
>>>
>>> It can also maximum code reuse probabilities in other user space hypervisor projects.
>>>
>>> Also, it can benefit a potential asymmetrical system. I understand that it won't appear
>>> in near future, but we should always be prepared, especially in UAPI design.
>> If for potential asymmetrical system, however there is only one scratch
>> vcpu. is that right? how does only one scratch vcpu detect ASMP
>> capability, and it is not bind to physical cpu to detect ASMP capability.
>>
>> In generic big.little is HMP rather than ASMP, are you agree.
> 
> So I was talking about emulating asymmetrical guest. Each guest CPU should have
> it's own copy of properties. That's the lesson learnt.
For ASMP there may be problem if instruction set is different. However I 
think it is a little far from now with LoongArch.
> 
> [...]
> 
> Anyway I'm just trying to help out here, feel free to go ahead without taking my advice.
It is really nice to talk with you , hope more people taking part in 
community from my heart.
> 
> I've seen so many pitfalls on all other arches and I don't want them to repeat on LoongArch.
> But sometimes people only learn from mistakes.
Different arch has different history, LoongArch should take pitfalls 
again, it is normal rules just from my thoughts, only that it is new and 
has no much burden now.

Regards
Bibo Mao


