Return-Path: <kvm+bounces-28635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F2D99A614
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B28661C239A2
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 14:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B99A21A712;
	Fri, 11 Oct 2024 14:14:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BBD721A6F1;
	Fri, 11 Oct 2024 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656075; cv=none; b=lhLo7NQLem1H9qlUb0Qd4t7D8O3SRjYWfI/tAQdJwrzAxYygHcNr3+L0I3vIRZOtaCbWR14un8rzgXzV2ODg7sOWeUGMbhNXmez9atKF+c4SmUFU8zmJnCFF+g3AAIP+M0M3J2DTWI5fsBy84sCjNDg1vaKxBv55K0L/HU2YS+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656075; c=relaxed/simple;
	bh=1hM8PIdzTTl0Yk1nkOCOVqrtci/YwOwp8fQa94Vp3ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3WND7bzUZzGUTuz6kZQHbt0a628ahxFj7pTyoWj/Yk8SEeo3yWBI2NFqD4W7oRYsckVBUvhU8m5ns8YKQ+rInm0gvTUyKUVLWQzt1tPDzBY3TPVpflDNu8wOYfA3NKQHXouC4tkcAurakAUjM974U1tCe0EOHZwbUT7CndoehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33747DA7;
	Fri, 11 Oct 2024 07:15:02 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B59763F5A1;
	Fri, 11 Oct 2024 07:14:28 -0700 (PDT)
Message-ID: <5540892e-bb25-47fe-8bf4-ac4481498470@arm.com>
Date: Fri, 11 Oct 2024 15:14:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/11] arm64: Detect if in a realm and set RIPAS RAM
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
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-3-steven.price@arm.com>
 <8a8ad27f-dc8f-4d44-bb35-67fd1133afbb@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8a8ad27f-dc8f-4d44-bb35-67fd1133afbb@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 08/10/2024 00:31, Gavin Shan wrote:
> On 10/5/24 12:42 AM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Detect that the VM is a realm guest by the presence of the RSI
>> interface. This is done after PSCI has been initialised so that we can
>> check the SMCCC conduit before making any RSI calls.
>>
>> If in a realm then all memory needs to be marked as RIPAS RAM initially,
>> the loader may or may not have done this for us. To be sure iterate over
>> all RAM and mark it as such. Any failure is fatal as that implies the
>> RAM regions passed to Linux are incorrect - which would mean failing
>> later when attempting to access non-existent RAM.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Co-developed-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v5:
>>   * Replace BUG_ON() with a panic() call that provides a message with the
>>     memory range that couldn't be set to RIPAS_RAM.
>>   * Move the call to arm64_rsi_init() later so that it is after PSCI,
>>     this means we can use arm_smccc_1_1_get_conduit() to check if it is
>>     safe to make RSI calls.
>> Changes since v4:
>>   * Minor tidy ups.
>> Changes since v3:
>>   * Provide safe/unsafe versions for converting memory to protected,
>>     using the safer version only for the early boot.
>>   * Use the new psci_early_test_conduit() function to avoid calling an
>>     SMC if EL3 is not present (or not configured to handle an SMC).
>> Changes since v2:
>>   * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
>>     static_key_false".
>>   * Rename set_memory_range() to rsi_set_memory_range().
>>   * Downgrade some BUG()s to WARN()s and handle the condition by
>>     propagating up the stack. Comment the remaining case that ends in a
>>     BUG() to explain why.
>>   * Rely on the return from rsi_request_version() rather than checking
>>     the version the RMM claims to support.
>>   * Rename the generic sounding arm64_setup_memory() to
>>     arm64_rsi_setup_memory() and move the call site to setup_arch().
>> ---
>>   arch/arm64/include/asm/rsi.h | 66 +++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/Makefile   |  3 +-
>>   arch/arm64/kernel/rsi.c      | 75 ++++++++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c    |  3 ++
>>   4 files changed, 146 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/rsi.h
>>   create mode 100644 arch/arm64/kernel/rsi.c
>>
> 
> Two nitpicks below.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> new file mode 100644
>> index 000000000000..e4c01796c618
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -0,0 +1,66 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2024 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_H_
>> +#define __ASM_RSI_H_
>> +
>> +#include <linux/errno.h>
>> +#include <linux/jump_label.h>
>> +#include <asm/rsi_cmds.h>
>> +
>> +DECLARE_STATIC_KEY_FALSE(rsi_present);
>> +
>> +void __init arm64_rsi_init(void);
>> +
>> +static inline bool is_realm_world(void)
>> +{
>> +    return static_branch_unlikely(&rsi_present);
>> +}
>> +
>> +static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t
>> end,
>> +                       enum ripas state, unsigned long flags)
>> +{
>> +    unsigned long ret;
>> +    phys_addr_t top;
>> +
>> +    while (start != end) {
>> +        ret = rsi_set_addr_range_state(start, end, state, flags, &top);
>> +        if (WARN_ON(ret || top < start || top > end))
>> +            return -EINVAL;
>> +        start = top;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
> 
> The WARN_ON() is redundant when the caller is arm64_rsi_setup_memory(),
> where
> system panic is invoked on any errors. So we perhaps need to drop the
> WARN_ON().

Actually this is error when I was preparing the series - the WARN_ON is
then dropped in the next patch. Thanks for pointing it out!

> [...]
> 
>> +
>> +static void __init arm64_rsi_setup_memory(void)
>> +{
>> +    u64 i;
>> +    phys_addr_t start, end;
>> +
>> +    /*
>> +     * Iterate over the available memory ranges and convert the state to
>> +     * protected memory. We should take extra care to ensure that we
>> DO NOT
>> +     * permit any "DESTROYED" pages to be converted to "RAM".
>> +     *
>> +     * panic() is used because if the attempt to switch the memory to
>> +     * protected has failed here, then future accesses to the memory are
>> +     * simply going to be reflected as a SEA (Synchronous External
>> Abort)
>> +     * which we can't handle.  Bailing out early prevents the guest
>> limping
>> +     * on and dying later.
>> +     */
>> +    for_each_mem_range(i, &start, &end) {
>> +        if (rsi_set_memory_range_protected_safe(start, end))
>> +            panic("Failed to set memory range to protected: %pa-%pa",
>> +                  &start, &end);
>> +    }
>> +}
>> +
> 
> {} is needed since the panic statement spans multiple lines.

Ack.

Thanks,
Steve


