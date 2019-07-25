Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856C574E2E
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 14:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbfGYMdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 08:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbfGYMdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 08:33:49 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB266330265;
        Thu, 25 Jul 2019 12:33:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20C8160606;
        Thu, 25 Jul 2019 12:33:46 +0000 (UTC)
Date:   Thu, 25 Jul 2019 14:33:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvm-unit-tests v2] arm: Add PL031 test
Message-ID: <20190725123344.4lmeopzyl4jdnsp7@kamzik.brq.redhat.com>
References: <20190712091938.492-1-graf@amazon.com>
 <20190715164235.z2xar7nqi5guqfuf@kamzik.brq.redhat.com>
 <02a38777-3ec0-0354-8d49-d8ce337e5660@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02a38777-3ec0-0354-8d49-d8ce337e5660@amazon.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 25 Jul 2019 12:33:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 02:12:19PM +0200, Alexander Graf wrote:
> 
> 
> On 15.07.19 18:42, Andrew Jones wrote:
> > On Fri, Jul 12, 2019 at 11:19:38AM +0200, Alexander Graf wrote:
> > > This patch adds a unit test for the PL031 RTC that is used in the virt machine.
> > > It just pokes basic functionality. I've mostly written it to familiarize myself
> > > with the device, but I suppose having the test around does not hurt, as it also
> > > exercises the GIC SPI interrupt path.
> > > 
> > > Signed-off-by: Alexander Graf <graf@amazon.com>
> > > 
> > > ---
> > > 
> > > v1 -> v2:
> > > 
> > >    - Use FDT to find base, irq and existence
> > >    - Put isb after timer read
> > >    - Use dist_base for gicv3
> > > ---
> > >   arm/Makefile.common |   1 +
> > >   arm/pl031.c         | 265 ++++++++++++++++++++++++++++++++++++++++++++
> > >   lib/arm/asm/gic.h   |   1 +
> > >   3 files changed, 267 insertions(+)
> > >   create mode 100644 arm/pl031.c
> > > 
> > > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > > index f0c4b5d..b8988f2 100644
> > > --- a/arm/Makefile.common
> > > +++ b/arm/Makefile.common
> > > @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
> > >   tests-common += $(TEST_DIR)/gic.flat
> > >   tests-common += $(TEST_DIR)/psci.flat
> > >   tests-common += $(TEST_DIR)/sieve.flat
> > > +tests-common += $(TEST_DIR)/pl031.flat
> > 
> > Makefile.common is for both arm32 and arm64, but this code is only
> > compilable on arm64. As there's no reason for it to be arm64 only,
> > then ideally we'd modify the code to allow compiling and running
> > on both, but otherwise we need to move this to Makefile.arm64.
> 
> D'oh. Sorry, I completely missed that bit. Of course we want to test on
> 32bit ARM as well! I'll fix it up :).
> 
> 
> [...]
> 
> > > +static int rtc_fdt_init(void)
> > > +{
> > > +	const struct fdt_property *prop;
> > > +	const void *fdt = dt_fdt();
> > > +	int node, len;
> > > +	u32 *data;
> > > +
> > > +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
> > > +	if (node < 0)
> > > +		return -1;
> > > +
> > > +	prop = fdt_get_property(fdt, node, "interrupts", &len);
> > > +	assert(prop && len == (3 * sizeof(u32)));
> > > +	data = (u32 *)prop->data;
> > > +	assert(data[0] == 0); /* SPI */
> > > +	pl031_irq = SPI(fdt32_to_cpu(data[1]));
> > 
> > Nit: Ideally we'd add some more devicetree API to get interrupts. With
> > that, and the existing devicetree API, we could remove all low-level fdt
> > related code in this function.
> 
> Well, we probably want some really high level fdt API that can traverse reg
> properly to map bus regs into physical addresses. As long as we don't have
> all that magic,

We do have much of that magic already. Skim through lib/devicetree.h to
see what's available.

> I see little point in inventing anything that looks more
> sophisticated but doesn't actually take the difficult problems into account
> :).

Well, for this case, the "interrupts" decoding isn't difficult and could
be shared among other devices if we added it to devicetree.c. And the
reg decoding below to get the base address is already supported by the
devicetree API.

All that said, it's just a nit that I won't insist on though, because it's
hard enough to get unit test contributors without asking that they also
contribute to the framework.

> 
> > 
> > > +
> > > +	prop = fdt_get_property(fdt, node, "reg", &len);
> > > +	assert(prop && len == (2 * sizeof(u64)));
> > > +	data = (u32 *)prop->data;
> > > +	pl031 = (void*)((ulong)fdt32_to_cpu(data[0]) << 32 | fdt32_to_cpu(data[1]));
> > 
> > This works because we currently ID map all the physical memory. I usually
> > try to remember to use an ioremap in these cases anyway though.
> 
> Great idea - it allows me to get rid of a bit of casting too.
>

Thanks,
drew
