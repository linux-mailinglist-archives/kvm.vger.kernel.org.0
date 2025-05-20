Return-Path: <kvm+bounces-47117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A25D5ABD871
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 464117B381E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA431B4247;
	Tue, 20 May 2025 12:48:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF39914A4E0;
	Tue, 20 May 2025 12:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747745279; cv=none; b=ji05A4ZI6z6mmoRlngXfuRhGXEnXPMRBBk+joDGrVJRM+2ps2oFv6w5YIXQuFPrhQqH5YSuGBPJFCFZgMgGwdiW3/Czb77tWfcHPj0il1fgbxT7RUEpL9bVtPRRg84bjuCIaWLPEl8MF6YldZisKeEV/h4lxar5sjmPfv4yl1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747745279; c=relaxed/simple;
	bh=he5SzJ+dieKD+JiRl4shWKNflBwC56+UsWlPOaCdwTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ueXuI5OR4b+6h4RQKr2J0Ntnz0Yaal5uv00TOV1APsOolE2z3ipiReHNWEPJ3JZluuLi+jWqYWoKxoA4lfcD7UWnIcTFryvT1QmfARDOPehYkqicm6X0C14cthVvlv0dSxWIec/7HMshD2ei+rzmDQBN/mjw33A0zIdEkbFHRGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D99431516;
	Tue, 20 May 2025 05:47:43 -0700 (PDT)
Received: from [10.1.36.74] (Suzukis-MBP.cambridge.arm.com [10.1.36.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C418A3F5A1;
	Tue, 20 May 2025 05:47:53 -0700 (PDT)
Message-ID: <4b86d8e7-2788-4362-916c-810161c4fad8@arm.com>
Date: Tue, 20 May 2025 13:47:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20250416134208.383984-35-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20250416134208.383984-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2025 14:41, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index f786fd978cf6..09cbb61816f3 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -94,6 +94,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 297b13ef1729..0c358ce0a7a1 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>   }
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +
>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index de7fe024dbff..36e22ed84e7e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1844,7 +1844,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide BRBE from guests */
>   	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,


