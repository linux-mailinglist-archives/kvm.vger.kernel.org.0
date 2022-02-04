Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04FB4A988C
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357014AbiBDLrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:47:19 -0500
Received: from foss.arm.com ([217.140.110.172]:38484 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230033AbiBDLrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 06:47:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5687F1480;
        Fri,  4 Feb 2022 03:47:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838873F40C;
        Fri,  4 Feb 2022 03:47:15 -0800 (PST)
Date:   Fri, 4 Feb 2022 11:47:25 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 09/64] KVM: arm64: nv: Support virtual EL2 exceptions
Message-ID: <Yf0STQXSEtPPApTL@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-10-maz@kernel.org>
 <Yfqh6BocbZA1jexU@monolith.localdoman>
 <87h79f3kxj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h79f3kxj.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 03, 2022 at 05:43:36PM +0000, Marc Zyngier wrote:
> On Wed, 02 Feb 2022 15:23:20 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Fri, Jan 28, 2022 at 12:18:17PM +0000, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > > new file mode 100644
> > > index 000000000000..f52cd4458947
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/emulate-nested.c
> > > @@ -0,0 +1,197 @@
> > 
> > Looks like this line:
> > 
> > // SPDX-License-Identifier: GPL-2.0-only
> > 
> > is missing.
> 
> Indeed. I should check all the new files, as they are a bit... off.
> 
> > 
> > > +/*
> > > + * Copyright (C) 2016 - Linaro and Columbia University
> > > + * Author: Jintack Lim <jintack.lim@linaro.org>
> > > + */
> > > +
> > > +#include <linux/kvm.h>
> > > +#include <linux/kvm_host.h>
> > > +
> > > +#include <asm/kvm_emulate.h>
> > > +#include <asm/kvm_nested.h>
> > > +
> > > +#include "hyp/include/hyp/adjust_pc.h"
> > > +
> > > +#include "trace.h"
> > > +
> > > +static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
> > > +{
> > > +	u64 mode = spsr & PSR_MODE_MASK;
> > > +
> > > +	/*
> > > +	 * Possible causes for an Illegal Exception Return from EL2:
> > > +	 * - trying to return to EL3
> > > +	 * - trying to return to a 32bit EL
> > > +	 * - trying to return to EL1 with HCR_EL2.TGE set
> > > +	 */
> > > +	if (mode == PSR_MODE_EL3t || mode == PSR_MODE_EL3h ||
> > > +	    spsr & PSR_MODE32_BIT ||
> > 
> > I take it KVM will not allow a L1 hypervisor to run EL1 or EL0 in 32
> > bit mode?
> 
> No, that'd really be a distraction at this stage. I don't expect any
> HW supporting NV NV to support AArch32 at EL1, and if someone really
> needs EL0 support (the HW support actually exists), they'll have to
> revisit this.
> 
> >
> > > +	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
> > > +					   mode == PSR_MODE_EL1h))) {
> > 
> > I think these checks should also be added:
> > 
> > "A return where the value of the saved process state M[4] bit is 0,
> > indicating a return to AArch64 state, and one of the following is
> > true:
> > 
> > - The M[1] bit is 1.
> > - The M[3:0] bits are 0b0001.
> 
> Definitely should add these two, probably in the form of a switch
> enumerating all the possible exception levels rather than checking for
> discrete bits that are hard to reason about.
> 
> > - The Exception level being returned to is using AArch32 state, as
> >   programmed by the SCR_EL3.RW or HCR_EL2.RW bits, or as configured
> >   from reset."
> 
> That's already caught with the SPSR check above.

Hmm... I don't think so. The illegal condition, according to the snippet, should
be:

!(mode & PSR_MODE32_BIT) && !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_RW)

Or, perhaps better, KVM could add an HCR_EL2 accessor that treated the
HCR_EL2.RW bit as RA0/WI as per the architecture when the EL1 is not capable of
AArch32.  That would make the above situation impossible.

Thanks,
Alex

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
