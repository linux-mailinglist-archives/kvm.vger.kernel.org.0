Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831963174DC
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 01:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhBKAAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 19:00:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16979 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhBKAAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 19:00:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602473650000>; Wed, 10 Feb 2021 15:59:33 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 23:59:31 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 23:59:29 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 23:59:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZE73QOvArqlRMErkL9FX1bmizWPt3V2mBQn9UIGM5K/o7injqYihwWCS5lzZGLgbTr3g+REP0uber4JgURxyYFbo7G54M2b8/wmw2yYusj8fYxyiXq5PWKaAw6NdzpdRm9r89RdUQUbmPTpQJvhnb3AJ9gMsL4BpBpDxoN4eDH4W8tK2x99GAl+Ri9Cy1jfvmK/poDLOx54ChwE5HrmuZxY/obin/8c2QvN1BTGSI4bQ3m4Fjj+qmzAAI81WWoMAlFWe1Jzz9+/EBfM90t2TyHFyEw5byK+7O84R5u56Kyedt6ItcAAIsfw7C5sDVgj5wuTpI0BDQDjU2/MYpl818g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JUPEmN4dVgkBxOz+LvCz2eb0nvSv75QXtMWb8Rtiqw=;
 b=RpPiBahIJEcFMN5mfR5hGdeOIsoAswbn4+hl7JGY67tcm0Pt3JLT4GebLQaUGWM9YLBLHjw2PaWBEvCGdqs9x6BC3n84X9P+2J6M1B/9s48ge5yf1gJua5FqfBXVQBMZ/gHEQtLI/jUYAshWNgpKcaqjGmN3m1/7ddDyG79F7ZlcihODcQ92iGl62oLLacZyPRaVTRbE3s62X55yCrOq88v1rIPu00vNYw7OrWJ8csMSbeSvONivaDGfcObg9or7LmYrhOEqqlRpewUzRpDDwnFXQmg1Aj+boDPLAUGkKl0VHSFkU1IOCXn0v4HRxu+oqQaV1g9uS0bkwUW/rWcW1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2581.namprd12.prod.outlook.com (2603:10b6:4:b2::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 10 Feb
 2021 23:59:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 23:59:26 +0000
Date:   Wed, 10 Feb 2021 19:59:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <alex.williamson@redhat.com>, <kwankhede@nvidia.com>,
        <tglx@linutronix.de>, <vkoul@kernel.org>, <megha.dey@intel.com>,
        <jacob.jun.pan@intel.com>, <ashok.raj@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <dan.j.williams@intel.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <pbonzini@redhat.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration
 and helper functions
Message-ID: <20210210235924.GJ4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:208:e8::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0029.namprd20.prod.outlook.com (2603:10b6:208:e8::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 23:59:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9zOG-006IE5-PM; Wed, 10 Feb 2021 19:59:24 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613001573; bh=5JUPEmN4dVgkBxOz+LvCz2eb0nvSv75QXtMWb8Rtiqw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=QFICxPmctqwdSALVyzViKH0VU0LI2M0CyAvOR0igykh/fxIRY3OySmAGiK9rxhcSK
         VVa+4Z8tSXkmiJVE/W25ksC2esm+x6Ow6A3PKp5ihcqhyyWqcw/X36fsZ5YOv5WzET
         gWgYFaraNToZ9B0IvMV+fuwkRvwemeMv6buuU0xGx8X7vzG0QAfBWYKfUTVSDJ442J
         U12R5BivzHvrY1ZQHk5b8kJ1buk8k169DpmtlAG8oSqc9MS/LGvJZ199Vo4LZcuH0T
         YCQwzzkM7e6tLnoWKQkAzARheEW2Gty98wIVep41WEv0ry3TZSXx9mkfq+GBeKN9h+
         zyjdYw+Kfearg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 01:53:24PM -0700, Dave Jiang wrote:

> +static int check_vma(struct idxd_wq *wq, struct vm_area_struct *vma)
>  {
> -	/* FIXME: Fill in later */
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;

These checks are redundant

> -static int idxd_mdev_host_release(struct idxd_device *idxd)
> +static int idxd_vdcm_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
> +{
> +	unsigned int wq_idx, rc;
> +	unsigned long req_size, pgoff = 0, offset;
> +	pgprot_t pg_prot;
> +	struct vdcm_idxd *vidxd = mdev_get_drvdata(mdev);
> +	struct idxd_wq *wq = vidxd->wq;
> +	struct idxd_device *idxd = vidxd->idxd;
> +	enum idxd_portal_prot virt_portal, phys_portal;
> +	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
> +	struct device *dev = mdev_dev(mdev);
> +
> +	rc = check_vma(wq, vma);
> +	if (rc)
> +		return rc;
> +
> +	pg_prot = vma->vm_page_prot;
> +	req_size = vma->vm_end - vma->vm_start;
> +	vma->vm_flags |= VM_DONTCOPY;
> +
> +	offset = (vma->vm_pgoff << PAGE_SHIFT) &
> +		 ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
> +
> +	wq_idx = offset >> (PAGE_SHIFT + 2);
> +	if (wq_idx >= 1) {
> +		dev_err(dev, "mapping invalid wq %d off %lx\n",
> +			wq_idx, offset);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Check and see if the guest wants to map to the limited or unlimited portal.
> +	 * The driver will allow mapping to unlimited portal only if the the wq is a
> +	 * dedicated wq. Otherwise, it goes to limited.
> +	 */
> +	virt_portal = ((offset >> PAGE_SHIFT) & 0x3) == 1;
> +	phys_portal = IDXD_PORTAL_LIMITED;
> +	if (virt_portal == IDXD_PORTAL_UNLIMITED && wq_dedicated(wq))
> +		phys_portal = IDXD_PORTAL_UNLIMITED;
> +
> +	/* We always map IMS portals to the guest */
> +	pgoff = (base + idxd_get_wq_portal_full_offset(wq->id, phys_portal,
> +						       IDXD_IRQ_IMS)) >> PAGE_SHIFT;
> +	dev_dbg(dev, "mmap %lx %lx %lx %lx\n", vma->vm_start, pgoff, req_size,
> +		pgprot_val(pg_prot));
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vma->vm_private_data = mdev;

What ensures the mdev pointer is valid strictly longer than the VMA?
This needs refcounting.

> +	vma->vm_pgoff = pgoff;
> +
> +	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);

Nothing validated req_size - did you copy this from the Intel RDMA
driver? It had a huge security bug just like this.
> +
> +static int msix_trigger_unregister(struct vdcm_idxd *vidxd, int index)
> +{
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +	struct ims_irq_entry *irq_entry;
> +	int rc;
> +
> +	if (!vidxd->vdev.msix_trigger[index])
> +		return 0;
> +
> +	dev_dbg(dev, "disable MSIX trigger %d\n", index);
> +	if (index) {
> +		u32 auxval;
> +
> +		irq_entry = &vidxd->irq_entries[index];
> +		if (irq_entry->irq_set) {
> +			free_irq(irq_entry->irq, irq_entry);
> +			irq_entry->irq_set = false;
> +		}
> +
> +		auxval = ims_ctrl_pasid_aux(0, false);
> +		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +		if (rc)
> +			return rc;
> +	}
> +	eventfd_ctx_put(vidxd->vdev.msix_trigger[index]);
> +	vidxd->vdev.msix_trigger[index] = NULL;
> +
> +	return 0;
> +}
> +
> +static int msix_trigger_register(struct vdcm_idxd *vidxd, u32 fd, int index)
> +{
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +	struct ims_irq_entry *irq_entry;
> +	struct eventfd_ctx *trigger;
> +	int rc;
> +
> +	if (vidxd->vdev.msix_trigger[index])
> +		return 0;
> +
> +	dev_dbg(dev, "enable MSIX trigger %d\n", index);
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		dev_warn(dev, "eventfd_ctx_fdget failed %d\n", index);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	if (index) {
> +		u32 pasid;
> +		u32 auxval;
> +
> +		irq_entry = &vidxd->irq_entries[index];
> +		rc = idxd_mdev_get_pasid(mdev, &pasid);
> +		if (rc < 0)
> +			return rc;
> +
> +		/*
> +		 * Program and enable the pasid field in the IMS entry. The programmed pasid and
> +		 * enabled field is checked against the  pasid and enable field for the work queue
> +		 * configuration and the pasid for the descriptor. A mismatch will result in blocked
> +		 * IMS interrupt.
> +		 */
> +		auxval = ims_ctrl_pasid_aux(pasid, true);
> +		rc = irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +		if (rc < 0)
> +			return rc;
> +
> +		rc = request_irq(irq_entry->irq, idxd_guest_wq_completion, 0, "idxd-ims",
> +				 irq_entry);
> +		if (rc) {
> +			dev_warn(dev, "failed to request ims irq\n");
> +			eventfd_ctx_put(trigger);
> +			auxval = ims_ctrl_pasid_aux(0, false);
> +			irq_set_auxdata(irq_entry->irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +			return rc;
> +		}
> +		irq_entry->irq_set = true;
> +	}
> +
> +	vidxd->vdev.msix_trigger[index] = trigger;
> +	return 0;
> +}
> +
> +static int vdcm_idxd_set_msix_trigger(struct vdcm_idxd *vidxd,
> +				      unsigned int index, unsigned int start,
> +				      unsigned int count, uint32_t flags,
> +				      void *data)
> +{
> +	int i, rc = 0;
> +
> +	if (count > VIDXD_MAX_MSIX_ENTRIES - 1)
> +		count = VIDXD_MAX_MSIX_ENTRIES - 1;
> +
> +	if (count == 0 && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> +		/* Disable all MSIX entries */
> +		for (i = 0; i < VIDXD_MAX_MSIX_ENTRIES; i++) {
> +			rc = msix_trigger_unregister(vidxd, i);
> +			if (rc < 0)
> +				return rc;
> +		}
> +		return 0;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +			u32 fd = *(u32 *)(data + i * sizeof(u32));
> +
> +			rc = msix_trigger_register(vidxd, fd, i);
> +			if (rc < 0)
> +				return rc;
> +		} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +			rc = msix_trigger_unregister(vidxd, i);
> +			if (rc < 0)
> +				return rc;
> +		}
> +	}
> +	return rc;
> +}
> +
> +static int idxd_vdcm_set_irqs(struct vdcm_idxd *vidxd, uint32_t flags,
> +			      unsigned int index, unsigned int start,
> +			      unsigned int count, void *data)
> +{
> +	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
> +		    unsigned int start, unsigned int count, uint32_t flags,
> +		    void *data) = NULL;
> +	struct mdev_device *mdev = vidxd->vdev.mdev;
> +	struct device *dev = mdev_dev(mdev);
> +
> +	switch (index) {
> +	case VFIO_PCI_INTX_IRQ_INDEX:
> +		dev_warn(dev, "intx interrupts not supported.\n");
> +		break;
> +	case VFIO_PCI_MSI_IRQ_INDEX:
> +		dev_dbg(dev, "msi interrupt.\n");
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_MASK:
> +		case VFIO_IRQ_SET_ACTION_UNMASK:
> +			break;
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vdcm_idxd_set_msix_trigger;

This would be a good place to insert a common VFIO helper library to
take care of the MSI-X emulation for IMS.

> +int idxd_mdev_host_init(struct idxd_device *idxd)
> +{
> +	struct device *dev = &idxd->pdev->dev;
> +	int rc;
> +
> +	if (!test_bit(IDXD_FLAG_IMS_SUPPORTED, &idxd->flags))
> +		return -EOPNOTSUPP;
> +
> +	if (iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_AUX)) {
> +		rc = iommu_dev_enable_feature(dev, IOMMU_DEV_FEAT_AUX);

Huh. This is the first user of IOMMU_DEV_FEAT_AUX, why has so much
dead-code infrastructure been already merged around this?


> @@ -34,6 +1024,7 @@ static int idxd_mdev_aux_probe(struct auxiliary_device *auxdev,
>  		return rc;
>  	}
>  
> +	set_bit(IDXD_FLAG_MDEV_ENABLED, &idxd->flags);

Something is being done wrong if this flag is needed

> +int vidxd_send_interrupt(struct ims_irq_entry *iie)
> +{
> +	/* PLACE HOLDER */
> +	return 0;
> +}

Here too, don't structure the patches like this

> diff --git a/drivers/vfio/mdev/idxd/vdev.h b/drivers/vfio/mdev/idxd/vdev.h
> new file mode 100644
> index 000000000000..cc2ba6ccff7b
> +++ b/drivers/vfio/mdev/idxd/vdev.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
> +
> +#ifndef _IDXD_VDEV_H_
> +#define _IDXD_VDEV_H_
> +
> +#include "mdev.h"
> +
> +int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
> +int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
> +int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
> +int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
> +void vidxd_mmio_init(struct vdcm_idxd *vidxd);
> +void vidxd_reset(struct vdcm_idxd *vidxd);
> +int vidxd_send_interrupt(struct ims_irq_entry *iie);
> +int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
> +void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);

Why are these functions special??

Jason
