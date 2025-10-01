Return-Path: <kvm+bounces-59290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A54BBB073E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 15:20:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBF002A0C47
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 13:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44252ED844;
	Wed,  1 Oct 2025 13:20:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4065228489C;
	Wed,  1 Oct 2025 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759324825; cv=none; b=BpctRRuznojSy0pmwEZ+A7d78qVF2Rq213UkFE3cC1ZKp9mKIymS65oZVG6tcNgTWJAU1TdFEuM+3GHioAXWIHqDNY6V0A/Gg3/vYJYslptS7DJ3WSTud9AMvCGrjLxgbguoYnStdvvc+hEt8X8CnFw93CqxOnuLjskNj9QYEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759324825; c=relaxed/simple;
	bh=SzvKklzVX6W0EPRa0KwrDs/5Evfvr+B1xb2KqTfE6pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ci/8ZzjMc9TOTqhWruMMKo8zfhLsb/1c8oTqJnuDkWg7s8zV0UFoGaumWclEmXEqMY5VB3LNvtxAIo4VrkFzafpTj5wLBAMYkZiBBksXa2V+VEC14Gf8eoUtPg/UBFeOFJY1h6iIQQsmikuOb9Vp8ChAVW6/j4PSYRoxWlYL50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79DF316F2;
	Wed,  1 Oct 2025 06:20:13 -0700 (PDT)
Received: from [10.57.0.204] (unknown [10.57.0.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87D133F59E;
	Wed,  1 Oct 2025 06:20:16 -0700 (PDT)
Message-ID: <2226e62f-76ca-4467-a8ae-460fd463df0a@arm.com>
Date: Wed, 1 Oct 2025 14:20:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/43] arm64: RME: Check for RME support at KVM init
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-6-steven.price@arm.com> <86ms6azxt5.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86ms6azxt5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/10/2025 12:05, Marc Zyngier wrote:
> On Wed, 20 Aug 2025 15:55:25 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
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
>>  * No need to guard kvm_init_rme() behind 'in_hyp_mode'.
>> Changes since v6:
>>  * Improved message for an unsupported RMI ABI version.
>> Changes since v5:
>>  * Reword "unsupported" message from "host supports" to "we want" to
>>    clarify that 'we' are the 'host'.
>> Changes since v2:
>>  * Drop return value from kvm_init_rme(), it was always 0.
>>  * Rely on the RMM return value to identify whether the RSI ABI is
>>    compatible.
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>>  arch/arm64/include/asm/kvm_host.h    |  4 ++
>>  arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>>  arch/arm64/include/asm/virt.h        |  1 +
>>  arch/arm64/kvm/Makefile              |  2 +-
>>  arch/arm64/kvm/arm.c                 |  5 +++
>>  arch/arm64/kvm/rme.c                 | 56 ++++++++++++++++++++++++++++
>>  7 files changed, 141 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>  create mode 100644 arch/arm64/kvm/rme.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index fa8a08a1ccd5..ab4093e41c4b 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -674,4 +674,22 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_SCTLR2En;
>>  	}
>>  }
>> +
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +	if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
> 
> Under what circumstances would you call this with a NULL pointer?

kvm_vm_ioctl_check_extension() is the culprit. I guess this could be
handled with an equivalent to kvm_pvm_ext_allowed().

>> +		return kvm->arch.is_realm;
>> +	return false;
>> +}
>> +
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +	return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2f2394cce24e..d1511ce26191 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -27,6 +27,7 @@
>>  #include <asm/fpsimd.h>
>>  #include <asm/kvm.h>
>>  #include <asm/kvm_asm.h>
>> +#include <asm/kvm_rme.h>
>>  #include <asm/vncr_mapping.h>
>>  
>>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -404,6 +405,9 @@ struct kvm_arch {
>>  	 * the associated pKVM instance in the hypervisor.
>>  	 */
>>  	struct kvm_protected_vm pkvm;
>> +
>> +	bool is_realm;
>> +	struct realm realm;
> 
> Given that pkvm and CCA are pretty much exclusive, I don't think we
> need to store both states separately. Make those a union.

Ack

>>  };
>>  
>>  struct kvm_vcpu_fault_info {
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
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
> 
> None of that is about RME. This is about CCA, which is purely a SW
> construct, and not a CPU architecture feature.
> 
> So 's/rme/cca/' everywhere that describe something that is not a
> direct effect of FEAT_RME being implemented on the CPU, but instead
> something that is CCA-specific.

Ok, it's a lot of churn but you've got a good point.

>> +
>> +/**
>> + * enum realm_state - State of a Realm
>> + */
>> +enum realm_state {
>> +	/**
>> +	 * @REALM_STATE_NONE:
>> +	 *      Realm has not yet been created. rmi_realm_create() may be
>> +	 *      called to create the realm.
>> +	 */
>> +	REALM_STATE_NONE,
>> +	/**
>> +	 * @REALM_STATE_NEW:
>> +	 *      Realm is under construction, not eligible for execution. Pages
>> +	 *      may be populated with rmi_data_create().
>> +	 */
>> +	REALM_STATE_NEW,
>> +	/**
>> +	 * @REALM_STATE_ACTIVE:
>> +	 *      Realm has been created and is eligible for execution with
>> +	 *      rmi_rec_enter(). Pages may no longer be populated with
>> +	 *      rmi_data_create().
>> +	 */
>> +	REALM_STATE_ACTIVE,
>> +	/**
>> +	 * @REALM_STATE_DYING:
>> +	 *      Realm is in the process of being destroyed or has already been
>> +	 *      destroyed.
>> +	 */
>> +	REALM_STATE_DYING,
>> +	/**
>> +	 * @REALM_STATE_DEAD:
>> +	 *      Realm has been destroyed.
>> +	 */
>> +	REALM_STATE_DEAD
>> +};
>> +
>> +/**
>> + * struct realm - Additional per VM data for a Realm
>> + *
>> + * @state: The lifetime state machine for the realm
>> + */
>> +struct realm {
>> +	enum realm_state state;
>> +};
>> +
>> +void kvm_init_rme(void);
>> +
>> +#endif /* __ASM_KVM_RME_H */
>> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
>> index aa280f356b96..db73c9bfd8c9 100644
>> --- a/arch/arm64/include/asm/virt.h
>> +++ b/arch/arm64/include/asm/virt.h
>> @@ -82,6 +82,7 @@ void __hyp_reset_vectors(void);
>>  bool is_kvm_arm_initialised(void);
>>  
>>  DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>> +DECLARE_STATIC_KEY_FALSE(kvm_rme_is_available);
> 
> Same thing about RME.
> 
>>  
>>  static inline bool is_pkvm_initialized(void)
>>  {
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 3ebc0570345c..70fa017831b3 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>>  kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>  	 inject_fault.o va_layout.o handle_exit.o config.o \
>>  	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
>> -	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
>> +	 vgic-sys-reg-v3.o fpsimd.o pkvm.o rme.o \
>>  	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>>  	 vgic/vgic.o vgic/vgic-init.o \
>>  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 888f7c7abf54..76177c56f1ef 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -40,6 +40,7 @@
>>  #include <asm/kvm_nested.h>
>>  #include <asm/kvm_pkvm.h>
>>  #include <asm/kvm_ptrauth.h>
>> +#include <asm/kvm_rme.h>
>>  #include <asm/sections.h>
>>  
>>  #include <kvm/arm_hypercalls.h>
>> @@ -59,6 +60,8 @@ enum kvm_wfx_trap_policy {
>>  static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>>  static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly = KVM_WFX_NOTRAP_SINGLE_TASK;
>>  
>> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
>> +
>>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>>  
>>  DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
>> @@ -2836,6 +2839,8 @@ static __init int kvm_arm_init(void)
>>  
>>  	in_hyp_mode = is_kernel_in_hyp_mode();
>>  
>> +	kvm_init_rme();
>> +
>>  	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>>  	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
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
>> +	struct arm_smccc_res res;
>> +	unsigned short version_major, version_minor;
>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +						     RMI_ABI_MINOR_VERSION);
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> 
> Shouldn't you first check that RME is actually available, by looking
> at ID_AA64PFR0_EL1.RME?

Well, you made a good point above that this isn't RME, it's CCA. And I
guess there's a possible world where the CCA interface could be
supported with something other than FEAT_RME (FEAT_RME2 maybe?) so I'm
not sure it necessarily a good idea to pin this on a CPU feature bit.

Ultimately what we want to know is whether the firmware thinks it can
supply us with the CCA interface and we don't really care how it
achieves it.

>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +		return -ENXIO;
>> +
>> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +	if (res.a0 != RMI_SUCCESS) {
>> +		unsigned short high_version_major, high_version_minor;
>> +
>> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>> +
>> +		kvm_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
>> +			version_major, version_minor,
>> +			high_version_major, high_version_minor,
>> +			RMI_ABI_MAJOR_VERSION,
>> +			RMI_ABI_MINOR_VERSION);
>> +		return -ENXIO;
>> +	}
>> +
>> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +	return 0;
>> +}
>> +
>> +void kvm_init_rme(void)
>> +{
>> +	if (PAGE_SIZE != SZ_4K)
>> +		/* Only 4k page size on the host is supported */
>> +		return;
> 
> Move the comment above the check (same thing below).

Ack.

Thanks,
Steve


