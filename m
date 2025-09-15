Return-Path: <kvm+bounces-57538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33E05B5774C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26FE43A6FD5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAB32FC009;
	Mon, 15 Sep 2025 10:55:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAB52FC004;
	Mon, 15 Sep 2025 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757933738; cv=none; b=RKNd7gQRNQk3+NkwUR1BTFx0T9vvRiEaWIByXDwVXEWUBWBVAh7WfywafxipmHfXoTCIRgXpIG6FMOVHYMkRnLxjwOYovARt0NAve9o7wFokqPHT1rkVjxc7dcVr9AVRWdIU708A/KcOIuzcNl7o2oEt1XJSV4ELJ4D6q5ifo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757933738; c=relaxed/simple;
	bh=pTYdthdubs0S1+6tBjbV9QEGKj6TXdRtw87t+bd4hlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNENHtRP6kuy0UxSesr/lXJVvWhI0sX2JsKQ9v5m/JJPITXTMt/j8CDj5/XLS1v+C3BUBIg+skUiCar89NZcSgdj9zxROdxZKDQDP8ZNHHQRs0Yp8e4CKUwRvFbAxmOxMBtgcHNAXpG67OMEvkIoXRcQo8QG76Dk4Ds6WnE8Xa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC62D1424;
	Mon, 15 Sep 2025 03:55:27 -0700 (PDT)
Received: from [10.57.5.5] (unknown [10.57.5.5])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB5823F694;
	Mon, 15 Sep 2025 03:55:30 -0700 (PDT)
Message-ID: <28a237e2-5902-4445-a05a-4d1877863ece@arm.com>
Date: Mon, 15 Sep 2025 11:55:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/43] arm64: RME: Check for RME support at KVM init
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-6-steven.price@arm.com>
 <0481109b-769f-464b-aa72-ad6e07bdfa78@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <0481109b-769f-464b-aa72-ad6e07bdfa78@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/09/2025 12:15, Gavin Shan wrote:
> On 8/21/25 12:55 AM, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Later patches make use of struct realm and the states as the ioctls
>> interfaces are added to support realm and REC creation and destruction.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v8:
>>   * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
>> Changes since v6:
>>   * Improved message for an unsupported RMI ABI version.
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
>>   arch/arm64/kvm/Makefile              |  2 +-
>>   arch/arm64/kvm/arm.c                 |  5 +++
>>   arch/arm64/kvm/rme.c                 | 56 ++++++++++++++++++++++++++++
>>   7 files changed, 141 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>   create mode 100644 arch/arm64/kvm/rme.c
>>
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 888f7c7abf54..76177c56f1ef 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -40,6 +40,7 @@
>>   #include <asm/kvm_nested.h>
>>   #include <asm/kvm_pkvm.h>
>>   #include <asm/kvm_ptrauth.h>
>> +#include <asm/kvm_rme.h>
>>   #include <asm/sections.h>
>>   
> 
> Nit: The header file <asm/kvm_rme.h> has been included to <asm/
> kvm_host.h> and
> <linux/kvm_host.h>, which has been included to arm.c. So this explicit
> inclusion
> can be dropped.

While it's true that it could be dropped because of the indirect
include, generally it's better to explicitly include a header file when
you are using the definitions from it. That way the code can be
refactored (e.g. if asm/kvm_host.h is changed to no longer needs the
header it can then safely drop the header include).

We have a similar situation with asm/kvm_asm.h being included both here
and in asm/kvm_host.h (and probably many others, this was just the first
I spotted).

>>   #include <kvm/arm_hypercalls.h>
>> @@ -59,6 +60,8 @@ enum kvm_wfx_trap_policy {
>>   static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly =
>> KVM_WFX_NOTRAP_SINGLE_TASK;
>>   static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly =
>> KVM_WFX_NOTRAP_SINGLE_TASK;
>>   +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
>> +
>>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>>     DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
>> @@ -2836,6 +2839,8 @@ static __init int kvm_arm_init(void)
>>         in_hyp_mode = is_kernel_in_hyp_mode();
>>   +    kvm_init_rme();
>> +
>>       if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>>           cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>>           kvm_info("Guests without required CPU erratum workarounds
>> can deadlock system!\n" \
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> new file mode 100644
>> index 000000000000..67cf2d94cb2d
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -0,0 +1,56 @@
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
>> +    unsigned short version_major, version_minor;
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
>> +        unsigned short high_version_major, high_version_minor;
>> +
>> +        high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>> +        high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>> +
>> +        kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.
>> %d\n",
>> +            version_major, version_minor,
>> +            high_version_major, high_version_minor,
>> +            RMI_ABI_MAJOR_VERSION,
>> +            RMI_ABI_MINOR_VERSION);
>> +        return -ENXIO;
>> +    }
>> +
>> +    kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +    return 0;
>> +}
>> +
>> +void kvm_init_rme(void)
>> +{
>> +    if (PAGE_SIZE != SZ_4K)
>> +        /* Only 4k page size on the host is supported */
>> +        return;
> 
> Nit: The comment can be moved before the check, something like below.
> Otherwise,
> {} is needed here.
> 
>     /* Only 4kB page size is supported */
>     if (PAGE_SIZE != SZ_4K)
>         return;
> 
>> +
>> +    if (rmi_check_version())
>> +        /* Continue without realm support */
>> +        return;
> 
> Nit: same as above.

Fair enough, I'm never sure what's best here - the comments are for the
error path "Continue without realm support [if we can't agree on a
version]", but it's a single statement so braces aren't needed. Still
the first instance can easily be hoisted above without losing its
meaning, and the second can be extended to clarify.

Thanks,
Steve

>> +
>> +    /* Future patch will enable static branch kvm_rme_is_available */
>> +}
> 
> Thanks,
> Gavin
> 


