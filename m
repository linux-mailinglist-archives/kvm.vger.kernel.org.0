Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855EE12A046
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 12:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLXLLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 06:11:11 -0500
Received: from foss.arm.com ([217.140.110.172]:51126 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfLXLLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 06:11:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7185A1FB;
        Tue, 24 Dec 2019 03:11:08 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB9FD3F534;
        Tue, 24 Dec 2019 03:11:07 -0800 (PST)
Date:   Tue, 24 Dec 2019 11:11:06 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 10/18] arm64: KVM/debug: use EL1&0 stage 1 translation
 regime
Message-ID: <20191224111105.GF42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-11-andrew.murray@arm.com>
 <86d0cgir74.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86d0cgir74.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 10:34:55AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:17 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > Now that we have all the save/restore mechanism in place, lets enable
> > the translation regime used by buffer from EL2 stage 1 to EL1 stage 1
> > on VHE systems.
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > [ Reword commit, don't trap to EL2 ]
> 
> Not trapping to EL2 for the case where we don't allow SPE in the
> guest is not acceptable.

Yes understood (because of this I had meant to send the series as RFC btw).


> 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 67b7c160f65b..6c153b79829b 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -100,6 +100,7 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
> >  
> >  	write_sysreg(val, cpacr_el1);
> >  
> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
> >  }
> >  NOKPROBE_SYMBOL(activate_traps_vhe);
> > @@ -117,6 +118,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> >  		__activate_traps_fpsimd32(vcpu);
> >  	}
> >  
> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
> 
> There is a _MASK macro that can replace this '3', and is in keeping
> with the rest of the code.

OK.


> 
> It still remains that it looks like the wrong place to do this, and
> vcpu_load seems much better. Why should you write to mdcr_el2 on each
> entry to the guest, since you know whether it has SPE enabled at the
> point where it gets scheduled?

Yes OK, I'll move what I can to vcpu_load.

Thanks,

Andrew Murray


> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
