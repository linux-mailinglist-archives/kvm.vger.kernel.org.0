Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541633B2474
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 03:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFXBUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 21:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFXBUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 21:20:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46275C061574;
        Wed, 23 Jun 2021 18:18:33 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624497511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l8alYlJ/aC0q6Bux+3r/DpEUt8CzurFkdXS4F7DcxVI=;
        b=z3LmLaVtyuGn+lmaBRc4qrfYhyIqCoRAopORFutB0XdZT946mxJPmu6S6T+CLZkji53l0S
        PJ7Rb8HsiqbYcuHKdmwG2eJyi0wdg/9g5uMpttMHqw86YEDv04z7ZBZvHeycWVI67cIhPh
        JM7E9SYilTTh7BoC96HHv9/H2+MKJYIYvhyS3yrI23bEFgKy/S9Zg5oIwupVvp4EsKBgfq
        pc/pcL44EC49ML3Wx3/R+gW2rZw1dEceW4/kKnYnpMCfQ+NbQT/VsWYwuhorveAC6IMU6X
        CinQwe7jw9v2jqXUYCARuSK5S6qP3D3WEUmmQPx1yz3XeeIH3CXXNx1T7bdjwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624497511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l8alYlJ/aC0q6Bux+3r/DpEUt8CzurFkdXS4F7DcxVI=;
        b=h2l5tdIdZ5vItC7muztVNSqWBsJ9hr23CnBq0yPWyarCsoucn1qzKL7+Q7y+uBXJH9OW/q
        WCb0tm4A5U3R9KBA==
To:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: RE: Virtualizing MSI-X on IMS via VFIO
In-Reply-To: <MWHPR11MB1886BB017C6C53A8061DDEE28C089@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <MWHPR11MB1886811339F7873A8E34549A8C089@MWHPR11MB1886.namprd11.prod.outlook.com> <87bl7wczkp.ffs@nanos.tec.linutronix.de> <MWHPR11MB1886BB017C6C53A8061DDEE28C089@MWHPR11MB1886.namprd11.prod.outlook.com>
Date:   Thu, 24 Jun 2021 03:18:31 +0200
Message-ID: <87tuloawm0.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin!

On Wed, Jun 23 2021 at 23:37, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> > Curious about irte entry when IRQ remapping is enabled. Is it also
>> > allocated at request_irq()?
>> 
>> Good question. No, it has to be allocated right away. We stick the
>> shutdown vector into the IRTE and then request_irq() will update it with
>> the real one.
>
> There are max 64K irte entries per Intel VT-d. Do we consider it as
> a limited resource in this new model, though it's much more than
> CPU vectors?

It's surely a limited resource. For me 64k entries seems to be plenty,
but what do I know. I'm not a virtualization wizard.

> Back to earlier discussion about guest ims support, you explained a layered
> model where the paravirt interface sits between msi domain and vector
> domain to get addr/data pair from the host. In this way it could provide
> a feedback mechanism for both msi and ims devices, thus not specific
> to ims only. Then considering the transition window where not all guest
> OSes may support paravirt interface at the same time (or there are
> multiple paravirt interfaces which takes time for host to support all), 
> would below staging approach still makes sense?
>
> 1)  Fix the lost interrupt issue in existing MSI virtualization flow;

That _cannot_ be fixed without a hypercall. See my reply to Alex.

> 2)  Virtualize MSI-X on IMS, bearing the same request_irq() problem;

That solves what? Maybe your perceived roadmap problem, but certainly
not any technical problem in the right way. Again: See my reply to Alex.

> 3)  Develop a paravirt interface to solve request_irq() problem for
>     both msi and ims devices;

First of all it's not a request_irq() problem: It's a plain resource
management problem which requires proper interaction between host and
guest.

And yes, it _is_ the correct answer to the problem and as I outlined in
my reply to Alex already it is _not_ rocket science and it won't make a
significant difference on your timeline because it's straight forward
and solves the problem properly with the added benefit to solve existing
problems which should and could have been solved long ago.

I don't care at all about the time you are wasting with half baken
thoughts about avoiding to do the right thing, but I very much care
about my time wasted to debunk them.

Thanks,

        tglx
