Return-Path: <kvm+bounces-26013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C20E996F5FA
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76FBC283D06
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049921CFEAD;
	Fri,  6 Sep 2024 13:55:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070661CF2B3;
	Fri,  6 Sep 2024 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630911; cv=none; b=mvXdJqsZPDLioxkKJWJ7U2oTH5tj7hCQQdYJrKVK8uwfZDSuUAquDr/2VsoyrSUFE/5TWnfmqql4OtGQ+RmH4kEsF4K0lq0rvDVxw6umGrhlF+8sS5Xd8i4ZLf4qDUWZ8bVh6clgePE/Em822Nem0WTO373tSrmHEc+t+7WG27A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630911; c=relaxed/simple;
	bh=oqZ+WpHd3rE4CnKLStyBnVW9tRRPxGCdLI5yqLavC8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mgy467JRuWfDVe2AgID7enPKZ3Ywg0lQoxBauXQlanCRsFnirzTd7zmAQ21/DAbgY9+AeuNWtGcvnkaJyDPzBEc+wRuNpg++ZhdzpiyJ6D6FTy7NqHpj3V2mNHGRdLGsbFnDgLgKlyi2XqVAkJwxwZJ+UFUi9Dnz57BsCfLv0i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E0FDFEC;
	Fri,  6 Sep 2024 06:55:34 -0700 (PDT)
Received: from [10.1.36.22] (e122027.cambridge.arm.com [10.1.36.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B883D3F844;
	Fri,  6 Sep 2024 06:55:03 -0700 (PDT)
Message-ID: <8a675a19-52c1-43c7-b560-fbadce0c5145@arm.com>
Date: Fri, 6 Sep 2024 14:55:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an
 MMIO is protected
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
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-8-steven.price@arm.com>
 <fe3da777-c6de-451d-8a8a-19fdda8e82e5@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <fe3da777-c6de-451d-8a8a-19fdda8e82e5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/09/2024 05:32, Gavin Shan wrote:
> Hi Steven,
> 
> On 8/19/24 11:19 PM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> On Arm CCA, with RMM-v1.0, all MMIO regions are shared. However, in
>> the future, an Arm CCA-v1.0 compliant guest may be run in a lesser
>> privileged partition in the Realm World (with Arm CCA-v1.1 Planes
>> feature). In this case, some of the MMIO regions may be emulated
>> by a higher privileged component in the Realm world, i.e, protected.
>>
>> Thus the guest must decide today, whether a given MMIO region is shared
>> vs Protected and create the stage1 mapping accordingly. On Arm CCA, this
>> detection is based on the "IPA State" (RIPAS == RIPAS_IO). Provide a
>> helper to run this check on a given range of MMIO.
>>
>> Also, provide a arm64 helper which may be hooked in by other solutions.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v5
>> ---
>>   arch/arm64/include/asm/io.h       |  8 ++++++++
>>   arch/arm64/include/asm/rsi.h      |  3 +++
>>   arch/arm64/include/asm/rsi_cmds.h | 21 +++++++++++++++++++++
>>   arch/arm64/kernel/rsi.c           | 26 ++++++++++++++++++++++++++
>>   4 files changed, 58 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 1ada23a6ec19..a6c551c5e44e 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -17,6 +17,7 @@
>>   #include <asm/early_ioremap.h>
>>   #include <asm/alternative.h>
>>   #include <asm/cpufeature.h>
>> +#include <asm/rsi.h>
>>     /*
>>    * Generic IO read/write.  These perform native-endian accesses.
>> @@ -318,4 +319,11 @@ extern bool
>> arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
>>                       unsigned long flags);
>>   #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
>>   +static inline bool arm64_is_iomem_private(phys_addr_t phys_addr,
>> size_t size)
>> +{
>> +    if (unlikely(is_realm_world()))
>> +        return arm64_rsi_is_protected_mmio(phys_addr, size);
>> +    return false;
>> +}
>> +
>>   #endif    /* __ASM_IO_H */
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> index 2bc013badbc3..e31231b50b6a 100644
>> --- a/arch/arm64/include/asm/rsi.h
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -13,6 +13,9 @@ DECLARE_STATIC_KEY_FALSE(rsi_present);
>>     void __init arm64_rsi_init(void);
>>   void __init arm64_rsi_setup_memory(void);
>> +
>> +bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size);
>> +
>>   static inline bool is_realm_world(void)
>>   {
>>       return static_branch_unlikely(&rsi_present);
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h
>> b/arch/arm64/include/asm/rsi_cmds.h
>> index 968b03f4e703..c2363f36d167 100644
>> --- a/arch/arm64/include/asm/rsi_cmds.h
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -45,6 +45,27 @@ static inline unsigned long
>> rsi_get_realm_config(struct realm_config *cfg)
>>       return res.a0;
>>   }
>>   +static inline unsigned long rsi_ipa_state_get(phys_addr_t start,
>> +                          phys_addr_t end,
>> +                          enum ripas *state,
>> +                          phys_addr_t *top)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_smc(SMC_RSI_IPA_STATE_GET,
>> +              start, end, 0, 0, 0, 0, 0,
>> +              &res);
>> +
>> +    if (res.a0 == RSI_SUCCESS) {
>> +        if (top)
>> +            *top = res.a1;
>> +        if (state)
>> +            *state = res.a2;
>> +    }
>> +
>> +    return res.a0;
>> +}
>> +
>>   static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
>>                                phys_addr_t end,
>>                                enum ripas state,
>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index e968a5c9929e..381a5b9a5333 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -67,6 +67,32 @@ void __init arm64_rsi_setup_memory(void)
>>       }
>>   }
>>   +bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
>> +{
>> +    enum ripas ripas;
>> +    phys_addr_t end, top;
>> +
>> +    /* Overflow ? */
>> +    if (WARN_ON(base + size < base))
>> +        return false;
>> +
>> +    end = ALIGN(base + size, RSI_GRANULE_SIZE);
>> +    base = ALIGN_DOWN(base, RSI_GRANULE_SIZE);
>> +
>> +    while (base < end) {
>> +        if (WARN_ON(rsi_ipa_state_get(base, end, &ripas, &top)))
>> +            break;
>> +        if (WARN_ON(top <= base))
>> +            break;
>> +        if (ripas != RSI_RIPAS_IO)
>> +            break;
>> +        base = top;
>> +    }
>> +
>> +    return (size && base >= end);
>> +}
> 
> I don't understand why @size needs to be checked here. Its initial value
> taken from the input parameter should be larger than zero and its value
> is never updated in the loop. So I'm understanding @size is always larger
> than zero, and the condition would be something like below if I'm correct.

Yes you are correct. I'm not entirely sure why it was written that way.
The only change dropping 'size' as you suggest is that a zero-sized
region is considered protected. But I'd consider it a bug if this is
called with size=0. I'll drop 'size' here.

>        return (base >= end);     /* RSI_RIPAS_IO returned for all
> granules */
> 
> Another issue is @top is always zero with the latest tf-rmm. More details
> are provided below.

That suggests that you are not actually using the 'latest' tf-rmm ;)
(for some definition of 'latest' which might not be obvious!)

From the cover letter:

> As mentioned above the new RMM specification means that corresponding
> changes need to be made in the RMM, at this time these changes are still
> in review (see 'topics/rmm-1.0-rel0-rc1'). So you'll need to fetch the
> changes[3] from the gerrit instance until they are pushed to the main
> branch.
>
> [3] https://review.trustedfirmware.org/c/TF-RMM/tf-rmm/+/30485

Sorry, I should probably have made this much more prominent in the cover
letter.

Running something like...

 git fetch https://git.trustedfirmware.org/TF-RMM/tf-rmm.git \
	refs/changes/85/30485/11

... should get you the latest. Hopefully these changes will get merged
to the main branch soon.

Steve

>> +EXPORT_SYMBOL(arm64_rsi_is_protected_mmio);
>> +
>>   void __init arm64_rsi_init(void)
>>   {
>>       /*
> 
> The unexpected calltrace is continuously observed with host/v4, guest/v5
> and
> latest upstream tf-rmm on 'WARN_ON(top <= base)' because @top is never
> updated
> by the latest tf-rmm. The following call path indicates how
> SMC_RSI_IPA_STATE_GET
> is handled by tf-rmm. I don't see RSI_RIPAS_IO is defined there and @top is
> updated.
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/kernel/rsi.c:103
> arm64_rsi_is_protected_mmio+0xf0/0x110
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
> 6.11.0-rc1-gavin-g3527d001084e #1
> [    0.000000] Hardware name: linux,dummy-virt (DT)
> [    0.000000] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS
> BTYPE=--)
> [    0.000000] pc : arm64_rsi_is_protected_mmio+0xf0/0x110
> [    0.000000] lr : arm64_rsi_is_protected_mmio+0x80/0x110
> [    0.000000] sp : ffffcd7097053bf0
> [    0.000000] x29: ffffcd7097053c30 x28: 0000000000000000 x27:
> 0000000000000000
> [    0.000000] x26: 00000000000003d0 x25: 00000000ffffff8e x24:
> ffffcd7096831bd0
> [    0.000000] x23: ffffcd7097053c08 x22: 00000000c4000198 x21:
> 0000000000001000
> [    0.000000] x20: 0000000001001000 x19: 0000000001000000 x18:
> 0000000000000002
> [    0.000000] x17: 0000000000000000 x16: 0000000000000010 x15:
> 0001000080000000
> [    0.000000] x14: 0068000000000703 x13: ffffffffff5fe000 x12:
> ffffcd7097053ba4
> [    0.000000] x11: 00000000000003d0 x10: ffffcd7097053bc4 x9 :
> 0000000000000444
> [    0.000000] x8 : ffffffffff5fe000 x7 : 0000000000000000 x6 :
> 0000000000000000
> [    0.000000] x5 : 0000000000000000 x4 : 0000000000000000 x3 :
> 0000000000000000
> [    0.000000] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
> 0000000000000000
> [    0.000000] Call trace:
> [    0.000000]  arm64_rsi_is_protected_mmio+0xf0/0x110
> [    0.000000]  set_fixmap_io+0x8c/0xd0
> [    0.000000]  of_setup_earlycon+0xa0/0x294
> [    0.000000]  early_init_dt_scan_chosen_stdout+0x104/0x1dc
> [    0.000000]  acpi_boot_table_init+0x1a4/0x2d8
> [    0.000000]  setup_arch+0x240/0x610
> [    0.000000]  start_kernel+0x6c/0x708
> [    0.000000]  __primary_switched+0x80/0x88
> 
> ===> tf-rmm: git@github.com:TF-RMM/tf-rmm.git
> 
> handle_realm_rsi
>   handle_rsi_ipa_state_get
>     realm_ipa_get_ripas
> 
> ===> tf-rmm/lib/s2tt/include/ripas.h
> 
> enum ripas {
>         RIPAS_EMPTY = RMI_EMPTY,        /* Unused IPA for Realm */
>         RIPAS_RAM = RMI_RAM,            /* IPA used for Code/Data by
> Realm */
>         RIPAS_DESTROYED = RMI_DESTROYED /* IPA is inaccessible to the
> Realm */
> };
> 
> ===> tf-rmm/runtime/rsi/memory.c
> 
> void handle_rsi_ipa_state_get(struct rec *rec,
>                               struct rsi_result *res)
> {
>         unsigned long ipa = rec->regs[1];
>         enum s2_walk_status ws;
>         enum ripas ripas_val = RIPAS_EMPTY;
> 
>         res->action = UPDATE_REC_RETURN_TO_REALM;
> 
>         if (!GRANULE_ALIGNED(ipa) || !addr_in_rec_par(rec, ipa)) {
>                 res->smc_res.x[0] = RSI_ERROR_INPUT;
>                 return;
>         }
> 
>         ws = realm_ipa_get_ripas(rec, ipa, &ripas_val);
>         if (ws == WALK_SUCCESS) {
>                 res->smc_res.x[0] = RSI_SUCCESS;
>                 res->smc_res.x[1] = (unsigned long)ripas_val;
>         } else {
>                 res->smc_res.x[0] = RSI_ERROR_INPUT;
>         }
> }
> 
> Thanks,
> Gavin
> 


