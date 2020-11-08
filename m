Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0912AADEC
	for <lists+kvm@lfdr.de>; Sun,  8 Nov 2020 23:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgKHWrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 17:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728016AbgKHWrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 17:47:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790C6C0613CF;
        Sun,  8 Nov 2020 14:47:16 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604875634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rBjYPcvZiasfxvS1ynS0aVZpxNlRTcwK/PNIK4/EIg=;
        b=rg0pavsyLrbvXpkOwHv56gFjjDzJtq1jY0qWo3GCCLGLGyobejcYXoCj2HP/1WTih0PspL
        NDcoAb0m48TalBOq8RhmX3Gny8QFgsyvhB8Y3RS+TLeq/TxCL+hATuwPYd6/ivXnusZmAc
        AN8mOEt2bGch9M9wyjuhELEeTrYHWCLs/BH29HPZlJHdQekF3HLAIuK6XruqG6aMs6U1iM
        +UiltBy+0CESqPIvvkO6Qo8bh2DQsYnGj1P1vXp6C9Rb20jsGmpybZsfY6eMVQ0wagoz36
        Xrg6g+pvkK5FeasJa3ysO6kJXDvB3AO3ujCoTTiJ2SxdrsTQMtKDyqtF71NRzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604875634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rBjYPcvZiasfxvS1ynS0aVZpxNlRTcwK/PNIK4/EIg=;
        b=7bR/otqcs/8wgIwKRCQs4JaHhVPWdvkD8tiRlYct4/B9HvLP5liAWJs8XX/Ud49gWt9j5w
        VTmUIuoZdf2/bgCw==
To:     David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     "Raj\, Ashok" <ashok.raj@intel.com>,
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
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
References: <20201103124351.GM2620339@nvidia.com> <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104124017.GW2620339@nvidia.com> <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201104135415.GX2620339@nvidia.com> <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com> <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03> <20201106175131.GW2620339@nvidia.com> <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com> <20201107001207.GA2620339@nvidia.com> <87pn4nk7nn.fsf@nanos.tec.linutronix.de> <d69953378bd1fdcdda54a2fbe285f6c0b1484e8a.camel@infradead.org>
Date:   Sun, 08 Nov 2020 23:47:13 +0100
Message-ID: <87h7pzjwjy.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08 2020 at 19:36, David Woodhouse wrote:
> On Sun, 2020-11-08 at 19:47 +0100, Thomas Gleixner wrote:
>> So this needs some thought.
>
> The problem here is that Intel implemented interrupt remapping in a way
> which is anathema to structured, ordered IRQ domains.
>
> When a guest writes an MSI message (addr/data) to the MSI table of a
> PCI device which has been assigned to that guest, it *doesn't* properly
> inherit the MSI composition from a parent irqdomain which knows about
> the (host-side) IOMMU.
>
> What actually happens is the hypervisor *traps* the writes to the
> device's MSI table, and translates them *then*.

That's what I showed in the ascii art :)

> In *precisely* the fashion which we're trying to avoid for IMS.

At least for the IMS variant where the storage is not in trappable
device memory.

> Now, you can imagine a world where it wasn't like this, where
> Remappable Format MSI messages don't exist, and where we let guests
> write native MSI message to the device without trapping =E2=80=94 and whe=
re the
> IOMMU then sees the incoming interrupt and has to map the APIC ID to a
> *virtual* CPU for that guest, based on the PCI source-id of the
> device.

That would be not convoluted enough and make too much sense.

> In that world, IMS would work naturally. But that isn't how Intel
> designed interrupt remapping. They *designed* to have to trap and
> translate as the message is written to the device.
>
> So it does look like we're going to need a hypercall interface to
> compose an MSI message on behalf of the guest, for IMS to use. In fact
> PCI devices assigned to a guest could use that too, and then we'd only
> need to trap-and-remap any attempt to write a Compatibility Format MSI
> to the device's MSI table, while letting Remappable Format messages get
> written directly.

Yes, if we have the HCALL domain then the message composed by the
hypervisor is valid for everything not only IMS. That's why I left out
any specifics on the Busdomain side. It does not matter which kind of
bus that is. The only mechanics which is provided by the busdomain is
to store the precomposed message and eventually provide mask/unmask at
that level.

> We'd also need a way for an OS running on bare metal to *know* that
> it's on bare metal and can just compose MSI messages for itself. Since
> we do expect bare metal to have an IOMMU, perhaps that is just a
> feature flag on the IOMMU?

There are still CPUs w/o IOMMU out there and new ones are shipped.

So you would basically mandate that IMS with memory storage can only
work on bare metal when the CPU has an IOMMU.

Jason said in [1]: "For x86 I think we could accept linking this to
IOMMU, if really necessary."

OTOH, what's the chance that a guest runs on something which

  1) Does not have X86_FEATURE_HYPERVISOR set in cpuid 1/EDX

and

  2) Cannot be identified as Xen domain

and

  3) Does not have a DMI vendor entry which identifies the
     virtualization solution (we don't use that today, but
     adding that table is trivial enough)

and

  4) Has such an IMS device passed through?

Possible, yes. Likely, no. Do we care?

> That or Intel needs to fix the IOMMU to do proper virtualisation and
> actually translate "Compatibility Format" MSIs for a guest too.

Is that going to happen before I retire?

Thanks,

        tglx

[1] https://lore.kernel.org/r/20200822005125.GB1152540@nvidia.com
