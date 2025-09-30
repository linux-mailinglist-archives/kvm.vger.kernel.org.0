Return-Path: <kvm+bounces-59049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B91BAACDE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 02:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAA393A9B9F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 00:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDBB1531C1;
	Tue, 30 Sep 2025 00:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mXjyV96j"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF3E74BE1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759192520; cv=none; b=r6nj22GBhpupMIvcalWyVWz/JwgsKttdFavr5d/6fxNJk/EStx9G9kz4VoNgUMKhcUusoKEg6TAUEVMZ3L43uK8/nUA10KZYpIRw111/CkwxrAwwhBG/6PKAqL5vva4VdBnuXarY5wwDkiB1785Upz6cxbFl3bKW3U0XsDsFqE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759192520; c=relaxed/simple;
	bh=cz22YYnnS6n/PVHMI9LuNRhKthyzTqkP7P+ziT1J5Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MlIxjpxiVK3ilPVXtYKuMc2a5qiucdPECGo/5DyuZHAQChuhVsGdsCW3dqxSmRITHVCshjRREjcBOVC8XrkIMXgu8gBH6WM0vAloXWxscr1DPPgKxEzsLky57PjaB3WCOd80Uf1+jA0Xr7uve63vrkqCEyeJdsPPOGtpqLuj8D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mXjyV96j; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 29 Sep 2025 17:35:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759192515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/zSYhlf0XUMz4UMm9FSlubQHqk4IYQKjvjWJ9kLyN4=;
	b=mXjyV96jLYYit3I6ZX9WC7triEupDEHwderTsG7W3levjBTWBqCGM2zs1fC7IgoKE/cqyw
	HODQS52Qp+fYgQzYeiKLK8CQBhJIZiYi0SeWDZtymkxSDOt0lmMj6CeaTXXYTGiWTNz9N4
	fMVtmgn5RkZ8eck2RZ0FdWDHiBGREPI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 01/13] KVM: arm64: Hide CNTHV_*_EL2 from userspace for
 nVHE guests
Message-ID: <aNslu47Dl13iNcaL@linux.dev>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Sep 29, 2025 at 05:04:45PM +0100, Marc Zyngier wrote:
> Although we correctly UNDEF any CNTHV_*_EL2 access from the guest
> when E2H==0, we still expose these registers to userspace, which
> is a bad idea.
> 
> Drop the ad-hoc UNDEF injection and switch to a .visibility()
> callback which will also hide the register from userspace.
> 
> Fixes: 0e45981028550 ("KVM: arm64: timer: Don't adjust the EL2 virtual timer offset")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ee8a7033c85bf..9f2f4e0b042e8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1594,16 +1594,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool access_hv_timer(struct kvm_vcpu *vcpu,
> -			    struct sys_reg_params *p,
> -			    const struct sys_reg_desc *r)
> -{
> -	if (!vcpu_el2_e2h_is_set(vcpu))
> -		return undef_access(vcpu, p, r);
> -
> -	return access_arch_timer(vcpu, p, r);
> -}
> -
>  static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
>  				    s64 new, s64 cur)
>  {
> @@ -2831,6 +2821,16 @@ static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
>  	return __el2_visibility(vcpu, rd, s1pie_visibility);
>  }
>  
> +static unsigned int cnthv_visibility(const struct kvm_vcpu *vcpu,
> +				     const struct sys_reg_desc *rd)
> +{
> +	if (vcpu_has_nv(vcpu) &&
> +	    !vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2_E2H0))
> +		return 0;
> +
> +	return REG_HIDDEN;
> +}

Hmm. We've already exposed these to userspace at this point, we just
conveniently last the get-reg-list test to assert the accessibility of
these (broken) exposures.

Given the amount of UAPI mishaps we've had with registers in the past I
don't have much appetite for taking away something we already
advertised.

What about making these RAZ/WI from userspace?

Thanks,
Oliver

