Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF82978D8
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 23:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756662AbgJWV2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 17:28:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56114 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756653AbgJWV2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 17:28:09 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603488486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRsCGgPj6oaOlEpNqefwc9WDPJyrSLzsLSaAwliNN2I=;
        b=3p0nbOBGxe0SBCoUmm25j9PVBmg6/i74e1kBg9lRU+sAIoC2oAaQEPRfYF5ptWwRxEJz7O
        Hkf68ZcjUISI5wjUX4Xu4Y8l1vEVKjoXBF43GMlxm6Kot+VB6KChCjxE3gvQFe+B4gLR/D
        8Td0gwJHuZBWD4xmHac7461yZNorIsWvRJkzRqgZsDz5iKZXBpr0mxk0qa95gRmjbAxnlx
        XIGDeUXtF/diwoQOjuaSiX3w4fjiNF3ZX0N+g0uZehyGQjrptIk7KzUEQzsqu7jnlttVdC
        SxSuhACWG6rJLb3qLg1jkZ2KAvVMKlL9hd2kzN0OUqb/JcQwi7LuUZxg2c21mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603488486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cRsCGgPj6oaOlEpNqefwc9WDPJyrSLzsLSaAwliNN2I=;
        b=XAkuVItq5M6DS6P5v/jbIzYBpMNq/82paVkxjtYcrCX1JdAa+OLRfKFW6uiNNjat/7X+V8
        0sM12dbueHfp49Aw==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent irqchip's MSI message
In-Reply-To: <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org>
References: <87y2jy542v.fsf@nanos.tec.linutronix.de> <C53CAD52-38F8-47D7-A5BE-4F470532EF20@infradead.org>
Date:   Fri, 23 Oct 2020 23:28:05 +0200
Message-ID: <87d01863a2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 23 2020 at 11:10, David Woodhouse wrote:
> On 22 October 2020 22:43:52 BST, Thomas Gleixner <tglx@linutronix.de> wrote:
> It makes the callers slightly more readable, not having to cast to uint32_t* from the struct.
>
> I did ponder defining a new struct with bitfields named along the
> lines of 'msi_addr_bits_19_to_4', but that seemed like overkill.

I did something like this in the meantime, because all of this just
sucks.

  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git x86/apic

Hot of the press and completely untested.

>>> +	/*
>>> +	 * They're in a bit of a random order for historical reasons, but
>>> +	 * the IO/APIC is just a device for turning interrupt lines into
>>> +	 * MSIs, and various bits of the MSI addr/data are just swizzled
>>> +	 * into/from the bits of Redirection Table Entry.
>>> +	 */
>>> +	entry[0] &= 0xfffff000;
>>> +	entry[0] |= (msg.data & (MSI_DATA_DELIVERY_MODE_MASK |
>>> +				 MSI_DATA_VECTOR_MASK));
>>> +	entry[0] |= (msg.address_lo & MSI_ADDR_DEST_MODE_MASK) << 9;
>>> +
>>> +	entry[1] &= 0xffff;
>>> +	entry[1] |= (msg.address_lo & MSI_ADDR_DEST_ID_MASK) << 12;
>>
>>Sorry, but this is unreviewable gunk.
>
> Crap. Sure, want to look at the I/OAPIC and MSI documentation and
> observe that it's just shifting bits around and "these bits go there,
> those bits go here..." but there's no magic which will make that go
> away. At some point you end up swizzling bits around with seemingly
> random bitmasks and shifts which you have to have worked out from the
> docs.

Yes, we can't avoid the bit swizzling at all. But it can be made more
readable.

> Now that I killed off the various IOMMU bits which also horrifically
> touch the RTE directly, perhaps there is more scope for faffing around
> with it differently, but it won't really change much. It's just
> urinating into the atmospheric disturbance.

Well, you can look at it this way, but I surely have better things to do
than taking pencil and paper and drawing up mappings when reading
through that code or a patch against it.

>> Aside of that it works magically because polarity,trigger and mask bit
>> have been set up before. But of course a comment about this is
>> completely overrated.
>
> Well yes, there's a lot about the I/OAPIC code which is a bit horrid
> but this patch is doing just one thing: making the bits get from
> e.g. cfg->dest_apicid and cfg->vector into the RTE in a generic
> fashion which does the right thing for IR too. Other cleanups are
> somewhat orthogonal, but yes it's a good spot that one of these was
> somewhat redundant in the first place. We could fix that up in a
> separate patch which comes first perhaps.

Yes, that code is horrid, but adding a comment to that effect when
changing it is not asked too much, right?

> If we're starting to clean up I/OAPIC code I'd like to take a long
> hard look at the level ack code paths, and the fact that we have
> separate ack_apic_irq and apic_ack_irq functions (or something like
> that; on phone now) which do different things. Perhaps the order (or
> the capitals on APIC which one of them has) makes it sane and
> meaningful for them both to exist and do different things?

The naming conventions are definitely not sane.

> I also note the Hyper-V "remapping" takes the IR code path and I'm not
> sure that's OK. Because of the complete lack of overall documentation
> on what it's all doing and why.

I stared into that today as well. There is a fundamental difference
between real hardware remapping and this.

Especially the affinity setting mode changes with remapping and hyper-v
goes into the remap path, but that hyperv driver does not issue
"irq_set_status_flags(virq, IRQ_MOVE_PCNTXT)", which means that you
can't change the affinity of the I/O-APIC interrupts in that hyperv mode
at all.

If that flag is not set then affinity changes are done in actual
interrupt context in ioapic_ack_level() which is only used for the
non-IR chip ...

I'm still wrapping my head around getting rid of this thing completely
because now it's just a subset of your KVM case with the only
restriction that I/O-APIC cannot be affined to any CPU with a APIC id
greater than 255.

Thanks,

        tglx
