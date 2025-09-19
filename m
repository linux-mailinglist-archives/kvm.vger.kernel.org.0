Return-Path: <kvm+bounces-58221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5A6B8B6F7
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCB00177F79
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3B02D46A7;
	Fri, 19 Sep 2025 22:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gRrKmvAx"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D235A2C3276
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319278; cv=none; b=gwMDPxM7vGT6+nvUxYYz2xkITyFUtQgodz72AX4zoqPrFggQsuJqRvE/80xCvvfyzR05sUVNfWq1sNHd5oBFa1yFVuandfeTlVUJMaO4DcoY8ojbVpB9O+6QD2/VrGfESIV7mk897dLKNF/k0sOGq/FUbYO29KnINTPXzXYhbX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319278; c=relaxed/simple;
	bh=RtT4wd+CD99ymKEzg52n+A2Ka2i/uRYdoyKth8rV/PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soB0osLTOJdtbxnyybYLt8Zv/rqgHYk2o3nZxTGKtZqHNsQo1A9W6M+v1KbCv7mpNKLVLMiZ/tfL+0k7P6Pd4KpYPuo9WCBPqE4VxQkmWK6QWZ3GBemwnlrwGcdbNukyuAkYhNtKvULt2Ha6HZvojJsIrqmlf8Y1uxPR7NVpys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gRrKmvAx; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Sep 2025 15:00:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758319264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhB9XBoASZEaIPr0CT1pnpt/0SafB3c+6yxK4UJFeHU=;
	b=gRrKmvAxzdFhtfFtQm5oCDKyPVYgW8khy+blMu1uvXudiSmtqG1OGrvgsibbKknQgBZOzd
	P6Ixvt7X41TAc3ys29H3ScxCr10GiESRicAGewna1GcZqmyNU9Uji47jrCma1i2wIw3Viz
	oWMHSxUOoNBQL079WcvMrCrnoWXend0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 07/16] KVM: arm64: Populate PAR_EL1 with 52bit
 addresses
Message-ID: <aM3Sm4vKZUw2Nu_L@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:42PM +0100, Marc Zyngier wrote:
> Expand the output address populated in PAR_EL1 to 52bit addresses.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 952c02c57d7dd..1c2f7719b6cbb 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -844,7 +844,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	} else if (wr->level == S1_MMU_DISABLED) {
>  		/* MMU off or HCR_EL2.DC == 1 */
>  		par  = SYS_PAR_EL1_NSE;
> -		par |= wr->pa & GENMASK_ULL(47, 12);
> +		par |= wr->pa & GENMASK_ULL(52, 12);

That should be bit 51, no?

Maybe just use SYS_PAR_EL1_PA as the mask.

>  		if (wi->regime == TR_EL10 &&
>  		    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> @@ -877,7 +877,7 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  			mair = MEMATTR(NC, NC);
>  
>  		par |= FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
> -		par |= wr->pa & GENMASK_ULL(47, 12);
> +		par |= wr->pa & GENMASK_ULL(52, 12);

Same here.

>  		sh = compute_s1_sh(wi, wr, mair);
>  		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
> -- 
> 2.39.2
> 

Thanks,
Oliver

