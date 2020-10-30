Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94372A0DEC
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgJ3SxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:53:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:35295 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbgJ3SxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:53:14 -0400
IronPort-SDR: EvoLUMt5v+SwmRwF5M1PJX3m0gpHEa0E8j9jrKgMrwATKqYYlBYhpCx9HOakJWLt1mt+mdkCBA
 DSEeOsHrPcfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9790"; a="147936810"
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="147936810"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:11 -0700
IronPort-SDR: 2Il6LhmX4D6Z5JnAyWW1xB2zxcZQENZoBdYJjW6JOsF5YIRwsOB3fgm9Thipxte67tU/cWakId
 dfAtrq5uwbBA==
X-IronPort-AV: E=Sophos;i="5.77,434,1596524400"; 
   d="scan'208";a="351960498"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 11:51:10 -0700
Subject: [PATCH v4 03/17] dmaengine: idxd: add theory of operation
 documentation for idxd mdev
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
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 30 Oct 2020 11:51:09 -0700
Message-ID: <160408386942.912050.10453115629849166836.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add idxd vfio mediated device theory of operation documentation.
Provide description on mdev design, usage, and why vfio mdev was chosen.

Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/driver-api/vfio/mdev-idxd.rst |  404 +++++++++++++++++++++++++++
 MAINTAINERS                                 |    1 
 2 files changed, 405 insertions(+)
 create mode 100644 Documentation/driver-api/vfio/mdev-idxd.rst

diff --git a/Documentation/driver-api/vfio/mdev-idxd.rst b/Documentation/driver-api/vfio/mdev-idxd.rst
new file mode 100644
index 000000000000..c75b7d88ef6b
--- /dev/null
+++ b/Documentation/driver-api/vfio/mdev-idxd.rst
@@ -0,0 +1,404 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============
+IDXD Overview
+=============
+IDXD (Intel Data Accelerator Driver) is the driver for the Intel Data
+Streaming Accelerator (DSA).  Intel DSA is a high performance data copy
+and transformation accelerator. In addition to data move operations,
+the device also supports data fill, CRC generation, Data Integrity Field
+(DIF), and memory compare and delta generation. Intel DSA supports
+a variety of PCI-SIG defined capabilities such as Address Translation
+Services (ATS), Process address Space ID (PASID), Page Request Interface
+(PRI), Message Signalled Interrupts Extended (MSI-X), and Advanced Error
+Reporting (AER). Some of those capabilities enable the device to support
+Shared Virtual Memory (SVM), or also known as Shared Virtual Addressing
+(SVA). Intel DSA also supports Intel Scalable I/O Virtualization (SIOV)
+to improve scalability of device assignment.
+
+
+The Intel DSA device contains the following basic components:
+* Work queue (WQ)
+
+  A WQ is an on device storage to queue descriptors to the
+  device. Requests are added to a WQ by using new CPU instructions
+  (MOVDIR64B and ENQCMD(S)) to write the memory mapped “portal”
+  associated with each WQ.
+
+* Engine
+
+  Operation unit that pulls descriptors from WQs and processes them.
+
+* Group
+
+  Abstract container to associate one or more engines with one or more WQs.
+
+
+Two types of WQs are supported:
+* Dedicated WQ (DWQ)
+
+  A single client should owns this exclusively and can submit work
+  to it. The MOVDIR64B instruction is used to submit descriptors to
+  this type of WQ. The instruction is a posted write, therefore the
+  submitter must ensure not exceed the WQ length for submission. The
+  use of PASID is optional with DWQ. Multiple clients can submit to
+  a DWQ, but sychronization is required due to when the WQ is full,
+  the submission is silently dropped.
+
+* Shared WQ (SWQ)
+
+  Multiple clients can submit work to this WQ. The submitter must use
+  ENQMCDS (from supervisor mode) or ENQCMD (from user mode). These
+  instructions will indicate via EFLAGS.ZF bit whether a submission
+  succeeds. The use of PASID is mandatory to identify the address space
+  of each client.
+
+
+For more information about the new instructions [1][2].
+
+The IDXD driver is broken down into following usages:
+* In kernel interface through dmaengine subsystem API.
+* Userspace DMA support through character device. mmap(2) is utilized
+  to map directly to mmio address (or portals) for descriptor submission.
+* VFIO Mediated device (mdev) supporting device passthrough usages.
+
+
+=================================
+Assignable Device Interface (ADI)
+=================================
+The term ADI is used to represent the minimal unit of assignment for
+Intel Scalable IOV device. Each ADI instance refers to the set of device
+backend resources that are allocated, configured and organized as an
+isolated unit.
+
+Intel DSA defines each WQ as an ADI. The MMIO registers of each work queue
+are partitioned into two categories:
+* MMIO registers accessed for data-path operations. 
+* MMIO registers accessed for control-path operations.
+
+Data-path MMIO registers of each WQ are contained within
+one or more system page size aligned regions and can be mapped in the
+CPU page table for direct access from the guest. Control-path MMIO
+registers of all WQs are located together but segregated from data-path
+MMIO regions. Therefore, guest updates to control-path registers must
+be intercepted and then go through the host driver to be reflected in
+the device.
+
+Data-path MMIO registers of DSA WQ are portals for submitting descriptors
+to the device. There are four portals per WQ, each being 64 bytes
+in size and located on a separate 4KB page in BAR2. Each portal has
+different implications regarding interrupt message type (MSI vs. IMS)
+and occupancy control (limited vs. unlimited). It is not necessary to
+map all portals to the guest.
+
+Control-path MMIO registers of DSA WQ include global configurations
+(shared by all WQs) and WQ-specific configurations. The owner
+(e.g. the guest) of the WQ is expected to only change WQ-specific
+configurations. Intel DSA spec introduces a “Configuration Support”
+capability which, if cleared, indicates that some fields of WQ
+configuration registers are read-only and the WQ configuration is
+pre-configured by the host. 
+
+
+Interrupt Message Store (IMS)
+=============================
+The ADI utilizes Interrupt Message Store (IMS), a device-specific MSI
+implementation, instead of MSIX for interrupts for the guest. This
+preserves MSIX for host usages and also allows a significantly larger
+number of interrupt vectors for large number of guests usage.
+
+Intel DSA device implements IMS as on-device memory mapped unified
+storage. Each interrupt message is stored as a DWORD size data payload
+and a 64-bit address (same as MSI-X). Access to the IMS is through the
+host idxd driver.
+
+The idxd driver makes use of the generic IMS irq chip and domain which
+stores the interrupt messages in an array in device memory. Allocation and
+freeing of interrupts happens via the generic msi_domain_alloc/free_irqs()
+interface. Driver only needs to ensure the interrupt domain is stored in
+the underlying device struct.
+
+
+ADI Isolation
+=============
+Operations or functioning of one ADI must not affect the functioning
+of another ADI or the physical device. Upstream memory requests from
+different ADIs are distinguished using a Process Address Space Identifier
+(PASID). With the support of PASID-granular address translation in Intel
+VT-d, the address space targeted by a request from ADI can be a Host
+Virtual Address (HVA), Host I/O Virtual Address (HIOVA), Guest Physical
+Address (GPA), Guest Virtual Address (GVA), Guest I/O Virtual Address
+(GIOVA), etc. The PASID identity for an ADI is expected to be accessed
+or modified by privileged software through the host driver.
+
+=========================
+Virtual DSA (vDSA) Device
+=========================
+The DSA WQ itself is not a PCI device thus must be composed into a
+virtual DSA device to the guest.
+
+The composition logic needs to handle four main requirements:
+* Emulate PCI config space.
+* Map data-path portals for direct access from the guest.
+* Emulate control-path MMIO registers and selectively forward WQ
+  configuration requests through host driver to the device.
+* Forward and emulate WQ interrupts to the guest.
+
+The composition logic tells the guest aspects of WQ which are configurable
+through a combination of capability fields, e.g.:
+* Configuration Support (if cleared, most aspects are not modifiable).
+* WQ Mode Support (if cleared, cannot change between dedicated and
+  shared mode).
+* Dedicated Mode Support.
+* Shared Mode Support.
+* ...
+
+The virtual capability fields are set according to the vDSA
+type. Following are examples of vDSA types and related WQ configurability:
+* Type ‘1DWQ_v1’
+   * One DSA gen 1 WQ dedicated to this guest
+   * Guest cannot share the WQ between its clients (no guest SVA)
+   * Guest cannot change any WQ configuration
+* Type ‘1SWQ_v1’
+   * One DSA gen 1 WQ shared between multiple VMs
+   * Guest can further share the WQ between its clients (guest SVA is required)
+   * Guest cannot change any WQ configuration
+* Type ‘1WQfull_v1’
+   * One DSA gen 1 WQ dedicated to this guest
+   * Guest is allowed to do limited WQ configurations (thru WQCFG
+     register), including WQ mode (dedicated/shared), privilege,
+     threshold, PASID enable, PASID value, etc.
+
+Besides, the composition logic also needs to serve administrative commands
+(thru virtual CMD register) through host driver, including:
+* Drain/abort all descriptors submitted by this guest.
+* Drain/abort descriptors associated with a PASID.
+* Enable/disable/reset the WQ (when it’s not shared by multiple VMs).
+* Request interrupt handle.
+
+With this design, vDSA emulation is **greatly simplified**. Most
+registers are emulated in simple READ-ONLY flavor, and handling limited
+configurability is required only for a few registers.
+
+===========================
+VFIO mdev vs. userspace DMA
+===========================
+There are two avenues to support vDSA composition.
+1. VFIO mediated device (mdev)
+2. Userspace DMA through char device
+
+VFIO mdev provides a generic subdevice passthrough framework. Unified
+uAPIs are used for both device and subdevice passthrough, thus any
+userspace VMM which already supports VFIO device passthrough would
+naturally support mdev/subdevice passthrough. The implication of VFIO
+mdev is putting emulation of device interface in the kernel (part of
+host driver) which must be carefully scrutinized. Fortunately, vDSA
+composition includes only a small portion of emulation code, due to the
+fact that most registers are simply READ-ONLY to the guest. The majority
+logic of handling limited configurability and administrative commands
+is anyway required to sit in the kernel, regardless of which kernel uAPI
+is pursued. In this regard, VFIO mdev is a nice fit for vDSA composition.
+
+IDXD driver provides a char device interface for applications to
+map the WQ portal and directly submit descriptors to do DMA. This
+interface provides only data-path access to userspace and relies on
+the host driver to handle control-path configurations. Expanding such
+interface to support subdevice passthrough allows moving the emulation
+code to userspace. However, quite some work is required to grow it from
+an application-oriented interface into a passthrough-oriented interface:
+new uAPIs to handle guest WQ configurability and administrative commands,
+and new uAPIs to handle passthrough specific requirements (e.g. DMA map,
+guest SVA, live migration, posted interrupt, etc.). And once it is done,
+every userspace VMM has to explicitly bind to IDXD specific uAPI, even
+though the real user is in the guest (instead of the VMM itself) in the
+passthrough scenario.
+
+Although some generalization might be possible to reduce the work of
+handling passthrough, we feel the difference between userspace DMA
+and subdevice passthrough is distinct in IDXD. Therefore, we choose to
+build vDSA composition on top of VFIO mdev framework and leave userspace
+DMA intact after discussion at LPC 2020.
+
+=============================
+Host Registration and Release
+=============================
+
+Intel DSA reports support for Intel Scalable IOV via a PCI Express
+Designated Vendor Specific Extended Capability (DVSEC). In addition,
+PASID-granular address translation capability is required in the
+IOMMU. During host initialization, the IDXD driver should check the
+presence of both capabilities before calling mdev_register_device()
+to register with the VFIO mdev framework and provide a set of ops
+(struct mdev_parent_ops). The IOMMU capability is indicated by the
+IOMMU_DEV_FEAT_AUX feature flag with iommu_dev_has_feature() and enabled
+with iommu_dev_enable_feature().
+
+On release, iommu_dev_disable_feature() is called after
+mdev_unregister_device() to disable the IOMMU_DEV_FEAT_AUX flag that
+the driver enabled during host initialization.
+
+The mdev_parent_ops data structure is filled out by the driver to provide
+a number of ops called by VFIO mdev framework::
+
+        struct mdev_parent_ops {
+                .supported_type_groups
+                .create
+                .remove
+                .open
+                .release
+                .read
+                .write
+                .mmap
+                .ioctl
+        };
+
+Supported_type_groups
+---------------------
+At the moment only one vDSA type is supported.
+
+“1DWQ_v1”:
+  Single dedicated WQ (DSA 1.0) with read-only configuration exposed to
+  the guest. On the guest kernel, a vDSA device shows up with a single
+  WQ that is pre-configured by the host. The configuration for the WQ
+  is entirely read-only and cannot be reconfigured. There is no support
+  of guest SVA on this WQ.
+
+  The interrupt vector 0 is emulated by the driver to support the admin
+  command completion and error reporting. A second interrupt vector is
+  bound to the IMS and used for I/O operation.
+
+
+create
+------
+API function to create the mdev. mdev_set_iommu_device() is called to
+associate the mdev device to the parent PCI device. This function is
+where the driver sets up and initializes the resources to support a single
+mdev device. This is triggered through sysfs to initiate the creation.
+
+remove
+------
+API function that mirrors the create() function and releases all the
+resources backing the mdev.  This is also triggered through sysfs.
+
+open
+----
+API function that is called down from VFIO userspace to indicate to the
+driver that the upper layers are ready to claim and utilize the mdev. IMS
+entries are allocated and setup here.
+
+release
+-------
+The mirror function to open that releases the mdev by VFIO userspace.
+
+read / write
+------------
+This is where the Intel IDXD driver provides read/write emulation of
+PCI config space and MMIO registers. These paths are the “slow” path
+of the mediated device and emulation is used rather than direct access
+to the hardware resources. Typically configuration and administrative
+commands go through this path. This allows the mdev to show up as a
+virtual PCI device on the guest kernel.
+
+The emulation of PCI config space is nothing special, which is simply
+copied from kvmgt. In the future this part might be consolidated to
+reduce duplication.
+
+Emulating MMIO reads are simply memory copies. There is no side-effect
+to be emulated upon guest read.
+
+Emulating MMIO writes are required only for a few registers, due to
+read-only configuration on the ‘1DWQ-v1’ type. Majority of composition
+logic is hooked in the CMD register for performing administrative commands
+such as WQ drain, abort, enable, disable and reset operations. The rest of
+the emulation is about handling errors (GENCTRL/SWERROR) and interrupts
+(INTCAUSE/MSIXPERM) on the vDSA device. Future mdev types might allow
+limited WQ configurability, which then requires additional emulation of
+the WQCFG register.
+
+mmap
+----
+This is the function that provides the setup to expose a portion of the
+hardware, also known as portals, for direct access for “fast” path
+operations through the mmap() syscall. A limited region of the hardware
+is mapped to the guest for direct I/O submission.
+
+There are four portals per WQ: unlimited MSI-X, limited MSI-X, unlimited
+IMS, limited IMS.  Descriptors submitted to limited portals are subject
+to threshold configuration limitations for shared WQs. The MSI-X portals
+are used for host submissions, and the IMS portals are mapped to vm for
+guest submission.
+
+ioctl
+-----
+This API function does several things
+* Provides general device information to VFIO userspace.
+* Provides device region information (PCI, mmio, etc).
+* Get interrupts information
+* Setup interrupts for the mediated device.
+* Mdev device reset
+
+For the Intel idxd driver, Interrupt Message Store (IMS) vectors are being
+used for mdev interrupts rather than MSIX vectors. IMS provides additional
+interrupt vectors outside of PCI MSIX specification in order to support
+significantly more vectors. The emulated interrupt (0) is connected through
+kernel eventfd. When interrupt 0 needs to be asserted, the driver will
+signal the eventfd to trigger the MSIX vector 0 interrupt on the guest.
+The IMS interrupts are setup via eventfd as well. However, it utilizes
+irq bypass manager to directly inject the interrupt in the guest.
+
+To allocate IMS, we utilize the IMS array APIs. On host init, we need
+to create the MSI domain::
+
+        struct ims_array_info ims_info;
+        struct device *dev = &pci_dev->dev;
+
+
+        /* assign the device IMS size */
+        ims_info.max_slots = max_ims_size;
+        /* assign the MMIO base address for the IMS table */
+        ims_info.slots = mmio_base + ims_offset;
+        /* assign the MSI domain to the device */
+        dev->msi_domain = pci_ims_array_create_msi_irq_domain(pci_dev, &ims_info);
+
+When we are ready to allocate the interrupts::
+
+        struct device *dev = mdev_dev(mdev);
+
+        irq_domain = pci_dev->dev.msi_domain;
+        /* the irqs are allocated against device of mdev */
+        rc = msi_domain_alloc_irqs(irq_domain, dev, num_vecs);
+
+
+        /* we can retrieve the slot index from msi_entry */
+        for_each_msi_entry(entry, dev) {
+                slot_index = entry->device_msi.hwirq;
+                irq = entry->irq;
+        }
+
+        request_irq(irq, interrupt_handler_function, 0, “ims”, context);
+
+
+The DSA device is structured such that MSI-X table entry 0 is used for
+admin commands completion, error reporting, and other misc commands. The
+remaining MSI-X table entries are used for WQ completion. For vm support,
+the virtual device also presents a similar layout. Therefore, vector 0
+is emulated by the software. Additional vector(s) are associated with IMS.
+
+The index (slot) for the per device IMS entry is managed by the MSI
+core. The index is the “interrupt handle” that the guest kernel
+needs to program into a DMA descriptor. That interrupt handle tells the
+hardware which IMS vector to trigger the interrupt on for the host.
+
+The virtual device presents an admin command called “request interrupt
+handle” that is not supported by the physical device. On probe of
+the DSA device on the guest kernel, the guest driver will issue the
+“request interrupt handle” command in order to get the interrupt
+handle for descriptor programming. The host driver will return the
+assigned slot for the IMS entry table to the guest.
+
+References
+==========
+[1] https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
+[2] https://software.intel.com/en-us/articles/intel-sdm
+[3] https://software.intel.com/sites/default/files/managed/cc/0e/intel-scalable-io-virtualization-technical-specification.pdf
+[4] https://software.intel.com/en-us/download/intel-data-streaming-accelerator-preliminary-architecture-specification
diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..af04e674853c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8888,6 +8888,7 @@ INTEL IADX DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	dmaengine@vger.kernel.org
 S:	Supported
+F:	Documentation/driver-api/vfio/mdev-idxd.rst
 F:	drivers/dma/idxd/*
 F:	include/uapi/linux/idxd.h
 


