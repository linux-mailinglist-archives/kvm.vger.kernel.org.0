Return-Path: <kvm+bounces-3763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FE9807927
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:09:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92FC51C20B51
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDE56EB62;
	Wed,  6 Dec 2023 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="qeV8sL4N";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="wO9GqRfs"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8FDC6;
	Wed,  6 Dec 2023 12:09:19 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1701893358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dbW0vrOnX4IbvYPSelJWPZTu1xdvo3BzQO97dlKHxY=;
	b=qeV8sL4NtDdpC+v98nxJ4YFKVOOWfHp2g6n3wWz51mR3auxn6LBI0HtkY4MvRXiDWwNVoP
	wNpoHq/gBo82SQ6AAblKYvofi0cnZSmpkGq+AJgot54INj94Wsb7mnVGhhS7TWa4aBA0ro
	XZh/QZPNCZgbSR68EModhMZezBhyZYqi50JYNEbFW7YGIoxwicQc6OW327a/9s0kmYvbIt
	L6VsFYRDQfBpTt/alXFH1z9XxlwgKo6yaVs477xVLupTh6J/7Pwzlb1NcwQpJMdVuc+oN8
	98LsEDjHF5IjePvq9BSSpYXSKNgCObJMxVu8faYOVYl54tC684CMmgwiz2fObg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1701893358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dbW0vrOnX4IbvYPSelJWPZTu1xdvo3BzQO97dlKHxY=;
	b=wO9GqRfsT0j4miTOei94cHhFBtNkngyWls/haTanPD0XtoG5yo1CZiFdGQTTKhwHhkTvkZ
	+Egma6PkYZuw3mBQ==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
 <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH RFC 10/13] x86/irq: Handle potential lost IRQ during
 migration and CPU offline
In-Reply-To: <20231112041643.2868316-11-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-11-jacob.jun.pan@linux.intel.com>
Date: Wed, 06 Dec 2023 21:09:17 +0100
Message-ID: <87a5qnum8i.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
> Though IRTE modification for IRQ affinity change is a atomic operation,
> it does not guarantee the timing of IRQ posting at PID.

No acronyms please.

> considered the following scenario:
> 	Device		system agent		iommu		memory 		CPU/LAPIC
> 1	FEEX_XXXX
> 2			Interrupt request
> 3						Fetch IRTE	->
> 4						->Atomic Swap PID.PIR(vec)
> 						Push to Global Observable(GO)
> 5						if (ON*)
> 	i						done;*
> 						else
> 6							send a notification ->
>
> * ON: outstanding notification, 1 will suppress new notifications
>
> If IRQ affinity change happens between 3 and 5 in IOMMU, old CPU's PIR could
> have pending bit set for the vector being moved. We must check PID.PIR
> to prevent the lost of interrupts.

We must check nothing. We must ensure that the code is correct, right?

> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/kernel/apic/vector.c |  8 +++++++-
>  arch/x86/kernel/irq.c         | 20 +++++++++++++++++---
>  2 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
> index 319448d87b99..14fc33cfdb37 100644
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -19,6 +19,7 @@
>  #include <asm/apic.h>
>  #include <asm/i8259.h>
>  #include <asm/desc.h>
> +#include <asm/posted_intr.h>
>  #include <asm/irq_remapping.h>
>  
>  #include <asm/trace/irq_vectors.h>
> @@ -978,9 +979,14 @@ static void __vector_cleanup(struct vector_cleanup *cl, bool check_irr)
>  		 * Do not check IRR when called from lapic_offline(), because
>  		 * fixup_irqs() was just called to scan IRR for set bits and
>  		 * forward them to new destination CPUs via IPIs.
> +		 *
> +		 * If the vector to be cleaned is delivered as posted intr,
> +		 * it is possible that the interrupt has been posted but
> +		 * not made to the IRR due to coalesced notifications.

not made to?

> +		 * Therefore, check PIR to see if the interrupt was posted.
>  		 */
>  		irr = check_irr ? apic_read(APIC_IRR + (vector / 32 * 0x10)) : 0;
> -		if (irr & (1U << (vector % 32))) {
> +		if (irr & (1U << (vector % 32)) || is_pi_pending_this_cpu(vector)) {

The comment above this code clearly explains what check_irr is
about. Why would the PIR pending check have different rules? Just
because its PIR, right?

>  
> +/*
> + * Check if a given vector is pending in APIC IRR or PIR if posted interrupt
> + * is enabled for coalesced interrupt delivery (CID).
> + */
> +static inline bool is_vector_pending(unsigned int vector)
> +{
> +	unsigned int irr;
> +
> +	irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
> +	if (irr  & (1 << (vector % 32)))
> +		return true;
> +
> +	return is_pi_pending_this_cpu(vector);
> +}

Why is this outside of the #ifdef region? Just because there was space
to put it, right?

And of course we need the same thing open coded in two locations.

What's wrong with using this inline function in __vector_cleanup() too?

	if (check_irr && vector_is_pending(vector)) {
        	pr_warn_once(...);
                ....
        }

That would make the logic of __vector_cleanup() correct _AND_ share the
code.


