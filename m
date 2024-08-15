Return-Path: <kvm+bounces-24313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9008D95388C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFC151C23B36
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737A81BA879;
	Thu, 15 Aug 2024 16:48:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C6A1B9B52
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723740486; cv=none; b=pLMGhric7AxnuXkiJboFeDPYgUgNAWa3LquXdevaCgzbg5Zo7NCMdZ2BUYC796wbH0p7a3nxOCbJO6BVCy+geupsoGq359aYLvaPQfKMYx2LuR0tCdS/LtfodeM3HP/DRN9Ihw33BSxUgYJxF4v4reWI0Si4CVPIbcCa9YZ4Ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723740486; c=relaxed/simple;
	bh=Gww+JuGDutyIvvwRzRxDpWv+dAmSrYITFV+aZJsSFeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQFiO2VJedRyIt9215dGe3cvZg+Gslmo/7uHjW1XuUSI3m+h+S31NNQ1u+jmtEPEILWZociDhF6gWZrET1QTupDi/CRlKXcQC8PF7UtepeqdOMr9tiiFWBChRJufPUXwX66T1uI0QG7mC03JilnzR19JcPJCHmHM4w/GQYb7UXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 048FC14BF;
	Thu, 15 Aug 2024 09:48:30 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9B6B3F6A8;
	Thu, 15 Aug 2024 09:48:01 -0700 (PDT)
Date: Thu, 15 Aug 2024 17:47:58 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v3 16/18] KVM: arm64: nv: Make AT+PAN instructions aware
 of FEAT_PAN3
Message-ID: <Zr4xPjLLGSs2JhhS@raptor>
References: <20240813100540.1955263-1-maz@kernel.org>
 <20240813100540.1955263-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813100540.1955263-17-maz@kernel.org>

Hi Marc,

On Tue, Aug 13, 2024 at 11:05:38AM +0100, Marc Zyngier wrote:
> FEAT_PAN3 added a check for executable permissions to FEAT_PAN2.
> Add the required SCTLR_ELx.EPAN and descriptor checks to handle
> this correctly.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 6d5555e98557..c134bcd0338d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -728,6 +728,21 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
>  	return par;
>  }
>  
> +static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
> +{
> +	u64 sctlr;
> +
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
> +		return false;
> +
> +	if (regime == TR_EL10)
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	else
> +		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +
> +	return sctlr & SCTLR_EL1_EPAN;

Checked that the EPAN is on the same position for SCTLR_EL1 and SCTLR_EL2.

> +}
> +
>  static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
>  	bool perm_fail, ur, uw, ux, pr, pw, px;
> @@ -794,7 +809,7 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  			bool pan;
>  
>  			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> -			pan &= ur || uw;
> +			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
>  			pw &= !pan;
>  			pr &= !pan;
>  		}

Matches AArch64.S1DirectBasePermissions().

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

