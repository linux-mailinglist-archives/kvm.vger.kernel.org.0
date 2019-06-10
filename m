Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36AF83BEAB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 23:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390130AbfFJV21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 17:28:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:6054 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389193AbfFJV21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 17:28:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 14:28:26 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 10 Jun 2019 14:28:26 -0700
Date:   Mon, 10 Jun 2019 14:31:34 -0700
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
        jacob.jun.pan@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190610143134.7bff96e9@jacob-builder>
In-Reply-To: <e02b024f-6ebc-e8fa-c30c-5bf3f4b164d6@arm.com>
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
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Jun 2019 13:45:02 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 07/06/2019 18:43, Jacob Pan wrote:
> >>> So it seems we agree on the following:
> >>> - iommu_unregister_device_fault_handler() will never fail
> >>> - iommu driver cleans up all pending faults when handler is
> >>> unregistered
> >>> - assume device driver or guest not sending more page response
> >>> _after_ handler is unregistered.
> >>> - system will tolerate rare spurious response
> >>>
> >>> Sounds right?    
> >>
> >> Yes, I'll add that to the fault series  
> > Hold on a second please, I think we need more clarifications. Ashok
> > pointed out to me that the spurious response can be harmful to other
> > devices when it comes to mdev, where PRQ group id is not per PASID,
> > device may reuse the group number and receiving spurious page
> > response can confuse the entire PF.   
> 
> I don't understand how mdev differs from the non-mdev situation (but I
> also still don't fully get how mdev+PASID will be implemented). Is the
> following the case you're worried about?
> 
>   M#: mdev #
> 
> # Dev         Host        mdev drv       VFIO/QEMU        Guest
> ====================================================================
> 1                     <- reg(handler)
> 2 PR1 G1 P1    ->         M1 PR1 G1        inject ->     M1 PR1 G1
> 3                     <- unreg(handler)
> 4       <- PS1 G1 P1 (F)      |
> 5                        unreg(handler)
> 6                     <- reg(handler)
> 7 PR2 G1 P1    ->         M2 PR2 G1        inject ->     M2 PR2 G1
> 8                                                     <- M1 PS1 G1
> 9         accept ??    <- PS1 G1 P1
> 10                                                    <- M2 PS2 G1
> 11        accept       <- PS2 G1 P1
> 
Not really. I am not worried about PASID reuse or unbind. Just within
the same PASID bind lifetime of a single mdev, back to back
register/unregister fault handler.
After Step 4, device will think G1 is done. Device could reuse G1 for
the next PR, if we accept PS1 in step 9, device will terminate G1 before
the real G1 PS arrives in Step 11. The real G1 PS might have a
different response code. Then we just drop the PS in Step 11?

If the device does not reuse G1 immediately, the spurious response to
G1 will get dropped no issue there.

> 
> Step 2 injects PR1 for mdev#1. Step 4 auto-responds to PR1. Between
> steps 5 and 6, we re-allocate PASID #1 for mdev #2. At step 7, we
> inject PR2 for mdev #2. Step 8 is the spurious Page Response for PR1.
> 
> But I don't think step 9 is possible, because the mdev driver knows
> that mdev #1 isn't using PASID #1 anymore. If the configuration is
> valid at all (a page response channel still exists for mdev #1), then
> mdev #1 now has a different PASID, e.g. #2, and step 9 would be "<-
> PS1 G1 P2" which is rejected by iommu.c (no such pending page
> request). And step 11 will be accepted.
> 
> If PASIDs are allocated through VCMD, then the situation seems
> similar: at step 2 you inject "M1 PR1 G1 P1" into the guest, and at
> step 8 the spurious response is "M1 PS1 G1 P1". If mdev #1 doesn't
> have PASID #1 anymore, then the mdev driver can check that the PASID
> is invalid and can reject the page response.
> 
> > Having spurious page response is also not
> > abiding the PCIe spec. exactly.  
> 
> We are following the PCI spec though, in that we don't send page
> responses for PRGIs that aren't in flight.
> 
You are right, the worst case of the spurious PS is to terminate the
group prematurely. Need to know the scope of the HW damage in case of mdev
where group IDs can be shared among mdevs belong to the same PF.

> > We have two options here:
> > 1. unregister handler will get -EBUSY if outstanding fault exists.
> > 	-PROs: block offending device unbind only, eventually
> > timeout will clear.
> > 	-CONs: flooded faults can prevent clearing
> > 2. unregister handle will block until all faults are clear in the
> > host. Never fails unregistration  
> 
> Here the host completes the faults itself or wait for a response from
> the guest? I'm slightly confused by the word "blocking". I'd rather we
> don't introduce an uninterruptible sleep in the IOMMU core, since it's
> unlikely to ever finish if we rely on the guest to complete things.
> 
No uninterruptible sleep, I meant unregister_handler is a sync call.
But no wait for guest's response.
> > 	-PROs: simple flow for VFIO, no need to worry about device
> > 	holding reference.
> > 	-CONs: spurious page response may come from
> > 	misbehaving/malicious guest if guest does unregister and
> > 	register back to back.  
> 
> > It seems the only way to prevent spurious page response is to
> > introduce a SW token or sequence# for each PRQ that needs a
> > response. I still think option 2 is good.
> > 
> > Consider the following time line:
> > decoding
> >  PR#: page request
> >  G#:  group #
> >  P#:  PASID
> >  S#:  sequence #
> >  A#:  address
> >  PS#: page response
> >  (F): Fail
> >  (S): Success
> > 
> > # Dev		Host		VFIO/QEMU	Guest
> > ===========================================================	
> > 1				<-reg(handler)
> > 2 PR1G1S1A1	->		inject	->
> > PR1G1S1A1 3 PR2G1S2A2	->
> > inject	->	PR2G1S2A2 4.
> > <-unreg(handler) 5.	<-PR1G1S1A1(F)			| 
> > 6.	<-PR2G1S2A2(F)			V
> > 7.				<-unreg(handler)
> > 8.				<-reg(handler)
> > 9 PR3G1S3A1	->		inject	->
> > PR3G1S3A1 10.
> > <-PS1G1S1A1 11.		<reject S1>
> > 11.		<accept S3>			<-PS3G1S3A1
> > 12.PS3G1S3A1(S)
> > 
> > The spurious page response comes in at step 10 where the guest sends
> > response for the request in step 1. But since the sequence # is 1,
> > host IOMMU driver will reject it. At step 11, we accept page
> > response for the matching sequence # then respond SUCCESS to the
> > device.
> > 
> > So would it be OK to add this sequence# to iommu_fault and page
> > response, or could event reuse the time stamp for that purpose.  
> 
> With a PV interface we can do what we want, but it can't work with an
> IOMMU emulation that only has 9 bits for the PRGI. I suppose we can
> add the sequence number but we'll have to handle the case where it
> isn't present in the page response (ie. accept it anyway).
> 
For VT-d emulation, we might be able to use the private data as
sequence# in vIOMMU. Keep the real private data in the host. Need Yi's
input. If private data is not present, then accept it anyway.

> Thanks,
> Jean
