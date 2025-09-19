Return-Path: <kvm+bounces-58212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D9C0B8B6B9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:58:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FD4658742F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E96A2D46B7;
	Fri, 19 Sep 2025 21:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HynyxMpN"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757D21DEFE8
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758319104; cv=none; b=WvCJ8tm0yiNmCJeWZQmDK4A9XHK3cxRnhTyj3EjKQdhJawGTEQrBM1Drm2EsKlj+NaAEGM9d1iJZsDc+xBQPGZOj6113N+gg7L9A5JVEk/Q9RhlzgkL8fQeJKlpdbvfOmmDJTwZhyZR8zlrw6SV1k2U+0MYFgEcXY/nSlytYaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758319104; c=relaxed/simple;
	bh=htS0YGjfUn8eMf9fl9ey6QEdl40299whWv+cWlIhluo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMR+Tv0KtKySqEkEEWGa5BBjbWLeKu2o7C0/UPWJ4FiQkvkz8WnTNCPFvrGd8uXvGgELdyfWFkoS8hHlRtNNg5IZDLv3Ty1qs3WF9GtblqmjqyWp/pgfu5ZE5BbgK2z1ivM+Eyz5cEQBzkITCcMvY+PIa3RJ+s+YhV8vhwwHSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HynyxMpN; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Sep 2025 14:58:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758319100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ucooLY/Qz66eYBaBZSuky0Pv3RB6ntHfOz3AUckBABo=;
	b=HynyxMpNUG/rRZP59lW/UjSDyNKUh2SFLaS6WDcrAv1UZ3aAmJ3QXn2TfE8uBGw15GXDt2
	FS1sN298fllNGieS+/2A2nMHhQUotWgbajlFrPictri2WPeWWSjfvMazRj5trGq+chwiS6
	kIdQFp2wXYk1ewUs8PJdx2jPRyj9hAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 06/16] KVM: arm64: Compute shareability for LPA2
Message-ID: <aM3R9mshUCJgXg9K@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-7-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-7-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:41PM +0100, Marc Zyngier wrote:
> +static u8 compute_s1_sh(struct s1_walk_info *wi, struct s1_walk_result *wr,
> +			u8 attr)
> +{
> +	u8 sh;
> +
> +	/*
> +	 * non-52bit and LPA have their basic shareability described in the
> +	 * descriptor. LPA2 gets it from the corresponding field in TCR,
> +	 * conveniently recorded in the walk info.
> +	 */
> +	if (!wi->pa52bit || BIT(wi->pgshift) == SZ_64K)
> +		sh = FIELD_GET(PTE_SHARED, wr->desc);

nit: s/PTE_SHARED/KVM_PTE_LEAF_ATTR_LO_S1_SH/ makes it a bit more
obvious what field is being used here (even though it was like this
before).

> @@ -798,11 +819,13 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  	    !MEMATTR_IS_DEVICE(final_attr))
>  		final_attr = MEMATTR(NC, NC);
>  
> +	s2_sh = FIELD_GET(PTE_SHARED, tr->desc);
> +

s/PTE_SHARED/KVM_PTE_LEAF_ATTR_LO_S2_SH/

Thanks,
Oliver

