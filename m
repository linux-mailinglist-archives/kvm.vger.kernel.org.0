Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EA764A2A7
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 14:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiLLN5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 08:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbiLLN4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 08:56:38 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCEF3140F1
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 05:56:37 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A5461FB;
        Mon, 12 Dec 2022 05:57:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 276243F71E;
        Mon, 12 Dec 2022 05:56:36 -0800 (PST)
Date:   Mon, 12 Dec 2022 13:56:33 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5czEQPdsaZPlSuB@monolith.localdoman>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5N0os7zL/BaMBa3@monolith.localdoman>
 <87fsdnfroe.wl-maz@kernel.org>
 <Y5XBo6s9JQVY79Wu@monolith.localdoman>
 <867cyxq9fl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cyxq9fl.wl-maz@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Dec 12, 2022 at 09:05:02AM +0000, Marc Zyngier wrote:
> Alex,
> 
> On Sun, 11 Dec 2022 11:40:39 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > A simple "hey, you're wrong here, the PMU extensions do not follow the
> > principles of the ID scheme for fields in ID registers" would have
> > sufficed.
> 
> This is what I did, and saved you the hassle of looking it up.

The comment was about how you went about it, not about proving someone
wrong. As expressive as it might be, I don't think that calling someone's
suggestion "ludicrous" from the position of authority associated with being
a maintainer is constructive; and can also be interpreted as a personal
attack (you used **your** suggestion, not **this** suggestion). I didn't
interpret it that way, just saying that it can be.

> 
> > Guess you never made a silly mistake ever, right?
> 
> It's not so much about making a silly mistake. I do that all the time.
> But it is about the way you state these things, and the weight that
> your reviews carry. You're a trusted reviewer, with a lot of
> experience, and posting with an @arm.com address: what you say in a
> public forum sticks. When you assert that the author is wrong, they
> will take it at face value.

This is how I stated things:

"Hm... in the Arm ARM it says that counters are 64-bit if PMUv3p5 is
implemented.  But it doesn't say anywhere that versions newer than p5 are
required to implement PMUv3p5." -> patently false, easily provable with the
Arm ARM and by logic (as you did). My entire argument was based on this, so
once this has been proven false, I would say that the rest of my argument
falls apart.

"For example, for PMUv3p7, it says that the feature is mandatory in Arm8.7
implementations. **My interpretation** of that is that it is not forbidden
for an implementer to cherry-pick this version on older versions of the
architecture where PMUv3p5 is not implemented." -> emphasis on the "my
interpretation"; also easy to prove false because PMUv3p5+ is required to
implement PMUv3p5, as per the architecture.

"**Maybe** the check should be pmu.version == ID_DFR0_PMU_V3_8_5, to match
the counter definitions in the architecture?" -> emphasis on the "maybe",
and the question mark at the end.

My intention wasn't to dictate something, my intention was to have a
conversation about the patch, with the mindset that I might be wrong. What
made you get the idea that I was asserting that the author is wrong? Where
by "asserting the author is wrong" I understand framing my comment in such
a way as to leave no room for further discussions. Or did you mean
something else by that?

Or, to put it another way, what about the way I stated things could have
been done better (other than not being wrong, obviously)?

> 
> > Otherwise, good job encouraging people to help review KVM/arm64 patches ;)
> 
> What is the worse: no review? or a review that spreads confusion?
> Think about it. I'm all for being nice, but I will call bullshit when

That wasn't about calling people out on their mistakes. I was saying that
the way you "call bullshit", as you put it, might be a put off for some
people. Call me naive, but I like to think that not everyone that comments
on a patch does it because they have to.

> I see it asserted by people with a certain level of authority.
> 
> And I've long made up my mind about the state of the KVM/arm64 review
> process -- reviews rarely come from people who have volunteered to do
> so, but instead from those who have either a vested interest in it, or
> an ulterior motive. Hey ho...

I genuinely don't know what to make of this. I can't even tell if it's
directed at me or not.

Thanks,
Alex
