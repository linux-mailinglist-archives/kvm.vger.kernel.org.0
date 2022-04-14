Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072C6500B72
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242454AbiDNKti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbiDNKth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:37 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D457E18B38
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933231; x=1681469231;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=48Xokbng5d6dua81VY7NaGw4smQ7xscTZ452J6IEtYA=;
  b=AuwRZpG7e0Kppzk8nJ/juAB3gCuKrOPS8X0doJ747vpIiC3vYxHqLnnY
   Hsfp+9JNLJRLhiDPeFtQhwdl5iTbYDvqYpC5K8terK3ewR64QMYLUmy/e
   wYXNb5+3VETMqo6Vwr1J4liIRbvz4K5ThK8CqhjhwMFkTWTKgs6ra4lrx
   saM8QnRE2aW+LCAuuHGz8lebVyhD7aJ7dR1RnwvzyMAico7PUBvpzaIr4
   5CLwNZKBTsO+yhJJwMYXzesVpJafNz65xCCtupBnVraTZnGCFH4X1aQ+Z
   Zkdsw8CONB2Lt/qwvNhD5XjFZXWD/ZsbiTspvJwrf8LqzEkGBRYDgQt2+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808655"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808655"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091163"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:10 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 00/18] vfio: Adopt iommufd
Date:   Thu, 14 Apr 2022 03:46:52 -0700
Message-Id: <20220414104710.28534-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the introduction of iommufd[1], the linux kernel provides a generic
interface for userspace drivers to propagate their DMA mappings to kernel
for assigned devices. This series does the porting of the VFIO devices
onto the /dev/iommu uapi and let it coexist with the legacy implementation.
Other devices like vpda, vfio mdev and etc. are not considered yet.

For vfio devices, the new interface is tied with device fd and iommufd
as the iommufd solution is device-centric. This is different from legacy
vfio which is group-centric. To support both interfaces in QEMU, this
series introduces the iommu backend concept in the form of different
container classes. The existing vfio container is named legacy container
(equivalent with legacy iommu backend in this series), while the new
iommufd based container is named as iommufd container (may also be mentioned
as iommufd backend in this series). The two backend types have their own
way to setup secure context and dma management interface. Below diagram
shows how it looks like with both BEs.

                    VFIO                           AddressSpace/Memory
    +-------+  +----------+  +-----+  +-----+
    |  pci  |  | platform |  |  ap |  | ccw |
    +---+---+  +----+-----+  +--+--+  +--+--+     +----------------------+
        |           |           |        |        |   AddressSpace       |
        |           |           |        |        +------------+---------+
    +---V-----------V-----------V--------V----+               /
    |           VFIOAddressSpace              | <------------+
    |                  |                      |  MemoryListener
    |          VFIOContainer list             |
    +-------+----------------------------+----+
            |                            |
            |                            |
    +-------V------+            +--------V----------+
    |   iommufd    |            |    vfio legacy    |
    |  container   |            |     container     |
    +-------+------+            +--------+----------+
            |                            |
            | /dev/iommu                 | /dev/vfio/vfio
            | /dev/vfio/devices/vfioX    | /dev/vfio/$group_id
 Userspace  |                            |
 ===========+============================+================================
 Kernel     |  device fd                 |
            +---------------+            | group/container fd
            | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
            |  ATTACH_IOAS) |            | device fd
            |               |            |
            |       +-------V------------V-----------------+
    iommufd |       |                vfio                  |
(map/unmap  |       +---------+--------------------+-------+
 ioas_copy) |                 |                    | map/unmap
            |                 |                    |
     +------V------+    +-----V------+      +------V--------+
     | iommfd core |    |  device    |      |  vfio iommu   |
     +-------------+    +------------+      +---------------+

[Secure Context setup]
- iommufd BE: uses device fd and iommufd to setup secure context
              (bind_iommufd, attach_ioas)
- vfio legacy BE: uses group fd and container fd to setup secure context
                  (set_container, set_iommu)
[Device access]
- iommufd BE: device fd is opened through /dev/vfio/devices/vfioX
- vfio legacy BE: device fd is retrieved from group fd ioctl
[DMA Mapping flow]
- VFIOAddressSpace receives MemoryRegion add/del via MemoryListener
- VFIO populates DMA map/unmap via the container BEs
  *) iommufd BE: uses iommufd
  *) vfio legacy BE: uses container fd

This series qomifies the VFIOContainer object which acts as a base class
for a container. This base class is derived into the legacy VFIO container
and the new iommufd based container. The base class implements generic code
such as code related to memory_listener and address space management whereas
the derived class implements callbacks that depend on the kernel user space
being used.

The selection of the backend is made on a device basis using the new
iommufd option (on/off/auto). By default the iommufd backend is selected
if supported by the host and by QEMU (iommufd KConfig). This option is
currently available only for the vfio-pci device. For other types of
devices, it does not yet exist and the legacy BE is chosen by default.

Test done:
- PCI and Platform device were tested
- ccw and ap were only compile-tested
- limited device hotplug test
- vIOMMU test run for both legacy and iommufd backends (limited tests)

This series was co-developed by Eric Auger and me based on the exploration
iommufd kernel[2], complete code of this series is available in[3]. As
iommufd kernel is in the early step (only iommufd generic interface is in
mailing list), so this series hasn't made the iommufd backend fully on par
with legacy backend w.r.t. features like p2p mappings, coherency tracking,
live migration, etc. This series hasn't supported PCI devices without FLR
neither as the kernel doesn't support VFIO_DEVICE_PCI_HOT_RESET when userspace
is using iommufd. The kernel needs to be updated to accept device fd list for
reset when userspace is using iommufd. Related work is in progress by
Jason[4].

TODOs:
- Add DMA alias check for iommufd BE (group level)
- Make pci.c to be BE agnostic. Needs kernel change as well to fix the
  VFIO_DEVICE_PCI_HOT_RESET gap
- Cleanup the VFIODevice fields as it's used in both BEs
- Add locks
- Replace list with g_tree
- More tests

Patch Overview:

- Preparation:
  0001-scripts-update-linux-headers-Add-iommufd.h.patch
  0002-linux-headers-Import-latest-vfio.h-and-iommufd.h.patch
  0003-hw-vfio-pci-fix-vfio_pci_hot_reset_result-trace-poin.patch
  0004-vfio-pci-Use-vbasedev-local-variable-in-vfio_realize.patch
  0005-vfio-common-Rename-VFIOGuestIOMMU-iommu-into-iommu_m.patch
  0006-vfio-common-Split-common.c-into-common.c-container.c.patch

- Introduce container object and covert existing vfio to use it:
  0007-vfio-Add-base-object-for-VFIOContainer.patch
  0008-vfio-container-Introduce-vfio_attach-detach_device.patch
  0009-vfio-platform-Use-vfio_-attach-detach-_device.patch
  0010-vfio-ap-Use-vfio_-attach-detach-_device.patch
  0011-vfio-ccw-Use-vfio_-attach-detach-_device.patch
  0012-vfio-container-obj-Introduce-attach-detach-_device-c.patch
  0013-vfio-container-obj-Introduce-VFIOContainer-reset-cal.patch

- Introduce iommufd based container:
  0014-hw-iommufd-Creation.patch
  0015-vfio-iommufd-Implement-iommufd-backend.patch
  0016-vfio-iommufd-Add-IOAS_COPY_DMA-support.patch

- Add backend selection for vfio-pci:
  0017-vfio-as-Allow-the-selection-of-a-given-iommu-backend.patch
  0018-vfio-pci-Add-an-iommufd-option.patch

[1] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com/
[2] https://github.com/luxis1999/iommufd/tree/iommufd-v5.17-rc6
[3] https://github.com/luxis1999/qemu/tree/qemu-for-5.17-rc6-vm-rfcv1
[4] https://lore.kernel.org/kvm/0-v1-a8faf768d202+125dd-vfio_mdev_no_group_jgg@nvidia.com/

Base commit: 4bf58c7 virtio-iommu: use-after-free fix

Thanks,
Yi & Eric

Eric Auger (12):
  scripts/update-linux-headers: Add iommufd.h
  linux-headers: Import latest vfio.h and iommufd.h
  hw/vfio/pci: fix vfio_pci_hot_reset_result trace point
  vfio/pci: Use vbasedev local variable in vfio_realize()
  vfio/container: Introduce vfio_[attach/detach]_device
  vfio/platform: Use vfio_[attach/detach]_device
  vfio/ap: Use vfio_[attach/detach]_device
  vfio/ccw: Use vfio_[attach/detach]_device
  vfio/container-obj: Introduce [attach/detach]_device container
    callbacks
  vfio/container-obj: Introduce VFIOContainer reset callback
  vfio/as: Allow the selection of a given iommu backend
  vfio/pci: Add an iommufd option

Yi Liu (6):
  vfio/common: Rename VFIOGuestIOMMU::iommu into ::iommu_mr
  vfio/common: Split common.c into common.c, container.c and as.c
  vfio: Add base object for VFIOContainer
  hw/iommufd: Creation
  vfio/iommufd: Implement iommufd backend
  vfio/iommufd: Add IOAS_COPY_DMA support

 MAINTAINERS                          |    7 +
 hw/Kconfig                           |    1 +
 hw/iommufd/Kconfig                   |    4 +
 hw/iommufd/iommufd.c                 |  209 +++
 hw/iommufd/meson.build               |    1 +
 hw/iommufd/trace-events              |   11 +
 hw/iommufd/trace.h                   |    1 +
 hw/meson.build                       |    1 +
 hw/vfio/ap.c                         |   62 +-
 hw/vfio/as.c                         | 1042 ++++++++++++
 hw/vfio/ccw.c                        |  118 +-
 hw/vfio/common.c                     | 2340 ++------------------------
 hw/vfio/container-obj.c              |  221 +++
 hw/vfio/container.c                  | 1308 ++++++++++++++
 hw/vfio/iommufd.c                    |  570 +++++++
 hw/vfio/meson.build                  |    6 +
 hw/vfio/migration.c                  |    4 +-
 hw/vfio/pci.c                        |  133 +-
 hw/vfio/platform.c                   |   42 +-
 hw/vfio/spapr.c                      |   22 +-
 hw/vfio/trace-events                 |   11 +
 include/hw/iommufd/iommufd.h         |   37 +
 include/hw/vfio/vfio-common.h        |   96 +-
 include/hw/vfio/vfio-container-obj.h |  169 ++
 linux-headers/linux/iommufd.h        |  223 +++
 linux-headers/linux/vfio.h           |   84 +
 meson.build                          |    1 +
 scripts/update-linux-headers.sh      |    2 +-
 28 files changed, 4258 insertions(+), 2468 deletions(-)
 create mode 100644 hw/iommufd/Kconfig
 create mode 100644 hw/iommufd/iommufd.c
 create mode 100644 hw/iommufd/meson.build
 create mode 100644 hw/iommufd/trace-events
 create mode 100644 hw/iommufd/trace.h
 create mode 100644 hw/vfio/as.c
 create mode 100644 hw/vfio/container-obj.c
 create mode 100644 hw/vfio/container.c
 create mode 100644 hw/vfio/iommufd.c
 create mode 100644 include/hw/iommufd/iommufd.h
 create mode 100644 include/hw/vfio/vfio-container-obj.h
 create mode 100644 linux-headers/linux/iommufd.h

-- 
2.27.0

