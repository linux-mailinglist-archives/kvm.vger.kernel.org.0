Return-Path: <kvm+bounces-59155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CBEEBAC8B0
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C7D71886F9A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE692222CA;
	Tue, 30 Sep 2025 10:45:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB9D5227
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759229158; cv=none; b=mCuvnB3vZ1ykSyCsfKI8k43VqStcPjGAFMpIGFW8UTk+/07Z93uZWxySB8MVmigDxmhPmQ27OcM3A+926RzG4Q/Gg8+lnfYNYby49pcDn8rTzOao+Npta33QyMKx7PTdIvMkwY88rucupGTZb7+rMbBwUuakX073h9APJl7u8QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759229158; c=relaxed/simple;
	bh=uGId4gXSZl6X3lPY5nilv8OMliez6i3MORgaqDa/tFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laRP8efQoR3wmQ+sjHp42eM5xqG7qe7hn4GSXgBP2lVXJSJxRQ+1Deo8899wco+O4g30uEVpIkrv9eZ6NQASyRez6bCv/4IkHVf2g1XgQGmOk+hTKEJiP8hqcTx0+9SP6IJQU2LUc5SiJ2/I90CTT8Zl/ZMt/LrqPYiwjbgX7KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A8971424;
	Tue, 30 Sep 2025 03:45:48 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 202A93F66E;
	Tue, 30 Sep 2025 03:45:54 -0700 (PDT)
Date: Tue, 30 Sep 2025 11:45:52 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 08/13] KVM: arm64: Move CNT*CT_EL0 userspace accessors to
 generic infrastructure
Message-ID: <20250930104552.GB1093338@e124191.cambridge.arm.com>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929160458.3351788-9-maz@kernel.org>

Observation below

  |
  v

On Mon, Sep 29, 2025 at 05:04:52PM +0100, Marc Zyngier wrote:
> Moving the counter registers is a bit more involved than for the control
> and comparator (there is no shadow data for the counter), but still
> pretty manageable.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/guest.c    |  7 -------
>  arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++---
>  2 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index c23ec9be4ce27..138e5e2dc10c8 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -592,19 +592,12 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
>  }
>  
>  static const u64 timer_reg_list[] = {
> -	KVM_REG_ARM_TIMER_CNT,
> -	KVM_REG_ARM_PTIMER_CNT,
>  };
>  
>  #define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
>  
>  static bool is_timer_reg(u64 index)
>  {
> -	switch (index) {
> -	case KVM_REG_ARM_TIMER_CNT:
> -	case KVM_REG_ARM_PTIMER_CNT:
> -		return true;
> -	}
>  	return false;
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 68e88d5c0dfb5..e67eb39ddc118 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1605,12 +1605,38 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
>  	case SYS_CNTHP_CTL_EL2:
>  		val &= ~ARCH_TIMER_CTRL_IT_STAT;
>  		break;
> +	case SYS_CNTVCT_EL0:
> +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> +			timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
> +		return 0;
> +	case SYS_CNTPCT_EL0:
> +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> +			timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);
> +		return 0;
>  	}
>  
>  	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
>  	return 0;
>  }
>  
> +static int arch_timer_get_user(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       u64 *val)
> +{
> +	switch (reg_to_encoding(rd)) {
> +	case SYS_CNTVCT_EL0:
> +		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_vtimer(vcpu));
> +		break;
> +	case SYS_CNTPCT_EL0:
> +		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_ptimer(vcpu));
> +		break;
> +	default:
> +		*val = __vcpu_sys_reg(vcpu, rd->reg);

Unsure if this is actually an issue but for the _CTL registers, via
access_arch_timer() (kvm_arm_timer_read_sysreg() -> .. -> read_timer_ctl()),
the ARCH_TIMER_CTRL_IT_STAT bit will be set if the timer expired, but that's
not done here.

> +	}
> +
> +	return 0;
> +}
> +
>  static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
>  				    s64 new, s64 cur)
>  {
> @@ -2539,7 +2565,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
>  
>  #define TIMER_REG(name, vis)					   \
>  	SYS_REG_USER_FILTER(name, access_arch_timer, reset_val, 0, \
> -			    NULL, arch_timer_set_user, vis)
> +			    arch_timer_get_user, arch_timer_set_user, vis)
>  
>  /*
>   * Since reset() callback and field val are not used for idregs, they will be
> @@ -3506,8 +3532,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	AMU_AMEVTYPER1_EL0(14),
>  	AMU_AMEVTYPER1_EL0(15),
>  
> -	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
> -	{ SYS_DESC(SYS_CNTVCT_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTPCT_EL0), .access = access_arch_timer,
> +	  .get_user = arch_timer_get_user, .set_user = arch_timer_set_user },
> +	{ SYS_DESC(SYS_CNTVCT_EL0), .access = access_arch_timer,
> +	  .get_user = arch_timer_get_user, .set_user = arch_timer_set_user },
>  	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTVCTSS_EL0), access_arch_timer },
>  	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },

Thanks,
Joey

