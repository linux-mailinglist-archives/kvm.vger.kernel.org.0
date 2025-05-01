Return-Path: <kvm+bounces-45085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 858E7AA5F37
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EA9E1BA7C47
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAF21A5B9E;
	Thu,  1 May 2025 13:31:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40AC199934;
	Thu,  1 May 2025 13:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106282; cv=none; b=b7l34jFuiA2otvGijg5oLV18+qv1crHBYPeh0afH3URdHm8uGaHWxYfdTJ3n2+sfP5b7cV1D5/jTUuxIJdLoBXc92VlxMfVozsMZEetYoRVDxYRfTwiPMzwXR8hD1lYVWwsbWS9XttR1PxiF+vz/WIH/Z5W9YBZ+m++TEOA6Ar0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106282; c=relaxed/simple;
	bh=etO68qKb2gZAy7IEQvfp46hAtSkStH1cUiCh5zZ2IYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oloHpCokLgr1mxN3X0N8YC75F7pm52VgjxqJieUTuYBFAdl1EJ0jxyuivEkwyWYzyMVyV+oT3UedNATawJU6x1lBWdmq7SCkgVg5A2ovy+sM+brAt7qrrLzhkw4bCEKFoDvdFEdaTFlwnaNaesjfZl19f5Ap4ipeBdS75kiPwf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7407A168F;
	Thu,  1 May 2025 06:31:11 -0700 (PDT)
Received: from [10.1.33.27] (e122027.cambridge.arm.com [10.1.33.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCB6E3F5A1;
	Thu,  1 May 2025 06:31:14 -0700 (PDT)
Message-ID: <93477779-bec8-4e6b-b6e5-edb82f664df7@arm.com>
Date: Thu, 1 May 2025 14:31:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/43] arm64: RME: Check for RME support at KVM init
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
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-6-steven.price@arm.com>
 <d582f30d-4d30-4ca0-992b-6bf7d8f7da83@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d582f30d-4d30-4ca0-992b-6bf7d8f7da83@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/04/2025 12:08, Suzuki K Poulose wrote:
> On 16/04/2025 14:41, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Later patches make use of struct realm and the states as the ioctls
>> interfaces are added to support realm and REC creation and destruction.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
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
>>   arch/arm64/kvm/Makefile              |  3 +-
>>   arch/arm64/kvm/arm.c                 |  6 +++
>>   arch/arm64/kvm/rme.c                 | 56 ++++++++++++++++++++++++++++
>>   7 files changed, 143 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>   create mode 100644 arch/arm64/kvm/rme.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>> include/asm/kvm_emulate.h
>> index d7cf66573aca..1c43a4fc25dd 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -686,4 +686,22 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu
>> *vcpu)
>>               vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
>>       }
>>   }
>> +
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +    if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
>> +        return kvm->arch.is_realm;
>> +    return false;
>> +}
>> +
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +    return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>> +{
>> +    return false;
>> +}
>> +
>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/
>> asm/kvm_host.h
>> index e98cfe7855a6..7bd81b86eab0 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -27,6 +27,7 @@
>>   #include <asm/fpsimd.h>
>>   #include <asm/kvm.h>
>>   #include <asm/kvm_asm.h>
>> +#include <asm/kvm_rme.h>
>>   #include <asm/vncr_mapping.h>
>>     #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -394,6 +395,9 @@ struct kvm_arch {
>>        * the associated pKVM instance in the hypervisor.
>>        */
>>       struct kvm_protected_vm pkvm;
>> +
>> +    bool is_realm;
>> +    struct realm realm;
>>   };
>>     struct kvm_vcpu_fault_info {
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> new file mode 100644
>> index 000000000000..9c8a0b23e0e4
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -0,0 +1,56 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_KVM_RME_H
>> +#define __ASM_KVM_RME_H
>> +
>> +/**
>> + * enum realm_state - State of a Realm
>> + */
>> +enum realm_state {
>> +    /**
>> +     * @REALM_STATE_NONE:
>> +     *      Realm has not yet been created. rmi_realm_create() may be
>> +     *      called to create the realm.
>> +     */
>> +    REALM_STATE_NONE,
>> +    /**
>> +     * @REALM_STATE_NEW:
>> +     *      Realm is under construction, not eligible for execution.
>> Pages
>> +     *      may be populated with rmi_data_create().
>> +     */
>> +    REALM_STATE_NEW,
>> +    /**
>> +     * @REALM_STATE_ACTIVE:
>> +     *      Realm has been created and is eligible for execution with
>> +     *      rmi_rec_enter(). Pages may no longer be populated with
>> +     *      rmi_data_create().
>> +     */
>> +    REALM_STATE_ACTIVE,
>> +    /**
>> +     * @REALM_STATE_DYING:
>> +     *      Realm is in the process of being destroyed or has already
>> been
>> +     *      destroyed.
>> +     */
>> +    REALM_STATE_DYING,
>> +    /**
>> +     * @REALM_STATE_DEAD:
>> +     *      Realm has been destroyed.
>> +     */
>> +    REALM_STATE_DEAD
>> +};
>> +
>> +/**
>> + * struct realm - Additional per VM data for a Realm
>> + *
>> + * @state: The lifetime state machine for the realm
>> + */
>> +struct realm {
>> +    enum realm_state state;
>> +};
>> +
>> +void kvm_init_rme(void);
>> +
>> +#endif /* __ASM_KVM_RME_H */
>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/
>> virt.h
>> index ebf4a9f943ed..e45d47156dcf 100644
>> --- a/arch/arm64/include/asm/virt.h
>> +++ b/arch/arm64/include/asm/virt.h
>> @@ -81,6 +81,7 @@ void __hyp_reset_vectors(void);
>>   bool is_kvm_arm_initialised(void);
>>     DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>> +DECLARE_STATIC_KEY_FALSE(kvm_rme_is_available);
>>     static inline bool is_pkvm_initialized(void)
>>   {
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 209bc76263f1..2ebc66812d49 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -23,7 +23,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o
>> pvtime.o \
>>        vgic/vgic-v3.o vgic/vgic-v4.o \
>>        vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>>        vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
>> -     vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
>> +     vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
>> +     rme.o
>>     kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>>   kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 68fec8c95fee..856a721d41ac 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -40,6 +40,7 @@
>>   #include <asm/kvm_nested.h>
>>   #include <asm/kvm_pkvm.h>
>>   #include <asm/kvm_ptrauth.h>
>> +#include <asm/kvm_rme.h>
>>   #include <asm/sections.h>
>>     #include <kvm/arm_hypercalls.h>
>> @@ -59,6 +60,8 @@ enum kvm_wfx_trap_policy {
>>   static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly =
>> KVM_WFX_NOTRAP_SINGLE_TASK;
>>   static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly =
>> KVM_WFX_NOTRAP_SINGLE_TASK;
>>   +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
>> +
>>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>>     DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
>> @@ -2819,6 +2822,9 @@ static __init int kvm_arm_init(void)
>>         in_hyp_mode = is_kernel_in_hyp_mode();
>>   +    if (in_hyp_mode)
>> +        kvm_init_rme();
>> +
> 
> minor nit:
> 
> I wondering if this check is necessary. If the host is running under a
> a hypervisor, it could relay the calls to the RMM. Nothing urgent, but
> it is a possibility. It doesn't matter to the host as such. The
> Realm Guest will do its own verification and the host can ignore
> what lies beneath ?

Reasonable point - I don't think we have anything yet that can do that
sort of relaying. But I guess anything which handles the RMI API we
should be compatible with, so there's no need specifically to require
in_hyp_mode.

Thanks,
Steve

> 
> Either ways,
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> 


