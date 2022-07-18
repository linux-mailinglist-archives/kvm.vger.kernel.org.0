Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4215787A0
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 18:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiGRQlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGRQln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 12:41:43 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AB98DFB1
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 09:41:42 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB9971042;
        Mon, 18 Jul 2022 09:41:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3F443F73D;
        Mon, 18 Jul 2022 09:41:40 -0700 (PDT)
Date:   Mon, 18 Jul 2022 17:42:08 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        andrew.jones@linux.dev
Subject: Re: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
Message-ID: <YtWNYGuP/Nu1HwDU@monolith.localdoman>
References: <20220718154910.3923412-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I believe you're missing the updated email for the arm maintainer. Added it.

Thanks,
Alex

On Mon, Jul 18, 2022 at 08:49:07AM -0700, Ricardo Koller wrote:
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
> I believe the third fix also requires a KVM change, but would like to
> double check with others first.  The only reference I could find in the
> ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
> J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
> overflow.
> 
> Ricardo Koller (3):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Remove checks for !overflow in chained counters tests
> 
>  arm/pmu.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
