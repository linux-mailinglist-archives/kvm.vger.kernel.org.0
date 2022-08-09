Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF6C58DA38
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiHIOWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 10:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiHIOWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 10:22:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FD8D12A84
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 07:22:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDBA823A;
        Tue,  9 Aug 2022 07:22:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDE7F3F5A1;
        Tue,  9 Aug 2022 07:22:12 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:22:57 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests RFC PATCH 19/19] arm/arm64: Rework the cache
 maintenance in asm_mmu_disable
Message-ID: <YvJtwWcKkcxLUVif@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-20-alexandru.elisei@arm.com>
 <3fba260d-bfca-14ea-7bdd-3e55f3d1e276@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fba260d-bfca-14ea-7bdd-3e55f3d1e276@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 02:53:34PM +0100, Nikos Nikoleris wrote:
> Hi Alex,
> 
> On 09/08/2022 10:15, Alexandru Elisei wrote:
> > asm_mmu_disable is overly ambitious and provably incorrect:
> > 
> > 1. It tries to clean and invalidate the data caches for the *entire*
> > memory, which is highly unnecessary, as it's very unlikely that a test
> > will write to the entire memory, and even more unlikely that a test will
> > modify the text section of the test image.
> > 
> 
> While it appears that we don't modify the text section, there is some
> loading happening before we start executing a test. Are you sure that the
> loader doesn't leave the memory dirty?

Yes, it's in the boot protocol for Linux [1]. I also mentioned this in the
commit message for the previous patch.

[1] https://elixir.bootlin.com/linux/v5.19/source/Documentation/arm64/booting.rst#L180

> 
> > 2. There is no corresponding dcache invalidate command for the entire
> > memory in asm_mmu_enable, leaving it up to the test that disabled the
> > MMU to do the cache maintenance in an asymmetrical fashion: only for
> > re-enabling the MMU, but not for disabling it.
> > 
> > 3. It's missing the DMB SY memory barrier to ensure that the dcache
> > maintenance is performed after the last store executed in program order
> > before calling asm_mmu_disable.
> > 
> 
> I am not sure why this is needed. In general, iiuc, a store to location x
> followed by a DC CVAC to x in program order don't need an barrier (see Arm
> ARM ARM DDI 0487G.b "Data cache maintenance instructions" at K11.5.1 and

Just a note, the latest public version is H.a.

K11.5.1 looks to me like it deals with ordering of the cache maintenance
operations with regards to memory accesses that are *after* the CMO in
program order, this patch is about memory accesses that are *before* the
CMO in program order.

> "Ordering and completion of data and instruction cache instructions" at
> D4-2656). It doesn't hurt to have it but I think it's unnecessary.

D4-2656 is about PAC, I assume you meant D4-2636 judging from the section
name (please correct me if I'm wrong):

"All data cache instructions, other than DC ZVA, that specify an address:
[..]
Can execute in any order relative to loads or stores that access any
address with the Device memory attribute, or with Normal memory with Inner
Non-cacheable attribute unless a DMB or DSB is executed between the
instructions."

Since the maintenance is performed with the MMU off, I think the DMB SY is
required as per the architecture.

I prefer to keep the maintenance after the MMU is disabled, to allow for
any kind of translation table setups that a test might conjure up (a test
in theory can create and install its own translation tables).

Thanks,
Alex

> 
> Thanks,
> 
> Nikos
> 
> > Fix all of the issues in one go, by doing the cache maintenance only for
> > the stack, as that is out of the control of the C code, and add the missing
> > memory barrier.
> > 
> > The code used to test that mmu_disable works correctly is similar to the
> > code used to test commit 410b3bf09e76 ("arm/arm64: Perform dcache clean
> > + invalidate after turning MMU off"), with extra cache maintenance
> > added:
> > 
> > +#include <alloc_page.h>
> > +#include <asm/cacheflush.h>
> > +#include <asm/mmu.h>
> >   int main(int argc, char **argv)
> >   {
> > +       int *x = alloc_page();
> > +       bool pass = true;
> > +       int i;
> > +
> > +       for  (i = 0; i < 1000000; i++) {
> > +               *x = 0x42;
> > +               dcache_clean_addr_poc((unsigned long)x);
> > +               mmu_disable();
> > +               if (*x != 0x42) {
> > +                       pass = false;
> > +                       break;
> > +               }
> > +               *x = 0x50;
> > +               /* Needed for the invalidation only. */
> > +               dcache_clean_inval_addr_poc((unsigned long)x);
> > +               mmu_enable(current_thread_info()->pgtable);
> > +               if (*x != 0x50) {
> > +                       pass = false;
> > +                       break;
> > +               }
> > +       }
> > +       report(pass, "MMU disable cache maintenance");
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >   arm/cstart.S   | 11 ++++++-----
> >   arm/cstart64.S | 11 +++++------
> >   2 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index fc7c558802f1..b27de44f30a6 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -242,11 +242,12 @@ asm_mmu_disable:
> >   	mcr	p15, 0, r0, c1, c0, 0
> >   	isb
> > -	ldr	r0, =__phys_offset
> > -	ldr	r0, [r0]
> > -	ldr	r1, =__phys_end
> > -	ldr	r1, [r1]
> > -	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> > +	dmb	sy
> > +	mov	r0, sp
> > +	lsr	r0, #THREAD_SHIFT
> > +	lsl	r0, #THREAD_SHIFT
> > +	add	r1, r0, #THREAD_SIZE
> > +	dcache_by_line_op dccmvac, sy, r0, r1, r3, r4
> >   	mov     pc, lr
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 1ce6b9e14d23..af4970775298 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -283,12 +283,11 @@ asm_mmu_disable:
> >   	msr	sctlr_el1, x0
> >   	isb
> > -	/* Clean + invalidate the entire memory */
> > -	adrp	x0, __phys_offset
> > -	ldr	x0, [x0, :lo12:__phys_offset]
> > -	adrp	x1, __phys_end
> > -	ldr	x1, [x1, :lo12:__phys_end]
> > -	dcache_by_line_op civac, sy, x0, x1, x2, x3
> > +	dmb	sy
> > +	mov	x9, sp
> > +	and	x9, x9, #THREAD_MASK
> > +	add	x10, x9, #THREAD_SIZE
> > +	dcache_by_line_op cvac, sy, x9, x10, x11, x12
> >   	ret
