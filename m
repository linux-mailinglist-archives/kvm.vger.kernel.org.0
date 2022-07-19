Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAC7579864
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 13:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbiGSL0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 07:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiGSL02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 07:26:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D1D713F9B
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 04:26:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35C02153B;
        Tue, 19 Jul 2022 04:26:27 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 480323F766;
        Tue, 19 Jul 2022 04:26:25 -0700 (PDT)
Date:   Tue, 19 Jul 2022 12:26:54 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YtaU/oSBWaBhjKYP@monolith.localdoman>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
 <YtWMXYyrEvZDFrAb@monolith.localdoman>
 <YtWc7YbR2d9uEZmX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWc7YbR2d9uEZmX@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Jul 18, 2022 at 10:48:29AM -0700, Ricardo Koller wrote:
> On Mon, Jul 18, 2022 at 05:38:23PM +0100, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, Jul 18, 2022 at 08:49:08AM -0700, Ricardo Koller wrote:
> > > There are various pmu tests that require an isb() between enabling
> > > counting and the actual counting. This can lead to count registers
> > > reporting less events than expected; the actual enabling happens after
> > > some events have happened.  For example, some missing isb()'s in the
> > > pmu-sw-incr test lead to the following errors on bare-metal:
> > > 
> > > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> > >         PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> > >         FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> > >         FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> > >         INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> > >         PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> > >         SUMMARY: 4 tests, 2 unexpected failures
> > > 
> > > Add the missing isb()'s on all failing tests, plus some others that are
> > > not currently required but might in the future (like an isb() after
> > > clearing the overflow signal in the IRQ handler).
> > 
> > That's rather cryptic. What might require those hypothetical ISBs and why? Why
> > should a test add code for some hypothetical requirement that might, or might
> > not, be implemented?
> 
> Good point, this wasn't very clear. Will add something more specific.
> 
> > 
> > This is pure speculation on my part, were you seeing spurious interrupts that
> > went away after adding the ISB in irq_handler()?
> 
> I didn't see any. But I think it could happen: multiple spurious
> interrupts until the line finally gets cleared.

I agree with you, it takes a finite time for any interrupt controller (in
our case, the GIC) to deassert the interrupt line to the CPU after a device
has deasserted the interrupt line to the interrupt controller. That's why
device drivers are usually robust in dealing with spurious interrupts.

It looks to me that the way irq_handler() treats spurious interrupts might
lead to tests being incorrectly treated as failed, which is going to be a
pain to reproduce and diagnose.

@Eric, was there a particular reason for this approach?

Thanks,
Alex
