Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE450B12
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 14:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfFXMtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 08:49:03 -0400
Received: from foss.arm.com ([217.140.110.172]:49212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfFXMtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 08:49:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73E0C344;
        Mon, 24 Jun 2019 05:49:02 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 856513F718;
        Mon, 24 Jun 2019 05:49:01 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:48:59 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Julien Thierry <julien.thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 06/59] KVM: arm64: nv: Allow userspace to set
 PSR_MODE_EL2x
Message-ID: <20190624124859.GP2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-7-marc.zyngier@arm.com>
 <7f8a9d76-6087-b8d9-3571-074a08d08ec8@arm.com>
 <3a68e4e6-878f-7272-4e2d-8768680287fd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a68e4e6-878f-7272-4e2d-8768680287fd@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 21, 2019 at 02:50:08PM +0100, Marc Zyngier wrote:
> On 21/06/2019 14:24, Julien Thierry wrote:
> > 
> > 
> > On 21/06/2019 10:37, Marc Zyngier wrote:
> >> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>
> >> We were not allowing userspace to set a more privileged mode for the VCPU
> >> than EL1, but we should allow this when nested virtualization is enabled
> >> for the VCPU.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/guest.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> index 3ae2f82fca46..4c35b5d51e21 100644
> >> --- a/arch/arm64/kvm/guest.c
> >> +++ b/arch/arm64/kvm/guest.c
> >> @@ -37,6 +37,7 @@
> >>  #include <asm/kvm_emulate.h>
> >>  #include <asm/kvm_coproc.h>
> >>  #include <asm/kvm_host.h>
> >> +#include <asm/kvm_nested.h>
> >>  #include <asm/sigcontext.h>
> >>  
> >>  #include "trace.h"
> >> @@ -194,6 +195,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> >>  			if (vcpu_el1_is_32bit(vcpu))
> >>  				return -EINVAL;
> >>  			break;
> >> +		case PSR_MODE_EL2h:
> >> +		case PSR_MODE_EL2t:
> >> +			if (vcpu_el1_is_32bit(vcpu) || !nested_virt_in_use(vcpu))
> > 
> > This condition reads a bit weirdly. Why do we care about anything else
> > than !nested_virt_in_use() ?
> > 
> > If nested virt is not in use then obviously we return the error.
> > 
> > If nested virt is in use then why do we care about EL1? Or should this
> > test read as "highest_el_is_32bit" ?
> 
> There are multiple things at play here:
> 
> - MODE_EL2x is not a valid 32bit mode
> - The architecture forbids nested virt with 32bit EL2
> 
> The code above is a simplification of these two conditions. But
> certainly we can do a bit better, as kvm_reset_cpu() doesn't really
> check that we don't create a vcpu with both 32bit+NV. These two bits
> should really be exclusive.

This code is safe for now because KVM_VCPU_MAX_FEATURES <=
KVM_ARM_VCPU_NESTED_VIRT, right, i.e., nested_virt_in_use() cannot be
true?

This makes me a little uneasy, but I think that's paranoia talking: we
want bisectably, but no sane person should ship with just half of this
series.  So I guess this is fine.

We could stick something like

	if (WARN_ON(...))
		return false;

in nested_virt_in_use() and then remove it in the final patch, but it's
probably overkill.

Cheers
---Dave
