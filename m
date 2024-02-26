Return-Path: <kvm+bounces-9620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B25866B98
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F8D41C223C7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8688E1CABA;
	Mon, 26 Feb 2024 07:59:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31F81CA91;
	Mon, 26 Feb 2024 07:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708934394; cv=none; b=M3XsSxyr0AqskmtAuzNqqxeVjDbShV8jVmJ2WPLs7E23roYgDEvf9gnsJ0a6y/lHvdGFBVoAESP6rOQSKgUsZW14knlzuHkPmNqPVkggqwHdyfRpsmpIX6UzUmL03rjvgmsMKMeBzc2dD0N2B3eZnRojQnpvw+SqbsQNrDfg2jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708934394; c=relaxed/simple;
	bh=dTj0w+7ycyZMOek1nHPKbi/sLqz2fVMlUDF8pUF8anY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cIwbheHnRTV+dzmfye635rFG9bd3KR2nfVwHPBSY5c/S/XX+QzQaby6ZQMzKTr6Tv8SJU4jGXkt3xv5BW5gvO8GZXkP2sx9GfFqh8A2hm2sp0w98yLFucMudNVoGL/VaEfOWMlX6E5UM8LRKw5rpCSKurFQd8mfDkCRnQGS4r8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxG+n0RNxlw4ERAA--.26289S3;
	Mon, 26 Feb 2024 15:59:48 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxvhPwRNxl8dNEAA--.60827S3;
	Mon, 26 Feb 2024 15:59:47 +0800 (CST)
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: WANG Xuerui <kernel@xen0n.name>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <d8994f0f-d789-46d2-bc4d-f9b37fb396ff@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <0fa41323-0071-aa97-21fb-3ad859d0a9b4@loongson.cn>
Date: Mon, 26 Feb 2024 16:00:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d8994f0f-d789-46d2-bc4d-f9b37fb396ff@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxvhPwRNxl8dNEAA--.60827S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZw1DtF4fXFWUAFW5GFWxGrX_yoW5ZrWfpF
	WftF1jkFs7trZ29a1Dtws3WF4Syr4kKFWUJrn8Jry5Aws09w1Syr10krWY9FykJ34rCr1a
	qrWUtry3ZF1DA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	XVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4s2-UUUUU



On 2024/2/26 下午1:25, WANG Xuerui wrote:
> Hi,
> 
> On 2/26/24 10:04, maobibo wrote:
>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> Instruction cpucfg can be used to get processor features. And there
>>>> is trap exception when it is executed in VM mode, and also it is
>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>> for KVM hypervisor to privide PV features, and the area can be extended
>>>> for other hypervisors in future. This area will never be used for
>>>> real HW, it is only used by software.
>>> After reading and thinking, I find that the hypercall method which is
>>> used in our productive kernel is better than this cpucfg method.
>>> Because hypercall is more simple and straightforward, plus we don't
>>> worry about conflicting with the real hardware.
>> No, I do not think so. cpucfg is simper than hypercall, hypercall can
>> be in effect when system runs in guest mode. In some scenario like TCG 
>> mode, hypercall is illegal intruction, however cpucfg can work.
> 
> While the CPUCFG instruction is universally available, it's also 
> unprivileged, so any additional CPUCFG behavior also automatically 
> becomes UAPI, which likely isn't what you expect. Hypervisor 
> implementation details shouldn't be leaked to userland because it has no 
> reason to care -- even though userland learns about the capabilities, it 
> cannot actually access the resources, because relevant CSRs and/or 
> instructions are privileged. Worse, the unnecessary exposure of 
> information could be a problem security-wise.
cpucfg is read-only and used to represent current hw cpu features,
why do you think there is security issue?  Is there security issue about 
cpucfg2 and cpucfg6 since it can be accessed in user space also?

PMU feature is defined in cpucfg6, PMU driver is written in kernel mode.
> 
> A possible way to preserve the unprivileged CPUCFG behavior would be 
> acting differently based on guest CSR.CRMD.PLV: only returning data for 
> the new configuration space when guest is not in PLV3. But this behavior 
> isn't explicitly allowed nor disallowed in the LoongArch manuals, and is 
> in my opinion unnecessarily complex.
> 
> And regarding the lack of hypcall support from QEMU system mode 
> emulation on TCG, I'd argue it's simply a matter of adding support in 
> target/loongarch64. This would be attractive because it will enable easy 
> development and testing of hypervisor software with QEMU -- both locally 
> and in CI.
Hypercall is part of hardware assisted virtualization LVZ, do you think
only adding hypercall instruction withou LVZ is possible?

> 
>> Extioi virtualization extension will be added later, cpucfg can be 
>> used to get extioi features. It is unlikely that extioi driver depends 
>> on PARA_VIRT macro if hypercall is used to get features.
> And the EXTIOI feature too isn't something usable from unprivileged 
> code, so I don't think it will affect the conclusions above.
Sorry, I do not know what do you mean.


Regards
Bibo Mao

> 


