Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B761A36793
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 00:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfFEWmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 18:42:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:12498 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFEWmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 18:42:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 15:42:48 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2019 15:42:48 -0700
Date:   Wed, 5 Jun 2019 15:45:53 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org, yi.l.liu@intel.com,
        jean-philippe.brucker@arm.com, will.deacon@arm.com,
        robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com,
        marc.zyngier@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v8 26/29] vfio-pci: Register an iommu fault handler
Message-ID: <20190605154553.0d00ad8d@jacob-builder>
In-Reply-To: <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-27-eric.auger@redhat.com>
        <20190603163139.70fe8839@x1.home>
        <10dd60d9-4af0-c0eb-08c9-a0db7ee1925e@redhat.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Jun 2019 18:11:08 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 6/4/19 12:31 AM, Alex Williamson wrote:
> > On Sun, 26 May 2019 18:10:01 +0200
> > Eric Auger <eric.auger@redhat.com> wrote:
> >   
> >> This patch registers a fault handler which records faults in
> >> a circular buffer and then signals an eventfd. This buffer is
> >> exposed within the fault region.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v3 -> v4:
> >> - move iommu_unregister_device_fault_handler to vfio_pci_release
> >> ---
> >>  drivers/vfio/pci/vfio_pci.c         | 49
> >> +++++++++++++++++++++++++++++ drivers/vfio/pci/vfio_pci_private.h
> >> |  1 + 2 files changed, 50 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci.c
> >> b/drivers/vfio/pci/vfio_pci.c index f75f61127277..520999994ba8
> >> 100644 --- a/drivers/vfio/pci/vfio_pci.c
> >> +++ b/drivers/vfio/pci/vfio_pci.c
> >> @@ -30,6 +30,7 @@
> >>  #include <linux/vfio.h>
> >>  #include <linux/vgaarb.h>
> >>  #include <linux/nospec.h>
> >> +#include <linux/circ_buf.h>
> >>  
> >>  #include "vfio_pci_private.h"
> >>  
> >> @@ -296,6 +297,46 @@ static const struct vfio_pci_regops
> >> vfio_pci_fault_prod_regops = { .add_capability =
> >> vfio_pci_fault_prod_add_capability, };
> >>  
> >> +int vfio_pci_iommu_dev_fault_handler(struct iommu_fault_event
> >> *evt, void *data) +{
> >> +	struct vfio_pci_device *vdev = (struct vfio_pci_device *)
> >> data;
> >> +	struct vfio_region_fault_prod *prod_region =
> >> +		(struct vfio_region_fault_prod
> >> *)vdev->fault_pages;
> >> +	struct vfio_region_fault_cons *cons_region =
> >> +		(struct vfio_region_fault_cons
> >> *)(vdev->fault_pages + 2 * PAGE_SIZE);
> >> +	struct iommu_fault *new =
> >> +		(struct iommu_fault *)(vdev->fault_pages +
> >> prod_region->offset +
> >> +			prod_region->prod *
> >> prod_region->entry_size);
> >> +	int prod, cons, size;
> >> +
> >> +	mutex_lock(&vdev->fault_queue_lock);
> >> +
> >> +	if (!vdev->fault_abi)
> >> +		goto unlock;
> >> +
> >> +	prod = prod_region->prod;
> >> +	cons = cons_region->cons;
> >> +	size = prod_region->nb_entries;
> >> +
> >> +	if (CIRC_SPACE(prod, cons, size) < 1)
> >> +		goto unlock;
> >> +
> >> +	*new = evt->fault;
> >> +	prod = (prod + 1) % size;
> >> +	prod_region->prod = prod;
> >> +	mutex_unlock(&vdev->fault_queue_lock);
> >> +
> >> +	mutex_lock(&vdev->igate);
> >> +	if (vdev->dma_fault_trigger)
> >> +		eventfd_signal(vdev->dma_fault_trigger, 1);
> >> +	mutex_unlock(&vdev->igate);
> >> +	return 0;
> >> +
> >> +unlock:
> >> +	mutex_unlock(&vdev->fault_queue_lock);
> >> +	return -EINVAL;
> >> +}
> >> +
> >>  static int vfio_pci_init_fault_region(struct vfio_pci_device
> >> *vdev) {
> >>  	struct vfio_region_fault_prod *header;
> >> @@ -328,6 +369,13 @@ static int vfio_pci_init_fault_region(struct
> >> vfio_pci_device *vdev) header = (struct vfio_region_fault_prod
> >> *)vdev->fault_pages; header->version = -1;
> >>  	header->offset = PAGE_SIZE;
> >> +
> >> +	ret =
> >> iommu_register_device_fault_handler(&vdev->pdev->dev,
> >> +
> >> vfio_pci_iommu_dev_fault_handler,
> >> +					vdev);
> >> +	if (ret)
> >> +		goto out;
> >> +
> >>  	return 0;
> >>  out:
> >>  	kfree(vdev->fault_pages);
> >> @@ -570,6 +618,7 @@ static void vfio_pci_release(void *device_data)
> >>  	if (!(--vdev->refcnt)) {
> >>  		vfio_spapr_pci_eeh_release(vdev->pdev);
> >>  		vfio_pci_disable(vdev);
> >> +
> >> iommu_unregister_device_fault_handler(&vdev->pdev->dev);  
> > 
> > 
> > But this can fail if there are pending faults which leaves a device
> > reference and then the system is broken :(  
> This series only features unrecoverable errors and for those the
> unregistration cannot fail. Now unrecoverable errors were added I
> admit this is confusing. We need to sort this out or clean the
> dependencies.
As Alex pointed out in 4/29, we can make
iommu_unregister_device_fault_handler() never fail and clean up all the
pending faults in the host IOMMU belong to that device. But the problem
is that if a fault, such as PRQ, has already been injected into the
guest, the page response may come back after handler is unregistered
and registered again. We need a way to reject such page response belong
to the previous life of the handler. Perhaps a sync call to the guest
with your fault queue eventfd? I am not sure.

Jacob
