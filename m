Return-Path: <kvm+bounces-14610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C788A46C6
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 04:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84BEE282DAF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 02:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445BC13ACC;
	Mon, 15 Apr 2024 02:04:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FC32C1B6;
	Mon, 15 Apr 2024 02:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713146668; cv=none; b=tyKnLXe56XMnlTmpc9/b0IwRXVVH+dLydEfdgX7hEwft30QMtHgwWr9/K9tMVVAOqkxMPZWr/TjF1FJBswBZVtjmlLRQV7/KAddhZk6KiGswR3BN950v5UlAPizW9b/AYXoqsLQNEDa1kIt/6aw840LIKSKW/AUP2kLqmFeB/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713146668; c=relaxed/simple;
	bh=ec0QOXPYSoYGavFDceYRWzdCXfJieKVX1eCxFV8JsP4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=XL+NBdgjbN3pfmyMZ6RP2awpg16NWUCwnbAFz7hzUCzZKNY7ZG2e181J2tDT8QpaN+h4VG9telB6+lc4iNglwirp2iJo6G/eRO94AxZmhdG43jbmhOrsh/lFlJ4wO9OYVr09sTImi3aejUclMBx/6pxYC+4haq9WVzsFPsOgslo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8AxhrklixxmLIwnAA--.8738S3;
	Mon, 15 Apr 2024 10:04:21 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxPBMhixxmPRd7AA--.38820S3;
	Mon, 15 Apr 2024 10:04:20 +0800 (CST)
Subject: Re: [PATCH] KVM: loongarch: Add vcpu id check before create vcpu
To: Sean Christopherson <seanjc@google.com>, Wujie Duan <wjduan@linx-info.com>
Cc: zhaotianrui@loongson.cn, chenhuacai@kernel.org, kernel@xen0n.name,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240412084703.1407412-1-wjduan@linx-info.com>
 <ZhmAbBGOvldKdkZu@google.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <6549c8d7-a916-da63-b547-7a51e532eeda@loongson.cn>
Date: Mon, 15 Apr 2024 10:04:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZhmAbBGOvldKdkZu@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxPBMhixxmPRd7AA--.38820S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7WFWxJr47XrWrAw4Utr4fJFc_yoW8Cw17pF
	WDuFn8Wr48Gr1xG34kt3yDury7Kws7Kr18X3WUtFy8AFnIyryFqFWFkrZ8AFs8Jw4rG34I
	vF15X3Z0vas0yabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU466zUUUUU



On 2024/4/13 上午2:41, Sean Christopherson wrote:
> On Fri, Apr 12, 2024, Wujie Duan wrote:
>> Add a pre-allocation arch condition to checks that vcpu id should
>> smaller than max_vcpus
>>
>> Signed-off-by: Wujie Duan <wjduan@linx-info.com>
>> ---
>>   arch/loongarch/kvm/vcpu.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 3a8779065f73..d41cacf39583 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -884,6 +884,9 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>>   
>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>   {
>> +	if (id >= kvm->max_vcpus)
>> +		return -EINVAL;
> 
> Do you have a testcase for this?  If I'm following the LoongArch code correctly,
> I don't think this is actually necessary.
> 
> In arch/loongarch/include/asm/kvm_host.h:
> 
>    #define KVM_MAX_VCPUS			256
> 
> without a #define KVM_MAX_VCPU_IDS in loongarch/, AFAICT.  And so the common
> code in include/linux/kvm_host.h will do:
> 
>    #ifndef KVM_MAX_VCPU_IDS
>    #define KVM_MAX_VCPU_IDS KVM_MAX_VCPUS
>    #endif
> 
> LoongArch's kvm_vm_ioctl_check_extension() reports that to userspace:
> 
> 	case KVM_CAP_MAX_VCPU_ID:
> 		r = KVM_MAX_VCPU_IDS;
> 
> and the common kvm_vm_ioctl_create_vcpu() does:
> 
> 	if (id >= KVM_MAX_VCPU_IDS)
> 		return -EINVAL;
> 
> and the common kvm_create_vm() does:
> 
> 	kvm->max_vcpus = KVM_MAX_VCPUS;
> 
> with again no override of max_vcpus in LoongArch or common KVM.  So unless I'm
> missing something, manually checking max_vcpus in LoongArch's kvm_arch_vcpu_precreate()
> is unnecessary.
> 
yes, you are right. There is already such checking in function 
kvm_vm_ioctl_create_vcpu(), and it is unnecessary to add the same 
checking in function kvm_arch_vcpu_precreate().

And thanks for pointing it out.

Regards
Bibo Mao


