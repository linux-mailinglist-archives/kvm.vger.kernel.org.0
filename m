Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30DA1BF83C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD3MbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 08:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgD3MbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 08:31:10 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2377F20775;
        Thu, 30 Apr 2020 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588249869;
        bh=nm1PyrXDTwqhS6NYKdnWkhnDkQsHQnUWY8q4kZYvSUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xkGj2LpEXbs16dMgJa6Vxu/MNyvzkhrjcI1BpImWhwhNCJ18M0FFv8Azk5Dqmk6zr
         4WrqcJ+gyfmgRVri2UFb/TN6GGDWqtm6SrfjHYw77bWrPNB+5PgobuEr5UMZG98EUw
         mhV2tJbIWmbH4fhLyWvdI37enHoWIVq28c4gT8WA=
Date:   Thu, 30 Apr 2020 13:31:05 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
Message-ID: <20200430123104.GB22842@willie-the-truck>
References: <20200430101513.318541-1-maz@kernel.org>
 <20200430102556.GE19932@willie-the-truck>
 <897baec2a3fad776716bccf3027340fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897baec2a3fad776716bccf3027340fa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 30, 2020 at 11:59:05AM +0100, Marc Zyngier wrote:
> On 2020-04-30 11:25, Will Deacon wrote:
> > On Thu, Apr 30, 2020 at 11:15:13AM +0100, Marc Zyngier wrote:
> > > In the unlikely event that a 32bit vcpu traps into the hypervisor
> > > on an instruction that is located right at the end of the 32bit
> > > range, the emulation of that instruction is going to increment
> > > PC past the 32bit range. This isn't great, as userspace can then
> > > observe this value and get a bit confused.
> > > 
> > > Conversly, userspace can do things like (in the context of a 64bit
> > > guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
> > > set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
> > > that PC hasn't been truncated. More confusion.
> > > 
> > > Fix both by:
> > > - truncating PC increments for 32bit guests
> > > - sanitize PC every time a core reg is changed by userspace, and
> > >   that PSTATE indicates a 32bit mode.
> > 
> > It's not clear to me whether this needs a cc stable. What do you think?
> > I
> > suppose that it really depends on how confused e.g. QEMU gets.
> 
> It isn't so much QEMU itself that I'm worried about (the emulation shouldn't
> really care about the PC), but the likes of GDB. So yes, a cc stable seems
> to
> be in order.

Okey doke.

> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/guest.c     | 4 ++++
> > >  virt/kvm/arm/hyp/aarch32.c | 8 ++++++--
> > >  2 files changed, 10 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 23ebe51410f0..2a159af82429 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > const struct kvm_one_reg *reg)
> > >  	}
> > > 
> > >  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> > > +
> > > +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> > > +		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> > 
> > It seems slightly odd to me that we don't enforce this for *all* the
> > registers when running as a 32-bit guest. Couldn't userspace be equally
> > confused by a 64-bit lr or sp?
> 
> Fair point. How about this on top, which wipes the upper 32 bits for
> each and every register in the current mode:
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2a159af82429..f958c3c7bf65 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -201,9 +201,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const
> struct kvm_one_reg *reg)
> 
>  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> 
> -	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> -		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
> +		int i;
> 
> +		for (i = 0; i < 16; i++)
> +			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);

I think you're missing all the funny banked registers that live all the way
up to x30 iirc.

Will
