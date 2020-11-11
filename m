Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32802AFD59
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgKLBbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgKKWqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 17:46:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E12C061A04;
        Wed, 11 Nov 2020 14:27:30 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605133648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/AJjHM4RdDlSJrBc4hxI1WObRemgRGA65few9eI9qhY=;
        b=Yz4kBo6iYpJ8A4VQHynSbh4zW33QX2TNKzEpF1vlJPbmL+ZOD/van513qYoQjUoLfiANkU
        /UcMuwr8ewQcOHJeACUHCPyaL/pQoU2Ye8qx5txQ5T1oPPOkUX8vJvzXHi6g0kwY67Itxa
        zGBFaWBV6dWK7StOKa/6l5Nbqbq4uAESoYqm4i6BqxlZlwB+jx6IrPz3+6zW+VvZltQnya
        H6MVzg9fXch2mIZ35bjtmv0EZ7F+FreuENigEmTzM8YVaGUms1dhyAjDYnVCbB2zUPKVcn
        mhXkmwtjeC83I8oiQUHByMZkWQELU+8MltibUfrWk7rdaAe3ViEru5/B5/33mA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605133648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/AJjHM4RdDlSJrBc4hxI1WObRemgRGA65few9eI9qhY=;
        b=0e9+v4yPq7Pamk3s9B1ZMn8Y1Q6geVARcMOWJtapXhxL5QALz7ZL4IJuvemVn9hGu0f1QI
        Xasc43FTcv++sKCQ==
To:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "jing.lin\@intel.com" <jing.lin@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201111160922.GA83266@otc-nc-03>
References: <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org> <20201111154159.GA24059@infradead.org> <20201111160922.GA83266@otc-nc-03>
Date:   Wed, 11 Nov 2020 23:27:28 +0100
Message-ID: <87k0uro7fz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11 2020 at 08:09, Ashok Raj wrote:
> On Wed, Nov 11, 2020 at 03:41:59PM +0000, Christoph Hellwig wrote:
>> On Sun, Nov 08, 2020 at 07:36:34PM +0000, David Woodhouse wrote:
>> > So it does look like we're going to need a hypercall interface to
>> > compose an MSI message on behalf of the guest, for IMS to use. In fact
>> > PCI devices assigned to a guest could use that too, and then we'd only
>> > need to trap-and-remap any attempt to write a Compatibility Format MSI
>> > to the device's MSI table, while letting Remappable Format messages get
>> > written directly.
>> > 
>> > We'd also need a way for an OS running on bare metal to *know* that
>> > it's on bare metal and can just compose MSI messages for itself. Since
>> > we do expect bare metal to have an IOMMU, perhaps that is just a
>> > feature flag on the IOMMU?
>> 
>> Have the platform firmware advertise if it needs native or virtualized
>> IMS handling.  If it advertises neither don't support IMS?
>
> The platform hint can be easily accomplished via DMAR table flags. We could
> have an IMS_OPTOUT(similart to x2apic optout flag) flag, when 0 its native 
> and IMS is supported.
>
> When vIOMMU is presented to guest, virtual DMAR table will have this flag
> set to 1. Indicates to GuestOS, native IMS isn't supported.

These opt-out bits suck by definition. It comes all back to the fact
that the whole virt thing didn't have a hardware defined way to tell
that the OS runs in a VM and not on bare metal. It wouldn't have been
rocket science to do so.

And because that does not exist, we need magic opt-out bits for every
other piece of functionality which gets added. Can we please stop this
and provide a well defined way to tell the OS whether it runs on bare
metal or not?

The point is that you really want opt-in bits so that decisions come
down to

     if (!virt || virt->supports_X)

which is the obvious sane and safe logic. But sure, why am I asking for
sane and safe in the context of virtualization?

Thanks,

        tglx
