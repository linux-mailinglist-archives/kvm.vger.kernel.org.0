Return-Path: <kvm+bounces-16606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B2F8BC5D2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 04:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66E231F22178
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 02:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A32040856;
	Mon,  6 May 2024 02:41:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178D7181;
	Mon,  6 May 2024 02:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714963275; cv=none; b=UneGyPDbk2Zcsw7QLTQOKafwKQtcZHCeGJ7yPd2h0B95RPmV9ak3quyqvwvBCluyr5kKa8/Wrj1sLOIAv3TPjgb3XzCd4cfe8AgjxI6hghGvSagyARXNeXbIbOwuGe7uTmdkxw6gKzwYlBJI4IdF6iwDRehEYcupZI41Z95dJb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714963275; c=relaxed/simple;
	bh=FrQ3Q4c+zpCTWdWoQPf9Jye9fRyoe4zWRs8w0j8CC9Y=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lDgi/wxx5DhRX4oZ8xKzfnkfG+NxFRgSdrW3XE5uIYExn1743XIg/PCRPzfArxeIrQmidg/24lcQlgq6jXban5IvLOWVFRslaxT0RH+OVjOKef6uawMg1FIziTEVpAP8pUo746JUlSqlfun9zpwds5O5fVDAw+t7CAwsHQ/jJhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Bx3+tEQzhmmN8HAA--.22454S3;
	Mon, 06 May 2024 10:41:08 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxU1ZAQzhms_MRAA--.19845S3;
	Mon, 06 May 2024 10:41:06 +0800 (CST)
Subject: Re: [PATCH v8 2/6] LoongArch: KVM: Add hypercall instruction
 emulation support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240428100518.1642324-1-maobibo@loongson.cn>
 <20240428100518.1642324-3-maobibo@loongson.cn>
 <CAAhV-H5xVP0+aUyq2+_XHW0=25zxuG53o=+vUV4MfKn=4tiwxA@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <dab88e08-5d56-3a65-df35-47842111a8dc@loongson.cn>
Date: Mon, 6 May 2024 10:41:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5xVP0+aUyq2+_XHW0=25zxuG53o=+vUV4MfKn=4tiwxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxU1ZAQzhms_MRAA--.19845S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGF17Cw18XrWrCF13AFyruFX_yoWrXFW3pF
	ykCrn5Ga18KryxCF13t3Z0grnxArs5Kr129Fy7K34jyFsFqr18tr4kKrZ8uFy5Gw4rZF1S
	qFyFqw13uF4UtacCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
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
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4AhLUUUUU



On 2024/5/6 上午9:54, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Sun, Apr 28, 2024 at 6:05 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> On LoongArch system, there is hypercall instruction special for
>> virtualization. When system executes this instruction on host side,
>> there is illegal instruction exception reported, however it will
>> trap into host when it is executed in VM mode.
>>
>> When hypercall is emulated, A0 register is set with value
>> KVM_HCALL_INVALID_CODE, rather than inject EXCCODE_INE invalid
>> instruction exception. So VM can continue to executing the next code.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/Kbuild      |  1 -
>>   arch/loongarch/include/asm/kvm_para.h  | 26 ++++++++++++++++++++++++++
>>   arch/loongarch/include/uapi/asm/Kbuild |  2 --
>>   arch/loongarch/kvm/exit.c              | 10 ++++++++++
>>   4 files changed, 36 insertions(+), 3 deletions(-)
>>   create mode 100644 arch/loongarch/include/asm/kvm_para.h
>>   delete mode 100644 arch/loongarch/include/uapi/asm/Kbuild
>>
>> diff --git a/arch/loongarch/include/asm/Kbuild b/arch/loongarch/include/asm/Kbuild
>> index 2dbec7853ae8..c862672ed953 100644
>> --- a/arch/loongarch/include/asm/Kbuild
>> +++ b/arch/loongarch/include/asm/Kbuild
>> @@ -26,4 +26,3 @@ generic-y += poll.h
>>   generic-y += param.h
>>   generic-y += posix_types.h
>>   generic-y += resource.h
>> -generic-y += kvm_para.h
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> new file mode 100644
>> index 000000000000..d48f993ae206
>> --- /dev/null
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_LOONGARCH_KVM_PARA_H
>> +#define _ASM_LOONGARCH_KVM_PARA_H
>> +
>> +/*
>> + * LoongArch hypercall return code
>> + */
>> +#define KVM_HCALL_STATUS_SUCCESS       0
>> +#define KVM_HCALL_INVALID_CODE         -1UL
>> +#define KVM_HCALL_INVALID_PARAMETER    -2UL
>> +
>> +static inline unsigned int kvm_arch_para_features(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline unsigned int kvm_arch_para_hints(void)
>> +{
>> +       return 0;
>> +}
>> +
>> +static inline bool kvm_check_and_clear_guest_paused(void)
>> +{
>> +       return false;
>> +}
>> +#endif /* _ASM_LOONGARCH_KVM_PARA_H */
>> diff --git a/arch/loongarch/include/uapi/asm/Kbuild b/arch/loongarch/include/uapi/asm/Kbuild
>> deleted file mode 100644
>> index 4aa680ca2e5f..000000000000
>> --- a/arch/loongarch/include/uapi/asm/Kbuild
>> +++ /dev/null
>> @@ -1,2 +0,0 @@
>> -# SPDX-License-Identifier: GPL-2.0
>> -generic-y += kvm_para.h
> This file shouldn't be removed.
yes, uapi kvm_param.h is needed for Loongarch, and there will be problem 
if it is removed. And it should kept unchanged.

Regards
Bibo Mao
> 
> Huacai
> 
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index ed1d89d53e2e..923bbca9bd22 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -685,6 +685,15 @@ static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu)
>>          return RESUME_GUEST;
>>   }
>>
>> +static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
>> +{
>> +       update_pc(&vcpu->arch);
>> +
>> +       /* Treat it as noop intruction, only set return value */
>> +       vcpu->arch.gprs[LOONGARCH_GPR_A0] = KVM_HCALL_INVALID_CODE;
>> +       return RESUME_GUEST;
>> +}
>> +
>>   /*
>>    * LoongArch KVM callback handling for unimplemented guest exiting
>>    */
>> @@ -716,6 +725,7 @@ static exit_handle_fn kvm_fault_tables[EXCCODE_INT_START] = {
>>          [EXCCODE_LSXDIS]                = kvm_handle_lsx_disabled,
>>          [EXCCODE_LASXDIS]               = kvm_handle_lasx_disabled,
>>          [EXCCODE_GSPR]                  = kvm_handle_gspr,
>> +       [EXCCODE_HVC]                   = kvm_handle_hypercall,
>>   };
>>
>>   int kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
>> --
>> 2.39.3
>>
>>


