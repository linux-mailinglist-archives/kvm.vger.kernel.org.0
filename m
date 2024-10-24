Return-Path: <kvm+bounces-29620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E84B9AE267
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA551B216A1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6B21C07DF;
	Thu, 24 Oct 2024 10:21:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9953399F
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729765312; cv=none; b=g9i/gw8Bu/jgjABcVGu1/c8GJr4Hc++2kWnVlwpxRCMGdH//BziWMKrf/hgt9VX8oz1Tqe7SwQd8DCFRzEAGPEKmv6D/WCZttSLWUZyjK6emsKUo/jStDIN27j+iY5DmZ5uzpaJhuPA9G3MwXeFqHb87ByDGZOx33R/q9/0QzZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729765312; c=relaxed/simple;
	bh=o7V1fEUBye7S5nTTQDp6lzZ3iKL73ESUhBqYHqHHr10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmdoefZYV5OSb/UVfZmCslJFSpvmpceWlJ5v/ud2netlSZZ4F5/DtQkIccOdHCxwLe6m+3yI86qLue28GnvVq6FefRNYeOixJJ0mxDr1Lhr8AYAV+s4e++X6/H3+deMQJcu2hGDA/+2JA8dfVZPNtR++KBRxssghIJrT8gd9VTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83B1F339;
	Thu, 24 Oct 2024 03:22:19 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A91F53F71E;
	Thu, 24 Oct 2024 03:21:48 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:21:46 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 12/37] KVM: arm64: Sanitise TCR2_EL2
Message-ID: <20241024102146.GB1382116@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-13-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:20PM +0100, Marc Zyngier wrote:
> TCR2_EL2 is a bag of control bits, all of which are only valid if
> certain features are present, and RES0 otherwise.
> 
> Describe these constraints and register them with the masking
> infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b20b3bfb9caec..b4b3ec88399b3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1179,6 +1179,28 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  		res0 |= ~(res0 | res1);
>  	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
>  
> +	/* TCR2_EL2 */
> +	res0 = TCR2_EL2_RES0;
> +	res1 = TCR2_EL2_RES1;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
> +		res0 |= (TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1 | TCR2_EL2_D128);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, MEC, IMP))
> +		res0 |= TCR2_EL2_AMEC1 | TCR2_EL2_AMEC0;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT))
> +		res0 |= TCR2_EL2_HAFT;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> +		res0 |= TCR2_EL2_PTTWI | TCR2_EL2_PnCH;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
> +		res0 |= TCR2_EL2_AIE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
> +		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		res0 |= TCR2_EL2_PIE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
> +		res0 |= (TCR2_EL2_E0POE | TCR2_EL2_D128 |
> +			 TCR2_EL2_AMEC1 | TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1);
> +	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
> +
>  	/* SCTLR_EL1 */
>  	res0 = SCTLR_EL1_RES0;
>  	res1 = SCTLR_EL1_RES1;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

