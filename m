Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363DA197966
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgC3Kgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:36:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:22579 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728656AbgC3Kgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585564610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/b2WvN7UKceu4Yrzld2/tRo4BW6Jsolfi2L31n0iepM=;
        b=S9X4P0H/usjDhpJxM0et2Pz4M1KzTO5LMmdcTod39CMisan+0z9lUZPuj4eFowTKsXrA8P
        /x63WFosIoFuMwxGmVAxeLXbL+tpG2cuvG0HS9f62BEKHYybytpSyACT2Njec8gWUfAzWu
        CKlf3aVEljqEzXk1nYUpyyJJqP2ST1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-0DiN0Mn3NBSAE6ovnf53gA-1; Mon, 30 Mar 2020 06:36:41 -0400
X-MC-Unique: 0DiN0Mn3NBSAE6ovnf53gA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DA2C107ACC4;
        Mon, 30 Mar 2020 10:36:39 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 761AD60BEC;
        Mon, 30 Mar 2020 10:36:25 +0000 (UTC)
Subject: Re: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VMs
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, david@gibson.dropbear.id.au,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e709e36f-dc50-2e70-3a1e-62f08533e454@redhat.com>
Date:   Mon, 30 Mar 2020 12:36:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 3/30/20 6:24 AM, Liu Yi L wrote:
> Shared Virtual Addressing (SVA), a.k.a, Shared Virtual Memory (SVM) on
> Intel platforms allows address space sharing between device DMA and
> applications. SVA can reduce programming complexity and enhance security.
> 
> This QEMU series is intended to expose SVA usage to VMs. i.e. Sharing
> guest application address space with passthru devices. This is called
> vSVA in this series. The whole vSVA enabling requires QEMU/VFIO/IOMMU
> changes.
> 
> The high-level architecture for SVA virtualization is as below, the key
> design of vSVA support is to utilize the dual-stage IOMMU translation (
> also known as IOMMU nesting translation) capability in host IOMMU.
> 
>     .-------------.  .---------------------------.
>     |   vIOMMU    |  | Guest process CR3, FL only|
>     |             |  '---------------------------'
>     .----------------/
>     | PASID Entry |--- PASID cache flush -
>     '-------------'                       |
>     |             |                       V
>     |             |                CR3 in GPA
>     '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>       v        v                          v
> Host
>     .-------------.  .----------------------.
>     |   pIOMMU    |  | Bind FL for GVA-GPA  |
>     |             |  '----------------------'
>     .----------------/  |
>     | PASID Entry |     V (Nested xlate)
>     '----------------\.------------------------------.
>     |             |   |SL for GPA-HPA, default domain|
>     |             |   '------------------------------'
>     '-------------'
> Where:
>  - FL = First level/stage one page tables
>  - SL = Second level/stage two page tables
> 
> The complete vSVA kernel upstream patches are divided into three phases:
>     1. Common APIs and PCI device direct assignment
>     2. IOMMU-backed Mediated Device assignment
>     3. Page Request Services (PRS) support
> 
> This QEMU patchset is aiming for the phase 1 and phase 2. It is based
> on the two kernel series below.
> [1] [PATCH V10 00/11] Nested Shared Virtual Address (SVA) VT-d support:
> https://lkml.org/lkml/2020/3/20/1172
> [2] [PATCH v1 0/8] vfio: expose virtual Shared Virtual Addressing to VMs
> https://lkml.org/lkml/2020/3/22/116
+ [PATCH v2 0/3] IOMMU user API enhancement, right?

I think in general, as long as the kernel dependencies are not resolved,
the QEMU series is supposed to stay in RFC state.

Thanks

Eric
> 
> There are roughly two parts:
>  1. Introduce HostIOMMUContext as abstract of host IOMMU. It provides explicit
>     method for vIOMMU emulators to communicate with host IOMMU. e.g. propagate
>     guest page table binding to host IOMMU to setup dual-stage DMA translation
>     in host IOMMU and flush iommu iotlb.
>  2. Setup dual-stage IOMMU translation for Intel vIOMMU. Includes 
>     - Check IOMMU uAPI version compatibility and VFIO Nesting capabilities which
>       includes hardware compatibility (stage 1 format) and VFIO_PASID_REQ
>       availability. This is preparation for setting up dual-stage DMA translation
>       in host IOMMU.
>     - Propagate guest PASID allocation and free request to host.
>     - Propagate guest page table binding to host to setup dual-stage IOMMU DMA
>       translation in host IOMMU.
>     - Propagate guest IOMMU cache invalidation to host to ensure iotlb
>       correctness.
> 
> The complete QEMU set can be found in below link:
> https://github.com/luxis1999/qemu.git: sva_vtd_v10_v2
> 
> Complete kernel can be found in:
> https://github.com/luxis1999/linux-vsva.git: vsva-linux-5.6-rc6
> 
> Tests: basci vSVA functionality test, VM reboot/shutdown/crash, kernel build in
> guest, boot VM with vSVA disabled, full comapilation with all archs.
> 
> Regards,
> Yi Liu
> 
> Changelog:
> 	- Patch v1 -> Patch v2:
> 	  a) Refactor the vfio HostIOMMUContext init code (patch 0008 - 0009 of v1 series)
> 	  b) Refactor the pasid binding handling (patch 0011 - 0016 of v1 series)
> 	  Patch v1: https://patchwork.ozlabs.org/cover/1259648/
> 
> 	- RFC v3.1 -> Patch v1:
> 	  a) Implement HostIOMMUContext in QOM manner.
> 	  b) Add pci_set/unset_iommu_context() to register HostIOMMUContext to
> 	     vIOMMU, thus the lifecircle of HostIOMMUContext is awared in vIOMMU
> 	     side. In such way, vIOMMU could use the methods provided by the
> 	     HostIOMMUContext safely.
> 	  c) Add back patch "[RFC v3 01/25] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps"
> 	  RFCv3.1: https://patchwork.kernel.org/cover/11397879/
> 
> 	- RFC v3 -> v3.1:
> 	  a) Drop IOMMUContext, and rename DualStageIOMMUObject to HostIOMMUContext.
> 	     HostIOMMUContext is per-vfio-container, it is exposed to  vIOMMU via PCI
> 	     layer. VFIO registers a PCIHostIOMMUFunc callback to PCI layer, vIOMMU
> 	     could get HostIOMMUContext instance via it.
> 	  b) Check IOMMU uAPI version by VFIO_CHECK_EXTENSION
> 	  c) Add a check on VFIO_PASID_REQ availability via VFIO_GET_IOMMU_IHNFO
> 	  d) Reorder the series, put vSVA linux header file update in the beginning
> 	     put the x-scalable-mode option mofification in the end of the series.
> 	  e) Dropped patch "[RFC v3 01/25] hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps"
> 	  RFCv3: https://patchwork.kernel.org/cover/11356033/
> 
> 	- RFC v2 -> v3:
> 	  a) Introduce DualStageIOMMUObject to abstract the host IOMMU programming
> 	  capability. e.g. request PASID from host, setup IOMMU nesting translation
> 	  on host IOMMU. The pasid_alloc/bind_guest_page_table/iommu_cache_flush
> 	  operations are moved to be DualStageIOMMUOps. Thus, DualStageIOMMUObject
> 	  is an abstract layer which provides QEMU vIOMMU emulators with an explicit
> 	  method to program host IOMMU.
> 	  b) Compared with RFC v2, the IOMMUContext has also been updated. It is
> 	  modified to provide an abstract for vIOMMU emulators. It provides the
> 	  method for pass-through modules (like VFIO) to communicate with host IOMMU.
> 	  e.g. tell vIOMMU emulators about the IOMMU nesting capability on host side
> 	  and report the host IOMMU DMA translation faults to vIOMMU emulators.
> 	  RFC v2: https://www.spinics.net/lists/kvm/msg198556.html
> 
> 	- RFC v1 -> v2:
> 	  Introduce IOMMUContext to abstract the connection between VFIO
> 	  and vIOMMU emulators, which is a replacement of the PCIPASIDOps
> 	  in RFC v1. Modify x-scalable-mode to be string option instead of
> 	  adding a new option as RFC v1 did. Refined the pasid cache management
> 	  and addressed the TODOs mentioned in RFC v1. 
> 	  RFC v1: https://patchwork.kernel.org/cover/11033657/
> 
> Eric Auger (1):
>   scripts/update-linux-headers: Import iommu.h
> 
> Liu Yi L (21):
>   header file update VFIO/IOMMU vSVA APIs
>   vfio: check VFIO_TYPE1_NESTING_IOMMU support
>   hw/iommu: introduce HostIOMMUContext
>   hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
>   hw/pci: introduce pci_device_set/unset_iommu_context()
>   intel_iommu: add set/unset_iommu_context callback
>   vfio/common: provide PASID alloc/free hooks
>   vfio/common: init HostIOMMUContext per-container
>   vfio/pci: set host iommu context to vIOMMU
>   intel_iommu: add virtual command capability support
>   intel_iommu: process PASID cache invalidation
>   intel_iommu: add PASID cache management infrastructure
>   vfio: add bind stage-1 page table support
>   intel_iommu: bind/unbind guest page table to host
>   intel_iommu: replay pasid binds after context cache invalidation
>   intel_iommu: do not pass down pasid bind for PASID #0
>   vfio: add support for flush iommu stage-1 cache
>   intel_iommu: process PASID-based iotlb invalidation
>   intel_iommu: propagate PASID-based iotlb invalidation to host
>   intel_iommu: process PASID-based Device-TLB invalidation
>   intel_iommu: modify x-scalable-mode to be string option
> 
>  hw/Makefile.objs                      |    1 +
>  hw/alpha/typhoon.c                    |    6 +-
>  hw/arm/smmu-common.c                  |    6 +-
>  hw/hppa/dino.c                        |    6 +-
>  hw/i386/amd_iommu.c                   |    6 +-
>  hw/i386/intel_iommu.c                 | 1109 ++++++++++++++++++++++++++++++++-
>  hw/i386/intel_iommu_internal.h        |  114 ++++
>  hw/i386/trace-events                  |    6 +
>  hw/iommu/Makefile.objs                |    1 +
>  hw/iommu/host_iommu_context.c         |  161 +++++
>  hw/pci-host/designware.c              |    6 +-
>  hw/pci-host/pnv_phb3.c                |    6 +-
>  hw/pci-host/pnv_phb4.c                |    6 +-
>  hw/pci-host/ppce500.c                 |    6 +-
>  hw/pci-host/prep.c                    |    6 +-
>  hw/pci-host/sabre.c                   |    6 +-
>  hw/pci/pci.c                          |   53 +-
>  hw/ppc/ppc440_pcix.c                  |    6 +-
>  hw/ppc/spapr_pci.c                    |    6 +-
>  hw/s390x/s390-pci-bus.c               |    8 +-
>  hw/vfio/common.c                      |  260 +++++++-
>  hw/vfio/pci.c                         |   13 +
>  hw/virtio/virtio-iommu.c              |    6 +-
>  include/hw/i386/intel_iommu.h         |   57 +-
>  include/hw/iommu/host_iommu_context.h |  116 ++++
>  include/hw/pci/pci.h                  |   18 +-
>  include/hw/pci/pci_bus.h              |    2 +-
>  include/hw/vfio/vfio-common.h         |    4 +
>  linux-headers/linux/iommu.h           |  378 +++++++++++
>  linux-headers/linux/vfio.h            |  127 ++++
>  scripts/update-linux-headers.sh       |    2 +-
>  31 files changed, 2463 insertions(+), 45 deletions(-)
>  create mode 100644 hw/iommu/Makefile.objs
>  create mode 100644 hw/iommu/host_iommu_context.c
>  create mode 100644 include/hw/iommu/host_iommu_context.h
>  create mode 100644 linux-headers/linux/iommu.h
> 

