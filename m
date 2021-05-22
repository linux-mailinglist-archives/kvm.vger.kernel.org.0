Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AE438D249
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhEVAUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:20:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:50278 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhEVAUc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:20:32 -0400
IronPort-SDR: O4IurjhamkGVBePUVJrcaIYCpOcrKpnen5Z6no/i7VmWQWeSN4CmkpIlM4KMvievDcAU1LCzwG
 Sersn6L+RXgw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="198518509"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="198518509"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:06 -0700
IronPort-SDR: lRGVHu3sDlfwO3wRUqFV/IkYVxGdkDnHLbDW/K2U4lgsvy2OYcsmkJ9Wy0fmfsFp7aWZO+8D5C
 XdfWraZxsFZA==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="434499755"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:05 -0700
Subject: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI support
 for the idxd driver
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:05 -0700
Message-ID: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series is rebased on top of Jason's VFIO refactoring collection:
https://github.com/jgunthorpe/linux/pull/3

We would like to receive review comments with respect to the mdev driver itself
and the common VFIO IMS support code that was suggested by Jason. The previous
version of the DEV-MSI/IMS code is still under review and also the IOASID code
is under design.

v6:
- Rebased on top of Jason's recent VFIO refactoring.
- Move VFIO IMS setup code to common (Jason)
- Changed patch ordering to minimize code stubs (Jason)

v5:
- Split out non driver IMS code to its own series.
- Removed common devsec code, Bjorn asked to deal with it post 5.11 and keep
custom code for now.
- Reworked irq_entries for IMS so emulated vector is also included.
- Reworked vidxd_send_interrupt() to take irq_entry directly (data ready for
consumption) (Thomas)
- Removed pointer to msi_entry in irq_entries (Thomas)
- Removed irq_domain check on free entries (Thomas)
- Split out irqbypass management code (Thomas)
- Fix EXPORT_SYMBOL to EXPORT_SYMBOL_GPL (Thomas)

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
- Add release int handle release support due to spec 1.1 update.

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
Followed the generic layering scheme: infrastructure bits->arch
bits->enabling bits

Mdev:
- Remove set kvm group notifier (Yan Zhao)
- Fix VFIO irq trigger removal (Yan Zhao)
- Add mmio read flush to ims mask (Jason)

v2:
IMS (now dev-msi):
- With recommendations from Jason/Thomas/Dan on making IMS more generic:
- Pass a non-pci generic device(struct device) for IMS management instead of
mdev
- Remove all references to mdev and symbol_get/put
- Remove all references to IMS in common code and replace with dev-msi
- Remove dynamic allocation of platform-msi interrupts: no groups,no
new msi list or list helpers
- Create a generic dev-msi domain with and without interrupt remapping
enabled.
- Introduce dev_msi_domain_alloc_irqs and dev_msi_domain_free_irqs apis

mdev:
- Removing unrelated bits from SVA enabling that’s not necessary for
the submission. (Kevin)
- Restructured entire mdev driver series to make reviewing easier (Kevin)
- Made rw emulation more robust (Kevin)
- Removed uuid wq type and added single dedicated wq type (Kevin)
- Locking fixes for vdev (Yan Zhao)
- VFIO MSIX trigger fixes (Yan Zhao)

This code series will match the support of the 5.6 kernel (stage 1) driver
but on guest.

The code has dependency on DEV_MSI/IMS enabling code:
https://lore.kernel.org/lkml/1614370277-23235-1-git-send-email-megha.dey@intel.com/

The code has dependency on idxd driver sub-driver cleanup series:
https://lore.kernel.org/dmaengine/162163546245.260470.18336189072934823712.stgit@djiang5-desk3.ch.intel.com/T/#t

The code has dependency on Jason's VFIO refactoring:
https://lore.kernel.org/kvm/0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com/

Part 1 of the driver has been accepted in v5.6 kernel. It supports dedicated
workqueue (wq) without Shared Virtual Memory (SVM) support.

Part 2 of the driver supports shared wq and SVM and has been accepted in
kernel v5.11.

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

The kernel tree can be found at [7].

[1]: https://lore.kernel.org/lkml/157965011794.73301.15960052071729101309.stgit@djiang5-desk3.ch.intel.com/
[2]: https://software.intel.com/en-us/articles/intel-sdm
[3]: https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[4]: https://software.intel.com/en-us/download/intel-data-streaming-accelerator-preliminary-architecture-specification
[5]: https://01.org/blogs/2019/introducing-intel-data-streaming-accelerator
[6]: https://intel.github.io/idxd/
[7]: https://github.com/intel/idxd-driver idxd-stage2.5

---

Dave Jiang (20):
      vfio/mdev: idxd: add theory of operation documentation for idxd mdev
      dmaengine: idxd: add external module driver support for dsa_bus_type
      dmaengine: idxd: add IMS offset and size retrieval code
      dmaengine: idxd: add portal offset for IMS portals
      vfio: mdev: common lib code for setting up Interrupt Message Store
      vfio/mdev: idxd: add PCI config for read/write for mdev
      vfio/mdev: idxd: Add administrative commands emulation for mdev
      vfio/mdev: idxd: Add mdev device context initialization
      vfio/mdev: Add mmio read/write support for mdev
      vfio/mdev: idxd: add mdev type as a new wq type
      vfio/mdev: idxd: Add basic driver setup for idxd mdev
      vfio: move VFIO PCI macros to common header
      vfio/mdev: idxd: add mdev driver registration and helper functions
      vfio/mdev: idxd: add 1dwq-v1 mdev type
      vfio/mdev: idxd: ims domain setup for the vdcm
      vfio/mdev: idxd: add new wq state for mdev
      vfio/mdev: idxd: add error notification from host driver to mediated device
      vfio: move vfio_pci_set_ctx_trigger_single to common code
      vfio: mdev: Add device request interface
      vfio/mdev: idxd: setup request interrupt


 .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
 drivers/dma/Kconfig                           |    1 +
 drivers/dma/idxd/Makefile                     |    2 +
 drivers/dma/idxd/cdev.c                       |    4 +-
 drivers/dma/idxd/device.c                     |  102 +-
 drivers/dma/idxd/idxd.h                       |   52 +-
 drivers/dma/idxd/init.c                       |   59 +
 drivers/dma/idxd/irq.c                        |   21 +-
 drivers/dma/idxd/registers.h                  |   25 +-
 drivers/dma/idxd/sysfs.c                      |   22 +
 drivers/vfio/Makefile                         |    2 +-
 drivers/vfio/mdev/Kconfig                     |   21 +
 drivers/vfio/mdev/Makefile                    |    4 +
 drivers/vfio/mdev/idxd/Makefile               |    4 +
 drivers/vfio/mdev/idxd/mdev.c                 |  958 ++++++++++++++++
 drivers/vfio/mdev/idxd/mdev.h                 |  112 ++
 drivers/vfio/mdev/idxd/vdev.c                 | 1016 +++++++++++++++++
 drivers/vfio/mdev/mdev_irqs.c                 |  341 ++++++
 drivers/vfio/pci/vfio_pci_intrs.c             |   63 +-
 drivers/vfio/pci/vfio_pci_private.h           |    6 -
 drivers/vfio/vfio_common.c                    |   74 ++
 include/linux/mdev.h                          |   66 ++
 include/linux/vfio.h                          |   10 +
 include/uapi/linux/idxd.h                     |    2 +
 24 files changed, 2890 insertions(+), 83 deletions(-)
 create mode 100644 drivers/vfio/mdev/idxd/Makefile
 create mode 100644 drivers/vfio/mdev/idxd/mdev.c
 create mode 100644 drivers/vfio/mdev/idxd/mdev.h
 create mode 100644 drivers/vfio/mdev/idxd/vdev.c
 create mode 100644 drivers/vfio/mdev/mdev_irqs.c
 create mode 100644 drivers/vfio/vfio_common.c

--

