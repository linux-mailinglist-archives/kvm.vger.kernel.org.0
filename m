Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E3591772
	for <lists+kvm@lfdr.de>; Sat, 13 Aug 2022 00:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbiHLWxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 18:53:50 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718138E0E0
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 15:53:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u133so2110858pfc.10
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=iRFZSl8CFIpxRsaSO+UveS+LzKviG0hnqiANKsDTmJo=;
        b=ors5xSxc06EEdIGJuxR+39I57umiC1BibyRM4LBpc2kaOhCFr/hmF236yZTjnr06II
         caLz+jcRsIdnW8PzXfD14Rbn/yYOQkMTpsxK7REj8R+pbCqF1FH1PfK9pGh+oWbUx0R8
         FFEoW7RgpvrGpyLsmv1OBKQUMLgOhgv+OYGKjgjksXSlwcfcpiaT2IEjxpbOTO1RQESl
         JrQB77IvEF1wn68+3VgOCd4dTwO2f4gP/60IsmLv0hfY7MnV8Br5SClEWv0GZbo9h65t
         4XSldbQ31P3l87u/Yk85lcyYbNB2XsRFs2B3XYdj5DDaRIb0FTB51fUx40+3jihowQb2
         R82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=iRFZSl8CFIpxRsaSO+UveS+LzKviG0hnqiANKsDTmJo=;
        b=6EQN5XzqHjZN6CvL8/mjOXfAnfJUaZXvcZ7emGIcllH92hsfCstLCsOE3SQRKZRwYw
         HmAolsVetv6UxomBmXFp57x8BOCixvA/CZh7NFSYoPvjx7hlCfqTqs7Q9TM9eX67qAGf
         YP29RIy/oxps11LL5+3auxlOStsNvjwX9of1lNe4T/DyqsdobbDX5RUJ17sWoqIdyya8
         c39KH8s83py4uiKZeJZBjKouZcGVRfu/zlRAqTus9kMCvHFpNXDBxjxNHYkyKH4Z7aw5
         WCo0rhx1B3J0cFtwaLVTdUsHq9wMCNggVZ1FUy3mQxll0pxB79vUFYK2BLChDRm0pMfY
         cGkg==
X-Gm-Message-State: ACgBeo0KCv4S59e+YgvWUQx4KYc5HoLSPJxYX3Fpj6g07beO7gzr8j7K
        psJAdP2aa9dzjZdhIiB6uJ8w2Mvzk04M7g==
X-Google-Smtp-Source: AA6agR6o+/PBRQB6iJgXbJNG81fXUZyRSovkajDgZyUM8uoihcMBBUE7NZZWEGizVgYbJjneu2WvaQ==
X-Received: by 2002:a63:1646:0:b0:41b:425b:fc3d with SMTP id 6-20020a631646000000b0041b425bfc3dmr4699419pgw.205.1660344828768;
        Fri, 12 Aug 2022 15:53:48 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id b17-20020a170902d51100b0016d763967f8sm2329558plg.107.2022.08.12.15.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 15:53:48 -0700 (PDT)
Date:   Fri, 12 Aug 2022 15:53:44 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvbZ+OnPTjvIYbUz@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <YvP8/m9uDI2PcyoP@google.com>
 <YvQIIWnUkCGl9Ltp@google.com>
 <YvQpN3SYePyTw13z@google.com>
 <87lervuefe.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lervuefe.wl-maz@kernel.org>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 01:56:21PM +0100, Marc Zyngier wrote:
> On Wed, 10 Aug 2022 22:55:03 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Wed, Aug 10, 2022 at 02:33:53PM -0500, Oliver Upton wrote:
> > > Hi Ricardo,
> > > 
> > > On Wed, Aug 10, 2022 at 11:46:22AM -0700, Ricardo Koller wrote:
> > > > On Fri, Aug 05, 2022 at 02:58:04PM +0100, Marc Zyngier wrote:
> > > > > Ricardo recently reported[1] that our PMU emulation was busted when it
> > > > > comes to chained events, as we cannot expose the overflow on a 32bit
> > > > > boundary (which the architecture requires).
> > > > > 
> > > > > This series aims at fixing this (by deleting a lot of code), and as a
> > > > > bonus adds support for PMUv3p5, as this requires us to fix a few more
> > > > > things.
> > > > > 
> > > > > Tested on A53 (PMUv3) and FVP (PMUv3p5).
> > > > > 
> > > > > [1] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
> > > > > 
> > > > > Marc Zyngier (9):
> > > > >   KVM: arm64: PMU: Align chained counter implementation with
> > > > >     architecture pseudocode
> > > > >   KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
> > > > >   KVM: arm64: PMU: Only narrow counters that are not 64bit wide
> > > > >   KVM: arm64: PMU: Add counter_index_to_*reg() helpers
> > > > >   KVM: arm64: PMU: Simplify setting a counter to a specific value
> > > > >   KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
> > > > >   KVM: arm64: PMU: Aleven ID_AA64DFR0_EL1.PMUver to be set from userspace
> > > > >   KVM: arm64: PMU: Implement PMUv3p5 long counter support
> > > > >   KVM: arm64: PMU: Aleven PMUv3p5 to be exposed to the guest
> > > > > 
> > > > >  arch/arm64/include/asm/kvm_host.h |   1 +
> > > > >  arch/arm64/kvm/arm.c              |   6 +
> > > > >  arch/arm64/kvm/pmu-emul.c         | 372 ++++++++++--------------------
> > > > >  arch/arm64/kvm/sys_regs.c         |  65 +++++-
> > > > >  include/kvm/arm_pmu.h             |  16 +-
> > > > >  5 files changed, 208 insertions(+), 252 deletions(-)
> > > > > 
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > 
> > > > Hi Marc,
> > > > 
> > > > There is one extra potential issue with exposing PMUv3p5. I see this
> > > > weird behavior when doing passthrough ("bare metal") on the fast-model
> > > > configured to emulate PMUv3p5: the [63:32] half of the counters
> > > > overflowing at 32-bits is still incremented.
> > > > 
> > > >   Fast model - ARMv8.5:
> > > >    
> > > > 	Assuming the initial state is even=0xFFFFFFFF and odd=0x0,
> > > > 	incrementing the even counter leads to:
> > > > 
> > > > 	0x00000001_00000000	0x00000000_00000001		0x1
> > > > 	even counter		odd counter			PMOVSET
> > > > 
> > > > 	Assuming the initial state is even=0xFFFFFFFF and odd=0xFFFFFFFF,
> > > > 	incrementing the even counter leads to:
> > > > 
> > > > 	0x00000001_00000000	0x00000001_00000000		0x3
> > > > 	even counter		odd counter			PMOVSET
> > > 
> > > This is to be expected, actually. PMUv8p5 counters are always 64 bit,
> > > regardless of the configured overflow.
> > > 
> > > DDI 0487H D8.3 Behavior on overflow
> > > 
> > >   If FEAT_PMUv3p5 is implemented, 64-bit event counters are implemented,
> > >   HDCR.HPMN is not 0, and either n is in the range [0 .. (HDCR.HPMN-1)]
> > >   or EL2 is not implemented, then event counter overflow is configured
> > >   by PMCR.LP:
> > > 
> > >   — When PMCR.LP is set to 0, if incrementing PMEVCNTR<n> causes an unsigned
> > >     overflow of bits [31:0] of the event counter, the PE sets PMOVSCLR[n] to 1.
> > >   — When PMCR.LP is set to 1, if incrementing PMEVCNTR<n> causes an unsigned
> > >     overflow of bits [63:0] of the event counter, the PE sets PMOVSCLR[n] to 1.
> > > 
> > >   [...]
> > > 
> > >   For all 64-bit counters, incrementing the counter is the same whether an
> > >   unsigned overflow occurs at [31:0] or [63:0]. If the counter increments
> > >   for an event, bits [63:0] are always incremented.
> > > 
> > > Do you see this same (expected) failure w/ Marc's series?
> > 
> > I don't know, I'm hitting another bug it seems.
> > 
> > Just realized that KVM does not offer PMUv3p5 (with this series applied)
> > when the real hardware is only Armv8.2 (the setup I originally tried).
> > So, tried these other two setups on the fast model:
> > 
> > has_arm_v8-5=1
> > 
> > 	# ./lkvm-static run --nodefaults --pmu pmu.flat -p pmu-chained-sw-incr
> > 	# lkvm run -k pmu.flat -m 704 -c 8 --name guest-135
> > 
> > 	INFO: PMU version: 0x6
> >                            ^^^
> >                            PMUv3 for Armv8.5
> > 	INFO: PMU implementer/ID code: 0x41("A")/0
> > 	INFO: Implements 8 event counters
> > 	FAIL: pmu: pmu-chained-sw-incr: overflow and chain counter incremented after 100 SW_INCR/CHAIN
> > 	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=4294967380 #1=0
> >                                                  ^^^
> >                                                  no overflows
> > 	FAIL: pmu: pmu-chained-sw-incr: expected overflows and values after 100 SW_INCR/CHAIN
> > 	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=84 #1=-1
> > 	INFO: pmu: pmu-chained-sw-incr: overflow=0x0, #0=4294967380 #1=4294967295
> > 	SUMMARY: 2 tests, 2 unexpected failures
> 
> Hmm. I think I see what's wrong. In kvm_pmu_create_perf_event(), we
> have this:
> 
> 	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
> 		attr.config1 |= 1;
> 
> 	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> 
> 	/* The initial sample period (overflow count) of an event. */
> 	if (kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
> 		attr.sample_period = (-counter) & GENMASK(63, 0);
> 	else
> 		attr.sample_period = (-counter) & GENMASK(31, 0);
> 
> but the initial sampling period shouldn't be based on the *guest*
> counter overflow. It really is about the getting to an overflow on the
> *host*, so the initial code was correct, and only the width of the
> counter matters here.

Right, I think this requires bringing back some of the chained related
code (like update_pmc_chained() and pmc_is_chained()), because

	attr.sample_period = (-counter) & GENMASK(31, 0);

should also be used when the counter is chained.

Thanks,
Ricardo

> 
> /me goes back to running the FVP...
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
