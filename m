Return-Path: <kvm+bounces-14549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE9C8A3400
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EECB1C2221C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE6914BF8F;
	Fri, 12 Apr 2024 16:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eprr8eHH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15382C60;
	Fri, 12 Apr 2024 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940356; cv=none; b=MdKkActTwF4aWx4kHz17qCdeZts7zAU34tN/kttVviS4PSDsXSRiDezfWtF4YGPOiwO6Cc93U4vYJvFWu3BMLCXKteXCIUAXFZB+WZ8fbEJQxqGRSduO2QbuvLgxhXPaDgTmoLjBIGgIEF/CTvoz4BkoPLBaTGsiduwCzkv7MyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940356; c=relaxed/simple;
	bh=oM4DdzknAHFnE6mRuMA2wl+932rmGVqLnvyBIg43hbc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+ZmpnfGR6aadpdNn/7XUECc/SDT/3wUuM1/CzEKJqK2OJu3u1mO/r1R9VvXwOAml68zt77IJcKwTzRGa55IirLWM5lnt44ElfhZEqsCqYY3cPU1xOtMu9gAXntcj0CjAU8i3R6aw9qz0D53uUysA5tpVqONyTLyeFuB119w1fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eprr8eHH; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712940354; x=1744476354;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oM4DdzknAHFnE6mRuMA2wl+932rmGVqLnvyBIg43hbc=;
  b=eprr8eHHXXfXFNLW7WEPRihqPXeZ+MnbX26R5Y2Ami0pBpVSEkkWBtLD
   d8tSf7J6XlPHraEYbXrJ1vjBq4SrDRBOqSy8+TcUTaWdsZY5+JO9UVv1M
   zjzwefHLrMk4fTGgQpRtOsGT6mZcj3QL2cy70nQn4AYBMt1+LkPL6yMzf
   glaIqLU3PyoOjQLx7EcGF0H5xLO0zgmY0wcrx5MjvDPOh/8h9kT2xB2Pl
   sUX11YmQYFYi/e4ZDz5sEpYvqGlSw0KpS6AzH0pZYGcG0F9l5BA5yw2Sj
   yOjsRTsWtw+WA1qB2qd2rGLLJLQTUd+bq7dH7ikkNS6ZJt/ZsBA4zflCe
   Q==;
X-CSE-ConnectionGUID: AEZOwvMMReqMTNOKKeR0qA==
X-CSE-MsgGUID: i8LM4LpyRSuftY+9GQZDmg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8579705"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="8579705"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 09:45:53 -0700
X-CSE-ConnectionGUID: 80Tnr3S/TTO8zdcQeBQRVg==
X-CSE-MsgGUID: 0APbk5XIQdKfqoIoV9mNrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21703737"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.54.39.125])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 09:45:52 -0700
Date: Fri, 12 Apr 2024 09:50:22 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, Thomas Gleixner <tglx@linutronix.de>, Lu Baolu
 <baolu.lu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Hansen, Dave" <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H.
 Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
 <ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, Robin Murphy
 <robin.murphy@arm.com>, "jim.harris@samsung.com" <jim.harris@samsung.com>,
 "a.manzanares@samsung.com" <a.manzanares@samsung.com>, Bjorn Helgaas
 <helgaas@kernel.org>, "Zeng, Guang" <guang.zeng@intel.com>,
 "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
 jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v2 07/13] x86/irq: Factor out calling ISR from
 common_interrupt
Message-ID: <20240412095022.592508c9@jacob-builder>
In-Reply-To: <BN9PR11MB52769DCDF70B551FCFF22DC58C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
	<20240405223110.1609888-8-jacob.jun.pan@linux.intel.com>
	<BN9PR11MB52769DCDF70B551FCFF22DC58C042@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Kevin,

On Fri, 12 Apr 2024 09:21:45 +0000, "Tian, Kevin" <kevin.tian@intel.com>
wrote:

> > From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Sent: Saturday, April 6, 2024 6:31 AM
> > 
> > Prepare for calling external IRQ handlers directly from the posted MSI
> > demultiplexing loop. Extract the common code with common interrupt to
> > avoid code duplication.
> > 
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> >  arch/x86/kernel/irq.c | 23 ++++++++++++++---------
> >  1 file changed, 14 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index f39f6147104c..c54de9378943 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> > @@ -242,18 +242,10 @@ static __always_inline void handle_irq(struct
> > irq_desc *desc,
> >  		__handle_irq(desc, regs);
> >  }
> > 
> > -/*
> > - * common_interrupt() handles all normal device IRQ's (the special SMP
> > - * cross-CPU interrupts have their own entry points).
> > - */
> > -DEFINE_IDTENTRY_IRQ(common_interrupt)
> > +static __always_inline void call_irq_handler(int vector, struct
> > pt_regs *regs) {
> > -	struct pt_regs *old_regs = set_irq_regs(regs);
> >  	struct irq_desc *desc;
> > 
> > -	/* entry code tells RCU that we're not quiescent.  Check it. */
> > -	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up
> > RCU");
> > -
> >  	desc = __this_cpu_read(vector_irq[vector]);
> >  	if (likely(!IS_ERR_OR_NULL(desc))) {
> >  		handle_irq(desc, regs);  
> 
> the hidden lines has one problem:
> 
> 	} else {
> 		apic_eoi();
> 
> 		if (desc == VECTOR_UNUSED) {
> 			...
> 
> there will be two EOI's for unused vectors, adding the one
> in sysvec_posted_msi_notification().

Indeed this unlikely case could cause lost interrupt. Imagine we have:

- IDT vector N (MSI notification), O, and P (other high-priority
system vectors).
- Device MSI vector A which triggers N.

Action 			APIC IRR		APIC ISR
---------------------------------------------------------
Device MSI A		N
APIC accepts N		-			N
New IRQs arrive		O,P			N
handle_irq(A)
eoi() due to A's fault	-			O,P
eoi in post_msi		-			P
----------------------------------------------------------
The second EOI clears ISR for vector O but missed processing it.


Intel SDM 11.8.4 for background.
"The IRR contains the active interrupt requests that have been accepted,
but not yet dispatched to the processor for servicing. When the local APIC
accepts an interrupt, it sets the bit in the IRR that corresponds the
vector of the accepted interrupt. When the processor core is ready to
handle the next interrupt, the local APIC clears the highest priority IRR
bit that is set and sets the corresponding ISR bit. The vector for the
highest priority bit set in the ISR is then dispatched to the processor
core for servicing.

While the processor is servicing the highest priority interrupt, the local
APIC can send additional fixed interrupts by setting bits in the IRR. When
the interrupt service routine issues a write to the EOI register (see
Section 11.8.5, Signaling Interrupt Servicing Completion), the local APIC
responds by clearing the highest priority ISR bit that is set. It then
repeats the process of clearing the highest priority bit in the IRR and
setting the corresponding bit in the ISR. The processor core then begins
executing the service routing for the highest priority bit set in the ISR
"

I need to avoid the duplicated EOI in this case and at minimum cost for the
hot path.

Thanks,

Jacob

