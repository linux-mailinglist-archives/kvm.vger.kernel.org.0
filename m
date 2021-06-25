Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE33B4387
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 14:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhFYMpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 08:45:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33180 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhFYMpK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 08:45:10 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624624968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUvHNoaJ8hCHdVSooVihvRmjh1gPNArcPRW12xQl1mg=;
        b=wE8ezas2TzVU1H2UhFE2Qqluhh4R0PTGEDvLHCOLfcRKKkYieNL6kUqFABsgS5f4EHK1zn
        uC6Dc5WymQYokWHBTcQ7vf1nHgivxUMx3MUK8qNxxXYiKhX4fN8cZcZ22L+ci4srGoE++t
        Cfol40KPMcXP9wqkZEedvJaVZS72WRmr1OjJRWD0k5yLXogloXgfks2oOZLF/kYlSwpkjg
        398u/kH2ZY5BlU7n2MuHxv2DzPSczvIGQb4mn4qTJyDTSMw5H7sbfci6fXpvzvWN8U78yS
        5xSOzMhEoEMYxpBxjgI38RARtNkGfSGE+3hUrlsDAYNe+gwwR6zNiEuyzHG7UA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624624968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kUvHNoaJ8hCHdVSooVihvRmjh1gPNArcPRW12xQl1mg=;
        b=fxzpnqDLxdWf/HUlsC3sYIU73rs4RLRvicSCFfizzTYMn/oKBBJAb5U77/sulc9bMlCoHc
        NgfQdpgeg1qmR/BA==
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
Date:   Fri, 25 Jun 2021 14:42:48 +0200
Message-ID: <87im22uncn.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25 2021 at 10:43, Thomas Gleixner wrote:
> On Fri, Jun 25 2021 at 05:21, Kevin Tian wrote:
>> p.s. one question to Thomas. As Alex cited above, software must 
>> not modify the Address, Data, or Steering Tag fields of an MSI-X
>> entry while it is unmasked. However this rule might be violated
>> today in below flow:
>>
>> request_irq()
>>     __setup_irq()
>>         irq_startup()
>>             __irq_startup()
>>                 irq_enable()
>>                     unmask_irq() <<<<<<<<<<<<<
>>         irq_setup_affinity()
>>             irq_do_set_affinity()
>>                 msi_set_affinity() // when IR is disabled
>>                     irq_msi_update_msg()
>>                         pci_msi_domain_write_msg() <<<<<<<<<<<<<<
>>
>> Isn't above have msi-x entry updated after it's unmasked? 
>
> Dammit, I could swear that we had masking at the core or PCI level at
> some point. Let me dig into this.

Indeed, that code path does not check irq_can_move_pcntxt(). It doesn't
blow up in our face by chance because of this:

     __setup_irq()
        irq_activate()
        unmask()
        irq_setup_affinity()

irq_activate() assigns a vector based on the affinity mask so
irq_setup_affinity() ends up writing the same data again pointlessly.

For some stupid reason the ordering of startup/setup_affinity is the way
it is for historical reasons. I tried to reorder it at some point but
that caused failure on !x86 so I went back to the status quo.

All other affinity settings happen with the interrupt masked because we
do that from actual interrupt context via irq_move_masked_irq() which
does the right thing.

Let me fix that proper for the startup case.

Thanks,

        tglx
