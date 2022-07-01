Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59EA562F93
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiGAJMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiGAJMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:12:22 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4325D3150F
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:12:18 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:12:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656666736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VqgXO16D+x0gzA4CkIK7qVGvhke2etcsjiyztr802YE=;
        b=wduebQc9vBD8HYo65dP6MglKM5seRz6YA2TBxm+61vYnEtxhrRkNHor2C0HIjLrfL0oZl3
        oHDl9z649WXTUCUk4Td2IMcp+tnIaJVA7T9Ibszfesa/ExnXkshnYH/WNbRfc53gsrxmth
        gUFY3YR7G/Xd+zXix/J3XtWd1xu+Jy0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean
 and invalidate before disabling
Message-ID: <20220701091214.savjgllxfcjk2l7g@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
 <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
 <Yr2H3AiNGHeKReP2@monolith.localdoman>
 <218172cd-25fc-8888-96cc-a7b5a9c65f73@arm.com>
 <Yr3H4HM/bMaahFk2@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yr3H4HM/bMaahFk2@monolith.localdoman>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 04:57:39PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Jun 30, 2022 at 04:16:09PM +0100, Nikos Nikoleris wrote:
> > Hi Alex,
> > 
> > On 30/06/2022 12:24, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > On Thu, Jun 30, 2022 at 12:08:41PM +0100, Nikos Nikoleris wrote:
> > > > Hi Alex,
> > > > 
> > > > On 30/06/2022 11:20, Alexandru Elisei wrote:
> > > > > Hi,
> > > > > 
> > > > > On Thu, Jun 30, 2022 at 11:03:12AM +0100, Nikos Nikoleris wrote:
> > > > > > From: Andrew Jones <drjones@redhat.com>
> > > > > > 
> > > > > > The commit message of commit 410b3bf09e76 ("arm/arm64: Perform dcache
> > > > > > clean + invalidate after turning MMU off") justifies cleaning and
> > > > > > invalidating the dcache after disabling the MMU by saying it's nice
> > > > > > not to rely on the current page tables and that it should still work
> > > > > > (per the spec), as long as there's an identity map in the current
> > > > > > tables. Doing the invalidation after also somewhat helped with
> > > > > > reenabling the MMU without seeing stale data, but the real problem
> > > > > > with reenabling was because the cache needs to be disabled with
> > > > > > the MMU, but it wasn't.
> > > > > > 
> > > > > > Since we have to trust/validate that the current page tables have an
> > > > > > identity map anyway, then there's no harm in doing the clean
> > > > > > and invalidate first (it feels a little better to do so, anyway,
> > > > > > considering the cache maintenance instructions take virtual
> > > > > > addresses). Then, also disable the cache with the MMU to avoid
> > > > > > problems when reenabling. We invalidate the Icache and disable
> > > > > > that too for good measure. And, a final TLB invalidation ensures
> > > > > > we're crystal clean when we return from asm_mmu_disable().
> > > > > 
> > > > > I'll point you to my previous reply [1] to this exact patch which explains
> > > > > why it's incorrect and is only papering over another problem.
> > > > > 
> > > > > [1] https://lore.kernel.org/all/Yn5Z6Kyj62cUNgRN@monolith.localdoman/
> > > > > 
> > > > 
> > > > Apologies, I didn't mean to ignore your feedback on this. There was a
> > > > parallel discussion in [2] which I thought makes the problem more concrete.
> > > 
> > > No problem, I figured as much :).
> > > 
> > > > 
> > > > This is Drew's patch as soon as he confirms he's also happy with the change
> > > > you suggested in the patch description I am happy to make it.
> > > > 
> > > > Generally, a test will start off with the MMU enabled. At this point, we
> > > > access code, use and modify data (EfiLoaderData, EfiLoaderCode). Any of the
> > > > two regions could be mapped as any type of memory (I need to have another
> > > > look to confirm if it's Normal Memory). Then we want to take over control of
> > > > the page tables and for that reason we have to switch off the MMU. And any
> > > > access to code or data will be with Device-nGnRnE as you pointed out. If we
> > > > don't clean and invalidate, instructions and data might be in the cache and
> > > > we will be mixing memory attributes, won't we?
> > > 
> > > I missed that comment, sorry. I've replied to that comment made in v2,
> > > here, in this ieration, in patch #19 ("arm/arm64: Add a setup sequence for
> > > systems that boot through EFI").
> > > 
> > > This is the second time you've mentioned mixed memory attributes, so I'm
> > > going to reiterate the question I asked in patch #19: what do you mean by
> > > "mixing memory attributes" and what is wrong with it? Because it looks to
> > > me like you're saying that you cannot access data written with the MMU on
> > > when the MMU is off (and I assume the other way around, you cannot data
> > > written with the MMU off when the MMU is on).
> > > 
> > 
> > What I mean by mixing memory attributes is illustrated by the following
> > example.
> > 
> > Take a memory location x, for which the page table entry maps to a physical
> > location as Normal, Inner-Shareable, Inner-writeback and Outer-writeback. If
> > we access it when the MMU is on and subquently when the MMU is off (treated
> > as Device-nGnRnE), then we have two accesses with mismatched memory
> > attributes to the same location. There is a whole section in the Arm ARM on
> > why this needs to be avoided (B2.8 Mismatched memory attributes) but the
> > result is "a loss of the uniprocessor semantics, ordering, or coherency". As
> > I understand, the solution to this is:
> > 
> > "If the mismatched attributes for a Location mean that multiple cacheable
> > accesses to the Location might be made with different shareability
> > attributes, then uniprocessor semantics, ordering, and coherency are
> > guaranteed only if:
> > • Software running on a PE cleans and invalidates a Location from cache
> > before and after each read or write to that Location by that PE.
> > • A DMB barrier with scope that covers the full shareability of the accesses
> > is placed between any accesses to the same memory Location that use
> > different attributes."
> 
> Ok, so this is about *mismatched* memory attributes. I searched the Arm ARM
> for the string "mixed" and nothing relevant came up.
> 
> Device-whatever memory is outer shareable and kvm-unit-tests maps memory as
> inner shareable, so that matches the "different shareability attributes"
> part of the paragraph.
> 
> But I would like to point out that there is only one type of cacheable
> access that is being performed, when the MMU is on. When the MMU is off,
> the access is not cacheable. So there are two types of accesses being
> performed:
> 
> - cacheable + inner-shareable (MMU on)
> - non-cacheable + outer-shareable (MMU off)
> 
> It looks to me like the paragraph doesn't apply to our case, because there
> are no "multiple cacheable accesses [..] made with different shareability
> attributes". Do you agree?
> 
> > 
> > So unless UEFI maps all memory as Device-nGnRnE we have to do something. I
> > will try to find out more about UEFI's page tables.
> 
> That's important to know, especially regarding the text section of the
> image. If UEFI doesnt' clean it to PoC, kvm-unit-tests must do it in order
> to execute correctly with the MMU off.
>

Hi Alex and Nikos,

Indeed my experiments on bare-metal made this change necessary. I'm happy
to see this discussion, though, as this patch could be tweaked or at least
the commit message improved in order to better explain what's going on and
why the changes are necessary. IOW, I have no problem with this patch
being dropped and replaced by one of you with something that "makes
more sense" as long as the outcome (coherent execution on bare-metal)
still works.

Thanks,
drew
