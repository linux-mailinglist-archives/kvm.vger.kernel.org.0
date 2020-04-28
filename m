Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174351BB378
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 03:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgD1Bef convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 27 Apr 2020 21:34:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:39564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbgD1Bef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 21:34:35 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 050A225275FAC370E7B4;
        Tue, 28 Apr 2020 09:34:34 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.234]) by
 DGGEMM402-HUB.china.huawei.com ([10.3.20.210]) with mapi id 14.03.0487.000;
 Tue, 28 Apr 2020 09:34:24 +0800
From:   "Zengtao (B)" <prime.zeng@hisilicon.com>
To:     Marc Zyngier <maz@kernel.org>, yuzenghui <yuzenghui@huawei.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        "Dave Martin" <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Subject: RE: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU
 reset state
Thread-Topic: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU
 reset state
Thread-Index: AQHWGKCGXKlP0CoY30iMrQFdxO97gqiHJHkAgAA8s4CABmeP4A==
Date:   Tue, 28 Apr 2020 01:34:24 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A5634AE@dggemm526-mbx.china.huawei.com>
References: <20200422120050.3693593-1-maz@kernel.org>
        <20200422120050.3693593-19-maz@kernel.org>
        <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
 <20200424084505.6b0afc94@why>
In-Reply-To: <20200424084505.6b0afc94@why>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org]
> On Behalf Of Marc Zyngier
> Sent: Friday, April 24, 2020 3:45 PM
> To: yuzenghui
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Will Deacon; Andre Przywara; Dave Martin;
> George Cherian; Zengtao (B); Catalin Marinas
> Subject: Re: [PATCH 18/26] KVM: arm64: Don't use empty structures as
> CPU reset state
> 
> Hi Zenghui,
> 
> On Fri, 24 Apr 2020 12:07:50 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> > Hi Marc,
> >
> > On 2020/4/22 20:00, Marc Zyngier wrote:
> > > Keeping empty structure as the vcpu state initializer is slightly
> > > wasteful: we only want to set pstate, and zero everything else.
> > > Just do that.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >   arch/arm64/kvm/reset.c | 20 +++++++++-----------
> > >   1 file changed, 9 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > > index 241db35a7ef4f..895d7d9ad1866 100644
> > > --- a/arch/arm64/kvm/reset.c
> > > +++ b/arch/arm64/kvm/reset.c
> > > @@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
> > >   /*
> > >    * ARMv8 Reset Values
> > >    */
> > > -static const struct kvm_regs default_regs_reset = {
> > > -	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
> > > -			PSR_F_BIT | PSR_D_BIT),
> > > -};
> > > +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h |
> PSR_A_BIT | PSR_I_BIT | \
> > > +				 PSR_F_BIT | PSR_D_BIT)
> > >   > -static const struct kvm_regs default_regs_reset32 = {
> > > -	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
> > > -			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> > > -};
> > > +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC |
> PSR_AA32_A_BIT | \
> > > +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> > >   >   static bool cpu_has_32bit_el1(void)
> > >   {
> > > @@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> > >   	const struct kvm_regs *cpu_reset;
> > >   	int ret = -EINVAL;
> > >   	bool loaded;
> > > +	u32 pstate;
> > >   >   	/* Reset PMU outside of the non-preemptible section */
> > >   	kvm_pmu_vcpu_reset(vcpu);
> > > @@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu
> *vcpu)
> > >   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT,
> vcpu->arch.features)) {
> > >   			if (!cpu_has_32bit_el1())
> > >   				goto out;
> > > -			cpu_reset = &default_regs_reset32;
> > > +			pstate = VCPU_RESET_PSTATE_SVC;
> > >   		} else {
> > > -			cpu_reset = &default_regs_reset;
> > > +			pstate = VCPU_RESET_PSTATE_EL1;
> > >   		}
> > >   >   		break;
> > >   	}
> > >   >   	/* Reset core registers */
> > > -	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
> > > +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));
> >
> > Be careful that we can *not* use 'sizeof(*cpu_reset)' here anymore.
> As
> > you're going to refactor the layout of the core registers whilst keeping
> > the kvm_regs API unchanged.  Resetting the whole kvm_regs will go
> > corrupting some affected registers and make them temporarily invalid.
> > The bad thing will show up after you start moving ELR_EL1 around,
> > specifically in patch #20...
> 
> Ah, awesome find! Yes, it is pretty obvious now that you point it out.
> If I had removed this now useless cpu_reset variable, I'd have spotted
> it!
> 
> > And the first victim is ... MPIDR_EL1 (the first one in sys_regs array).
> > Now you know how this was spotted ;-)  I think this should be the
> root
> > cause of what Zengtao had previously reported [*].
> 
> It'd be good if Zengtao could confirm that changing this line to
> 
> 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> 
> fixes his problem.

I tried this change, and it did fix my problem, thanks :). 

> 
> > If these registers are all expected to be reset to architecturally
> > UNKNOWN values, I think we can just drop this memset(), though
> haven't
> > check with the ARM ARM carefully.
> 
> D1.9.1 ("PE state on reset to AArch64 state"):
> 
> "All general-purpose, and SIMD and floating-point registers are
> UNKNOWN."
> 
> There is a vaguely similar wording for AArch32 (G1.17.1), although it
> is only described by omission:
> 
> "Immediately after a reset, much of the PE state is UNKNOWN. However,
> some of the PE state is defined."
> 
> and the GPRs are not part of the list of defined states.
> 
> Still, I'm worried to change KVM's behaviour after so long... I'll have
> a try with a handful of non-Linux guests and see if anything breaks.
> 
> Thanks again,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
