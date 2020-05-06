Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84D1C721C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgEFNvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:51:12 -0400
Received: from foss.arm.com ([217.140.110.172]:37036 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgEFNvM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:51:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43E1DD6E;
        Wed,  6 May 2020 06:51:11 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56BF83F68F;
        Wed,  6 May 2020 06:51:10 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 32/32] arm/arm64: Add PCI Express 1.1 support
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>,
        kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-33-alexandru.elisei@arm.com>
 <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f1e6746f-6196-a687-f3c5-78a08df31205@arm.com>
Date:   Wed, 6 May 2020 14:51:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2b963524-3153-fc95-7bf2-b60852ea2f22@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/6/20 3:06 PM, André Przywara wrote:
> On 26/03/2020 15:24, Alexandru Elisei wrote:
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
>>  include/kvm/kvm-config.h          |  2 +-
>>  include/kvm/pci.h                 | 76 ++++++++++++++++++++++++++++---
>>  pci.c                             |  5 +-
>>  vfio/pci.c                        | 26 +++++++----
>>  7 files changed, 96 insertions(+), 20 deletions(-)
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
> The existence of this symbol seems somewhat odd, there should be no ARM
> specific version of the config space size.

The existence of the symbol is required because at the moment PCI Express support
is not available for all architecture, and this file needs to be included in
pci.h, not the other way around. I agree it's not ideal, but that's the way it is
right now.

> Do you know why we don't use the generic PCI_CFG_SIZE here?
> At the very least I would expect something like:
> #define ARM_PCI_CFG_SIZE	PCI_EXP_CFG_SIZE

We don't use PCI_EXP_CFG_SIZE because it might not be available for all
architectures. It is possible it's not there on x86, like the error you have
encountered showed, so instead of waiting for someone to report a compilation
failure, I would rather use a number from the start.

>
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
>> index ed325fa4a811..2251f627d8b5 100644
>> --- a/arm/pci.c
>> +++ b/arm/pci.c
>> @@ -62,7 +62,7 @@ void pci__generate_fdt_nodes(void *fdt)
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
>> index be75f77fd2cb..71ee9d8cb01f 100644
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
>> +#define PCI_DEV_CFG_SIZE	4096
> Maybe use PCI_CFG_SPACE_EXP_SIZE from pci_regs.h?

I cannot do that because it's not available on all distros. I used
PCI_CFG_SPACE_EXP_SIZE in the previous iteration, but I changed it when Sami
reported a compilation failure on his particular setup (it's mentioned in the
changelog).

>
>> +
>> +union pci_config_address {
>> +	struct {
>> +#if __BYTE_ORDER == __LITTLE_ENDIAN
>> +		unsigned	reg_offset	: 2;		/* 1  .. 0  */
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
> Just for the records:
> I think we agreed on this before, but using a C bitfield to model
> hardware defined bits is broken, because the C standard doesn't
> guarantee those bits to be consecutive and layed out like we hope it would.
> But since we have this issue already with the legacy config space, and
> it seems to work (TM), we can fix this later.

Still on the record, it's broken for big endian because only the byte order is
different, not the individual bits. But there are other things that are broken for
big endian, so not a big deal.

>
>> +	};
>> +	u32 w;
>> +};
>> +
>> +#else
>> +#define PCI_CFG_SIZE		(1ULL << 24)
>> +#define PCI_DEV_CFG_SIZE	256
> Shall we use PCI_CFG_SPACE_SIZE from the kernel headers here?

I would rather not, for the reasons explained above.

>
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
> I guess this is meant to map to the PCI Express Capability Structure as
> described in the PCIe spec?
> We would need to add the "packed" attribute then. But actually I am not
> a fan of using C language constructs to model specified register
> arrangements, the kernel tries to avoid this as well.

I'm not sure what you are suggesting. Should we rewrite the entire PCI emulation
code in kvmtool then?

>
> Actually, looking closer: why do we need this in the first place? I
> removed this and struct pm_cap, and it still compiles.
> So can we lose those two structures at all? And move the discussion and
> implementation (for VirtIO 1.0?) to a later series?

I've answered both points in v2 of the series [1].

[1] https://www.spinics.net/lists/kvm/msg209601.html

>
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
>> +
>> +struct pm_cap {
>> +	u8 cap;
>> +	u8 next;
>> +	u16 pmc;
>> +	u16 pmcsr;
>> +	u8 pmcsr_bse;
>> +	u8 data;
>> +};
>> +
>>  struct pci_device_header;
>>  
>>  typedef int (*bar_activate_fn_t)(struct kvm *kvm,
>> @@ -110,14 +172,12 @@ typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
>>  				   int bar_num, void *data);
>>  
>>  #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
>> -#define PCI_DEV_CFG_SIZE	256
>> -#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>  
>>  struct pci_config_operations {
>>  	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -		      u8 offset, void *data, int sz);
>> +		      u16 offset, void *data, int sz);
>>  	void (*read)(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -		     u8 offset, void *data, int sz);
>> +		     u16 offset, void *data, int sz);
>>  };
>>  
>>  struct pci_device_header {
>> @@ -147,6 +207,10 @@ struct pci_device_header {
>>  			u8		min_gnt;
>>  			u8		max_lat;
>>  			struct msix_cap msix;
>> +#ifdef ARCH_HAS_PCI_EXP
>> +			struct pm_cap pm;
>> +			struct pcie_cap pcie;
>> +#endif
>>  		} __attribute__((packed));
>>  		/* Pad to PCI config space size */
>>  		u8	__pad[PCI_DEV_CFG_SIZE];
>> diff --git a/pci.c b/pci.c
>> index 68ece65441a6..b471209a6efc 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -400,7 +400,8 @@ static void pci_config_bar_wr(struct kvm *kvm,
>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>  {
>>  	void *base;
>> -	u8 bar, offset;
>> +	u8 bar;
>> +	u16 offset;
>>  	struct pci_device_header *pci_hdr;
>>  	u8 dev_num = addr.device_number;
>>  	u32 value = 0;
>> @@ -439,7 +440,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>  
>>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>  {
>> -	u8 offset;
>> +	u16 offset;
>>  	struct pci_device_header *pci_hdr;
>>  	u8 dev_num = addr.device_number;
>>  
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 2b891496547d..6b8726227ea0 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -311,7 +311,7 @@ out_unlock:
>>  }
>>  
>>  static void vfio_pci_msix_cap_write(struct kvm *kvm,
>> -				    struct vfio_device *vdev, u8 off,
>> +				    struct vfio_device *vdev, u16 off,
>>  				    void *data, int sz)
>>  {
>>  	struct vfio_pci_device *pdev = &vdev->pci;
>> @@ -343,7 +343,7 @@ static void vfio_pci_msix_cap_write(struct kvm *kvm,
>>  }
>>  
>>  static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
>> -				     u8 off, u8 *data, u32 sz)
>> +				     u16 off, u8 *data, u32 sz)
>>  {
>>  	size_t i;
>>  	u32 mask = 0;
>> @@ -391,7 +391,7 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
>>  }
>>  
>>  static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
>> -				   u8 off, u8 *data, u32 sz)
>> +				   u16 off, u8 *data, u32 sz)
>>  {
>>  	u8 ctrl;
>>  	struct msi_msg msg;
>> @@ -536,7 +536,7 @@ out:
>>  }
>>  
>>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -			      u8 offset, void *data, int sz)
>> +			      u16 offset, void *data, int sz)
>>  {
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>> @@ -554,7 +554,7 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
>>  }
>>  
>>  static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -			       u8 offset, void *data, int sz)
>> +			       u16 offset, void *data, int sz)
>>  {
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>> @@ -638,15 +638,17 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
>>  {
>>  	int ret;
>>  	size_t size;
>> -	u8 pos, next;
>> +	u16 pos, next;
>>  	struct pci_cap_hdr *cap;
>> -	u8 virt_hdr[PCI_DEV_CFG_SIZE];
>> +	u8 *virt_hdr;
>>  	struct vfio_pci_device *pdev = &vdev->pci;
>>  
>>  	if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
>>  		return 0;
>>  
>> -	memset(virt_hdr, 0, PCI_DEV_CFG_SIZE);
>> +	virt_hdr = calloc(1, PCI_DEV_CFG_SIZE);
>> +	if (!virt_hdr)
>> +		return -errno;
> There are two places where we return in this function, we don't seem to
> free virt_hdr in those cases. Looks like a job for your beloved goto ;-)
>
Indeed, I'll do that.

Thanks,
Alex
