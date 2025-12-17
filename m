Return-Path: <kvm+bounces-66177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C558CC8544
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 16:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0AC1305D43F
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9478138C648;
	Wed, 17 Dec 2025 14:29:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D39C389F77;
	Wed, 17 Dec 2025 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765981794; cv=none; b=ihAVE+lm40y9mO3VXQTrbd3gKs7dTlV1yYWmU4uiAQUQ+b/b1Z7HFG3hGuDeS+P8poW0lb1swB7ya4clWndUeIsE65nJdX8y9UfYe0FOu8thh16AYSnWjoLcvNhz5yhUpYGwIZQM9ptaAR5kccYFvIPuHUf4NdpYou7AnrJTuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765981794; c=relaxed/simple;
	bh=P8UoqtDkSIejHJ3dZSwB+Al5ZpdAYzsvTp6EFWWH3vM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c22ifXSKW8zav82DVUCEmZPrFhRLILfeakXcroibVufkJabOPfNkRW+dH3P0E8Ht4BsckJMT1EPzNA1Hr5n+LvZh12r/bE67c3q8oWgtwPAOfb5XndAuhiPdsrd7NktAkdx6PGkgygAcHiQdfSogqvoTZ6O1mS4CLHYvRw30et0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91910FEC;
	Wed, 17 Dec 2025 06:29:44 -0800 (PST)
Received: from [10.57.79.105] (unknown [10.57.79.105])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 495223F73B;
	Wed, 17 Dec 2025 06:29:48 -0800 (PST)
Message-ID: <f04bdf46-c752-43ec-88fa-dcd37f29d374@arm.com>
Date: Wed, 17 Dec 2025 14:29:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 11/46] arm64: RMI: Activate realm on first VCPU run
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
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-12-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251217101125.91098-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/12/2025 10:10, Steven Price wrote:
> When a VCPU migrates to another physical CPU check if this is the first
> time the guest has run, and if so activate the realm.
> 
> Before the realm can be activated it must first be created, this is a
> stub in this patch and will be filled in by a later patch.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v12
> ---
>   arch/arm64/include/asm/kvm_rmi.h |  1 +
>   arch/arm64/kvm/arm.c             |  6 +++++
>   arch/arm64/kvm/rmi.c             | 42 ++++++++++++++++++++++++++++++++
>   3 files changed, 49 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
> index cb7350f8a01a..e4534af06d96 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
> @@ -69,6 +69,7 @@ void kvm_init_rmi(void);
>   u32 kvm_realm_ipa_limit(void);
>   
>   int kvm_init_realm_vm(struct kvm *kvm);
> +int kvm_activate_realm(struct kvm *kvm);
>   void kvm_destroy_realm(struct kvm *kvm);
>   void kvm_realm_destroy_rtts(struct kvm *kvm);
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 941d1bec8e77..542df37b9e82 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -951,6 +951,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>   			return ret;
>   	}
>   
> +	if (kvm_is_realm(vcpu->kvm)) {
> +		ret = kvm_activate_realm(kvm);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	mutex_lock(&kvm->arch.config_lock);
>   	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
>   	mutex_unlock(&kvm->arch.config_lock);
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index e57e8b7eafa9..98929382c365 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -223,6 +223,48 @@ void kvm_realm_destroy_rtts(struct kvm *kvm)
>   	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>   }
>   
> +static int realm_ensure_created(struct kvm *kvm)
> +{
> +	/* Provided in later patch */
> +	return -ENXIO;
> +}
> +
> +int kvm_activate_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +	int ret;
> +
> +	if (!kvm_is_realm(kvm))
> +		return -ENXIO;
> +
> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
> +		return 0;
> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +	/* Check again with the lock held */
> +	if (kvm_realm_state(kvm) == REALM_STATE_ACTIVE)
> +		return 0;
> +
> +	ret = realm_ensure_created(kvm);
> +	if (ret)
> +		return ret;
> +
> +	/* Mark state as dead in case we fail */
> +	WRITE_ONCE(realm->state, REALM_STATE_DEAD);
> +
> +	if (!irqchip_in_kernel(kvm)) {
> +		/* Userspace irqchip not yet supported with realms */
> +		return -EOPNOTSUPP;
> +	}

super minor nit: We could do this check before create the realm, within
the config_lock'ed region.

Suzuki


