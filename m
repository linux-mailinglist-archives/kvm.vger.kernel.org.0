Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98989743DC2
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbjF3Ony (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjF3Onh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:43:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BAF6423E
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 07:43:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92DB2D75;
        Fri, 30 Jun 2023 07:44:09 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 030CB3F73F;
        Fri, 30 Jun 2023 07:43:23 -0700 (PDT)
Date:   Fri, 30 Jun 2023 15:43:21 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Message-ID: <ZJ7qCdSkHSIj-I2N@monolith.localdoman>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
 <20230531201438.3881600-6-eric.auger@redhat.com>
 <ZIxM8-z0WdhbVq64@monolith.localdoman>
 <5be4612e-5364-fe22-c09c-d4c8215942ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5be4612e-5364-fe22-c09c-d4c8215942ff@redhat.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Mon, Jun 19, 2023 at 10:00:11PM +0200, Eric Auger wrote:
> Hi,
> 
> On 6/16/23 13:52, Alexandru Elisei wrote:
> > Hi,
> >
> > The test looks much more readable now, some comments below.
> >
> > On Wed, May 31, 2023 at 10:14:37PM +0200, Eric Auger wrote:
> >> [..]
> >> +static void test_mem_access_reliability(bool overflow_at_64bits)
> >> +{
> >> +	uint32_t events[] = {MEM_ACCESS};
> >> +	void *addr = malloc(PAGE_SIZE);
> >> +	uint64_t count, delta, max = 0, min = pmevcntr_mask();
> >> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
> >> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> >> +	bool overflow = false;
> >> +
> >> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> >> +	    !check_overflow_prerequisites(overflow_at_64bits))
> >> +		return;
> >> +
> >> +	pmu_reset();
> >> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> >> +	for (int i = 0; i < 100; i++) {
> >> +		pmu_reset();
> >> +		write_regn_el0(pmevcntr, 0, pre_overflow2);
> >> +		write_sysreg_s(0x1, PMCNTENSET_EL0);
> >> +		isb();
> >> +		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> >> +		count = read_regn_el0(pmevcntr, 0);
> >> +		if (count >= pre_overflow2) {
> >> +			/* not counter overflow, as expected */
> >> +			delta = count - pre_overflow2;
> > Personally, I find the names confusing. Since the test tries to see how
> > much the counting is unreliable, I would have have expected delta to be
> > difference between the expected number of events incremented (i.e., COUNT)
> > and the actual number of events recorded in the counter. I would rename
> > count to cntr_val and delta to num_events, but that might be just personal
> > bias and I leave it up to you if think this might be useful.
> I followed your suggestion

Sorry for that, I guess I didn't think things through :(

Thanks,
Alex
