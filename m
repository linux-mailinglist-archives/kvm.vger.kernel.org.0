Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61D72D45A4
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 16:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbgLIPmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 10:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgLIPmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 10:42:13 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FC6C061793;
        Wed,  9 Dec 2020 07:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=6r9heBjzWXYJc89ySTWF0dstHk+7cI5ZT6+P8OGgWRk=; b=m+D2g1sGexb0Y8RFn4mA4QNiNl
        oDT3PmXNumeabAlzk0BkSisiByiKbz5fmEFipdVq2YGitAr55xt05Rer6S6A+ESAd9uqDYfwaKFKQ
        SJNcnXfua//C/WmH+xsop61sFpVpVMxO1fqGpdhXbxn60w/YLNhb8ZiviUQzT16S77BVBcA5dNNom
        iX0NSBQpHLzMmCEZ+aQnvBR2VYiBzfw45f1M7RZwIGVqNwf3ONWVdjKFyu6ZrzNvc57wwox65s7gk
        CXzof3lalgMWS8tZGViU8Rms39jIEoGoRHbAT/8ZTm0kKfvHG6FPtgvMJE4JaNOTkIh75+wxXwjgb
        D1xmYY5w==;
Received: from [2a01:4c8:1485:1509:f1a9:965:876e:14dd]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn1ac-00061D-Su; Wed, 09 Dec 2020 15:41:15 +0000
Date:   Wed, 09 Dec 2020 15:41:10 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <35165dbc-73d0-21cd-0baf-db4ffb55fc47@oracle.com>
References: <20190220201609.28290-1-joao.m.martins@oracle.com> <20190220201609.28290-11-joao.m.martins@oracle.com> <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org> <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com> <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org> <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com> <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org> <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org> <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com> <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org> <f7dec3f1-aadc-bda5-f4dc-7185ffd9c1a6@oracle.com> <db4ea3bd6ebec53c40526d67273ccfba38982811.camel@infradead.org> <35165dbc-73d0-21cd-0baf-db4ffb55fc47@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
To:     Joao Martins <joao.m.martins@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>, karahmed@amazon.de
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <2E57982D-6508-4850-ABA5-67592381379D@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9 December 2020 13:26:55 GMT, Joao Martins <joao=2Em=2Emartins@oracle=
=2Ecom> wrote:
>On 12/9/20 11:39 AM, David Woodhouse wrote:
>> On Wed, 2020-12-09 at 10:51 +0000, Joao Martins wrote:
>>> Isn't this what the first half of this patch was doing initially
>(minus the
>>> irq routing) ? Looks really similar:
>>>
>>>
>https://lore=2Ekernel=2Eorg/kvm/20190220201609=2E28290-11-joao=2Em=2Emart=
ins@oracle=2Ecom/
>>=20
>> Absolutely! This thread is in reply to your original posting of
>> precisely that patch, and I've had your tree open in gitk to crib
>from
>> for most of the last week=2E
>>=20
>I forgot about this patch given all the discussion so far and I had to
>re-look given that
>it resembled me from your snippet=2E But I ended up being a little
>pedantic -- sorry about that=2E

Nah, pedantry is good :)

>> At most, we just need to make sure that kvm_xen_has_interrupt()
>returns
>> false if the per-vCPU LAPIC vector is configured=2E But I didn't do
>that
>> because I checked Xen and it doesn't do it either=2E
>>=20
>Oh! I have this strange recollection that it was, when we were looking
>at the Xen
>implementation=2E

Hm, maybe I missed it=2E Will stare at it harder, although looking at Xen =
code tends to make my brain hurt :)

>> As far as I can tell, Xen's hvm_vcpu_has_pending_irq() will still
>> return the domain-wide vector in preference to the one in the LAPIC,
>if
>> it actually gets invoked=2E=20
>
>Only if the callback installed is HVMIRQ_callback_vector IIUC=2E
>
>Otherwise the vector would be pending like any other LAPIC vector=2E

Ah, right=2E

For some reason I had it in my head that you could only set the per-vCPU l=
apic vector if the domain was set to HVMIRQ_callback_vector=2E If the domai=
n is set to HVMIRQ_callback_none, that clearly makes more sense=2E

Still, my patch should do the same as Xen does in the case where a guest d=
oes set both, I think=2E

Faithful compatibility with odd Xen behaviour FTW :)

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
