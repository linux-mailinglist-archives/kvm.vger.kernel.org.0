Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E294028AAA6
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbgJKVPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Oct 2020 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387457AbgJKVP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Oct 2020 17:15:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EC6C0613CE;
        Sun, 11 Oct 2020 14:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=HaNvNJNqShxRibbaAVJtLOGl045COY2jHpkwhNWQ1O8=; b=r8zg1sCeWkNKE7gc7C+e+At4lA
        bdH0jciNm36VvbZ6MEuKXmbGcb8NaOaAQD3vfDn30e6roeFhDmvCz2AXFfYxZ8YMpCK4xKnYSCcG/
        m35HTKIOvnsjNQoAXnWPEkKlgr/Ob8DCkeQLdh44yx/enLT8fSA8ttHEN1iwgXT9caFJOki3c1uyR
        2xPfeg4UQqy17CHYPbYOQwH8B/9kRe5C58LYSG2F6KsDMwFQAzXf6DJRH98IXEt/0PilDDw8Jx8pF
        wxgvCahUwzEbaAw2m0whT9IDFgRDdE97DQzjnEy/nBQ23oYBbT8EkO/tPsYr+TbVI0Q/TPpxzVCVl
        j8FhJB8Q==;
Received: from [2001:8b0:10b:1:ad95:471b:fe64:9cc3]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRigX-0002Jt-Hz; Sun, 11 Oct 2020 21:15:18 +0000
Date:   Sun, 11 Oct 2020 22:15:13 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <87pn5or8k7.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org> <20201007122046.1113577-1-dwmw2@infradead.org> <20201007122046.1113577-5-dwmw2@infradead.org> <87blhcx6qz.fsf@nanos.tec.linutronix.de> <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org> <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org> <87362owhcb.fsf@nanos.tec.linutronix.de> <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org> <87tuv4uwmt.fsf@nanos.tec.linutronix.de> <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org> <874kn2s3ud.fsf@nanos.tec.linutronix.de> <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org> <87pn5or8k7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11 October 2020 18:12:08 BST, Thomas Gleixner <tglx@linutronix=2Ede> wr=
ote:
>On Sat, Oct 10 2020 at 12:58, David Woodhouse wrote:
>> On 10 October 2020 12:44:10 BST, Thomas Gleixner <tglx@linutronix=2Ede>
>wrote:
>>>On Sat, Oct 10 2020 at 11:06, David Woodhouse wrote:
>
>>>> The IRQ remapping drivers already plug into the device-add notifier
>>>> and can fill in the appropriate MSI domain just like they do=C2=B9 fo=
r
>>>> PCI and ACPI devices=2E
>>>> Using platform_add_bundle() for HPET looks trivial enough; I'll
>have
>>>> a play with that and then do IOAPIC too if/when the initialisation
>>>> order and hotplug handling all works out OK to install the correct
>>>> msi_domain=2E
>>>
>>> Yes, I was wondering about that when I made PCI at least use that
>>> mechanism, but had not had time to actually look at it=2E
>>
>> Yeah=2E There's some muttering to be done for HPET about whether it's
>> *its* MSI domain or whether it's the parent domain=2E But I'll have a
>> play=2E I think we'll be able to drop the whole
>> irq_remapping_get_irq_domain() thing=2E
>
>That would be really nice=2E

I can make it work for HPET if I fix up the point at which the IRQ remappi=
ng code registers a notifier on the platform bus=2E (At IRQ remap setup tim=
e is too early; when it registers the PCI bus notifier is too late=2E)

IOAPIC is harder though as the platform bus doesn't even exist that early=
=2E Maybe an early platform bus is possible but it would have to turn out p=
articularly simple to do, or I'd need to find another use case too, to just=
ify it=2E Will continue to play=2E=2E=2E=2E

>> Either way, it's a separate cleanup and the 15-bit APIC ID series I
>> posted yesterday should be fine as it is=2E
>
>I go over it in the next days once more and stick it into my devel tree
>until rc1=2E Need to get some conflicts sorted with that Device MSI
>stuff=2E

While playing with HPET I noticed I need s/CONFIG_PCI_MSI/CONFIG_IRQ_GENER=
IC_MSI/ where the variables are declared at the top of msi=2Ec to match the=
 change I made later on=2E Can post v3 of the series or you can silently fi=
x it up as you go; please advise=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
