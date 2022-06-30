Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1905D56190B
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiF3LYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbiF3LYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:24:15 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 668384F675
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 04:24:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40AFC1063;
        Thu, 30 Jun 2022 04:24:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B882A3F5A1;
        Thu, 30 Jun 2022 04:24:12 -0700 (PDT)
Date:   Thu, 30 Jun 2022 12:24:34 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        andrew.jones@linux.dev, pbonzini@redhat.com, jade.alglave@arm.com,
        ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean
 and invalidate before disabling
Message-ID: <Yr2H3AiNGHeKReP2@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
 <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Jun 30, 2022 at 12:08:41PM +0100, Nikos Nikoleris wrote:
> Hi Alex,
> 
> On 30/06/2022 11:20, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Thu, Jun 30, 2022 at 11:03:12AM +0100, Nikos Nikoleris wrote:
> > > From: Andrew Jones <drjones@redhat.com>
> > > 
> > > The commit message of commit 410b3bf09e76 ("arm/arm64: Perform dcache
> > > clean + invalidate after turning MMU off") justifies cleaning and
> > > invalidating the dcache after disabling the MMU by saying it's nice
> > > not to rely on the current page tables and that it should still work
> > > (per the spec), as long as there's an identity map in the current
> > > tables. Doing the invalidation after also somewhat helped with
> > > reenabling the MMU without seeing stale data, but the real problem
> > > with reenabling was because the cache needs to be disabled with
> > > the MMU, but it wasn't.
> > > 
> > > Since we have to trust/validate that the current page tables have an
> > > identity map anyway, then there's no harm in doing the clean
> > > and invalidate first (it feels a little better to do so, anyway,
> > > considering the cache maintenance instructions take virtual
> > > addresses). Then, also disable the cache with the MMU to avoid
> > > problems when reenabling. We invalidate the Icache and disable
> > > that too for good measure. And, a final TLB invalidation ensures
> > > we're crystal clean when we return from asm_mmu_disable().
> > 
> > I'll point you to my previous reply [1] to this exact patch which explains
> > why it's incorrect and is only papering over another problem.
> > 
> > [1] https://lore.kernel.org/all/Yn5Z6Kyj62cUNgRN@monolith.localdoman/
> > 
> 
> Apologies, I didn't mean to ignore your feedback on this. There was a
> parallel discussion in [2] which I thought makes the problem more concrete.

No problem, I figured as much :).

> 
> This is Drew's patch as soon as he confirms he's also happy with the change
> you suggested in the patch description I am happy to make it.
> 
> Generally, a test will start off with the MMU enabled. At this point, we
> access code, use and modify data (EfiLoaderData, EfiLoaderCode). Any of the
> two regions could be mapped as any type of memory (I need to have another
> look to confirm if it's Normal Memory). Then we want to take over control of
> the page tables and for that reason we have to switch off the MMU. And any
> access to code or data will be with Device-nGnRnE as you pointed out. If we
> don't clean and invalidate, instructions and data might be in the cache and
> we will be mixing memory attributes, won't we?

I missed that comment, sorry. I've replied to that comment made in v2,
here, in this ieration, in patch #19 ("arm/arm64: Add a setup sequence for
systems that boot through EFI").

This is the second time you've mentioned mixed memory attributes, so I'm
going to reiterate the question I asked in patch #19: what do you mean by
"mixing memory attributes" and what is wrong with it? Because it looks to
me like you're saying that you cannot access data written with the MMU on
when the MMU is off (and I assume the other way around, you cannot data
written with the MMU off when the MMU is on).

Thanks,
Alex
