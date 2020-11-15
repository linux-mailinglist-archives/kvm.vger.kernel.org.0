Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE372B39CB
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 23:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgKOWLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 17:11:36 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37306 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbgKOWLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 17:11:36 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605478288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6TFX5iDoqSU4XMSTlY2depc58WL9jbkVOPxJSaKpX1w=;
        b=EMeVVBC6Fu80l9wEyzf72WLeD7zqU7duok6LeiLq6ntvr/yCM5jKU0jjzsOqr72nErJVVn
        rAL7ONQPghWFzA80ezhtbDEmhV48Klx3KYX+w0OUD50fsqPQuKX+t4Wwpg088k+Mandp4y
        XfIrICnRPrHboTpgx3atl/EUf/oq8MhzsRDuj3GSxszH1qoNFKQZRFTgXhNRRO8edrr/PD
        VOCyM/26xavGBaHxLVILZ1UO5M9hNe+R1yRSM0CVrXQRcn+R7mCF8smSMcmY6YzvFa2G3A
        CMtPxfiQEyJiWVXEUdw75OF2PgbySeOAlniVzxZ/3ylR/K87U+mKyYM8eCtLDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605478288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6TFX5iDoqSU4XMSTlY2depc58WL9jbkVOPxJSaKpX1w=;
        b=YgFNGHBNJRaPf0FNkvPNTDMM0zfYcq3p/2Cm0CnbsaX64wH0mGg0yiF9IMeuXrfoSMKqLT
        0I0U8EBJ6uiFOPBA==
To:     "Raj\, Ashok" <ashok.raj@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
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
In-Reply-To: <20201115193156.GB14750@araj-mobl1.jf.intel.com>
References: <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03> <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03> <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com> <20201112193253.GG19638@char.us.oracle.com> <877dqqmc2h.fsf@nanos.tec.linutronix.de> <20201114103430.GA9810@infradead.org> <20201114211837.GB12197@araj-mobl1.jf.intel.com> <877dqmamjl.fsf@nanos.tec.linutronix.de> <20201115193156.GB14750@araj-mobl1.jf.intel.com>
Date:   Sun, 15 Nov 2020 23:11:27 +0100
Message-ID: <875z665kz4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 15 2020 at 11:31, Ashok Raj wrote:
> On Sun, Nov 15, 2020 at 12:26:22PM +0100, Thomas Gleixner wrote:
>> > opt-in by device or kernel? The way we are planning to support this is:
>> >
>> > Device support for IMS - Can discover in device specific means
>> > Kernel support for IMS. - Supported by IOMMU driver.
>> 
>> And why exactly do we have to enforce IOMMU support? Please stop looking
>> at IMS purely from the IDXD perspective. We are talking about the
>> general concept here and not about the restricted Intel universe.
>
> I think you have mentioned it almost every reply :-)..Got that! Point taken
> several emails ago!! :-)

You sure? I _try_ to not mention it again then. No promise though. :)

> I didn't mean just for idxd, I said for *ANY* device driver that wants to
> use IMS.

Which is wrong. Again:

A) For PF/VF on bare metal there is absolutely no IOMMU dependency
   because it does not have a PASID requirement. It's just an
   alternative solution to MSI[X], which allows optimizations like
   storing the message in driver manages queue memory or lifting the
   restriction of 2048 interrupts per device. Nothing else.

B) For PF/VF in a guest the IOMMU dependency of IMS is a red herring.
   There is no direct dependency on the IOMMU.

   The problem is the inability of the VMM to trap the message write to
   the IMS storage if the storage is in guest driver managed memory.
   This can be solved with either

   - a hypercall which translates the guest MSI message
   or
   - a vIOMMU which uses a hypercall or whatever to translate the guest
     MSI message

C) Subdevices ala mdev are a different story. They require PASID which
   enforces IOMMU and the IMS part is not managed by the users anyway.

So we have a couple of problems to solve:

  1) Figure out whether the OS runs on bare metal

     There is no reliable answer to that, so we either:

      - Use heuristics and assume that failure is unlikely and in case
        of failure blame the incompetence of VMM authors and/or
        sysadmins

     or
     
      - Default to IMS disabled and let the sysadmin enable it via
        command line option.

        If the kernel detects to run in a VM it yells and disables it
        unless the OS and the hypervisor agree to provide support for
        that scenario (see #2).

        That's fails as well if the sysadmin does so when the OS runs on
        a VMM which is not identifiable, but at least we can rightfully
        blame the sysadmin in that case.

     or

      - Declare that IMS always depends on IOMMU

        I personaly don't care, but people working on these kind of
        device already said, that they want to avoid it when possible.
        
        If you want to go that route, then please talk to those folks
        and ask them to agree in public.

     You also need to take into account that this must work on all
     architectures which support virtualization because IMS is
     architecture independent.

  2) Guest support for PF/VF

     Again we have several scenarios depending on the IMS storage
     type.

      - If the storage type is device memory then it's pretty much the
        same as MSI[X] just a different location.

      - If the storage is in driver managed memory then this needs
        #1 plus guest OS and hypervisor support (hypercall/vIOMMU)
        
  3) Guest support for PF/VF and guest managed subdevice (mdev)

     Depends on #1 and #2 and is an orthogonal problem if I'm not
     missing something.

To move forward we need to make a decision about #1 and #2 now.

This needs to be well thought out as changing it after the fact is
going to be a nightmare.

/me grudgingly refrains from mentioning the obvious once more.

Thanks,

        tglx
