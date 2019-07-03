Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31135E8CF
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGCQ1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:27:11 -0400
Received: from foss.arm.com ([217.140.110.172]:52062 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfGCQ1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:27:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF292344;
        Wed,  3 Jul 2019 09:27:09 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E05F3F718;
        Wed,  3 Jul 2019 09:27:09 -0700 (PDT)
Date:   Wed, 3 Jul 2019 17:27:07 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/59] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
Message-ID: <20190703162706.GV2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-5-marc.zyngier@arm.com>
 <20190624112851.GM2790@e103592.cambridge.arm.com>
 <01e61a51-5bf0-8943-6f68-7a5cea59f093@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01e61a51-5bf0-8943-6f68-7a5cea59f093@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 03, 2019 at 12:53:58PM +0100, Marc Zyngier wrote:
> On 24/06/2019 12:28, Dave Martin wrote:
> > On Fri, Jun 21, 2019 at 10:37:48AM +0100, Marc Zyngier wrote:
> >> From: Christoffer Dall <christoffer.dall@arm.com>
> >>
> >> Introduce the feature bit and a primitive that checks if the feature is
> >> set behind a static key check based on the cpus_have_const_cap check.
> >>
> >> Checking nested_virt_in_use() on systems without nested virt enabled
> >> should have neglgible overhead.
> >>
> >> We don't yet allow userspace to actually set this feature.
> >>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/include/asm/kvm_nested.h   |  9 +++++++++
> >>  arch/arm64/include/asm/kvm_nested.h | 13 +++++++++++++
> >>  arch/arm64/include/uapi/asm/kvm.h   |  1 +
> >>  3 files changed, 23 insertions(+)
> >>  create mode 100644 arch/arm/include/asm/kvm_nested.h
> >>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
> >>
> >> diff --git a/arch/arm/include/asm/kvm_nested.h b/arch/arm/include/asm/kvm_nested.h
> >> new file mode 100644
> >> index 000000000000..124ff6445f8f
> >> --- /dev/null
> >> +++ b/arch/arm/include/asm/kvm_nested.h
> >> @@ -0,0 +1,9 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef __ARM_KVM_NESTED_H
> >> +#define __ARM_KVM_NESTED_H
> >> +
> >> +#include <linux/kvm_host.h>
> >> +
> >> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu) { return false; }
> >> +
> >> +#endif /* __ARM_KVM_NESTED_H */
> >> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> >> new file mode 100644
> >> index 000000000000..8a3d121a0b42
> >> --- /dev/null
> >> +++ b/arch/arm64/include/asm/kvm_nested.h
> >> @@ -0,0 +1,13 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef __ARM64_KVM_NESTED_H
> >> +#define __ARM64_KVM_NESTED_H
> >> +
> >> +#include <linux/kvm_host.h>
> >> +
> >> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
> >> +{
> >> +	return cpus_have_const_cap(ARM64_HAS_NESTED_VIRT) &&
> >> +		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);
> >> +}
> >> +
> >> +#endif /* __ARM64_KVM_NESTED_H */
> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> index d819a3e8b552..563e2a8bae93 100644
> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> @@ -106,6 +106,7 @@ struct kvm_regs {
> >>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
> >>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
> >>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
> >> +#define KVM_ARM_VCPU_NESTED_VIRT	7 /* Support nested virtualization */
> > 
> > This seems weirdly named:
> > 
> > Isn't the feature we're exposing here really EL2?  In that case, the
> > feature the guest gets with this flag enabled is plain virtualisation,
> > possibly with the option to nest further.
> > 
> > Does the guest also get nested virt (i.e., recursively nested virt from
> > the host's PoV) as a side effect, or would require an explicit extra
> > flag?
> 
> So far, there is no extra flag to describe further nesting, and it
> directly comes from EL2 being emulated. I don't mind renaming this to
> KVM_ARM_VCPU_HAS_EL2, or something similar... Whether we want userspace
> to control the exposure of the nesting capability (i.e. EL2 with
> ARMv8.3-NV) is another question.

Agreed.

KVM_ARM_VCPU_HAS_EL2 seems a reasonable name to me.

If we have have an internal flag in vcpu_arch.flags we could call that
something different (i.e., keep the NESTED_VIRT naming) if it's natural
to do so.

Cheers
---Dave
