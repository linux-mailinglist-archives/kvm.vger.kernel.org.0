Return-Path: <kvm+bounces-51485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 162BDAF7566
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D7A31C84159
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A1462376FF;
	Thu,  3 Jul 2025 13:22:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1026B13B7A3;
	Thu,  3 Jul 2025 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751548969; cv=none; b=DpTms6shnkx8vmKDTFkq911R+JQFiNgWYWGXIl2B25kNXb9oFi3B+WSTfqSfdkHCnlythKG11ZkyoQm8DgjLhOzbWVh4bheJ0gvejWYgus7V3nE70WixK1TxBX/QsbmYnJzE83LCCBfglMK950PZJXnEvdPws8kueP5Ow0x8HkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751548969; c=relaxed/simple;
	bh=JNCBYyYgVR5MIcBAsHB8xGmLlEpcps+NLVCquHha+6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CGJY5VrHs9Q0YQIFaQTOTaC3aSj5QkNZ76eEiKaPP3X4eqH2YvDakOxONPSqqmPFkc52n0Bv95dt+Cf6rOJlPHRWH5F541HM+c5VuYuvy9X4Bpy1S69p5JB3k9fmVxUTZGrxOUcHvabjzriExgVdzWjsScyoyBB99jA/DTq3iF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4C9B1596;
	Thu,  3 Jul 2025 06:22:32 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19B753F58B;
	Thu,  3 Jul 2025 06:22:43 -0700 (PDT)
Message-ID: <45ae476d-a557-40a5-81d2-99841fda4941@arm.com>
Date: Thu, 3 Jul 2025 14:22:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/43] arm64: RME: Support for the VGIC in realms
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-14-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250611104844.245235-14-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/06/2025 11:48, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest but delegates
> much of the handling to the host. Implement support in KVM for
> saving/restoring state to/from the REC structure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v8:
>   * Propagate gicv3_hcr to from the RMM.
> Changes from v5:
>   * Handle RMM providing fewer GIC LRs than the hardware supports.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  1 +
>   arch/arm64/kvm/arm.c             | 16 +++++++++--
>   arch/arm64/kvm/rme.c             |  5 ++++
>   arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
>   arch/arm64/kvm/vgic/vgic-v3.c    |  6 +++-
>   arch/arm64/kvm/vgic/vgic.c       | 49 ++++++++++++++++++++++++++++++--
>   6 files changed, 72 insertions(+), 7 deletions(-)
> 

...

> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index eb1205654ac8..77b4962ebfb6 100644
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
>   	/*
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

This function is never reached for Realms, this should be folded in 
vgic_rmm_save_state(). See below.


>   		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
>   	WARN_ON(vgic_v4_put(vcpu));
>   
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index c7aed48c5668..2908b4610c4e 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c

...

>   void kvm_vgic_put(struct kvm_vcpu *vcpu)
>   {
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> +	if (unlikely(vcpu_is_rec(vcpu)))
> +		return;

^^^

> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) ||
> +		     !vgic_initialized(vcpu->kvm))) {
>   		if (has_vhe() && static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>   			__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
>   		return;

Suzuki

