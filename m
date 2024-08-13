Return-Path: <kvm+bounces-24032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD714950A01
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69E44282107
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 16:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799961A0AFB;
	Tue, 13 Aug 2024 16:20:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291E61A0709
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723566011; cv=none; b=QP+hk7WktF2tG9Rlj6KW00i9EZdqYyaQs3VzgdrYVn8ysIfeKi4LMfYv6oB3YPmFnYE0K2nJlnNVIX/NRpoUtY3ntxFVz3t8LAcL3lFWWTyBC9NRrM3HqZtWnoG5DZ7k3h7Kgb5LXF3NHlVPSOfd3loDLdpXbz1gVckzwzR8RTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723566011; c=relaxed/simple;
	bh=ZKTCFZmbG5pTOi9ndxbq9LGUYrME/QFRl3HIWniT/i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fo49b3849dvl/4RTODnkzw3NmBJVcshy901CNWAhcTqqUwPhm2pKFuPMBibd/qZRDqAzIrngXtyDu6jVwZ8jFXukatnrguXiE001yO5MI8pBwJtoAwqRYvOdvSHlpkvYAKjRmDb+endKEdAZ94jtaIIgKZSwljlc0EDT4/1Be+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4221412FC;
	Tue, 13 Aug 2024 09:20:32 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1CB13F6A8;
	Tue, 13 Aug 2024 09:20:04 -0700 (PDT)
Date: Tue, 13 Aug 2024 17:19:59 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 09/10] KVM: arm64: Handle  PIR{,E0}_EL2 traps
Message-ID: <20240813154937.GA3328587@e124191.cambridge.arm.com>
References: <20240813144738.2048302-1-maz@kernel.org>
 <20240813144738.2048302-10-maz@kernel.org>
 <20240813152452.GD3321997@e124191.cambridge.arm.com>
 <878qx05sut.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qx05sut.wl-maz@kernel.org>

On Tue, Aug 13, 2024 at 04:45:46PM +0100, Marc Zyngier wrote:
> On Tue, 13 Aug 2024 16:24:52 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > On Tue, Aug 13, 2024 at 03:47:37PM +0100, Marc Zyngier wrote:
> > > Add the FEAT_S1PIE EL2 registers the sysreg descriptor array so that
> > > they can be handled as a trap.
> > > 
> > > Access to these registers is conditionned on ID_AA64MMFR3_EL1.S1PIE
> > > being advertised.
> > > 
> > > Similarly to other other changes, PIRE0_EL2 is guaranteed to trap
> > > thanks to the D22677 update to the architecture..
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 52250db3c122..a5f604e24e05 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -346,6 +346,18 @@ static bool access_rw(struct kvm_vcpu *vcpu,
> > >  	return true;
> > >  }
> > >  
> > > +static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
> > > +				  struct sys_reg_params *p,
> > > +				  const struct sys_reg_desc *r)
> > > +{
> > > +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
> > > +		kvm_inject_undefined(vcpu);
> > > +		return false;
> > > +	}
> > > +
> > > +	return access_rw(vcpu, p, r);
> > > +}
> > > +
> > >  /*
> > >   * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
> > >   */
> > > @@ -2827,6 +2839,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > >  	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
> > >  
> > >  	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
> > > +	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
> > > +	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
> > >  	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
> > >  
> > >  	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
> > 
> > I think we should also use this for PIR_EL1 / PIRE0_EL1? We have NULL for their access field.
> > 
> > 	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
> 
> I don't think we need this. In general, the EL1 FEAT_S1PIE registers
> are directly accessed by the VM, and do not trap.
> 
> However, if the VM has been configured to not expose S1PIE, then we
> set the corresponding FGU bits in kvm_calculate_traps():
> 
> 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
> 						HFGxTR_EL2_nPIR_EL1);
> 
> The effect of this is that we don't even make to the sysreg array, and
> inject an UNDEF directly from the point of decoding the trap (see the
> beginning of triage_sysreg_trap()).
> 
> For EL2 registers, there is no concept of FGT since they always trap,
> so no architectural trick we can play to shortcut the handling.
> Therefore we make it to the handler and have to triage things there.
> 
> Does it make sense?

Ah yes, forgot how that worked, thanks for the reminder!

There's another 'conditionned' typo in the commit message, but otherwise:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

