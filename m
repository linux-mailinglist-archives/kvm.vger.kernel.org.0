Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B43570577
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 16:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiGKOXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGKOXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 10:23:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 409E865580
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 07:23:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F5561596;
        Mon, 11 Jul 2022 07:23:00 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0A733F70D;
        Mon, 11 Jul 2022 07:22:58 -0700 (PDT)
Date:   Mon, 11 Jul 2022 15:23:23 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean
 and invalidate before disabling
Message-ID: <YswyW4bxGpbsN6KO@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
 <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
 <Yr2H3AiNGHeKReP2@monolith.localdoman>
 <218172cd-25fc-8888-96cc-a7b5a9c65f73@arm.com>
 <Yr3H4HM/bMaahFk2@monolith.localdoman>
 <20220701091214.savjgllxfcjk2l7g@kamzik>
 <Yr7LbKN4BK7G2LD2@monolith.localdoman>
 <20220701111627.w2jciiqnapt3z2sv@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701111627.w2jciiqnapt3z2sv@kamzik>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

Sorry, I lost track of this thread.

On Fri, Jul 01, 2022 at 01:16:27PM +0200, Andrew Jones wrote:
> On Fri, Jul 01, 2022 at 11:24:44AM +0100, Alexandru Elisei wrote:
> ...
> > > being dropped and replaced by one of you with something that "makes
> > > more sense" as long as the outcome (coherent execution on bare-metal)
> > > still works.
> > 
> > Hmm... maybe an experiment will work. I propose the following:
> > 
> > 1. Revert this patch.
> > 2. Apply this diff on top of the series:
> > 
> > diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> > index 30d04d0eb100..913f4088d96c 100644
> > --- a/lib/arm/setup.c
> > +++ b/lib/arm/setup.c
> > @@ -374,6 +374,11 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> >                 }
> >         }
> >         __phys_end &= PHYS_MASK;
> > +
> > +       asm volatile("dc cvau, %0\n" :: "r" (&__phys_offset) : "memory");
> > +       asm volatile("dc cvau, %0\n" :: "r" (&__phys_end) : "memory");
> > +       dsb(sy);
> > +
> >         asm_mmu_disable();
> > 
> >         if (free_mem_pages == 0)
> > 
> > This is the solution, based on an architectural explanation of what we were
> > observing, that I proposed on your github branch, a solution that you've
> > tested with the result:
> > 
> > "I tested at least 10 times (lost count) with a build where "arm/arm64:
> > mmu_disable: Clean and invalidate before disabling" was reverted from the
> > target-efi branch and your hack was applied. It worked every time."
> > 
> > [1] https://github.com/rhdrjones/kvm-unit-tests/commit/fc58684bc47b7d07d75098fdfddb6083e9b12104#commitcomment-44222926
> >
> 
> Hi Alex,
> 
> Thanks for digging that back up. I had lost track of it. The last comment
> is you saying that you'll send a proper patch. Did you send one that got
> lost? If not, would you like to send one now that Nikos can incorporate?

The "proper patch" that I was referring to was to skip cache maintenance
when the MMU is already off. Based on the ongoing thread with Nikos, we
might have to rethink asm_mmu_disable, so I'm waiting for a conclusion
before I make any changes to asm_mmu_disable.

Thanks,
Alex

> 
> Thanks,
> drew
