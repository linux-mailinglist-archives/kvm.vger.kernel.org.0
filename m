Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7745C3B4A0D
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 23:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFYVWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 17:22:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYVWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 17:22:05 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624655982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+qtCczX3lqY8VCVDX6AiP18j8YGevOY6tjrdN7I5ph8=;
        b=qQW+iHl3GMPGFh7uKtfj3D8xQdsFSsMEb93CeWz5e0ltJI2MgHqIEHnYTRXuoH7wff6fdl
        89fvpzP9InM7hUD6hK7qBv37SO7iIUjloZAFTpnimbTiMpasmjn+gQ1KtXRaoAGfXORC/0
        gJnCBoY2V0fpDx3xfBFU8iVNMG0f+iIhdgViQGik0pE51rJvY1joY+0uW+6EbB7v7NHpBz
        Avg5JmnybC41pXLq0n+VwbUaoQnZyvb8fQAxoc+hJvQoP5fNj2kvugJzVrgQOJO5c+ZoXp
        fpDBPbwkZBtEmVhnepZpbZQE9jFIrTtGopXZ4+29U+zT+bZiSDgZOVikH6Ltkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624655982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+qtCczX3lqY8VCVDX6AiP18j8YGevOY6tjrdN7I5ph8=;
        b=Y7FmdJ0EyBpyiA9OpBLjT77S5JD6QhZQBSo1B7MtS6TxnAlLie4B5A+BNRu7qShwXghcEC
        RQIXqnxtqeikoQAQ==
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
In-Reply-To: <87o8buuyfy.ffs@nanos.tec.linutronix.de>
References: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com> <8735t7wazk.ffs@nanos.tec.linutronix.de> <20210624154434.11809b8f.alex.williamson@redhat.com> <BN9PR11MB5433063F826F5CEC93BCE0E38C069@BN9PR11MB5433.namprd11.prod.outlook.com> <87o8buuyfy.ffs@nanos.tec.linutronix.de>
Date:   Fri, 25 Jun 2021 23:19:42 +0200
Message-ID: <87czs9vdzl.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25 2021 at 10:43, Thomas Gleixner wrote:
> On Fri, Jun 25 2021 at 05:21, Kevin Tian wrote:
>>> From: Alex Williamson <alex.williamson@redhat.com>
>>> So caching/latching occurs on unmask for MSI-X, but I can't find
>>> similar statements for MSI.  If you have, please note them.  It's
>>> possible MSI is per interrupt.
>>
>> I checked PCI Local Bus Specification rev3.0. At that time MSI and
>> MSI-X were described/compared together in almost every paragraph 
>> in 6.8.3.4 (Per-vector Masking and Function Masking). The paragraph
>> that you cited is the last one in that section. It's a pity that MSI is
>> not clarified in this paragraph but it gives me the impression that 
>> MSI function is not permitted to cache address and data values. 
>> Later after MSI and MSI-X descriptions were split into separate 
>> sections in PCIe spec, this impression is definitely weakened a lot.
>>
>> If true, this even implies that software is free to change data/addr
>> when MSI is unmasked, which is sort of counter-intuitive to most
>> people.
>
> Yes, software is free to do that and it has to deal with the
> consequences. See arch/x86/kernel/apic/msi.c::msi_set_affinity().

Well, it's actually forced to do so when the MSI implementation does not
provide masking. If masking is available then it should be used also for
MSI as it prevents the nasty update problem where the hardware can
observe inconsistent state... Which x86 does correctly except for that
startup issue you spotted, but I'm not at all sure about the rest.

The startup issue is halfways trivial to fix I think, but there are
other issues with the PCI/MSI-X handling which I discovered while
staring at that code for a while. Still working on it.

Thanks,

        tglx


