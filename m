Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5810E47C9
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 11:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439106AbfJYJtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 05:49:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58126 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394402AbfJYJtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 05:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571996988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l5enplt3kss0i+VSuFpeLf1RUqsTPPDkUugAnG5THGI=;
        b=bXMMNTZB27ts301DGmfCLaKbSbB16rz8Z6j5C+gg4APsedX9+Xybuyofb3o7OrejMmwbW+
        4w84+z36Sm0rNnK/a6kqvYKIJKf+G+uzv7Hi+rq4yd8glQP5jryTPgutgwoI5wNSD21urH
        zmNsGG2NgnOuxkVi+E4xha4V17fvMVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-UbMDExvAOdCwKEwS4Zs1ZA-1; Fri, 25 Oct 2019 05:49:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BA941005500;
        Fri, 25 Oct 2019 09:49:43 +0000 (UTC)
Received: from [10.72.12.249] (ovpn-12-249.pek2.redhat.com [10.72.12.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F003194B6;
        Fri, 25 Oct 2019 09:49:21 +0000 (UTC)
Subject: Re: [RFC v2 00/22] intel_iommu: expose Shared Virtual Addressing to
 VM
To:     Liu Yi L <yi.l.liu@intel.com>, qemu-devel@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     tianyu.lan@intel.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        jun.j.tian@intel.com, eric.auger@redhat.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, david@gibson.dropbear.id.au
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <367adad0-eb05-c950-21d7-755fffacbed6@redhat.com>
Date:   Fri, 25 Oct 2019 17:49:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: UbMDExvAOdCwKEwS4Zs1ZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/24 =E4=B8=8B=E5=8D=888:34, Liu Yi L wrote:
> Shared virtual address (SVA), a.k.a, Shared virtual memory (SVM) on Intel
> platforms allow address space sharing between device DMA and applications=
.


Interesting, so the below figure demonstrates the case of VM. I wonder=20
how much differences if we compare it with doing SVM between device and=20
an ordinary process (e.g dpdk)?

Thanks


> SVA can reduce programming complexity and enhance security.
> This series is intended to expose SVA capability to VMs. i.e. shared gues=
t
> application address space with passthru devices. The whole SVA virtualiza=
tion
> requires QEMU/VFIO/IOMMU changes. This series includes the QEMU changes, =
for
> VFIO and IOMMU changes, they are in separate series (listed in the "Relat=
ed
> series").
>
> The high-level architecture for SVA virtualization is as below:
>
>      .-------------.  .---------------------------.
>      |   vIOMMU    |  | Guest process CR3, FL only|
>      |             |  '---------------------------'
>      .----------------/
>      | PASID Entry |--- PASID cache flush -
>      '-------------'                       |
>      |             |                       V
>      |             |                CR3 in GPA
>      '-------------'
> Guest
> ------| Shadow |--------------------------|--------
>        v        v                          v
> Host
>      .-------------.  .----------------------.
>      |   pIOMMU    |  | Bind FL for GVA-GPA  |
>      |             |  '----------------------'
>      .----------------/  |
>      | PASID Entry |     V (Nested xlate)
>      '----------------\.------------------------------.
>      |             |   |SL for GPA-HPA, default domain|
>      |             |   '------------------------------'
>      '-------------'
> Where:
>   - FL =3D First level/stage one page tables
>   - SL =3D Second level/stage two page tables
>
> The complete vSVA upstream patches are divided into three phases:
>      1. Common APIs and PCI device direct assignment
>      2. Page Request Services (PRS) support
>      3. Mediated device assignment
>
> This RFC patchset is aiming for the phase 1. Works together with the VT-d
> driver[1] changes and VFIO changes[2].
>
> Related series:
> [1] [PATCH v6 00/10] Nested Shared Virtual Address (SVA) VT-d support:
> https://lkml.org/lkml/2019/10/22/953
> <This series is based on this kernel series from Jacob Pan>
>
> [2] [RFC v2 0/3] vfio: support Shared Virtual Addressing from Yi Liu
>
> There are roughly four parts:
>   1. Introduce IOMMUContext as abstract layer between vIOMMU emulator and
>      VFIO to avoid direct calling between the two
>   2. Passdown PASID allocation and free to host
>   3. Passdown guest PASID binding to host
>   4. Passdown guest IOMMU cache invalidation to host
>
> The full set can be found in below link:
> https://github.com/luxis1999/qemu.git: sva_vtd_v6_qemu_rfc_v2
>
> Changelog:
> =09- RFC v1 -> v2:
> =09  Introduce IOMMUContext to abstract the connection between VFIO
> =09  and vIOMMU emulator, which is a replacement of the PCIPASIDOps
> =09  in RFC v1. Modify x-scalable-mode to be string option instead of
> =09  adding a new option as RFC v1 did. Refined the pasid cache managemen=
t
> =09  and addressed the TODOs mentioned in RFC v1.
> =09  RFC v1: https://patchwork.kernel.org/cover/11033657/
>
> Eric Auger (1):
>    update-linux-headers: Import iommu.h
>
> Liu Yi L (20):
>    header update VFIO/IOMMU vSVA APIs against 5.4.0-rc3+
>    intel_iommu: modify x-scalable-mode to be string option
>    vfio/common: add iommu_ctx_notifier in container
>    hw/pci: modify pci_setup_iommu() to set PCIIOMMUOps
>    hw/pci: introduce pci_device_iommu_context()
>    intel_iommu: provide get_iommu_context() callback
>    vfio/pci: add iommu_context notifier for pasid alloc/free
>    intel_iommu: add virtual command capability support
>    intel_iommu: process pasid cache invalidation
>    intel_iommu: add present bit check for pasid table entries
>    intel_iommu: add PASID cache management infrastructure
>    vfio/pci: add iommu_context notifier for pasid bind/unbind
>    intel_iommu: bind/unbind guest page table to host
>    intel_iommu: replay guest pasid bindings to host
>    intel_iommu: replay pasid binds after context cache invalidation
>    intel_iommu: do not passdown pasid bind for PASID #0
>    vfio/pci: add iommu_context notifier for PASID-based iotlb flush
>    intel_iommu: process PASID-based iotlb invalidation
>    intel_iommu: propagate PASID-based iotlb invalidation to host
>    intel_iommu: process PASID-based Device-TLB invalidation
>
> Peter Xu (1):
>    hw/iommu: introduce IOMMUContext
>
>   hw/Makefile.objs                |    1 +
>   hw/alpha/typhoon.c              |    6 +-
>   hw/arm/smmu-common.c            |    6 +-
>   hw/hppa/dino.c                  |    6 +-
>   hw/i386/amd_iommu.c             |    6 +-
>   hw/i386/intel_iommu.c           | 1249 ++++++++++++++++++++++++++++++++=
+++++--
>   hw/i386/intel_iommu_internal.h  |  109 ++++
>   hw/i386/trace-events            |    6 +
>   hw/iommu/Makefile.objs          |    1 +
>   hw/iommu/iommu.c                |   66 +++
>   hw/pci-host/designware.c        |    6 +-
>   hw/pci-host/ppce500.c           |    6 +-
>   hw/pci-host/prep.c              |    6 +-
>   hw/pci-host/sabre.c             |    6 +-
>   hw/pci/pci.c                    |   27 +-
>   hw/ppc/ppc440_pcix.c            |    6 +-
>   hw/ppc/spapr_pci.c              |    6 +-
>   hw/s390x/s390-pci-bus.c         |    8 +-
>   hw/vfio/common.c                |   10 +
>   hw/vfio/pci.c                   |  149 +++++
>   include/hw/i386/intel_iommu.h   |   58 +-
>   include/hw/iommu/iommu.h        |  113 ++++
>   include/hw/pci/pci.h            |   13 +-
>   include/hw/pci/pci_bus.h        |    2 +-
>   include/hw/vfio/vfio-common.h   |    9 +
>   linux-headers/linux/iommu.h     |  324 ++++++++++
>   linux-headers/linux/vfio.h      |   83 +++
>   scripts/update-linux-headers.sh |    2 +-
>   28 files changed, 2232 insertions(+), 58 deletions(-)
>   create mode 100644 hw/iommu/Makefile.objs
>   create mode 100644 hw/iommu/iommu.c
>   create mode 100644 include/hw/iommu/iommu.h
>   create mode 100644 linux-headers/linux/iommu.h
>

