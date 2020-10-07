Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF2228604D
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 15:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgJGNhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 09:37:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43720 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgJGNhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 09:37:42 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602077860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZUt/fRAzcQQKkeUzrcwPraubNG6JI07bzPBHwzVZIgQ=;
        b=HW5HXQV3gvvUAmzOgKsr4dezYeSmHLOR8iy6zUzQaUcHLGktBjwmlNLTw/6QrvMrORy72D
        Rucl3nOYVdeBElsLHa07uFtvk/M+uU5i8c3Ks0JCzdwn93FAKBjEhG1ob9iBSuyinFjI9z
        kTVvQvyEk9jgRH8QDHbAKc05Hn1/GfoPr0j4rz6XWX3kajMnUvWYZnXNN3DCdcTqMaB1Rn
        GbQ1Ij2qXUU7/JDFz1WKh9TJmczHRhynpKVFsHA+TXbRnxxZRpLZCpXplcDbmmlhwqwdGr
        s7/6ezwliI21q0gPxk592Y0jsMwQhZpYLSMLG3DET8eMJkeSbSkmgw6Zi2l+fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602077860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZUt/fRAzcQQKkeUzrcwPraubNG6JI07bzPBHwzVZIgQ=;
        b=MKTe4LJhkKRejWCeZylCr0cq7MMOKpAD+4goDzh+miVH4LV7POjXNqtUtN6NikIW1rl+sW
        p69rlmKsnBdzuYCQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
In-Reply-To: <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org> <87lfgj59mp.fsf@nanos.tec.linutronix.de> <75d79c50d586c18f0b1509423ed673670fc76431.camel@infradead.org>
Date:   Wed, 07 Oct 2020 15:37:39 +0200
Message-ID: <87tuv640nw.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 08:19, David Woodhouse wrote:
> On Tue, 2020-10-06 at 23:26 +0200, Thomas Gleixner wrote:
>> On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
>> > From: David Woodhouse <dwmw@amazon.co.uk>
>> > 
>> > This is the maximum possible set of CPUs which can be used. Use it
>> > to calculate the default affinity requested from __irq_alloc_descs()
>> > by first attempting to find the intersection with irq_default_affinity,
>> > or falling back to using just the max_affinity if the intersection
>> > would be empty.
>> 
>> And why do we need that as yet another argument?
>> 
>> This is an optional property of the irq domain, really and no caller has
>> any business with that. 
>
> Because irq_domain_alloc_descs() doesn't actually *take* the domain as
> an argument. It's more of an internal function, which is only non-
> static because it's used from kernel/irq/ipi.c too for some reason. If
> we convert the IPI code to just call __irq_alloc_descs() directly,
> perhaps that we can actually make irq_domain_alloc_decs() static.

What is preventing you to change the function signature? But handing
down irqdomain here is not cutting it. The right thing to do is to
replace 'struct irq_affinity_desc *affinity' with something more
flexible.

>> >  int irq_domain_alloc_descs(int virq, unsigned int cnt, irq_hw_number_t hwirq,
>> > -			   int node, const struct irq_affinity_desc *affinity)
>> > +			   int node, const struct irq_affinity_desc *affinity,
>> > +			   const struct cpumask *max_affinity)
>> >  {
>> > +	cpumask_var_t default_affinity;
>> >  	unsigned int hint;
>> > +	int i;
>> > +
>> > +	/* Check requested per-IRQ affinities are in the possible range */
>> > +	if (affinity && max_affinity) {
>> > +		for (i = 0; i < cnt; i++)
>> > +			if (!cpumask_subset(&affinity[i].mask, max_affinity))
>> > +				return -EINVAL;
>> 
>> https://lore.kernel.org/r/alpine.DEB.2.20.1701171956290.3645@nanos
>> 
>> What is preventing the affinity spreading code from spreading the masks
>> out to unusable CPUs? The changelog is silent about that part.
>
> I'm coming to the conclusion that we should allow unusable CPUs to be
> specified at this point, just as we do offline CPUs. That's largely
> driven by the realisation that our x86_non_ir_cpumask is only going to
> contain online CPUs anyway, and hotplugged CPUs only get added to it as
> they are brought online.

Can you please stop looking at this from a x86 only perspective. It's
largely irrelevant what particular needs x86 or virt or whatever has.

Fact is, that if there are CPUs which cannot be targeted by device
interrupts then the multiqueue affinity mechanism has to be fixed to
handle this. Right now it's just broken.

Passing yet more cpumasks and random pointers around through device
drivers and whatever is just not going to happen. Neither are we going
to have

        arch_can_be_used_for_device_interrupts_mask

or whatever you come up with and claim it to be 'generic'.

The whole affinity control mechanism needs to be refactored from ground
up and the information about CPUs which can be targeted has to be
retrievable through the irqdomain hierarchy.

Anything else is just tinkering and I have zero interest in mopping up
after you.

It's pretty obvious that the irq domains are the right place to store
that information:

const struct cpumask *irqdomain_get_possible_affinity(struct irq_domain *d)
{
        while (d) {
        	if (d->get_possible_affinity)
                	return d->get_possible_affinity(d);
                d = d->parent;
        }
        return cpu_possible_mask;
}

So if you look at X86 then you have either:

   [VECTOR] ----------------- [IO/APIC]
                          |-- [MSI]
                          |-- [WHATEVER]

or

   [VECTOR] ---[REMAP]------- [IO/APIC]
             |            |-- [MSI]
             |----------------[WHATEVER]

So if REMAP allows cpu_possible_mask and VECTOR some restricted subset
then irqdomain_get_possible_affinity() will return the correct result
independent whether remapping is enabled or not.

This allows to use that for other things like per node restrictions or
whatever people come up with, without sprinkling more insanities through
the tree.

Thanks,

        tglx
