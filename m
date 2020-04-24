Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEBB1B6F39
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 09:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgDXHpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 03:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgDXHpJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 03:45:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6AB220704;
        Fri, 24 Apr 2020 07:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587714309;
        bh=bgQUeLtR5/7GCj8flGJ20OIZAJat0izFGHC+rQxM1Nw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZYezxYGsy/G1/2Jk5bMxQlxiWkn+K1nNr7hI7ZppcXRhc8cg98jCrayPkkBrdIisP
         GQdWFFKlqM2rLs5qeqWiQvTeMhc9jvcpu863z+OFOYVW7Q7JiYRoAF0sFpOyPKHEVd
         jEfBF2WmiIdN2XcMiyBclLkmiiCrfBC9RLg6c8k8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRt1H-005zJu-9N; Fri, 24 Apr 2020 08:45:07 +0100
Date:   Fri, 24 Apr 2020 08:45:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU
 reset state
Message-ID: <20200424084505.6b0afc94@why>
In-Reply-To: <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
References: <20200422120050.3693593-1-maz@kernel.org>
        <20200422120050.3693593-19-maz@kernel.org>
        <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, andre.przywara@arm.com, Dave.Martin@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On Fri, 24 Apr 2020 12:07:50 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi Marc,
> 
> On 2020/4/22 20:00, Marc Zyngier wrote:
> > Keeping empty structure as the vcpu state initializer is slightly
> > wasteful: we only want to set pstate, and zero everything else.
> > Just do that.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >   arch/arm64/kvm/reset.c | 20 +++++++++-----------
> >   1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 241db35a7ef4f..895d7d9ad1866 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
> >   /*
> >    * ARMv8 Reset Values
> >    */
> > -static const struct kvm_regs default_regs_reset = {
> > -	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
> > -			PSR_F_BIT | PSR_D_BIT),
> > -};
> > +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> > +				 PSR_F_BIT | PSR_D_BIT)  
> >   > -static const struct kvm_regs default_regs_reset32 = {  
> > -	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
> > -			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> > -};
> > +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> > +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)  
> >   >   static bool cpu_has_32bit_el1(void)  
> >   {
> > @@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >   	const struct kvm_regs *cpu_reset;
> >   	int ret = -EINVAL;
> >   	bool loaded;
> > +	u32 pstate;  
> >   >   	/* Reset PMU outside of the non-preemptible section */  
> >   	kvm_pmu_vcpu_reset(vcpu);
> > @@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> >   			if (!cpu_has_32bit_el1())
> >   				goto out;
> > -			cpu_reset = &default_regs_reset32;
> > +			pstate = VCPU_RESET_PSTATE_SVC;
> >   		} else {
> > -			cpu_reset = &default_regs_reset;
> > +			pstate = VCPU_RESET_PSTATE_EL1;
> >   		}  
> >   >   		break;  
> >   	}  
> >   >   	/* Reset core registers */  
> > -	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
> > +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));  
> 
> Be careful that we can *not* use 'sizeof(*cpu_reset)' here anymore.  As
> you're going to refactor the layout of the core registers whilst keeping
> the kvm_regs API unchanged.  Resetting the whole kvm_regs will go
> corrupting some affected registers and make them temporarily invalid.
> The bad thing will show up after you start moving ELR_EL1 around,
> specifically in patch #20...

Ah, awesome find! Yes, it is pretty obvious now that you point it out.
If I had removed this now useless cpu_reset variable, I'd have spotted
it!

> And the first victim is ... MPIDR_EL1 (the first one in sys_regs array).
> Now you know how this was spotted ;-)  I think this should be the root
> cause of what Zengtao had previously reported [*].

It'd be good if Zengtao could confirm that changing this line to

	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));

fixes his problem.

> If these registers are all expected to be reset to architecturally
> UNKNOWN values, I think we can just drop this memset(), though haven't
> check with the ARM ARM carefully.

D1.9.1 ("PE state on reset to AArch64 state"):

"All general-purpose, and SIMD and floating-point registers are
UNKNOWN."

There is a vaguely similar wording for AArch32 (G1.17.1), although it
is only described by omission:

"Immediately after a reset, much of the PE state is UNKNOWN. However,
some of the PE state is defined."

and the GPRs are not part of the list of defined states.

Still, I'm worried to change KVM's behaviour after so long... I'll have
a try with a handful of non-Linux guests and see if anything breaks.

Thanks again,

         M.
-- 
Jazz is not dead. It just smells funny...
