Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A703DB8B8
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 14:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbhG3Mib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 08:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238723AbhG3Mia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 08:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 387E560527;
        Fri, 30 Jul 2021 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627648706;
        bh=o6XJinuY1CMi7OTgS2kgmVPjGGg7c5qp+9A1WHaEJeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gvoj29gJx02m2wpzcfnFS/kvmf3bt/1JtnNfvnmVMt0Lx2mLv077D9LYeQ8y72IH0
         xK7eY6PADSRu2OsCVvpOgpjAhzPFWY1mHS734NAu8xlCOZninU5TDITouDswtHyKSw
         P3JBAGxK/A/RaI5GJ88s2JjmWV8wTvJD6GeSneGoOy+h0sFgdzdEt0TZb8xSe3HOm4
         u2tfhCEiq9PMqvLkaFdD+G0Kjszw5bHG2+spn+Tz2kk6wnn/xPpOOad0XKW61WJQmM
         jjnwoQbbY/tYqJkEJptW8MQeCiH/J8O2mrj8RAvRIoylG5xwq5hgQ3fOsk1ILcWfee
         PDCgxrH809nqg==
Date:   Fri, 30 Jul 2021 13:38:21 +0100
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
Subject: Re: [PATCH 05/16] KVM: arm64: Plumb MMIO checking into the fault
 handling
Message-ID: <20210730123820.GA23756@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-6-maz@kernel.org>
 <20210727181120.GD19173@willie-the-truck>
 <87y29qd9hb.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y29qd9hb.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 11:21:52AM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:11:21 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:48PM +0100, Marc Zyngier wrote:
> > > Plumb the MMIO checking code into the MMIO fault handling code.
> > > Nothing allows a region to be registered yet, so there should be
> > > no funtional change either.
> > 
> > Typo: functional
> > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/mmio.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> > > index 3dd38a151d2a..fd5747279d27 100644
> > > --- a/arch/arm64/kvm/mmio.c
> > > +++ b/arch/arm64/kvm/mmio.c
> > > @@ -6,6 +6,7 @@
> > >  
> > >  #include <linux/kvm_host.h>
> > >  #include <asm/kvm_emulate.h>
> > > +#include <asm/kvm_mmu.h>
> > >  #include <trace/events/kvm.h>
> > >  
> > >  #include "trace.h"
> > > @@ -130,6 +131,10 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> > >  	int len;
> > >  	u8 data_buf[8];
> > >  
> > > +	/* Check failed? Return to the guest for debriefing... */
> > > +	if (!kvm_check_ioguard_page(vcpu, fault_ipa))
> > > +		return 1;
> > > +
> > >  	/*
> > >  	 * No valid syndrome? Ask userspace for help if it has
> > >  	 * volunteered to do so, and bail out otherwise.
> > > @@ -156,6 +161,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> > >  	len = kvm_vcpu_dabt_get_as(vcpu);
> > >  	rt = kvm_vcpu_dabt_get_rd(vcpu);
> > >  
> > > +	/* If we cross a page boundary, check that too... */
> > > +	if (((fault_ipa + len - 1) & PAGE_MASK) != (fault_ipa & PAGE_MASK) &&
> > > +	    !kvm_check_ioguard_page(vcpu, fault_ipa + len - 1))
> > > +		return 1;
> > > +
> > 
> > I find this a little odd as the checks straddle the invalid syndrome check,
> > meaning that the relative priorities of KVM_ARCH_FLAG_MMIO_GUARD and
> > KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER are unclear.
> 
> Good point. And the combination of both flags on its own is odd. Maybe
> KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER should be ignored or deemed
> incompatible with the MMIO guard feature.
> 
> The lack of syndrome information means that we cannot really test for
> the boundaries of the access (len is invalid), so I'd be tempted to
> inject an abort in this case.
> 
> Thoughts?

I agree. Probably worth rejecting both flags anyway so the VMM knows what
it's getting, but injecting an abort into the guest if we don't have
sufficient syndrom information to triage it safely feels like the right
thing to do.

Will
