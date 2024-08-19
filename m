Return-Path: <kvm+bounces-24525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1B9C956CC1
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80EC41F21D39
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6D016CD1B;
	Mon, 19 Aug 2024 14:10:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573AE16B399;
	Mon, 19 Aug 2024 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076623; cv=none; b=GF4kwj/49EvC6wGtBFJA4Z036u4WzC+iybBkALBHsqysle1g1SLE3E0JaOTNyP64/64QZB6TfeYgc0NzOxgnId+Sm3kiiVlKfoFC7J+YZvqaUpWQNBeFYdiW0hgCLGQaOEITxs7TQzMzrvLR/J0/t+uGD9OKuszkhRIzIQu4ABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076623; c=relaxed/simple;
	bh=Jgcmn7cNSHC9O5Fypdkuo7mZ5zRoudMi01BnYlAJV1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbEnn4G0kv6UxeRg7f3RuY+zxjl5kvC0Uvw/fWvK75wfm9S7tYcgYRSkXCp0m+Y7RQEO55Dn1c95DV692w+uCZmpTF6SA1gyGS0gj9tCtCGTnFzYJExf92bkKWc1TeLFH1alunnsc4p0VeSVz710sssGs3tipjzlltCgasemUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 956AD339;
	Mon, 19 Aug 2024 07:10:46 -0700 (PDT)
Received: from [10.57.85.21] (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8A073F73B;
	Mon, 19 Aug 2024 07:10:16 -0700 (PDT)
Message-ID: <d55a24d2-bad9-40c7-8a2e-4a7bebe9c682@arm.com>
Date: Mon, 19 Aug 2024 15:10:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com>
 <ff5a11d6-8208-4987-af03-f67b10cc5904@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ff5a11d6-8208-4987-af03-f67b10cc5904@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/08/2024 15:04, Suzuki K Poulose wrote:
> Hi Steven
> 
> On 19/08/2024 14:19, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Detect that the VM is a realm guest by the presence of the RSI
>> interface.
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
>>   arch/arm64/include/asm/rsi.h | 65 ++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/Makefile   |  3 +-
>>   arch/arm64/kernel/rsi.c      | 78 ++++++++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c    |  8 ++++
>>   4 files changed, 153 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/rsi.h
>>   create mode 100644 arch/arm64/kernel/rsi.c
>>
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> new file mode 100644
>> index 000000000000..2bc013badbc3
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2024 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RSI_H_
>> +#define __ASM_RSI_H_
>> +
>> +#include <linux/jump_label.h>
>> +#include <asm/rsi_cmds.h>
>> +
>> +DECLARE_STATIC_KEY_FALSE(rsi_present);
>> +
>> +void __init arm64_rsi_init(void);
>> +void __init arm64_rsi_setup_memory(void);
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
>> +/*
>> + * Convert the specified range to RAM. Do not use this if you rely on
>> the
>> + * contents of a page that may already be in RAM state.
>> + */
>> +static inline int rsi_set_memory_range_protected(phys_addr_t start,
>> +                         phys_addr_t end)
>> +{
>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
>> +                    RSI_CHANGE_DESTROYED);
>> +}
>> +
>> +/*
>> + * Convert the specified range to RAM. Do not convert any pages that
>> may have
>> + * been DESTROYED, without our permission.
>> + */
>> +static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
>> +                              phys_addr_t end)
>> +{
>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
>> +                    RSI_NO_CHANGE_DESTROYED);
>> +}
>> +
>> +static inline int rsi_set_memory_range_shared(phys_addr_t start,
>> +                          phys_addr_t end)
>> +{
>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
>> +                    RSI_NO_CHANGE_DESTROYED);
> 
> I think this should be RSI_CHANGE_DESTROYED, as we are transitioning a
> page to "shared" (i.e, IPA state to EMPTY) and we do not expect the data
> to be retained over the transition. Thus we do not care if the IPA was
> in RIPAS_DESTROYED.

Fair point - although something has gone wrong if the VMM has destroyed
the memory we're calling this on. But it's not going to cause problems
using RSI_CHANGE_DESTROYED and might be (slightly) more efficient.

Thanks,

Steve

> Rest looks good to me.
> 
> 
> Suzuki


