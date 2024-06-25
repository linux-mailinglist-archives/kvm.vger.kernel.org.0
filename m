Return-Path: <kvm+bounces-20492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0724916AA5
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 16:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A1A41F28394
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 14:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56F816C6A7;
	Tue, 25 Jun 2024 14:37:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA631662F1
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326264; cv=none; b=u1ULaN1YAAWs57O3fS+sBbAhgNEFgTjlTbJKWGMWP1IzQRH33N0MQQAvV30FufLFL0kBDnApzZAiEAAD8rKMmtqECRy5LgJZKexJUBMHupo/BWbbZpUdM66lvd0jjCFfdoxYi6Z+2qWTWP6cDwkIKfnYW6xs7eOZZEJMUIDpe0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326264; c=relaxed/simple;
	bh=EWMVGg9YpHzHifkyO1SPAjclRSlTBvvGsjzxcMP65gE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CpHaKsRHhjq8HESTjHjtctK0C+B7iNC1aDtVqxtcmkQAaSr1eua7YiGqQGWHhB4XmorZDfBq276Wc0xAxMAcgfW+sB8gDPpqW4hN6DFdIX1Qn8jddlKIpDiSbsFQbXQaocAQ666K/aV2aDxXs4MYX+GK6HXUPLrpS4PL8sv91Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 411A2339;
	Tue, 25 Jun 2024 07:38:05 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F9413F73B;
	Tue, 25 Jun 2024 07:37:39 -0700 (PDT)
Date: Tue, 25 Jun 2024 15:37:34 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Correctly honor the presence of FEAT_TCRX
Message-ID: <20240625143734.GA1517668@e124191.cambridge.arm.com>
References: <20240625130042.259175-1-maz@kernel.org>
 <20240625130042.259175-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625130042.259175-2-maz@kernel.org>

On Tue, Jun 25, 2024 at 02:00:37PM +0100, Marc Zyngier wrote:
> We currently blindly enable TCR2_EL1 use in a guest, irrespective
> of the feature set. This is obviously wrong, and we should actually
> honor the guest configuration and handle the possible trap resulting
> from the guest being buggy.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 2 +-
>  arch/arm64/kvm/sys_regs.c        | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b2adc2c6c82a5..e6682a3ace5af 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -102,7 +102,7 @@
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>  
> -#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
> +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
>  
>  /* TCR_EL2 Registers bits */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 22b45a15d0688..71996d36f3751 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -383,6 +383,12 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>  	u64 val, mask, shift;
>  
> +	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
> +	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
> +		kvm_inject_undefined(vcpu);
> +		return false;
> +	}
> +

If we need to start doing this with more vm(sa) registers, it might make sense
to think of a way to do this without putting a big if/else in here.  For now
this is seems fine.

>  	BUG_ON(!p->is_write);
>  
>  	get_access_mask(r, &mask, &shift);
> @@ -4060,6 +4066,9 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
>  			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +
> +		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
> +			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
>  	}
>  
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

