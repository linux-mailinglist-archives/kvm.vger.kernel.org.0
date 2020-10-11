Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3339A28A876
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388269AbgJKRML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 13:12:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39752 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbgJKRML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 13:12:11 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602436329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGag+uiqb/LGv/l0AA6JDsfzfRJnBglwKI/AjMPRXoY=;
        b=uq8zJ61Ut/9czRp3JdqW4G3m8ksX8GS3+WskWgRinSZnYRDlU3xjBzSfNmHFlJZNqKpD0n
        laCvZ1BgWRQUlZWJIXfDVWUmZSYahqnm3kBT0jWRWdXEe0Eb3nWiZ70iFpMxf8Y0mnZw90
        OGy1kKLWiO67EdO2LRskzjf/VtdmXf8E61O/EUiNYpFC315aj2yqExB+/+3VdJdY54z7uK
        iyKTfEsxQ8xbI8P6as3vR7gGOouu667h5bzCn56frjHnYf7zpnB725ku+Yi1mjboqqbVNk
        9P1e+IH7S2uPo8NJMbmz3twlCriRNo0F3glV6UVYNkCuiE+vy3tVyMXwbO58KQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602436329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGag+uiqb/LGv/l0AA6JDsfzfRJnBglwKI/AjMPRXoY=;
        b=WY5DKdIbrXfo8t+NmA9ppRR9SZznzPu7hyLknc3RQfjiVq2AObl7lila7aypUxLFuuac+Q
        07yWqk1/hQGkRZDA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de> <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
Date:   Sun, 11 Oct 2020 19:12:08 +0200
Message-ID: <87pn5or8k7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 10 2020 at 12:58, David Woodhouse wrote:
> On 10 October 2020 12:44:10 BST, Thomas Gleixner <tglx@linutronix.de> wro=
te:
>>On Sat, Oct 10 2020 at 11:06, David Woodhouse wrote:

>>> The IRQ remapping drivers already plug into the device-add notifier
>>> and can fill in the appropriate MSI domain just like they do=C2=B9 for
>>> PCI and ACPI devices.
>>> Using platform_add_bundle() for HPET looks trivial enough; I'll have
>>> a play with that and then do IOAPIC too if/when the initialisation
>>> order and hotplug handling all works out OK to install the correct
>>> msi_domain.
>>
>> Yes, I was wondering about that when I made PCI at least use that
>> mechanism, but had not had time to actually look at it.
>
> Yeah. There's some muttering to be done for HPET about whether it's
> *its* MSI domain or whether it's the parent domain. But I'll have a
> play. I think we'll be able to drop the whole
> irq_remapping_get_irq_domain() thing.

That would be really nice.

> Either way, it's a separate cleanup and the 15-bit APIC ID series I
> posted yesterday should be fine as it is.

I go over it in the next days once more and stick it into my devel tree
until rc1. Need to get some conflicts sorted with that Device MSI stuff.

Thanks,

        tglx


