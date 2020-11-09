Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69D2AC8C2
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgKIWmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:42:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54086 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIWmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:42:33 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604961750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1z9VVm4SXFnU2lDoSHTfhVj4WS02FXiBfM7TibPl7tM=;
        b=gv6V9waMvfQvNDKvhhA3p1Jhiex5y9NA8ZsEEZ1sbUrMZigd3WeMwV1gW0WUeiOgxD7FM6
        GFtvGUGHSSFJHAC+LCM5baXBjwRvq1v/Hf7sV+yHGkhkmtIcgq1fYAWSZfBa/JT8Y9Zlkt
        C2+7KgPDA4w7dwsXUwbua6kspktrNPuSl02ukjUfm1jp8yFrVnSSg11qb8BdH7kZHQcJJK
        Mwc9mBi4AApzBznXZqBKN/HNzqOsO42HIiJ1h8UJwMdfonjZ2gUkVQZcVRHOTIF8KBwPvV
        ZX/SDZkS3eJiC+XZjoDl+efXN/AViWOu6D86FAQU/p8Kp15igsdcVgx7foK0WQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604961750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1z9VVm4SXFnU2lDoSHTfhVj4WS02FXiBfM7TibPl7tM=;
        b=PGZ6AIOpNGkeoLmMZtTwEYJNEluUtRndUUua0A9Ig+sMIdYS4ym6WC/DtX5XCmbXt+IbQX
        IUOxmz2U79FQy+DA==
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj\, Ashok" <ashok.raj@intel.com>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201109173034.GG2620339@nvidia.com>
References: <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <20201108235852.GC32074@araj-mobl1.jf.intel.com> <874klykc7h.fsf@nanos.tec.linutronix.de> <20201109173034.GG2620339@nvidia.com>
Date:   Mon, 09 Nov 2020 23:42:29 +0100
Message-ID: <87pn4mi23u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09 2020 at 13:30, Jason Gunthorpe wrote:
> On Mon, Nov 09, 2020 at 12:21:22PM +0100, Thomas Gleixner wrote:
>> >> Is the IOMMU/Interrupt remapping unit able to catch such messages whi=
ch
>> >> go outside the space to which the guest is allowed to signal to? If y=
es,
>> >> problem solved. If no, then IMS storage in guest memory can't ever
>> >> work.

> The SIOV case is to take a single RID and split it to multiple
> VMs and also to the hypervisor. All these things concurrently use the
> same RID, and the IOMMU can't tell them apart.
>
> The hypervisor security domain owns TLPs with no PASID. Each PASID is
> assigned to a VM.
>
> For interrupts, today, they are all generated, with no PASID, to the
> same RID. There is no way for remapping to protect against a guest
> without checking also PASID.
>
> The relavance of PASID is this:
>
>> Again, trap emulate does not work for IMS when the IMS store is software
>> managed guest memory and not part of the device. And that's the whole
>> reason why we are discussing this.
>
> With PASID tagged interrupts and a IOMMU interrupt remapping
> capability that can trigger on PASID, then the platform can provide
> the same level of security as SRIOV - the above is no problem.
>
> The device ensures that all DMAs and all interrupts program by the
> guest are PASID tagged and the platform provides security by checking
> the PASID when delivering the interrupt.

Correct.

> Intel IOMMU doesn't work this way today, but it makes alot of design
> sense.

Right.

> Otherwise the interrupt is effectively delivered to the hypervisor. A
> secure device can *never* allow a guest to specify an addr/data pair
> for a non-PASID tagged TLP, so the device cannot offer IMS to the
> guest.

Ok. Let me summarize the current state of supported scenarios:

 1) SRIOV works with any form of IMS storage because it does not require
    PASID and the VF devices have unique requester ids, which allows the
    remap unit to sanity check the message.

 2) SIOV with IMS when the hypervisor can manage the IMS store
    exclusively.

So #2 prevents a device which handles IMS storage in queue memory to
utilize IMS for SIOV in a guest because the hypervisor cannot manage the
IMS message store and the guest can write arbitrary crap to it which
violates the isolation principle.

And here is the relevant part of the SIOV spec:

 "IMS is managed by host driver software and is not accessible directly
  from guest or user-mode drivers.

  Within the device, IMS storage is not accessible from the ADIs. ADIs
  can request interrupt generation only through the device=E2=80=99s =E2=80=
=98Interrupt
  Message Generation Logic=E2=80=99, which allows an ADI to only generate
  interrupt messages that are associated with that specific ADI. These
  restrictions ensure that the host driver has complete control over
  which interrupt messages can be generated by each ADI.

  On Intel 64 architecture platforms, message signaled interrupts are
  issued as DWORD size untranslated memory writes without a PASID TLP
  Prefix, to address range 0xFEExxxxx. Since all memory requests
  generated by ADIs include a PASID TLP Prefix, it is not possible for
  an ADI to generate a DMA write that would be interpreted by the
  platform as an interrupt message."

That's the reductio ad absurdum for this sentence in the first paragraph
of the preceding chapter describing the concept of IMS:

  "IMS enables devices to store the interrupt messages for ADIs in a
   device-specific optimized manner without the scalability restrictions
   of the PCI Express defined MSI-X capability."

"Device-specific optimized manner" is either wishful thinking or
marketing induced verbal diarrhoea.

The current specification puts massive restrictions on IMS storage which
are _not_ allowing to optimize it in a device specific manner as
demonstrated in this discussion.

It also precludes obvious use cases like passing a full device to a
guest and let the guest manage SIOV subdevices for containers or nested
guests.

TBH, to me this is just another hastily cobbled together half thought
out misfeature cast in silicon. The proposed software support is
following the exactly same principle.

So before we go anywhere with this, I want to see a proper way forward
to support _all_ sensible use cases and to fulfil the promise of
"device-specific optimized manner" at the conceptual and specification
and also at the code level.

I'm not at all interested to rush in support for a half baken Intel
centric solution which other people have to clean up after the fact
(again).

IOW, it's time to go back to the drawing board.

Thanks,

        tglx

