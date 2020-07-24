Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B8F22BB13
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 02:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGXAga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 20:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgGXAga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 20:36:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B63CC0619D3;
        Thu, 23 Jul 2020 17:36:30 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595550988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/sRzv0b/bz/POqyqjoZfEPy4Nx5XjZu9PPTUOfSVGkE=;
        b=EbjD2pbE9xi9X6EuT6/rBzkOU6K3d+v/6/JJb8wA5gqm5/NAbvriX9OxDb4zpEMrgT3P1V
        8Qe43EfciXdkNx332TkQ91suJSH3eEOwHQWMu/kmgnAD/haYxa60VS00D+lYgh4/LnHCh5
        Pdp+nBV5MrcyMlYKlw5U/71XhWmdCKmP/IeBlG5roj0NsKlY71fX5VB/DO8nREQfs3QSFO
        upMIW0mFVX6JGEZITdAqxGSQWuwOn/g3zp6CNHoXEOC5i9hZC6xMdA7/xmrmEKMzFeAFYR
        ilvTG4hHwzetSB2KYExZbiXuPHjKlavYT1DS6c4tB1x3tXXyCe5/elx1N8Q0/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595550988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/sRzv0b/bz/POqyqjoZfEPy4Nx5XjZu9PPTUOfSVGkE=;
        b=AXxWb6SEOMOM8pVovKOD5jMvjWwY8VB+Vyq6cRSWK7OH06fR2JFMaPSsDA9qW3J6czD05O
        sxw3A3fEfTlP+dCg==
To:     Jason Gunthorpe <jgg@mellanox.com>, Marc Zyngier <maz@kernel.org>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <20200724001606.GR2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com> <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com> <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com> <cfb8191e364e77f352b1483c415a83a5@kernel.org> <20200724001606.GR2021248@mellanox.com>
Date:   Fri, 24 Jul 2020 02:36:27 +0200
Message-ID: <87h7txvjec.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason Gunthorpe <jgg@mellanox.com> writes:
> On Thu, Jul 23, 2020 at 09:51:52AM +0100, Marc Zyngier wrote:
>> > IIRC on Intel/AMD at least once a MSI is launched it is not maskable.
>> 
>> Really? So you can't shut a device with a screaming interrupt,
>> for example, should it become otherwise unresponsive?
>
> Well, it used to be like that in the APICv1 days. I suppose modern
> interrupt remapping probably changes things.

The MSI side of affairs has nothing to do with Intel and neither with
ACPIv1. It's a trainwreck on the PCI side.

MSI interrupts do not have mandatory masking. For those which do not
implement it (and that's still the case with devices designed today
especially CPU internal peripherals) there are only a few options to
shut them up:

  1) Disable MSI which has the problem that the interrupt gets
     redirected to legacy PCI #A-#D interrupt unless the hardware
     supports to disable that redirection, which is another optional
     thing and hopeless case

  2) Disable it at the IRQ remapping level which fortunately allows by
     design to do so.

  3) Disable it at the device level which is feasible for a device
     driver but impossible for the irq side

>> > So the model for MSI is always "mask at source". The closest mapping
>> > to the Linux IRQ model is to say the end device has a irqchip that
>> > encapsulates the ability of the device to generate the MSI in the
>> > first place.
>> 
>> This is an x86'ism, I'm afraid. Systems I deal with can mask any
>> interrupt at the interrupt controller level, MSI or not.

Yes, it's a pain, but reality.

> Sure. However it feels like a bad practice to leave the source
> unmasked and potentially continuing to generate messages if the
> intention was to disable the IRQ that was assigned to it - even if the
> messages do not result in CPU interrupts they will still consume
> system resources.

See above. You cannot reach out to the device driver to disable the
underlying interrupt source, which is the ultimate ratio if #1 or #2 are
not working or not there. That would be squaring the circle and
violating all rules of layering and locking at once.

The bad news is that we can't change the hardware. We have to deal with
it. And yes, I told HW people publicly and in private conversations that
unmaskable interrupts are broken by definition for more than a
decade. They still get designed that way ...

>> If masking at the source is the only way to shut the device up,
>> and assuming that the device provides the expected semantics
>> (a MSI raised by the device while the interrupt is masked
>> isn't lost and gets sent when unmasked), that's fair enough.
>> It's just ugly.
>
> It makes sense that the masking should follow the same semantics for
> PCI MSI masking.

Which semantics? The horrors of MSI or the halfways reasonable MSI-X
variant?

Thanks,

        tglx
