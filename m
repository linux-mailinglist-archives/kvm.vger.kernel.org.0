Return-Path: <kvm+bounces-59159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5CBBBACE38
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 14:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4013A3A34
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1343F2F6560;
	Tue, 30 Sep 2025 12:41:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18382561AA
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759236081; cv=none; b=InsTOiVu03gci9OfBcR0prcqRHGPkvpN2vsDonDWZBWEXGk7JSgFD68NajAHVT7EK6oI/DejlAzSkoJKyizSwMBwJT7eO4FEHRjE7zONODtPWnyAfHsQvibGLxwmPfa/H2IV0EPKBAumcdyJ5tEg1ei1LbqjTPVgPxbjq1aq0eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759236081; c=relaxed/simple;
	bh=XUMNDUlQ42X0HZHhNXW7nGSIkc2/6BF3Of8OwnoJB7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=echWRml8vJVN0fLisDbDGoAa0dIITVpE/tikXNfN6ZCUw0RakQVEYnlJIgH3RjgBQEjrah2HZKCUSJjATZwbWNloiP8Ky6AKWvQoxjewVjEGO2EQ3b/LcpxQ0l88luL6ZZiGX3NRS5A8aUtnOzobHd7oWptqI4AftDpkZA9IcfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3FF7339;
	Tue, 30 Sep 2025 05:41:09 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E70E3F66E;
	Tue, 30 Sep 2025 05:41:16 -0700 (PDT)
Date: Tue, 30 Sep 2025 13:41:10 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 08/13] KVM: arm64: Move CNT*CT_EL0 userspace accessors to
 generic infrastructure
Message-ID: <20250930124055.GA1107543@e124191.cambridge.arm.com>
References: <20250929160458.3351788-1-maz@kernel.org>
 <20250929160458.3351788-9-maz@kernel.org>
 <20250930104552.GB1093338@e124191.cambridge.arm.com>
 <86tt0kywlq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tt0kywlq.wl-maz@kernel.org>

On Tue, Sep 30, 2025 at 01:05:05PM +0100, Marc Zyngier wrote:
> On Tue, 30 Sep 2025 11:45:52 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Observation below
> > 
> >   |
> >   v
> > 
> > On Mon, Sep 29, 2025 at 05:04:52PM +0100, Marc Zyngier wrote:
> > > Moving the counter registers is a bit more involved than for the control
> > > and comparator (there is no shadow data for the counter), but still
> > > pretty manageable.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/guest.c    |  7 -------
> > >  arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++---
> > >  2 files changed, 31 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index c23ec9be4ce27..138e5e2dc10c8 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -592,19 +592,12 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
> > >  }
> > >  
> > >  static const u64 timer_reg_list[] = {
> > > -	KVM_REG_ARM_TIMER_CNT,
> > > -	KVM_REG_ARM_PTIMER_CNT,
> > >  };
> > >  
> > >  #define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
> > >  
> > >  static bool is_timer_reg(u64 index)
> > >  {
> > > -	switch (index) {
> > > -	case KVM_REG_ARM_TIMER_CNT:
> > > -	case KVM_REG_ARM_PTIMER_CNT:
> > > -		return true;
> > > -	}
> > >  	return false;
> > >  }
> > >  
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 68e88d5c0dfb5..e67eb39ddc118 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1605,12 +1605,38 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
> > >  	case SYS_CNTHP_CTL_EL2:
> > >  		val &= ~ARCH_TIMER_CTRL_IT_STAT;
> > >  		break;
> > > +	case SYS_CNTVCT_EL0:
> > > +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> > > +			timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
> > > +		return 0;
> > > +	case SYS_CNTPCT_EL0:
> > > +		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
> > > +			timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);
> > > +		return 0;
> > >  	}
> > >  
> > >  	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
> > >  	return 0;
> > >  }
> > >  
> > > +static int arch_timer_get_user(struct kvm_vcpu *vcpu,
> > > +			       const struct sys_reg_desc *rd,
> > > +			       u64 *val)
> > > +{
> > > +	switch (reg_to_encoding(rd)) {
> > > +	case SYS_CNTVCT_EL0:
> > > +		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_vtimer(vcpu));
> > > +		break;
> > > +	case SYS_CNTPCT_EL0:
> > > +		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_ptimer(vcpu));
> > > +		break;
> > > +	default:
> > > +		*val = __vcpu_sys_reg(vcpu, rd->reg);
> > 
> > Unsure if this is actually an issue but for the _CTL registers, via
> > access_arch_timer() (kvm_arm_timer_read_sysreg() -> .. -> read_timer_ctl()),
> > the ARCH_TIMER_CTRL_IT_STAT bit will be set if the timer expired, but that's
> > not done here.
> 
> Indeed, but I don't think this really matters, at least not for
> save/restore. We always clear the ISTATUS bit on restore, and
> snapshoting CTL is always a racy process.

Makes sense, so:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

