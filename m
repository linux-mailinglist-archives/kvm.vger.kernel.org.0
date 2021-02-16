Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECFF31D228
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 22:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhBPVee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 16:34:34 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8588 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhBPVeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 16:34:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602c3a240000>; Tue, 16 Feb 2021 13:33:24 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:33:23 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 21:33:17 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 16 Feb 2021 21:33:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG2qmwstDeOKJUyM+8QClyq3phY0vNpVEnP6gWCcffEeUhvVtYvlSZpKgVCbXNLgEs+OvzASQ2SZGu/E5v7mPGjkCPHLEQIm5oCdd5f3ZMKZF30CZj3GFpqqby+zUiyCfR/q+H9WhYHWBCTd2++5A2LqkL6dt1iqFPoWKi/B29yfFw0rD9mxJ6Nz3VaxY1m0eGwfy4JHGUuM8844PEqV2mkSnlkK8qYgouzYjvrJPigq/7J54jXeJXusZQK1QrWSEF+j8J7alyXIH2B1Qrk9zaDFKr5w5PVZjET9luDzOJpJ3jRRJVPONMeHmgsnruPReH6E62czNnXyuFXLBjJUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xh09CJxUgWP2SQ20O6FOGI/ixuZJ7YZLsaRHyoXZp2I=;
 b=a87QzwES6xRh5QOZ5FDbUiy8GrwDhW27PRFdLXjfPV4iW/ZdJIzqGDcVRr8VrEKWvnJfBCFdsgEPc+C6twrsYLZb/QOZ61/aTxFWAlFfpfiWbLquJEyoMi4g2OiJrkW+zPMTZydx6NuE6p8TMnZIbm77PGPzZ3Aczo8olmYykehbNTPEArDq5DM4+/136PmdOjPPFagyYB7tZDIa98vsMOHtdQ2uZvVlc0oLJRq2zY2BdQpSEVjPTieU9jgms73FqLJFpOrTvqWlanJ6DnoFN89xTj+lXkXU+45HAufqCkHTNsQeRI11Nfl4yRB3S8WhH1DIygpcv5VRLK2AsiRSFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2486.namprd12.prod.outlook.com (2603:10b6:4:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Tue, 16 Feb
 2021 21:33:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.041; Tue, 16 Feb 2021
 21:33:13 +0000
Date:   Tue, 16 Feb 2021 17:33:10 -0400
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
Message-ID: <20210216213310.GJ4247@nvidia.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
X-ClientProxiedBy: BL1PR13CA0484.namprd13.prod.outlook.com
 (2603:10b6:208:2c7::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0484.namprd13.prod.outlook.com (2603:10b6:208:2c7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Tue, 16 Feb 2021 21:33:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lC7y2-009Loc-Pd; Tue, 16 Feb 2021 17:33:10 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613511204; bh=xh09CJxUgWP2SQ20O6FOGI/ixuZJ7YZLsaRHyoXZp2I=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Xt1i9n5NEj58ZNoPeM+EpZAN2gQN2xPHW76v9nRkB8dRNTrAXEhWSv8OQpqr5dKLO
         MS4QhIooQsnqS+yzmoF47ynF5RlTIWRfLtpjYH74lFnIuYF+fLWD+7Bwq0cx8zJvqD
         /6LEkXMOifdDrQelBer8U1wRPUZmjoTfNnyu1yalNKXxDOhv/lhO3levAGOPsWFe2Q
         oBiXncqBeXE5TRpU3RXDSaJnixBKj/clUPiLl/ie0Etq8AThuavJM3ffCk9UFCzyxB
         R2HyZ0WGTL9EAwpa2RFwxZic4D2tpDTK8wsryVKHQSsrgnv18Kpxb5QVP10n0SyJDk
         b2hN0Kp8FO5Zg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 12:04:55PM -0700, Dave Jiang wrote:

> > > +	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size, pg_prot);
> > Nothing validated req_size - did you copy this from the Intel RDMA
> > driver? It had a huge security bug just like this.

> Thanks. Will add. Some of the code came from the Intel i915 mdev
> driver.

Please make sure it is fixed as well, the security bug is huge.

> > > +			      unsigned int index, unsigned int start,
> > > +			      unsigned int count, void *data)
> > > +{
> > > +	int (*func)(struct vdcm_idxd *vidxd, unsigned int index,
> > > +		    unsigned int start, unsigned int count, uint32_t flags,
> > > +		    void *data) = NULL;
> > > +	struct mdev_device *mdev = vidxd->vdev.mdev;
> > > +	struct device *dev = mdev_dev(mdev);
> > > +
> > > +	switch (index) {
> > > +	case VFIO_PCI_INTX_IRQ_INDEX:
> > > +		dev_warn(dev, "intx interrupts not supported.\n");
> > > +		break;
> > > +	case VFIO_PCI_MSI_IRQ_INDEX:
> > > +		dev_dbg(dev, "msi interrupt.\n");
> > > +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > > +		case VFIO_IRQ_SET_ACTION_MASK:
> > > +		case VFIO_IRQ_SET_ACTION_UNMASK:
> > > +			break;
> > > +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> > > +			func = vdcm_idxd_set_msix_trigger;
> > This would be a good place to insert a common VFIO helper library to
> > take care of the MSI-X emulation for IMS.
> 
> I took a look at the idxd version vs the VFIO version and they are somewhat
> different. Although the MSI and MSIX case can be squashed in the idxd driver
> code. I do think that the parent code block can be split out in VFIO code
> and made into a common helper function to deal with VFIO_DEVICE_SET_IRQS and
> I've done so.

Really it looks like the MSI emulation for a simple IMS device is just
mapping the MSI table to a certain irq_chip, this feels like it should
be substantially common code

> > > diff --git a/drivers/vfio/mdev/idxd/vdev.h b/drivers/vfio/mdev/idxd/vdev.h
> > > new file mode 100644
> > > index 000000000000..cc2ba6ccff7b
> > > +++ b/drivers/vfio/mdev/idxd/vdev.h
> > > @@ -0,0 +1,19 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/* Copyright(c) 2019,2020 Intel Corporation. All rights rsvd. */
> > > +
> > > +#ifndef _IDXD_VDEV_H_
> > > +#define _IDXD_VDEV_H_
> > > +
> > > +#include "mdev.h"
> > > +
> > > +int vidxd_mmio_read(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
> > > +int vidxd_mmio_write(struct vdcm_idxd *vidxd, u64 pos, void *buf, unsigned int size);
> > > +int vidxd_cfg_read(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int count);
> > > +int vidxd_cfg_write(struct vdcm_idxd *vidxd, unsigned int pos, void *buf, unsigned int size);
> > > +void vidxd_mmio_init(struct vdcm_idxd *vidxd);
> > > +void vidxd_reset(struct vdcm_idxd *vidxd);
> > > +int vidxd_send_interrupt(struct ims_irq_entry *iie);
> > > +int vidxd_setup_ims_entries(struct vdcm_idxd *vidxd);
> > > +void vidxd_free_ims_entries(struct vdcm_idxd *vidxd);
> > Why are these functions special??
> 
> I'm not sure I follow the intent of this question. The vidxd_* functions are
> split out to vdev.c because they are the emulation helper functions for the
> mdev. It seems reasonable to split them out from the mdev code to make it
> more manageable.

Why do they get their own mostly empty header file?

Jason
