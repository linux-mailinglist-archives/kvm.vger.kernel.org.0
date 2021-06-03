Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147BF39AC24
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 22:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhFCU5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 16:57:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:49788 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhFCU5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 16:57:31 -0400
IronPort-SDR: a8UHUQzXeCCct5iRLQjh54zfo0Di1P+RaEo4T/+yggl/05A3ylQnmc1LAeI5Sbfe+LZG77xtqe
 MbFJNNLr7tmw==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="184521561"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="184521561"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 13:55:32 -0700
IronPort-SDR: MjfM7yT9NG79x395JzZW/keo/oszVCbdecgt/yty7PosWCm9vajnPWokqPWAK11mHE//JujYHK
 b3hP56vtGhcA==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="550306458"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 13:55:30 -0700
Date:   Thu, 3 Jun 2021 13:58:07 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603135807.40684468@jacob-builder>
In-Reply-To: <PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <PH0PR12MB54811863B392C644E5365446DC3E9@PH0PR12MB5481.namprd12.prod.outlook.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Parav,

On Tue, 1 Jun 2021 17:30:51 +0000, Parav Pandit <parav@nvidia.com> wrote:

> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Thursday, May 27, 2021 1:28 PM  
> 
> > 5.6. I/O page fault
> > +++++++++++++++
> > 
> > (uAPI is TBD. Here is just about the high-level flow from host IOMMU
> > driver to guest IOMMU driver and backwards).
> > 
> > -   Host IOMMU driver receives a page request with raw fault_data {rid,
> >     pasid, addr};
> > 
> > -   Host IOMMU driver identifies the faulting I/O page table according
> > to information registered by IOASID fault handler;
> > 
> > -   IOASID fault handler is called with raw fault_data (rid, pasid,
> > addr), which is saved in ioasid_data->fault_data (used for response);
> > 
> > -   IOASID fault handler generates an user fault_data (ioasid, addr),
> > links it to the shared ring buffer and triggers eventfd to userspace;
> > 
> > -   Upon received event, Qemu needs to find the virtual routing
> > information (v_rid + v_pasid) of the device attached to the faulting
> > ioasid. If there are multiple, pick a random one. This should be fine
> > since the purpose is to fix the I/O page table on the guest;
> > 
> > -   Qemu generates a virtual I/O page fault through vIOMMU into guest,
> >     carrying the virtual fault data (v_rid, v_pasid, addr);
> >   
> Why does it have to be through vIOMMU?
I think this flow is for fully emulated IOMMU, the same IOMMU and device
drivers run in the host and guest. Page request interrupt is reported by
the IOMMU, thus reporting to vIOMMU in the guest.

> For a VFIO PCI device, have you considered to reuse the same PRI
> interface to inject page fault in the guest? This eliminates any new
> v_rid. It will also route the page fault request and response through the
> right vfio device.
> 
I am curious how would PCI PRI can be used to inject fault. Are you talking
about PCI config PRI extended capability structure? The control is very
limited, only enable and reset. Can you explain how would page fault
handled in generic PCI cap?
Some devices may have device specific way to handle page faults, but I
guess this is not the PCI PRI method you are referring to?

> > -   Guest IOMMU driver fixes up the fault, updates the I/O page table,
> > and then sends a page response with virtual completion data (v_rid,
> > v_pasid, response_code) to vIOMMU;
> >   
> What about fixing up the fault for mmu page table as well in guest?
> Or you meant both when above you said "updates the I/O page table"?
> 
> It is unclear to me that if there is single nested page table maintained
> or two (one for cr3 references and other for iommu). Can you please
> clarify?
> 
I think it is just one, at least for VT-d, guest cr3 in GPA is stored
in the host iommu. Guest iommu driver calls handle_mm_fault to fix the mmu
page tables which is shared by the iommu.

> > -   Qemu finds the pending fault event, converts virtual completion data
> >     into (ioasid, response_code), and then calls a /dev/ioasid ioctl to
> >     complete the pending fault;
> >   
> For VFIO PCI device a virtual PRI request response interface is done, it
> can be generic interface among multiple vIOMMUs.
> 
same question above, not sure how this works in terms of interrupts and
response queuing etc.

> > -   /dev/ioasid finds out the pending fault data {rid, pasid, addr}
> > saved in ioasid_data->fault_data, and then calls iommu api to complete
> > it with {rid, pasid, response_code};
> >  


Thanks,

Jacob
