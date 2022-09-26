Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC95EAC3A
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiIZQPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiIZQPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:15:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 863983DF3D
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 08:03:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9A6F1042;
        Mon, 26 Sep 2022 08:03:49 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B42D93F66F;
        Mon, 26 Sep 2022 08:03:41 -0700 (PDT)
Date:   Mon, 26 Sep 2022 16:04:36 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <YzG/ZPLRsH4qwfnJ@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
 <20220920084553.734jvkqpognzgfpr@kamzik>
 <Yym+MOMK68K7abiQ@e121798.cambridge.arm.com>
 <20220920145952.fnftt2v46daigtdt@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220920145952.fnftt2v46daigtdt@kamzik>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 04:59:52PM +0200, Andrew Jones wrote:
> On Tue, Sep 20, 2022 at 02:20:48PM +0100, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Tue, Sep 20, 2022 at 10:45:53AM +0200, Andrew Jones wrote:
> > > On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> > > > With powerpc moving the page allocator, there are no architectures left
> > > > which use the physical allocator after the boot setup:  arm, arm64,
> > > > s390x and powerpc drain the physical allocator to initialize the page
> > > > allocator; and x86 calls setup_vm() to drain the allocator for each of
> > > > the tests that allocate memory.
> > > 
> > > Please put the motivation for this change in the commit message. I looked
> > > ahead at the next patch to find it, but I'm not sure I agree with it. We
> > > should be able to keep the locking even when used early, since we probably
> > > need our locking to be something we can use early elsewhere anyway.
> > 
> > You are correct, the commit message doesn't explain why locking is removed,
> > which makes the commit confusing. I will try to do a better job for the
> > next iteration (if we decide to keep this patch).
> > 
> > I removed locking because the physical allocator by the end of the series
> > will end up being used only by arm64 to create the idmap, which is done on
> 
> If only arm, and no unit tests, needs the phys allocator, then it can be
> integrated with whatever arm is using it for and removed from the general
> lib.

I kept the allocator in lib because I thought that RISC-V might have an use
for it. Since it's a RISC architecture, I was thinking that it also might
require software cache management around enabling/disabling the MMU. But in
the end it's up to you, it would be easy to move the physical allocator to
lib/arm if you think that is best.

> 
> > the boot CPU and with the MMU off. After that, the translation table
> > allocator functions will use the page allocator, which can be used
> > concurrently.
> > 
> > Looking at the spinlock implementation, spin_lock() doesn't protect from
> > the concurrent accesses when the MMU is disabled (lock->v is
> > unconditionally set to 1). Which means that spin_lock() does not work (in
> > the sense that it doesn't protect against concurrent accesses) on the boot
> > path, which doesn't need a spinlock anyway, because no secondaries are
> > online secondaries. It also means that spinlocks don't work when
> > AUXINFO_MMU_OFF is set. So for the purpose of simplicity I preferred to
> > drop it entirely.
> 
> If other architectures or unit tests have / could have uses for the
> phys allocator then we should either document that it doesn't have
> locks or keep the locks, and arm will just know that they don't work,
> but also that they don't need to for its purposes.

I will write a comment explaining the baked in assumptions for the
allocator.

> 
> Finally, if we drop the locks and arm doesn't have any other places where
> we use locks without the MMU enabled, then we can change the lock
> implementation to not have the no-mmu fallback - maybe by switching to the
> generic implementation as the other architectures have done.

The architecture mandates that load-acquire/store-release instructions are
supported only on Normal memory (to be more precise, Inner Shareable, Inner
Write-Back, Outer Write-Back Normal memory with Read allocation hints and
Write allocation hints and not transient and Outer Shareable, Inner
Write-Back, Outer Write-Back Normal memory with Read allocation hints and
Write allocation hints and not transient, ARM DDI 0487H.a, pages B2-211 and
B2-212).

If the AUXINFO_MMU_OFF flag is set, kvm-unit-tests doesn't enable the MMU
at boot, which means that all tests can be run with the MMU disabled. In
this case, all memory is Device-nGnRnE (instead of Normal). By using an
implementation that doesn't take into account that spin_lock() might be
called with the MMU disabled, kvm-unit-tests will end up using exclusive
access instructions on memory which doesn't support it. This can have
various effects, all rather unpleasant, like causing an external abort or
treating the exclusive access instruction as a NOP (ARM DDI 0487H.a, page
B2-212).

Tested this on my rockpro64 board, kvm-unit-tests built from current
master, with the mmu_disabled() path removed from spin_lock() (and
AUXINFO_MMU_OFF flag set), all tests hang indefinitely, that's because
phys_alloc_init() uses a spinlock. It is conceivable that we could rework
the setup code to remove the usage of spinlocks, but it's still the matter
of tests needing one for synchronization. It's also the matter of the uart
needing one for puts. And report. And probably other places.

Out of curiosity, without setting the AUXINFO_MMU_OFF flag, I tried using
the generic version of the spinlock (I assume you mean the one from
lib/asm-generic/spinlock.h, changed lib/arm64/asm/spinlock.h to include the
above header), selftest-setup hangs without displaying anything before
phys_alloc_init(), I have no idea why that is.

In the current implementation, when AUXINFO_MMU_OFF is set, tests that
actually use more than one thread might end up being incorrect some of the
time because spin_lock() doesn't protect against concurrent accesses.
That's pretty bad, but I think the alternative off all tests hanging
indefinitely is worse.

In my opinion, the current spinlock implementation is incorrect when the
MMU is disabled, but using a generic implementation is worse. I guess
another thing to put on the TODO list.  Arm ARM recommends Lamport’s Bakery
algorithm for mutual exclusion and we could try to implement that for the
MMU disabled case, but I don't see much interest at the moment in running
tests with the MMU disabled.

Thanks,
Alex

> 
> Thanks,
> drew
