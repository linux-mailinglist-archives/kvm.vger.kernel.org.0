Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1BC1BF9DE
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgD3Nqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbgD3Nqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 09:46:55 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1732082E;
        Thu, 30 Apr 2020 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254414;
        bh=cIGsayzyQrmoAosJwNbheDRWF4TGcuP/5fJyINZP78U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BRMV7FauM4SoitKAPFxH/263TwK51GMEbX2WUTdzhWUPJYlLMMchtTpkp3VX4JOUR
         7ifde/j5zTwb0Zt2UrTSiL0TrRKM9w9fUc4hJ0F5NYKAx1p9Qc9Ah6bCL5S6NGIudW
         7MDW0NUmac55807mzyt0EoogYvL7pcm3ttyAYaNk=
Date:   Thu, 30 Apr 2020 14:46:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
Message-ID: <20200430134649.GC22842@willie-the-truck>
References: <20200430101513.318541-1-maz@kernel.org>
 <20200430102556.GE19932@willie-the-truck>
 <897baec2a3fad776716bccf3027340fa@kernel.org>
 <20200430123104.GB22842@willie-the-truck>
 <1c0175a09a90d2b7c0243e5bcec7cc9a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c0175a09a90d2b7c0243e5bcec7cc9a@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 30, 2020 at 01:45:51PM +0100, Marc Zyngier wrote:
> On 2020-04-30 13:31, Will Deacon wrote:
> > On Thu, Apr 30, 2020 at 11:59:05AM +0100, Marc Zyngier wrote:
> > > On 2020-04-30 11:25, Will Deacon wrote:
> > > > On Thu, Apr 30, 2020 at 11:15:13AM +0100, Marc Zyngier wrote:
> > > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > > index 23ebe51410f0..2a159af82429 100644
> > > > > --- a/arch/arm64/kvm/guest.c
> > > > > +++ b/arch/arm64/kvm/guest.c
> > > > > @@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > > > const struct kvm_one_reg *reg)
> > > > >  	}
> > > > >
> > > > >  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> > > > > +
> > > > > +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> > > > > +		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> > > >
> > > > It seems slightly odd to me that we don't enforce this for *all* the
> > > > registers when running as a 32-bit guest. Couldn't userspace be equally
> > > > confused by a 64-bit lr or sp?
> > > 
> > > Fair point. How about this on top, which wipes the upper 32 bits for
> > > each and every register in the current mode:
> > > 
> > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > index 2a159af82429..f958c3c7bf65 100644
> > > --- a/arch/arm64/kvm/guest.c
> > > +++ b/arch/arm64/kvm/guest.c
> > > @@ -201,9 +201,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu,
> > > const
> > > struct kvm_one_reg *reg)
> > > 
> > >  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> > > 
> > > -	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> > > -		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));
> > > +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK) {
> > > +		int i;
> > > 
> > > +		for (i = 0; i < 16; i++)
> > > +			*vcpu_reg32(vcpu, i) = (u32)*vcpu_reg32(vcpu, i);
> > 
> > I think you're missing all the funny banked registers that live all the
> > way
> > up to x30 iirc.
> 
> No, they are all indirected via vcpu_reg32(), which has the magic tables.
> And the whole point is that we only want to affect the current mode (no
> point
> in repainting the FIQ registers if the PSR says USR).
> 
> Or am I missing something obvious?

Nope, just my inability to parse vcpu_reg32 the first time around! So, for
the updated patch:

Acked-by: Will Deacon <will@kernel.org?

Thanks,

Will
