Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1438A285F9C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgJGM7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 08:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbgJGM7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 08:59:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12350C061755;
        Wed,  7 Oct 2020 05:59:03 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602075541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUlXpRcdjDMd7cwhwzUEPO97AvYbTkCdBAMwSiAXy90=;
        b=ygQhpekbSZb+0bHmfd9+EwqUEQHh2ATtKLZJUgxN2aZRx+vibKErUl+OB+IclL9e2CLvJJ
        BFSj/tzbVFvPm9AW1U+wVwxqIN11eTmbpA18ZEmvaGjBUIKdyJIIFRY4G+8fgc6gjmoaYv
        JtJLCupbyM/ps8yAN3x96nYDbL6n+Ia/91H+tBfth4P9J2RQDGPPEEA2nqpoMzK+LpyEw9
        HHaz3U+2iXrpKcNnUFsjXpMgY2sfDv0eIp8y98+fqD1NDA0ABNj/n6Hmwe79tG5UdSz3UQ
        Z9XYgDNwJsD+NrGHCaYXoSMoSa0ZOcghpNg/5fFouxyYXvGsjh1KK02bJzxZrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602075541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jUlXpRcdjDMd7cwhwzUEPO97AvYbTkCdBAMwSiAXy90=;
        b=dz/tx+RV0UESDPh1neqXFJC7LRS0By4Wn08o1mSZYG5vCaBGEwri/Rk7HvtoDSyFYsQIb1
        Gv4NHE4xTe+gkvCA==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 10/13] x86/irq: Limit IOAPIC and MSI domains' affinity without IR
In-Reply-To: <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-10-dwmw2@infradead.org> <87d01v58bw.fsf@nanos.tec.linutronix.de> <d34efce9ca5a4a9d8d8609f872143e306bf5ee98.camel@infradead.org>
Date:   Wed, 07 Oct 2020 14:59:00 +0200
Message-ID: <874kn65h0r.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 07 2020 at 08:48, David Woodhouse wrote:
> On Tue, 2020-10-06 at 23:54 +0200, Thomas Gleixner wrote:
>> On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
> This is the case I called out in the cover letter:
>
>     This patch series implements a per-domain "maximum affinity" set and
>     uses it for the non-remapped IOAPIC and MSI domains on x86. As well as
>     allowing more CPUs to be used without interrupt remapping, this also
>     fixes the case where some IOAPICs or PCI devices aren't actually in
>     scope of any active IOMMU and are operating without remapping.
>
> To fix *that* case, we really do need the whole series giving us per-
> domain restricted affinity, and to use it for those MSIs/IOAPICs that
> the IRQ remapping doesn't cover.

Which do not exist today.

>> >  	ip->irqdomain->parent = parent;
>> > +	if (parent == x86_vector_domain)
>> > +		irq_domain_set_affinity(ip->irqdomain, &x86_non_ir_cpumask);
>> 
>> OMG
>
> This IOAPIC function may or may not be behind remapping.

>> >  		d->flags |= IRQ_DOMAIN_MSI_NOMASK_QUIRK;
>> > +		irq_domain_set_affinity(d, &x86_non_ir_cpumask);
>> 
>> So here it's unconditional
>
> Yes, this code is only for the non-remapped case and there's a separate
> arch_create_remap_msi_irq_domain() function a few lines further down
> which creates the IR-PCI-MSI IRQ domain. So no need for a condition
> here.
>
>> > +	if (parent == x86_vector_domain)
>> > +		irq_domain_set_affinity(d, &x86_non_ir_cpumask);
>> 
>> And here we need a condition again. Completely obvious and reviewable - NOT.
>
> And HPET may or may not be behind remapping so again needs the
> condition. I had figured that part was fairly obvious but can note it
> in the commit comment.

And all of this is completely wrong to begin with.

The information has to property of the relevant irq domains and the
hierarchy allows you nicely to retrieve it from there instead of
sprinkling this all over the place.

Thanks,

        tglx
