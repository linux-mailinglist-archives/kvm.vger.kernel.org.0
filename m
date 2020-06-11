Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D131F70CE
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgFKXUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 19:20:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:57714 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbgFKXUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 19:20:52 -0400
IronPort-SDR: 4TuFqZyGUEfZDtEKac1V2eKelE8A+T4L71/kYn74cUyA7p6B9Jn/ycxf0xmFy1x4yKohxzDwDR
 oc6NRe4dnX6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 16:20:51 -0700
IronPort-SDR: XhXMCmaBfuRgwtEFEXtJMZygbD7vqtJ8pGircQSzqdqyXnILtwUaucQYN/2ij0J2tfgHHt0zS8
 TZF78l9QkkIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="260815830"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jun 2020 16:20:48 -0700
Date:   Thu, 11 Jun 2020 19:10:48 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        kevin.tian@intel.com, shaopeng.he@intel.com, yi.l.liu@intel.com,
        xin.zeng@intel.com, hang.yuan@intel.com,
        Wang Haibin <wanghaibin.wang@huawei.com>
Subject: Re: [RFC PATCH v4 08/10] i40e/vf_migration: VF live migration -
 pass-through VF first
Message-ID: <20200611231048.GE13961@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200518024202.13996-1-yan.y.zhao@intel.com>
 <20200518025316.14491-1-yan.y.zhao@intel.com>
 <e45d5bb6-6f15-dd4d-6de2-478b36f88069@huawei.com>
 <20200611002319.GC13961@joy-OptiPlex-7040>
 <fe5c0a64-003c-1db6-8256-f0dc00333f1d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe5c0a64-003c-1db6-8256-f0dc00333f1d@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 11, 2020 at 10:27:34AM +0800, Xiang Zheng wrote:
> 
> 
> On 2020/6/11 8:23, Yan Zhao wrote:
> > On Wed, Jun 10, 2020 at 04:59:43PM +0800, Xiang Zheng wrote:
> >> Hi Yan,
> >>
> >> few nits below...
> >>
> >> On 2020/5/18 10:53, Yan Zhao wrote:
> >>> This driver intercepts all device operations as long as it's probed
> >>> successfully by vfio-pci driver.
> >>>
> >>> It will process regions and irqs of its interest and then forward
> >>> operations to default handlers exported from vfio pci if it wishes to.
> >>>
> >>> In this patch, this driver does nothing but pass through VFs to guest
> >>> by calling to exported handlers from driver vfio-pci.
> >>>
> >>> Cc: Shaopeng He <shaopeng.he@intel.com>
> >>>
> >>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >>> ---
> >>>  drivers/net/ethernet/intel/Kconfig            |  10 ++
> >>>  drivers/net/ethernet/intel/i40e/Makefile      |   2 +
> >>>  .../ethernet/intel/i40e/i40e_vf_migration.c   | 165 ++++++++++++++++++
> >>>  .../ethernet/intel/i40e/i40e_vf_migration.h   |  59 +++++++
> >>>  4 files changed, 236 insertions(+)
> >>>  create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.c
> >>>  create mode 100644 drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> >>>
> >>> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> >>> index ad34e4335df2..31780d9a59f1 100644
> >>> --- a/drivers/net/ethernet/intel/Kconfig
> >>> +++ b/drivers/net/ethernet/intel/Kconfig
> >>> @@ -264,6 +264,16 @@ config I40E_DCB
> >>>  
> >>>  	  If unsure, say N.
> >>>  
> 
> [...]
> 
> >>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> >>> new file mode 100644
> >>> index 000000000000..696d40601ec3
> >>> --- /dev/null
> >>> +++ b/drivers/net/ethernet/intel/i40e/i40e_vf_migration.h
> >>> @@ -0,0 +1,59 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>> +/* Copyright(c) 2013 - 2019 Intel Corporation. */
> >>> +
> >>> +#ifndef I40E_MIG_H
> >>> +#define I40E_MIG_H
> >>> +
> >>> +#include <linux/pci.h>
> >>> +#include <linux/vfio.h>
> >>> +#include <linux/mdev.h>
> >>> +
> >>> +#include "i40e.h"
> >>> +#include "i40e_txrx.h"
> >>> +
> >>> +/* helper macros copied from vfio-pci */
> >>> +#define VFIO_PCI_OFFSET_SHIFT   40
> >>> +#define VFIO_PCI_OFFSET_TO_INDEX(off)   ((off) >> VFIO_PCI_OFFSET_SHIFT)
> >>> +#define VFIO_PCI_INDEX_TO_OFFSET(index)	((u64)(index) << VFIO_PCI_OFFSET_SHIFT)
> >>> +#define VFIO_PCI_OFFSET_MASK    (((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
> >>> +
> >>> +/* Single Root I/O Virtualization */
> >>> +struct pci_sriov {
> >>> +	int		pos;		/* Capability position */
> >>> +	int		nres;		/* Number of resources */
> >>> +	u32		cap;		/* SR-IOV Capabilities */
> >>> +	u16		ctrl;		/* SR-IOV Control */
> >>> +	u16		total_VFs;	/* Total VFs associated with the PF */
> >>> +	u16		initial_VFs;	/* Initial VFs associated with the PF */
> >>> +	u16		num_VFs;	/* Number of VFs available */
> >>> +	u16		offset;		/* First VF Routing ID offset */
> >>> +	u16		stride;		/* Following VF stride */
> >>> +	u16		vf_device;	/* VF device ID */
> >>> +	u32		pgsz;		/* Page size for BAR alignment */
> >>> +	u8		link;		/* Function Dependency Link */
> >>> +	u8		max_VF_buses;	/* Max buses consumed by VFs */
> >>> +	u16		driver_max_VFs;	/* Max num VFs driver supports */
> >>> +	struct pci_dev	*dev;		/* Lowest numbered PF */
> >>> +	struct pci_dev	*self;		/* This PF */
> >>> +	u32		cfg_size;	/* VF config space size */
> >>> +	u32		class;		/* VF device */
> >>> +	u8		hdr_type;	/* VF header type */
> >>> +	u16		subsystem_vendor; /* VF subsystem vendor */
> >>> +	u16		subsystem_device; /* VF subsystem device */                                                                                   
> >>> +	resource_size_t	barsz[PCI_SRIOV_NUM_BARS];	/* VF BAR size */
> >>> +	bool		drivers_autoprobe; /* Auto probing of VFs by driver */
> >>> +};
> >>> +
> >>
> >> Can "struct pci_sriov" be extracted for common use? This should not be exclusive
> >> for "i40e_vf migration support".
> >>
> > the definition of this structure is actually in driver/pci/pci.h.
> > maybe removing the copy here and use below include is better?
> > #include "../../../../pci/pci.h"
> > 
> 
> How about moving the definition from driver/pci/pci.h into include/linux/pci.h? So
> we can just include "linux/pci.h" and removing the copy here.
>
I prefer to leaving it in drivers/pci/pci.h for now.

Thanks
Yan
