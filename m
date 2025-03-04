Return-Path: <kvm+bounces-40059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17DC0A4E87D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7075617C577
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 17:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6CAD2D4B65;
	Tue,  4 Mar 2025 16:56:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43582D4B62
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741107374; cv=none; b=EammLEt/UDitblvDECjnDJ3dGjkIE+qrz4Eo6UNYkRMnK5zXT8/ydn/3zEJSnD9kT0FdYsAVdyXPTIJgWQzAHNMY6yZ1ZHDM7432jRd2GJkaeN9nbJ/jT4ZOrCO22/KplFzxfH3pzxyWlaKcGxQn2f9z1rC82BNjKkCTuYVTao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741107374; c=relaxed/simple;
	bh=WHEjj5DtUU4Uq63k9XAObiVLYSnUPqAM+Bsk2qbyMkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMRIlEUcrYT3YeK9ffz2tF5eT6wLWhCyIKUP3K8XyYxl4QWkD9dNYGpNtArOfTDub1CRetoVr73oa4M+OipkiuxepZGCa6laLvVHZ/IxlkTsQNXcXlVlggG78MCEx0HfDRTDFX2RPiL//MWtDYwUxAtg0+HUQ89WIn1/jW3kjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A22BF2F;
	Tue,  4 Mar 2025 08:56:24 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D45703F5A1;
	Tue,  4 Mar 2025 08:56:09 -0800 (PST)
Date: Tue, 4 Mar 2025 16:56:04 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 6/7] arm64: pmu: count EL2 cycles
Message-ID: <20250304165604.GA1553498@e124191.cambridge.arm.com>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-7-joey.gouly@arm.com>
 <Z8CaT5Qe5X4t4Kzg@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8CaT5Qe5X4t4Kzg@raptor>

Hi Alexandru,

On Thu, Feb 27, 2025 at 05:01:03PM +0000, Alexandru Elisei wrote:
> Hi Joey,
> 
> On Thu, Feb 20, 2025 at 02:13:53PM +0000, Joey Gouly wrote:
> > Count EL2 cycles if that's the EL kvm-unit-tests is running at!
> > 
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  arm/pmu.c | 21 ++++++++++++++++++---
> >  1 file changed, 18 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 2dc0822b..238e4628 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -206,6 +206,8 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
> >  #define ID_DFR0_PMU_V3_8_5	0b0110
> >  #define ID_DFR0_PMU_IMPDEF	0b1111
> >  
> > +#define PMCCFILTR_EL0_NSH	BIT(27)
> > +
> >  static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
> >  static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
> >  static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
> > @@ -247,7 +249,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
> >  #define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
> >  
> >  #define PMEVTYPER_EXCLUDE_EL1 BIT(31)
> 
> I think you can drop the macro. I was expecting to see an exclude EL2 macro
> used in its place when the test is running at EL2, but it seems
> PMEVTYPER_EXCLUDE_EL1 is not used anywhere. Unless I'm missing something here.

I will drop it.

> 
> > -#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
> > +#define PMEVTYPER_EXCLUDE_EL0 BIT(30) | BIT(27)
> 
> I'm not really sure what that's supposed to achieve - if the test is
> running at EL2, and events from both EL0 and EL2 are excluded, what's left
> to count?

bit 27 of PMEVTYPER is the NSH bit, when it is 1 the events are not filtered.
This is the opposite polarity to the U (bit 30) and P (bit 31) bits. When they
are 1, the events are filtered.

> 
> I also don't understand what PMEVTYPER_EXCLUDE_EL0 does in the non-nested
> virt case (when kvm-unit-tests boots at El1). The tests run at EL1, so not
> counting events at EL0 shouldn't affect anything. Am I missing something
> obvious here?

I don't know why it's like that. AFAICT, it doesn't run anything at EL0.

> 
> >  
> >  static bool is_event_supported(uint32_t n, bool warn)
> >  {
> > @@ -1059,11 +1061,18 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >  static bool check_cycles_increase(void)
> >  {
> >  	bool success = true;
> > +	u64 pmccfiltr = 0;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> >  	pmu_reset();
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> > -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> > +
> > +#if defined(__aarch64__)
> > +	if (current_level() == CurrentEL_EL2)
> > +		// include EL2 cycle counts
> > +		pmccfiltr |= PMCCFILTR_EL0_NSH;
> > +#endif
> > +	set_pmccfiltr(pmccfiltr);
> >  
> >  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
> >  	isb();
> > @@ -1114,11 +1123,17 @@ static void measure_instrs(int num, uint32_t pmcr)
> >  static bool check_cpi(int cpi)
> >  {
> >  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> > +	u64 pmccfiltr = 0;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> >  	pmu_reset();
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> > -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> > +#if defined(__aarch64__)
> > +	if (current_level() == CurrentEL_EL2)
> > +		// include EL2 cycle counts
> > +		pmccfiltr |= PMCCFILTR_EL0_NSH;
> > +#endif
> 
> It's called twice, so it could be abstracted in a function.
> 
> Also, I find it interesting that for PMCCFILTR_EL0 you set the NSH bit
> based on current exception level, but for PMEVTYPER you set it
> unconditionally. Why the different approaches? For convenience of is there
> something more?

No real reason. I don't really know about the PMU, just did some changes to get
this test working.  I'll look into if setting NSH always is fine too, then I'll
unconditionally do it.

Thanks,
Joey

