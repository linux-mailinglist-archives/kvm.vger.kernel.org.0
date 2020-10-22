Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17E2966C0
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 23:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372437AbgJVVnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 17:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372432AbgJVVnz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 17:43:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244AFC0613CE;
        Thu, 22 Oct 2020 14:43:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603403033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=c32SKqD2QPPmQRkKDG5IckFogmrBjrqnOlEPJ34GffQ=;
        b=djSQMJvu88coa4ZnaK9g69LibWRWkd0bVkrazf5TGY3ku/NnliEgV5RIYQqddSS5O41bSB
        8MVMUf50eEzJTpgoHepJz9F05yw/FfLg5J6YFUzWf0Px/R8Az29hFA6lo9qCJPMyNZdntF
        rhlqunO69v/B/SaawC/2YQEiAW7qyQfxu5aG/cspUC8Vads5EXLlBP6Xlj/XwecshHQWzq
        eIo4vfglKAsQyQO9nRvSyMrLHptLFF3Fxm2J5NIFHc9xKQlSWp8lEH5ew/t3TvmpI+rK5P
        lT3kN4bVzZefwVb2oLeI4u2DytHlyA5FVxGxLMp1TAzuCE+tgzrs1ff5v2hwcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603403033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=c32SKqD2QPPmQRkKDG5IckFogmrBjrqnOlEPJ34GffQ=;
        b=xlNKFG/FRxX90888QEwo+jxnoVhskeS5SmseJy0OSOtvwYdaHTEmVrfehSvAP8GHBdt9E9
        1CouFj602bGhAPDg==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v2 8/8] x86/ioapic: Generate RTE directly from parent irqchip's MSI message
In-Reply-To: <20201009104616.1314746-9-dwmw2@infradead.org>
Date:   Thu, 22 Oct 2020 23:43:52 +0200
Message-ID: <87y2jy542v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09 2020 at 11:46, David Woodhouse wrote:

@@ -45,12 +45,11 @@ enum irq_alloc_type {
 };

> +static void mp_swizzle_msi_dest_bits(struct irq_data *irq_data, void *_entry)
> +{
> +	struct msi_msg msg;
> +	u32 *entry = _entry;

Why is this a void * argument and then converting it to a u32 *? Just to
make that function completely unreadable?

> +
> +	irq_chip_compose_msi_msg(irq_data, &msg);

Lacks a comment. Also mp_swizzle... is a misnomer as this invokes the
msi compose function which is not what the function name suggests.

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

Sorry, but this is unreviewable gunk. The whole msi_msg setup sucks with
this unholy macro maze. I have a half finished series which allows
architectures to provide shadow members for data, address_* so this can
be done proper with bitfields.

Aside of that it works magically because polarity,trigger and mask bit
have been set up before. But of course a comment about this is
completely overrated.

Thanks,

        tglx
