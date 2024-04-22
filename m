Return-Path: <kvm+bounces-15495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5156E8ACCCB
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 14:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D36A21F2234D
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 12:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2C613E88E;
	Mon, 22 Apr 2024 12:36:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438C5131191
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 12:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713789395; cv=none; b=dL2gQ0Q8orlD6Qqr/88cXkZPzmITinLGrJn95zmLI4tYkdKy3TURR2j8KucvJg+Sj3/n/8SxHD+mR4vhQ/YZZM4XjVJoxg9FozEqpNXlfmGXzg5n94Q09PKusOrNfdyCuGtKxTW+9jeG2qy31BUCXL7ECM3AVF7fskSKOtiTidM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713789395; c=relaxed/simple;
	bh=z5IAxfyTqSEgC6NXDG2iMQE7HM7+kx0UTNa1mhWKEXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHH0Y8p+fPvD7OXOoGBCmicdrRJoFVfODKBtXtgRImji1VC2L75xnZgD89Xl4Anv+lbMWwWk8WLdFkQ6MjPtcoFPcKOqPutGKAMRHpJjOLDZGjoyIMAIbsVYyPl29MY6fi5mvQdw9F/gBrjWazQRwmWx94fhVNQaOszr+NzYTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECBDC339;
	Mon, 22 Apr 2024 05:36:59 -0700 (PDT)
Received: from arm.com (unknown [10.57.76.213])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 59D983F7BD;
	Mon, 22 Apr 2024 05:36:27 -0700 (PDT)
Date: Mon, 22 Apr 2024 13:36:39 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com,
	oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 08/33] arm: realm: Make uart available
 before MMU is enabled
Message-ID: <ZiZZ17+/Br80pLLm@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-9-suzuki.poulose@arm.com>
 <ZiZQ8USVlxz0RFs3@arm.com>
 <f793a86c-2143-4db6-a2ae-a151c00a7b56@arm.com>
 <ZiZWqXUbpCXZn9z/@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiZWqXUbpCXZn9z/@arm.com>

Hi,

On Mon, Apr 22, 2024 at 01:23:05PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Mon, Apr 22, 2024 at 01:09:13PM +0100, Suzuki K Poulose wrote:
> > Hi Alexandru
> > 
> > On 22/04/2024 12:58, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > On Fri, Apr 12, 2024 at 11:33:43AM +0100, Suzuki K Poulose wrote:
> > > > From: Joey Gouly <joey.gouly@arm.com>
> > > > 
> > > > A Realm must access any emulated I/O mappings with the PTE_NS_SHARED bit set.
> > > > This is modelled as a PTE attribute, but is actually part of the address.
> > > > 
> > > > So, when MMU is disabled, the "physical address" must reflect this bit set. We
> > > > access the UART early before the MMU is enabled. So, make sure the UART is
> > > > accessed always with the bit set.
> > > > 
> > > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > ---
> > > >   lib/arm/asm/pgtable.h   |  5 +++++
> > > >   lib/arm/io.c            | 24 +++++++++++++++++++++++-
> > > >   lib/arm64/asm/pgtable.h |  5 +++++
> > > >   3 files changed, 33 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
> > > > index 350039ff..7e85e7c6 100644
> > > > --- a/lib/arm/asm/pgtable.h
> > > > +++ b/lib/arm/asm/pgtable.h
> > > > @@ -112,4 +112,9 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
> > > >   	return pte_offset(pmd, addr);
> > > >   }
> > > > +static inline unsigned long arm_shared_phys_alias(void *x)
> > > > +{
> > > > +	return ((unsigned long)(x) | PTE_NS_SHARED);
> > > > +}
> > > 
> > > Is it allowed for a realm to run in aarch32 mode?
> > 
> > No. Realm EL1 must be Aarch64.
> 
> Ok, then can you make the above function return the original address?
> 
> > 
> > > 
> > > > +
> > > >   #endif /* _ASMARM_PGTABLE_H_ */
> > > > diff --git a/lib/arm/io.c b/lib/arm/io.c
> > > > index 836fa854..127727e4 100644
> > > > --- a/lib/arm/io.c
> > > > +++ b/lib/arm/io.c
> > > > @@ -15,6 +15,8 @@
> > > >   #include <asm/psci.h>
> > > >   #include <asm/spinlock.h>
> > > >   #include <asm/io.h>
> > > > +#include <asm/mmu-api.h>
> > > > +#include <asm/pgtable.h>
> > > >   #include "io.h"
> > > > @@ -30,6 +32,24 @@ static struct spinlock uart_lock;
> > > >   static volatile u8 *uart0_base = UART_EARLY_BASE;
> > > >   bool is_pl011_uart;
> > > > +static inline volatile u8 *get_uart_base(void)
> > > > +{
> > > > +	/*
> > > > +	 * The address of the UART base may be different
> > > > +	 * based on whether we are running with/without
> > > > +	 * MMU enabled.
> > > > +	 *
> > > > +	 * For realms, we must force to use the shared physical
> > > > +	 * alias with MMU disabled, to make sure the I/O can
> > > > +	 * be emulated.
> > > > +	 * When the MMU is turned ON, the mappings are created
> > > > +	 * appropriately.
> > > > +	 */
> > > > +	if (mmu_enabled())
> > > > +		return uart0_base;
> > > > +	return (u8 *)arm_shared_phys_alias((void *)uart0_base);
> > > > +}
> > > > +
> > > >   static void uart0_init_fdt(void)
> > > >   {
> > > >   	/*
> > > > @@ -109,9 +129,11 @@ void io_init(void)
> > > >   void puts(const char *s)
> > > >   {
> > > > +	volatile u8 *uart_base = get_uart_base();
> 
> Is it just my email client or is the indentation missing here?
> 
> > > > +
> > > >   	spin_lock(&uart_lock);
> > > >   	while (*s)
> > > > -		writeb(*s++, uart0_base);
> > > > +		writeb(*s++, uart_base);
> > > >   	spin_unlock(&uart_lock);
> > > >   }
> > > > diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
> > > > index 5b9f40b0..871c03e9 100644
> > > > --- a/lib/arm64/asm/pgtable.h
> > > > +++ b/lib/arm64/asm/pgtable.h
> > > > @@ -28,6 +28,11 @@ extern unsigned long prot_ns_shared;
> > > >   */
> > > >   #define PTE_NS_SHARED		(prot_ns_shared)
> > > > +static inline unsigned long arm_shared_phys_alias(void *addr)
> > > > +{
> > > > +	return ((unsigned long)addr | PTE_NS_SHARED);
> > > > +}
> > > 
> > > Have you considered specifying the correct UART address at compile time using
> > > ./configure --earlycon?
> > 
> > Do you mean
> > 
> > ./configure --earlycon=<NS-Alias-normal-UART-Address> for Realms ?
> > 
> > If so, there are multiple issues with that :
> > 
> > 1. A payload could be run in a normal VM or a Realm VM. Having the above
> > restricts using the same payload in different worlds. (e.g., comparison).
> > 
> > 2. The IPA width of the Realm and thus the PTE_NS_SHARED is dynamic
> > and really depends on what the VMM decides to choose the IPA size.
> > (Could be based on user input).
> 
> Does it depend on the chosen IPA size, or on the VA size, or on both?
> Because uart0_base is used with both the MMU on and off.

Oh, ok, my bad, I hadn't realized that the uart address is modified only if the
MMU is not enabled. So it's actually only the IPA that must have the bit set.

I have to say that a PTE attribute, as it is called in the commit message, which
has a variable bit position that depends on the output address size is quite
surprising. I was under the impression that the bit position is constant when I
made the suggestion.

Yeah, it makes sense to have a helper to set the bit based on whether or not the
MMU is enabled.

Thanks,
Alex

> 
> Thanks,
> Alex
> 
> > 
> > If any of the above fails, and a wrong earlycon address could result
> > in "Synchronouse External Abort" into the Realm (if it is in protected
> > IPA).
> > 
> > Suzuki
> > > 
> > > Thanks,
> > > Alex
> > > > +
> > > >   /*
> > > >    * Highest possible physical address supported.
> > > >    */
> > > > -- 
> > > > 2.34.1
> > > > 
> > 
> 

