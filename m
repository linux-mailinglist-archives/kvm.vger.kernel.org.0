Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435EB5F51E0
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 11:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJEJkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 05:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJEJkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 05:40:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96F66140DD
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 02:40:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F29B0113E;
        Wed,  5 Oct 2022 02:40:19 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5E5A3F67D;
        Wed,  5 Oct 2022 02:40:11 -0700 (PDT)
Date:   Wed, 5 Oct 2022 10:41:19 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        maz@kernel.org, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Message-ID: <Yz1RP/IkW6SYrJZo@monolith.localdoman>
References: <20220805004139.990531-1-ricarkol@google.com>
 <89c93f1e-6e78-f679-aecb-7e506fa0cea3@redhat.com>
 <YzxmHpV2rpfaUdWi@monolith.localdoman>
 <5b69f259-4a25-18eb-6c7c-4b59e1f81036@redhat.com>
 <Yz1MiE64ZEa7twtM@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yz1MiE64ZEa7twtM@monolith.localdoman>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Oct 05, 2022 at 10:21:12AM +0100, Alexandru Elisei wrote:
> Hi Eric,
> 
> On Tue, Oct 04, 2022 at 07:31:25PM +0200, Eric Auger wrote:
> > Hi Alexandru,
> > 
> > On 10/4/22 18:58, Alexandru Elisei wrote:
> > > Hi Eric,
> > >
> > > On Tue, Oct 04, 2022 at 06:20:23PM +0200, Eric Auger wrote:
> > >> Hi Ricardo, Marc,
> > >>
> > >> On 8/5/22 02:41, Ricardo Koller wrote:
> > >>> There are some tests that fail when running on bare metal (including a
> > >>> passthrough prototype).  There are three issues with the tests.  The
> > >>> first one is that there are some missing isb()'s between enabling event
> > >>> counting and the actual counting. This wasn't an issue on KVM as
> > >>> trapping on registers served as context synchronization events. The
> > >>> second issue is that some tests assume that registers reset to 0.  And
> > >>> finally, the third issue is that overflowing the low counter of a
> > >>> chained event sets the overflow flag in PMVOS and some tests fail by
> > >>> checking for it not being set.
> > >>>
> > >>> Addressed all comments from the previous version:
> > >>> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
> > >>> - adding missing isb() and fixed the commit message (Alexandru).
> > >>> - fixed wording of a report() check (Andrew).
> > >>>
> > >>> Thanks!
> > >>> Ricardo
> > >>>
> > >>> Ricardo Koller (3):
> > >>>   arm: pmu: Add missing isb()'s after sys register writing
> > >>>   arm: pmu: Reset the pmu registers before starting some tests
> > >>>   arm: pmu: Check for overflow in the low counter in chained counters
> > >>>     tests
> > >>>
> > >>>  arm/pmu.c | 56 ++++++++++++++++++++++++++++++++++++++-----------------
> > >>>  1 file changed, 39 insertions(+), 17 deletions(-)
> > >>>
> > >> While testing this series and the related '[PATCH 0/9] KVM: arm64: PMU:
> > >> Fixing chained events, and PMUv3p5 support' I noticed I have kvm unit
> > >> test failures on some machines. This does not seem related to those
> > >> series though since I was able to get them without. The failures happen
> > >> on Amberwing machine for instance with the pmu-chain-promotion.
> > >>
> > >> While further investigating I noticed there is a lot of variability on
> > >> the kvm unit test mem_access_loop() count. I can get the counter = 0x1F
> > >> on the first iteration and 0x96 on the subsequent ones for instance.
> > >> While running mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E) I was
> > >> expecting the counter to be close to 20. It is on some HW.
> > >>
> > >> [..]
> > >>
> > >> So I come to the actual question. Can we do any assumption on the
> > >> (virtual) PMU quality/precision? If not, the tests I originally wrote
> > >> are damned to fail on some HW (on some other they always pass) and I
> > >> need to make a decision wrt re-writing part of them, expecially those
> > >> which expect overflow after a given amount of ops. Otherwise, there is
> > >> either something wrong in the test (asm?) or in KVM PMU emulation.
> > >>
> > >> I tried to bisect because I did observe the same behavior on some older
> > >> kernels but the bisect was not successful as the issue does not happen
> > >> always.
> > >>
> > >> Thoughts?
> > > Looking at mem_access_loop(), the first thing that jumps out is the fact
> > > that is missing a DSB barrier. ISB affects only instructions, not memory
> > > accesses and without a DSB, the PE can reorder memory accesses however it
> > > sees fit.
> > Following your suggestion I added a dsh ish at the end of loop and
> > before disabling pmcr_el0 (I hope this is the place you were thinking
> > of) but unfortunately it does not seem to fix my issue.
> 
> Yes, DSB ISH after "b.gt 1b\n" and before the write to PMCR_EL0 that
> disables the PMU.
> 
> I think you also need a DSB ISH before the write to PMCR_EL0 that enables
> the PMU in the first instruction of the asm block. In your example, the
> MEM_ACCESS event count is higher than expected, and one explanation for the
> large disparity that I can think of is that previous memory accesses are
> reordered past the instruction that enables the PMU, which makes the PMU
> add these events to the total event count.
> 
> > >
> > > I also believe precise_instrs_loop() to be in the same situation, as the
> > > architecture doesn't guarantee that the cycle counter increments after
> > > every CPU cycle (ARM DDI 0487I.a, page D11-5246):
> > >
> > > "Although the architecture requires that direct reads of PMCCNTR_EL0 or
> > > PMCCNTR occur in program order, there is no requirement that the count
> > > increments between two such reads. Even when the counter is incrementing on
> > > every clock cycle, software might need check that the difference between
> > > two reads of the counter is nonzero."
> > OK
> > >
> > > There's also an entire section in ARM DDI 0487I.a dedicated to this, titled
> > > "A reasonable degree of inaccuracy" (page D11-5248). I'll post some
> > > snippets that I found interesting, but there are more examples and
> > > explanations to be found in that chapter.
> > 
> > yeah I saw that, hence my question about the reasonable disparity we can
> > expect from the HW/SW stack.
> > >
> > > "In exceptional circumstances, such as a change in Security state or other
> > > boundary condition, it is acceptable for the count to be inaccurate."
> > >
> > > PMCR writes are trapped by KVM. Is a change in exception level an
> > > "exception circumstance"? Could be, but couldn't find anything definitive.
> > > For example, the architecture allows an implementation to drop an event in
> > > the case of an interrupt:
> > >
> > > "However, dropping a single branch count as the result of a rare
> > > interaction with an interrupt is acceptable."
> > >
> > > So events could definitely be dropped because of an interrupt for the host.
> > >
> > > And there's also this:
> > >
> > > "The imprecision means that the counter might have counted an event around
> > > the time the counter was disabled, but does not allow the event to be
> > > observed as counted after the counter was disabled."
> > In our case there seems to be a huge discrepancy.
> 
> I agree. There is this about the MEM_ACCESS event in the Arm ARM:
> 
> "The counter counts each Memory-read operation or Memory-write operation
> that the PE makes."
> 
> As for what a Memory-read operation is (emphasis added by me):
> 
> "A memory-read operation might be due to:
> The result of an architecturally executed memory-reading instructions.
> The result of a Speculatively executed memory-reading instructions <- this
> is why the DSB ISH is needed before enabling the PMU.
> **A translation table walk**."
> 
> Those extra memory accesses might be caused by the table walker deciding to
> walk the tables, speculatively or not. Software has no control over the
> table walker (as long as it is enabled).

Please ignore this part, just noticed in the MEM_ACCESS event definition
that translation table walks are not counted.

Thanks,
Alex

> 
> Thanks,
> Alex
> 
> > >
> > > If you want my opinion, if it is necessary to count the number of events
> > > for a test instead, I would define a margin of error on the number of
> > > events counted. Or the test could be changed to check that at least one
> > > such event was observed.
> > I agree with you on the fact a reasonable margin must be observed and
> > the tests may need to be rewritten to account for the observed disparity
> > if considered "normal". Another way to proceed is to compute the
> > disparity before launching the main tests and if too big, skip the main
> > tests. Again on some HW, the counts are really 'as expected' and constant.
> > 
> > Thanks!
> > 
> > Eric
> > >
> > > Thanks,
> > > Alex
> > >
> > 
