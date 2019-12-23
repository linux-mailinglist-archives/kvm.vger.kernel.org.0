Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED2E1295BA
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLWL4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:56:55 -0500
Received: from foss.arm.com ([217.140.110.172]:43766 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbfLWL4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:56:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BEFA1FB;
        Mon, 23 Dec 2019 03:56:54 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5C7F3F68F;
        Mon, 23 Dec 2019 03:56:53 -0800 (PST)
Date:   Mon, 23 Dec 2019 11:56:52 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 11/18] KVM: arm64: don't trap Statistical Profiling
 controls to EL2
Message-ID: <20191223115651.GA42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-12-andrew.murray@arm.com>
 <86bls0iqv6.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bls0iqv6.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 10:42:05AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:18 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > As we now save/restore the profiler state there is no need to trap
> > accesses to the statistical profiling controls. Let's unset the
> > _TPMS bit.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/debug.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index 43487f035385..07ca783e7d9e 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -88,7 +88,6 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
> >   *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> >   *  - Debug ROM Address (MDCR_EL2_TDRA)
> >   *  - OS related registers (MDCR_EL2_TDOSA)
> > - *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
> >   *
> >   * Additionally, KVM only traps guest accesses to the debug registers if
> >   * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
> > @@ -111,7 +110,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  	 */
> >  	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> >  	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
> > -				MDCR_EL2_TPMS |
> 
> No. This is an *optional* feature (the guest could not be presented
> with the SPE feature, or the the support simply not be compiled in).
> 
> If the guest is not allowed to see the feature, for whichever reason,
> the traps *must* be enabled and handled.

I'll update this (and similar) to trap such registers when we don't support
SPE in the guest.

My original concern in the cover letter was in how to prevent the guest
from attempting to use these registers in the first place - I think the
solution I was looking for is to trap-and-emulate ID_AA64DFR0_EL1 such that
the PMSVer bits indicate that SPE is not emulated.

Thanks,

Andrew Murray


> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
