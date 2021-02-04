Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57D30E475
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhBCU6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:58:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:12600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232418AbhBCU6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:58:09 -0500
IronPort-SDR: Ufhf3p2MP74m6bMrZcfqIaAS97kWCDINIBVYs9Mt0cUpdmunjBL6F/H44bHHyqoP6QxtoHwBY4
 6YSYHDcUFyKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="200084219"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="200084219"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 12:57:28 -0800
IronPort-SDR: yMqLzRM8tQcXr+F3v3s6g/9oYesf6lNaMFrMbQVl3ch/g8Svfv0ksgiAXszPU9lnf2HW0dIW1q
 2MR208kK0L6Q==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="372510537"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 03 Feb 2021 12:57:27 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [PATCH 00/12] Introduce dev-msi and interrupt message store
Date:   Wed,  3 Feb 2021 12:56:33 -0800
Message-Id: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide support for device specific MSI implementations for devices which
have their own resource management and interrupt chip. These devices are
not related to PCI and contrary to platform MSI they do not share a
common resource and interrupt chip. They provide their own domain specific
resource management and interrupt chip.

On top of this, add support for Interrupt Message Store or IMS[1], which
is a scalable device specific interrupt mechanism to support devices which
may need more than 2048 interrupts. With IMS, there is theoretically no
upper bound on the number of interrupts a device can support. The normal
IMS use case is for guest usages but it can very well be used by host too.

Introduce a generic IMS irq chip and domain which stores the interrupt
messages as an array in device memory. Allocation and freeing of interrupts
happens via the generic msi_domain_alloc/free_irqs() interface. One only
needs to ensure the interrupt domain is stored in the underlying device struct.

These patches can be divided into following steps:

1. X86 specific preparation for device MSI
   x86/irq: Add DEV_MSI allocation type
   x86/msi: Rename and rework pci_msi_prepare() to cover non-PCI MSI

2. Generic device MSI infrastructure
   platform-msi: Provide default irq_chip:: Ack
   genirq/proc: Take buslock on affinity write
   genirq/msi: Provide and use msi_domain_set_default_info_flags()
   platform-msi: Add device MSI infrastructure
   irqdomain/msi: Provide msi_alloc/free_store() callbacks
   genirq: Set auxiliary data for an interrupt

3. Interrupt Message Store (IMS) irq domain/chip implementation for device array
   irqchip: Add IMS (Interrupt Message Store) driver
   iommu/vt-d: Add DEV-MSI support

4. Add platform check for subdevice irq domain
   iommu: Add capability IOMMU_CAP_VIOMMU
   platform-msi: Add platform check for subdevice irq domain

The device IMS (Interrupt Message Storage) should not be enabled in any
virtualization environments unless there is a HYPERCALL domain which
makes the changes in the message store monitored by the hypervisor.[2]
As the initial step, we allow the IMS to be enabled only if we are
running on the bare metal. It's easy to enable IMS in the virtualization
environments if above preconditions are met in the future.

These patches have been tested with the IDXD driver:
        https://github.com/intel/idxd-driver idxd-stage2.5
Most of these patches are originally by Thomas:
        https://lore.kernel.org/linux-hyperv/20200826111628.794979401@linutronix.de/
and are rebased on latest kernel

This patches series has undergone a lot of changes since first submitted as an RFC
in September 2019. I have divided the changes into 3 stages for better understanding

Stage 1: Standalone RFC IMS series[3]
-------------------------------------
https://lore.kernel.org/lkml/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/
V1:
1. Extend existing platform-msi to support IMS
2. platform_msi_domain_alloc_irqs_group is introduced to allocate IMS
   interrupts, tagged with a group ID.
3. To free vectors of a particular group, platform_msi_domain_free_irqs_group
   API in introduced

Stage 2: dev-msi/IMS merged with Dave Jiang's IDXD series[2]
------------------------------------------------------------
V1: (changes from stage 1):
1. Introduced a new list for platform-msi descriptors
2. Introduced dynamic allocation for IMS interrupts
3. shifted creation of ims domain from arch/x86 to drivers/
4. Removed arch specific callbacks
5. Introduced enum platform_msi_type
6. Added more technical details to the cover letter
7. Merge common code between platform-msi.c and ims-msi.c
8. Introduce new structures platform_msi_ops and platform_msi_funcs
9. Addressed Andriy Shevchenko's comments on RFC V1 patch series
10. Dropped the dynamic group allocation scheme.
11. Use RCU lock instead of mutex lock to protect the device list

V2:
1. IMS made dev-msi
2. With recommendations from Jason/Thomas/Dan on making IMS more generic
3. Pass a non-pci generic device(struct device) for IMS management instead of mdev
4. Remove all references to mdev and symbol_get/put
5. Remove all references to IMS in common code and replace with dev-msi
6. Remove dynamic allocation of platform-msi interrupts: no groups,no
   new msi list or list helpers
7. Create a generic dev-msi domain with and without interrupt remapping enabled.
8. Introduce dev_msi_domain_alloc_irqs and dev_msi_domain_free_irqs apis

V3:
1. No need to add support for 2 different dev-msi irq domains, a common
   once can be used for both the cases(with IR enabled/disabled)
2. Add arch specific function to specify additions to msi_prepare callback
   instead of making the callback a weak function
3. Call platform ops directly instead of a wrapper function
4. Make mask/unmask callbacks as void functions
5. dev->msi_domain should be updated at the device driver level before
   calling dev_msi_alloc_irqs()
6. dev_msi_alloc/free_irqs() cannot be used for PCI devices
7. Followed the generic layering scheme: infrastructure bits->arch bits->enabling bits

V4:
1. Make interrupt remapping code more readable
2. Add flush writes to unmask/write and reset ims slots
3. Interrupt Message Storm-> Interrupt Message Store
4. Merge in pasid programming code.

Stage 3: Standalone dev-msi and IMS driver series
-------------------------------------------------
V1:(Changes from Stage 2 V4)
1. Split dev-msi/IMS code from Dave Jiang’s IDXD patch series
2. Set the source-id of all dev-msi interrupt requests to the parent PCI device
3. Separated core irq code from IMS related code
4. Added missing set_desc ops to the IMS msi_domain_ops
5. Added more details in the commit message-test case for auxillary interrupt data
6. Updated the copyright year from 2020 to 2021
7. Updated cover letter
8. Add platform check for subdevice irq domain (Lu Baolu):
   V1->V2:
   - V1 patches:[4]
   - Rename probably_on_bare_metal() with on_bare_metal();
   - Some vendors might use the same name for both bare metal and virtual
     environment. Before we add vendor specific code to distinguish
     between them, let's return false in on_bare_metal(). This won't
     introduce any regression. The only impact is that the coming new
     platform msi feature won't be supported until the vendor specific code
     is provided.
   V2->V3:
   - V2 patches:[5]
   - Add all identified heuristics so far

[1]: https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[2]: https://lore.kernel.org/dmaengine/160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com/
[3]: https://lore.kernel.org/lkml/1568338328-22458-1-git-send-email-megha.dey@linux.intel.com/
[4]: https://lore.kernel.org/linux-pci/20201210004624.345282-1-baolu.lu@linux.intel.com/
[5]: https://lore.kernel.org/linux-pci/20210106022749.2769057-1-baolu.lu@linux.intel.com/

Lu Baolu (2):
  iommu: Add capability IOMMU_CAP_VIOMMU_HINT
  platform-msi: Add platform check for subdevice irq domain

Megha Dey (2):
  genirq: Set auxiliary data for an interrupt
  iommu/vt-d: Add DEV-MSI support

Thomas Gleixner (8):
  x86/irq: Add DEV_MSI allocation type
  x86/msi: Rename and rework pci_msi_prepare() to cover non-PCI MSI
  platform-msi: Provide default irq_chip:: Ack
  genirq/proc: Take buslock on affinity write
  genirq/msi: Provide and use msi_domain_set_default_info_flags()
  platform-msi: Add device MSI infrastructure
  irqdomain/msi: Provide msi_alloc/free_store() callbacks
  irqchip: Add IMS (Interrupt Message Store) driver

 arch/x86/include/asm/hw_irq.h       |   1 +
 arch/x86/include/asm/msi.h          |   4 +-
 arch/x86/kernel/apic/msi.c          |  27 +++--
 arch/x86/pci/common.c               |  74 +++++++++++++
 drivers/base/platform-msi.c         | 141 ++++++++++++++++++++++++
 drivers/iommu/amd/iommu.c           |   2 +
 drivers/iommu/intel/iommu.c         |  20 ++++
 drivers/iommu/intel/irq_remapping.c |   6 +-
 drivers/iommu/virtio-iommu.c        |   9 ++
 drivers/irqchip/Kconfig             |  14 +++
 drivers/irqchip/Makefile            |   1 +
 drivers/irqchip/irq-ims-msi.c       | 211 ++++++++++++++++++++++++++++++++++++
 drivers/pci/controller/pci-hyperv.c |   2 +-
 drivers/pci/msi.c                   |   7 +-
 include/linux/interrupt.h           |   2 +
 include/linux/iommu.h               |   2 +
 include/linux/irq.h                 |   4 +
 include/linux/irqchip/irq-ims-msi.h |  68 ++++++++++++
 include/linux/irqdomain.h           |   1 +
 include/linux/msi.h                 |  38 +++++++
 kernel/irq/Kconfig                  |   4 +
 kernel/irq/manage.c                 |  38 ++++++-
 kernel/irq/msi.c                    |  35 ++++++
 23 files changed, 692 insertions(+), 19 deletions(-)
 create mode 100644 drivers/irqchip/irq-ims-msi.c
 create mode 100644 include/linux/irqchip/irq-ims-msi.h

-- 
2.7.4

