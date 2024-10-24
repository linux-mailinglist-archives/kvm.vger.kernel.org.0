Return-Path: <kvm+bounces-29651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA989AE94D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 16:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EFC61C22650
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F011E378A;
	Thu, 24 Oct 2024 14:50:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26F91D63D8
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 14:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781399; cv=none; b=C35s8dLDx3VnEAPzCcVxfF0SYdcYeBq033qWyPrbUasiOEuI8H8r/K/4JMD0zgK+UjlMOUJPQF92MPD1ti/5CBoLgZavGzi3xeWScJm6lRLJZ4kfvVUJW1rBjKZ1WwffPEo99RnIu2bS6TJERRnq/mrjnYr60OsB8m0QEQBiJvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781399; c=relaxed/simple;
	bh=l7p6gRgaKwWcNWn+zIEa8wISY6gfDrLdDkURDWjv2Yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0r29Juf8oZV9q3b2DkpzKbspN1/CkcCRVeep15ZcArjx+FV5b0aNYBCREBl00YloRtWYJCOjyUxamVwldlyRGRbMSVIEDLG3xhlAbkSmrv/HxixlXIaogAKhsPDhTUYnz+hZ39zwB8rFEjCAtQe52dhUdJHkirxoV2lRs9PD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 621A0339;
	Thu, 24 Oct 2024 07:50:20 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83C733F528;
	Thu, 24 Oct 2024 07:49:49 -0700 (PDT)
Date: Thu, 24 Oct 2024 15:49:47 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 18/37] KVM: arm64: Add AT fast-path support for S1PIE
Message-ID: <20241024144947.GD1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-19-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-19-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:26PM +0100, Marc Zyngier wrote:
> Emulating AT using AT instructions requires that the live state
> matches the translation regime the AT instruction targets.
> 
> If targeting the EL1&0 translation regime and that S1PIE is
> supported, we also need to restore that state (covering TCR2_EL1,
> PIR_EL1, and PIRE0_EL1).
> 
> Add the required system register switcheroo.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/at.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index f04677127fbc0..b9d0992e91972 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -412,6 +412,9 @@ struct mmu_config {
>  	u64	ttbr1;
>  	u64	tcr;
>  	u64	mair;
> +	u64	tcr2;
> +	u64	pir;
> +	u64	pire0;
>  	u64	sctlr;
>  	u64	vttbr;
>  	u64	vtcr;
> @@ -424,6 +427,13 @@ static void __mmu_config_save(struct mmu_config *config)
>  	config->ttbr1	= read_sysreg_el1(SYS_TTBR1);
>  	config->tcr	= read_sysreg_el1(SYS_TCR);
>  	config->mair	= read_sysreg_el1(SYS_MAIR);
> +	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
> +		config->tcr2	= read_sysreg_el1(SYS_TCR2);
> +		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
> +			config->pir	= read_sysreg_el1(SYS_PIR);
> +			config->pire0	= read_sysreg_el1(SYS_PIRE0);
> +		}
> +	}
>  	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
>  	config->vttbr	= read_sysreg(vttbr_el2);
>  	config->vtcr	= read_sysreg(vtcr_el2);
> @@ -444,6 +454,13 @@ static void __mmu_config_restore(struct mmu_config *config)
>  	write_sysreg_el1(config->ttbr1,	SYS_TTBR1);
>  	write_sysreg_el1(config->tcr,	SYS_TCR);
>  	write_sysreg_el1(config->mair,	SYS_MAIR);
> +	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
> +		write_sysreg_el1(config->tcr2, SYS_TCR2);
> +		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
> +			write_sysreg_el1(config->pir, SYS_PIR);
> +			write_sysreg_el1(config->pire0, SYS_PIRE0);
> +		}
> +	}
>  	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
>  	write_sysreg(config->vttbr,	vttbr_el2);
>  	write_sysreg(config->vtcr,	vtcr_el2);
> @@ -914,6 +931,13 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
> +		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
> +			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
> +			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
> +		}
> +	}
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
>  	__load_stage2(mmu, mmu->arch);
>  

