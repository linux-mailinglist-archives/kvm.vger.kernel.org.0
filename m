Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2515E3B3FA7
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 10:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhFYIpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 04:45:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60236 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhFYIpe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 04:45:34 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624610593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmSyoyyEMIJp4af9Gw12TH4tDtwX0VdKMNAYZNcVDm4=;
        b=AHhjaAphGowU0pTeCjnJZBJhc7RMpOXvnz7Jt+/Cir61tfBTJQHV8RmcP+0Sd4I5165grH
        8KPyOWmPcsw8G3AGa6FJsrR/FnrWZMyDl5ug54a4N/NTgAQbCtBXH0pieKNXdhB7QKktJZ
        RInPKgF+l4oR+s6OUsdOU2DeLmSD0l3PtWP+8vcmF+TMxxpVD2aQ4OgAsERGHXb0DwblZw
        LhW16coCVxJuWrccmqvp4bcJSIeKjdP/P7Pt/9eTtOyxoGYiIiPrBYeILh44OtLnZDZtUL
        g56JUPauHwhIaSE0C31xFnmZgXRsLXfDIlXNwnqClstL6soTQpkr0dsIB85o5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624610593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LmSyoyyEMIJp4af9Gw12TH4tDtwX0VdKMNAYZNcVDm4=;
        b=gHFW4IDg4490PWojrbqW+tDv1+7J+vzUU1hputd/LpqH1bHZNkjSAETMfcWItcvT6bTHPR
        NLKzY4/iKpkbtwBA==
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
In-Reply-To: <BN9PR11MB5433063F826F5CEC93BCE0E38C069@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <MWHPR11MB1886E14C57689A253D9B40C08C079@MWHPR11MB1886.namprd11.prod.outlook.com> <8735t7wazk.ffs@nanos.tec.linutronix.de> <20210624154434.11809b8f.alex.williamson@redhat.com> <BN9PR11MB5433063F826F5CEC93BCE0E38C069@BN9PR11MB5433.namprd11.prod.outlook.com>
Date:   Fri, 25 Jun 2021 10:43:13 +0200
Message-ID: <87o8buuyfy.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25 2021 at 05:21, Kevin Tian wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> So caching/latching occurs on unmask for MSI-X, but I can't find
>> similar statements for MSI.  If you have, please note them.  It's
>> possible MSI is per interrupt.
>
> I checked PCI Local Bus Specification rev3.0. At that time MSI and
> MSI-X were described/compared together in almost every paragraph 
> in 6.8.3.4 (Per-vector Masking and Function Masking). The paragraph
> that you cited is the last one in that section. It's a pity that MSI is
> not clarified in this paragraph but it gives me the impression that 
> MSI function is not permitted to cache address and data values. 
> Later after MSI and MSI-X descriptions were split into separate 
> sections in PCIe spec, this impression is definitely weakened a lot.
>
> If true, this even implies that software is free to change data/addr
> when MSI is unmasked, which is sort of counter-intuitive to most
> people.

Yes, software is free to do that and it has to deal with the
consequences. See arch/x86/kernel/apic/msi.c::msi_set_affinity().

> Then I further found below thread:
>
> https://lore.kernel.org/lkml/1468426713-31431-1-git-send-email-marc.zyngier@arm.com/
>
> It identified a device which does latch the message content in a
> MSI-capable device, forcing the kernel to startup irq early before
> enabling MSI capability.
>
> So, no answer and let's see whether Thomas can help identify
> a better proof.

As I said to Alex: The MSI specification is and always was blury and the
behaviour in detail is implementation defined. IOW, what might work on
device A is not guaranteed to work on device B.

> p.s. one question to Thomas. As Alex cited above, software must 
> not modify the Address, Data, or Steering Tag fields of an MSI-X
> entry while it is unmasked. However this rule might be violated
> today in below flow:
>
> request_irq()
>     __setup_irq()
>         irq_startup()
>             __irq_startup()
>                 irq_enable()
>                     unmask_irq() <<<<<<<<<<<<<
>         irq_setup_affinity()
>             irq_do_set_affinity()
>                 msi_set_affinity() // when IR is disabled
>                     irq_msi_update_msg()
>                         pci_msi_domain_write_msg() <<<<<<<<<<<<<<
>
> Isn't above have msi-x entry updated after it's unmasked? 

Dammit, I could swear that we had masking at the core or PCI level at
some point. Let me dig into this.

Thanks,

        tglx
