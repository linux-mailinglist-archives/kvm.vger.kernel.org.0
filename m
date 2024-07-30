Return-Path: <kvm+bounces-22675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C03C9413A4
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 15:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCC871F23CFF
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 13:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0201A08B1;
	Tue, 30 Jul 2024 13:51:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDFD198856;
	Tue, 30 Jul 2024 13:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722347506; cv=none; b=uRO/iBMhwiAvSw6W+I9HDimdeCSUQWHMF3RkGr98KTC4+X32DddBbG3RZYr6dCKu7kI5BAsdzNmXZ0KtHsWGkq++85bFATyxoiBPGDtE16qch83kXgN/k06Ith7KFaODe7prT6M3oTmmskXQitUc1smPn9Na5ZAP8p5TZ9soNno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722347506; c=relaxed/simple;
	bh=v84jDA2Jy0vq2wzWcyDW+Xy7r1OC4+RaSYYN0UBsC/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q3t5Z7fxELmMsbh10EA8L/QOK31T7aGN9c4yfYs3tfkoqskmWjyuUlRlio1l6d2wi4wI2CvtoveiOL/BPdX7+p5itfbLwjzlXJ1CwtVRAvPybckPX1F+jXeqAPiZlW/YTMqAScpriQN7xcS0lIi6/aGAWlVY6S6cQaWLJL16pbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB4C81007;
	Tue, 30 Jul 2024 06:52:09 -0700 (PDT)
Received: from [10.57.94.83] (unknown [10.57.94.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B50D63F766;
	Tue, 30 Jul 2024 06:51:40 -0700 (PDT)
Message-ID: <7203814a-1a1d-41c4-8fc5-95216e2febcd@arm.com>
Date: Tue, 30 Jul 2024 14:51:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/15] arm64: Detect if in a realm and set RIPAS RAM
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-4-steven.price@arm.com>
 <2b4f0496-99f4-4bc6-af6c-a8be8fca69a8@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <2b4f0496-99f4-4bc6-af6c-a8be8fca69a8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Gavin

Thanks for your review, comments inline.

On 30/07/2024 00:37, Gavin Shan wrote:
> On 7/1/24 7:54 PM, Steven Price wrote:
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
>>   arch/arm64/include/asm/rsi.h      | 64 +++++++++++++++++++++++++
>>   arch/arm64/include/asm/rsi_cmds.h | 22 +++++++++
>>   arch/arm64/kernel/Makefile        |  3 +-
>>   arch/arm64/kernel/rsi.c           | 77 +++++++++++++++++++++++++++++++
>>   arch/arm64/kernel/setup.c         |  8 ++++
>>   5 files changed, 173 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/rsi.h
>>   create mode 100644 arch/arm64/kernel/rsi.c
>>
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> new file mode 100644
>> index 000000000000..29fdc194d27b
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -0,0 +1,64 @@
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
> 
> @flags has been defined as int instead of unsigned long, which is 
> inconsistent
> to TF-RMM's definitions since it has type of 'unsigned long'.

Sorry, do you mean that TF-RMM treats the "flags" as an "int" instead of
unsigned long and we should be consistent with TF-RMM ? If so, I don't
think that is correct. We should be compliant to the RMM spec, which
describes "RsiRipasChangeFlags" as a 64bit value and thus must be
'unsigned long' as we used here.

> 
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
>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY, 0);
>> +}
>> +#endif
> 
> s/0/RSI_NO_CHANGE_DESTROYED

This is not required as we do not care if the GRANULE was destroyed or
not, since it is going to be "UNUSED" anyway in a protected way 
(RIPAS_EMPTY). And we do not rely on the contents of the memory being
preserved, when the page is made shared (In fact we cannot do that
with Arm CCA).

Thus we do not get any security benefits with the flag. The flag is ONLY
useful, when the Realm does a "blanket" IPA_STATE_SET(RIPAS_RAM) for
all of its memory area described as RAM. In this case, we want to make
sure that the Host hasn't destroyed any DATA that was loaded (and
measured) in the "NEW" state.

e.g, Host loads Kernel at Addr X in RAM (which is transitioned to 
RIPAS_RAM, measured in RIM by RMM) and ACTIVATEs the Realm. Host could 
then destroy some pages of the loaded image before the Realm boots (thus
transitioning into DESTROYED). But for the Realm, at early boot, it is
much easier to "mark" the entire RAM region as RIPAS_RAM,


for_each_memory_region(region) {
	set_ipa_state_range(region->start, region->end, RIPAS_RAM, 
RSI_NO_CHANGE_DESTROYED);
}

rather than performing:

for_each_granule(g in DRAM) :

switch (rsi_get_ipa_state(g)) {
case RIPAS_EMPTY: rsi_set_ipa_state(g, RIPAS_RAM); break;
case RIPAS_RAM: break; /* Nothing to do */
case DESTROYED: BUG();
}





> s/#endif/#endif /* __ASM_RSI_H_ */
> 
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h 
>> b/arch/arm64/include/asm/rsi_cmds.h
>> index 89e907f3af0c..acb557dd4b88 100644
>> --- a/arch/arm64/include/asm/rsi_cmds.h
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -10,6 +10,11 @@
>>   #include <asm/rsi_smc.h>
>> +enum ripas {
>> +    RSI_RIPAS_EMPTY,
>> +    RSI_RIPAS_RAM,
>> +};
>> +
>>   static inline unsigned long rsi_request_version(unsigned long req,
>>                           unsigned long *out_lower,
>>                           unsigned long *out_higher)
>> @@ -35,4 +40,21 @@ static inline unsigned long 
>> rsi_get_realm_config(struct realm_config *cfg)
>>       return res.a0;
>>   }
>> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>> +                             phys_addr_t end,
>> +                             enum ripas state,
>> +                             unsigned long flags,
>> +                             phys_addr_t *top)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
>> +              flags, 0, 0, 0, &res);
>> +
>> +    if (top)
>> +        *top = res.a1;
>> +
>> +    return res.a0;
>> +}
>> +
>>   #endif
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 763824963ed1..a483b916ed11 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -33,7 +33,8 @@ obj-y            := debug-monitors.o entry.o irq.o 
>> fpsimd.o        \
>>                  return_address.o cpuinfo.o cpu_errata.o        \
>>                  cpufeature.o alternative.o cacheinfo.o        \
>>                  smp.o smp_spin_table.o topology.o smccc-call.o    \
>> -               syscall.o proton-pack.o idle.o patching.o pi/
>> +               syscall.o proton-pack.o idle.o patching.o pi/    \
>> +               rsi.o
>>   obj-$(CONFIG_COMPAT)            += sys32.o signal32.o            \
>>                          sys_compat.o
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> new file mode 100644
>> index 000000000000..f01bff9dab04
>> --- /dev/null
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -0,0 +1,77 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/jump_label.h>
>> +#include <linux/memblock.h>
>> +#include <linux/psci.h>
>> +#include <asm/rsi.h>
>> +
>> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>> +EXPORT_SYMBOL(rsi_present);
>> +
>> +static bool rsi_version_matches(void)
>> +{
>> +    unsigned long ver_lower, ver_higher;
>> +    unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
>> +                        &ver_lower,
>> +                        &ver_higher);
>> +
>> +    if (ret == SMCCC_RET_NOT_SUPPORTED)
>> +        return false;
>> +
>> +    if (ret != RSI_SUCCESS) {
>> +        pr_err("RME: RMM doesn't support RSI version %u.%u. Supported 
>> range: %lu.%lu-%lu.%lu\n",
>> +               RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
>> +               RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>> +               RSI_ABI_VERSION_GET_MINOR(ver_lower),
>> +               RSI_ABI_VERSION_GET_MAJOR(ver_higher),
>> +               RSI_ABI_VERSION_GET_MINOR(ver_higher));
>> +        return false;
>> +    }
>> +
>> +    pr_info("RME: Using RSI version %lu.%lu\n",
>> +        RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>> +        RSI_ABI_VERSION_GET_MINOR(ver_lower));
>> +
>> +    return true;
>> +}
>> +
>> +void __init arm64_rsi_setup_memory(void)
>> +{
>> +    u64 i;
>> +    phys_addr_t start, end;
>> +
>> +    if (!is_realm_world())
>> +        return;
>> +
>> +    /*
>> +     * Iterate over the available memory ranges and convert the state to
>                                               
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                                               blocks and convert them to

TBH, I don't see any significant difference between the two. Am I
missing something ?

> 
>> +     * protected memory. We should take extra care to ensure that we 
>> DO NOT
>> +     * permit any "DESTROYED" pages to be converted to "RAM".
>> +     *
>> +     * BUG_ON is used because if the attempt to switch the memory to
>> +     * protected has failed here, then future accesses to the memory are
>> +     * simply going to be reflected as a fault which we can't handle.
>> +     * Bailing out early prevents the guest limping on and dieing later.
>> +     */
>> +    for_each_mem_range(i, &start, &end) {
>> +        BUG_ON(rsi_set_memory_range_protected_safe(start, end));
>> +    }
>> +}
>> +
> 
> If I'm understanding the code completely, this changes the memory state 
> from
> RIPAS_EMPTY to RIPAS_RAM so that the following page faults can be routed to
> host properly. Otherwise, a SEA is injected to the realm according to
> tf-rmm/runtime/core/exit.c::handle_data_abort(). The comments can be more
> explicit to replace "fault" with "SEA (Synchronous External Abort)".

Agreed.  SEA is more accurate than fault.

> 
> Besides, this forces a guest exit with reason RMI_EXIT_RIPAS_CHANGE 
> which is
> handled by the host, where RMI_RTT_SET_RIPAS is triggered to convert the 
> memory
> state from RIPAS_EMPTY to RIPAS_RAM. The question is why the conversion 
> can't
> be done by VMM (QEMU)?

A VMM could potentially do this via INIT_RIPAS at Realm creation for
the entire RAM. But, as far as the Realm is concerned it is always safer 
to do this step and is relatively a lightweight operation at boot. 
Physical pages need not be allocated/mapped in stage2 with the IPA State 
change.


Suzuki
> 
>> +void __init arm64_rsi_init(void)
>> +{
>> +    /*
>> +     * If PSCI isn't using SMC, RMM isn't present. Don't try to 
>> execute an
>> +     * SMC as it could be UNDEFINED.
>> +     */
>> +    if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
>> +        return;
>> +    if (!rsi_version_matches())
>> +        return;
>> +
>> +    static_branch_enable(&rsi_present);
>> +}
>> +
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index a096e2451044..143f87615af0 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -43,6 +43,7 @@
>>   #include <asm/cpu_ops.h>
>>   #include <asm/kasan.h>
>>   #include <asm/numa.h>
>> +#include <asm/rsi.h>
>>   #include <asm/scs.h>
>>   #include <asm/sections.h>
>>   #include <asm/setup.h>
>> @@ -293,6 +294,11 @@ void __init __no_sanitize_address setup_arch(char 
>> **cmdline_p)
>>        * cpufeature code and early parameters.
>>        */
>>       jump_label_init();
>> +    /*
>> +     * Init RSI before early param so that "earlycon" console uses the
>> +     * shared alias when in a realm
>> +     */
>> +    arm64_rsi_init();
>>       parse_early_param();
>>       dynamic_scs_init();
>> @@ -328,6 +334,8 @@ void __init __no_sanitize_address setup_arch(char 
>> **cmdline_p)
>>       arm64_memblock_init();
>> +    arm64_rsi_setup_memory();
>> +
>>       paging_init();
>>       acpi_table_upgrade();
> 
> Thanks,
> Gavin
> 


