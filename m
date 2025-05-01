Return-Path: <kvm+bounces-45077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9337CAA5D66
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 12:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03DA14C41B8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CAC221F20;
	Thu,  1 May 2025 10:43:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D2A1DC9A3
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 10:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746096223; cv=none; b=dE7v2D0hZw74uA7m76QY4eidIvY+x51qgyRKwyeYLjLaOK+jRmlCUFyWVYRD8pIUS+20p+iVoFK3OdCk3XDuHTuX1FTuRDFn1qLjYch1UNPaWTXeKop2RRR8NEkEthpG09w2aksifUQ/sHPTfk6NH15Jaq+FJu8B/Z49gx1h4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746096223; c=relaxed/simple;
	bh=0/dQJYcz+1JKfUAWj9CPp7LMRU5ymdAIIa36fhXVHi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueS0Dv+x6jxXi76BRk3eL2EJCAiR5Mati19dAqyXOZmUxbCOWUU9QEtIydaKga+8dH1NhL54L8DTEsW+QdNXYQF4kM/mWFaJgb+Eg4Ik8d940qHc6jYOccnMbaXdwn1eWsgVvRQPWekHjkHSV1KXbJUdNA/ZjtDQ8u4mR9CKr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62F62106F;
	Thu,  1 May 2025 03:43:33 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F6CC3F673;
	Thu,  1 May 2025 03:43:38 -0700 (PDT)
Date: Thu, 1 May 2025 11:43:36 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 16/42] KVM: arm64: Simplify handling of negative FGT
 bits
Message-ID: <20250501104336.GG1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-17-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:10PM +0100, Marc Zyngier wrote:
> check_fgt_bit() and triage_sysreg_trap() implement the same thing
> twice for no good reason. We have to lookup the FGT register twice,
> as we don't communucate it. Similarly, we extract the register value
> at the wrong spot.
> 
> Reorganise the code in a more logical way so that things are done
> at the correct location, removing a lot of duplication.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 49 ++++++++-------------------------
>  1 file changed, 12 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 1bcbddc88a9b7..52a2d63a667c9 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2215,11 +2215,11 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
>  	return masks->mask[sr - __VNCR_START__].res0;
>  }
>  
> -static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
> -			  u64 val, const union trap_config tc)
> +static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
> +			  const union trap_config tc)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> -	enum vcpu_sysreg sr;
> +	u64 val;
>  
>  	/*
>  	 * KVM doesn't know about any FGTs that apply to the host, and hopefully
> @@ -2228,6 +2228,8 @@ static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
>  	if (is_hyp_ctxt(vcpu))
>  		return false;
>  
> +	val = __vcpu_sys_reg(vcpu, sr);
> +
>  	if (tc.pol)
>  		return (val & BIT(tc.bit));
>  
> @@ -2242,38 +2244,17 @@ static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
>  	if (val & BIT(tc.bit))
>  		return false;
>  
> -	switch ((enum fgt_group_id)tc.fgt) {
> -	case HFGRTR_GROUP:
> -		sr = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
> -		break;
> -
> -	case HDFGRTR_GROUP:
> -		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
> -		break;
> -
> -	case HAFGRTR_GROUP:
> -		sr = HAFGRTR_EL2;
> -		break;
> -
> -	case HFGITR_GROUP:
> -		sr = HFGITR_EL2;
> -		break;
> -
> -	default:
> -		WARN_ONCE(1, "Unhandled FGT group");
> -		return false;
> -	}
> -
>  	return !(kvm_get_sysreg_res0(kvm, sr) & BIT(tc.bit));
>  }
>  
>  bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  {
> +	enum vcpu_sysreg fgtreg;
>  	union trap_config tc;
>  	enum trap_behaviour b;
>  	bool is_read;
>  	u32 sysreg;
> -	u64 esr, val;
> +	u64 esr;
>  
>  	esr = kvm_vcpu_get_esr(vcpu);
>  	sysreg = esr_sys64_to_sysreg(esr);
> @@ -2320,25 +2301,19 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  		break;
>  
>  	case HFGRTR_GROUP:
> -		if (is_read)
> -			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
> -		else
> -			val = __vcpu_sys_reg(vcpu, HFGWTR_EL2);
> +		fgtreg = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
>  		break;
>  
>  	case HDFGRTR_GROUP:
> -		if (is_read)
> -			val = __vcpu_sys_reg(vcpu, HDFGRTR_EL2);
> -		else
> -			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
> +		fgtreg = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
>  		break;
>  
>  	case HAFGRTR_GROUP:
> -		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
> +		fgtreg = HAFGRTR_EL2;
>  		break;
>  
>  	case HFGITR_GROUP:
> -		val = __vcpu_sys_reg(vcpu, HFGITR_EL2);
> +		fgtreg = HFGITR_EL2;
>  		switch (tc.fgf) {
>  			u64 tmp;
>  
> @@ -2359,7 +2334,7 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  		goto local;
>  	}
>  
> -	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu, is_read, val, tc))
> +	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu, fgtreg, tc))
>  		goto inject;
>  
>  	b = compute_trap_behaviour(vcpu, tc);
> -- 
> 2.39.2
> 

