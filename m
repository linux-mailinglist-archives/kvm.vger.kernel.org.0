Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474DF6115E0
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 17:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiJ1PbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 11:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiJ1PbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 11:31:12 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224B81C73CB
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 08:31:10 -0700 (PDT)
Date:   Fri, 28 Oct 2022 17:31:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666971068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mKCuPt/8IWceQBTjesPE2RI/v342KHoVYNbvb2oGIP8=;
        b=cuKEiP9Bg1x9GoVMbysf+C4/1aQCs1sFDPgLKeGi1NcRcVmD1tizMDcG4TCF2SodD0+zks
        0IHvBXJOV1lpsQirhekOgTB/NZ+SS2OflLj+ppq03FQectutagyp4FGQ9NPMhw6C0g1t6K
        enOBU6s4b7+eDXJ6Hl+hiUMtz8U15yY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <20221028153107.ul5uexzwuwefes6a@kamzik>
References: <20220811185210.234711-1-ricarkol@google.com>
 <20221028114041.5symayccvdgkqaor@kamzik>
 <86fsf8dmap.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fsf8dmap.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28, 2022 at 04:01:50PM +0100, Marc Zyngier wrote:
> Hi Drew,
> 
> On Fri, 28 Oct 2022 12:40:41 +0100,
> Andrew Jones <andrew.jones@linux.dev> wrote:
> > 
> > On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
> > > There are some tests that fail when running on bare metal (including a
> > > passthrough prototype).  There are three issues with the tests.  The
> > > first one is that there are some missing isb()'s between enabling event
> > > counting and the actual counting. This wasn't an issue on KVM as
> > > trapping on registers served as context synchronization events. The
> > > second issue is that some tests assume that registers reset to 0.  And
> > > finally, the third issue is that overflowing the low counter of a
> > > chained event sets the overflow flag in PMVOS and some tests fail by
> > > checking for it not being set.
> > > 
> > > Addressed all comments from the previous version:
> > > https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> > > - add pmu_reset() for 32-bit arm [Andrew]
> > > - collect r-b from Alexandru
> > > 
> > > Thanks!
> > > Ricardo
> > > 
> > > Ricardo Koller (4):
> > >   arm: pmu: Add missing isb()'s after sys register writing
> > >   arm: pmu: Add reset_pmu() for 32-bit arm
> > >   arm: pmu: Reset the pmu registers before starting some tests
> > >   arm: pmu: Check for overflow in the low counter in chained counters
> > >     tests
> > > 
> > >  arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 55 insertions(+), 17 deletions(-)
> > >
> > 
> > Hi all,
> > 
> > Please refresh my memory. Does this series work on current platforms? Or
> > was it introducing new test failures which may be in the test, as opposed
> > to KVM? If they work on most platforms, but not on every platform, then
> > have we identified what triggers them to fail and whether that should be
> > fixed or just worked-around? I'm sorry I still can't help out with the
> > testing as I haven't yet had time to setup the Rpi that Mark Rutland gave
> > me in Dublin.
> 
> This series does show that KVM is buggy, and I have patches out to fix
> it [1]. The patches should work on anything, really.
> 
> > I know this series has been rotting on arm/queue for months, so I'll be
> > happy to merge it if the consensus is to do so. I can also drop it, or
> > some of the patches, if that's the consensus.
> 
> I'd be very happy to see these patches being merged.

Thanks for the information, Marc. I've gone ahead and merged the tests.
What's the worst than can happen :-)  Anyway, I agree that when the tests
start failing in CIs, then they're doing their job. If your pending series
can't be applied right away, then the CIs can likely be taught to
temporarily ignore the known failures.

Thanks,
drew

> 
> Thanks,
> 
> 	M.
> 
> [1] https://lore.kernel.org/r/20221028105402.2030192-1-maz@kernel.org
> 
> -- 
> Without deviation from the norm, progress is not possible.
