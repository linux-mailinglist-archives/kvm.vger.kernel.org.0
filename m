Return-Path: <kvm+bounces-28380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 871AC998017
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 138B2B23696
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08753204955;
	Thu, 10 Oct 2024 08:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bpTMQl/V"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B26B66C
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728547705; cv=none; b=kyWZxq4+pYNNrXXyDNv/aKX4TxuqnwSRvynr/7OD3t/cYvdqUPIXm2NPmgTDMlGMSOHvEmaJ08UkEcesweUOMXfrQJ4u78nDuiqroS2c8Z0pH3KzO80KaZb+nDevCJSNse1oSBgDO0OGa7PMmjbB3dowDBvcwO3e7fHUF7BAxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728547705; c=relaxed/simple;
	bh=mgKDM7ZGN2dxGHMljrLzruLS4Ex748V1tH1cXWkrJk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VzPiO1mUDCZd3nxVeqmZs2jpx0WEZNrejOaDonEVpy8EG1T8y08MrG+V7Jr1urRRJ5H5rdZml4l9ofX8ubgt8AbJt8Kbt/XHu7gnr1Y8umvbptshVrIEqrQgILR3N8B/i1fSaHYz3UBTJTDUfgNJG/pr38Y6IVwdaj9z/td3TmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bpTMQl/V; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 10 Oct 2024 01:08:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728547700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xYVOzScYvF7RxPJxE1kY3PH7rcWWCODJu8owyPShCxM=;
	b=bpTMQl/VmGmA05n0JgJRXSVsecTOl/1X8diq1Pohb1PY+z58xpgdDeuJjT3ddxGQYKzx3g
	i1lBuY0ASePb6275IB3fPrstEYOJtHiVHgmS+ruj+mRG96jbIZflzHkaz12Ooa4Uomq7gX
	TU/Ak0nz0al4rDd8McfMBGGgFOsMIo0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 33/36] KVM: arm64: Disable hierarchical permissions
 when POE is enabled
Message-ID: <ZweLbQRD6wAkG6Sz@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-34-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-34-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 08:00:16PM +0100, Marc Zyngier wrote:
> The hierarchical permissions must be disabled when POE is enabled
> in the translation regime used for a given table walk.
> 
> We store the two enable bits in the s1_walk_info structure so that
> they can be retrieved down the line, as they will be useful.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 4921284eeedff..301399f17983f 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -24,6 +24,8 @@ struct s1_walk_info {
>  	unsigned int		txsz;
>  	int 	     		sl;
>  	bool	     		hpd;
> +	bool			e0poe;
> +	bool			poe;
>  	bool	     		be;
>  	bool	     		s2;
>  };
> @@ -110,6 +112,34 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	}
>  }
>  
> +static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
> +{
> +	u64 val;
> +
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {

nit: kvm_has_s1pie()

> +		wi->poe = wi->e0poe = false;
> +		return;
> +	}
> +
> +	switch (wi->regime) {
> +	case TR_EL2:
> +	case TR_EL20:
> +		val = vcpu_read_sys_reg(vcpu, TCR2_EL2);
> +		wi->poe = val & TCR2_EL2_POE;
> +		wi->e0poe = val & TCR2_EL2_E0POE;

Hmm... E0POE is always false in the EL2 translation regime. The RES0
mask does the heavy lifting here, but that only works if we force
userspace to select an nVHE-only or VHE-only vCPU.

It might make sense to have TR_EL2 force this to false to make it a bit
more self-documenting, albeit not a functional issue.

> +		break;
> +	case TR_EL10:
> +		if (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) {
> +			wi->poe = wi->e0poe = false;
> +			return;
> +		}
> +
> +		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
> +		wi->poe = val & TCR2_EL1x_POE;
> +		wi->e0poe = val & TCR2_EL1x_E0POE;
> +	}
> +}
> +

-- 
Thanks,
Oliver

