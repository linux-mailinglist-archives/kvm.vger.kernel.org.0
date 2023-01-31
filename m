Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25D96837EC
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjAaUye (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjAaUyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:54:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218DA58299
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PAwzCsqe2YSBqNSG3y1q0FkKgyaoA5R9+oNGILzyrZI=;
        b=T2UpiDXcxmTkgLP9b1Cqvgpvo2qdD1igb9BOv6PvXGvXgfU6auejBdOq2scHZXhcpdwcYQ
        XFGGGHRcEoGxXP9kGWJfbZS4GmPywRmfmLjnlBfBH6DXjBWn2F3cnRHnGkG6V0Lv3/BQdk
        vERKmuaFkwBhZK3zq6T0dNa5VJImKgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-Ya3mQyCfOOya2D36jwUNdg-1; Tue, 31 Jan 2023 15:53:16 -0500
X-MC-Unique: Ya3mQyCfOOya2D36jwUNdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0AF85CCE3;
        Tue, 31 Jan 2023 20:53:15 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC92F40C2064;
        Tue, 31 Jan 2023 20:53:08 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 00/18] vfio: Adopt iommufd
Date:   Tue, 31 Jan 2023 21:52:47 +0100
Message-Id: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the introduction of iommufd, the Linux kernel provides a generic
interface for userspace drivers to propagate their DMA mappings to kernel
for assigned devices. This series does the porting of the VFIO devices
onto the /dev/iommu uapi and let it coexist with the legacy implementation.

This QEMU integration is the result of a collaborative work between
Yi Liu, Yi Sun, Nicolin Chen and Eric Auger.

At QEMU level, interactions with the /dev/iommu are abstracted by a new
iommufd object (compiled in with the CONFIG_IOMMUFD option).

Any QEMU device (e.g. vfio device) wishing to use /dev/iommu must be
linked with an iommufd object. In this series, the vfio-pci device is
granted with such capability (other VFIO devices are not yet ready):

It gets a new optional parameter named iommufd which allows to pass
an iommufd object:

    -object iommufd,id=iommufd0
    -device vfio-pci,host=0000:02:00.0,iommufd=iommufd0

Note the /dev/iommu can be externally opened by a management layer.
In such a case the fd is passed along with the iommufd object:
  
    -object iommufd,id=iommufd0,fd=22
    -device vfio-pci,host=0000:02:00.0,iommufd=iommufd0

If the fd parameter is not passed, the fd (/dev/iommu) is opened by QEMU.

If no iommufd option is passed to the vfio-pci device, iommufd is not
used and the end-user gets the behavior based on the legacy vfio iommu
interfaces:

    -device vfio-pci,host=0000:02:00.0

While the legacy kernel interface is group-centric, the new iommufd
interface is device-centric, relying on device fd and iommufd.

To support both interfaces in the QEMU VFIO device we reworked the vfio
container abstraction so that the generic VFIO code can use either
backend.

The VFIOContainer object becomes a base object derived into
a) the legacy VFIO container and
b) the new iommufd based container.

The base object implements generic code such as code related to
memory_listener and address space management whereas the derived
objects implement callbacks specific to either BE, legacy and
iommufd. Indeed each backend has its own way to setup secure context
and dma management interface. The below diagram shows how it looks
like with both BEs.

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
Userspace   |                            |
============+============================+===========================
Kernel      |  device fd                 |
            +---------------+            | group/container fd
            | (BIND_IOMMUFD |            | (SET_CONTAINER/SET_IOMMU)
            |  ATTACH_IOAS) |            | device fd
            |               |            |
            |       +-------V------------V-----------------+
    iommufd |       |                vfio                  |
(map/unmap  |       +---------+--------------------+-------+
ioas_copy)  |                 |                    | map/unmap
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

This series depends on Yi's kernel series:
"[PATCH 00/13] Add vfio_device cdev for iommufd support"
https://lore.kernel.org/all/20230117134942.101112-1-yi.l.liu@intel.com/

which can be found at:
https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v1

This qemu series can be found at:
https://github.com/eauger/qemu/tree/iommufd_rfcv3

Test done:
- PCI and Platform device were tested
- ccw and ap were only compile-tested
- limited device hotplug test
- vIOMMU test run for both legacy and iommufd backends (limited tests)

Given some iommufd kernel limitations, the iommufd backend is
not yuet fully on par with the legacy backend w.r.t. features like:
- p2p mappings (you will see related error traces)
- coherency tracking
- live migration
- vfio pci device hot reset
- and etc.

TODOs:
- Add DMA alias check for iommufd BE (group level)
- Make pci.c to be BE agnostic. Needs kernel change as well to fix the
  VFIO_DEVICE_PCI_HOT_RESET gap
- Cleanup the VFIODevice fields as it's used in both backends
- Add device fd parameter to vfio-device in case the iommufd option is used
- Add locks
- Replace list with g_tree
- More tests

Change log:
v2 -> v3:
- rebase on top of v7.2.0
- Fix the compilation with CONFIG_IOMMUFD unset by using true classes for
  VFIO backends
- Fix use after free in error path, reported by Alister
- Split common.c in several steps to ease the review

v1 -> v2:
- remove the first three patches of rfcv1
- add open cdev helper suggested by Jason
- remove the QOMification of the VFIOContainer and simply use standard ops (David)
- add "-object iommufd" suggested by Alex

v1: https://lore.kernel.org/qemu-devel/20220414104710.28534-1-yi.l.liu@intel.com/

Thanks,
Yi, Yi, Eric


Eric Auger (10):
  scripts/update-linux-headers: Add iommufd.h
  vfio/common: Introduce vfio_container_add|del_section_window()
  vfio/container: Introduce vfio_[attach/detach]_device
  vfio/platform: Use vfio_[attach/detach]_device
  vfio/ap: Use vfio_[attach/detach]_device
  vfio/ccw: Use vfio_[attach/detach]_device
  vfio/container-base: Introduce [attach/detach]_device container
    callbacks
  vfio/container-base: Introduce VFIOContainer reset callback
  backends/iommufd: Introduce the iommufd object
  vfio/as: Allow the selection of a given iommu backend

Yi Liu (8):
  linux-headers: Import vfio.h and iommufd.h
  vfio/common: Move IOMMU agnostic helpers to a separate file
  vfio/common: Move legacy VFIO backend code into separate container.c
  vfio/common: Rename into as.c
  vfio: Add base container
  util/char_dev: Add open_cdev()
  vfio/iommufd: Implement the iommufd backend
  vfio/iommufd: Add IOAS_COPY_DMA support

 MAINTAINERS                           |   13 +
 qapi/qom.json                         |   16 +-
 include/hw/vfio/vfio-common.h         |   94 +-
 include/hw/vfio/vfio-container-base.h |  162 ++
 include/qemu/char_dev.h               |   16 +
 include/sysemu/iommufd.h              |   47 +
 linux-headers/linux/iommufd.h         |  349 ++++
 linux-headers/linux/kvm.h             |   58 +-
 linux-headers/linux/vfio.h            |  344 +++-
 backends/iommufd.c                    |  265 +++
 backends/iommufd_stub.c               |   35 +
 hw/vfio/ap.c                          |   62 +-
 hw/vfio/as.c                          |  993 ++++++++++
 hw/vfio/ccw.c                         |  118 +-
 hw/vfio/common.c                      | 2574 -------------------------
 hw/vfio/container-base.c              |  172 ++
 hw/vfio/container.c                   | 1349 +++++++++++++
 hw/vfio/helpers.c                     |  598 ++++++
 hw/vfio/iommufd.c                     |  565 ++++++
 hw/vfio/migration.c                   |    5 +-
 hw/vfio/pci.c                         |   83 +-
 hw/vfio/platform.c                    |   42 +-
 hw/vfio/spapr.c                       |   22 +-
 util/chardev_open.c                   |   61 +
 backends/Kconfig                      |    5 +
 backends/meson.build                  |    2 +
 backends/trace-events                 |   12 +
 hw/vfio/meson.build                   |    6 +-
 hw/vfio/trace-events                  |   11 +
 qemu-options.hx                       |   12 +
 scripts/update-linux-headers.sh       |    2 +-
 util/meson.build                      |    1 +
 32 files changed, 5192 insertions(+), 2902 deletions(-)
 create mode 100644 include/hw/vfio/vfio-container-base.h
 create mode 100644 include/qemu/char_dev.h
 create mode 100644 include/sysemu/iommufd.h
 create mode 100644 linux-headers/linux/iommufd.h
 create mode 100644 backends/iommufd.c
 create mode 100644 backends/iommufd_stub.c
 create mode 100644 hw/vfio/as.c
 delete mode 100644 hw/vfio/common.c
 create mode 100644 hw/vfio/container-base.c
 create mode 100644 hw/vfio/container.c
 create mode 100644 hw/vfio/helpers.c
 create mode 100644 hw/vfio/iommufd.c
 create mode 100644 util/chardev_open.c

-- 
2.37.3

