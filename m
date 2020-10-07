Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84452285FC3
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgJGNIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 09:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbgJGNIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 09:08:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0656C061755;
        Wed,  7 Oct 2020 06:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=MLWrFRdqNIgAposi7IkoIjLJgrHHB/ryW+Kmcpuy9RI=; b=pUn1H7J5DnVS5L3J2RCT4AwktL
        JhUzwP+tkrOwapHPyY1bbwLjCQxUMCknVqcoCG3BUEhyld71eor0C0z9DIaM92K/XszWih/M1aCn0
        +aFdgQ4vNGtkgzitqN/4OHMO3Vh6SCfcQVkonMRoOE+tllBHP/8Qp+i/8WpAm7DO0aJTTKO32utny
        D6JcPzjPGb+1BkS6Y3+F1iFQR5hogp7TEGIUDzm/zE2hKO3uRptfdNBBuBKcwMZIC7y+QEXCUYn71
        84ycEZtFnlMStpRztl3dKDKwSXXDW3LtygIW5vJgpfIH08PUh+w9BkF6FGRsd/E6XCg1wvtaSvmnX
        D4/fqEsQ==;
Received: from [2a01:4c8:1095:4638:609d:719a:b13b:be97]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQ9Ar-0005yl-0v; Wed, 07 Oct 2020 13:08:05 +0000
Date:   Wed, 07 Oct 2020 14:08:01 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <874kn65h0r.fsf@nanos.tec.linutronix.de>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org> <874kn65h0r.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <F9476D19-3D08-4CE6-A535-6C1D2E9BA88D@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7 October 2020 13:59:00 BST, Thomas Gleixner <tglx@linutronix=2Ede> wro=
te:
>On Wed, Oct 07 2020 at 08:48, David Woodhouse wrote:
>> On Tue, 2020-10-06 at 23:54 +0200, Thomas Gleixner wrote:
>>> On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
>> This is the case I called out in the cover letter:
>>
>>     This patch series implements a per-domain "maximum affinity" set
>and
>>     uses it for the non-remapped IOAPIC and MSI domains on x86=2E As
>well as
>>     allowing more CPUs to be used without interrupt remapping, this
>also
>>     fixes the case where some IOAPICs or PCI devices aren't actually
>in
>>     scope of any active IOMMU and are operating without remapping=2E
>>
>> To fix *that* case, we really do need the whole series giving us per-
>> domain restricted affinity, and to use it for those MSIs/IOAPICs that
>> the IRQ remapping doesn't cover=2E
>
>Which do not exist today=2E

Sure=2E But at patch 10/13 into this particular patch series, it *does* ex=
ist=2E

(Ignoring, for the moment, that I'm about to rewrite half the preceding pa=
tches to take a different approach)


>>> >  	ip->irqdomain->parent =3D parent;
>>> > +	if (parent =3D=3D x86_vector_domain)
>>> > +		irq_domain_set_affinity(ip->irqdomain, &x86_non_ir_cpumask);
>>>=20
>>> OMG
>>
>> This IOAPIC function may or may not be behind remapping=2E
>
>>> >  		d->flags |=3D IRQ_DOMAIN_MSI_NOMASK_QUIRK;
>>> > +		irq_domain_set_affinity(d, &x86_non_ir_cpumask);
>>>=20
>>> So here it's unconditional
>>
>> Yes, this code is only for the non-remapped case and there's a
>separate
>> arch_create_remap_msi_irq_domain() function a few lines further down
>> which creates the IR-PCI-MSI IRQ domain=2E So no need for a condition
>> here=2E
>>
>>> > +	if (parent =3D=3D x86_vector_domain)
>>> > +		irq_domain_set_affinity(d, &x86_non_ir_cpumask);
>>>=20
>>> And here we need a condition again=2E Completely obvious and
>reviewable - NOT=2E
>>
>> And HPET may or may not be behind remapping so again needs the
>> condition=2E I had figured that part was fairly obvious but can note it
>> in the commit comment=2E
>
>And all of this is completely wrong to begin with=2E
>
>The information has to property of the relevant irq domains and the
>hierarchy allows you nicely to retrieve it from there instead of
>sprinkling this all over the place=2E

No=2E This is not a property of the parent domain per se=2E Especially if =
you're thinking that we could inherit the affinity mask from the parent, th=
en twice no=2E

This is a property of the MSI domain itself, and how many bits of destinat=
ion ID the hardware at *this* level can interpret and pass on to the parent=
 domain=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
