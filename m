Return-Path: <kvm+bounces-29652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E7C9AEA59
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:26:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EFF7B2211D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACCA1EC01A;
	Thu, 24 Oct 2024 15:26:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FAD1EBFE6
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783585; cv=none; b=dY6IdKoA1CYbjoYazDTZceQjEPeZQ1KSueQZnjkyUeaU6RndgW5R0Ekrze/NeQCnLYD454AOAz24NvQmKCk0I+cpZuDZeqa9J3QGMCWlo3uvxF46Ta93o93bOrQdkwMAvPtcSg/beLu6mTBgvwH3JTg7ntf8/1cdj71N3LQlaeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783585; c=relaxed/simple;
	bh=kzZsei3tp2cmcvoB+MW177567m4eG8TwCQWOhTvDpkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IUBViXGDmgaWSXo/hZ43fDoZBb1Gd6U2uLUofhO2dhPR2HS60F+iaqvp4Ejk1vNf2tmiXiJIaOGfMIDfoKMPJePRC9CFIXIW3yLUwd+HSYNWGCXLGrBa5sJXmRJatIKfUV3mHlTn1H13itk4PMGk+zyidrM9o8P1BiMVzgTy5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22EB1339;
	Thu, 24 Oct 2024 08:26:51 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4866B3F528;
	Thu, 24 Oct 2024 08:26:20 -0700 (PDT)
Date: Thu, 24 Oct 2024 16:26:18 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 33/37] KVM: arm64: Add POE save/restore for AT
 emulation fast-path
Message-ID: <20241024152618.GE1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-34-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-34-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:41PM +0100, Marc Zyngier wrote:
> Just like the other extensions affecting address translation,
> we must save/restore POE so that an out-of-context translation
> context can be restored and used with the AT instructions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/at.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index de7109111e404..ef1643faedeb4 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -440,6 +440,8 @@ struct mmu_config {
>  	u64	tcr2;
>  	u64	pir;
>  	u64	pire0;
> +	u64	por_el0;
> +	u64	por_el1;
>  	u64	sctlr;
>  	u64	vttbr;
>  	u64	vtcr;
> @@ -458,6 +460,10 @@ static void __mmu_config_save(struct mmu_config *config)
>  			config->pir	= read_sysreg_el1(SYS_PIR);
>  			config->pire0	= read_sysreg_el1(SYS_PIRE0);
>  		}
> +		if (system_supports_poe()) {
> +			config->por_el1	= read_sysreg_el1(SYS_POR);
> +			config->por_el0	= read_sysreg_s(SYS_POR_EL0);
> +		}
>  	}
>  	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
>  	config->vttbr	= read_sysreg(vttbr_el2);
> @@ -485,6 +491,10 @@ static void __mmu_config_restore(struct mmu_config *config)
>  			write_sysreg_el1(config->pir, SYS_PIR);
>  			write_sysreg_el1(config->pire0, SYS_PIRE0);
>  		}
> +		if (system_supports_poe()) {
> +			write_sysreg_el1(config->por_el1, SYS_POR);
> +			write_sysreg_s(config->por_el0, SYS_POR_EL0);
> +		}
>  	}
>  	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
>  	write_sysreg(config->vttbr,	vttbr_el2);
> @@ -1105,6 +1115,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
>  			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
>  		}
> +		if (kvm_has_s1poe(vcpu->kvm)) {
> +			write_sysreg_el1(vcpu_read_sys_reg(vcpu, POR_EL1), SYS_POR);
> +			write_sysreg_s(vcpu_read_sys_reg(vcpu, POR_EL0), SYS_POR_EL0);
> +		}
>  	}
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
>  	__load_stage2(mmu, mmu->arch);
> -- 
> 2.39.2
> 

