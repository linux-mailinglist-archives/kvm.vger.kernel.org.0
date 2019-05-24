Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9B299CF
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403932AbfEXOM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 10:12:27 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:43846 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403864AbfEXOM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 10:12:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E549BA78;
        Fri, 24 May 2019 07:12:25 -0700 (PDT)
Received: from e107155-lin (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFD8C3F575;
        Fri, 24 May 2019 07:12:23 -0700 (PDT)
Date:   Fri, 24 May 2019 15:12:18 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 05/15] arm64: KVM: add access handler for SPE system
 registers
Message-ID: <20190524141218.GA29406@e107155-lin>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-6-sudeep.holla@arm.com>
 <c45323a8-92e4-e406-381b-2084e222a870@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c45323a8-92e4-e406-381b-2084e222a870@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 12:36:24PM +0100, Julien Thierry wrote:
> Hi Sudeep,
> 
> On 23/05/2019 11:34, Sudeep Holla wrote:
> > SPE Profiling Buffer owning EL is configurable and when MDCR_EL2.E2PB
> > is configured to provide buffer ownership to EL1, the control registers
> > are trapped.
> > 
> > Add access handlers for the Statistical Profiling Extension(SPE)
> > Profiling Buffer controls registers. This is need to support profiling
> > using SPE in the guests.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 13 ++++++++++++
> >  arch/arm64/kvm/sys_regs.c         | 35 +++++++++++++++++++++++++++++++
> >  include/kvm/arm_spe.h             | 15 +++++++++++++
> >  3 files changed, 63 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 611a4884fb6c..559aa6931291 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -147,6 +147,19 @@ enum vcpu_sysreg {
> >  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
> >  	DISR_EL1,	/* Deferred Interrupt Status Register */
> >  
> > +	/* Statistical Profiling Extension Registers */
> > +
> > +	PMSCR_EL1,
> > +	PMSICR_EL1,
> > +	PMSIRR_EL1,
> > +	PMSFCR_EL1,
> > +	PMSEVFR_EL1,
> > +	PMSLATFR_EL1,
> > +	PMSIDR_EL1,
> > +	PMBLIMITR_EL1,
> > +	PMBPTR_EL1,
> > +	PMBSR_EL1,
> > +
> >  	/* Performance Monitors Registers */
> >  	PMCR_EL0,	/* Control Register */
> >  	PMSELR_EL0,	/* Event Counter Selection Register */
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 857b226bcdde..dbf5056828d3 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -646,6 +646,30 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >  	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> >  }
> >  
> > +static bool access_pmsb_val(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > +			    const struct sys_reg_desc *r)
> > +{
> > +	if (p->is_write)
> > +		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> > +	else
> > +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> > +
> > +	return true;
> > +}
> > +
> > +static void reset_pmsb_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > +{
> > +	if (!kvm_arm_support_spe_v1()) {
> > +		__vcpu_sys_reg(vcpu, r->reg) = 0;
> > +		return;
> > +	}
> > +
> > +	if (r->reg == PMSIDR_EL1)
> 
> If only PMSIDR_EL1 has a non-zero reset value, it feels a bit weird to
> share the reset function for all these registers.
>

Ah, right. Initially I did have couple of other registers which were not
needed. So I removed them without observing that I could have just used
reset_val(0) for all except PMSIDR_EL1.

> I would suggest only having a reset_pmsidr() function, and just use
> reset_val() with sys_reg_desc->val set to 0 for all the others.
>

Thanks for pointing this out.

--
Regards,
Sudeep
