Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2812AD3B7
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 11:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbgKJK1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 05:27:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:57432 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgKJK1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 05:27:32 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605004049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6DwWScf0UiIUjDzc5mG7wsSoj8qM105KIV0Vc2jhoyE=;
        b=A6koRcL2APXggzJ+TaVK0jtT/Y9Y4Sx0/RBQwGdQOp3ZCzQq5EHzjh7KkO78DYwIIOugTX
        nNjD084g0l5Rzs+q/cDy8CnUMaItY7qKSqdJWa2KiptiNhBIpJqGS2Q08VJ6Y1QsDp5OJv
        WMUhyWAihOARcEQv5Up+5dIMMLMNqmGYVOg1Vd2+FwSOOcG940YY/SkPo/JTKxo5TRAvhC
        YReXDDCE/Y4oHdnl7d29uh/kijmN0QXR7PllbPl55quT3ahZF/tCCSooPmJZDxp4lGaN+S
        KLQ1ufojPwXEf0Co3wsWIC5ZdMVXupAmiZyiL5b+3TV3biZdZXTPBJLAQEC/vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605004049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6DwWScf0UiIUjDzc5mG7wsSoj8qM105KIV0Vc2jhoyE=;
        b=QylWp/qKbYrVZSRS5UNzA78ocFtrzSzsSSU6VHwRkrJTJVz6AS54U7VAA7GZmdAd88He52
        MNk+zuSOGGEkLTDQ==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
In-Reply-To: <20201110051412.GA20147@otc-nc-03>
References: <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <20201108235852.GC32074@araj-mobl1.jf.intel.com> <874klykc7h.fsf@nanos.tec.linutronix.de> <20201109173034.GG2620339@nvidia.com> <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
Date:   Tue, 10 Nov 2020 11:27:29 +0100
Message-ID: <875z6dik1a.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ashok,

On Mon, Nov 09 2020 at 21:14, Ashok Raj wrote:
> On Mon, Nov 09, 2020 at 11:42:29PM +0100, Thomas Gleixner wrote:
>> On Mon, Nov 09 2020 at 13:30, Jason Gunthorpe wrote:
> Approach to IMS is more of a phased approach. 
>
> #1 Allow physical device to scale beyond limits of PCIe MSIx
>    Follows current methodology for guest interrupt programming and
>    evolutionary changes rather than drastic.

Trapping MSI[X] writes is there because it allows to hand a device to an
unmodified guest OS and to handle the case where the MSI[X] entries
storage cannot be mapped exclusively to the guest.

But aside of this, it's not required if the storage can be mapped
exclusively, the guest is hypervisor aware and can get a host composed
message via a hypercall. That works for physical functions and SRIOV,
but not for SIOV.

> #2 Long term we should work together on enabling IMS in guest which
>    requires changes in both HW and SW eco-system.
>
> For #1, the immediate need is to find a way to limit guest from using IMS
> due to current limitations. We have couple options.
>
> a) CPUID based method to disallow IMS when running in a guest OS. Limiting
>    use to existing virtual MSIx to guest devices. (Both you/Jason alluded)
> b) We can extend DMAR table to have a flag for opt-out. So in real platform
>    this flag is clear and in guest VMM will ensure vDMAR will have this flag
>    set. Along the lines as Jason alluded, platform level and via ACPI
>    methods. We have similar use for x2apic_optout today.
>
> Think a) is probably more generic.

But incomplete as I explained before. If the VMM does not set the
hypervisor bit in CPUID then the guest OS assumes to run on bare
metal. It needs more than just relying on CPUID.

Aside of that neither Jason nor myself said that IMS cannot be supported
in a guest. PF and VF IMS can and has to be supported. SIOV is a
different story due to the PASID requirement which obviously needs to be
managed host side and needs HW changes.

> From SW improvements:
>
> - Hypercall to retrieve addr/data from host

You need to have that even for the non SIOV case in order to hand in a
full device which has the IMS storage in queue memory.

> Devices such as idxd that do not have these entries on page-boundaries for
> isolation to permit direct programming from GuestOS will continue to use
> trap-emulate as used today.

That's a restriction of that particular hardware.

> Until then, IMS will be restricted to host VMM only, and we can use the
> methods above to prevent IMS in guest and continue to use the legacy
> virtual MSIx.

SIOV IMS.

But as things stand now not even PF/VF pass through are possible. This
might not be an issue for IDXD, but it's an issue in general and this
want's the be thought of _now_ before we put a lot of infrastructure in
to place which needs then to be ripped apart again.

>> The current specification puts massive restrictions on IMS storage which
>> are _not_ allowing to optimize it in a device specific manner as
>> demonstrated in this discussion.
>
> IMS doesn't restrict this optimization, but to allow it requires more
> OS support as you had mentioned.

Right, IMS per se does not put an restriction on it.

The specification and the HW limitations on the remapping unit put that
restriction into place.

OS support is an obvious requirement, but OS support cannot make
the restrictions of HW go away magically.

But again, we need to think about the path forward _now_.

Just slapping some 'works for IDXD' solution into place can severly
restrict the options for going beyond these limitations simply because
we have to support that 'works for IDXD thing' forever.

Thanks,

        tglx
