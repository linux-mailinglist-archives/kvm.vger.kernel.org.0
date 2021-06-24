Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F53B248C
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 03:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFXBi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 21:38:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41142 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFXBi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 21:38:26 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624498567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Agt8zrKs/F4N1ClKsmnKuU3iQuaV8RIz8HGNILY824=;
        b=r6nZ0D+TDAABUcuiRXUXXjAPUgIo5ABoa3CP8Z9rO92u1p6M/G+rRRrJ3LsUB7iW0bioDf
        uV9QtqUhNXszmdgWL/zreyN4OUgkk9E7tFjRhpc6cF1Pz93SkgWONIHWncxizxLU4WPLpZ
        9OnC0laLO11hfUF8SnoCKXsj/KaTYSnl119r9Nsa25jYEBBEWswzD+YMHg3usE/JMes+2W
        kp4hhV7zMo4D8RjDbuiUSS0+vg6gBHX/HYx5N9SrFX6biLxykbDhgoD2/EN6qaFajq8yM1
        j/zWi4X7c9SdfrT0i0mmos/k8VcGd8OowSlqfXkZR/JyY+7JvEOBXFv+89UB2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624498567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Agt8zrKs/F4N1ClKsmnKuU3iQuaV8RIz8HGNILY824=;
        b=y8FPE18Zp85WPUYsfkJjRINkv8U883vG42wRCe7SBCrRwuvnO7QJEtKTwloCWOmm4Bfa8s
        Q4sF4oAYK0MzoQBw==
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
In-Reply-To: <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <20210623091935.3ab3e378.alex.williamson@redhat.com> <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com>
Date:   Thu, 24 Jun 2021 03:36:07 +0200
Message-ID: <87r1gsavso.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin,

On Thu, Jun 24 2021 at 00:00, Kevin Tian wrote:
>> From: Alex Williamson <alex.williamson@redhat.com>
>> Sent: Wednesday, June 23, 2021 11:20 PM
>>
> [...]
>  > > So the only downside today of allocating more MSI-X vectors than
>> > necessary is memory consumption for the irq descriptors.
>> 
>> As above, this is a QEMU policy of essentially trying to be a good
>> citizen and allocate only what we can infer the guest is using.  What's
>> a good way for QEMU, or any userspace, to know it's running on a host
>> where vector exhaustion is not an issue?
>
> In my proposal a new command (VFIO_DEVICE_ALLOC_IRQS) is
> introduced to separate allocation from enabling. The availability
> of this command could be the indicator whether vector 
> exhaustion is not an issue now?

Your proposal still does not address the fundamental issue of a missing
feedback to the guest and you can invent a gazillion more IOCTL commands
and none of them will solve that issue. A hypercall/paravirt interface is
the only reasonable solution.

The time you are wasting to come up with non-solutions would have surely
been better spent implementing the already known and obvious proper
solution. You might be halfways done already with that.

Thanks,

        tglx
