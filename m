Return-Path: <kvm+bounces-19834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF88A90C19D
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 03:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7C52838DC
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 01:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1126518645;
	Tue, 18 Jun 2024 01:48:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB361C697;
	Tue, 18 Jun 2024 01:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718675286; cv=none; b=mfACiNlEfFkK4YXCyQgLBGbphFttriAV7Q/ic2sHiuR6/BOL9IRbCgLkFgEMJ+8r8UYTK3Hn9oIRkVfdBlF9GH5+qgLAgSkMcfxIAFdcYb2qQJOqdGh65rXHa6glIv8DLSzW7c3Mm8aAPtriEGVqOvrUCE/asY8Z+Gm3b2FMHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718675286; c=relaxed/simple;
	bh=9nibZJ0FWduyum7S7nLwNvrtxl5PR55RgEHP66fZR1A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jwA7VdXpzv6fdapX2ErwgoWobPJ1PNRcxOUJYrSEUUpDW5OoNwpOJw+TYpZsE32gZxIRZCpS2T6MTFjjWPo/2kFmgONSMzpdlsrZTDbjYuGebzLcp6ToERi/KpZ2TP+U3ALcfOEmzPI+Iu2waRGHfvw11u+InSkS6ZxSbuLerJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxvOpR53Bmi8cHAA--.30934S3;
	Tue, 18 Jun 2024 09:48:01 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxBMVO53Bm16omAA--.17683S3;
	Tue, 18 Jun 2024 09:48:00 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Delay secondary mmu tlb flush before
 guest entry
To: Sean Christopherson <seanjc@google.com>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240615025930.1408266-1-maobibo@loongson.cn>
 <ZnBNCYZHuflw83jq@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <756c9cb4-35b9-4523-7ac7-9a70bdf6ddba@loongson.cn>
Date: Tue, 18 Jun 2024 09:47:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZnBNCYZHuflw83jq@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxBMVO53Bm16omAA--.17683S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tF1Dur47Gry5JFW8WF1xZwc_yoW8tF4fpF
	97uFs5JF4Fgr1xta42vwnxWrsxXrs3Kr1293W3KFW5Ar4aqF1kXFykKFZxZFyUXw4rAa1I
	qFyrJw1avFZ8tacCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==

Sean,

Thanks for reviewing the patch, we are not familiar with open source 
community, it gives us much helps.

On 2024/6/17 下午10:49, Sean Christopherson wrote:
> On Sat, Jun 15, 2024, Bibo Mao wrote:
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index c87b6ea0ec47..98078e01dd55 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -30,6 +30,7 @@
>>   #define KVM_PRIVATE_MEM_SLOTS		0
>>   
>>   #define KVM_HALT_POLL_NS_DEFAULT	500000
>> +#define KVM_REQ_TLB_FLUSH_GPA		KVM_ARCH_REQ(0)
>>   
>>   #define KVM_GUESTDBG_SW_BP_MASK		\
>>   	(KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
>> @@ -190,6 +191,7 @@ struct kvm_vcpu_arch {
>>   
>>   	/* vcpu's vpid */
>>   	u64 vpid;
>> +	unsigned long flush_gpa;
> 
> Side topic, GPAs should really use "gpa_t" instead of "unsigned long", otherwise
> 32-bit kernels running on CPUs with 64-bit physical addresses will fail miserably
> (which may or may not be a problem in practice for LoongArch).
Sure, will modify.

> 
>> diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
>> index 02535df6b51f..55f7f3621e38 100644
>> --- a/arch/loongarch/kvm/tlb.c
>> +++ b/arch/loongarch/kvm/tlb.c
>> @@ -21,12 +21,9 @@ void kvm_flush_tlb_all(void)
>>   	local_irq_restore(flags);
>>   }
>>   
>> +/* Called with irq disabled */
> 
> Rather than add a comment, add:
> 
> 	lockdep_assert_irqs_disabled()
Good point, will modify.

> 
> in the function.
> 
>>   void kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
>>   {
>> -	unsigned long flags;
>> -
>> -	local_irq_save(flags);
>>   	gpa &= (PAGE_MASK << 1);
>>   	invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
>> -	local_irq_restore(flags);
>>   }
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 9e8030d45129..ae9ae88c11db 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -51,6 +51,16 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>>   	return RESUME_GUEST;
>>   }
>>   
>> +/* Check pending request with irq disabled */
> 
> Same thing here.
Will modify in next version.

Regards
Bibo Mao


