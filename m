Return-Path: <kvm+bounces-37613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C89AA2C9C2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFEF03AD333
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA1C196C7B;
	Fri,  7 Feb 2025 17:05:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A200195980;
	Fri,  7 Feb 2025 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947929; cv=none; b=gYhFbNyI6DE5nGNIYq7nMvTpBhl7gC/TAK6LnL0cqLMX2IofdumG+/sHsmDKJHd69vuADekIbfJskGlg3JodC66dVNPCeuAAnVK6qXNRJQFLPcHPPfNZl4Se1W/GHHNscaa9bIZWZlw5D48fx2b3zogBNe2vmLIYmR8k1/OXmZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947929; c=relaxed/simple;
	bh=s1BVV71tdKWb68/UoMTAso4yYcOFYRGBfAKM4k3Ge8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzABNvbdLSvk7IRO5uwhlLDXwncuv0wQIfte6pKFxqbhTkHSYScR4cobfRnJxMAorq7v8Z7xSxORwjVnXNi19qaxj+f2SC0ywdoHup+o6xYcw0kcdmxQB9WXYLaxbG/LssgWSuw7fJOPpH2VlR4Gpj4gMv6fEmtZponQOxwJceM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4515113E;
	Fri,  7 Feb 2025 09:05:49 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DFEE3F63F;
	Fri,  7 Feb 2025 09:05:21 -0800 (PST)
Message-ID: <2987f990-6535-4df0-896f-7cb0eec79aca@arm.com>
Date: Fri, 7 Feb 2025 17:05:21 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/43] arm64: rme: Allow checking SVE on VM instance
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-29-steven.price@arm.com>
 <4cd1b360-6902-4800-93a2-905cfd8ca7f8@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <4cd1b360-6902-4800-93a2-905cfd8ca7f8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/02/2025 06:00, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Given we have different types of VMs supported, check the
>> support for SVE for the given instance of the VM to accurately
>> report the status.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h | 2 ++
>>   arch/arm64/kvm/arm.c             | 5 ++++-
>>   arch/arm64/kvm/rme.c             | 5 +++++
>>   3 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index 90a4537ad38d..0d89ab1645c1 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>>   u32 kvm_realm_ipa_limit(void);
>>   u32 kvm_realm_vgic_nr_lr(void);
>>   +bool kvm_rme_supports_sve(void);
>> +
>>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>   int kvm_init_realm_vm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 134acb4ee26f..6f7f96ab781d 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -456,7 +456,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>           r = get_kvm_ipa_limit();
>>           break;
>>       case KVM_CAP_ARM_SVE:
>> -        r = system_supports_sve();
>> +        if (kvm_is_realm(kvm))
>> +            r = kvm_rme_supports_sve();
>> +        else
>> +            r = system_supports_sve();
>>           break;
> 
> kvm_vm_ioctl_check_extension() can be called by
> ioctl(KVM_CHECK_EXTENSION) on the
> file descriptor of '/dev/kvm'. kvm is NULL and kvm_is_realm() returns
> false in
> this case.
> 
> kvm_dev_ioctl
>   kvm_vm_ioctl_check_extension_generic  // kvm is NULL
>     kvm_vm_ioctl_check_extension

See my reply in patch 25

>>       case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>>       case KVM_CAP_ARM_PTRAUTH_GENERIC:
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 5831d379760a..27a479feb907 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -20,6 +20,11 @@ static bool rme_supports(unsigned long feature)
>>       return !!u64_get_bits(rmm_feat_reg0, feature);
>>   }
>>   +bool kvm_rme_supports_sve(void)
>> +{
>> +    return rme_supports(RMI_FEATURE_REGISTER_0_SVE_EN);
>> +}
>> +
> 
> If rme_supports() becomes a public helper, it can be directly used. In
> turn,
> kvm_rme_supports_sve() can be dropped. RMI_FEATURE_REGISTER_0_SVE_EN is
> obvious
> to indicate the corresponding feature.

I agree this seem reasonable. Sadly the use of u64_get_bits() is
assuming that the 'feature' parameter is constant at runtime. I could
rework it to not require a constant, but considering this is the only
function which is exposing rme_supports() without any further checks I
feel it's better to leave the code as it is.

Obviously if we get more feature bits like this in the future then it
would be worth revisiting.

Thanks,
Steve

>>   static int rmi_check_version(void)
>>   {
>>       struct arm_smccc_res res;
> 
> Thanks,
> Gavin
> 


