Return-Path: <kvm+bounces-45209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5036AA7049
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43CAF1BA8352
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 11:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95B0254B10;
	Fri,  2 May 2025 11:04:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95229243951;
	Fri,  2 May 2025 11:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746183875; cv=none; b=rmD4tHFTdjjeIWOo06IMK5ii0ne6tldPrmoeLAZZHTba5qyW0whn9tutd+8nK1vBWIFU3CK+vaLjERnqY2omJIcfzWuQZz741nK/o27C8xe5kvi0iMn/O9Wb6f+T/P+wlYuoLGD2wfZ64iqxyfZm8jBab4faIyNTCv8aXQtHe8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746183875; c=relaxed/simple;
	bh=3OTFRZBkrjijZtuyP1PjuHQyBy+WZ2Tuv4lnEulpl30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeUtDEbjwufkSG5XuB+RN5+0dVBsup6Yr6HW9EESolWKuiOOxdOP5JZgsV7XO4c+R45PXJ/HuzN2AbImXG0zCRTNmHMTlotp1qXFAf/6rT6pClwIM0//03Jt0/kPFpGmKJTvJTdGUtPSldWDf6xAE7c1Nlvu/IqE0DG4Sb6XjvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 414501688;
	Fri,  2 May 2025 04:04:22 -0700 (PDT)
Received: from [10.57.43.85] (unknown [10.57.43.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 645533F66E;
	Fri,  2 May 2025 04:04:25 -0700 (PDT)
Message-ID: <bf0b9232-36b0-41c5-89a5-6639719cd09e@arm.com>
Date: Fri, 2 May 2025 12:04:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 13/43] arm64: RME: Support for the VGIC in realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 <20250416134208.383984-14-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Handle RMM providing fewer GIC LRs than the hardware supports.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  1 +
>   arch/arm64/kvm/arm.c             | 16 +++++++++---
>   arch/arm64/kvm/rme.c             |  5 ++++
>   arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c    |  6 ++++-
>   arch/arm64/kvm/vgic/vgic.c       | 43 ++++++++++++++++++++++++++++++--
>   6 files changed, 66 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index f716b890e484..9bcad6ec5dbb 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -92,6 +92,7 @@ struct realm_rec {
>   
>   void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
> +u32 kvm_realm_vgic_nr_lr(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int kvm_init_realm_vm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fd83efb667cc..808d7e479571 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -683,19 +683,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
>   	}
>   
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +
> +	vcpu->cpu = -1;
> +
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +
>   	kvm_vcpu_put_debug(vcpu);
>   	kvm_arch_vcpu_put_fp(vcpu);
>   	if (has_vhe())
>   		kvm_vcpu_put_vhe(vcpu);
> -	kvm_timer_vcpu_put(vcpu);
> -	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> -	vcpu->cpu = -1;
>   }
>   
>   static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> @@ -912,6 +917,11 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>   			return ret;
>   	}
>   
> +	if (!irqchip_in_kernel(kvm) && kvm_is_realm(vcpu->kvm)) {
> +		/* Userspace irqchip not yet supported with Realms */
> +		return -EOPNOTSUPP;
> +	}
> +
>   	mutex_lock(&kvm->arch.config_lock);
>   	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
>   	mutex_unlock(&kvm->arch.config_lock);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f4923fc3b34e..1239eb07aca6 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -77,6 +77,11 @@ u32 kvm_realm_ipa_limit(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>   }
>   
> +u32 kvm_realm_vgic_nr_lr(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
> +}
> +
>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 1f33e71c2a73..a81c7f3d1d42 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -81,7 +81,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   	 * the proper checks already.
>   	 */
>   	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> -		!kvm_vgic_global_state.can_emulate_gicv2)
> +	    (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
>   		return -ENODEV;
>   
>   	/* Must be held to avoid race with vCPU creation */
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index b9ad7c42c5b0..c10ad817030d 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -8,9 +8,11 @@
>   #include <linux/kvm_host.h>
>   #include <linux/string_choices.h>
>   #include <kvm/arm_vgic.h>
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/rmi_smc.h>
>   
>   #include "vgic.h"
>   
> @@ -758,7 +760,9 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
>   		return;
>   	}
>   
> -	if (likely(!is_protected_kvm_enabled()))
> +	if (vcpu_is_rec(vcpu))
> +		cpu_if->vgic_vmcr = vcpu->arch.rec.run->exit.gicv3_vmcr;
> +	else if (likely(!is_protected_kvm_enabled()))
>   		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
>   	WARN_ON(vgic_v4_put(vcpu));
>   
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 8d189ce18ea0..c68a41a29917 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -10,7 +10,9 @@
>   #include <linux/list_sort.h>
>   #include <linux/nospec.h>
>   
> +#include <asm/kvm_emulate.h>
>   #include <asm/kvm_hyp.h>
> +#include <asm/kvm_rme.h>
>   
>   #include "vgic.h"
>   
> @@ -23,6 +25,8 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
>   
>   static inline int kvm_vcpu_vgic_nr_lr(struct kvm_vcpu *vcpu)
>   {
> +	if (unlikely(vcpu_is_rec(vcpu)))
> +		return kvm_realm_vgic_nr_lr();
>   	return kvm_vgic_global_state.nr_lr;
>   }
>   
> @@ -864,10 +868,23 @@ static inline bool can_access_vgic_from_kernel(void)
>   	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
>   }
>   
> +static inline void vgic_rmm_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vcpu_vgic_nr_lr(vcpu); i++) {
> +		cpu_if->vgic_lr[i] = vcpu->arch.rec.run->exit.gicv3_lrs[i];
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = 0;
> +	}
> +}

We also need to save/restore gicv3_hcr/cpuif->vgic_hcr.

> +
>   static inline void vgic_save_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_save_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_save_state(vcpu);
>   	else
>   		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -903,10 +920,28 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>   	vgic_prune_ap_list(vcpu);
>   }
>   
> +static inline void vgic_rmm_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	int i;
> +
> +	for (i = 0; i < kvm_vcpu_vgic_nr_lr(vcpu); i++) {
> +		vcpu->arch.rec.run->enter.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +		/*
> +		 * Also populate the rec.run->exit copies so that a late
> +		 * decision to back out from entering the realm doesn't cause
> +		 * the state to be lost
> +		 */
> +		vcpu->arch.rec.run->exit.gicv3_lrs[i] = cpu_if->vgic_lr[i];
> +	}
> +}
> +
>   static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
>   {
>   	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   		vgic_v2_restore_state(vcpu);
> +	else if (vcpu_is_rec(vcpu))
> +		vgic_rmm_restore_state(vcpu);
>   	else
>   		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
>   }
> @@ -976,7 +1011,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm) ||
> +		     vcpu_is_rec(vcpu))) {


>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;
> @@ -990,7 +1027,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
>   
>   void kvm_vgic_put(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm) ||
> +		     vcpu_is_rec(vcpu))) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);

We could return early here for rec, and skip the unnecessary trap steps. 
Similar for the vgic_load case.

Rest looks good to me.

Suzuki


>   		return;


