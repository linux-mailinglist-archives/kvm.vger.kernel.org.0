Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CF739371
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfFGRj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:39:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:36843 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbfFGRj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:39:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 10:39:55 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002.jf.intel.com with ESMTP; 07 Jun 2019 10:39:55 -0700
Date:   Fri, 7 Jun 2019 10:43:01 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Vincent Stehle <Vincent.Stehle@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190607104301.6b1bbd74@jacob-builder>
In-Reply-To: <dc051424-67d7-02ff-9b8e-0d7a8a4e59eb@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-27-eric.auger@redhat.com>
        <20190603163139.70fe8839@x1.home>
        <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
        <20190605154553.0d00ad8d@jacob-builder>
        <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
        <20190606132903.064f7ac4@jacob-builder>
        <dc051424-67d7-02ff-9b8e-0d7a8a4e59eb@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jun 2019 11:28:13 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 06/06/2019 21:29, Jacob Pan wrote:
> >>>>>> iommu_unregister_device_fault_handler(&vdev->pdev->dev);      
> >>>>>
> >>>>>
> >>>>> But this can fail if there are pending faults which leaves a
> >>>>> device reference and then the system is broken :(      
> >>>> This series only features unrecoverable errors and for those the
> >>>> unregistration cannot fail. Now unrecoverable errors were added I
> >>>> admit this is confusing. We need to sort this out or clean the
> >>>> dependencies.    
> >>> As Alex pointed out in 4/29, we can make
> >>> iommu_unregister_device_fault_handler() never fail and clean up
> >>> all the pending faults in the host IOMMU belong to that device.
> >>> But the problem is that if a fault, such as PRQ, has already been
> >>> injected into the guest, the page response may come back after
> >>> handler is unregistered and registered again.    
> >>
> >> I'm trying to figure out if that would be harmful in any way. I
> >> guess it can be a bit nasty if we handle the page response right
> >> after having injected a new page request that uses the same PRGI.
> >> In any other case we discard the page response, but here we
> >> forward it to the endpoint and:
> >>
> >> * If the response status is success, endpoint retries the
> >> translation. The guest probably hasn't had time to handle the new
> >> page request and translation will fail, which may lead the endpoint
> >> to give up (two unsuccessful translation requests). Or send a new
> >> request
> >>  
> > Good point, there shouldn't be any harm if the page response is a
> > "fake" success. In fact it could happen in the normal operation when
> > PRQs to two devices share the same non-leaf translation structure.
> > The worst case is just a retry. I am not aware of the retry limit,
> > is it in the PCIe spec? I cannot find it.  
> 
> I don't think so, it's the implementation's choice. In general I don't
> think devices will have a retry limit, but it doesn't seem like the
> PCI spec prevents them from implementing one either. It could be
> useful to stop retrying after a certain number of faults, for
> preventing livelocks when the OS doesn't fix up the page tables and
> the device would just repeat the fault indefinitely.
> 
> > I think we should just document it, similar to having a spurious
> > interrupt. The PRQ trace event should capture that as well.
> >   
> >> * otherwise the endpoint won't retry the access, and could also
> >> disable PRI if the status is failure.
> >>  
> > That would be true regardless this race condition with handler
> > registration. So should be fine.  
> 
> We do give an invalid response for the old PRG (because of
> unregistering), but also for the new one, which has a different
> address that the guest might be able to page in and would normally
> return success.
> 
> >>> We need a way to reject such page response belong
> >>> to the previous life of the handler. Perhaps a sync call to the
> >>> guest with your fault queue eventfd? I am not sure.    
> >>
> >> We could simply expect the device driver not to send any page
> >> response after unregistering the fault handler. Is there any
> >> reason VFIO would need to unregister and re-register the fault
> >> handler on a live guest? 
> > There is no reason for VFIO to unregister and register again, I was
> > just thinking from security perspective. Someone could write a VFIO
> > app do this attack. But I agree the damage is within the device,
> > may get PRI disabled as a result.  
> 
> Yes I think the damage would always be contained within the
> misbehaving software
> 
> > So it seems we agree on the following:
> > - iommu_unregister_device_fault_handler() will never fail
> > - iommu driver cleans up all pending faults when handler is
> > unregistered
> > - assume device driver or guest not sending more page response
> > _after_ handler is unregistered.
> > - system will tolerate rare spurious response
> > 
> > Sounds right?  
> 
> Yes, I'll add that to the fault series
Hold on a second please, I think we need more clarifications. Ashok
pointed out to me that the spurious response can be harmful to other
devices when it comes to mdev, where PRQ group id is not per PASID,
device may reuse the group number and receiving spurious page response
can confuse the entire PF. Having spurious page response is also not
abiding the PCIe spec. exactly.

We have two options here:
1. unregister handler will get -EBUSY if outstanding fault exists.
	-PROs: block offending device unbind only, eventually timeout
	will clear.
	-CONs: flooded faults can prevent clearing
2. unregister handle will block until all faults are clear in the host.
   Never fails unregistration
	-PROs: simple flow for VFIO, no need to worry about device
	holding reference.
	-CONs: spurious page response may come from
	misbehaving/malicious guest if guest does unregister and
	register back to back.
It seems the only way to prevent spurious page response is to introduce
a SW token or sequence# for each PRQ that needs a response. I still
think option 2 is good.

Consider the following time line:
decoding
 PR#: page request
 G#:  group #
 P#:  PASID
 S#:  sequence #
 A#:  address
 PS#: page response
 (F): Fail
 (S): Success

# Dev		Host		VFIO/QEMU	Guest
===========================================================	
1				<-reg(handler)
2 PR1G1S1A1	->		inject	->	PR1G1S1A1
3 PR2G1S2A2	->		inject	->	PR2G1S2A2
4.				<-unreg(handler)
5.	<-PR1G1S1A1(F)			| 
6.	<-PR2G1S2A2(F)			V
7.				<-unreg(handler)
8.				<-reg(handler)
9 PR3G1S3A1	->		inject	->	PR3G1S3A1
10.						<-PS1G1S1A1
11.		<reject S1>
11.		<accept S3>			<-PS3G1S3A1
12.PS3G1S3A1(S)

The spurious page response comes in at step 10 where the guest sends
response for the request in step 1. But since the sequence # is 1, host
IOMMU driver will reject it. At step 11, we accept page response for
the matching sequence # then respond SUCCESS to the device.

So would it be OK to add this sequence# to iommu_fault and page
response, or could event reuse the time stamp for that purpose.


Jacob
