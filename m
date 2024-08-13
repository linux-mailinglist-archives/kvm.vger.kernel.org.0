Return-Path: <kvm+bounces-24013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6027950866
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:04:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 795FC1F2181E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8173F19F49A;
	Tue, 13 Aug 2024 15:03:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5B519EEA4
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561439; cv=none; b=YBRTZGQQhV3ndio35f2T8BHL3edCoegdoT4RK7nxK5v8EIJ2H7Re1Zw/evRbvhUZd2FOu3atBWYMO+xZerSjKFDEojTO7C7c0WujENX5ul0j6rQQkQiPbALUkxf+nd85mcJ+oR2vp7WS3MnzmY+raoi4EOLm/r9nbwsRC3iwg8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561439; c=relaxed/simple;
	bh=9C1B9ZXz5l2K0y0I7wQn1wQGug0dx9fDUNnA2bsXorc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KEj0+aHF51GYvYF0JKOiEUgXegcKoSEo4ZzffbK7Jd83lpd5Rk299RtRDRsoiwndfgjWh7GyGDx+OXiJBv6NF2mXZMVGyfSHcJ0rwgIv0fHmbNtCRoi499XWEph0RaLzuXnjqscfs23W9uDTHJsQqttBS6qpWvEH7giviYbZutA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C290B12FC;
	Tue, 13 Aug 2024 08:04:21 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B8F63F6A8;
	Tue, 13 Aug 2024 08:03:54 -0700 (PDT)
Date: Tue, 13 Aug 2024 16:03:48 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 03/10] KVM: arm64: Add TCR2_EL2 to the sysreg arrays
Message-ID: <20240813150348.GA3321997@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144738.2048302-4-maz@kernel.org>

On Tue, Aug 13, 2024 at 03:47:31PM +0100, Marc Zyngier wrote:
> Add the TCR2_EL2 register to the per-vcpu sysreg register
> array, as well as the sysreg descriptor array.
> 
> Access to this register is conditionned on ID_AA64MMFR3_EL1.TCRX
> being advertised.

s/conditionned/conditional based/

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a33f5996ca9f..5a9e0ad35580 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -462,6 +462,7 @@ enum vcpu_sysreg {
>  	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
>  	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
>  	TCR_EL2,	/* Translation Control Register (EL2) */
> +	TCR2_EL2,	/* Extended Translation Control Register (EL2) */
>  	SPSR_EL2,	/* EL2 saved program status register */
>  	ELR_EL2,	/* EL2 exception link register */
>  	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 95832881fd66..52250db3c122 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -436,6 +436,18 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
> +		kvm_inject_undefined(vcpu);
> +		return false;
> +	}
> +
> +	return access_rw(vcpu, p, r);
> +}
> +
>  static bool access_actlr(struct kvm_vcpu *vcpu,
>  			 struct sys_reg_params *p,
>  			 const struct sys_reg_desc *r)
> @@ -2783,6 +2795,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
> +	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
>  	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
>  	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

