Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFC7457160
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 16:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhKSPJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 10:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhKSPJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 10:09:25 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3304EC061574;
        Fri, 19 Nov 2021 07:06:22 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 204915B9; Fri, 19 Nov 2021 16:06:19 +0100 (CET)
Date:   Fri, 19 Nov 2021 16:06:12 +0100
From:   =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211119150612.jhsvsbzisvux2lga@8bytes.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211118133325.GO2105516@nvidia.com>
 <BN9PR11MB5433E5B63E575E2232DFBBE48C9C9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <75100dfd-9cfe-9f3d-531d-b4d30de03e76@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75100dfd-9cfe-9f3d-531d-b4d30de03e76@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021 at 07:14:10PM +0800, Lu Baolu wrote:
> The singleton group requirement for iommu_attach/detach_device() was
> added by below commit:
> 
> commit 426a273834eae65abcfc7132a21a85b3151e0bce
> Author: Joerg Roedel <jroedel@suse.de>
> Date:   Thu May 28 18:41:30 2015 +0200
> 
>     iommu: Limit iommu_attach/detach_device to devices with their own group
> 
>     This patch changes the behavior of the iommu_attach_device
>     and iommu_detach_device functions. With this change these
>     functions only work on devices that have their own group.
>     For all other devices the iommu_group_attach/detach
>     functions must be used.
> 
>     Signed-off-by: Joerg Roedel <jroedel@suse.de>
> 
> Joerg,can you please shed some light on the background of this
> requirement? Does above idea of transition from singleton group
> to group with single driver bound make sense to you?

This change came to be because the iommu_attach/detach_device()
interface doesn't fit well into a world with iommu-groups. Devices
within a group are by definition not isolated between each other, so
they must all be in the same address space (== iommu_domain). So it
doesn't make sense to allow attaching a single device within a group to
a different iommu_domain.

I know that in theory it is safe to allow devices within a group to be
in different domains because there iommu-groups catch multiple
non-isolation cases:

	1) Devices behind a non-ACS capable bridge or multiple functions
	   of a PCI device. Here it is safe to put the devices into
	   different iommu-domains as long as all affected devices are
	   controlled by the same owner.

	2) Devices which share a single request-id and can't be
	   differentiated by the IOMMU hardware. These always need to be
	   in the same iommu_domain.

To lift the single-domain-per-group requirement the iommu core code
needs to learn the difference between the two cases above.

Regards,

	Joerg
