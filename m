Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC64B410A30
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbhISGm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:42:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:31584 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhISGmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:42:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="284010956"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="284010956"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:41:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510701821"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:41:23 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 00/20] Introduce /dev/iommu for userspace I/O address space management
Date:   Sun, 19 Sep 2021 14:38:28 +0800
Message-Id: <20210919063848.1476776-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linux now includes multiple device-passthrough frameworks (e.g. VFIO and
vDPA) to manage secure device access from the userspace. One critical task
of those frameworks is to put the assigned device in a secure, IOMMU-
protected context so user-initiated DMAs are prevented from doing harm to
the rest of the system.

Currently those frameworks implement their own logic for managing I/O page
tables to isolate user-initiated DMAs. This doesn't scale to support many
new IOMMU features, such as PASID-granular DMA remapping, nested translation,
I/O page fault, IOMMU dirty bit, etc.

/dev/iommu is introduced as an unified interface for managing I/O address
spaces and DMA isolation for passthrough devices. It's originated from the
upstream discussion for the vSVA enabling work[1].

This RFC aims to provide a basic skeleton for above proposal, w/o adding
any new feature beyond what vfio type1 provides today. For an overview of
future extensions, please refer to the full design proposal [2].

The core concepts in /dev/iommu are iommufd and ioasid. iommufd (by opening
/dev/iommu) is the container holding multiple I/O address spaces, while
ioasid is the fd-local software handle representing an I/O address space and
associated with a single I/O page table. User manages those address spaces
through fd operations, e.g. by using vfio type1v2 mapping semantics to manage
respective I/O page tables.

An I/O address space takes effect in the iommu only after it is attached by
a device. One I/O address space can be attached by multiple devices. One
device can be only attached to a single I/O address space in this RFC, to
match vfio type1 behavior as the starting point.

Device must be bound to an iommufd before attach operation can be conducted.
The binding operation builds the connection between the devicefd (opened via
device-passthrough framework) and iommufd. Most importantly, the entire
/dev/iommu framework adopts a device-centric model w/o carrying any container/
group legacy as current vfio does. This requires the binding operation also
establishes a security context which prevents the bound device from accessing
the rest of the system, as the contract for vfio to grant user access to the
assigned device. Detail explanation of this aspect can be found in patch 06.

Last, the format of an I/O page table must be compatible to the attached 
devices (or more specifically to the IOMMU which serves the DMA from the
attached devices). User is responsible for specifying the format when
allocating an IOASID, according to one or multiple devices which will be
attached right after. The device IOMMU format can be queried via iommufd
once a device is successfully bound to the iommufd. Attaching a device to
an IOASID with incompatible format is simply rejected.

The skeleton is mostly implemented in iommufd, except that bind_iommufd/
ioasid_attach operations are initiated via device-passthrough framework
specific uAPIs. This RFC only changes vfio to work with iommufd. vdpa
support can be added in a later stage.

Basically iommufd provides following uAPIs and helper functions:

- IOMMU_DEVICE_GET_INFO, for querying per-device iommu capability/format;
- IOMMU_IOASID_ALLOC/FREE, as the name stands;
- IOMMU_[UN]MAP_DMA, providing vfio type1v2 semantics for managing a
  specific I/O page table;
- helper functions for vfio to bind_iommufd/attach_ioasid with devices;

vfio extensions include:
- A new interface for user to open a device w/o using container/group uAPI;
- VFIO_DEVICE_BIND_IOMMUFD, for binding a vfio device to an iommufd;
  * unbind is automatically done when devicefd is closed;
- VFIO_DEVICE_[DE]ATTACH_IOASID, for attaching/detaching a vfio device
  to/from an ioasid in the specified iommufd;

[TODO in RFC v2]

We did one temporary hack in v1 by reusing vfio_iommu_type1.c to implement
IOMMU_[UN]MAP_DMA. This leads to some dirty code in patch 16/17/18. We
estimated almost 80% of the current type1 code are related to map/unmap.
It needs non-trivial effort for either duplicating it in iommufd or making
it shared by both vfio and iommufd. We hope this hack doesn't affect the
review of the overall skeleton, since the  role of this part is very clear.
Based on the received feedback we will make a clean implementation in v2.

For userspace our time doesn't afford a clean implementation in Qemu.
Instead, we just wrote a simple application (similar to the example in
iommufd.rst) and verified the basic work flow (bind/unbind, alloc/free
ioasid, attach/detach, map/unmap, multi-devices group, etc.). We did
verify the I/O page table mappings established as expected, though no
DMA is conducted. We plan to have a clean implementation in Qemu and
provide a public link for reference when v2 is sending out.

[TODO out of this RFC]

The entire /dev/iommu project involves lots of tasks. It has to grow in
a staging approach. Below is a rough list of TODO features. Most of them
can be developed in parallel after this skeleton is accepted. For more
detail please refer to the design proposal [2]:

1. Move more vfio device types to iommufd:
    * device which does no-snoop DMA
    * software mdev
    * PPC device
    * platform device

2. New vfio device type
    * hardware mdev/subdev (with PASID)

3. vDPA adoption

4. User-managed I/O page table
    * ioasid nesting (hardware)
    * ioasid nesting (software)
    * pasid virtualization
        o pdev (arm/amd)
        o pdev/mdev which doesn't support enqcmd (intel)
        o pdev/mdev which supports enqcmd (intel)
    * I/O page fault (stage-1)

5. Miscellaneous
    * I/O page fault (stage-2), for on-demand paging
    * IOMMU dirty bit, for hardware-assisted dirty page tracking
    * shared I/O page table (mm, ept, etc.)
    * vfio/vdpa shim to avoid code duplication for legacy uAPI
    * hardware-assisted vIOMMU

[1] https://lore.kernel.org/linux-iommu/20210330132830.GO2356281@nvidia.com/
[2] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/

[Series Overview]
* Basic skeleton:
  0001-iommu-iommufd-Add-dev-iommu-core.patch

* VFIO PCI creates device-centric interface:
  0002-vfio-Add-vfio-device-class-for-device-nodes.patch
  0003-vfio-Add-vfio_-un-register_device.patch
  0004-iommu-Add-iommu_device_get_info-interface.patch
  0005-vfio-pci-Register-device-centric-interface.patch

* Bind device fd with iommufd:
  0006-iommu-Add-iommu_device_init-exit-_user_dma-interface.patch
  0007-iommu-iommufd-Add-iommufd_-un-bind_device.patch
  0008-vfio-pci-Add-VFIO_DEVICE_BIND_IOMMUFD.patch

* IOASID allocation:
  0009-iommu-iommufd-Add-IOMMU_DEVICE_GET_INFO.patch
  0010-iommu-iommufd-Add-IOMMU_IOASID_ALLOC-FREE.patch

* IOASID [de]attach:
  0011-iommu-Extend-iommu_at-de-tach_device-for-multiple-de.patch
  0012-iommu-iommufd-Add-iommufd_device_-de-attach_ioasid.patch
  0013-vfio-pci-Add-VFIO_DEVICE_-DE-ATTACH_IOASID.patch

* /dev/iommu DMA (un)map:
  0014-vfio-type1-Export-symbols-for-dma-un-map-code-sharin.patch
  0015-iommu-iommufd-Report-iova-range-to-userspace.patch
  0016-iommu-iommufd-Add-IOMMU_-UN-MAP_DMA-on-IOASID.patch

* Report the device info:
  0017-iommu-vt-d-Implement-device_info-iommu_ops-callback.patch

* Add doc:
  0018-Doc-Add-documentation-for-dev-iommu.patch
 
* Basic skeleton:
  0001-iommu-iommufd-Add-dev-iommu-core.patch

* VFIO PCI creates device-centric interface:
  0002-vfio-Add-device-class-for-dev-vfio-devices.patch
  0003-vfio-Add-vfio_-un-register_device.patch
  0004-iommu-Add-iommu_device_get_info-interface.patch
  0005-vfio-pci-Register-device-to-dev-vfio-devices.patch

* Bind device fd with iommufd:
  0006-iommu-Add-iommu_device_init-exit-_user_dma-interface.patch
  0007-iommu-iommufd-Add-iommufd_-un-bind_device.patch
  0008-vfio-pci-Add-VFIO_DEVICE_BIND_IOMMUFD.patch

* IOASID allocation:
  0009-iommu-Add-page-size-and-address-width-attributes.patch
  0010-iommu-iommufd-Add-IOMMU_DEVICE_GET_INFO.patch
  0011-iommu-iommufd-Add-IOMMU_IOASID_ALLOC-FREE.patch
  0012-iommu-iommufd-Add-IOMMU_CHECK_EXTENSION.patch

* IOASID [de]attach:
  0013-iommu-Extend-iommu_at-de-tach_device-for-multiple-de.patch
  0014-iommu-iommufd-Add-iommufd_device_-de-attach_ioasid.patch
  0015-vfio-pci-Add-VFIO_DEVICE_-DE-ATTACH_IOASID.patch

* DMA (un)map:
  0016-vfio-type1-Export-symbols-for-dma-un-map-code-sharin.patch
  0017-iommu-iommufd-Report-iova-range-to-userspace.patch
  0018-iommu-iommufd-Add-IOMMU_-UN-MAP_DMA-on-IOASID.patch

* Report the device info in vt-d driver to enable whole series:
  0019-iommu-vt-d-Implement-device_info-iommu_ops-callback.patch

* Add doc:
  0020-Doc-Add-documentation-for-dev-iommu.patch

Complete code can be found in:
https://github.com/luxis1999/dev-iommu/commits/dev-iommu-5.14-rfcv1

Thanks for your time!

Regards,
Yi Liu
---

Liu Yi L (15):
  iommu/iommufd: Add /dev/iommu core
  vfio: Add device class for /dev/vfio/devices
  vfio: Add vfio_[un]register_device()
  vfio/pci: Register device to /dev/vfio/devices
  iommu/iommufd: Add iommufd_[un]bind_device()
  vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
  iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
  iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
  iommu/iommufd: Add IOMMU_CHECK_EXTENSION
  iommu/iommufd: Add iommufd_device_[de]attach_ioasid()
  vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
  vfio/type1: Export symbols for dma [un]map code sharing
  iommu/iommufd: Report iova range to userspace
  iommu/iommufd: Add IOMMU_[UN]MAP_DMA on IOASID
  Doc: Add documentation for /dev/iommu

Lu Baolu (5):
  iommu: Add iommu_device_get_info interface
  iommu: Add iommu_device_init[exit]_user_dma interfaces
  iommu: Add page size and address width attributes
  iommu: Extend iommu_at[de]tach_device() for multiple devices group
  iommu/vt-d: Implement device_info iommu_ops callback

 Documentation/userspace-api/index.rst   |   1 +
 Documentation/userspace-api/iommufd.rst | 183 ++++++
 drivers/iommu/Kconfig                   |   1 +
 drivers/iommu/Makefile                  |   1 +
 drivers/iommu/intel/iommu.c             |  35 +
 drivers/iommu/iommu.c                   | 188 +++++-
 drivers/iommu/iommufd/Kconfig           |  11 +
 drivers/iommu/iommufd/Makefile          |   2 +
 drivers/iommu/iommufd/iommufd.c         | 832 ++++++++++++++++++++++++
 drivers/vfio/pci/Kconfig                |   1 +
 drivers/vfio/pci/vfio_pci.c             | 179 ++++-
 drivers/vfio/pci/vfio_pci_private.h     |  10 +
 drivers/vfio/vfio.c                     | 366 ++++++++++-
 drivers/vfio/vfio_iommu_type1.c         | 246 ++++++-
 include/linux/iommu.h                   |  35 +
 include/linux/iommufd.h                 |  71 ++
 include/linux/vfio.h                    |  27 +
 include/uapi/linux/iommu.h              | 162 +++++
 include/uapi/linux/vfio.h               |  56 ++
 19 files changed, 2358 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/userspace-api/iommufd.rst
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/iommufd.c
 create mode 100644 include/linux/iommufd.h

-- 
2.25.1

