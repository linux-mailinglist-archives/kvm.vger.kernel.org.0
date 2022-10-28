Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D7B610FDF
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJ1Lks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiJ1Lkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 07:40:47 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D42170B47
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 04:40:44 -0700 (PDT)
Date:   Fri, 28 Oct 2022 13:40:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666957243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oMwmA0KpK5H/XyHLykXQNWwS3gmrGZkypXJgGt50K3o=;
        b=ZsQBJ0JT+hoaIbFWnjW51cRN/7fXidPu+ilJ3RCADVnuHunfEyfv46LiZhUav8JtSDg8ud
        nPZ02Qqvg4/y/xhMNsr53S8Q+Vd/JkyAGEBG2rr4ygUrxf7Z/yGbIfL++B13etr7Yh5DCz
        BphBsNU3l0qW73jRtOsEelTFZ+WSMcQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <20221028114041.5symayccvdgkqaor@kamzik>
References: <20220811185210.234711-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
> There are some tests that fail when running on bare metal (including a
> passthrough prototype).  There are three issues with the tests.  The
> first one is that there are some missing isb()'s between enabling event
> counting and the actual counting. This wasn't an issue on KVM as
> trapping on registers served as context synchronization events. The
> second issue is that some tests assume that registers reset to 0.  And
> finally, the third issue is that overflowing the low counter of a
> chained event sets the overflow flag in PMVOS and some tests fail by
> checking for it not being set.
> 
> Addressed all comments from the previous version:
> https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> - add pmu_reset() for 32-bit arm [Andrew]
> - collect r-b from Alexandru
> 
> Thanks!
> Ricardo
> 
> Ricardo Koller (4):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Add reset_pmu() for 32-bit arm
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Check for overflow in the low counter in chained counters
>     tests
> 
>  arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 55 insertions(+), 17 deletions(-)
>

Hi all,

Please refresh my memory. Does this series work on current platforms? Or
was it introducing new test failures which may be in the test, as opposed
to KVM? If they work on most platforms, but not on every platform, then
have we identified what triggers them to fail and whether that should be
fixed or just worked-around? I'm sorry I still can't help out with the
testing as I haven't yet had time to setup the Rpi that Mark Rutland gave
me in Dublin.

I know this series has been rotting on arm/queue for months, so I'll be
happy to merge it if the consensus is to do so. I can also drop it, or
some of the patches, if that's the consensus.

Thanks,
drew
