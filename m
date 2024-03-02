Return-Path: <kvm+bounces-10699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E332186EE33
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 03:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A81B1F221D0
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 02:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D7C179D0;
	Sat,  2 Mar 2024 02:58:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2667E6;
	Sat,  2 Mar 2024 02:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709348281; cv=none; b=Xfghoqr6YHrn4ysKD1nlcGIoNAP9QrM1t9rFJ1RFyaMQXwSt/Cno2S3eiWSq8PUAzwtFSFcSL679FAyq7XkE0tWvCkGJ5iGZtrAGB03qZiRZ9LpKlSBRXlMSZNn1Qv18NceAoWLkcXVJh4QL0PDMrlgGQlDkhs4QNNeyXwCw+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709348281; c=relaxed/simple;
	bh=i9MXZrjdN4IaL/tM9+NfwWXuEZp3zXMWZ583WxUt7+0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qsMHk9CX4PK+742xZerAGeDcgEVrvuM7FWW8vzV9mdIVkgyz5WAiK1v776YTLuroOM7kOV1JNJzo3Zd+blwGIKdXApjCbwQ2l55ehkgboOuS1utJZHkYm+/0VKHDQ4uPY83WiXMyqCfwfqAoDFODzBtn/Ow08o8H/HFHr3qA2x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxWOisleJl4XYTAA--.29808S3;
	Sat, 02 Mar 2024 10:57:48 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbROgleJlHyVMAA--.6327S3;
	Sat, 02 Mar 2024 10:57:39 +0800 (CST)
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: WANG Xuerui <kernel@xen0n.name>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
 <327808dd-ac34-4c61-9992-38642acc9419@xen0n.name>
 <62cc24fd-025a-53c6-1c8e-2d20de54d297@loongson.cn>
 <431111f3-d84a-4311-986d-eebd91559cd3@xen0n.name>
From: maobibo <maobibo@loongson.cn>
Message-ID: <9881fa84-74c4-b7e8-63fb-607a22b1eee2@loongson.cn>
Date: Sat, 2 Mar 2024 10:57:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <431111f3-d84a-4311-986d-eebd91559cd3@xen0n.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbROgleJlHyVMAA--.6327S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Xry5Xry7uFWfuF18GFy7CFX_yoW7AryDpF
	W8AF47Kr48JF4Iyws7tw1UZr1YyrW8JF48XF98AryDAryqyr1ftr40yr4Y9FyDGr1xCF1Y
	vrW7tFy7Zw1DA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=



On 2024/2/27 下午6:19, WANG Xuerui wrote:
> On 2/27/24 18:12, maobibo wrote:
>>
>>
>> On 2024/2/27 下午5:10, WANG Xuerui wrote:
>>> On 2/27/24 11:14, maobibo wrote:
>>>>
>>>>
>>>> On 2024/2/27 上午4:02, Jiaxun Yang wrote:
>>>>>
>>>>>
>>>>> 在2024年2月26日二月 上午8:04，maobibo写道：
>>>>>> On 2024/2/26 下午2:12, Huacai Chen wrote:
>>>>>>> On Mon, Feb 26, 2024 at 10:04 AM maobibo <maobibo@loongson.cn> 
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>>>>>>>> Hi, Bibo,
>>>>>>>>>
>>>>>>>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> 
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>> Instruction cpucfg can be used to get processor features. And 
>>>>>>>>>> there
>>>>>>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 
>>>>>>>>>> - 20
>>>>>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is 
>>>>>>>>>> used
>>>>>>>>>> for KVM hypervisor to privide PV features, and the area can be 
>>>>>>>>>> extended
>>>>>>>>>> for other hypervisors in future. This area will never be used for
>>>>>>>>>> real HW, it is only used by software.
>>>>>>>>> After reading and thinking, I find that the hypercall method 
>>>>>>>>> which is
>>>>>>>>> used in our productive kernel is better than this cpucfg method.
>>>>>>>>> Because hypercall is more simple and straightforward, plus we 
>>>>>>>>> don't
>>>>>>>>> worry about conflicting with the real hardware.
>>>>>>>> No, I do not think so. cpucfg is simper than hypercall, 
>>>>>>>> hypercall can
>>>>>>>> be in effect when system runs in guest mode. In some scenario 
>>>>>>>> like TCG
>>>>>>>> mode, hypercall is illegal intruction, however cpucfg can work.
>>>>>>> Nearly all architectures use hypercall except x86 for its historical
>>>>>> Only x86 support multiple hypervisors and there is multiple 
>>>>>> hypervisor
>>>>>> in x86 only. It is an advantage, not historical reason.
>>>>>
>>>>> I do believe that all those stuff should not be exposed to guest 
>>>>> user space
>>>>> for security reasons.
>>>> Can you add PLV checking when cpucfg 0x40000000-0x400000FF is 
>>>> emulated? if it is user mode return value is zero and it is kernel 
>>>> mode emulated value will be returned. It can avoid information leaking.
>>>
>>> I've suggested this approach in another reply [1], but I've rechecked 
>>> the manual, and it turns out this behavior is not permitted by the 
>>> current wording. See LoongArch Reference Manual v1.10, Volume 1, 
>>> Section 2.2.10.5 "CPUCFG":
>>>
>>>  > CPUCFG 访问未定义的配置字将读回全 0 值。
>>>  >
>>>  > Reads of undefined CPUCFG configuration words shall return 
>>> all-zeroes.
>>>
>>> This sentence mentions no distinction based on privilege modes, so it 
>>> can only mean the behavior applies universally regardless of 
>>> privilege modes.
>>>
>>> I think if you want to make CPUCFG behavior PLV-dependent, you may 
>>> have to ask the LoongArch spec editors, internally or in public, for 
>>> a new spec revision.
>> No, CPUCFG behavior between CPUCFG0-CPUCFG21 is unchanged, only that 
>> it can be defined by software since CPUCFG 0x400000000 is used by 
>> software.
> 
> The 0x40000000 range is not mentioned in the manuals. I know you've 
> confirmed privately with HW team but this needs to be properly 
> documented for public projects to properly rely on.
> 
>>> (There are already multiple third-party LoongArch implementers as of 
>>> late 2023, so any ISA-level change like this would best be 
>>> coordinated, to minimize surprises.)
>> With document Vol 4-23
>> https://www.intel.com/content/dam/develop/external/us/en/documents/335592-sdm-vol-4.pdf 
>>
>>
>> There is one line "MSR address range between 40000000H - 400000FFH is 
>> marked as a specially reserved range. All existing and
>> future processors will not implement any features using any MSR in 
>> this range."
> 
> Thanks for providing this info, now at least we know why it's this 
> specific range of 0x400000XX that's chosen.
> 
>>
>> It only says that it is reserved, it does not say detailed software 
>> behavior. Software behavior is defined in hypervisor such as:
>> https://github.com/MicrosoftDocs/Virtualization-Documentation/blob/main/tlfs/Requirements%20for%20Implementing%20the%20Microsoft%20Hypervisor%20Interface.pdf 
>>
>> https://kb.vmware.com/s/article/1009458
>>
>> If hypercall method is used, there should be ABI also like aarch64:
>> https://documentation-service.arm.com/static/6013e5faeee5236980d08619
> 
> Yes proper documentation of public API surface is always necessary 
> *before* doing real work. Because right now the hypercall provider is 
> Linux KVM, maybe we can document the existing and planned hypercall 
> usage and ABI in the kernel docs along with code changes.
> 
yes, I will add hypercall in kernel docs.

SMC calling convention is ABI between OS and secure firmware, LoongArch 
has no secure mode, it not necessary to has such doc.The hypercall 
calling convention is relative with hypervisor SW, not relative with CPU 
HW vendor. Each hypervisor maybe has its separate hypercall calling 
convention just like syscall ABIs.

Regards
Bibo Mao


