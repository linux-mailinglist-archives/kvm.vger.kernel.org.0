Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE52696E57
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 21:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBNUTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 15:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjBNUTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 15:19:05 -0500
Received: from out-16.mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7459B4EDD
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 12:19:04 -0800 (PST)
Date:   Tue, 14 Feb 2023 21:18:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676405942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GNW8SrgMQvUyACn7rFRBFRQ3ENe28gCY7MBVq5s37kc=;
        b=DASD/suchG96au0LYsv6dTjdALItPT7wWU9eun7rJ2QSWlObNf5bMbqNOTN9eT9JB7GFqv
        phZj31ai7ctY1JjBs96+vYmpRr02dsiEm9w3hkSlAMYPsvxVDCmdrBj7jovKHUWk55dFxO
        GwM7WkhBD15O8o0im1eWmacWI+0Wk0c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v4 0/6] arm: pmu: Add support for PMUv3p5
Message-ID: <20230214201856.wvfg2wxgeg5z6out@orel>
References: <20230126165351.2561582-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126165351.2561582-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 04:53:45PM +0000, Ricardo Koller wrote:
> The first commit fixes the tests when running on PMUv3p5. The issue is that
> PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> for overflowing at 32 or 64-bits. Tests are currently failing [0] on
> PMUv3p5 because of this. They wrongly assume that values will be wrapped
> around 32-bits, but they overflow into the other half of the 64-bit
> counters.
> 
> The second and third commits add new tests for 64-bit overflows, a feature
> added with PMUv3p5 (PMCR_EL0.LP == 1). This is done by running all
> overflow-related tests in two modes: with 32-bit and 64-bit overflows.
> The fourt commit changes the value reporting to use %lx instead of %ld.
> 
> This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
> kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
> PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.
> 
> Changes from v3:
> - Added commit to fix test_overflow_interrupt(). (Reiji and Eric)
> - Separated s/ALL_SET/ALL_SET_32/ and s/PRE_OVERFLOW/PRE_OVERFLOW_32
>   into its own commit. (Reiji and Eric)
> - Fix s/200/20. (Eric)
> 
> Changes from v2:
> - used Oliver's suggestion of using pmevcntr_mask() for masking counters to
>   32 or 64 bits, instead of casting to uint32_t or uint64_t.
> - removed ALL_SET_AT() in favor of pmevcntr_mask(). (Oliver)
> - moved the change to have odd counter overflows at 64-bits from first to
>   third commit.
> - renamed PRE_OVERFLOW macro to PRE_OVERFLOW_32, and PRE_OVERFLOW_AT() to
>   PRE_OVERFLOW().
> 
> Changes from v1 (all suggested by Alexandru):
> - report counter values in hexadecimal
> - s/overflow_at_64bits/unused for all chained tests
> - check that odd counters do not increment when using overflow_at_64bits
>   (pmcr.LP=1)
> - test 64-bit odd counters overflows
> - switch confusing var names in test_chained_sw_incr(): cntr0 <-> cntr1
> 
> [0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
> [1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/
> 
> Ricardo Koller (6):
>   arm: pmu: Fix overflow checks for PMUv3p5 long counters
>   arm: pmu: Prepare for testing 64-bit overflows
>   arm: pmu: Rename ALL_SET and PRE_OVERFLOW
>   arm: pmu: Add tests for 64-bit overflows
>   arm: pmu: Print counter values as hexadecimals
>   arm: pmu: Fix test_overflow_interrupt()
> 
>  arm/pmu.c | 298 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 188 insertions(+), 110 deletions(-)
> 
> -- 
> 2.39.1.456.gfc5497dd1b-goog
>

Applied, thanks
