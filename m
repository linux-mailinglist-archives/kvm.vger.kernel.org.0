Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E2731D0A5
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 20:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhBPTFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 14:05:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:18311 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhBPTFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 14:05:39 -0500
IronPort-SDR: kjS5zar2hIBXTcW8hzxKaD9h6zL5xTIA8zQms24XVYOMnB+97WvjOIg2LnLquGG/3QRhTFQKCh
 J46PLEZTL8XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="247053730"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="247053730"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 11:04:58 -0800
IronPort-SDR: IkXRk4kgwxnBP95KswecI/URFxEMO6foUMEHjp9OaizJkObckv3e/7XQzMgJrGF/eg0ca7jaPc
 KCLhLBQpUlFg==
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="439051318"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.209.30.169]) ([10.209.30.169])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 11:04:56 -0800
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, parav@mellanox.com, netanelg@mellanox.com,
        shahafs@mellanox.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
Date:   Tue, 16 Feb 2021 12:04:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210235924.GJ4247@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/10/2021 4:59 PM, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 01:53:24PM -0700, Dave Jiang wrote:
>
>> +static int check_vma(struct idxd_wq *wq, struct vm_area_struct *vma)
>>   {
>> -	/* FIXME: Fill in later */
>> +	if (vma->vm_end < vma->vm_start)
>> +		return -EINVAL;
> These checks are redundant

Thanks. Will remove.

>
>> -static int idxd_mdev_host_release(struct idxd_device *idxd)
>> +static int idxd_vdcm_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
>> +{
>> +	unsigned int wq_idx, rc;
>> +	unsigned long req_size, pgoff = 0, offset;
>> +	pgprot_t pg_prot;
>> +	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
>> +	struct idxd_wq *wq = vidxd->wq;
>> +	struct idxd_device *idxd = vidxd->idxd;
>> +	enum idxd_portal_prot virt_portal, phys_portal;
>> +	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
>> +	struct device *dev = mdev_dev(mdev);
>> +
>> +	rc = check_vma(wq, vma);
>> +	if (rc)
>> +		return rc;
>> +
>> +	pg_prot = vma->vm_page_prot;
>> +	req_size = vma->vm_end - vma->vm_start;
>> +	vma->vm_flags |= VM_DONTCOPY;
>> +
>> +	offset = (vma->vm_pgoff << PAGE_SHIFT) &
>> +		 ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
>> +
>> +	wq_idx = offset >> (PAGE_SHIFT + 2);
>> +	if (wq_idx >= 1) {
>> +		dev_err(dev, "mapping invalid wq %d off %lx\n",
>> +			wq_idx, offset);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Check and see if the guest wants to map to the limited or unlimited portal.
>> +	 * The driver will allow mapping to unlimited portal only if the the wq is a
>> +	 * dedicated wq. Otherwise, it goes to limited.
>> +	 */
>> +	virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
>> +	phys_portal = IDXD_PORTAL_LIMITED;
>> +	if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
>> +		phys_portal = IDXD_PORTAL_UNLIMITED;
>> +
>> +	/* We always map IMS portals to the guest */
>> +	pgoff = (base + idxd_get_wq_portal_full_offset(wq->id, phys_portal,
>> +						       IDXD_IRQ_IMS)) >> PAGE_SHIFT;
>> +	dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
>> +		pgprot_val(pg_prot));
>> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +	vma->vm_private_data = mdev;
> What ensures the mdev pointer is valid strictly longer than the VMA?
> This needs refcounting.

Going to take a kref at open and then put_device at close. Does that 
sound reasonable or should I be calling get_device() in mmap() and then 
register a notifier for when vma is released?


>
>> +	vma->vm_pgoff = pgoff;
>> +
>> +	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);
> Nothing validated req_size - did you copy this from the Intel RDMA
> driver? It had a huge security bug just like this.
Thanks. Will add. Some of the code came from the Intel i915 mdev driver.
>> +
>> +static int msix_trigger_unregister(struct vdcm_idxd *vidxd, int index)
>> +{
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +	struct ims_irq_entry *irq_entry;
>> +	int rc;
>> +
>> +	if (!vidxd->vdev.msix_trigger[index])
>> +		return 0;
>> +
>> +	dev_dbg(dev, "disable MSIX trigger %d\n", index);
>> +	if (index) {
>> +		u32 auxval;
>> +
>> +		irq_entry = &vidxd->irq_entries[index];
>> +		if (irq_entry->irq_set) {
>> +			free_irq(irq_entry->irq, irq_entry);
>> +			irq_entry->irq_set = false;
>> +		}
>> +
>> +		auxval = ims_ctrl_pasid_aux(0, false);
>> +		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +	eventfd_ctx_put(vidxd->vdev.msix_trigger[index]);
>> +	vidxd->vdev.msix_trigger[index] = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
>> +{
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +	struct ims_irq_entry *irq_entry;
>> +	struct eventfd_ctx *trigger;
>> +	int rc;
>> +
>> +	if (vidxd->vdev.msix_trigger[index])
>> +		return 0;
>> +
>> +	dev_dbg(dev, "enable MSIX trigger %d\n", index);
>> +	trigger = eventfd_ctx_fdget(fd);
>> +	if (IS_ERR(trigger)) {
>> +		dev_warn(dev, "eventfd_ctx_fdget failed %d\n", index);
>> +		return PTR_ERR(trigger);
>> +	}
>> +
>> +	if (index) {
>> +		u32 pasid;
>> +		u32 auxval;
>> +
>> +		irq_entry = &vidxd->irq_entries[index];
>> +		rc = idxd_mdev_get_pasid(mdev, &pasid);
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		/*
>> +		 * Program and enable the pasid field in the IMS entry. The programmed pasid and
>> +		 * enabled field is checked against the  pasid and enable field for the work queue
>> +		 * configuration and the pasid for the descriptor. A mismatch will result in blocked
>> +		 * IMS interrupt.
>> +		 */
>> +		auxval = ims_ctrl_pasid_aux(pasid, true);
>> +		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		rc = request_irq(irq_entry->irq, idxd_guest_wq_completion, 0, "idxd-ims",
>> +				 irq_entry);
>> +		if (rc) {
>> +			dev_warn(dev, "failed to request ims irq\n");
>> +			eventfd_ctx_put(trigger);
>> +			auxval = ims_ctrl_pasid_aux(0, false);
>> +			irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
>> +			return rc;
>> +		}
>> +		irq_entry->irq_set = true;
>> +	}
>> +
>> +	vidxd->vdev.msix_trigger[index] = trigger;
>> +	return 0;
>> +}
>> +
>> +static int vdcm_idxd_set_msix_trigger(struct vdcm_idxd *vidxd,
>> +				      unsigned int index, unsigned int start,
>> +				      unsigned int count, uint32_t flags,
>> +				      void *data)
>> +{
>> +	int i, rc = 0;
>> +
>> +	if (count > VIDXD_MAX_MSIX_ENTRIES - 1)
>> +		count = VIDXD_MAX_MSIX_ENTRIES - 1;
>> +
>> +	if (count == 0 && (flags & VFIO_IRQ_SET_DATA_NONE)) {
>> +		/* Disable all MSIX entries */
>> +		for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
>> +			rc = msix_trigger_unregister(vidxd, i);
>> +			if (rc < 0)
>> +				return rc;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	for (i = 0; i < count; i++) {
>> +		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>> +			u32 fd = *(u32 *)(data + i * sizeof(u32));
>> +
>> +			rc = msix_trigger_register(vidxd, fd, i);
>> +			if (rc < 0)
>> +				return rc;
>> +		} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
>> +			rc = msix_trigger_unregister(vidxd, i);
>> +			if (rc < 0)
>> +				return rc;
>> +		}
>> +	}
>> +	return rc;
>> +}
>> +
>> +static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
>> +			      unsigned int index, unsigned int start,
>> +			      unsigned int count, void *data)
>> +{
>> +	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
>> +		    unsigned int start, unsigned int count, uint32_t flags,
>> +		    void *data) = NULL;
>> +	struct mdev_device *mdev = vidxd->vdev.mdev;
>> +	struct device *dev = mdev_dev(mdev);
>> +
>> +	switch (index) {
>> +	case VFIO_PCI_INTX_IRQ_INDEX:
>> +		dev_warn(dev, "intx interrupts not supported.\n");
>> +		break;
>> +	case VFIO_PCI_MSI_IRQ_INDEX:
>> +		dev_dbg(dev, "msi interrupt.\n");
>> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>> +		case VFIO_IRQ_SET_ACTION_MASK:
>> +		case VFIO_IRQ_SET_ACTION_UNMASK:
>> +			break;
>> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
>> +			func = vdcm_idxd_set_msix_trigger;
> This would be a good place to insert a common VFIO helper library to
> take care of the MSI-X emulation for IMS.

I took a look at the idxd version vs the VFIO version and they are 
somewhat different. Although the MSI and MSIX case can be squashed in 
the idxd driver code. I do think that the parent code block can be split 
out in VFIO code and made into a common helper function to deal with 
VFIO_DEVICE_SET_IRQS and I've done so.


>> +int idxd_mdev_host_init(struct idxd_device *idxd)
>> +{
>> +	struct device *dev = &idxd->pdev->dev;
>> +	int rc;
>> +
>> +	if (!test_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
>> +		rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);
> Huh. This is the first user of IOMMU_DEV_FEAT_AUX, why has so much
> dead-code infrastructure been already merged around this?
>
>
>> @@ -34,6 +1024,7 @@ static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
>>   		return rc;
>>   	}
>>   
>> +	set_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);
> Something is being done wrong if this flag is needed

Will remove.


>
>> +int vidxd_send_interrupt(struct ims_irq_entry *iie)
>> +{
>> +	/* PLACE HOLDER */
>> +	return 0;
>> +}
> Here too, don't structure the patches like this

This is the unfortunately result of attempting to split the driver code 
into manageable patches from inherited code. Do you suggest I organize 
it such that I add the function definitions first so we don't deal with 
empty functions?

>
>> diff --git a/drivers/vfio/mdev/idxd/vdev.h b/drivers/vfio/mdev/idxd/vdev.h
>> new file mode 100644
>> index 000000000000..cc2ba6ccff7b
>> +++ b/drivers/vfio/mdev/idxd/vdev.h
>> @@ -0,0 +1,19 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
>> +
>> +#ifndef _IDXD_VDEV_H_
>> +#define _IDXD_VDEV_H_
>> +
>> +#include "mdev.h"
>> +
>> +int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
>> +int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
>> +int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
>> +int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
>> +void vidxd_mmio_init(struct vdcm_idxd *vidxd);
>> +void vidxd_reset(struct vdcm_idxd *vidxd);
>> +int vidxd_send_interrupt(struct ims_irq_entry *iie);
>> +int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
>> +void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
> Why are these functions special??

I'm not sure I follow the intent of this question. The vidxd_* functions 
are split out to vdev.c because they are the emulation helper functions 
for the mdev. It seems reasonable to split them out from the mdev code 
to make it more manageable.


>
> Jason
