Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E9B39217
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 18:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbfFGQ3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 12:29:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730521AbfFGQ3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 12:29:50 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 702B630872DE;
        Fri,  7 Jun 2019 16:29:42 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C93318CFA6;
        Fri,  7 Jun 2019 16:29:33 +0000 (UTC)
Date:   Fri, 7 Jun 2019 10:29:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        jean-philippe.brucker@arm.com, will.deacon@arm.com,
        robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com,
        marc.zyngier@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
Subject: Re: [PATCH v8 25/29] vfio-pci: Add a new VFIO_REGION_TYPE_NESTED
 region type
Message-ID: <20190607102931.0bf2dfe0@x1.home>
In-Reply-To: <9c1ea2db-5ba0-3cf5-3b38-2c4a125460e6@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-26-eric.auger@redhat.com>
        <20190603163159.31e7ae23@x1.home>
        <9c1ea2db-5ba0-3cf5-3b38-2c4a125460e6@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 07 Jun 2019 16:29:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jun 2019 10:28:06 +0200
Auger Eric <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 6/4/19 12:31 AM, Alex Williamson wrote:
> > On Sun, 26 May 2019 18:10:00 +0200
> > Eric Auger <eric.auger@redhat.com> wrote:
> >   
> >> This patch adds two new regions aiming to handle nested mode
> >> translation faults.
> >>
> >> The first region (two host kernel pages) is read-only from the
> >> user-space perspective. The first page contains an header
> >> that provides information about the circular buffer located in the
> >> second page. The circular buffer is put in a different page in
> >> the prospect to be mmappable.
> >>
> >> The max user API version supported by the kernel is returned
> >> through a dedicated fault region capability.
> >>
> >> The prod header contains
> >> - the user API version in use (potentially inferior to the one
> >>   returned in the capability),
> >> - the offset of the queue within the region,
> >> - the producer index relative to the start of the queue
> >> - the max number of fault records,
> >> - the size of each record.
> >>
> >> The second region is write-only from the user perspective. It
> >> contains the version of the requested fault ABI and the consumer
> >> index that is updated by the userspace each time this latter has
> >> consumed fault records.
> >>
> >> The natural order of operation for the userspace is:
> >> - retrieve the highest supported fault ABI version
> >> - set the requested fault ABI version in the consumer region
> >>
> >> Until the ABI version is not set by the userspace, the kernel
> >> cannot return a comprehensive set of information inside the
> >> prod header (entry size and number of entries in the fault queue).  
> > 
> > It's not clear to me why two regions are required for this.  If the
> > first page is not mmap capable, why does it need to be read-only?  If
> > it were not read-only couldn't the fields of the second region also fit
> > within this first page?  If you wanted to deal with an mmap capable
> > writeable region, it could just be yet a 3rd page in the first region.  
> I thought it would be clearer for the userspace to have 2 separate
> regions, one for the producer and one for the consumer. Otherwise I will
> need to specify which fields are read-only or write-only. But this may
> be more self-contained in a single region.

We need to figure out read vs write anyway, but separating them to
separate regions just for that seems unnecessary.  How many regions do
we expect to require for a single feature?

> >   
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v4 -> v5
> >> - check cons is not null in vfio_pci_check_cons_fault
> >>
> >> v3 -> v4:
> >> - use 2 separate regions, respectively in read and write modes
> >> - add the version capability
> >> ---
> >>  drivers/vfio/pci/vfio_pci.c         | 105 ++++++++++++++++++++++++++++
> >>  drivers/vfio/pci/vfio_pci_private.h |  17 +++++
> >>  drivers/vfio/pci/vfio_pci_rdwr.c    |  73 +++++++++++++++++++
> >>  include/uapi/linux/vfio.h           |  42 +++++++++++
> >>  4 files changed, 237 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> >> index cab71da46f4a..f75f61127277 100644
> >> --- a/drivers/vfio/pci/vfio_pci.c
> >> +++ b/drivers/vfio/pci/vfio_pci.c
> >> @@ -261,6 +261,106 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
> >>  	return ret;
> >>  }
> >>  
> >> +void vfio_pci_fault_release(struct vfio_pci_device *vdev,
> >> +			    struct vfio_pci_region *region)
> >> +{
> >> +}
> >> +
> >> +static const struct vfio_pci_fault_abi fault_abi_versions[] = {
> >> +	[0] = {
> >> +		.entry_size = sizeof(struct iommu_fault),
> >> +	},
> >> +};
> >> +
> >> +#define NR_FAULT_ABIS ARRAY_SIZE(fault_abi_versions)  
> > 
> > This looks like it's leading to some dangerous complicated code to
> > support multiple user selected ABIs.  How many ABIs do we plan to
> > support?  The region capability also exposes a type, sub-type, and
> > version.  How much of this could be exposed that way?  ie. if we need
> > to support multiple versions, expose multiple regions.  
> 
> This is something that was discussed earlier and suggested by
> Jean-Philippe that we may need to support several versions of the ABI
> (typicallu when adding PRI support).
> Exposing multiple region is an interesting idea and I will explore that
> direction.
> >   
> >> +
> >> +static int vfio_pci_fault_prod_add_capability(struct vfio_pci_device *vdev,
> >> +		struct vfio_pci_region *region, struct vfio_info_cap *caps)
> >> +{
> >> +	struct vfio_region_info_cap_fault cap = {
> >> +		.header.id = VFIO_REGION_INFO_CAP_PRODUCER_FAULT,
> >> +		.header.version = 1,
> >> +		.version = NR_FAULT_ABIS,
> >> +	};
> >> +	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
> >> +}
> >> +
> >> +static const struct vfio_pci_regops vfio_pci_fault_cons_regops = {
> >> +	.rw		= vfio_pci_fault_cons_rw,
> >> +	.release	= vfio_pci_fault_release,
> >> +};
> >> +
> >> +static const struct vfio_pci_regops vfio_pci_fault_prod_regops = {
> >> +	.rw		= vfio_pci_fault_prod_rw,
> >> +	.release	= vfio_pci_fault_release,
> >> +	.add_capability = vfio_pci_fault_prod_add_capability,
> >> +};
> >> +
> >> +static int vfio_pci_init_fault_region(struct vfio_pci_device *vdev)
> >> +{
> >> +	struct vfio_region_fault_prod *header;
> >> +	int ret;
> >> +
> >> +	mutex_init(&vdev->fault_queue_lock);
> >> +
> >> +	vdev->fault_pages = kzalloc(3 * PAGE_SIZE, GFP_KERNEL);
> >> +	if (!vdev->fault_pages)
> >> +		return -ENOMEM;
> >> +
> >> +	ret = vfio_pci_register_dev_region(vdev,
> >> +		VFIO_REGION_TYPE_NESTED,
> >> +		VFIO_REGION_SUBTYPE_NESTED_FAULT_PROD,
> >> +		&vfio_pci_fault_prod_regops, 2 * PAGE_SIZE,
> >> +		VFIO_REGION_INFO_FLAG_READ, vdev->fault_pages);  
> > 
> > If mmap isn't supported yet, why are we pushing the queue out to the
> > 2nd page?  We're just wasting space.  vfio_region_fault_prod.offset
> > allows us to relocate it when/if it is mmap capable.  
> OK. mmap capability is introduced in 27/29 though.
> >   
> >> +	if (ret)
> >> +		goto out;
> >> +
> >> +	ret = vfio_pci_register_dev_region(vdev,
> >> +		VFIO_REGION_TYPE_NESTED,
> >> +		VFIO_REGION_SUBTYPE_NESTED_FAULT_CONS,
> >> +		&vfio_pci_fault_cons_regops,
> >> +		sizeof(struct vfio_region_fault_cons),
> >> +		VFIO_REGION_INFO_FLAG_WRITE,
> >> +		vdev->fault_pages + 2 * PAGE_SIZE);  
> > 
> > What's the remaining (PAGE_SIZE - sizeof(struct vfio_region_fault_cons))
> > bytes used for?  
> They are not used.

So we probably don't want to allocate a full page for it.  Seems little
reason to separate by pages when mmap is not supported anyway.
 
> >> +	if (ret)
> >> +		goto out;
> >> +
> >> +	header = (struct vfio_region_fault_prod *)vdev->fault_pages;
> >> +	header->version = -1;
> >> +	header->offset = PAGE_SIZE;
> >> +	return 0;
> >> +out:
> >> +	kfree(vdev->fault_pages);
> >> +	return ret;
> >> +}
> >> +
> >> +int vfio_pci_check_cons_fault(struct vfio_pci_device *vdev,
> >> +			     struct vfio_region_fault_cons *cons_header)
> >> +{
> >> +	struct vfio_region_fault_prod *prod_header =
> >> +		(struct vfio_region_fault_prod *)vdev->fault_pages;
> >> +
> >> +	if (cons_header->version > NR_FAULT_ABIS)
> >> +		return -EINVAL;
> >> +
> >> +	if (!vdev->fault_abi) {
> >> +		vdev->fault_abi = cons_header->version;
> >> +		prod_header->entry_size =
> >> +			fault_abi_versions[vdev->fault_abi - 1].entry_size;
> >> +		prod_header->nb_entries = PAGE_SIZE / prod_header->entry_size;  
> > 
> > Is this sufficient for 4K hosts?  Clearly a 64K host has 16x the number
> > of entries, so if this is a heuristic the results are vastly different.  
> This series only deals with unrecoverable errors. We don't expect many
> of them so I did not consider the need to have a more complicated
> heuristic. Now if we consider the PRI use case we need to reconsider the
> size of the fault queue. If this feature is introduced later with a new
> region type, then we can handle this later?
> 
> Practically the event queue size is set by the guest SMMUv3 driver and
> trapped at the SMMUV3 QEMU device level. So we could communicate this
> info through IOMMU MR notifiers but that's a rather complicated chain
> and I would rather avoid that complexity if not necessary.

I'd hope that this interface accounts for both errors and page mapping
requests and that things like queue size are specified in the user
interface to account for these sorts of differences.  Thanks,

Alex
