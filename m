Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B321058F338
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiHJTeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiHJTeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:34:09 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C887695F
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:34:08 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660160047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xd7ZEh3Cai7T9+89O7KBFEDHECO3gMJG4kN2ocTFX7A=;
        b=gZ45Svi4/xPi8Uqm/3lqwxOfKntmq36LjsWKSmUW6nYlWib/04Y6vZ31GUKn3YNO8cljdM
        EQzpyHEIhidWwAm6OXLz4+hBTEHeQdL2c1GgIGcj6VZ5bhoUKGHdzJQhwwImYP4jWLyL0C
        wZqU6VogFnXuXNTqPRwlJKPkEb7vfro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvQIIWnUkCGl9Ltp@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <YvP8/m9uDI2PcyoP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvP8/m9uDI2PcyoP@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Wed, Aug 10, 2022 at 11:46:22AM -0700, Ricardo Koller wrote:
> On Fri, Aug 05, 2022 at 02:58:04PM +0100, Marc Zyngier wrote:
> > Ricardo recently reported[1] that our PMU emulation was busted when it
> > comes to chained events, as we cannot expose the overflow on a 32bit
> > boundary (which the architecture requires).
> > 
> > This series aims at fixing this (by deleting a lot of code), and as a
> > bonus adds support for PMUv3p5, as this requires us to fix a few more
> > things.
> > 
> > Tested on A53 (PMUv3) and FVP (PMUv3p5).
> > 
> > [1] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
> > 
> > Marc Zyngier (9):
> >   KVM: arm64: PMU: Align chained counter implementation with
> >     architecture pseudocode
> >   KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
> >   KVM: arm64: PMU: Only narrow counters that are not 64bit wide
> >   KVM: arm64: PMU: Add counter_index_to_*reg() helpers
> >   KVM: arm64: PMU: Simplify setting a counter to a specific value
> >   KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
> >   KVM: arm64: PMU: Aleven ID_AA64DFR0_EL1.PMUver to be set from userspace
> >   KVM: arm64: PMU: Implement PMUv3p5 long counter support
> >   KVM: arm64: PMU: Aleven PMUv3p5 to be exposed to the guest
> > 
> >  arch/arm64/include/asm/kvm_host.h |   1 +
> >  arch/arm64/kvm/arm.c              |   6 +
> >  arch/arm64/kvm/pmu-emul.c         | 372 ++++++++++--------------------
> >  arch/arm64/kvm/sys_regs.c         |  65 +++++-
> >  include/kvm/arm_pmu.h             |  16 +-
> >  5 files changed, 208 insertions(+), 252 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> 
> Hi Marc,
> 
> There is one extra potential issue with exposing PMUv3p5. I see this
> weird behavior when doing passthrough ("bare metal") on the fast-model
> configured to emulate PMUv3p5: the [63:32] half of the counters
> overflowing at 32-bits is still incremented.
> 
>   Fast model - ARMv8.5:
>    
> 	Assuming the initial state is even=0xFFFFFFFF and odd=0x0,
> 	incrementing the even counter leads to:
> 
> 	0x00000001_00000000	0x00000000_00000001		0x1
> 	even counter		odd counter			PMOVSET
> 
> 	Assuming the initial state is even=0xFFFFFFFF and odd=0xFFFFFFFF,
> 	incrementing the even counter leads to:
> 
> 	0x00000001_00000000	0x00000001_00000000		0x3
> 	even counter		odd counter			PMOVSET

This is to be expected, actually. PMUv8p5 counters are always 64 bit,
regardless of the configured overflow.

DDI 0487H D8.3 Behavior on overflow

  If FEAT_PMUv3p5 is implemented, 64-bit event counters are implemented,
  HDCR.HPMN is not 0, and either n is in the range [0 .. (HDCR.HPMN-1)]
  or EL2 is not implemented, then event counter overflow is configured
  by PMCR.LP:

  — When PMCR.LP is set to 0, if incrementing PMEVCNTR<n> causes an unsigned
    overflow of bits [31:0] of the event counter, the PE sets PMOVSCLR[n] to 1.
  — When PMCR.LP is set to 1, if incrementing PMEVCNTR<n> causes an unsigned
    overflow of bits [63:0] of the event counter, the PE sets PMOVSCLR[n] to 1.

  [...]

  For all 64-bit counters, incrementing the counter is the same whether an
  unsigned overflow occurs at [31:0] or [63:0]. If the counter increments
  for an event, bits [63:0] are always incremented.

Do you see this same (expected) failure w/ Marc's series?

--
Thanks,
Oliver
