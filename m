Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFEA2A0DDD
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgJ3Swx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:52:53 -0400
Received: from mga04.intel.com ([192.55.52.120]:61948 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbgJ3Swv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:52:51 -0400
IronPort-SDR: qUq5UuUwNWRp0yWAnOUDA13SnZc+I+UmRLFD5B0U2YXORa/Smi64685QrgEgLyzjNJTHIK2p0i
 rcdk2q2FSYpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="166066326"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="166066326"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:50:50 -0700
IronPort-SDR: yb4iy1MnaDk/HvorLTTuD3ECBRP0QWvp9P+d/Do+P/MfQ+bmR55vk7WABr5Jx6EaDWiD6l33ds
 UX5W9rT18q/A==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="469608019"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:50:48 -0700
Subject: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI support
 for the idxd driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     Megha Dey <megha.dey@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:50:47 -0700
Message-ID: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Would like to acquire Reviewed-by tags from Thomas for MSI and IMS related bits.
- Would like to acquire for Reviewed-by tags from Alex and/or Kirti for the VFIO mdev driver bits.
- Would like to acquire for Reviewed-by tag from Bjorn for PCI common bits
- Would like to acquire 5.11 kernel acceptance through dmaengine (Vinod) with the review tags. 

v4:
dev-msi:
- Make interrupt remapping code more readable (Thomas)
- Add flush writes to unmask/write and reset ims slots (Thomas)
- Interrupt Message Storm-> Interrupt Message Store (Thomas)
- Merge in pasid programming code. (Thomas)

mdev:
- Fixed up domain assignment (Thomas)
- Define magic numbers (Thomas)
- Move siov detection code to PCI common (Thomas)
- Remove duplicated MSI entry info (Thomas)
- Convert code to use ims_slot (Thomas)
- Add explanation of pasid programming for IMS entry (Thomas)
- Add release int handle release support due to DSA spec 1.1 update.

v3:
Dev-msi:
- No need to add support for 2 different dev-msi irq domains, a common
  once can be used for both the cases(with IR enabled/disabled)
- Add arch specific function to specify additions to msi_prepare callback
  instead of making the callback a weak function
- Call platform ops directly instead of a wrapper function
- Make mask/unmask callbacks as void functions
  dev->msi_domain should be updated at the device driver level before
  calling dev_msi_alloc_irqs()
  dev_msi_alloc/free_irqs() cannot be used for PCI devices
  Followed the generic layering scheme: infrastructure bits->arch bits->enabling bits

Mdev:
- Remove set kvm group notifier (Yan Zhao)
- Fix VFIO irq trigger removal (Yan Zhao)
- Add mmio read flush to ims mask (Jason)

v2:
IMS (now dev-msi):
- With recommendations from Jason/Thomas/Dan on making IMS more generic:
- Pass a non-pci generic device(struct device) for IMS management instead of mdev
- Remove all references to mdev and symbol_get/put
- Remove all references to IMS in common code and replace with dev-msi
- Remove dynamic allocation of platform-msi interrupts: no groups,no
  new msi list or list helpers
- Create a generic dev-msi domain with and without interrupt remapping enabled.
- Introduce dev_msi_domain_alloc_irqs and dev_msi_domain_free_irqs apis

mdev: 
- Removing unrelated bits from SVA enabling that’s not necessary for
  the submission. (Kevin)
- Restructured entire mdev driver series to make reviewing easier (Kevin)
- Made rw emulation more robust (Kevin)
- Removed uuid wq type and added single dedicated wq type (Kevin)
- Locking fixes for vdev (Yan Zhao)
- VFIO MSIX trigger fixes (Yan Zhao)

This code series will match the support of the 5.6 kernel (stage 1) driver but on guest.

The code has dependency on Thomas’s MSI restructuring patch series:
https://lore.kernel.org/lkml/20200826111628.794979401@linutronix.de/

The code has dependency on Baolu’s mdev domain patches:
https://lore.kernel.org/lkml/20201030045809.957927-1-baolu.lu@linux.intel.com/

The code has dependency on David Box’s dvsec definition patch:
https://lore.kernel.org/linux-pci/bc5f059c5bae957daebde699945c80808286bf45.camel@linux.intel.com/T/#m1d0dc12e3b2c739e2c37106a45f325bb8f001774

Stage 1 of the driver has been accepted in v5.6 kernel. It supports dedicated workqueue (wq)
without Shared Virtual Memory (SVM) support. 

Stage 2 of the driver supports shared wq and SVM. It should be pending for 5.11 and in
dmaengine/next.

VFIO mediated device framework allows vendor drivers to wrap a portion of
device resources into virtual devices (mdev). Each mdev can be assigned
to different guest using the same set of VFIO uAPIs as assigning a
physical device. Accessing to the mdev resource is served with mixed
policies. For example, vendor drivers typically mark data-path interface
as pass-through for fast guest operations, and then trap-and-mediate the
control-path interface to avoid undesired interference between mdevs. Some
level of emulation is necessary behind vfio mdev to compose the virtual
device interface.

This series brings mdev to idxd driver to enable Intel Scalable IOV
(SIOV), a hardware-assisted mediated pass-through technology. SIOV makes
each DSA wq independently assignable through PASID-granular resource/DMA
isolation. It helps improve scalability and reduces mediation complexity
against purely software-based mdev implementations. Each assigned wq is
configured by host and exposed to the guest in a read-only configuration
mode, which allows the guest to use the wq w/o additional setup. This
design greatly reduces the emulation bits to focus on handling commands
from guests.

There are two possible avenues to support virtual device composition:
1. VFIO mediated device (mdev) or 2. User space DMA through char device
(or UACCE). Given the small portion of emulation to satisfy our needs
and VFIO mdev having the infrastructure already to support the device
passthrough, we feel that VFIO mdev is the better route. For more in depth
explanation, see documentation in Documents/driver-api/vfio/mdev-idxd.rst.

Introducing mdev types “1dwq-v1” type. This mdev type allows
allocation of a single dedicated wq from available dedicated wqs. After
a workqueue (wq) is enabled, the user will generate an uuid. On mdev
creation, the mdev driver code will find a dwq depending on the mdev
type. When the create operation is successful, the user generated uuid
can be passed to qemu. When the guest boots up, it should discover a
DSA device when doing PCI discovery.

For example of “1dwq-v1” type:
1. Enable wq with “mdev” wq type
2. A user generated uuid.
3. The uuid is written to the mdev class sysfs path:
echo $UUID > /sys/class/mdev_bus/0000\:00\:0a.0/mdev_supported_types/idxd-1dwq-v1/create
4. Pass the following parameter to qemu:
"-device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:0a.0/$UUID"
 
The wq exported through mdev will have the read only config bit set
for configuration. This means that the device does not require the
typical configuration. After enabling the device, the user must set the
WQ type and name. That is all is necessary to enable the WQ and start
using it. The single wq configuration is not the only way to create the
mdev. Multi wqs support for mdev will be in the future works.
 
The mdev utilizes Interrupt Message Store or IMS[3], a device-specific
MSI implementation, instead of MSIX for interrupts for the guest. This
preserves MSIX for host usages and also allows a significantly larger
number of interrupt vectors for guest usage.

The idxd driver implements IMS as on-device memory mapped unified
storage. Each interrupt message is stored as a DWORD size data payload
and a 64-bit address (same as MSI-X). Access to the IMS is through the
host idxd driver.

The idxd driver makes use of the generic IMS irq chip and domain which
stores the interrupt messages as an array in device memory. Allocation and
freeing of interrupts happens via the generic msi_domain_alloc/free_irqs()
interface. One only needs to ensure the interrupt domain is stored in
the underlying device struct.

[1]: https://lore.kernel.org/lkml/157965011794.73301.15960052071729101309.stgit@djiang5-desk3.ch.intel.com/
[2]: https://software.intel.com/en-us/articles/intel-sdm
[3]: https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[4]: https://software.intel.com/en-us/download/intel-data-streaming-accelerator-preliminary-architecture-specification
[5]: https://01.org/blogs/2019/introducing-intel-data-streaming-accelerator
[6]: https://intel.github.io/idxd/
[7]: https://github.com/intel/idxd-driver idxd-stage2.5

---

Dave Jiang (15):
      dmaengine: idxd: add theory of operation documentation for idxd mdev
      dmaengine: idxd: add support for readonly config devices
      dmaengine: idxd: add interrupt handle request support
      PCI: add SIOV and IMS capability detection
      dmaengine: idxd: add IMS support in base driver
      dmaengine: idxd: add device support functions in prep for mdev
      dmaengine: idxd: add basic mdev registration and helper functions
      dmaengine: idxd: add emulation rw routines
      dmaengine: idxd: prep for virtual device commands
      dmaengine: idxd: virtual device commands emulation
      dmaengine: idxd: ims setup for the vdcm
      dmaengine: idxd: add mdev type as a new wq type
      dmaengine: idxd: add dedicated wq mdev type
      dmaengine: idxd: add new wq state for mdev
      dmaengine: idxd: add error notification from host driver to mediated device

Megha Dey (1):
      iommu/vt-d: Add DEV-MSI support

Thomas Gleixner (1):
      irqchip: Add IMS (Interrupt Message Store) driver


 .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
 Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
 MAINTAINERS                                   |    1 +
 drivers/dma/Kconfig                           |    9 +
 drivers/dma/idxd/Makefile                     |    2 +
 drivers/dma/idxd/cdev.c                       |    6 +-
 drivers/dma/idxd/device.c                     |  294 ++++-
 drivers/dma/idxd/idxd.h                       |   67 +-
 drivers/dma/idxd/init.c                       |   86 ++
 drivers/dma/idxd/irq.c                        |    6 +-
 drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
 drivers/dma/idxd/mdev.h                       |  116 ++
 drivers/dma/idxd/registers.h                  |   38 +-
 drivers/dma/idxd/submit.c                     |   37 +-
 drivers/dma/idxd/sysfs.c                      |   52 +-
 drivers/dma/idxd/vdev.c                       |  976 ++++++++++++++
 drivers/dma/idxd/vdev.h                       |   28 +
 drivers/iommu/intel/iommu.c                   |   31 +-
 drivers/iommu/intel/irq_remapping.c           |   34 +-
 drivers/pci/Kconfig                           |   15 +
 drivers/pci/Makefile                          |    2 +
 drivers/pci/dvsec.c                           |   40 +
 drivers/pci/siov.c                            |   50 +
 include/linux/pci-siov.h                      |   18 +
 include/linux/pci.h                           |    3 +
 include/uapi/linux/idxd.h                     |    2 +
 include/uapi/linux/pci_regs.h                 |    4 +
 kernel/irq/msi.c                              |    2 +
 28 files changed, 3352 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/driver-api/vfio/mdev-idxd.rst
 create mode 100644 drivers/dma/idxd/mdev.c
 create mode 100644 drivers/dma/idxd/mdev.h
 create mode 100644 drivers/dma/idxd/vdev.c
 create mode 100644 drivers/dma/idxd/vdev.h
 create mode 100644 drivers/pci/dvsec.c
 create mode 100644 drivers/pci/siov.c
 create mode 100644 include/linux/pci-siov.h

--

