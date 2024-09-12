Return-Path: <kvm+bounces-26678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5AA976584
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16DA32867E5
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D9719C57E;
	Thu, 12 Sep 2024 09:28:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AD1190063;
	Thu, 12 Sep 2024 09:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133285; cv=none; b=LupWoU3tUgLOAgzMN+JeauHo+iNK3nmKo31BDsXkVJS2e3WO5v0JDA4nDrtxvQlgLULefmP0p0D7pBELrlTV91uFsBdTXzeiIFMHobOApj8pwLnhRVvVAeqSW2B+TyIuJBn390ZNPKRC4B3qADuff6YlBfgq0xaTkt5ShFJQVgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133285; c=relaxed/simple;
	bh=EPXa/NnVK8uQjh00WPL84+pNBcw20vQC/zILNvMMWEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXHjEpVSaoU93TE9F3a2iW+CPitMWXMv07fjuIsbBqiTFpdVzJWuEbKsWZMQrAvOIc/fQEUkE6f8XjZx1j1GH1jmc9levIitwEHRYzPMYSaocEC+YPcdKh/w97CXVb7nOyLOSyci/4sFJ9a9DUDAAtTqSewrB8A1tLHHdhk5veQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 750F2DA7;
	Thu, 12 Sep 2024 02:28:31 -0700 (PDT)
Received: from [10.1.34.27] (e122027.cambridge.arm.com [10.1.34.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A43B23F64C;
	Thu, 12 Sep 2024 02:27:58 -0700 (PDT)
Message-ID: <1e3bf62e-87cb-4ac0-a97e-48eb392b95c9@arm.com>
Date: Thu, 12 Sep 2024 10:27:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/43] arm64: RME: Check for RME support at KVM init
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-8-steven.price@arm.com>
 <8e17105a-8732-46df-8f3e-01a168558231@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8e17105a-8732-46df-8f3e-01a168558231@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 12/09/2024 09:49, Gavin Shan wrote:
> On 8/22/24 1:38 AM, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>   * Drop return value from kvm_init_rme(), it was always 0.
>>   * Rely on the RMM return value to identify whether the RSI ABI is
>>     compatible.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h | 17 +++++++++
>>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>>   arch/arm64/include/asm/virt.h        |  1 +
>>   arch/arm64/kvm/Makefile              |  3 +-
>>   arch/arm64/kvm/arm.c                 |  6 +++
>>   arch/arm64/kvm/rme.c                 | 50 +++++++++++++++++++++++++
>>   7 files changed, 136 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>   create mode 100644 arch/arm64/kvm/rme.c
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> new file mode 100644
>> index 000000000000..418685fbf6ed
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -0,0 +1,50 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/rmi_cmds.h>
>> +#include <asm/virt.h>
>> +
>> +static int rmi_check_version(void)
>> +{
>> +    struct arm_smccc_res res;
>> +    int version_major, version_minor;
>> +    unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +                             RMI_ABI_MINOR_VERSION);
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>> +
>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +        return -ENXIO;
>> +
>> +    version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +    version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +    if (res.a0 != RMI_SUCCESS) {
>> +        kvm_err("Unsupported RMI ABI (v%d.%d) host supports v%d.%d\n",
>> +            version_major, version_minor,
>> +            RMI_ABI_MAJOR_VERSION,
>> +            RMI_ABI_MINOR_VERSION);
> 
> This message is perhaps something like below since a range of versions
> can be
> supported by one particular RMM release.
> 
>     kvm_err("Unsupported RMI ABI v%d.%d. Host supports v%ld.%ld -
> v%ld.%ld\n",
>             RMI_ABI_MAJOR_VERSION, RMI_ABI_MINOR_VERSION,
>             RMI_ABI_VERSION_GET_MAJOR(res.a1),
> RMI_ABI_VERSION_GET_MINOR(res.a1),
>             RMI_ABI_VERSION_GET_MAJOR(res.a2),
> RMI_ABI_VERSION_GET_MINOR(res.a2));
> 
>> +        return -ENXIO;
>> +    }
>> +
>> +    kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
> 
> We probably need to print the requested version, instead of the lower
> implemented
> version, if I'm correct. At present, both of them have been fixed to
> v1.0 and we
> don't have a problem though.

The RSI_VERSION command is somewhat complex. The RMM returns both a
"higher revision" and a "lower revision". The higher revision is the
highest interface revision supported by the RMM - and not especially
useful at least for the moment when Linux is only aiming for v1.0. So
we're currently just reporting the "lower revision" in the outputs.

There are three possibilities explained in the spec:

a) The RMM is compatible (status code is RSI_SUCCESS). From the spec
"The lower revision is equal to the requested revision". So this last
print will indeed output the requested revision.

b) The RMM doesn't support the requested revision, it supports an older
revision. In this case "The lower revision is the highest interface
revision which is both less than the requested revision and
supported by the RMM". Of course when we're requesting v1.0 this
situation should never occur, but generally we'd expect to negotiate the
lower revision if possible so this is the useful information to output.

c) The RMM does not support the requested revision, it supports a newer
revision. From the spec "The lower revision is equal to the higher
revision". So there's no point outputting both.

So situation (b) is the only case where the higher revision is
interesting. But it's only useful in a situation like:

 * Linux supports v1.1 and v2.0 (and maybe v1.0).
 * Linux prefers v1.1 over v2.0 (and v2.0 over v1.0).
 * Linux therefore requests v1.1.
 * The RMM supports v1.0 and v2.0 (but not v1.1) and so returns failure.
 * lower revision: v1.0
 * higher revision: v2.0

Linux can then use the higher revision field to detect that it can try
again with v2.0.

My expectation is that newer revisions will be preferred and so Linux
will always start by requesting the newest revision it supports (so
"higher revision" will be irrelevant). But it's there so we can support
a scenario like above.

We could output the higher revision just for information, a form of
"hey, your RMM is newer than Linux" - but I'm not sure I see the point.

Steve

>         kvm_info("RMI ABI version v%d.%d\n", RMI_ABI_MAJOR_VERSION,
> RMI_ABI_MINOR_VERSION);
> 
>> +    return 0;
>> +}
>> +
> 
> Thanks,
> Gavin
> 


