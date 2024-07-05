Return-Path: <kvm+bounces-21031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7C7928106
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 05:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 315D6282DEE
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A00F45000;
	Fri,  5 Jul 2024 03:46:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6642F52;
	Fri,  5 Jul 2024 03:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151173; cv=none; b=jLCtYSnDqiRNLg+o+sYJGJJxU7fK/A225Pt9fLHq8DOffV/KBgKiJdE/GYzx1ViyP4kFQqRP2SaehLvOPV3cCYj3QBVHusdBs2OwhvNIw9rqRj8BH8ab8aAxMuuQHwxKVJC2+t2RE+eF/0sEJw97e8YfiS6dHOzY2sMT4Htnd2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151173; c=relaxed/simple;
	bh=+KePI4SgVpf5w87VPQS36mWxSnuO1LS3nkAD9zxGCQk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h/+ICP6OosYkghzNVrydsHCpFTUK6c0eECPobCguL9IkOvtp37oMnRj1MBf8eSPBdKkvq+Uo8N5jVHTJTgKGYvMJ9zkFlngEIFL1525r23TSwgST2ccZCjrbRpsRlmWjjj6xlNuaUAZOgCl9sQx4VkqDlEmoNIG3itI8CKqIPe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxDOuBbIdmuCcBAA--.3531S3;
	Fri, 05 Jul 2024 11:46:09 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Axjsd9bIdmy947AA--.7396S3;
	Fri, 05 Jul 2024 11:46:08 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Xuerui Wang <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
 <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
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
From: maobibo <maobibo@loongson.cn>
Message-ID: <9316cde1-26d0-54d5-43c3-1284288c685f@loongson.cn>
Date: Fri, 5 Jul 2024 11:46:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <01eb9efd-ca7a-4d4c-a29d-cfc2f6cfbb86@app.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Axjsd9bIdmy947AA--.7396S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXF4fWr47Xr1rZrWfAFy7Jwc_yoWrGrW7pa
	y5KF4akFWktryxA3y0va1xWr1Sy3y0vr43Xrn5GryDJrs8Ga47JF12ka1Fka4DGr48W34I
	vFsrtr9a9FyDZacCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1c
	AE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E
	14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnI
	WIevJa73UjIFyTuYvjxU7XTmDUUUU



On 2024/7/5 上午11:19, Jiaxun Yang wrote:
> 
> 
> 在2024年7月5日七月 上午9:21，maobibo写道：
> [...]
>>> for you.
>> On the other hand, can you list benefits or disadvantage of approaches
>> on different architecture?
> 
> So the obvious benefit of scratch vCPU would be maintaining consistency and simpleness
> for UAPI.
I do not find the simpleness, for the same feature function, both VM 
feature and CPU feature is define as follows.  Do you think it is for 
simple :)

VM CAPBILITY:
     KVM_CAP_ARM_PTRAUTH_ADDRESS
     KVM_CAP_ARM_PTRAUTH_GENERIC
     KVM_CAP_ARM_EL1_32BIT
     KVM_CAP_ARM_PMU_V3
     KVM_CAP_ARM_SVE
     KVM_CAP_ARM_PSCI
     KVM_CAP_ARM_PSCI_0_2

CPU:
     KVM_ARM_VCPU_POWER_OFF
     KVM_ARM_VCPU_EL1_32BIT
     KVM_ARM_VCPU_PSCI_0_2
     KVM_ARM_VCPU_PMU_V3
     KVM_ARM_VCPU_SVE
     KVM_ARM_VCPU_PTRAUTH_ADDRESS
     KVM_ARM_VCPU_PTRAUTH_GENERIC
     KVM_ARM_VCPU_HAS_EL2

Also why scratch vcpu is created and tested on host cpu type rather than 
other cpu type?  It wastes much time for host cpu type to detect capability.
> 
> It can also maximum code reuse probabilities in other user space hypervisor projects.
> 
> Also, it can benefit a potential asymmetrical system. I understand that it won't appear
> in near future, but we should always be prepared, especially in UAPI design.
If for potential asymmetrical system, however there is only one scratch 
vcpu. is that right? how does only one scratch vcpu detect ASMP 
capability, and it is not bind to physical cpu to detect ASMP capability.

In generic big.little is HMP rather than ASMP, are you agree.

> 
>>
>> Or you post patch about host cpu support, I list its disadvantage. Or I
>> post patch about host cpu support with scheduled time, then we talk
>> about it. Is that fair for you?
> 
> I'm not committed to development work, I can try, but I can't promise.
> 
> Regarding the fairness, IMO that's not how community works. If you observe reviewing
> process happening all the place, it's always about addressing other's concern.
> 
> Still, it's up to maintainers to decide what's reasonable, I'm just trying to help.
yes I agree. I and Tianrui are maintainer also, we write all the kvm 
loongarch code. We are familiar with it from the beginning.

Regards
Bibo Mao
> 
>>
>> It is unfair that you list some approaches and let others spend time to
>> do, else you are my top boss :)
> 
> I mean, I'm just trying to make some progress here. I saw you have some disagreement
> with Huacai.
> 
> I know QEMU side implementation better than Huacai, so I'm trying to propose a solution
> that would address Huacai's concern and may work for you.
> 
>>>
>>> I understand you may have some plans in your mind, please elaborate so
>>> we can smash
>>> them together. That's how community work.
>>>
>>>>
>>>> For host cpu type or migration feature detection, I have no idea now,
>>>> also I do not think it will be big issue for me, I will do it with
>>>> scheduled time. Of source, welcome Jiaxun and you to implement host
>>>> cpu type or migration feature detection.
>>>
>>> My concern is if you allow CPU features to have "auto" property you are
>>> risking create
>>> inconsistency among migration. Once you've done that it's pretty hard to
>>> get rid of it.
>>>
>>> Please check how RISC-V dealing with CPU features at QMP side.We are working on
>>>
>>> I'm not meant to hinder your development work, but we should always
>>> think ahead.
>> Yes, it is potential issue and we will solve it. Another potential issue
>> is that PV features may different on host, you cannot disable PV
>> features directly.  The best way is that you post patch about it, then
>> we can talk about together, else it may be kindly reminder, also may be
>> waste of time, everyone is busy working for boss :)
> 
> Sigh, so you meant you submitted something known to be problematic?
> 


