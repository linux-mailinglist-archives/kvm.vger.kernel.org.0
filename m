Return-Path: <kvm+bounces-45890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E3FAAFC06
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:50:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3779E1BC61C1
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D82522D4F3;
	Thu,  8 May 2025 13:49:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2153819309C
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746712198; cv=none; b=fyVfqqp/zdfx1g2LRlMTf35WXlUP5UO38DlEZQePjoEwK7Loeh8omZ+t0p8UR8ONicizhztAJpJgrIadVMhjv2pFaDE5OfyZewdGmg633TUS3hkpexNZCb03HXQhB6OYGozDq1K/38oXIbe0No321c+VicO6dyxvCK3gp81VqpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746712198; c=relaxed/simple;
	bh=uBC2Ihdt2rDNkt4rQMMXMF3OAN4i06Q6AEeMdRZfFL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8lAAf0yhQhOhaQ1LSpDWQPdzdyl1np+pC/0+Yh93HNMaDdy88Ql0Y4JbY4ZgreNQsJqvo3vo2zoerxO+fex0jHS0UwxNLGAE836oueIXHFku2DAEL9VJuEv0PmEhWlNE2lCfQwfHdaQtNG0qx43OxhX1tbA06bFe7bFsw0twa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC540106F;
	Thu,  8 May 2025 06:49:45 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4038E3F58B;
	Thu,  8 May 2025 06:49:54 -0700 (PDT)
Date: Thu, 8 May 2025 14:49:48 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v4 27/43] KVM: arm64: Use computed FGT masks to setup FGT
 registers
Message-ID: <20250508134948.GA3256485@e124191.cambridge.arm.com>
References: <20250506164348.346001-1-maz@kernel.org>
 <20250506164348.346001-28-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506164348.346001-28-maz@kernel.org>

On Tue, May 06, 2025 at 05:43:32PM +0100, Marc Zyngier wrote:
> Flip the hyervisor FGT configuration over to the computed FGT
> masks.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 45 +++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 925a3288bd5be..e8645375499df 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -65,12 +65,41 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +#define reg_to_fgt_masks(reg)						\
> +	({								\
> +		struct fgt_masks *m;					\
> +		switch(reg) {						\
> +		case HFGRTR_EL2:					\
> +			m = &hfgrtr_masks;				\
> +			break;						\
> +		case HFGWTR_EL2:					\
> +			m = &hfgwtr_masks;				\
> +			break;						\
> +		case HFGITR_EL2:					\
> +			m = &hfgitr_masks;				\
> +			break;						\
> +		case HDFGRTR_EL2:					\
> +			m = &hdfgrtr_masks;				\
> +			break;						\
> +		case HDFGWTR_EL2:					\
> +			m = &hdfgwtr_masks;				\
> +			break;						\
> +		case HAFGRTR_EL2:					\
> +			m = &hafgrtr_masks;				\
> +			break;						\
> +		default:						\
> +			BUILD_BUG_ON(1);				\
> +		}							\
> +									\
> +		m;							\
> +	})
> +
>  #define compute_clr_set(vcpu, reg, clr, set)				\
>  	do {								\
> -		u64 hfg;						\
> -		hfg = __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0;	\

__vcpu_sys_reg() has done the ~RES0 part since 888f0880702 ("KVM: arm64: nv: Add sanitising to VNCR-backed sysregs"),
in case anyone else wondered where that part went!

> -		set |= hfg & __ ## reg ## _MASK; 			\
> -		clr |= ~hfg & __ ## reg ## _nMASK; 			\
> +		u64 hfg = __vcpu_sys_reg(vcpu, reg);			\
> +		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
> +		set |= hfg & m->mask;					\
> +		clr |= ~hfg & m->nmask;					\
>  	} while(0)
>  
>  #define reg_to_fgt_group_id(reg)					\
> @@ -101,12 +130,14 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  #define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
>  	do {								\
>  		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
> -		set |= hfg & __ ## reg ## _MASK;			\
> -		clr |= hfg & __ ## reg ## _nMASK; 			\
> +		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
> +		set |= hfg & m->mask;					\
> +		clr |= hfg & m->nmask;					\
>  	} while(0)
>  
>  #define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
>  	do {								\
> +		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
>  		u64 c = clr, s = set;					\
>  		u64 val;						\
>  									\
> @@ -116,7 +147,7 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  									\
>  		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
>  									\
> -		val = __ ## reg ## _nMASK;				\
> +		val = m->nmask;						\
>  		val |= s;						\
>  		val &= ~c;						\
>  		write_sysreg_s(val, SYS_ ## reg);			\

