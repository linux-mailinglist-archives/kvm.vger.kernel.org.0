Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A1C1B4EF8
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 23:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDVVOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 17:14:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:52565 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgDVVOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 17:14:38 -0400
IronPort-SDR: tR+PDkjBU/ier9SbbhN4ntD/CyWhcZBTUXplhOn4uWSNn0KtF1rrX/qqK+gg35cRxSb2YPJVMR
 vybaviIeEr5A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 14:14:37 -0700
IronPort-SDR: 8vCw1V311yc1l9jGv5DHjLy8mjDMw8yJKPOo/IUX+/10QcFObB1zlI1It2yH/GrtMrLkWUtZui
 fmoNWkImtY8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="274020861"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by orsmga002.jf.intel.com with ESMTP; 22 Apr 2020 14:14:36 -0700
Date:   Wed, 22 Apr 2020 14:14:36 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200422211436.GA103345@otc-nc-03>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422115017.GQ11945@mellanox.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason

> > > 
> > > I'm feeling really skeptical that adding all this PCI config space and
> > > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > > interface is a good idea, that kind of stuff is much safer in
> > > userspace.
> > > 
> > > Particularly since vfio is not really needed once a driver is using
> > > the PASID stuff. We already have general code for drivers to use to
> > > attach a PASID to a mm_struct - and using vfio while disabling all the
> > > DMA/iommu config really seems like an abuse.
> > 
> > Well, this series is for virtualizing idxd device to VMs, instead of
> > supporting SVA for bare metal processes. idxd implements a
> > hardware-assisted mediated device technique called Intel Scalable
> > I/O Virtualization,
> 
> I'm familiar with the intel naming scheme.
> 
> > which allows each Assignable Device Interface (ADI, e.g. a work
> > queue) tagged with an unique PASID to ensure fine-grained DMA
> > isolation when those ADIs are assigned to different VMs. For this
> > purpose idxd utilizes the VFIO mdev framework and IOMMU aux-domain
> > extension. Bare metal SVA will be enabled for idxd later by using
> > the general SVA code that you mentioned.  Both paths will co-exist
> > in the end so there is no such case of disabling DMA/iommu config.
>  
> Again, if you will have a normal SVA interface, there is no need for a
> VFIO version, just use normal SVA for both.
> 
> PCI emulation should try to be in userspace, not the kernel, for
> security.

Not sure we completely understand your proposal. Mediated devices
are software constructed and they have protected resources like
interrupts and stuff and VFIO already provids abstractions to export
to user space.

Native SVA is simply passing the process CR3 handle to IOMMU so
IOMMU knows how to walk process page tables, kernel handles things
like page-faults, doing device tlb invalidations and such.

That by itself doesn't translate to what a guest typically does
with a VDEV. There are other control paths that need to be serviced
from the kernel code via VFIO. For speed path operations like
ringing doorbells and such they are directly managed from guest.

How do you propose to use the existing SVA api's  to also provide 
full device emulation as opposed to using an existing infrastructure 
that's already in place?

Perhaps Alex can ease Jason's concerns?

Cheers,
Ashok

