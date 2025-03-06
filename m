Return-Path: <kvm+bounces-40250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5222A54FAB
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EAB43B3CC0
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430B038DE0;
	Thu,  6 Mar 2025 15:53:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D03C148FF5
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276384; cv=none; b=TBjOAVvJijCAaY2KIf28JLtcjdNQHTkN7acZwjZ37lCfMn+XhgcvEFnECO0hWDC8Hb9Ygh+hIRTn2Z7g+bGe2f+d9nDfKy+UNY9Efat7BG0PCYkVjAn1U/B5GtQBOL+J4YB+rTPDhMyRVQWFZLRtRdRhPVF8U3W7WjoOOkwpb+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276384; c=relaxed/simple;
	bh=Sm+9+2YIU2uoB3CewLYcbRHvxwNjlIaG7ZSfmA4hoGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4l9/9dPyB5mxEMi9vMrzfb4TU8JrADeJEBT2JAklMu4v5IKvuXKItXlH4FnkBqKD51xthVcFneomwiLd7XH26Dvwkv0UjmVstqbvn1xXksdF1YiKnlO5XKRAM8ZdRSMRlw4di/cb/cW+kWThBdw6rXFeJ0XixnGgxNGOVeQVW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 906121007;
	Thu,  6 Mar 2025 07:53:13 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87D703F673;
	Thu,  6 Mar 2025 07:52:59 -0800 (PST)
Date: Thu, 6 Mar 2025 15:52:56 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, drjones@redhat.com, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 2/7] arm64: timer: use hypervisor
 timers when at EL2
Message-ID: <Z8nE2P1JvOhB0WGv@raptor>
References: <20250220141354.2565567-1-joey.gouly@arm.com>
 <20250220141354.2565567-3-joey.gouly@arm.com>
 <Z8CYwU7cfxEMnEUL@raptor>
 <20250304170503.GC1553498@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304170503.GC1553498@e124191.cambridge.arm.com>

Hi Joey,

On Tue, Mar 04, 2025 at 05:05:03PM +0000, Joey Gouly wrote:
> On Thu, Feb 27, 2025 at 04:55:26PM +0000, Alexandru Elisei wrote:
> > Hi Joey,
> > 
> > On Thu, Feb 20, 2025 at 02:13:49PM +0000, Joey Gouly wrote:
> > > At EL2, with VHE:
> > >   - CNTP_CVAL_EL0 is forwarded to CNTHP_CVAL_EL0
> > >   - CNTV_CVAL_EL0 is forwarded to CNTHP_CVAL_EL0
> > 
> > CNTH*V*_CVAL_EL0, right?
> 
> Fixed.
> 
> > 
> > It also happens for the other two registers for the physical and virtual
> > timers (CNT{P,V}_{TVAL,CTL}_EL0). Just nitpicking here.
> 
> I'll write it like that, thanks!
> 
> > 
> > > 
> > > Save the hypervisor physical and virtual timer IRQ numbers from the DT/ACPI.
> > > 
> > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > ---
> > >  arm/timer.c         | 10 ++++++++--
> > >  lib/acpi.h          |  2 ++
> > >  lib/arm/asm/timer.h | 11 +++++++++++
> > >  lib/arm/timer.c     | 19 +++++++++++++++++--
> > >  4 files changed, 38 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arm/timer.c b/arm/timer.c
> > > index 2cb80518..c6287ca7 100644
> > > --- a/arm/timer.c
> > > +++ b/arm/timer.c
> > > @@ -347,8 +347,14 @@ static void test_ptimer(void)
> > >  static void test_init(void)
> > >  {
> > >  	assert(TIMER_PTIMER_IRQ != -1 && TIMER_VTIMER_IRQ != -1);
> It's still there ^^
> > > -	ptimer_info.irq = TIMER_PTIMER_IRQ;
> > > -	vtimer_info.irq = TIMER_VTIMER_IRQ;
> > > +	if (current_level() == CurrentEL_EL1) {
> > > +		ptimer_info.irq = TIMER_PTIMER_IRQ;
> > > +		vtimer_info.irq = TIMER_VTIMER_IRQ;
> > 
> > You dropped the assert for TIMER_{P,V}TIMER_IRQ.
> 
> The assertion is still there!

Yeah, my bad, sorry for that.

Alex

> 
> > 
> > Otherwise, looks good to me:
> > 
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks!
> 
> > 
> > Thanks,
> > Alex
> > 
> > > +	} else {
> > > +		assert(TIMER_HPTIMER_IRQ != -1 && TIMER_HVTIMER_IRQ != -1);
> > > +		ptimer_info.irq = TIMER_HPTIMER_IRQ;
> > > +		vtimer_info.irq = TIMER_HVTIMER_IRQ;
> > > +	}
> > >  
> > >  	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
> > >  	ptimer_info.read_ctl();
> > > diff --git a/lib/acpi.h b/lib/acpi.h
> > > index c330c877..66e3062d 100644
> > > --- a/lib/acpi.h
> > > +++ b/lib/acpi.h
> > > @@ -290,6 +290,8 @@ struct acpi_table_gtdt {
> > >  	u64 counter_read_block_address;
> > >  	u32 platform_timer_count;
> > >  	u32 platform_timer_offset;
> > > +	u32 virtual_el2_timer_interrupt;
> > > +	u32 virtual_el2_timer_flags;
> > >  };
> > >  
> > >  /* Reset to default packing */
> > > diff --git a/lib/arm/asm/timer.h b/lib/arm/asm/timer.h
> > > index aaf839fc..7dda0f4f 100644
> > > --- a/lib/arm/asm/timer.h
> > > +++ b/lib/arm/asm/timer.h
> > > @@ -21,12 +21,23 @@ struct timer_state {
> > >  		u32 irq;
> > >  		u32 irq_flags;
> > >  	} vtimer;
> > > +	struct {
> > > +		u32 irq;
> > > +		u32 irq_flags;
> > > +	} hptimer;
> > > +	struct {
> > > +		u32 irq;
> > > +		u32 irq_flags;
> > > +	} hvtimer;
> > >  };
> > >  extern struct timer_state __timer_state;
> > >  
> > >  #define TIMER_PTIMER_IRQ (__timer_state.ptimer.irq)
> > >  #define TIMER_VTIMER_IRQ (__timer_state.vtimer.irq)
> > >  
> > > +#define TIMER_HPTIMER_IRQ (__timer_state.hptimer.irq)
> > > +#define TIMER_HVTIMER_IRQ (__timer_state.hvtimer.irq)
> > > +
> > >  void timer_save_state(void);
> > >  
> > >  #endif /* !__ASSEMBLY__ */
> > > diff --git a/lib/arm/timer.c b/lib/arm/timer.c
> > > index ae702e41..57f504e2 100644
> > > --- a/lib/arm/timer.c
> > > +++ b/lib/arm/timer.c
> > > @@ -38,10 +38,11 @@ static void timer_save_state_fdt(void)
> > >  	 *      secure timer irq
> > >  	 *      non-secure timer irq            (ptimer)
> > >  	 *      virtual timer irq               (vtimer)
> > > -	 *      hypervisor timer irq
> > > +	 *      hypervisor timer irq            (hptimer)
> > > +	 *      hypervisor virtual timer irq    (hvtimer)
> > >  	 */
> > >  	prop = fdt_get_property(fdt, node, "interrupts", &len);
> > > -	assert(prop && len == (4 * 3 * sizeof(u32)));
> > > +	assert(prop && len >= (4 * 3 * sizeof(u32)));
> > >  
> > >  	data = (u32 *) prop->data;
> > >  	assert(fdt32_to_cpu(data[3]) == 1 /* PPI */ );
> > > @@ -50,6 +51,14 @@ static void timer_save_state_fdt(void)
> > >  	assert(fdt32_to_cpu(data[6]) == 1 /* PPI */ );
> > >  	__timer_state.vtimer.irq = PPI(fdt32_to_cpu(data[7]));
> > >  	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
> > > +	if (len == (5 * 3 * sizeof(u32))) {
> > > +		assert(fdt32_to_cpu(data[9]) == 1 /* PPI */ );
> > > +		__timer_state.hptimer.irq = PPI(fdt32_to_cpu(data[10]));
> > > +		__timer_state.hptimer.irq_flags = fdt32_to_cpu(data[11]);
> > > +		assert(fdt32_to_cpu(data[12]) == 1 /* PPI */ );
> > > +		__timer_state.hvtimer.irq = PPI(fdt32_to_cpu(data[13]));
> > > +		__timer_state.hvtimer.irq_flags = fdt32_to_cpu(data[14]);
> > > +	}
> > >  }
> > >  
> > >  #ifdef CONFIG_EFI
> > > @@ -72,6 +81,12 @@ static void timer_save_state_acpi(void)
> > >  
> > >  	__timer_state.vtimer.irq = gtdt->virtual_timer_interrupt;
> > >  	__timer_state.vtimer.irq_flags = gtdt->virtual_timer_flags;
> > > +
> > > +	__timer_state.hptimer.irq = gtdt->non_secure_el2_interrupt;
> > > +	__timer_state.hptimer.irq_flags = gtdt->non_secure_el2_flags;
> > > +
> > > +	__timer_state.hvtimer.irq = gtdt->virtual_el2_timer_interrupt;
> > > +	__timer_state.hvtimer.irq_flags = gtdt->virtual_el2_timer_flags;
> > >  }
> > >  
> > >  #else
> > > -- 
> > > 2.25.1
> > > 

