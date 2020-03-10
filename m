Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F499180340
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgCJQ2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 12:28:24 -0400
Received: from foss.arm.com ([217.140.110.172]:39244 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgCJQ2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 12:28:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24C2A1FB;
        Tue, 10 Mar 2020 09:28:23 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 392FD3F67D;
        Tue, 10 Mar 2020 09:28:22 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 30/30] arm/arm64: Add PCI Express 1.1 support
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-31-alexandru.elisei@arm.com>
 <20200207165146.66237847@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a2b4a7be-3a49-036d-377f-267f76894805@arm.com>
Date:   Tue, 10 Mar 2020 16:28:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207165146.66237847@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/7/20 4:51 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:48:05 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> PCI Express comes with an extended addressing scheme, which directly
>> translated into a bigger device configuration space (256->4096 bytes)
>> and bigger PCI configuration space (16->256 MB), as well as mandatory
>> capabilities (power management [1] and PCI Express capability [2]).
>>
>> However, our virtio PCI implementation implements version 0.9 of the
>> protocol and it still uses transitional PCI device ID's, so we have
>> opted to omit the mandatory PCI Express capabilities.For VFIO, the power
>> management and PCI Express capability are left for a subsequent patch.
>>
>> [1] PCI Express Base Specification Revision 1.1, section 7.6
>> [2] PCI Express Base Specification Revision 1.1, section 7.8
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/include/arm-common/kvm-arch.h |  4 +-
>>  arm/pci.c                         |  2 +-
>>  builtin-run.c                     |  1 +
>>  hw/vesa.c                         |  2 +-
>>  include/kvm/kvm-config.h          |  2 +-
>>  include/kvm/pci.h                 | 76 ++++++++++++++++++++++++++++---
>>  pci.c                             |  5 +-
>>  vfio/pci.c                        | 26 +++++++----
>>  8 files changed, 97 insertions(+), 21 deletions(-)
>>
>> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
>> index b9d486d5eac2..13c55fa3dc29 100644
>> --- a/arm/include/arm-common/kvm-arch.h
>> +++ b/arm/include/arm-common/kvm-arch.h
>> @@ -23,7 +23,7 @@
>>  
>>  #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
>>  #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
>> -#define ARM_PCI_CFG_SIZE	(1ULL << 24)
>> +#define ARM_PCI_CFG_SIZE	(1ULL << 28)
>>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
>>  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
>>  
>> @@ -50,6 +50,8 @@
>>  
>>  #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
>>  
>> +#define ARCH_HAS_PCI_EXP	1
>> +
>>  static inline bool arm_addr_in_ioport_region(u64 phys_addr)
>>  {
>>  	u64 limit = KVM_IOPORT_AREA + ARM_IOPORT_SIZE;
>> diff --git a/arm/pci.c b/arm/pci.c
>> index 1c0949a22408..eec9f3d936a5 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -77,7 +77,7 @@ void pci__generate_fdt_nodes(void *fdt)
>>  	_FDT(fdt_property_cell(fdt, "#address-cells", 0x3));
>>  	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
>>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0x1));
>> -	_FDT(fdt_property_string(fdt, "compatible", "pci-host-cam-generic"));
>> +	_FDT(fdt_property_string(fdt, "compatible", "pci-host-ecam-generic"));
>>  	_FDT(fdt_property(fdt, "dma-coherent", NULL, 0));
>>  
>>  	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
>> diff --git a/builtin-run.c b/builtin-run.c
>> index 9cb8c75300eb..def8a1f803ad 100644
>> --- a/builtin-run.c
>> +++ b/builtin-run.c
>> @@ -27,6 +27,7 @@
>>  #include "kvm/irq.h"
>>  #include "kvm/kvm.h"
>>  #include "kvm/pci.h"
>> +#include "kvm/vfio.h"
>>  #include "kvm/rtc.h"
>>  #include "kvm/sdl.h"
>>  #include "kvm/vnc.h"
>> diff --git a/hw/vesa.c b/hw/vesa.c
>> index aca938f79c82..4321cfbb6ddc 100644
>> --- a/hw/vesa.c
>> +++ b/hw/vesa.c
>> @@ -82,7 +82,7 @@ static int vesa__bar_deactivate(struct kvm *kvm,
>>  }
>>  
>>  static void vesa__pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -				u8 offset, void *data, int sz)
>> +				u16 offset, void *data, int sz)
>>  {
>>  	u32 value;
>>  
>> diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
>> index a052b0bc7582..a1012c57b7a7 100644
>> --- a/include/kvm/kvm-config.h
>> +++ b/include/kvm/kvm-config.h
>> @@ -2,7 +2,6 @@
>>  #define KVM_CONFIG_H_
>>  
>>  #include "kvm/disk-image.h"
>> -#include "kvm/vfio.h"
>>  #include "kvm/kvm-config-arch.h"
>>  
>>  #define DEFAULT_KVM_DEV		"/dev/kvm"
>> @@ -18,6 +17,7 @@
>>  #define MIN_RAM_SIZE_MB		(64ULL)
>>  #define MIN_RAM_SIZE_BYTE	(MIN_RAM_SIZE_MB << MB_SHIFT)
>>  
>> +struct vfio_device_params;
>>  struct kvm_config {
>>  	struct kvm_config_arch arch;
>>  	struct disk_image_params disk_image[MAX_DISK_IMAGES];
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index ae71ef33237c..0c3c74b82626 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -10,6 +10,7 @@
>>  #include "kvm/devices.h"
>>  #include "kvm/msi.h"
>>  #include "kvm/fdt.h"
>> +#include "kvm.h"
>>  
>>  #define pci_dev_err(pci_hdr, fmt, ...) \
>>  	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> @@ -32,9 +33,41 @@
>>  #define PCI_CONFIG_BUS_FORWARD	0xcfa
>>  #define PCI_IO_SIZE		0x100
>>  #define PCI_IOPORT_START	0x6200
>> -#define PCI_CFG_SIZE		(1ULL << 24)
>>  
>> -struct kvm;
>> +#define PCIE_CAP_REG_VER	0x1
>> +#define PCIE_CAP_REG_DEV_LEGACY	(1 << 4)
>> +#define PM_CAP_VER		0x3
>> +
>> +#ifdef ARCH_HAS_PCI_EXP
>> +#define PCI_CFG_SIZE		(1ULL << 28)
>> +#define PCI_DEV_CFG_SIZE	PCI_CFG_SPACE_EXP_SIZE
>> +
>> +union pci_config_address {
>> +	struct {
>> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>> +		unsigned	reg_offset	: 2;		/* 1  .. 0  */
> Meeh, using C struct bitfields and expect them to map to certain bits is not within the C standard. But I see that you are merely the messenger here, as we use this already for the CAM mapping. So we keep this fix for another time ...
>
>> +		unsigned	register_number	: 10;		/* 11 .. 2  */
>> +		unsigned	function_number	: 3;		/* 14 .. 12 */
>> +		unsigned	device_number	: 5;		/* 19 .. 15 */
>> +		unsigned	bus_number	: 8;		/* 27 .. 20 */
>> +		unsigned	reserved	: 3;		/* 30 .. 28 */
>> +		unsigned	enable_bit	: 1;		/* 31       */
>> +#else
>> +		unsigned	enable_bit	: 1;		/* 31       */
>> +		unsigned	reserved	: 3;		/* 30 .. 28 */
>> +		unsigned	bus_number	: 8;		/* 27 .. 20 */
>> +		unsigned	device_number	: 5;		/* 19 .. 15 */
>> +		unsigned	function_number	: 3;		/* 14 .. 12 */
>> +		unsigned	register_number	: 10;		/* 11 .. 2  */
>> +		unsigned	reg_offset	: 2;		/* 1  .. 0  */
>> +#endif
>> +	};
>> +	u32 w;
>> +};
>> +
>> +#else
>> +#define PCI_CFG_SIZE		(1ULL << 24)
>> +#define PCI_DEV_CFG_SIZE	PCI_CFG_SPACE_SIZE
>>  
>>  union pci_config_address {
>>  	struct {
>> @@ -58,6 +91,8 @@ union pci_config_address {
>>  	};
>>  	u32 w;
>>  };
>> +#endif
>> +#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>  
>>  struct msix_table {
>>  	struct msi_msg msg;
>> @@ -100,6 +135,33 @@ struct pci_cap_hdr {
>>  	u8	next;
>>  };
>>  
>> +struct pcie_cap {
>> +	u8 cap;
>> +	u8 next;
>> +	u16 cap_reg;
>> +	u32 dev_cap;
>> +	u16 dev_ctrl;
>> +	u16 dev_status;
>> +	u32 link_cap;
>> +	u16 link_ctrl;
>> +	u16 link_status;
>> +	u32 slot_cap;
>> +	u16 slot_ctrl;
>> +	u16 slot_status;
>> +	u16 root_ctrl;
>> +	u16 root_cap;
>> +	u32 root_status;
>> +};
> Wouldn't you need those to be defined as packed as well, if you include them below in a packed struct?

No. For gcc-8.4 and gcc-4.0.2 (and I assume everything in between):

"Specifying the |packed|attribute for |struct|and |union|types is equivalent to
specifying the |packed|attribute on each of the structure or union members".

> But more importantly: Do we actually need those definitions? We don't seem to use them, do we?
> And the u8 __pad[PCI_DEV_CFG_SIZE] below should provide the extended storage space a guest would expect?

Yes, we don't use them for the reasons I explained in the commit message. I would
rather keep them, because they are required by the PCIE spec.

Thanks,
Alex
>
> The rest looks alright.
>
> Cheers,
> Andre.
