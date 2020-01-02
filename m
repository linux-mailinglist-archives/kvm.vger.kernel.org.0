Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E7012E8A2
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 17:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgABQVv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 11:21:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgABQVv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 11:21:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2E78328;
        Thu,  2 Jan 2020 08:21:50 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B3873F68F;
        Thu,  2 Jan 2020 08:21:50 -0800 (PST)
Date:   Thu, 2 Jan 2020 16:21:48 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        will@kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/18] arm64: KVM: reset E2PB correctly in MDCR_EL2
 when exiting the guest(VHE)
Message-ID: <20200102162147.GQ42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-3-andrew.murray@arm.com>
 <20191221131214.769a140e@why>
 <20191224102949.GD42593@e119886-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224102949.GD42593@e119886-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 24, 2019 at 10:29:50AM +0000, Andrew Murray wrote:
> On Sat, Dec 21, 2019 at 01:12:14PM +0000, Marc Zyngier wrote:
> > On Fri, 20 Dec 2019 14:30:09 +0000
> > Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > > From: Sudeep Holla <sudeep.holla@arm.com>
> > > 
> > > On VHE systems, the reset value for MDCR_EL2.E2PB=b00 which defaults
> > > to profiling buffer using the EL2 stage 1 translations. 
> > 
> > Does the reset value actually matter here? I don't see it being
> > specific to VHE systems, and all we're trying to achieve is to restore
> > the SPE configuration to a state where it can be used by the host.
> > 
> > > However if the
> > > guest are allowed to use profiling buffers changing E2PB settings, we
> > 
> > How can the guest be allowed to change E2PB settings? Or do you mean
> > here that allowing the guest to use SPE will mandate changes of the
> > E2PB settings, and that we'd better restore the hypervisor state once
> > we exit?
> > 
> > > need to ensure we resume back MDCR_EL2.E2PB=b00. Currently we just
> > > do bitwise '&' with MDCR_EL2_E2PB_MASK which will retain the value.
> > > 
> > > So fix it by clearing all the bits in E2PB.
> > > 
> > > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > ---
> > >  arch/arm64/kvm/hyp/switch.c | 4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > index 72fbbd86eb5e..250f13910882 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -228,9 +228,7 @@ void deactivate_traps_vhe_put(void)
> > >  {
> > >  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
> > >  
> > > -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> > > -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> > > -		    MDCR_EL2_TPMS;
> > > +	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
> > >  
> > >  	write_sysreg(mdcr_el2, mdcr_el2);
> > >  
> > 
> > I'm OK with this change, but I believe the commit message could use
> > some tidying up.
> 
> No problem, I'll update the commit message.

This is my new description:

    arm64: KVM: reset E2PB correctly in MDCR_EL2 when exiting the guest (VHE)
    
    Upon leaving the guest on VHE systems we currently preserve the value of
    MDCR_EL2.E2PB. This register determines if the SPE profiling buffer controls
    are trapped and which translation regime they use.
    
    In order to permit guest access to SPE we may use a different translation
    regime whilst the vCPU is scheduled - therefore let's ensure that upon leaving
    the guest we set E2PB back to the value expected by the host (b00).
    
    For nVHE systems we already explictly set E2PB back to the expected value
    of 0b11 in __deactivate_traps_nvhe.

Thanks,

Andrew Murray

> 
> Thanks,
> 
> Andrew Murray
> 
> > 
> > Thanks,
> > 
> > 	M.
> > -- 
> > Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
