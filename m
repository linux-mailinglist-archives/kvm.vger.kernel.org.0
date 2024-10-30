Return-Path: <kvm+bounces-30013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDB69B625E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 12:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FA211F21B77
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 11:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18C61E7655;
	Wed, 30 Oct 2024 11:56:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204D079D2;
	Wed, 30 Oct 2024 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289381; cv=none; b=DpVlIrlDSsLeJDbsEflgrfREY/OCOfhzjrdGjZ1OQu47On6u9KuoyeUnri3gKZhoxgS2SjT3WrC/00kNPWxKYOWklhuVm1Jfi5WdbrCMCKO2y2tf4LHXpydX9lAR9PDMdY8Lj2uFfEymQN1xFJjxvH1H/HmfGGo9FqDnruPrpls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289381; c=relaxed/simple;
	bh=5z9/T3UXEW6lG4xakIGGEzGXoMGGoluht/KIMPSiWbw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFQ3cXmVRAWwxwrQQHnHlz+fwDfNV5TyFl2LfluYZmxuQ0m1TkeEKD87/igbreoQj00fWD57xoQa7UfQiptGMcmuUdMNkyTpM3kcvE9s6mH/XyK/BiTlCK+uf1qdAS1VSeLjYyW9o8EYnipfQAq92MTEukkbfjQ+gmfsXcsc3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE0C4CEE3;
	Wed, 30 Oct 2024 11:56:15 +0000 (UTC)
Date: Wed, 30 Oct 2024 13:56:11 +0200
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
Cc: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
 <alison.schofield@intel.com>, <dan.j.williams@intel.com>,
 <dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
 <ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
 <acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
 <ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiwang@kernel.org>
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Message-ID: <20241030135611.0000031f.zhiw@nvidia.com>
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:33 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

Hi folks:

As what Kevin and Alex pointed out that we need to discuss about the
virtualization polices for the registers that need to be handled by the
vfio-cxl core, here are my summary about the virtualization polices for
configuration space registers.

For CXL MMIO registers, I am leaning towards vfio-cxl core respecting
the BAR Virtualization ACL Register Block (8.2.6 BAR Virtualization ACL
Register Block), which shows the register ranges can be safely
passed to the guest. For registers are not in the Virtualization ACL
Register Block, or a device doesn't present a BAR Virtualization ACL
Register Block, we leave the handling the to the variant driver.
Besides, 

Feel free to comment.

Z.

----

8.1 Configuration Space Registers
=================================

8.1.3 PCIE DVSEC for CXL Devices
==================================

- DVS Header 1 (0x4)
All bits are RO, emulated as RO and initial values are from the HW.

- DVS Header 2 (0x8)
All bits are RO, emulated as RO and initial values are from the HW.

- DVSEC CXL Capability (0xa)

Overide values from HW:

Bit [5:4] RO - HDM_Count:
Support only one HDM decoder

Bit [12] RO - TSP Capable:
Not supported in v1

Other bits are RO, emulated, and inital values are from the HW.

- DVSEC CXL Control (0xc)

Bit [0] RWL - Cache_Enable:
Emulated as RO if CONFIG_LOCK bit is set, otherwise RW.

Bit [1] RO - IO_Enable:
Emulated as RO.

Bit [12:2] RWL:
Emulated as RO when CONFIG_LOCK bit is set, otherwise RW.

Bit [13] Rsvd:
Emualted as RO

Bit [14] RWL:
Emulated as RO when CONFIG_LOCK bit is set, otherwise RW.

Bit [15] Rsvd:
Emulated as RO.

- DVSEC CXL Status (0xe)

Bit [14] RW1CS - Viral_Status:
Emulate write one clear bit.

Other bits are Rsvd and emulated as RO, inital values are from the HW.

- DVSEC CXL Control 2 (0x10)

Bit [0] RW - Disable caching:
Disable the caching on HW when VM writes bit 1.

Bit [1] RW - Initiate Cache Write Back and Invalidation:
Trigger the cache writeback and invalidation via Linux CXL core, update
cache invalid bit in DVSEC CXL Status 2.

Bit [2] RW - Initiate CXL Reset:
Trigger the CXL reset via Linux CXL core, update the CXL reset complete
, CXL reset error in DVSEC CXL Status 2.

Bit [3] RW - CXL Reset Mem Clr Enable:
As a param when trigger the CXL reset via Linux CXL core.

Bit [4] Desired Volatile HDM State after Hot Reset - RWS/RO
Write the bit on the HW or via Linux CXL core.

Bit [5] Modified Completion Eanble - RW/RO
Write the bit on the HW or via Linux CXL core.

Other bits are Rsvd, emulated as RO and inital values are from the HW.

- DVSEC CXL Status 2 (0x12)
Bit [0] RO - Cache Invalid:
Updated when emulating DVSEC CXL Control 2.

Bit [1] RO - CXL Reset Complete:
Updated when emulating DVSEC CXL Control 2.

Bit [1] RO - CXL Reset Error:
Updated when emulating DVSEC CXL Control 2.

Bit [3] RW1CS/RsvdZ - Volatile HDM Preservation Error:
Read the bit from the HW.

Bit [14:4] Rsvd:
Emulated as RO and inital values are from the HW.

Bit [15] RO - Power Management Intalization Complete:
Read the bit from the HW.

DVSEC CXL Capability2 (0x16)
All bits are RO, emulated as RO and initial values are from the HW.

DVSEC CXL Range 1 Size High (0x18)
All bits are RO, emulated as RO and initial values are from the HW.

DVSEC CXL Range 1 Size Low (0x1c)
All bits are RO, emulated as RO and initial values are from the HW.

DVSEC CXL Range 1 Base High (0x20)
Emulated as RW

DVSEC CXL Range 1 Base Low (0x24)
Emulated as RW

DVSEC CXL Range 2 Size High (0x28)
All bits are RO, emulated as RO and initial values are from the HW.

DVSEC CXL Range 2 Size Low (0x2c)
All bits are RO, emulated as RO and initial values are from the HW.

DVSEC CXL Range 2 Base High (0x30)
Emulated as RW

DVSEC CXL Range 2 Base Low (0x34)
Emulated as RW

DVSEC CXL Capability 3 (0x38)
All bits are RO, emulated as RO and initial values are from the HW.

8.1.4 Non-CXL Function Map DVSEC
================================
Not supported

8.1.5 CXL Extensions DVSEC for Ports
====================================
For root port/switches, no need to support in type-2 device passthorugh

8.1.6 GPF DVSEC for CXL Port
============================
For root port/switches, no need to support in type-2 device passthorugh

8.1.7 GPF DVSEC for CXL Device
==============================

DVS Header 1 (0x4)
All bits are RO, emulated as RO and initial values are from the HW.

DVS Header 2 (0x8)
All bits are RO, emulated as RO and initial values are from the HW.

GPF Phase 2 Duration (0xa)
All bits are RO, emulated as RO and initial values are from the HW.

GPF Phase 2 Power (0xc)
All bits are RO, emulated as RO and initial values are from the HW.

8.1.8 PCIE DVSEC for Flex Bus Port
==================================
For root port/switches, no need to support in type-2 device passthorugh

8.1.9 Register Locator DVSEC
============================

DVS Header 1 (0x4)
All bits are RO, emulated as RO and initial values are from the HW.

DVS Header 2 (0x8)
All bits are RO, emulated as RO and initial values are from the HW.

Register Block 1-3 (Varies)
All bits are RO, emulated as RO and initial values are from the HW.

8.1.10 MLD DVSEC
================
Not supported. Mostly this is for type-3 device.

8.1.11 Table Access DOE
Coupled with QEMU DOE emulation

8.1.12 Memory Device Configuration Space Layout
Not supported. Mostly this is for type-3 device.

8.1.13 Switch Mailbox CCI Configuration Space Layout
Not supported. This is for switches.


> Hi folks:
> 
> As promised in the LPC, here are all you need (patches, repos, guiding
> video, kernel config) to build a environment to test the
> vfio-cxl-core.
> 
> Thanks so much for the discussions! Enjoy and see you in the next one.
> 
> Background
> ==========
> 
> Compute Express Link (CXL) is an open standard interconnect built upon
> industrial PCI layers to enhance the performance and efficiency of
> data centers by enabling high-speed, low-latency communication
> between CPUs and various types of devices such as accelerators,
> memory.
> 
> It supports three key protocols: CXL.io as the control protocol,
> CXL.cache as the cache-coherent host-device data transfer protocol,
> and CXL.mem as memory expansion protocol. CXL Type 2 devices leverage
> the three protocols to seamlessly integrate with host CPUs, providing
> a unified and efficient interface for high-speed data transfer and
> memory sharing. This integration is crucial for heterogeneous
> computing environments where accelerators, such as GPUs, and other
> specialized processors, are used to handle intensive workloads.
> 
> Goal
> ====
> 
> Although CXL is built upon the PCI layers, passing a CXL type-2
> device can be different than PCI devices according to CXL
> specification[1]:
> 
> - CXL type-2 device initialization. CXL type-2 device requires an
> additional initialization sequence besides the PCI device
> initialization. CXL type-2 device initialization can be pretty
> complicated due to its hierarchy of register interfaces. Thus, a
> standard CXL type-2 driver initialization sequence provided by the
> kernel CXL core is used.
> 
> - Create a CXL region and map it to the VM. A mapping between HPA and
> DPA (Device PA) needs to be created to access the device memory
> directly. HDM decoders in the CXL topology need to be configured
> level by level to manage the mapping. After the region is created, it
> needs to be mapped to GPA in the virtual HDM decoders configured by
> the VM.
> 
> - CXL reset. The CXL device reset is different from the PCI device
> reset. A CXL reset sequence is introduced by the CXL spec.
> 
> - Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in
> the configuration for device enumeration and device control. (E.g. if
> a device is capable of CXL.mem CXL.cache, enable/disable capability)
> They are owned by the kernel CXL core, and the VM can not modify them.
> 
> - Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO
> registers that can sit in a PCI BAR. The location of register groups
> sit in the PCI BAR is indicated by the register locator in the CXL
> DVSECs. They are also owned by the kernel CXL core. Some of them need
> to be emulated.
> 
> Design
> ======
> 
> To achieve the purpose above, the vfio-cxl-core is introduced to host
> the common routines that variant driver requires for device
> passthrough. Similar with the vfio-pci-core, the vfio-cxl-core
> provides common routines of vfio_device_ops for the variant driver to
> hook and perform the CXL routines behind it.
> 
> Besides, several extra APIs are introduced for the variant driver to
> provide the necessary information the kernel CXL core to initialize
> the CXL device. E.g., Device DPA.
> 
> CXL is built upon the PCI layers but with differences. Thus, the
> vfio-pci-core is aimed to be re-used as much as possible with the
> awareness of operating on a CXL device.
> 
> A new VFIO device region is introduced to expose the CXL region to the
> userspace. A new CXL VFIO device cap has also been introduced to
> convey the necessary CXL device information to the userspace.
> 
> Patches
> =======
> 
> The patches are based on the cxl-type2 support RFCv2 patchset[2]. Will
> rebase them to V3 once the cxl-type2 support v3 patch review is done.
> 
> PATCH 1-3: Expose the necessary routines required by vfio-cxl.
> 
> PATCH 4: Introduce the preludes of vfio-cxl, including CXL device
> initialization, CXL region creation.
> 
> PATCH 5: Expose the CXL region to the userspace.
> 
> PATCH 6-7: Prepare to emulate the HDM decoder registers.
> 
> PATCH 8: Emulate the HDM decoder registers.
> 
> PATCH 9: Tweak vfio-cxl to be aware of working on a CXL device.
> 
> PATCH 10: Tell vfio-pci-core to emulate CXL DVSECs.
> 
> PATCH 11: Expose the CXL device information that userspace needs.
> 
> PATCH 12: An example variant driver to demonstrate the usage of
> vfio-cxl-core from the perspective of the VFIO variant driver.
> 
> PATCH 13: A workaround needs suggestions.
> 
> Test
> ====
> 
> To test the patches and hack around, a virtual passthrough with nested
> virtualization approach is used.
> 
> The host QEMU emulates a CXL type-2 accel device based on Ira's
> patches with the changes to emulate HDM decoders.
> 
> While running the vfio-cxl in the L1 guest, an example VFIO variant
> driver is used to attach with the QEMU CXL access device.
> 
> The L2 guest can be booted via the QEMU with the vfio-cxl support in
> the VFIOStub.
> 
> In the L2 guest, a dummy CXL device driver is provided to attach to
> the virtual pass-thru device.
> 
> The dummy CXL type-2 device driver can successfully be loaded with the
> kernel cxl core type2 support, create CXL region by requesting the CXL
> core to allocate HPA and DPA and configure the HDM decoders.
> 
> To make sure everyone can test the patches, the kernel config of L1
> and L2 are provided in the repos, the required kernel command params
> and qemu command line can be found from the demostration video.[5]
> 
> Repos
> =====
> 
> QEMU host:
> https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-host L1
> Kernel:
> https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l1-kernel-rfc
> L1 QEMU:
> https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-l1-rfc
> L2 Kernel:
> https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l2
> 
> [1] https://computeexpresslink.org/cxl-specification/
> [2]
> https://lore.kernel.org/netdev/20240715172835.24757-1-alejandro.lucero-palau@amd.com/T/
> [3]
> https://patchew.org/QEMU/20230517-rfc-type2-dev-v1-0-6eb2e470981b@intel.com/
> [4] https://youtu.be/zlk_ecX9bxs?si=hc8P58AdhGXff3Q7
> 
> Feedback expected
> =================
> 
> - Archtiecture level between vfio-pci-core and vfio-cxl-core.
> - Variant driver requirements from more hardware vendors.
> - vfio-cxl-core UABI to QEMU.
> 
> Moving foward
> =============
> 
> - Rebase the patches on top of Alejandro's PATCH v3.
> - Get Ira's type-2 emulated device patch into upstream as CXL folks
> and RH folks both came to talk and expect this. I had a chat with Ira
> and he expected me to take it over. Will start a discussion in the
> CXL discord group for the desgin of V1.
> - Sparse map in vfio-cxl-core.
> 
> Known issues
> ============
> 
> - Teardown path. Missing teardown paths have been implements in
> Alejandor's PATCH v3. It should be solved after the rebase.
> 
> - Powerdown L1 guest instead of reboot it. The QEMU reset handler is
> missing in the Ira's patch. When rebooting L1, many CXL registers are
> not reset. This will be addressed in the formal review of emulated
> CXL type-2 device support.
> 
> Zhi Wang (13):
>   cxl: allow a type-2 device not to have memory device registers
>   cxl: introduce cxl_get_hdm_info()
>   cxl: introduce cxl_find_comp_reglock_offset()
>   vfio: introduce vfio-cxl core preludes
>   vfio/cxl: expose CXL region to the usersapce via a new VFIO device
>     region
>   vfio/pci: expose vfio_pci_rw()
>   vfio/cxl: introduce vfio_cxl_core_{read, write}()
>   vfio/cxl: emulate HDM decoder registers
>   vfio/pci: introduce CXL device awareness
>   vfio/pci: emulate CXL DVSEC registers in the configuration space
>   vfio/cxl: introduce VFIO CXL device cap
>   vfio/cxl: VFIO variant driver for QEMU CXL accel device
>   vfio/cxl: workaround: don't take resource region when cxl is
> enabled.
> 
>  drivers/cxl/core/pci.c              |  28 ++
>  drivers/cxl/core/regs.c             |  22 +
>  drivers/cxl/cxl.h                   |   1 +
>  drivers/cxl/cxlpci.h                |   3 +
>  drivers/cxl/pci.c                   |  14 +-
>  drivers/vfio/pci/Kconfig            |   6 +
>  drivers/vfio/pci/Makefile           |   5 +
>  drivers/vfio/pci/cxl-accel/Kconfig  |   6 +
>  drivers/vfio/pci/cxl-accel/Makefile |   3 +
>  drivers/vfio/pci/cxl-accel/main.c   | 116 +++++
>  drivers/vfio/pci/vfio_cxl_core.c    | 647
> ++++++++++++++++++++++++++++ drivers/vfio/pci/vfio_pci_config.c  |
> 10 + drivers/vfio/pci/vfio_pci_core.c    |  79 +++-
>  drivers/vfio/pci/vfio_pci_rdwr.c    |   8 +-
>  include/linux/cxl_accel_mem.h       |   3 +
>  include/linux/cxl_accel_pci.h       |   6 +
>  include/linux/vfio_pci_core.h       |  53 +++
>  include/uapi/linux/vfio.h           |  14 +
>  18 files changed, 992 insertions(+), 32 deletions(-)
>  create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
>  create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
>  create mode 100644 drivers/vfio/pci/cxl-accel/main.c
>  create mode 100644 drivers/vfio/pci/vfio_cxl_core.c
> 


