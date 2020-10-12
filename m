Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ED728B1A5
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 11:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgJLJdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 05:33:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44042 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLJdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 05:33:15 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602495192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JSsfdVS/IXadTB6/3l+nuddk+n+p1R2MMBOm9Inb64s=;
        b=H3HlfgaQNs8IPvfPMYH0nPsaTXtZqh/iGC4VBnqHO6UbChs4028O8I4kPkrLn6BwOHbfeW
        4EETQsPdvWPyxnwi+8IkXLKPsPJTCevNtdQe4Cbst+mGduYia1fMmrhbxdqxEecDXyg4cI
        xp1m7uSgI2V6+xAtiDaD3P+uhzTB7kO7uPUbPs/BsZscHSapHHYlNGQGXmSWOoz9QyaWau
        /W/ISRBEFZt8X/lyZJyXJLQSaHCpCnFKbA3NTnRibkHVqzrDocGEGD76a6TOx8mHU9tjTR
        lQuHByo+qp7qyEj9L6HHNqed7DXv902hkwf1YogblQLsT5rNgDiUSqAkWUyK+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602495192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JSsfdVS/IXadTB6/3l+nuddk+n+p1R2MMBOm9Inb64s=;
        b=pdch0IHL06sUes3CadNLSh1RGp6TomTF8WLrXtqVOqDHAuHlizNeespRoVIoxDHIWDGKZW
        N6FYVdl1q3C9e6Aw==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
In-Reply-To: <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de> <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org> <87pn5or8k7.fsf@nanos.tec.linutronix.de> <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
Date:   Mon, 12 Oct 2020 11:33:11 +0200
Message-ID: <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 11 2020 at 22:15, David Woodhouse wrote:
> On 11 October 2020 18:12:08 BST, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Sat, Oct 10 2020 at 12:58, David Woodhouse wrote:
>>> On 10 October 2020 12:44:10 BST, Thomas Gleixner <tglx@linutronix.de>
>> wrote:
>>> Yeah. There's some muttering to be done for HPET about whether it's
>>> *its* MSI domain or whether it's the parent domain. But I'll have a
>>> play. I think we'll be able to drop the whole
>>> irq_remapping_get_irq_domain() thing.
>>
>> That would be really nice.
>
> I can make it work for HPET if I fix up the point at which the IRQ
> remapping code registers a notifier on the platform bus. (At IRQ remap
> setup time is too early; when it registers the PCI bus notifier is too
> late.)
>
> IOAPIC is harder though as the platform bus doesn't even exist that
> early. Maybe an early platform bus is possible but it would have to
> turn out particularly simple to do, or I'd need to find another use
> case too, to justify it. Will continue to play....

You might want to look into using irq_find_matching_fwspec() instead for
both HPET and IOAPIC. That needs a select() callback implemented in the
remapping domains.

>> I go over it in the next days once more and stick it into my devel tree
>> until rc1. Need to get some conflicts sorted with that Device MSI
>> stuff.
>
> While playing with HPET I noticed I need
> s/CONFIG_PCI_MSI/CONFIG_IRQ_GENERIC_MSI/ where the variables are
> declared at the top of msi.c to match the change I made later on. Can
> post v3 of the series or you can silently fix it up as you go; please
> advise.

I think I might be able to handle that on my own :)

Thanks,

        tglx
