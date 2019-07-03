Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AC65E8B1
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 18:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfGCQYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 12:24:16 -0400
Received: from foss.arm.com ([217.140.110.172]:51962 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfGCQYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 12:24:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF569344;
        Wed,  3 Jul 2019 09:24:15 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0EFF3F718;
        Wed,  3 Jul 2019 09:24:14 -0700 (PDT)
Date:   Wed, 3 Jul 2019 17:24:12 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/59] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
Message-ID: <20190703162412.GU2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-5-marc.zyngier@arm.com>
 <20190624114329.GO2790@e103592.cambridge.arm.com>
 <5bd65cc0-89a1-0849-2041-b6016d58e4f2@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bd65cc0-89a1-0849-2041-b6016d58e4f2@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 03, 2019 at 12:56:51PM +0100, Marc Zyngier wrote:
> On 24/06/2019 12:43, Dave Martin wrote:
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
> > 
> > [...]
> > 
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
> > 
> > Also, is it worth having a vcpu->arch.flags flag for this, similarly to
> > SVE and ptrauth?
> 
> What would we expose through this flag?

Nothing new, put possibly more efficient to access.

AFAIK, test_bit() always results in an explicit load, whereas
vcpu->arch.flags is just a variable, which we already access on some hot
paths.  So the compiler can read it once and cache it, with a bit of
luck.

For flags that are fixed after vcpu init, or flags that are only read/
written by the vcpu thread itself, this should work fine.

Cheers
---Dave
