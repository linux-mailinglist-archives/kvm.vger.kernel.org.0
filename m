Return-Path: <kvm+bounces-37611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21517A2C9BC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C883A7F9B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFD119ADA2;
	Fri,  7 Feb 2025 17:05:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36536192B71;
	Fri,  7 Feb 2025 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947911; cv=none; b=KsC8AjJw7TeNt5j5y1DMC9IOS4nybyb2STNgX4UbGRLNVGCop+b2A6zhMCS9/NkINk1ajXJv7EbD8J1H/7g0hMJlVC8ZUkmviMx7tF52Wsf41XuOaJVAsB9d3fB2Ybug1x3ooFWv3UDzptYDAimkSqTF0pGu0Ic2EUITA1lEb4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947911; c=relaxed/simple;
	bh=WUw1gALBq8tAikhml2GxbRsrvj6QxwNui/fjyJm6s+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pEkUMTYVXgCofZhmko1fytZrfOSwNJQQw6n4rrH5YvFDUtjjr9q/uF6s+2CtTA2xvS5kKUlHe4gY85XQVoJpXRl1SVCtD0wQbrRb6xHy3R2oBuRHJZC7NDoIdgg7vK+ebeY6BSQOzej88YBsbiKKP/IJQwnUjmv/OKXyfUpDHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98BCF113E;
	Fri,  7 Feb 2025 09:05:32 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B83F3F63F;
	Fri,  7 Feb 2025 09:05:05 -0800 (PST)
Message-ID: <56908846-0d8e-4d84-9c7a-61e696d40825@arm.com>
Date: Fri, 7 Feb 2025 17:05:05 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 25/43] arm64: Don't expose stolen time for realm guests
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-26-steven.price@arm.com>
 <ae13e762-bd0d-4525-8919-f6b1bcfc8fee@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ae13e762-bd0d-4525-8919-f6b1bcfc8fee@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/02/2025 02:15, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> It doesn't make much sense as a realm guest wouldn't want to trust the
>> host. It will also need some extra work to ensure that KVM will only
>> attempt to write into a shared memory region. So for now just disable
>> it.
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/arm.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index eff1a4ec892b..134acb4ee26f 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -432,7 +432,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>           r = system_supports_mte();
>>           break;
>>       case KVM_CAP_STEAL_TIME:
>> -        r = kvm_arm_pvtime_supported();
>> +        if (kvm_is_realm(kvm))
>> +            r = 0;
>> +        else
>> +            r = kvm_arm_pvtime_supported();
>>           break;
> 
> kvm_vm_ioctl_check_extension() can be called on the file descriptor of
> "/dev/kvm".
> 'kvm' is NULL and kvm_is_realm() returns false, which is the missed
> corner case.

This is a general problem with checking extensions on the /dev/kvm file
descriptor. In this case the kernel does support stolen time, but it
doesn't support it with a realm guest. Because there's no context to
know whether the query is about realm guests or not there's little the
kernel can do other than report support.

This is the same situation with other extensions that are keyed off
kvm_is_realm(). I'm not sure what we can do other than say that VMMs
shouldn't do that.

Steve

>>       case KVM_CAP_ARM_EL1_32BIT:
>>           r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
> 
> Thanks,
> Gavin
> 


