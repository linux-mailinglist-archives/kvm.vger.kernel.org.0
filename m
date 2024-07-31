Return-Path: <kvm+bounces-22728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CAE942752
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B84CFB220FB
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4A51A4B55;
	Wed, 31 Jul 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D44Gbqgk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090D21A4B53
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722409404; cv=none; b=ndFNnQEUdyREoh8J94GKegE0Boo4uvVc7GIvS7d2toupI948Bcl7DLErD1CG6tcJBHLxMW8FhCT4jZ9k2Zgeayn9sxr1/urdMGzazldsTLoTFRszcxXrUgueEhVvn0Hhc/9dlK6Se+YhjALu1vBxSCJ3ErEfNeZmeavMKca3ttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722409404; c=relaxed/simple;
	bh=n6d2o3izcW8oiD2F/fNtuhRCdX8R/aQslO/wnQQ78lA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dvkovjkwusrNo39KGa0H+CmbS1JRFazl7k4fAuQSrq24ZvBZgjtzQggY1jBWzB+JgMSvzG5TnAgoBmuUsyXu9B0Ya9wo6hgaJ/Q0WrJm8mHkI9KCGQMuPs0bVm//3LSd3YzcyR66p449XUxbGhOgyEHfCpSIRpZGsciW/Vim/EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D44Gbqgk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722409401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LAdvZ+eMAZtmcOE4Ce0xGHUX2arEN9HYUPCWONQAJT8=;
	b=D44GbqgkO49x3M950m4J8fVIczdyJl0lhrarJoA7jouaIUWwCuf/wmOXA4hSl02E9n06z7
	TNBe4wcw97/pBb0RPczd+8AH8199KTTJ6UeEErWw//apcwhG5YthsiSaDiLWzkoRrd7/LR
	Uj3KcmBgxnar/t4DbHwlwFxuIrc6T5M=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-8wEechY2MU-SqrzKT21Cuw-1; Wed, 31 Jul 2024 03:03:19 -0400
X-MC-Unique: 8wEechY2MU-SqrzKT21Cuw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1fb1759e34dso33675905ad.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 00:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722409398; x=1723014198;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAdvZ+eMAZtmcOE4Ce0xGHUX2arEN9HYUPCWONQAJT8=;
        b=BYUh/YZpFe0DzrkkCu1OSBZlFDGsWFHj9vCh2NmLEPtbkMeG3J0I3YySy16u0lpo4u
         VF+81uSQ6KVGRnKjCwJ6lYusywFkGC/TGAEbfxCbQGuTc8PMlTjFz1AfIzqoAFSqCfYx
         wCQHvF/E6qR6lDy2dXjsZbAzEeVg2nptTLU0mdxDWpUB/kQ0hf2JkEDKMFUgNt3TCZsP
         hD7lKNO7guYu+CimlURLuGlCQwPowsoJB30W6LKI8noG1qwEIlisQIYeNm30IeZtF3wc
         a/Cj5kCOkJ2/7nqYWIOi9qNBxTFqWA/rURXFpehYAszANkt1BF4HpjGLddFSaYwYVe5I
         NvUw==
X-Forwarded-Encrypted: i=1; AJvYcCXM/1hCbrVu/w0QYRhMJfwsmEBzd1ngj1kpEKmxHBlvJRtm73XMTuBAa11NCsIgTwYSYcA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCL5357wHC+WXf2BNJ8M5tM0007srSf7yAXqTuCNxgU3rh26cA
	YYC/F4mcMVVhplFsPpdAKx22/3QpzqnLajCZmSP0Wwmtf+qsSZM6X9YlGkuqW9oqLQEip45rGzH
	bmgOB1g2Dz5U2v7+INabI46Hn1TXOOTOrHtXMX9ZvU48DAvv4wg==
X-Received: by 2002:a17:903:25c5:b0:1fd:5fa0:e99b with SMTP id d9443c01a7336-1ff04932858mr99306035ad.57.1722409397868;
        Wed, 31 Jul 2024 00:03:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqhGyvdB5DyHe3W381+2OBrcPmLv1DDfOJxLzBkjNCIHRDY9968utATm5TcMH/dNiQM08rBQ==
X-Received: by 2002:a17:903:25c5:b0:1fd:5fa0:e99b with SMTP id d9443c01a7336-1ff04932858mr99305825ad.57.1722409397396;
        Wed, 31 Jul 2024 00:03:17 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee5734sm112968765ad.135.2024.07.31.00.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 00:03:16 -0700 (PDT)
Message-ID: <3e30f7b8-c7a4-4ab9-8afc-a48c84e62728@redhat.com>
Date: Wed, 31 Jul 2024 17:03:07 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/15] arm64: Detect if in a realm and set RIPAS RAM
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 <7203814a-1a1d-41c4-8fc5-95216e2febcd@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <7203814a-1a1d-41c4-8fc5-95216e2febcd@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Suzuki,

On 7/30/24 11:51 PM, Suzuki K Poulose wrote:
> On 30/07/2024 00:37, Gavin Shan wrote:
>> On 7/1/24 7:54 PM, Steven Price wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> Detect that the VM is a realm guest by the presence of the RSI
>>> interface.
>>>
>>> If in a realm then all memory needs to be marked as RIPAS RAM initially,
>>> the loader may or may not have done this for us. To be sure iterate over
>>> all RAM and mark it as such. Any failure is fatal as that implies the
>>> RAM regions passed to Linux are incorrect - which would mean failing
>>> later when attempting to access non-existent RAM.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Co-developed-by: Steven Price <steven.price@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v3:
>>>   * Provide safe/unsafe versions for converting memory to protected,
>>>     using the safer version only for the early boot.
>>>   * Use the new psci_early_test_conduit() function to avoid calling an
>>>     SMC if EL3 is not present (or not configured to handle an SMC).
>>> Changes since v2:
>>>   * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
>>>     static_key_false".
>>>   * Rename set_memory_range() to rsi_set_memory_range().
>>>   * Downgrade some BUG()s to WARN()s and handle the condition by
>>>     propagating up the stack. Comment the remaining case that ends in a
>>>     BUG() to explain why.
>>>   * Rely on the return from rsi_request_version() rather than checking
>>>     the version the RMM claims to support.
>>>   * Rename the generic sounding arm64_setup_memory() to
>>>     arm64_rsi_setup_memory() and move the call site to setup_arch().
>>> ---
>>>   arch/arm64/include/asm/rsi.h      | 64 +++++++++++++++++++++++++
>>>   arch/arm64/include/asm/rsi_cmds.h | 22 +++++++++
>>>   arch/arm64/kernel/Makefile        |  3 +-
>>>   arch/arm64/kernel/rsi.c           | 77 +++++++++++++++++++++++++++++++
>>>   arch/arm64/kernel/setup.c         |  8 ++++
>>>   5 files changed, 173 insertions(+), 1 deletion(-)
>>>   create mode 100644 arch/arm64/include/asm/rsi.h
>>>   create mode 100644 arch/arm64/kernel/rsi.c
>>>
>>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>>> new file mode 100644
>>> index 000000000000..29fdc194d27b
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/rsi.h
>>> @@ -0,0 +1,64 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/*
>>> + * Copyright (C) 2024 ARM Ltd.
>>> + */
>>> +
>>> +#ifndef __ASM_RSI_H_
>>> +#define __ASM_RSI_H_
>>> +
>>> +#include <linux/jump_label.h>
>>> +#include <asm/rsi_cmds.h>
>>> +
>>> +DECLARE_STATIC_KEY_FALSE(rsi_present);
>>> +
>>> +void __init arm64_rsi_init(void);
>>> +void __init arm64_rsi_setup_memory(void);
>>> +static inline bool is_realm_world(void)
>>> +{
>>> +    return static_branch_unlikely(&rsi_present);
>>> +}
>>> +
>>> +static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
>>> +                       enum ripas state, unsigned long flags)
>>> +{
>>> +    unsigned long ret;
>>> +    phys_addr_t top;
>>> +
>>> +    while (start != end) {
>>> +        ret = rsi_set_addr_range_state(start, end, state, flags, &top);
>>> +        if (WARN_ON(ret || top < start || top > end))
>>> +            return -EINVAL;
>>> +        start = top;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>
>> @flags has been defined as int instead of unsigned long, which is inconsistent
>> to TF-RMM's definitions since it has type of 'unsigned long'.
> 
> Sorry, do you mean that TF-RMM treats the "flags" as an "int" instead of
> unsigned long and we should be consistent with TF-RMM ? If so, I don't
> think that is correct. We should be compliant to the RMM spec, which
> describes "RsiRipasChangeFlags" as a 64bit value and thus must be
> 'unsigned long' as we used here.
> 

No worries, I guess I didn't make myself clear enough. Sorry about that.
Let me explain it with more details. @flag is passed down as the following
call trace shows.

   rsi_set_memory_range_protected_safe
     rsi_set_memory_range                             // RSI_NO_CHANGE_DESTROYED
       rsi_set_addr_range_state
         arm_smccc_smc(SMC_RSI_IPA_STATE_SET, ...)

The kernel defines RSI_CHANGE_DESTROYED as a "int" value, but same flag has
been defined as 'unsigned int' value in tf-rmm. However, kernel uses 'unsigned
long' flags to hold it.

   // kernel's prototype - 'unsigned long flags'
   static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
                                        enum ripas state, unsigned long flags)

   // kernel's definition - 'int'
   #define RSI_CHANGE_DESTROYED    0

   // tf-rmm's definition - 'unsigned int'
   #define U(_x)                 (unsigned int)(_x)
   #define RSI_CHANGE_DESTROYED  U(0)

>>
>>> +/*
>>> + * Convert the specified range to RAM. Do not use this if you rely on the
>>> + * contents of a page that may already be in RAM state.
>>> + */
>>> +static inline int rsi_set_memory_range_protected(phys_addr_t start,
>>> +                         phys_addr_t end)
>>> +{
>>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
>>> +                    RSI_CHANGE_DESTROYED);
>>> +}
>>> +
>>> +/*
>>> + * Convert the specified range to RAM. Do not convert any pages that may have
>>> + * been DESTROYED, without our permission.
>>> + */
>>> +static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
>>> +                              phys_addr_t end)
>>> +{
>>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
>>> +                    RSI_NO_CHANGE_DESTROYED);
>>> +}
>>> +
>>> +static inline int rsi_set_memory_range_shared(phys_addr_t start,
>>> +                          phys_addr_t end)
>>> +{
>>> +    return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY, 0);
>>> +}
>>> +#endif
>>
>> s/0/RSI_NO_CHANGE_DESTROYED
> 
> This is not required as we do not care if the GRANULE was destroyed or
> not, since it is going to be "UNUSED" anyway in a protected way (RIPAS_EMPTY). And we do not rely on the contents of the memory being
> preserved, when the page is made shared (In fact we cannot do that
> with Arm CCA).
> 
> Thus we do not get any security benefits with the flag. The flag is ONLY
> useful, when the Realm does a "blanket" IPA_STATE_SET(RIPAS_RAM) for
> all of its memory area described as RAM. In this case, we want to make
> sure that the Host hasn't destroyed any DATA that was loaded (and
> measured) in the "NEW" state.
> 
> e.g, Host loads Kernel at Addr X in RAM (which is transitioned to RIPAS_RAM, measured in RIM by RMM) and ACTIVATEs the Realm. Host could then destroy some pages of the loaded image before the Realm boots (thus
> transitioning into DESTROYED). But for the Realm, at early boot, it is
> much easier to "mark" the entire RAM region as RIPAS_RAM,
> 
> 
> for_each_memory_region(region) {
>      set_ipa_state_range(region->start, region->end, RIPAS_RAM, RSI_NO_CHANGE_DESTROYED);
> }
> 
> rather than performing:
> 
> for_each_granule(g in DRAM) :
> 
> switch (rsi_get_ipa_state(g)) {
> case RIPAS_EMPTY: rsi_set_ipa_state(g, RIPAS_RAM); break;
> case RIPAS_RAM: break; /* Nothing to do */
> case DESTROYED: BUG();
> }
> 
> 

The point was 0 and RSI_NO_CHANGE_DESTROYED are interchangeable. Since RSI_NO_CHANGE_DESTROYED
has been defined as 0, why we don't used RSI_NO_CHANGE_DESTROYED?

> 
>> s/#endif/#endif /* __ASM_RSI_H_ */
>>
>>> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
>>> index 89e907f3af0c..acb557dd4b88 100644
>>> --- a/arch/arm64/include/asm/rsi_cmds.h
>>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>>> @@ -10,6 +10,11 @@
>>>   #include <asm/rsi_smc.h>
>>> +enum ripas {
>>> +    RSI_RIPAS_EMPTY,
>>> +    RSI_RIPAS_RAM,
>>> +};
>>> +
>>>   static inline unsigned long rsi_request_version(unsigned long req,
>>>                           unsigned long *out_lower,
>>>                           unsigned long *out_higher)
>>> @@ -35,4 +40,21 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
>>>       return res.a0;
>>>   }
>>> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>>> +                             phys_addr_t end,
>>> +                             enum ripas state,
>>> +                             unsigned long flags,
>>> +                             phys_addr_t *top)
>>> +{
>>> +    struct arm_smccc_res res;
>>> +
>>> +    arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
>>> +              flags, 0, 0, 0, &res);
>>> +
>>> +    if (top)
>>> +        *top = res.a1;
>>> +
>>> +    return res.a0;
>>> +}
>>> +
>>>   #endif
>>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>>> index 763824963ed1..a483b916ed11 100644
>>> --- a/arch/arm64/kernel/Makefile
>>> +++ b/arch/arm64/kernel/Makefile
>>> @@ -33,7 +33,8 @@ obj-y            := debug-monitors.o entry.o irq.o fpsimd.o        \
>>>                  return_address.o cpuinfo.o cpu_errata.o        \
>>>                  cpufeature.o alternative.o cacheinfo.o        \
>>>                  smp.o smp_spin_table.o topology.o smccc-call.o    \
>>> -               syscall.o proton-pack.o idle.o patching.o pi/
>>> +               syscall.o proton-pack.o idle.o patching.o pi/    \
>>> +               rsi.o
>>>   obj-$(CONFIG_COMPAT)            += sys32.o signal32.o            \
>>>                          sys_compat.o
>>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>>> new file mode 100644
>>> index 000000000000..f01bff9dab04
>>> --- /dev/null
>>> +++ b/arch/arm64/kernel/rsi.c
>>> @@ -0,0 +1,77 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/jump_label.h>
>>> +#include <linux/memblock.h>
>>> +#include <linux/psci.h>
>>> +#include <asm/rsi.h>
>>> +
>>> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
>>> +EXPORT_SYMBOL(rsi_present);
>>> +
>>> +static bool rsi_version_matches(void)
>>> +{
>>> +    unsigned long ver_lower, ver_higher;
>>> +    unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
>>> +                        &ver_lower,
>>> +                        &ver_higher);
>>> +
>>> +    if (ret == SMCCC_RET_NOT_SUPPORTED)
>>> +        return false;
>>> +
>>> +    if (ret != RSI_SUCCESS) {
>>> +        pr_err("RME: RMM doesn't support RSI version %u.%u. Supported range: %lu.%lu-%lu.%lu\n",
>>> +               RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
>>> +               RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>>> +               RSI_ABI_VERSION_GET_MINOR(ver_lower),
>>> +               RSI_ABI_VERSION_GET_MAJOR(ver_higher),
>>> +               RSI_ABI_VERSION_GET_MINOR(ver_higher));
>>> +        return false;
>>> +    }
>>> +
>>> +    pr_info("RME: Using RSI version %lu.%lu\n",
>>> +        RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>>> +        RSI_ABI_VERSION_GET_MINOR(ver_lower));
>>> +
>>> +    return true;
>>> +}
>>> +
>>> +void __init arm64_rsi_setup_memory(void)
>>> +{
>>> +    u64 i;
>>> +    phys_addr_t start, end;
>>> +
>>> +    if (!is_realm_world())
>>> +        return;
>>> +
>>> +    /*
>>> +     * Iterate over the available memory ranges and convert the state to
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>                                               blocks and convert them to
> 
> TBH, I don't see any significant difference between the two. Am I
> missing something ?
> 

for_each_mem_range() is a helper provided by memory block management module.
So 'memory block' sounds like more accurate than broadly used term "memory
range" here.

>>
>>> +     * protected memory. We should take extra care to ensure that we DO NOT
>>> +     * permit any "DESTROYED" pages to be converted to "RAM".
>>> +     *
>>> +     * BUG_ON is used because if the attempt to switch the memory to
>>> +     * protected has failed here, then future accesses to the memory are
>>> +     * simply going to be reflected as a fault which we can't handle.
>>> +     * Bailing out early prevents the guest limping on and dieing later.
>>> +     */
>>> +    for_each_mem_range(i, &start, &end) {
>>> +        BUG_ON(rsi_set_memory_range_protected_safe(start, end));
>>> +    }
>>> +}
>>> +
>>
>> If I'm understanding the code completely, this changes the memory state from
>> RIPAS_EMPTY to RIPAS_RAM so that the following page faults can be routed to
>> host properly. Otherwise, a SEA is injected to the realm according to
>> tf-rmm/runtime/core/exit.c::handle_data_abort(). The comments can be more
>> explicit to replace "fault" with "SEA (Synchronous External Abort)".
> 
> Agreed.  SEA is more accurate than fault.
> 

Ok.

>>
>> Besides, this forces a guest exit with reason RMI_EXIT_RIPAS_CHANGE which is
>> handled by the host, where RMI_RTT_SET_RIPAS is triggered to convert the memory
>> state from RIPAS_EMPTY to RIPAS_RAM. The question is why the conversion can't
>> be done by VMM (QEMU)?
> 
> A VMM could potentially do this via INIT_RIPAS at Realm creation for
> the entire RAM. But, as far as the Realm is concerned it is always safer to do this step and is relatively a lightweight operation at boot. Physical pages need not be allocated/mapped in stage2 with the IPA State change.
> 

Ok. Thanks for the explanation.

> 
> Suzuki
>>
>>> +void __init arm64_rsi_init(void)
>>> +{
>>> +    /*
>>> +     * If PSCI isn't using SMC, RMM isn't present. Don't try to execute an
>>> +     * SMC as it could be UNDEFINED.
>>> +     */
>>> +    if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
>>> +        return;
>>> +    if (!rsi_version_matches())
>>> +        return;
>>> +
>>> +    static_branch_enable(&rsi_present);
>>> +}
>>> +
>>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>>> index a096e2451044..143f87615af0 100644
>>> --- a/arch/arm64/kernel/setup.c
>>> +++ b/arch/arm64/kernel/setup.c
>>> @@ -43,6 +43,7 @@
>>>   #include <asm/cpu_ops.h>
>>>   #include <asm/kasan.h>
>>>   #include <asm/numa.h>
>>> +#include <asm/rsi.h>
>>>   #include <asm/scs.h>
>>>   #include <asm/sections.h>
>>>   #include <asm/setup.h>
>>> @@ -293,6 +294,11 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>>        * cpufeature code and early parameters.
>>>        */
>>>       jump_label_init();
>>> +    /*
>>> +     * Init RSI before early param so that "earlycon" console uses the
>>> +     * shared alias when in a realm
>>> +     */
>>> +    arm64_rsi_init();
>>>       parse_early_param();
>>>       dynamic_scs_init();
>>> @@ -328,6 +334,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>>       arm64_memblock_init();
>>> +    arm64_rsi_setup_memory();
>>> +
>>>       paging_init();
>>>       acpi_table_upgrade();
>>

Thanks,
Gavin


