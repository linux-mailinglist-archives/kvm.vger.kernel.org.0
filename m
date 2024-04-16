Return-Path: <kvm+bounces-14768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B72B8A6C47
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA6F41F21663
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 13:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B397F12C49E;
	Tue, 16 Apr 2024 13:30:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEF412C483;
	Tue, 16 Apr 2024 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713274215; cv=none; b=iwz3ikb+W3lZOb730fw09DAXHmdgVwWCD+Swa1PvT95xpb59aFcO1GHW6LCyrN9q8I4xfwMKPpPXyAAtUpmInfFoaoJJLepwCSnQQBQNiw60gYmNAVCTTc+zXgZQQ4M4sFlYoK3xBad8Kx0doQMlSwMeM+7rdwPuA5IVPf4jgLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713274215; c=relaxed/simple;
	bh=+j/6gM3a937z2BzVy5L+xPXIwJaTO68RZyd2qEEbv9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqrsCvhnk7iKu9SF005exezHZrYMrUjqKiDWdeU+SQFHV3FHj4KpuzUe4GAsDA+9mho0Kxn+t888MsE1N/wwUacA/PlHGRxi2BkqwECGQQDOIp6E00nPkUvbWKKcWYPy5X4j+qoarztEg+TQW1y8Fle2UVfr+G5yMXJEbJoaHQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68DE4339;
	Tue, 16 Apr 2024 06:30:40 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EB303F738;
	Tue, 16 Apr 2024 06:30:07 -0700 (PDT)
Message-ID: <37fa1ff5-9e94-4def-afd6-fb9ea9356977@arm.com>
Date: Tue, 16 Apr 2024 14:30:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/43] arm64: RME: Check for RME support at KVM init
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-8-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-8-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steven

On 12/04/2024 09:42, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 18 +++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 ++
>   arch/arm64/include/asm/kvm_rme.h     | 56 ++++++++++++++++++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  3 +-
>   arch/arm64/kvm/arm.c                 |  9 +++++
>   arch/arm64/kvm/rme.c                 | 52 ++++++++++++++++++++++++++
>   7 files changed, 142 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 975af30af31f..6f08398537e2 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -611,4 +611,22 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
>   
>   	kvm_write_cptr_el2(val);
>   }
> +
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9e8a496fb284..63b68b85db3f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -27,6 +27,7 @@
>   #include <asm/fpsimd.h>
>   #include <asm/kvm.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/kvm_rme.h>
>   #include <asm/vncr_mapping.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> @@ -348,6 +349,9 @@ struct kvm_arch {
>   	 * the associated pKVM instance in the hypervisor.
>   	 */
>   	struct kvm_protected_vm pkvm;
> +
> +	bool is_realm;
> +	struct realm realm;
>   };
>   
>   struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> new file mode 100644
> index 000000000000..922da3f47227
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -0,0 +1,56 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_KVM_RME_H
> +#define __ASM_KVM_RME_H
> +
> +/**
> + * enum realm_state - State of a Realm
> + */
> +enum realm_state {
> +	/**
> +	 * @REALM_STATE_NONE:
> +	 *      Realm has not yet been created. rmi_realm_create() may be
> +	 *      called to create the realm.
> +	 */
> +	REALM_STATE_NONE,
> +	/**
> +	 * @REALM_STATE_NEW:
> +	 *      Realm is under construction, not eligible for execution. Pages
> +	 *      may be populated with rmi_data_create().
> +	 */
> +	REALM_STATE_NEW,
> +	/**
> +	 * @REALM_STATE_ACTIVE:
> +	 *      Realm has been created and is eligible for execution with
> +	 *      rmi_rec_enter(). Pages may no longer be populated with
> +	 *      rmi_data_create().
> +	 */
> +	REALM_STATE_ACTIVE,
> +	/**
> +	 * @REALM_STATE_DYING:
> +	 *      Realm is in the process of being destroyed or has already been
> +	 *      destroyed.
> +	 */
> +	REALM_STATE_DYING,
> +	/**
> +	 * @REALM_STATE_DEAD:
> +	 *      Realm has been destroyed.
> +	 */
> +	REALM_STATE_DEAD
> +};
> +
> +/**
> + * struct realm - Additional per VM data for a Realm
> + *
> + * @state: The lifetime state machine for the realm
> + */
> +struct realm {
> +	enum realm_state state;
> +};
> +
> +int kvm_init_rme(void);
> +
> +#endif
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 261d6e9df2e1..12cf36c38189 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -81,6 +81,7 @@ void __hyp_reset_vectors(void);
>   bool is_kvm_arm_initialised(void);
>   
>   DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_rme_is_available);
>   
>   /* Reports the availability of HYP mode */
>   static inline bool is_hyp_mode_available(void)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index c0c050e53157..1c1d8cdf381f 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -20,7 +20,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 vgic/vgic-v3.o vgic/vgic-v4.o \
>   	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>   	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> -	 vgic/vgic-its.o vgic/vgic-debug.o
> +	 vgic/vgic-its.o vgic/vgic-debug.o \
> +	 rme.o
>   
>   kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3dee5490eea9..2056c660c5ee 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -38,6 +38,7 @@
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_nested.h>
>   #include <asm/kvm_pkvm.h>
> +#include <asm/kvm_rme.h>
>   #include <asm/kvm_emulate.h>
>   #include <asm/sections.h>
>   
> @@ -47,6 +48,8 @@
>   
>   static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
>   
> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
> +
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
>   DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> @@ -2562,6 +2565,12 @@ static __init int kvm_arm_init(void)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	if (in_hyp_mode) {
> +		err = kvm_init_rme();
> +		if (err)
> +			return err;
> +	}
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> new file mode 100644
> index 000000000000..3dbbf9d046bf
> --- /dev/null
> +++ b/arch/arm64/kvm/rme.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	int version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +

We don't seem to be using the res.a0 to determin if the RMM supports our
requested version. As per RMM spec, section B4.3.23 :

"
The status code and lower revision output values indicate which of the 
following is true, in order of precedence:
  a) The RMM supports an interface revision which is compatible with the
     requested revision.
      • The status code is RMI_SUCCESS.
      • The lower revision is equal to the requested revision.
  b) The RMM does not support an interface revision which is compatible
     with the requested revision The RMM supports an interface revision
     which is incompatible with and less than the requested revision.
      • The status code is RMI_ERROR_INPUT.
      • The lower revision is the highest interface revision which is
        both less than the requested revision and supported by the RMM.

  c) The RMM does not support an interface revision which is compatible
     with the requested revision The RMM supports an interface revision
     which is incompatible with and greater than the requested revision.
      • The status code is RMI_ERROR_INPUT.
      • The lower revision is equal to the higher revision.

So, we could simply check the res.a0 for RMI_SUCCESS and proceed with
marking RMM available.


> +	if (version_major != RMI_ABI_MAJOR_VERSION) {
> +		kvm_err("Unsupported RMI ABI (v%d.%d) host supports v%d.%d\n",
> +			version_major, version_minor,
> +			RMI_ABI_MAJOR_VERSION,
> +			RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +int kvm_init_rme(void)
> +{
> +	if (PAGE_SIZE != SZ_4K)
> +		/* Only 4k page size on the host is supported */
> +		return 0;
> +
> +	if (rmi_check_version())
> +		/* Continue without realm support */
> +		return 0;
> +
> +	/* Future patch will enable static branch kvm_rme_is_available */
> +
> +	return 0;

Do we ever expect this to fail the kvm initialisation ? Otherwise, we
could leave it as a void ?

Suzuki
> +}


