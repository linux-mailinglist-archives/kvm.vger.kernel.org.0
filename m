Return-Path: <kvm+bounces-44477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99374A9DEC4
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 04:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73A6A3A9F0A
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 02:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4825F1FCFE9;
	Sun, 27 Apr 2025 02:50:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866C21BF58;
	Sun, 27 Apr 2025 02:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745722239; cv=none; b=LUb1p8q5SfkYk6xxVksllzdFpX86Sw1dgyjHZ6mnIg8IqgbJy2RRtrphAyRgfmgSldcqQzO7BOu4NHxP8zdpgup5T0NuYKb+ZQY+Y429Y09Jban49e2YtCjdsD7tbXY3uTBocN9cmAlXkaanCWEas1CgEzNUXlGcJxGokm1QA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745722239; c=relaxed/simple;
	bh=TGZLcsC/sBWPz3pHPkhHmDMqiIJeLWq/erDIoTVstOc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VGqF8/OIBo9ULbtsAduiqrcDNZ0rgwAU2ho+jHR9F21/fw5CLXXtQQWGqzpFr/N+enwCclFkp9d9fuIiyUtKbKCWDWFYcluwfemlxzD4AsIA1MdMdAYyQuRGp/poND5Lv4sKbLRc2PQTcYasU+6AKIsSKSHJWj7p1yoH+Z04HzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxXWt7mw1oiAvHAA--.2449S3;
	Sun, 27 Apr 2025 10:50:35 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBx3MR4mw1o8OeXAA--.50601S3;
	Sun, 27 Apr 2025 10:50:34 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Fully clear some registers when VM reboot
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250424063846.3927992-1-maobibo@loongson.cn>
 <CAAhV-H51WRgk8Bs5dsF1LrgdaqL7dk9ioy7H79voZKapov9U2g@mail.gmail.com>
 <883cb562-9236-f161-71fa-0b963db22a11@loongson.cn>
 <CAAhV-H5taW2fAGW8CQ7MF5wjW8nuYREcNd6SSmvBmCtoJta5rQ@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <4e728f47-2453-f95f-587d-5df8fd2217e6@loongson.cn>
Date: Sun, 27 Apr 2025 10:49:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5taW2fAGW8CQ7MF5wjW8nuYREcNd6SSmvBmCtoJta5rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBx3MR4mw1o8OeXAA--.50601S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7KF4fGryrGFWfJw18ur1Utwc_yoW5JF15pr
	WjkF1Dur48Wr17tF12qwsYgF1aqrZ7Kr48XF9xXFy2yrn0v345tF40krW2kF98X348JF1x
	ZF1UC3yS9F4qy3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8j-
	e5UUUUU==



On 2025/4/26 下午6:20, Huacai Chen wrote:
> On Thu, Apr 24, 2025 at 3:07 PM bibo mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/4/24 下午2:53, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Thu, Apr 24, 2025 at 2:38 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> Some registers such as LOONGARCH_CSR_ESTAT and LOONGARCH_CSR_GINTC
>>>> are partly cleared with function _kvm_set_csr(). This comes from hardware
>>> I cannot find the _kvm_set_csr() function, maybe it's a typo?
>> oop, it is _kvm_setcsr(), will refresh in next version.
>>
>>> And the tile can be "LoongArch: KVM: Fully clear some CSRs when VM reboot"
>> yeap, this title is more suitable.
> Already applied with those modifications.
Thanks for doing this  -:)

> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>> specification, some bits are read only in VM mode, and however it can be
>>>> written in host mode. So it is partly cleared in VM mode, and can be fully
>>>> cleared in host mode.
>>>>
>>>> These read only bits show pending interrupt or exception status. When VM
>>>> reset, the read-only bits should be cleared, otherwise vCPU will receive
>>>> unknown interrupts in boot stage.
>>>>
>>>> Here registers LOONGARCH_CSR_ESTAT/LOONGARCH_CSR_GINTC are fully cleared
>>>> in ioctl KVM_REG_LOONGARCH_VCPU_RESET vCPU reset path.
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/kvm/vcpu.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>> index 8e427b379661..80b2316d6f58 100644
>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>> @@ -902,6 +902,14 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>>>>                           vcpu->arch.st.guest_addr = 0;
>>>>                           memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
>>>>                           memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
>>>> +
>>>> +                       /*
>>>> +                        * When vCPU reset, clear the ESTAT and GINTC registers
>>>> +                        * And the other CSR registers are cleared with function
>>>> +                        * _kvm_set_csr().
>>>> +                        */
>>>> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_GINTC, 0);
>>>> +                       kvm_write_sw_gcsr(vcpu->arch.csr, LOONGARCH_CSR_ESTAT, 0);
>>>>                           break;
>>>>                   default:
>>>>                           ret = -EINVAL;
>>>>
>>>> base-commit: 9d7a0577c9db35c4cc52db90bc415ea248446472
>>>> --
>>>> 2.39.3
>>>>
>>>>
>>


