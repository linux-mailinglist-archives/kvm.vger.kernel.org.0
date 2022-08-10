Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821BF58E911
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiHJIv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 04:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiHJIv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 04:51:27 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 375FD5A3ED
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 01:51:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9A311FB;
        Wed, 10 Aug 2022 01:51:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C099B3F70D;
        Wed, 10 Aug 2022 01:51:24 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:52:02 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests RFC PATCH 19/19] arm/arm64: Rework the cache
 maintenance in asm_mmu_disable
Message-ID: <YvNxsvtQ/4D/wswX@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-20-alexandru.elisei@arm.com>
 <3fba260d-bfca-14ea-7bdd-3e55f3d1e276@arm.com>
 <YvJtwWcKkcxLUVif@monolith.localdoman>
 <3ff46ed4-4c83-2f00-90b0-4407b9c331d5@arm.com>
 <YvKQ+VfMHR1XytJK@monolith.localdoman>
 <9e9f4b5d-7ba9-e76c-14ec-0efe6c6b9411@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e9f4b5d-7ba9-e76c-14ec-0efe6c6b9411@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

Just want to make this clear, this patch should be read in conjuction  with
the previous patch, patch #18 ("arm/arm64: Perform dcache maintenance at
boot"), which explains what dcache maintenance operations are needed for
writes when the MMU is disabled. Without it, this patch might look very
confusing.

On Tue, Aug 09, 2022 at 08:48:40PM +0100, Nikos Nikoleris wrote:
> On 09/08/2022 17:53, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Tue, Aug 09, 2022 at 04:53:18PM +0100, Nikos Nikoleris wrote:
> > > On 09/08/2022 15:22, Alexandru Elisei wrote:
> > > > On Tue, Aug 09, 2022 at 02:53:34PM +0100, Nikos Nikoleris wrote:
> > > > > Hi Alex,
> > > > > 
> > > > > On 09/08/2022 10:15, Alexandru Elisei wrote:
> > > > > > asm_mmu_disable is overly ambitious and provably incorrect:
> > > > > > 
> > > > > > 1. It tries to clean and invalidate the data caches for the *entire*
> > > > > > memory, which is highly unnecessary, as it's very unlikely that a test
> > > > > > will write to the entire memory, and even more unlikely that a test will
> > > > > > modify the text section of the test image.
> > > > > > 
> > > > > 
> > > > > While it appears that we don't modify the text section, there is some
> > > > > loading happening before we start executing a test. Are you sure that the
> > > > > loader doesn't leave the memory dirty?
> > > > 
> > > > Yes, it's in the boot protocol for Linux [1]. I also mentioned this in the
> > > > commit message for the previous patch.
> > > > 
> > > > [1] https://elixir.bootlin.com/linux/v5.19/source/Documentation/arm64/booting.rst#L180
> > > > 
> > > 
> > > I see, thanks!
> > > 
> > > Right now {asm_,}mmu_disable() is not used anywhere. So this patch will
> > > introduce the assumption that mmu_disable() can be safely called only if we
> > > didn't perform any writes, outside the test's stack, doesn't it?
> > 
> > This patch introduces the assumption that the code that disables the MMU
> > will do the necessary cache maintenance. I should reword the commit
> > message to make it clearer.
> > 
> > > 
> > > When we add support for EFI, there is a lot happening from efi_main() until
> > > we get to the point where we can mmu_disable(), cleaning just the (new)
> > > stack of the test seems risky.
> > 
> > Well, that's an understatement, the code disabling the MMU definitly needs
> > to do the necessary cache maintenance! asm_mmu_disable() is not a silver
> > bullet that removes the need to do any cache maintenace, the previous patch
> > explains what needs to be done and why. If you're looking for inspiration
> > about what maintenance to be done for UEFI, I suggest you look there. Or
> > even better, you can reuse that code, which I think is the better approach
> > for the UEFI series going forward, but that's a discussion for the UEFI
> > thread.
> > 
> 
> I would argue that asm_mmu_disable() was "a silver bullet" and your patch is

This commit message explains why asm_mmu_disable cannot be a silver bullet
(reason number 2).

> changing it. How do you choose what is reasonable for asm_mmu_disable to
> clean? Why should it clean the stack?

I explained in this commit message what it should clean the stack (the
second to last paragrah).

As for deciding what's reasonable, the more memory the environment has, the
longer it will take to clean it. Tried it with 3GB of memory,
asm_mmu_disable() takes about 1 second, and it should scale linearly with
the memory size. I find that to be a poor user experience, I don't want the
user to wait for several seconds if not minutes on servers with a large
memory pool, especially since it's totally unnecessary and can be avoided
with a few simple rules: want to read something with MMU off, do a dcache
clean to PoC; want to write something with the MMU off, do a dcache inval
to PoC before the write; want to read with the MMU on something that was
written with the MMU off, do a dcache inval to PoC before the read. That's
just how it is on arm64, and has been this way since the architecture was
created. And if you're wondering why kvm-unit-tests doesn't do it in the
setup code, the previous patch explains why.

So, to summarize:

- cleaning the entire memory in asm_mmu_disable is not enough to ensure
correctness if the MMU is ever re-enabled.
- cleaning the entire memory can take a long time.

In conclusion, it's better that asm_mmu_disable doesn't clean the entire
memory.

> 
> > > 
> > > > > 
> > > > > > 2. There is no corresponding dcache invalidate command for the entire
> > > > > > memory in asm_mmu_enable, leaving it up to the test that disabled the
> > > > > > MMU to do the cache maintenance in an asymmetrical fashion: only for
> > > > > > re-enabling the MMU, but not for disabling it.
> > > > > > 
> > > > > > 3. It's missing the DMB SY memory barrier to ensure that the dcache
> > > > > > maintenance is performed after the last store executed in program order
> > > > > > before calling asm_mmu_disable.
> > > > > > 
> > > > > 
> > > > > I am not sure why this is needed. In general, iiuc, a store to location x
> > > > > followed by a DC CVAC to x in program order don't need an barrier (see Arm
> > > > > ARM ARM DDI 0487G.b "Data cache maintenance instructions" at K11.5.1 and
> > > > 
> > > > Just a note, the latest public version is H.a.
> > > > 
> > > > K11.5.1 looks to me like it deals with ordering of the cache maintenance
> > > > operations with regards to memory accesses that are *after* the CMO in
> > > > program order, this patch is about memory accesses that are *before* the
> > > > CMO in program order.
> > > > 
> > > 
> > > The AArch64 example in K11.5.1 has a memory instruction before and after the
> > > CMO:
> > > 
> > > STR W5, [X1]
> > > DC CVAC, X1
> > > DMB ISH
> > > STR W0, [X4]
> > > 
> > > The first store and the DC CVAC access the same cache line and there is no
> > > need for a memory barrier in between. The second store is assumed to be to a
> > > different location and that's why we need a barrier to order it with respect
> > > to the DC CVAC.
> > 
> > It's explained why the DMB is not necessary in the section that you've
> > referenced. I'll reproduce the paragraph:
> > 
> > "All data cache instructions, other than DC ZVA, that specify an address:
> > 
> > Execute in program order relative to loads or stores that have all of the
> > following properties:
> > 
> > —Access an address in Normal memory with either Inner Write Through or
> > Inner Write Back attributes within the same cache line of minimum size, as
> > indicated by CTR_EL0.DMinLine.
> > 
> > —Use an address with the same cacheability attributes as the address passed
> > to the data cache instruction."
> > 
> > Both the store and the dcache clean access the same cache line, indexed by
> > the adress in register X1. Does that make sense to you?
> > 
> > > 
> > > > > "Ordering and completion of data and instruction cache instructions" at
> > > > > D4-2656). It doesn't hurt to have it but I think it's unnecessary.
> > > > 
> > > > D4-2656 is about PAC, I assume you meant D4-2636 judging from the section
> > > > name (please correct me if I'm wrong): >
> > > > "All data cache instructions, other than DC ZVA, that specify an address:
> > > > [..]
> > > > Can execute in any order relative to loads or stores that access any
> > > > address with the Device memory attribute, or with Normal memory with Inner
> > > > Non-cacheable attribute unless a DMB or DSB is executed between the
> > > > instructions."
> > > > 
> > > > Since the maintenance is performed with the MMU off, I think the DMB SY is
> > > > required as per the architecture.
> > > > 
> > > > I prefer to keep the maintenance after the MMU is disabled, to allow for
> > > > any kind of translation table setups that a test might conjure up (a test
> > > > in theory can create and install its own translation tables).
> > > > 
> > > 
> > > Right, so between the stores and the DC CVAC, we've switched the MMU off, in
> > > which case the DMB SY might be necessary. I was missing this part.
> >                         ^^^^^^^^^^^^^^^^^^^
> > 		       might be necessary or might be **unnecessary**?
> > 
> > I would say that it's definitely unecessary according to the
> > architecture, not "might be".
> > 
> 
> Well you had successfully convinced me that since we're switching the MMU
> off, there needs to be a barrier to ensure that the dc cvac is ordered with
> respect to prior stores. Switching the MMU off means that stores could be
> executed with different memory attributes (e.g., Normal, Inner-Shareable,
> Writeback) than the DC CVAC (Device-nGnRnE). Some type of barrier might be
> needed. This is what your patch is doing.

Exactly! I got myself confused, and wrote "unnecessary" when I meant
"necessary". So the above paragraph should read:

"I would say that it's definitely **necessary** according to the
architecture, not "might be".

Sorry for the confusion :(

> 
> > > 
> > > The benefits of this design choice (switch the MMU off then clean data) are
> > > still unclear to me. This patch is modifying the CMO operation to perform
> > > only a clean. Why can't we clean the data cache before we switch off the MMU
> > > and use the same translation we used to write to it.
> > 
> > What do you mean by "translation"? Same VA to PA mapping? Or same address
> > attributes? If it's the latter, the architecture is pretty clear that this
> > is correct and expected.
> 
> Both.
> 
> > 
> > If it's the VA to PA mapping, asm_mmu_disable is called with an identify
> > mapped stack, otherwise following the ret at the end of the function,
> > asm_mmu_disable would not return to the calling function (when the MMU is
> > disabled, all addresses are flat mapped, and x30/lr will point to some
> > bogus address). mmu_disable() even has an assert to check that the stack is
> > identify mapped.
> > 
> > So I really do think that the order of the operations is correct. Unless
> > you can prove otherwise.
> > 
> > Why is it so important to you that the dcache is cleaned with the MMU on?
> > It's correct either way, so I'm interested to know why you are so keen on
> > doing it with the MMU enabled. I've already told you my reason for doing it
> > with the MMU disabled, I'm waiting to hear yours.
> 
> Sorry, maybe I am missing something. As far as I remember, your argument was
> that invalidating the cache before switching the MMU off was pointless, for
> Normal Memory any kind of speculation might result in fetching data to the
> cache. I agree. But this patch changes the CMO we use and it doesn't

Yeah, that was with the old implementation. The old implementation was
incorrect, because clean cache lines can still be allocated when
kvm-unit-tests is running with the MMU disabled by higher level software
(which is running with the MMU on), so you also need to do invalidate after
the last write with the MMU off (to be 100% correct, before the first read
with the MMU on; this is explained in the previous patch, and in point
number 2 in this commit message; also, if you're wondering where's the
corresponding invalidation, it's in asm_mmu_enable, added in the previous
patch).

> invalidate any more. What was the argument for cleaning the cache after
> switching the MMU off?

So there's no confusion about the DMB SY being needed. And I can come up
with another: it's possibly faster, because the address if flat mapped and
doesn't have to be translated using the translation tables (the dcaches are
physically indexed) - not really important, but hey, it's a reason. Yes,
they're both very weak, that's why I'm waiting to be convinced otherwise.

Why did you want the cache maintenance to be done with the MMU enabled?

Thanks,
Alex

> 
> I am happy either way, I am just trying to understand :)
> 
> Thanks,
> 
> Nikos
> 
> > 
> > Thanks,
> > Alex
> > 
> > > 
> > > Thanks,
> > > 
> > > Nikos
> > > 
> > > > Thanks,
> > > > Alex
> > > > 
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > Nikos
> > > > > 
> > > > > > Fix all of the issues in one go, by doing the cache maintenance only for
> > > > > > the stack, as that is out of the control of the C code, and add the missing
> > > > > > memory barrier.
> > > > > > 
> > > > > > The code used to test that mmu_disable works correctly is similar to the
> > > > > > code used to test commit 410b3bf09e76 ("arm/arm64: Perform dcache clean
> > > > > > + invalidate after turning MMU off"), with extra cache maintenance
> > > > > > added:
> > > > > > 
> > > > > > +#include <alloc_page.h>
> > > > > > +#include <asm/cacheflush.h>
> > > > > > +#include <asm/mmu.h>
> > > > > >     int main(int argc, char **argv)
> > > > > >     {
> > > > > > +       int *x = alloc_page();
> > > > > > +       bool pass = true;
> > > > > > +       int i;
> > > > > > +
> > > > > > +       for  (i = 0; i < 1000000; i++) {
> > > > > > +               *x = 0x42;
> > > > > > +               dcache_clean_addr_poc((unsigned long)x);
> > > > > > +               mmu_disable();
> > > > > > +               if (*x != 0x42) {
> > > > > > +                       pass = false;
> > > > > > +                       break;
> > > > > > +               }
> > > > > > +               *x = 0x50;
> > > > > > +               /* Needed for the invalidation only. */
> > > > > > +               dcache_clean_inval_addr_poc((unsigned long)x);
> > > > > > +               mmu_enable(current_thread_info()->pgtable);
> > > > > > +               if (*x != 0x50) {
> > > > > > +                       pass = false;
> > > > > > +                       break;
> > > > > > +               }
> > > > > > +       }
> > > > > > +       report(pass, "MMU disable cache maintenance");
> > > > > > 
> > > > > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > > > > > ---
> > > > > >     arm/cstart.S   | 11 ++++++-----
> > > > > >     arm/cstart64.S | 11 +++++------
> > > > > >     2 files changed, 11 insertions(+), 11 deletions(-)
> > > > > > 
> > > > > > diff --git a/arm/cstart.S b/arm/cstart.S
> > > > > > index fc7c558802f1..b27de44f30a6 100644
> > > > > > --- a/arm/cstart.S
> > > > > > +++ b/arm/cstart.S
> > > > > > @@ -242,11 +242,12 @@ asm_mmu_disable:
> > > > > >     	mcr	p15, 0, r0, c1, c0, 0
> > > > > >     	isb
> > > > > > -	ldr	r0, =__phys_offset
> > > > > > -	ldr	r0, [r0]
> > > > > > -	ldr	r1, =__phys_end
> > > > > > -	ldr	r1, [r1]
> > > > > > -	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> > > > > > +	dmb	sy
> > > > > > +	mov	r0, sp
> > > > > > +	lsr	r0, #THREAD_SHIFT
> > > > > > +	lsl	r0, #THREAD_SHIFT
> > > > > > +	add	r1, r0, #THREAD_SIZE
> > > > > > +	dcache_by_line_op dccmvac, sy, r0, r1, r3, r4
> > > > > >     	mov     pc, lr
> > > > > > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > > > > > index 1ce6b9e14d23..af4970775298 100644
> > > > > > --- a/arm/cstart64.S
> > > > > > +++ b/arm/cstart64.S
> > > > > > @@ -283,12 +283,11 @@ asm_mmu_disable:
> > > > > >     	msr	sctlr_el1, x0
> > > > > >     	isb
> > > > > > -	/* Clean + invalidate the entire memory */
> > > > > > -	adrp	x0, __phys_offset
> > > > > > -	ldr	x0, [x0, :lo12:__phys_offset]
> > > > > > -	adrp	x1, __phys_end
> > > > > > -	ldr	x1, [x1, :lo12:__phys_end]
> > > > > > -	dcache_by_line_op civac, sy, x0, x1, x2, x3
> > > > > > +	dmb	sy
> > > > > > +	mov	x9, sp
> > > > > > +	and	x9, x9, #THREAD_MASK
> > > > > > +	add	x10, x9, #THREAD_SIZE
> > > > > > +	dcache_by_line_op cvac, sy, x9, x10, x11, x12
> > > > > >     	ret
