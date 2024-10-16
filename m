Return-Path: <kvm+bounces-28996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0419A0B46
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:20:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19FECB27CC5
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 13:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA2B1EB5B;
	Wed, 16 Oct 2024 13:19:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34E1206E71
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084762; cv=none; b=ggUne0il6snzvROPmM8HCcp6FTbdCievhHRMgA5qpVVgzbIbMQU2uEsn++r4fltsSJY8wesbaxVlaLCezDnWnQ/m1bIxzcsuzy++lq4PT3XO5PLFGLEZkMCzkgbwf4L9aRQNV5LJRMtaeqdM0fs7Z+k77dVg5/bdnGH1plBo69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084762; c=relaxed/simple;
	bh=eQ3XQ5xCOVKHVO6j6DURkih8E8ejH6kHPbFeXY+gs6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bi9ap1+EIL+tbyCfbXO/9b838vXwJK8pAz/Eu89AKd/bAVJb3DRH9mzD6I0HUlRavxrnqM7LvlP9UnG3Ets1C9OVoMJIN3y41BUENKrqJdiLy+HSk823hYeeK3VbQ2hX2X99+abNvIa+5wEfvUvvywwW+aS7LCqHNICP54e5V9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD363FEC;
	Wed, 16 Oct 2024 06:19:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62A063F528;
	Wed, 16 Oct 2024 06:19:17 -0700 (PDT)
Date: Wed, 16 Oct 2024 14:19:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 06/36] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Message-ID: <Zw-9UvkO6eJkAaYQ@raptor>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-7-maz@kernel.org>
 <Zw-JTojEW5ZXa8R-@raptor>
 <861q0g5ls1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q0g5ls1.wl-maz@kernel.org>

Hi,

On Wed, Oct 16, 2024 at 12:29:02PM +0100, Marc Zyngier wrote:
> On Wed, 16 Oct 2024 10:37:18 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > I'm planning to have a look at (some) of the patches, do you have a
> > timeline for merging the series? Just so I know what to prioritise.
> 
> I want it merged yesterday. All of it.
> 
> > 
> > On Wed, Oct 09, 2024 at 07:59:49PM +0100, Marc Zyngier wrote:
> > > Accessing CNTHCTL_EL2 is fraught with danger if running with
> > > HCR_EL2.E2H=1: half of the bits are held in CNTKCTL_EL1, and
> > > thus can be changed behind our back, while the rest lives
> > > in the CNTHCTL_EL2 shadow copy that is memory-based.
> > > 
> > > Yes, this is a lot of fun!
> > > 
> > > Make sure that we merge the two on read access, while we can
> > > write to CNTKCTL_EL1 in a more straightforward manner.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c    | 28 ++++++++++++++++++++++++++++
> > >  include/kvm/arm_arch_timer.h |  3 +++
> > >  2 files changed, 31 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 3cd54656a8e2f..932d2fb7a52a0 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -157,6 +157,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> > >  		if (!is_hyp_ctxt(vcpu))
> > >  			goto memory_read;
> > >  
> > > +		/*
> > > +		 * CNTHCTL_EL2 requires some special treatment to
> > > +		 * account for the bits that can be set via CNTKCTL_EL1.
> > > +		 */
> > > +		switch (reg) {
> > > +		case CNTHCTL_EL2:
> > > +			if (vcpu_el2_e2h_is_set(vcpu)) {
> > > +				val = read_sysreg_el1(SYS_CNTKCTL);
> > > +				val &= CNTKCTL_VALID_BITS;
> > > +				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> > > +				return val;
> > > +			}
> > > +			break;
> > > +		}
> > > +
> > >  		/*
> > >  		 * If this register does not have an EL1 counterpart,
> > >  		 * then read the stored EL2 version.
> > > @@ -207,6 +222,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> > >  		 */
> > >  		__vcpu_sys_reg(vcpu, reg) = val;
> > >  
> > > +		switch (reg) {
> > > +		case CNTHCTL_EL2:
> > > +			/*
> > > +			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
> > > +			 * Otherwise, some of the bits are backed by
> > > +			 * CNTKCTL_EL1, while the rest is kept in memory.
> > > +			 * Yes, this is fun stuff.
> > > +			 */
> > > +			if (vcpu_el2_e2h_is_set(vcpu))
> > > +				write_sysreg_el1(val, SYS_CNTKCTL);
> > 
> > Sorry, but I just can't seem to get my head around why the RES0 bits aren't
> > cleared. Is KVM relying on the guest to implement Should-Be-Zero-or-Preserved,
> > as per the RES0 definition?
> 
> KVM isn't relying on anything. And it isn't about the RES0 bits not
> being cleared. It is about the HW not providing storage for some of
> the CNTHCTL_EL2 bits when the guest is using CNTKCTL_EL1 as a proxy
> for its own view of CNTHCTL_EL2.
> 
> Namely, bits outside of CNTKCTL_VALID_BITS are not guaranteed to be
> stored until (IIRC) FEAT_NV2p1, which retrospectively fixes the
> architecture by mandating that the relevant bits have dedicated
> storage.

The definition for RES0 says:

'A bit that is RES0 in a context is reserved for possible future use in that
context. To preserve forward compatibility, software:
 * Must not rely on the bit reading as 0.
 * Must use an SBZP policy to write to the bit.'

where Should-Be-Zero-of-Preserved (SBZP):

'When writing this field, software must either write all 0s to this field or, if
the register is being restored from a previously read state, write the
previously read value to this field. If this is not done, then the result is
unpredictable.'

And what about the rest of the RES0 bits from CNTKCTL_EL1, those that are RES0
in both registers?

Thanks,
Alex

