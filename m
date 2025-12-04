Return-Path: <kvm+bounces-65273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEAACCA34E2
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 11:51:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4CD0D300D721
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 10:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5AE22C08C5;
	Thu,  4 Dec 2025 10:51:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C478F28CF5D
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845484; cv=none; b=PRODZ1/Y6dYLHzITA6V3wg3Pnw42PsSyI9RJ3sfWH5Kg82EPNU9g+YGUbw2t2DitC46N7douOTuwfPVpJtBw15SQZEDrbY9D7ZA/KHorhSXER8v+z/oSMTK3ACTX9OGnD3EswX3MBHxHeYMyQ275LBHr701/7iGTTzHDCnl9jNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845484; c=relaxed/simple;
	bh=9zBoHpSsXVZiwHMRXnfhwLIXCCnHzO+5ikF9YtUUDak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KWFQqoIekfsR3nLMOjx6XHepR3ZZ9tSeAph3YprhAX9n/GXi7sUtIPyO6fX1G4taCqCtxPPuZiPdyWt1OCuwK5Lv77kBwXtPdziOIrZC7yrNO4D8R15hLCmy9GtnvArF6msUxMcz6F8uVs3Qz1ZNomlxOlPojWa6d87t1HyfPpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E45B0339;
	Thu,  4 Dec 2025 02:51:14 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 061513F73B;
	Thu,  4 Dec 2025 02:51:20 -0800 (PST)
Message-ID: <7f853a85-f1da-4e6f-ab3f-63507731f8ee@arm.com>
Date: Thu, 4 Dec 2025 10:51:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] KVM: arm64: pkvm: Report optional ID register
 traps with a 0x18 syndrome
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-9-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251204094806.3846619-9-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/4/25 09:48, Marc Zyngier wrote:
> With FEAT_IDST, unimplemented system registers in the feature ID space
> must be reported using EC=0x18 at the closest handling EL, rather than
> with an UNDEF.
> 
> Most of these system registers are always implemented thanks to their
> dependency on FEAT_AA64, except for a set of (currently) three registers:
> GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> and SMIDR_EL1 (depending on SME).
> 
> For these three registers, report their trap as EC=0x18 if they
> end-up trapping into KVM and that FEAT_IDST is implemented in the guest.
> Otherwise, just make them UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 876b36d3d4788..efc36645f4b5a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -347,6 +347,18 @@ static bool pvm_gic_read_sre(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool pvm_idst_access(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, NI))
> +		inject_undef64(vcpu);
> +	else
> +		inject_sync64(vcpu, kvm_vcpu_get_esr(vcpu));
> +
> +	return false;
> +}
> +

Just wondering, why is the pkvm version register specific? You changed
the non-pkvm from register specific to generic.

>  /* Mark the specified system register as an AArch32 feature id register. */
>  #define AARCH32(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch32 }
>  
> @@ -472,6 +484,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  
>  	HOST_HANDLED(SYS_CCSIDR_EL1),
>  	HOST_HANDLED(SYS_CLIDR_EL1),
> +	{ SYS_DESC(SYS_CCSIDR2_EL1), .access = pvm_idst_access },
> +	{ SYS_DESC(SYS_GMID_EL1), .access = pvm_idst_access },
> +	{ SYS_DESC(SYS_SMIDR_EL1), .access = pvm_idst_access },
>  	HOST_HANDLED(SYS_AIDR_EL1),
>  	HOST_HANDLED(SYS_CSSELR_EL1),
>  	HOST_HANDLED(SYS_CTR_EL0),

Thanks,

Ben


