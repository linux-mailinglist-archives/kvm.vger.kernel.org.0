Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82F4AEEC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 02:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfFSAP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 20:15:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:6548 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbfFSAP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 20:15:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 17:15:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="153637382"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 18 Jun 2019 17:15:56 -0700
Date:   Tue, 18 Jun 2019 17:19:08 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190618171908.76284cd7@jacob-builder>
In-Reply-To: <77405d39-81a4-d9a8-5d35-27602199867a@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-27-eric.auger@redhat.com>
        <20190603163139.70fe8839@x1.home>
        <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
        <20190605154553.0d00ad8d@jacob-builder>
        <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
        <20190606132903.064f7ac4@jacob-builder>
        <dc051424-67d7-02ff-9b8e-0d7a8a4e59eb@arm.com>
        <20190607104301.6b1bbd74@jacob-builder>
        <e02b024f-6ebc-e8fa-c30c-5bf3f4b164d6@arm.com>
        <20190610143134.7bff96e9@jacob-builder>
        <905f130b-02dc-6971-8d5b-ce87d9bc96a4@arm.com>
        <20190612115358.0d90b322@jacob-builder>
        <77405d39-81a4-d9a8-5d35-27602199867a@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 15:04:36 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 12/06/2019 19:53, Jacob Pan wrote:
> >>> You are right, the worst case of the spurious PS is to terminate
> >>> the group prematurely. Need to know the scope of the HW damage in
> >>> case of mdev where group IDs can be shared among mdevs belong to
> >>> the same PF.    
> >>
> >> But from the IOMMU fault API point of view, the full page request
> >> is identified by both PRGI and PASID. Given that each mdev has its
> >> own set of PASIDs, it should be easy to isolate page responses per
> >> mdev. 
> > On Intel platform, devices sending page request with private data
> > must receive page response with matching private data. If we solely
> > depend on PRGI and PASID, we may send stale private data to the
> > device in those incorrect page response. Since private data may
> > represent PF device wide contexts, the consequence of sending page
> > response with wrong private data may affect other mdev/PASID.
> > 
> > One solution we are thinking to do is to inject the sequence #(e.g.
> > ktime raw mono clock) as vIOMMU private data into to the guest.
> > Guest would return this fake private data in page response, then
> > host will send page response back to the device that matches PRG1
> > and PASID and private_data.
> > 
> > This solution does not expose HW context related private data to the
> > guest but need to extend page response in iommu uapi.
> > 
> > /**
> >  * struct iommu_page_response - Generic page response information
> >  * @version: API version of this structure
> >  * @flags: encodes whether the corresponding fields are valid
> >  *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
> >  * @pasid: Process Address Space ID
> >  * @grpid: Page Request Group Index
> >  * @code: response code from &enum iommu_page_response_code
> >  * @private_data: private data for the matching page request
> >  */
> > struct iommu_page_response {
> > #define IOMMU_PAGE_RESP_VERSION_1	1
> > 	__u32	version;
> > #define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
> > #define IOMMU_PAGE_RESP_PRIVATE_DATA	(1 << 1)
> > 	__u32	flags;
> > 	__u32	pasid;
> > 	__u32	grpid;
> > 	__u32	code;
> > 	__u32	padding;
> > 	__u64	private_data[2];
> > };
> > 
> > There is also the change needed for separating storage for the real
> > and fake private data.
> > 
> > Sorry for the last minute change, did not realize the HW
> > implications.
> > 
> > I see this as a future extension due to limited testing,   
> 
> I'm wondering how we deal with:
> (1) old userspace that won't fill the new private_data field in
> page_response. A new kernel still has to support it.
> (2) old kernel that won't recognize the new PRIVATE_DATA flag.
> Currently iommu_page_response() rejects page responses with unknown
> flags.
> 
> I guess we'll need a two-way negotiation, where userspace queries
> whether the kernel supports the flag (2), and the kernel learns
> whether it should expect the private data to come back (1).
> 
I am not sure case (1) exist in that there is no existing user space
supports PRQ w/o private data. Am I missing something?

For VT-d emulation, private data is always part of the scalable mode
PASID capability. If vIOMMU query host supports PASID and scalable
mode, it will always support private data once PRQ is enabled.

So I think we only need to negotiate (2) which should be covered by
VT-d PASID cap.

> > perhaps for
> > now, can you add paddings similar to page request? Make it 64B as
> > well.  
> 
> I don't think padding is necessary, because iommu_page_response is
> sent by userspace to the kernel, unlike iommu_fault which is
> allocated by userspace and filled by the kernel.
> 
> Page response looks a lot more like existing VFIO mechanisms, so I
> suppose we'll wrap the iommu_page_response structure and include an
> argsz parameter at the top:
> 
> 	struct vfio_iommu_page_response {
> 		u32 argsz;
> 		struct iommu_page_response pr;
> 	};
> 
> 	struct vfio_iommu_page_response vpr = {
> 		.argsz = sizeof(vpr),
> 		.pr = ...
> 		...
> 	};
> 
> 	ioctl(devfd, VFIO_IOMMU_PAGE_RESPONSE, &vpr);
> 
> In that case supporting private data can be done by simply appending a
> field at the end (plus the negotiation above).
> 
Do you mean at the end of struct vfio_iommu_page_response{}? or at
the end of that seems struct iommu_page_response{}?

The consumer of the private data is iommu driver not vfio. So I think
you want to add the new field at the end of struct iommu_page_response,
right?
I think that would work, just to clarify.
