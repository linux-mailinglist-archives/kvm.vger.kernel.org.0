Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6321C26CF3E
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 01:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIPXJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 19:09:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:47633 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgIPXJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Sep 2020 19:09:05 -0400
IronPort-SDR: G13EVxgrWiMUJEvRX1ETlQzgt6Rw2zDqEBfREMZ8mLaSlOku4seoE5FM4jbulolTfVH0JTdA6L
 zvGyrI+UFPag==
X-IronPort-AV: E=McAfee;i="6000,8403,9746"; a="221136274"
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="221136274"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 16:09:04 -0700
IronPort-SDR: ciXVM4r79l01GczmidIOUSxSTwcXHW230qN0CHY8Ys5imcKc7r+Q3pzICMmWls07BPPAdtV2ag
 LRtHNHKL76EQ==
X-IronPort-AV: E=Sophos;i="5.76,434,1592895600"; 
   d="scan'208";a="452047379"
Received: from jpan9-mobl2.amr.corp.intel.com (HELO localhost) ([10.213.174.80])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 16:09:03 -0700
Date:   Wed, 16 Sep 2020 16:09:01 -0700
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
Message-ID: <20200916160901.000046ec@intel.com>
In-Reply-To: <20200916183841.GI6199@nvidia.com>
References: <20200915113341.GW904879@nvidia.com>
        <20200915181154.GA70770@otc-nc-03>
        <20200915184510.GB1573713@nvidia.com>
        <20200915150851.76436ca1@jacob-builder>
        <20200915235126.GK1573713@nvidia.com>
        <20200915171319.00003f59@linux.intel.com>
        <20200916150754.GE6199@nvidia.com>
        <20200916163343.GA76252@otc-nc-03>
        <20200916170113.GD3699@nvidia.com>
        <20200916112110.000024ee@intel.com>
        <20200916183841.GI6199@nvidia.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,
On Wed, 16 Sep 2020 15:38:41 -0300, Jason Gunthorpe <jgg@nvidia.com>
wrote:

> On Wed, Sep 16, 2020 at 11:21:10AM -0700, Jacob Pan (Jun) wrote:
> > Hi Jason,
> > On Wed, 16 Sep 2020 14:01:13 -0300, Jason Gunthorpe <jgg@nvidia.com>
> > wrote:
> >   
> > > On Wed, Sep 16, 2020 at 09:33:43AM -0700, Raj, Ashok wrote:  
> > > > On Wed, Sep 16, 2020 at 12:07:54PM -0300, Jason Gunthorpe
> > > > wrote:    
> > > > > On Tue, Sep 15, 2020 at 05:22:26PM -0700, Jacob Pan (Jun)
> > > > > wrote:    
> > > > > > > If user space wants to bind page tables, create the PASID
> > > > > > > with /dev/sva, use ioctls there to setup the page table
> > > > > > > the way it wants, then pass the now configured PASID to a
> > > > > > > driver that can use it.     
> > > > > > 
> > > > > > Are we talking about bare metal SVA?     
> > > > > 
> > > > > What a weird term.    
> > > > 
> > > > Glad you noticed it at v7 :-) 
> > > > 
> > > > Any suggestions on something less weird than 
> > > > Shared Virtual Addressing? There is a reason why we moved from
> > > > SVM to SVA.    
> > > 
> > > SVA is fine, what is "bare metal" supposed to mean?
> > >   
> > What I meant here is sharing virtual address between DMA and host
> > process. This requires devices perform DMA request with PASID and
> > use IOMMU first level/stage 1 page tables.
> > This can be further divided into 1) user SVA 2) supervisor SVA
> > (sharing init_mm)
> > 
> > My point is that /dev/sva is not useful here since the driver can
> > perform PASID allocation while doing SVA bind.  
> 
> No, you are thinking too small.
> 
> Look at VDPA, it has a SVA uAPI. Some HW might use PASID for the SVA.
> 
Could you point to me the SVA UAPI? I couldn't find it in the mainline.
Seems VDPA uses VHOST interface?

> When VDPA is used by DPDK it makes sense that the PASID will be SVA
> and 1:1 with the mm_struct.
> 
I still don't see why bare metal DPDK needs to get a handle of the
PASID. Perhaps the SVA patch would explain. Or are you talking about
vDPA DPDK process that is used to support virtio-net-pmd in the guest?

> When VDPA is used by qemu it makes sense that the PASID will be an
> arbitary IOVA map constructed to be 1:1 with the guest vCPU physical
> map. /dev/sva allows a single uAPI to do this kind of setup, and qemu
> can support it while supporting a range of SVA kernel drivers. VDPA
> and vfio-mdev are obvious initial targets.
> 
> *BOTH* are needed.
> 
> In general any uAPI for PASID should have the option to use either the
> mm_struct SVA PASID *OR* a PASID from /dev/sva. It costs virtually
> nothing to implement this in the driver as PASID is just a number, and
> gives so much more flexability.
> 
Not really nothing in terms of PASID life cycles. For example, if user
uses uacce interface to open an accelerator, it gets an FD_acc. Then it
opens /dev/sva to allocate PASID then get another FD_pasid. Then we
pass FD_pasid to the driver to bind page tables, perhaps multiple
drivers. Now we have to worry about If FD_pasid gets closed before
FD_acc(s) closed and all these race conditions.

If we do not expose FD_pasid to the user, the teardown is much simpler
and streamlined. Following each FD_acc close, PASID unbind is performed.

> > Yi can correct me but this set is is about VFIO-PCI, VFIO-mdev will
> > be introduced later.  
> 
> Last patch is:
> 
>   vfio/type1: Add vSVA support for IOMMU-backed mdevs
> 
> So pretty hard to see how this is not about vfio-mdev, at least a
> little..
> 
> Jason


Thanks,

Jacob
