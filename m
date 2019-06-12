Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BF042F55
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 20:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfFLSuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 14:50:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:41659 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfFLSuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 14:50:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 11:50:49 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga004.jf.intel.com with ESMTP; 12 Jun 2019 11:50:49 -0700
Date:   Wed, 12 Jun 2019 11:53:58 -0700
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
Message-ID: <20190612115358.0d90b322@jacob-builder>
In-Reply-To: <905f130b-02dc-6971-8d5b-ce87d9bc96a4@arm.com>
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
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 14:14:33 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 10/06/2019 22:31, Jacob Pan wrote:
> > On Mon, 10 Jun 2019 13:45:02 +0100
> > Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:
> >   
> >> On 07/06/2019 18:43, Jacob Pan wrote:  
> >>>>> So it seems we agree on the following:
> >>>>> - iommu_unregister_device_fault_handler() will never fail
> >>>>> - iommu driver cleans up all pending faults when handler is
> >>>>> unregistered
> >>>>> - assume device driver or guest not sending more page response
> >>>>> _after_ handler is unregistered.
> >>>>> - system will tolerate rare spurious response
> >>>>>
> >>>>> Sounds right?      
> >>>>
> >>>> Yes, I'll add that to the fault series    
> >>> Hold on a second please, I think we need more clarifications.
> >>> Ashok pointed out to me that the spurious response can be harmful
> >>> to other devices when it comes to mdev, where PRQ group id is not
> >>> per PASID, device may reuse the group number and receiving
> >>> spurious page response can confuse the entire PF.     
> >>
> >> I don't understand how mdev differs from the non-mdev situation
> >> (but I also still don't fully get how mdev+PASID will be
> >> implemented). Is the following the case you're worried about?
> >>
> >>   M#: mdev #
> >>
> >> # Dev         Host        mdev drv       VFIO/QEMU        Guest
> >> ====================================================================
> >> 1                     <- reg(handler)
> >> 2 PR1 G1 P1    ->         M1 PR1 G1        inject ->     M1 PR1 G1
> >> 3                     <- unreg(handler)
> >> 4       <- PS1 G1 P1 (F)      |
> >> 5                        unreg(handler)
> >> 6                     <- reg(handler)
> >> 7 PR2 G1 P1    ->         M2 PR2 G1        inject ->     M2 PR2 G1
> >> 8                                                     <- M1 PS1 G1
> >> 9         accept ??    <- PS1 G1 P1
> >> 10                                                    <- M2 PS2 G1
> >> 11        accept       <- PS2 G1 P1
> >>  
> > Not really. I am not worried about PASID reuse or unbind. Just
> > within the same PASID bind lifetime of a single mdev, back to back
> > register/unregister fault handler.
> > After Step 4, device will think G1 is done. Device could reuse G1
> > for the next PR, if we accept PS1 in step 9, device will terminate
> > G1 before the real G1 PS arrives in Step 11. The real G1 PS might
> > have a different response code. Then we just drop the PS in Step
> > 11?  
> 
> Yes, I think we do. Two possibilities:
> 
> * G1 is reused at step 7 for the same PASID context, which means that
> it is for the same mdev. The problem is then identical to the non-mdev
> case, new page faults and old page response may cross:
> 
> # Dev         Host        mdev drv       VFIO/QEMU        Guest
> ====================================================================
> 7 PR2 G1 P1  --.
> 8               \                         .------------- M1 PS1 G1
> 9                '----->  PR2 G1 P1  ->  /   inject  --> M1 PR2 G1
> 10           accept <---  PS1 G1 P1  <--'
> 11           reject <---  PS2 G1 P1  <------------------ M1 PS2 G1
> 
> And the incorrect page response is returned to the guest. However it
> affects a single mdev/guest context, it doesn't affect other mdevs.
> 
> * Or G1 is reused at step 7 for a different PASID. At step 10 the
> fault handler rejects the page response because the PASID is
> different, and step 11 is accepted.
> 
> 
> >>> Having spurious page response is also not
> >>> abiding the PCIe spec. exactly.    
> >>
> >> We are following the PCI spec though, in that we don't send page
> >> responses for PRGIs that aren't in flight.
> >>  
> > You are right, the worst case of the spurious PS is to terminate the
> > group prematurely. Need to know the scope of the HW damage in case
> > of mdev where group IDs can be shared among mdevs belong to the
> > same PF.  
> 
> But from the IOMMU fault API point of view, the full page request is
> identified by both PRGI and PASID. Given that each mdev has its own
> set of PASIDs, it should be easy to isolate page responses per mdev.
> 
On Intel platform, devices sending page request with private data must
receive page response with matching private data. If we solely depend
on PRGI and PASID, we may send stale private data to the device in
those incorrect page response. Since private data may represent PF
device wide contexts, the consequence of sending page response with
wrong private data may affect other mdev/PASID.

One solution we are thinking to do is to inject the sequence #(e.g.
ktime raw mono clock) as vIOMMU private data into to the guest. Guest
would return this fake private data in page response, then host will
send page response back to the device that matches PRG1 and PASID and
private_data.

This solution does not expose HW context related private data to the
guest but need to extend page response in iommu uapi.

/**
 * struct iommu_page_response - Generic page response information
 * @version: API version of this structure
 * @flags: encodes whether the corresponding fields are valid
 *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
 * @pasid: Process Address Space ID
 * @grpid: Page Request Group Index
 * @code: response code from &enum iommu_page_response_code
 * @private_data: private data for the matching page request
 */
struct iommu_page_response {
#define IOMMU_PAGE_RESP_VERSION_1	1
	__u32	version;
#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
#define IOMMU_PAGE_RESP_PRIVATE_DATA	(1 << 1)
	__u32	flags;
	__u32	pasid;
	__u32	grpid;
	__u32	code;
	__u32	padding;
	__u64	private_data[2];
};

There is also the change needed for separating storage for the real and
fake private data.

Sorry for the last minute change, did not realize the HW implications.

I see this as a future extension due to limited testing, perhaps for
now, can you add paddings similar to page request? Make it 64B as well.

struct iommu_page_response {
#define IOMMU_PAGE_RESP_VERSION_1	1
	__u32	version;
#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
	__u32	flags;
	__u32	pasid;
	__u32	grpid;
	__u32	code;
	__u8	padding[44];
};

Thanks!

Jacob
