Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B261E287DB5
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 23:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgJHVOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 17:14:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52952 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgJHVOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 17:14:30 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602191668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmLeNZlnV7ehVAVhnHCb2FaMBjRQs76k2/xo1iDM6Vg=;
        b=hD1GAF6+KK2bameAjzzJ7TC3vtVsb89mmEBVTf/g4+gnMQc0Z3LsDMaE2Wn5oGIE3sQbj9
        LpJU6ZqrAl8XLzEU33GbN0RsY+MzMuPJ3t5B/jyhYcn6tAY0zTXFmdVC6AXT72ITm+V233
        Af8qSd7vIDLoGGwELr8hfxlKY3DQNWVX0qEArk/WavJ+L5L1fmC2o36VwllwIrHCwUcLhW
        ESctOmKrjXoBsM0JaHs/L7ktbzGqwzrXX5AxTTZqSicH/j9QuWNhnAJXcVOksLWIlkifAF
        nXBGH3ITpZTbjZ2EYNSyf8DYp6fmw8+ZS4vU358Ai20uTKsozUM7rgrJUvKBtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602191668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BmLeNZlnV7ehVAVhnHCb2FaMBjRQs76k2/xo1iDM6Vg=;
        b=IsxncIH0tg45i0pg2oKWmoW1Z58Z/AWtFajrodpTsUGOjnBmdX1vhjHZ/5n5kWrQFUE+Gw
        /H++gUHzcQG8AXCA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
Date:   Thu, 08 Oct 2020 23:14:28 +0200
Message-ID: <87362owhcb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 08 2020 at 17:08, David Woodhouse wrote:
> On Thu, 2020-10-08 at 13:55 +0100, David Woodhouse wrote:
>
> (We'd want the x86_vector_domain to actually have an MSI compose
> function in the !CONFIG_PCI_MSI case if we did this, of course.)

The compose function and the vector domain wrapper can simply move to vector.c

> From 2fbc79588d4677ee1cc9df661162fcf1a7da57f0 Mon Sep 17 00:00:00 2001
> From: David Woodhouse <dwmw@amazon.co.uk>
> Date: Thu, 8 Oct 2020 15:44:42 +0100
> Subject: [PATCH 6/5] x86/ioapic: Generate RTE directly from parent irqchip's MSI
>  message
>
> The IOAPIC generates an MSI cycle with address/data bits taken from its
> Redirection Table Entry in some combination which used to make sense,
> but now is just a bunch of bits which get passed through in some
> seemingly arbitrary order.
>
> Instead of making IRQ remapping drivers directly frob the IOAPIC RTE,
> let them just do their job and generate an MSI message. The bit
> swizzling to turn that MSI message into the IOAPIC's RTE is the same in
> all cases, since it's a function of the IOAPIC hardware. The IRQ
> remappers have no real need to get involved with that.
>
> The only slight caveat is that the IOAPIC is interpreting some of
> those fields too, and it does want the 'vector' field to be unique
> to make EOI work. The AMD IOMMU happens to put its IRTE index in the
> bits that the IOAPIC thinks are the vector field, and accommodates
> this requirement by reserving the first 32 indices for the IOAPIC.
> The Intel IOMMU doesn't actually use the bits that the IOAPIC thinks
> are the vector field, so it fills in the 'pin' value there instead.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/include/asm/hw_irq.h       | 11 +++---
>  arch/x86/include/asm/msidef.h       |  2 ++
>  arch/x86/kernel/apic/io_apic.c      | 55 ++++++++++++++++++-----------
>  drivers/iommu/amd/iommu.c           | 14 --------
>  drivers/iommu/hyperv-iommu.c        | 31 ----------------
>  drivers/iommu/intel/irq_remapping.c | 19 +++-------
>  6 files changed, 46 insertions(+), 86 deletions(-)

Nice :)

> +static void mp_swizzle_msi_dest_bits(struct irq_data *irq_data, void *_entry)
> +{
> +	struct msi_msg msg;
> +	u32 *entry = _entry;
> +
> +	irq_chip_compose_msi_msg(irq_data, &msg);

Duh, for some stupid reason it never occured to me to do it that
way.

Historically the MSI compose function was part of the MSI PCI chip and I
just changed that recently when I reworked the code to make IMS support
possible.

Historical blinders are pretty sticky :(

> +	/*
> +	 * They're in a bit of a random order for historical reasons, but
> +	 * the IO/APIC is just a device for turning interrupt lines into
> +	 * MSIs, and various bits of the MSI addr/data are just swizzled
> +	 * into/from the bits of Redirection Table Entry.
> +	 */
> +	entry[0] &= 0xfffff000;
> +	entry[0] |= (msg.data & (MSI_DATA_DELIVERY_MODE_MASK |
> +				 MSI_DATA_VECTOR_MASK));
> +	entry[0] |= (msg.address_lo & MSI_ADDR_DEST_MODE_MASK) << 9;
> +
> +	entry[1] &= 0xffff;
> +	entry[1] |= (msg.address_lo & MSI_ADDR_DEST_ID_MASK) << 12;
> +}

....

>  	switch (info->type) {
>  	case X86_IRQ_ALLOC_TYPE_IOAPIC:
> -		/* Setup IOAPIC entry */
> -		entry = info->ioapic.entry;
> -		info->ioapic.entry = NULL;
> -		memset(entry, 0, sizeof(*entry));
> -		entry->vector        = index;
> -		entry->mask          = 0;
> -		entry->trigger       = info->ioapic.trigger;
> -		entry->polarity      = info->ioapic.polarity;
> -		/* Mask level triggered irqs. */
> -		if (info->ioapic.trigger)
> -			entry->mask = 1;
> -		break;
> -

Thanks for cleaning this up!

       tglx

