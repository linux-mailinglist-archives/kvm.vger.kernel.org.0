Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF9F0EC
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 09:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfD3HKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 03:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3HKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 03:10:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E89681DF4;
        Tue, 30 Apr 2019 07:09:59 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E30C51001DD2;
        Tue, 30 Apr 2019 07:09:52 +0000 (UTC)
Subject: Re: [PATCH v7 00/23] SMMUv3 Nested Stage Setup
To:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com, robin.murphy@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        christoffer.dall@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d9967a8c-cd3b-6994-c5ef-c4341aaaf0fd@redhat.com>
Date:   Tue, 30 Apr 2019 09:09:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 30 Apr 2019 07:09:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 4/8/19 2:18 PM, Eric Auger wrote:
> This series allows a virtualizer to program the nested stage mode.
> This is useful when both the host and the guest are exposed with
> an SMMUv3 and a PCI device is assigned to the guest using VFIO.
> 
> In this mode, the physical IOMMU must be programmed to translate
> the two stages: the one set up by the guest (IOVA -> GPA) and the
> one set up by the host VFIO driver as part of the assignment process
> (GPA -> HPA).
> 
> On Intel, this is traditionnaly achieved by combining the 2 stages
> into a single physical stage. However this relies on the capability
> to trap on each guest translation structure update. This is possible
> by using the VTD Caching Mode. Unfortunately the ARM SMMUv3 does
> not offer a similar mechanism.
> 
> However, the ARM SMMUv3 architecture supports 2 physical stages! Those
> were devised exactly with that use case in mind. Assuming the HW
> implements both stages (optional), the guest now can use stage 1
> while the host uses stage 2.
> 
> This assumes the virtualizer has means to propagate guest settings
> to the host SMMUv3 driver. This series brings this VFIO/IOMMU
> infrastructure.  Those services are:
> - bind the guest stage 1 configuration to the stream table entry
> - propagate guest TLB invalidations
> - bind MSI IOVAs
> - propagate faults collected at physical level up to the virtualizer
> 
> This series largely reuses the user API and infrastructure originally
> devised for SVA/SVM and patches submitted by Jacob, Yi Liu, Tianyu in
> [1-2] and Jean-Philippe [3-4].

I am going to respin on top of latest Jean-Philippe's 5.2 changes in
arm-smmu-v3.c. Do you have some comments on changes done since your last
review? Does it go towards the good direction from the iommu API pov and
smmuv3 implementation?

Thanks

Eric
> 
> Best Regards
> 
> Eric
> 
> This series can be found at:
> https://github.com/eauger/linux/tree/v5.1-rc3-2stage-v7
> 
> References:
> [1] [PATCH v5 00/23] IOMMU and VT-d driver support for Shared Virtual
>     Address (SVA)
>     https://lwn.net/Articles/754331/
> [2] [RFC PATCH 0/8] Shared Virtual Memory virtualization for VT-d
>     (VFIO part)
>     https://lists.linuxfoundation.org/pipermail/iommu/2017-April/021475.html
> [3] [v2,00/40] Shared Virtual Addressing for the IOMMU
>     https://patchwork.ozlabs.org/cover/912129/
> [4] [PATCH v3 00/10] Shared Virtual Addressing for the IOMMU
>     https://patchwork.kernel.org/cover/10608299/
> 
> History:
> v6 -> v7:
> - removed device handle from bind/unbind_guest_msi
> - added "iommu/smmuv3: Nested mode single MSI doorbell per domain
>   enforcement"
> - added few uapi comments as suggested by Jean, Jacop and Alex
> 
> v5 -> v6:
> - Fix compilation issue when CONFIG_IOMMU_API is unset
> 
> v4 -> v5:
> - fix bug reported by Vincent: fault handler unregistration now happens in
>   vfio_pci_release
> - IOMMU_FAULT_PERM_* moved outside of struct definition + small
>   uapi changes suggested by Kean-Philippe (except fetch_addr)
> - iommu: introduce device fault report API: removed the PRI part.
> - see individual logs for more details
> - reset the ste abort flag on detach
> 
> v3 -> v4:
> - took into account Alex, jean-Philippe and Robin's comments on v3
> - rework of the smmuv3 driver integration
> - add tear down ops for msi binding and PASID table binding
> - fix S1 fault propagation
> - put fault reporting patches at the beginning of the series following
>   Jean-Philippe's request
> - update of the cache invalidate and fault API uapis
> - VFIO fault reporting rework with 2 separate regions and one mmappable
>   segment for the fault queue
> - moved to PATCH
> 
> v2 -> v3:
> - When registering the S1 MSI binding we now store the device handle. This
>   addresses Robin's comment about discimination of devices beonging to
>   different S1 groups and using different physical MSI doorbells.
> - Change the fault reporting API: use VFIO_PCI_DMA_FAULT_IRQ_INDEX to
>   set the eventfd and expose the faults through an mmappable fault region
> 
> v1 -> v2:
> - Added the fault reporting capability
> - asid properly passed on invalidation (fix assignment of multiple
>   devices)
> - see individual change logs for more info
> 
> 
> Eric Auger (14):
>   iommu: Introduce bind/unbind_guest_msi
>   vfio: VFIO_IOMMU_BIND/UNBIND_MSI
>   iommu/smmuv3: Get prepared for nested stage support
>   iommu/smmuv3: Implement attach/detach_pasid_table
>   iommu/smmuv3: Implement cache_invalidate
>   dma-iommu: Implement NESTED_MSI cookie
>   iommu/smmuv3: Nested mode single MSI doorbell per domain enforcement
>   iommu/smmuv3: Implement bind/unbind_guest_msi
>   iommu/smmuv3: Report non recoverable faults
>   vfio-pci: Add a new VFIO_REGION_TYPE_NESTED region type
>   vfio-pci: Register an iommu fault handler
>   vfio_pci: Allow to mmap the fault queue
>   vfio-pci: Add VFIO_PCI_DMA_FAULT_IRQ_INDEX
>   vfio: Document nested stage control
> 
> Jacob Pan (4):
>   driver core: add per device iommu param
>   iommu: introduce device fault data
>   iommu: introduce device fault report API
>   iommu: Introduce attach/detach_pasid_table API
> 
> Jean-Philippe Brucker (2):
>   iommu/arm-smmu-v3: Link domains and devices
>   iommu/arm-smmu-v3: Maintain a SID->device structure
> 
> Liu, Yi L (3):
>   iommu: Introduce cache_invalidate API
>   vfio: VFIO_IOMMU_ATTACH/DETACH_PASID_TABLE
>   vfio: VFIO_IOMMU_CACHE_INVALIDATE
> 
>  Documentation/vfio.txt              |  83 ++++
>  drivers/iommu/arm-smmu-v3.c         | 631 ++++++++++++++++++++++++++--
>  drivers/iommu/dma-iommu.c           | 129 +++++-
>  drivers/iommu/iommu.c               | 205 ++++++++-
>  drivers/vfio/pci/vfio_pci.c         | 214 ++++++++++
>  drivers/vfio/pci/vfio_pci_intrs.c   |  19 +
>  drivers/vfio/pci/vfio_pci_private.h |  18 +
>  drivers/vfio/pci/vfio_pci_rdwr.c    |  73 ++++
>  drivers/vfio/vfio_iommu_type1.c     | 172 ++++++++
>  include/linux/device.h              |   3 +
>  include/linux/dma-iommu.h           |  17 +
>  include/linux/iommu.h               | 135 ++++++
>  include/uapi/linux/iommu.h          | 240 +++++++++++
>  include/uapi/linux/vfio.h           | 107 +++++
>  14 files changed, 2013 insertions(+), 33 deletions(-)
>  create mode 100644 include/uapi/linux/iommu.h
> 
