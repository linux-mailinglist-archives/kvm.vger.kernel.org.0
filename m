Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D490358DAFE
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbiHIPVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 11:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiHIPU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 11:20:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EEDF2734
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 08:20:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE18E23A;
        Tue,  9 Aug 2022 08:20:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C4D83F5A1;
        Tue,  9 Aug 2022 08:20:56 -0700 (PDT)
Date:   Tue, 9 Aug 2022 16:21:41 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 1/3] arm: pmu: Add missing isb()'s
 after sys register writing
Message-ID: <YvJ7hbMZ+FLkxuc4@monolith.localdoman>
References: <20220805004139.990531-1-ricarkol@google.com>
 <20220805004139.990531-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805004139.990531-2-ricarkol@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Aug 04, 2022 at 05:41:37PM -0700, Ricardo Koller wrote:
> There are various pmu tests that require an isb() between enabling
> counting and the actual counting. This can lead to count registers
> reporting less events than expected; the actual enabling happens after
> some events have happened.  For example, some missing isb()'s in the
> pmu-sw-incr test lead to the following errors on bare-metal:
> 
> 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> 	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> 	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> 	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> 	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> 	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> 	SUMMARY: 4 tests, 2 unexpected failures
> 
> Add the missing isb()'s on all failing tests, plus some others that seem
> required:
> - after clearing the overflow signal in the IRQ handler to make spurious
>   interrupts less likely.
> - after direct writes to PMSWINC_EL0 for software to read the correct
>   value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
