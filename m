Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0CA26C852
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 20:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgIPSWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 14:22:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:13919 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbgIPSVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 14:21:13 -0400
IronPort-SDR: 1wc6PxOA8tht6i/aT5k1BM1OclUsRFY8KYrKjtdUAFKXX1D+anEKNKeK+cDm29q04QAVKVq96r
 T4lWRAexNoBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="156945960"
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="156945960"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 11:21:13 -0700
IronPort-SDR: juzWmbnvtkvHCD/V5EkjPIxuDdEgR3cVbtJpmnnFPdYrQM+3YPyUTVV5beblXc5j8JzJg31a0b
 oGAsbrgkE0BQ==
X-IronPort-AV: E=Sophos;i="5.76,433,1592895600"; 
   d="scan'208";a="343994210"
Received: from jpan9-mobl2.amr.corp.intel.com (HELO localhost) ([10.213.174.80])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 11:21:12 -0700
Date:   Wed, 16 Sep 2020 11:21:10 -0700
From:   "Jacob Pan (Jun)" <jacob.jun.pan@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>, <eric.auger@redhat.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <kevin.tian@intel.com>, <jun.j.tian@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>, <hao.wu@intel.com>,
        <stefanha@gmail.com>, <iommu@lists.linux-foundation.org>,
        <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        <jacob.jun.pan@linux.intel.com>, jacob.jun.pan@intel.com
Subject: Re: [PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing
 to VMs
Message-ID: <20200916112110.000024ee@intel.com>
In-Reply-To: <20200916170113.GD3699@nvidia.com>
References: <20200914190057.GM904879@nvidia.com>
        <20200914224438.GA65940@otc-nc-03>
        <20200915113341.GW904879@nvidia.com>
        <20200915181154.GA70770@otc-nc-03>
        <20200915184510.GB1573713@nvidia.com>
        <20200915150851.76436ca1@jacob-builder>
        <20200915235126.GK1573713@nvidia.com>
        <20200915171319.00003f59@linux.intel.com>
        <20200916150754.GE6199@nvidia.com>
        <20200916163343.GA76252@otc-nc-03>
        <20200916170113.GD3699@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,
On Wed, 16 Sep 2020 14:01:13 -0300, Jason Gunthorpe <jgg@nvidia.com>
wrote:

> On Wed, Sep 16, 2020 at 09:33:43AM -0700, Raj, Ashok wrote:
> > On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe wrote:  
> > > On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun) wrote:  
> > > > > If user space wants to bind page tables, create the PASID with
> > > > > /dev/sva, use ioctls there to setup the page table the way it
> > > > > wants, then pass the now configured PASID to a driver that
> > > > > can use it.   
> > > > 
> > > > Are we talking about bare metal SVA?   
> > > 
> > > What a weird term.  
> > 
> > Glad you noticed it at v7 :-) 
> > 
> > Any suggestions on something less weird than 
> > Shared Virtual Addressing? There is a reason why we moved from SVM
> > to SVA.  
> 
> SVA is fine, what is "bare metal" supposed to mean?
> 
What I meant here is sharing virtual address between DMA and host
process. This requires devices perform DMA request with PASID and use
IOMMU first level/stage 1 page tables.
This can be further divided into 1) user SVA 2) supervisor SVA (sharing
init_mm)

My point is that /dev/sva is not useful here since the driver can
perform PASID allocation while doing SVA bind.

> PASID is about constructing an arbitary DMA IOVA map for PCI-E
> devices, being able to intercept device DMA faults, etc.
> 
An arbitrary IOVA map does not need PASID. In IOVA, you do map/unmap
explicitly, why you need to handle IO page fault?

To me, PASID identifies an address space that is associated with a
mm_struct.

> SVA is doing DMA IOVA 1:1 with the mm_struct CPU VA. DMA faults
> trigger the same thing as CPU page faults. If is it not 1:1 then there
> is no "shared". When SVA is done using PCI-E PASID it is "PASID for
> SVA". Lots of existing devices already have SVA without PASID or
> IOMMU, so lets not muddy the terminology.
> 
I agree. This conversation is about "PASID for SVA" not "SVA without
PASID"


> vPASID/vIOMMU is allowing a guest to control the DMA IOVA map and
> manipulate the PASIDs.
> 
> vSVA is when a guest uses a vPASID to provide SVA, not sure this is
> an informative term.
> 
I agree.

> This particular patch series seems to be about vPASID/vIOMMU for
> vfio-mdev vs the other vPASID/vIOMMU patch which was about vPASID for
> vfio-pci.
> 
Yi can correct me but this set is is about VFIO-PCI, VFIO-mdev will be
introduced later.

> > > > If so, I don't see the need for userspace to know there is a
> > > > PASID. All user space need is that my current mm is bound to a
> > > > device by the driver. So it can be a one-step process for user
> > > > instead of two.  
> > > 
> > > You've missed the entire point of the conversation, VDPA already
> > > needs more than "my current mm is bound to a device"  
> > 
> > You mean current version of vDPA? or a potential future version of
> > vDPA?  
> 
> Future VDPA drivers, it was made clear this was important to Intel
> during the argument about VDPA as a mdev.
> 
> Jason


Thanks,

Jacob
