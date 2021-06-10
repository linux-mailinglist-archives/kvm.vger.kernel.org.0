Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320113A3129
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhFJQp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 12:45:26 -0400
Received: from foss.arm.com ([217.140.110.172]:36544 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231747AbhFJQpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 12:45:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8ABDDED1;
        Thu, 10 Jun 2021 09:43:09 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EC833F719;
        Thu, 10 Jun 2021 09:43:08 -0700 (PDT)
Subject: Re: [PATCH kvmtool 3/4] arm/arm64: Add PCI Express 1.1 support
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20210609183812.29596-1-alexandru.elisei@arm.com>
 <20210609183812.29596-4-alexandru.elisei@arm.com>
 <20210610171414.6006a963@slackpad.fritz.box>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e659c617-7e85-a048-9d5c-258d3b3a9b4a@arm.com>
Date:   Thu, 10 Jun 2021 17:44:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610171414.6006a963@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 6/10/21 5:14 PM, Andre Przywara wrote:
> On Wed,  9 Jun 2021 19:38:11 +0100
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
>> opted to omit the mandatory PCI Express capabilities. For VFIO, the power
>> management and PCI Express capability are left for a subsequent patch.
>>
>> [1] PCI Express Base Specification Revision 1.1, section 7.6
>> [2] PCI Express Base Specification Revision 1.1, section 7.8
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/include/arm-common/kvm-arch.h |  4 ++-
>>  arm/pci.c                         |  2 +-
>>  include/kvm/pci.h                 | 51 ++++++++++++++++++++++++++++---
>>  pci.c                             |  5 +--
>>  vfio/pci.c                        | 26 ++++++++++------
>>  5 files changed, 70 insertions(+), 18 deletions(-)
>>
>> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
>> index 436b67b843fc..c645ac001bca 100644
>> --- a/arm/include/arm-common/kvm-arch.h
>> +++ b/arm/include/arm-common/kvm-arch.h
>> @@ -49,7 +49,7 @@
>>  
>>  
>>  #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
>> -#define ARM_PCI_CFG_SIZE	(1ULL << 24)
>> +#define ARM_PCI_CFG_SIZE	(1ULL << 28)
>>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
>>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
>>  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
>> @@ -77,6 +77,8 @@
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
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index bf81323d83b7..42d9e1c5645f 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -10,6 +10,7 @@
>>  #include "kvm/devices.h"
>>  #include "kvm/msi.h"
>>  #include "kvm/fdt.h"
>> +#include "kvm/kvm-arch.h"
>>  
>>  #define pci_dev_err(pci_hdr, fmt, ...) \
>>  	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
>> @@ -32,10 +33,49 @@
>>  #define PCI_CONFIG_BUS_FORWARD	0xcfa
>>  #define PCI_IO_SIZE		0x100
>>  #define PCI_IOPORT_START	0x6200
>> -#define PCI_CFG_SIZE		(1ULL << 24)
>>  
>>  struct kvm;
>>  
>> +/*
>> + * On some distributions, pci_regs.h doesn't define PCI_CFG_SPACE_SIZE and
>> + * PCI_CFG_SPACE_EXP_SIZE, so we define our own.
>> + */
>> +#define PCI_CFG_SIZE_LEGACY		(1ULL << 24)
>> +#define PCI_DEV_CFG_SIZE_LEGACY		256
>> +#define PCI_CFG_SIZE_EXTENDED		(1ULL << 28)
>> +#define PCI_DEV_CFG_SIZE_EXTENDED 	4096
> Do we need the size right now? If not, we can use
> #define PCI_DEV_CFG_SIZE  (PCI_CFG_SIZE << 16) down below?
> To make it more obvious where this comes from?

I put it there because we need PCI_DEV_CFG_SIZE_LEGACY in the vfio code, and it
looked strangely asymmetrical to have the legacy size but not the extended size.
Unless there's something I'm misinterpreting about your comment.

Thanks,

Alex

>
> The rest looks alright, thanks for addressing the comments from last
> year ;-)
>
> Cheers,
> Andre
>
>
>> +
>> +#ifdef ARCH_HAS_PCI_EXP
>> +#define PCI_CFG_SIZE		PCI_CFG_SIZE_EXTENDED
>> +#define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_EXTENDED
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
>> +	};
>> +	u32 w;
>> +};
>> +
>> +#else
>> +#define PCI_CFG_SIZE		PCI_CFG_SIZE_LEGACY
>> +#define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_LEGACY
>> +
>>  union pci_config_address {
>>  	struct {
>>  #if __BYTE_ORDER == __LITTLE_ENDIAN
>> @@ -58,6 +98,9 @@ union pci_config_address {
>>  	};
>>  	u32 w;
>>  };
>> +#endif /* ARCH_HAS_PCI_EXP */
>> +
>> +#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
>>  
>>  struct msix_table {
>>  	struct msi_msg msg;
>> @@ -110,14 +153,12 @@ typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
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
>> diff --git a/pci.c b/pci.c
>> index d6da79e0a56a..e593033164c1 100644
>> --- a/pci.c
>> +++ b/pci.c
>> @@ -353,7 +353,8 @@ static void pci_config_bar_wr(struct kvm *kvm,
>>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>  {
>>  	void *base;
>> -	u8 bar, offset;
>> +	u8 bar;
>> +	u16 offset;
>>  	struct pci_device_header *pci_hdr;
>>  	u8 dev_num = addr.device_number;
>>  	u32 value = 0;
>> @@ -392,7 +393,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
>>  
>>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
>>  {
>> -	u8 offset;
>> +	u16 offset;
>>  	struct pci_device_header *pci_hdr;
>>  	u8 dev_num = addr.device_number;
>>  
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index 49ecd12a38cd..6a4204634e71 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -313,7 +313,7 @@ out_unlock:
>>  }
>>  
>>  static void vfio_pci_msix_cap_write(struct kvm *kvm,
>> -				    struct vfio_device *vdev, u8 off,
>> +				    struct vfio_device *vdev, u16 off,
>>  				    void *data, int sz)
>>  {
>>  	struct vfio_pci_device *pdev = &vdev->pci;
>> @@ -345,7 +345,7 @@ static void vfio_pci_msix_cap_write(struct kvm *kvm,
>>  }
>>  
>>  static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
>> -				     u8 off, u8 *data, u32 sz)
>> +				     u16 off, u8 *data, u32 sz)
>>  {
>>  	size_t i;
>>  	u32 mask = 0;
>> @@ -393,7 +393,7 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
>>  }
>>  
>>  static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
>> -				   u8 off, u8 *data, u32 sz)
>> +				   u16 off, u8 *data, u32 sz)
>>  {
>>  	u8 ctrl;
>>  	struct msi_msg msg;
>> @@ -553,7 +553,7 @@ out:
>>  }
>>  
>>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -			      u8 offset, void *data, int sz)
>> +			      u16 offset, void *data, int sz)
>>  {
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>> @@ -571,7 +571,7 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
>>  }
>>  
>>  static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>> -			       u8 offset, void *data, int sz)
>> +			       u16 offset, void *data, int sz)
>>  {
>>  	struct vfio_region_info *info;
>>  	struct vfio_pci_device *pdev;
>> @@ -658,15 +658,17 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
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
>> +		return -ENOMEM;
>>  
>>  	pos = pdev->hdr.capabilities & ~3;
>>  
>> @@ -702,6 +704,8 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
>>  	size = PCI_DEV_CFG_SIZE - PCI_STD_HEADER_SIZEOF;
>>  	memcpy((void *)&pdev->hdr + pos, virt_hdr + pos, size);
>>  
>> +	free(virt_hdr);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -812,7 +816,11 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>>  
>>  	/* Install our fake Configuration Space */
>>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>> -	hdr_sz = PCI_DEV_CFG_SIZE;
>> +	/*
>> +	 * We don't touch the extended configuration space, let's be cautious
>> +	 * and not overwrite it all with zeros, or bad things might happen.
>> +	 */
>> +	hdr_sz = PCI_DEV_CFG_SIZE_LEGACY;
>>  	if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) != hdr_sz) {
>>  		vfio_dev_err(vdev, "failed to write %zd bytes to Config Space",
>>  			     hdr_sz);
