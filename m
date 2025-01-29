Return-Path: <kvm+bounces-36865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90109A2202C
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 16:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA4D63A71EE
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A008E1DDC29;
	Wed, 29 Jan 2025 15:24:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E244418C31;
	Wed, 29 Jan 2025 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738164269; cv=none; b=m6Bj6JrF1K0GIGSR/n32953HpT6Ppp3DnuomrGI4wdGXZsAbPjrnS2wR+YikoKADus3PZOSkZ+boVkS2qiryH7Z1TUg9dtiaP9judeEG/UqI06ajjmH6TxjOK5GpwdUOg9WWNznzxYU9zE6C6TlTcU4WxDHqEn02Z9nJ7xaPR70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738164269; c=relaxed/simple;
	bh=64wDy/SvJI+sTp+F1GvCexrXLQBTM82iJOEpBiCnsZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6pg1aw2T6oCHrg1bMI1exqzMOPCvAuT3FOGR7lE+qz2AFYaD308kRzlRrH9dnZfAzWzlQPAMeYuUFNwB2EJUS5TJt9/g751SGgh678R8I82EYMUlsHLIGapdkV5hwd4h8gjCeWvRlRRF97/0w71xVvVYJySEp+gz6D/quvg61s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E18C497;
	Wed, 29 Jan 2025 07:24:52 -0800 (PST)
Received: from [10.57.77.31] (unknown [10.57.77.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 336153F63F;
	Wed, 29 Jan 2025 07:24:22 -0800 (PST)
Message-ID: <c4c5bb64-bbbc-48d4-9569-c6a55e6edfb4@arm.com>
Date: Wed, 29 Jan 2025 15:24:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
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
 <20241212155610.76522-7-steven.price@arm.com>
 <7271b3ff-8665-4a98-b3dd-77417f85d5e3@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <7271b3ff-8665-4a98-b3dd-77417f85d5e3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 29/01/2025 03:57, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v5:
>>   * Reword "unsupported" message from "host supports" to "we want" to
>>     clarify that 'we' are the 'host'.
>> Changes since v2:
>>   * Drop return value from kvm_init_rme(), it was always 0.
>>   * Rely on the RMM return value to identify whether the RSI ABI is
>>     compatible.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>>   arch/arm64/include/asm/virt.h        |  1 +
>>   arch/arm64/kvm/Makefile              |  3 +-
>>   arch/arm64/kvm/arm.c                 |  6 +++
>>   arch/arm64/kvm/rme.c                 | 50 +++++++++++++++++++++++++
>>   7 files changed, 137 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>   create mode 100644 arch/arm64/kvm/rme.c
>>
> 
> [...]
> 
>> +
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +    if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
>> +        return kvm->arch.is_realm;
>> +    return false;
>> +}
>> +
> 
> kvm->arch.is_realm won't be true when kvm_rme_is_available is false.
> It's set
> in kvm_arch_init_vm() of PATCH[10]. So it's safe to be simplified as
> below if
> the changes to kvm_arch_init_vm() is slightly modified, more details can be
> found from the comments to PATCH[10]
> 
> With the changes, we don't have to check kvm_rme_is_available every time.

This is true, however, kvm_rme_is_available is a static key, which means
that the kernel uses runtime patching to change the value. So by
checking kvm_rme_is_available this check is short-circuited and there's
no (data) memory access.

I have to admit I've no idea whether this actually makes any practical
difference to any benchmark but the intention was to have the minimum
possible overhead on systems which don't have the RME hardware.

Steve

> static inline bool kvm_is_realm(struct kvm *kvm)
> {
>     return (kvm && kvm->arch.is_realm);
> }
> 
> Thanks,
> Gavin
> 


