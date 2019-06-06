Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8008437EAF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFFUZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:25:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:51641 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfFFUZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 16:25:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 13:25:58 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2019 13:25:57 -0700
Date:   Thu, 6 Jun 2019 13:29:03 -0700
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
Message-ID: <20190606132903.064f7ac4@jacob-builder>
In-Reply-To: <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-27-eric.auger@redhat.com>
        <20190603163139.70fe8839@x1.home>
        <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
        <20190605154553.0d00ad8d@jacob-builder>
        <2753d192-1c46-d78e-c425-0c828e48cde2@arm.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Jun 2019 19:54:05 +0100
Jean-Philippe Brucker <jean-philippe.brucker@arm.com> wrote:

> On 05/06/2019 23:45, Jacob Pan wrote:
> > On Tue, 4 Jun 2019 18:11:08 +0200
> > Auger Eric <eric.auger@redhat.com> wrote:
> >   
> >> Hi Alex,
> >>
> >> On 6/4/19 12:31 AM, Alex Williamson wrote:  
> >>> On Sun, 26 May 2019 18:10:01 +0200
> >>> Eric Auger <eric.auger@redhat.com> wrote:
> >>>     
> >>>> This patch registers a fault handler which records faults in
> >>>> a circular buffer and then signals an eventfd. This buffer is
> >>>> exposed within the fault region.
> >>>>
> >>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>>>
> >>>> ---
> >>>>
> >>>> v3 -> v4:
> >>>> - move iommu_unregister_device_fault_handler to vfio_pci_release
> >>>> ---
> >>>>  drivers/vfio/pci/vfio_pci.c         | 49
> >>>> +++++++++++++++++++++++++++++ drivers/vfio/pci/vfio_pci_private.h
> >>>> |  1 + 2 files changed, 50 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci.c
> >>>> b/drivers/vfio/pci/vfio_pci.c index f75f61127277..520999994ba8
> >>>> 100644 --- a/drivers/vfio/pci/vfio_pci.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci.c
> >>>> @@ -30,6 +30,7 @@
> >>>>  #include <linux/vfio.h>
> >>>>  #include <linux/vgaarb.h>
> >>>>  #include <linux/nospec.h>
> >>>> +#include <linux/circ_buf.h>
> >>>>  
> >>>>  #include "vfio_pci_private.h"
> >>>>  
> >>>> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops
> >>>> vfio_pci_fault_prod_regops = { .add_capability =
> >>>> vfio_pci_fault_prod_add_capability, };
> >>>>  
> >>>> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event
> >>>> *evt, void *data) +{
> >>>> +	struct vfio_pci_device *vdev = (struct vfio_pci_device
> >>>> *) data;
> >>>> +	struct vfio_region_fault_prod *prod_region =
> >>>> +		(struct vfio_region_fault_prod
> >>>> *)vdev->fault_pages;
> >>>> +	struct vfio_region_fault_cons *cons_region =
> >>>> +		(struct vfio_region_fault_cons
> >>>> *)(vdev->fault_pages + 2 * PAGE_SIZE);
> >>>> +	struct iommu_fault *new =
> >>>> +		(struct iommu_fault *)(vdev->fault_pages +
> >>>> prod_region->offset +
> >>>> +			prod_region->prod *
> >>>> prod_region->entry_size);
> >>>> +	int prod, cons, size;
> >>>> +
> >>>> +	mutex_lock(&vdev->fault_queue_lock);
> >>>> +
> >>>> +	if (!vdev->fault_abi)
> >>>> +		goto unlock;
> >>>> +
> >>>> +	prod = prod_region->prod;
> >>>> +	cons = cons_region->cons;
> >>>> +	size = prod_region->nb_entries;
> >>>> +
> >>>> +	if (CIRC_SPACE(prod, cons, size) < 1)
> >>>> +		goto unlock;
> >>>> +
> >>>> +	*new = evt->fault;
> >>>> +	prod = (prod + 1) % size;
> >>>> +	prod_region->prod = prod;
> >>>> +	mutex_unlock(&vdev->fault_queue_lock);
> >>>> +
> >>>> +	mutex_lock(&vdev->igate);
> >>>> +	if (vdev->dma_fault_trigger)
> >>>> +		eventfd_signal(vdev->dma_fault_trigger, 1);
> >>>> +	mutex_unlock(&vdev->igate);
> >>>> +	return 0;
> >>>> +
> >>>> +unlock:
> >>>> +	mutex_unlock(&vdev->fault_queue_lock);
> >>>> +	return -EINVAL;
> >>>> +}
> >>>> +
> >>>>  static int vfio_pci_init_fault_region(struct vfio_pci_device
> >>>> *vdev) {
> >>>>  	struct vfio_region_fault_prod *header;
> >>>> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct
> >>>> vfio_pci_device *vdev) header = (struct vfio_region_fault_prod
> >>>> *)vdev->fault_pages; header->version = -1;
> >>>>  	header->offset = PAGE_SIZE;
> >>>> +
> >>>> +	ret =
> >>>> iommu_register_device_fault_handler(&vdev->pdev->dev,
> >>>> +
> >>>> vfio_pci_iommu_dev_fault_handler,
> >>>> +					vdev);
> >>>> +	if (ret)
> >>>> +		goto out;
> >>>> +
> >>>>  	return 0;
> >>>>  out:
> >>>>  	kfree(vdev->fault_pages);
> >>>> @@ -570,6 +618,7 @@ static void vfio_pci_release(void
> >>>> *device_data) if (!(--vdev->refcnt)) {
> >>>>  		vfio_spapr_pci_eeh_release(vdev->pdev);
> >>>>  		vfio_pci_disable(vdev);
> >>>> +
> >>>> iommu_unregister_device_fault_handler(&vdev->pdev->dev);    
> >>>
> >>>
> >>> But this can fail if there are pending faults which leaves a
> >>> device reference and then the system is broken :(    
> >> This series only features unrecoverable errors and for those the
> >> unregistration cannot fail. Now unrecoverable errors were added I
> >> admit this is confusing. We need to sort this out or clean the
> >> dependencies.  
> > As Alex pointed out in 4/29, we can make
> > iommu_unregister_device_fault_handler() never fail and clean up all
> > the pending faults in the host IOMMU belong to that device. But the
> > problem is that if a fault, such as PRQ, has already been injected
> > into the guest, the page response may come back after handler is
> > unregistered and registered again.  
> 
> I'm trying to figure out if that would be harmful in any way. I guess
> it can be a bit nasty if we handle the page response right after
> having injected a new page request that uses the same PRGI. In any
> other case we discard the page response, but here we forward it to
> the endpoint and:
> 
> * If the response status is success, endpoint retries the
> translation. The guest probably hasn't had time to handle the new
> page request and translation will fail, which may lead the endpoint
> to give up (two unsuccessful translation requests). Or send a new
> request
> 
Good point, there shouldn't be any harm if the page response is a
"fake" success. In fact it could happen in the normal operation when
PRQs to two devices share the same non-leaf translation structure. The
worst case is just a retry. I am not aware of the retry limit, is it in
the PCIe spec? I cannot find it.

I think we should just document it, similar to having a spurious
interrupt. The PRQ trace event should capture that as well.

> * otherwise the endpoint won't retry the access, and could also
> disable PRI if the status is failure.
> 
That would be true regardless this race condition with handler
registration. So should be fine.

> > We need a way to reject such page response belong
> > to the previous life of the handler. Perhaps a sync call to the
> > guest with your fault queue eventfd? I am not sure.  
> 
> We could simply expect the device driver not to send any page response
> after unregistering the fault handler. Is there any reason VFIO would
> need to unregister and re-register the fault handler on a live guest?
> 
There is no reason for VFIO to unregister and register again, I was
just thinking from security perspective. Someone could write a VFIO app
do this attack. But I agree the damage is within the device, may get
PRI disabled as a result.

So it seems we agree on the following:
- iommu_unregister_device_fault_handler() will never fail
- iommu driver cleans up all pending faults when handler is unregistered
- assume device driver or guest not sending more page response _after_
  handler is unregistered.
- system will tolerate rare spurious response

Sounds right?

> Thanks,
> Jean

[Jacob Pan]
