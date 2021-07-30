Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166113DB8E0
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhG3MuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhG3MuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 08:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E8060F94;
        Fri, 30 Jul 2021 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627649414;
        bh=Qx8s173dITTj8lJV0Vz8eXvZOBa4mUT9bdDcZtwP9Uo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FElWlKyjKu/pcWTrbgSrqv/Is3Rt7MaSar2yTy2qsCABnJd2AlNmxJP17O/tqGRmn
         Z+OrWRwxwm+SjOmpbYX2hRt0zu+6dPgzKnxi8SCvCqokvhn3XdrEvRuoa8F+9xg0/l
         kEKUMk6Q6fHWLK8pI4QJuS4aejesAiwFNKpJAK2mUaVHEx9hAEVZzS39P+v/va8ik0
         DguLFDI2Jlg+dzGCuTAdx1/Su7YHNFHHF02BCsIPZCCUjdLYTgmrT+26Ar/MRDFhDH
         f/caP/gOfCDjDOxCkP4VOx9QzBfgcwCfUcvC0MIuoyVo6CYTwZ1t/fdnbAe9kNVWc5
         0XVIgQF+h36wA==
Date:   Fri, 30 Jul 2021 13:50:09 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 06/16] KVM: arm64: Force a full unmap on vpcu reinit
Message-ID: <20210730125008.GB23756@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-7-maz@kernel.org>
 <20210727181132.GE19173@willie-the-truck>
 <87wnpad8pg.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnpad8pg.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 11:38:35AM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:11:33 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:49PM +0100, Marc Zyngier wrote:
> > > As we now keep information in the S2PT, we must be careful not
> > > to keep it across a VM reboot, which could otherwise lead to
> > > interesting problems.
> > > 
> > > Make sure that the S2 is completely discarded on reset of
> > > a vcpu, and remove the flag that enforces the MMIO check.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 97ab1512c44f..b0d2225190d2 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1096,12 +1096,18 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
> > >  	 * ensuring that the data side is always coherent. We still
> > >  	 * need to invalidate the I-cache though, as FWB does *not*
> > >  	 * imply CTR_EL0.DIC.
> > > +	 *
> > > +	 * If the MMIO guard was enabled, we pay the price of a full
> > > +	 * unmap to get back to a sane state (and clear the flag).
> > >  	 */
> > >  	if (vcpu->arch.has_run_once) {
> > > -		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> > > +		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> > > +		    test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
> > >  			stage2_unmap_vm(vcpu->kvm);
> > >  		else
> > >  			icache_inval_all_pou();
> > > +
> > > +		clear_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
> > 
> > What prevents this racing with another vCPU trying to set the bit?
> 
> Not much. We could take the kvm lock on both ends to serialize it, but
> that's pretty ugly. And should we care? What is the semantic of
> resetting a vcpu while another is still running?

It's definitely weird, but given that this is an attack vector I don't think
we can rule out attackers trying whacky stuff like this (although maybe
we end up forbidding vcpu reset in pKVM -- dunno).

> If we want to support this sort of behaviour, then our tracking is
> totally bogus, because it is VM-wide. And you don't even have to play
> with that bit from another vcpu: all the information is lost at the
> point where we unmap the S2 PTs.
> 
> Maybe an alternative is to move this to the halt/reboot PSCI handlers,
> making it clearer what we expect?

I think that's probably worth looking at. The race is quite hard to reason
about otherwise, so if clearing the bit can be done on the teardown path
in single-threaded context then I think that's better. It looks like
kvm_prepare_system_event() has all the synchronisation we need there.

Will
