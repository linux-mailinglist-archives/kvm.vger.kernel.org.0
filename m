Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB86D3B0986
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 17:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhFVPxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 11:53:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:62009 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231936AbhFVPxQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 11:53:16 -0400
IronPort-SDR: +ocYNyxbo+2BS1cweEbNexI7VKSXzdgnfK3QTUJm48xz++TPm2Wi1OSbnXQpKBb2Q6KyU+FdBC
 lMwSR1L6E7xA==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="207123449"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="207123449"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 08:50:55 -0700
IronPort-SDR: l5n+kq0PIsY3vVfJdA5KOdsgf7lkC5ME6WmCWmIP4OtO+7q5nkUhNbYZx9c+CYE4fXjws41twe
 yqR7ij8Ku5Gw==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="473815730"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.178.7]) ([10.213.178.7])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 08:50:53 -0700
Subject: Re: Virtualizing MSI-X on IMS via VFIO
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <76c02ea6-f1c5-2772-419f-5ceb197fe904@intel.com>
Date:   Tue, 22 Jun 2021 08:50:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/22/2021 3:16 AM, Tian, Kevin wrote:
> Hi, Alex,
>
> Need your help to understand the current MSI-X virtualization flow in
> VFIO. Some background info first.
>
> Recently we are discussing how to virtualize MSI-X with Interrupt
> Message Storage (IMS) on mdev:
>          https://lore.kernel.org/kvm/87im2lyiv6.ffs@nanos.tec.linutronix.de/
>
> IMS is a device specific interrupt storage, allowing an optimized and
> scalable manner for generating interrupts. idxd mdev exposes virtual
> MSI-X capability to guest but uses IMS entries physically for generating
> interrupts.
>
> Thomas has helped implement a generic ims irqchip driver:
>          https://lore.kernel.org/linux-hyperv/20200826112335.202234502@linutronix.de/
>
> idxd device allows software to specify an IMS entry (for triggering
> completion interrupt) when submitting a descriptor. To prevent one
> mdev triggering malicious interrupt into another mdev (by specifying
> an arbitrary entry), idxd ims entry includes a PASID field for validation -
> only a matching PASID in the executed descriptor can trigger interrupt
> via this entry. idxd driver is expected to program ims entries with
> PASIDs that are allocated to the mdev which owns those entries.
>
> Other devices may have different ID and format to isolate ims entries.
> But we need abstract a generic means for programming vendor-specific
> ID into vendor-specific ims entry, without violating the layering model.
>
> Thomas suggested vendor driver to first register ID information (possibly
> plus the location where to write ID to) in msi_desc when allocating irqs
> (extend existing alloc function or via new helper function) and then have
> the generic ims irqchip driver to update ID to the ims entry when it's
> started up by request_irq().
>
> Then there are two questions to be answered:
>
>      1) How does vendor driver decide the ID to be registered to msi_desc?
>      2) How is Thomas's model mapped to the MSI-X virtualization flow in VFIO?
>
> For the 1st open, there are two types of PASIDs on idxd mdev:
>
>      1) default PASID: one per mdev and allocated when mdev is created;
>      2) sva PASIDs: multiple per mdev and allocated on-demand (via vIOMMU);
>
> If vIOMMU is not exposed, all ims entries of this mdev should be
> programmed with default PASID which is always available in mdev's
> lifespan.
>
> If vIOMMU is exposed and guest sva is enabled, entries used for sva
> should be tagged with sva PASIDs, leaving others tagged with default
> PASID. To help achieve intra-guest interrupt isolation, guest idxd driver
> needs program guest sva PASIDs into virtual MSIX_PERM register (one
> per MSI-X entry) for validation. Access to MSIX_PERM is trap-and-emulated
> by host idxd driver which then figure out which PASID to register to
> msi_desc (require PASID translation info via new /dev/iommu proposal).
>
> The guest driver is expected to update MSIX_PERM before request_irq().
>
> Now the 2nd open requires your help. Below is what I learned from
> current vfio/qemu code (for vfio-pci device):
>
>      0) Qemu doesn't attempt to allocate all irqs as reported by msix->
>          table_size. It is done in an dynamic and incremental way.
>
>      1) VFIO provides just one command (VFIO_DEVICE_SET_IRQS) for
>           allocating/enabling irqs given a set of vMSIX vectors [start, count]:
>
>          a) if irqs not allocated, allocate irqs [start+count]. Enable irqs for
>              specified vectors [start, count] via request_irq();
>          b) if irqs already allocated, enable irqs for specified vectors;
>          c) if irq already enabled, disable and re-enable irqs for specified
>               vectors because user may specify a different eventfd;
>
>      2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
>          DEVICE_SET_IRQS to enable vector#0, even though it's currently
>          masked by the guest. Interrupts are received by Qemu but blocked
>          from guest via mask/pending bit emulation. The main intention is
>          to enable physical MSI-X;
>
>      3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
>          DEVICE_SET_IRQS to enable vector#0 again, with a eventfd different
>          from the one provided in 2);
>
>      4) When guest unmasks vector#1, Qemu finds it's outside of allocated
>          vectors (only vector#0 now):
>
>          a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free
>              irq for vector#0;
>
>          b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
>              irqs for both vector#0 and vector#1;
>
>       5) When guest unmasks vector#2, same flow in 4) continues.
>
>       ....
>
> If above understanding is correct, how is lost interrupt avoided between
> 4.a) and 4.b) given that irq has been torn down for vector#0 in the middle
> while from guest p.o.v this vector is actually unmasked? There must be
> a mechanism in place, but I just didn't figure it out...
>
> Given above flow is robust, mapping Thomas's model to this flow is
> straightforward. Assume idxd mdev has two vectors: vector#0 for
> misc/error interrupt and vector#1 as completion interrupt for guest
> sva. VFIO_DEVICE_SET_IRQS is handled by idxd mdev driver:
>
>      2) When guest enables virtual MSI-X capability, Qemu calls VFIO_
>          DEVICE_SET_IRQS to enable vector#0. Because vector#0 is not
>          used for sva, MSIX_PERM#0 has PASID disabled. Host idxd driver
>          knows to register default PASID to msi_desc#0 when allocating irqs.
>          Then .startup() callback of ims irqchip is called to program default
>          PASID saved in msi_desc#0 to the target ims entry when request_irq().
>
>      3) When guest unmasks vector#0 via request_irq(), Qemu calls VFIO_
>          DEVICE_SET_IRQS to enable vector#0 again. Following same logic
>          as vfio-pci, idxd driver first disable irq#0 via free_irq() and then
>          re-enable irq#0 via request_irq(). It's still default PASID being used
>          according to msi_desc#0.

Hi Kevin, slight correction here. Because vector#0 is emulated for idxd 
vdev, it has no IMS backing. So there is no msi_desc#0 for that vector. 
msi_desc#0 actually starts at vector#1 where IMS is allocated to back 
it. vector#0 does not go through request_irq(). It only has eventfd 
part. Everything you say is correct but starts at vector#1.


>
>      4) When guest unmasks vector#1, Qemu finds it's outside of allocated
>          vectors (only vector#0 now):
>
>          a) Qemu first calls VFIO_DEVICE_SET_IRQS to disable and free
>              irq for vector#0. msi_desc#0 is also freed.
>
>          b) Qemu then calls VFIO_DEVICE_SET_IRQS to allocate and enable
>              irqs for both vector#0 and vector#1. At this point, MSIX_PERM#0
>             has PASID disabled while MSIX_PERM#1 has a valid guest PASID1
>             for sva. idxd driver registers default PASID to msix_desc#0 and
>             host PASID2 (translated from guest PASID1) to msix_desc#1 when
>             allocating irqs. Later when both irqs are enabled via request_irq(),
>             ims irqchip driver updates the target ims entries according to
>             msix_desc#0 and misx_desc#1 respectively.
>
> But this is specific to how Qemu virtualizes MSI-X today. What about it
> may change (or another device model) to allocate all table_size irqs
> when guest enables MSI-X capability? At that point we don't have valid
> MSIX_PERM content to register PASID info to msix_desc. Possibly what
> we really require is a separate helper function allowing driver to update
> msix_desc after irq allocation, e.g. when guest unmasks a vector...
>
> and do you see any other facets which are overlooked here?
>
> Thanks
> Kevin
