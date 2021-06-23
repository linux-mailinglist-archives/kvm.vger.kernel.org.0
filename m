Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078E93B17C5
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 12:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhFWKIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 06:08:40 -0400
Received: from foss.arm.com ([217.140.110.172]:33154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230212AbhFWKIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 06:08:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB91A31B;
        Wed, 23 Jun 2021 03:06:22 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D69A3F719;
        Wed, 23 Jun 2021 03:06:21 -0700 (PDT)
Date:   Wed, 23 Jun 2021 11:06:01 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org, pierre.gondois@arm.com
Subject: Re: [PATCH v2 kvmtool 3/4] arm/arm64: Add PCI Express 1.1 support
Message-ID: <20210623110601.76413625@slackpad.fritz.box>
In-Reply-To: <1c2dbb75-f37a-677e-cac8-15f37299587e@arm.com>
References: <20210621092128.11313-1-alexandru.elisei@arm.com>
        <20210621092128.11313-4-alexandru.elisei@arm.com>
        <20210621150421.6f1c7e7c@slackpad.fritz.box>
        <1c2dbb75-f37a-677e-cac8-15f37299587e@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Jun 2021 10:32:49 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> On 6/21/21 3:04 PM, Andre Przywara wrote:
> > On Mon, 21 Jun 2021 10:21:27 +0100
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >  
> >> PCI Express comes with an extended addressing scheme, which directly
> >> translated into a bigger device configuration space (256->4096 bytes)
> >> and bigger PCI configuration space (16->256 MB), as well as mandatory
> >> capabilities (power management [1] and PCI Express capability [2]).
> >>
> >> However, our virtio PCI implementation implements version 0.9 of the
> >> protocol and it still uses transitional PCI device ID's, so we have
> >> opted to omit the mandatory PCI Express capabilities. For VFIO, the power
> >> management and PCI Express capability are left for a subsequent patch.
> >>
> >> [1] PCI Express Base Specification Revision 1.1, section 7.6
> >> [2] PCI Express Base Specification Revision 1.1, section 7.8
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>  
> > Sorry, one thing I missed on the first review:
> >  
> >> ---
> >>  arm/include/arm-common/kvm-arch.h |  4 ++-
> >>  arm/pci.c                         |  2 +-
> >>  include/kvm/pci.h                 | 51 ++++++++++++++++++++++++++++---
> >>  pci.c                             |  5 +--
> >>  vfio/pci.c                        | 26 ++++++++++------
> >>  5 files changed, 70 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
> >> index 436b67b843fc..c645ac001bca 100644
> >> --- a/arm/include/arm-common/kvm-arch.h
> >> +++ b/arm/include/arm-common/kvm-arch.h
> >> @@ -49,7 +49,7 @@
> >>  
> >>  
> >>  #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
> >> -#define ARM_PCI_CFG_SIZE	(1ULL << 24)
> >> +#define ARM_PCI_CFG_SIZE	(1ULL << 28)
> >>  #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
> >>  #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
> >>  				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
> >> @@ -77,6 +77,8 @@
> >>  
> >>  #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
> >>  
> >> +#define ARCH_HAS_PCI_EXP	1
> >> +
> >>  static inline bool arm_addr_in_ioport_region(u64 phys_addr)
> >>  {
> >>  	u64 limit = KVM_IOPORT_AREA + ARM_IOPORT_SIZE;
> >> diff --git a/arm/pci.c b/arm/pci.c
> >> index ed325fa4a811..2251f627d8b5 100644
> >> --- a/arm/pci.c
> >> +++ b/arm/pci.c
> >> @@ -62,7 +62,7 @@ void pci__generate_fdt_nodes(void *fdt)
> >>  	_FDT(fdt_property_cell(fdt, "#address-cells", 0x3));
> >>  	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
> >>  	_FDT(fdt_property_cell(fdt, "#interrupt-cells", 0x1));
> >> -	_FDT(fdt_property_string(fdt, "compatible", "pci-host-cam-generic"));
> >> +	_FDT(fdt_property_string(fdt, "compatible", "pci-host-ecam-generic"));
> >>  	_FDT(fdt_property(fdt, "dma-coherent", NULL, 0));
> >>  
> >>  	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
> >> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> >> index bf81323d83b7..42d9e1c5645f 100644
> >> --- a/include/kvm/pci.h
> >> +++ b/include/kvm/pci.h
> >> @@ -10,6 +10,7 @@
> >>  #include "kvm/devices.h"
> >>  #include "kvm/msi.h"
> >>  #include "kvm/fdt.h"
> >> +#include "kvm/kvm-arch.h"
> >>  
> >>  #define pci_dev_err(pci_hdr, fmt, ...) \
> >>  	pr_err("[%04x:%04x] " fmt, pci_hdr->vendor_id, pci_hdr->device_id, ##__VA_ARGS__)
> >> @@ -32,10 +33,49 @@
> >>  #define PCI_CONFIG_BUS_FORWARD	0xcfa
> >>  #define PCI_IO_SIZE		0x100
> >>  #define PCI_IOPORT_START	0x6200
> >> -#define PCI_CFG_SIZE		(1ULL << 24)
> >>  
> >>  struct kvm;
> >>  
> >> +/*
> >> + * On some distributions, pci_regs.h doesn't define PCI_CFG_SPACE_SIZE and
> >> + * PCI_CFG_SPACE_EXP_SIZE, so we define our own.
> >> + */
> >> +#define PCI_CFG_SIZE_LEGACY		(1ULL << 24)
> >> +#define PCI_DEV_CFG_SIZE_LEGACY		256
> >> +#define PCI_CFG_SIZE_EXTENDED		(1ULL << 28)
> >> +#define PCI_DEV_CFG_SIZE_EXTENDED 	4096
> >> +
> >> +#ifdef ARCH_HAS_PCI_EXP
> >> +#define PCI_CFG_SIZE		PCI_CFG_SIZE_EXTENDED
> >> +#define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_EXTENDED
> >> +
> >> +union pci_config_address {
> >> +	struct {
> >> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> >> +		unsigned	reg_offset	: 2;		/* 1  .. 0  */
> >> +		unsigned	register_number	: 10;		/* 11 .. 2  */
> >> +		unsigned	function_number	: 3;		/* 14 .. 12 */
> >> +		unsigned	device_number	: 5;		/* 19 .. 15 */
> >> +		unsigned	bus_number	: 8;		/* 27 .. 20 */
> >> +		unsigned	reserved	: 3;		/* 30 .. 28 */
> >> +		unsigned	enable_bit	: 1;		/* 31       */
> >> +#else
> >> +		unsigned	enable_bit	: 1;		/* 31       */
> >> +		unsigned	reserved	: 3;		/* 30 .. 28 */
> >> +		unsigned	bus_number	: 8;		/* 27 .. 20 */
> >> +		unsigned	device_number	: 5;		/* 19 .. 15 */
> >> +		unsigned	function_number	: 3;		/* 14 .. 12 */
> >> +		unsigned	register_number	: 10;		/* 11 .. 2  */
> >> +		unsigned	reg_offset	: 2;		/* 1  .. 0  */
> >> +#endif
> >> +	};
> >> +	u32 w;
> >> +};
> >> +
> >> +#else
> >> +#define PCI_CFG_SIZE		PCI_CFG_SIZE_LEGACY
> >> +#define PCI_DEV_CFG_SIZE	PCI_DEV_CFG_SIZE_LEGACY
> >> +
> >>  union pci_config_address {
> >>  	struct {
> >>  #if __BYTE_ORDER == __LITTLE_ENDIAN
> >> @@ -58,6 +98,9 @@ union pci_config_address {
> >>  	};
> >>  	u32 w;
> >>  };
> >> +#endif /* ARCH_HAS_PCI_EXP */
> >> +
> >> +#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
> >>  
> >>  struct msix_table {
> >>  	struct msi_msg msg;
> >> @@ -110,14 +153,12 @@ typedef int (*bar_deactivate_fn_t)(struct kvm *kvm,
> >>  				   int bar_num, void *data);
> >>  
> >>  #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
> >> -#define PCI_DEV_CFG_SIZE	256
> >> -#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
> >>  
> >>  struct pci_config_operations {
> >>  	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
> >> -		      u8 offset, void *data, int sz);
> >> +		      u16 offset, void *data, int sz);
> >>  	void (*read)(struct kvm *kvm, struct pci_device_header *pci_hdr,
> >> -		     u8 offset, void *data, int sz);
> >> +		     u16 offset, void *data, int sz);
> >>  };
> >>  
> >>  struct pci_device_header {
> >> diff --git a/pci.c b/pci.c
> >> index d6da79e0a56a..e593033164c1 100644
> >> --- a/pci.c
> >> +++ b/pci.c
> >> @@ -353,7 +353,8 @@ static void pci_config_bar_wr(struct kvm *kvm,
> >>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
> >>  {
> >>  	void *base;
> >> -	u8 bar, offset;
> >> +	u8 bar;
> >> +	u16 offset;
> >>  	struct pci_device_header *pci_hdr;
> >>  	u8 dev_num = addr.device_number;
> >>  	u32 value = 0;
> >> @@ -392,7 +393,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
> >>  
> >>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
> >>  {
> >> -	u8 offset;
> >> +	u16 offset;
> >>  	struct pci_device_header *pci_hdr;
> >>  	u8 dev_num = addr.device_number;
> >>  
> >> diff --git a/vfio/pci.c b/vfio/pci.c
> >> index 49ecd12a38cd..6a4204634e71 100644
> >> --- a/vfio/pci.c
> >> +++ b/vfio/pci.c
> >> @@ -313,7 +313,7 @@ out_unlock:
> >>  }
> >>  
> >>  static void vfio_pci_msix_cap_write(struct kvm *kvm,
> >> -				    struct vfio_device *vdev, u8 off,
> >> +				    struct vfio_device *vdev, u16 off,
> >>  				    void *data, int sz)
> >>  {
> >>  	struct vfio_pci_device *pdev = &vdev->pci;
> >> @@ -345,7 +345,7 @@ static void vfio_pci_msix_cap_write(struct kvm *kvm,
> >>  }
> >>  
> >>  static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
> >> -				     u8 off, u8 *data, u32 sz)
> >> +				     u16 off, u8 *data, u32 sz)
> >>  {
> >>  	size_t i;
> >>  	u32 mask = 0;
> >> @@ -393,7 +393,7 @@ static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
> >>  }
> >>  
> >>  static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
> >> -				   u8 off, u8 *data, u32 sz)
> >> +				   u16 off, u8 *data, u32 sz)
> >>  {
> >>  	u8 ctrl;
> >>  	struct msi_msg msg;
> >> @@ -553,7 +553,7 @@ out:
> >>  }
> >>  
> >>  static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
> >> -			      u8 offset, void *data, int sz)
> >> +			      u16 offset, void *data, int sz)
> >>  {
> >>  	struct vfio_region_info *info;
> >>  	struct vfio_pci_device *pdev;
> >> @@ -571,7 +571,7 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
> >>  }
> >>  
> >>  static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
> >> -			       u8 offset, void *data, int sz)
> >> +			       u16 offset, void *data, int sz)
> >>  {
> >>  	struct vfio_region_info *info;
> >>  	struct vfio_pci_device *pdev;
> >> @@ -658,15 +658,17 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
> >>  {
> >>  	int ret;
> >>  	size_t size;
> >> -	u8 pos, next;
> >> +	u16 pos, next;
> >>  	struct pci_cap_hdr *cap;
> >> -	u8 virt_hdr[PCI_DEV_CFG_SIZE];
> >> +	u8 *virt_hdr;
> >>  	struct vfio_pci_device *pdev = &vdev->pci;
> >>  
> >>  	if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
> >>  		return 0;
> >>  
> >> -	memset(virt_hdr, 0, PCI_DEV_CFG_SIZE);
> >> +	virt_hdr = calloc(1, PCI_DEV_CFG_SIZE);
> >> +	if (!virt_hdr)
> >> +		return -ENOMEM;  
> > This will leak if the function returns with an error, due to
> > vfio_pci_add_cap() calls failing.
> > The easiest way out is probably initialising ret = 0 and using "goto
> > out;", I guess.  
> 
> I don't understand what you mean, can you elaborate?
> 
> From what I can tell, the function doesn't do any assignment before this point, so
> I don't know what will leak. vfio_pci_add_cap() calls are skipped entirely if the
> function returns early here, so I don't see how they can fail.

I meant you only free virt_hdr at the end of the function, if it
returns successfully. If if returns with an error from any of the
vfio_pci_add_cap() calls in the switch/case statement, the allocation
will never be freed.
Sorry if my wording was unclear!

Cheers,
Andre

> >>  	pos = pdev->hdr.capabilities & ~3;
> >>  
> >> @@ -702,6 +704,8 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
> >>  	size = PCI_DEV_CFG_SIZE - PCI_STD_HEADER_SIZEOF;
> >>  	memcpy((void *)&pdev->hdr + pos, virt_hdr + pos, size);
> >>  
> >> +	free(virt_hdr);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -812,7 +816,11 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
> >>  
> >>  	/* Install our fake Configuration Space */
> >>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
> >> -	hdr_sz = PCI_DEV_CFG_SIZE;
> >> +	/*
> >> +	 * We don't touch the extended configuration space, let's be cautious
> >> +	 * and not overwrite it all with zeros, or bad things might happen.
> >> +	 */
> >> +	hdr_sz = PCI_DEV_CFG_SIZE_LEGACY;
> >>  	if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) != hdr_sz) {
> >>  		vfio_dev_err(vdev, "failed to write %zd bytes to Config Space",
> >>  			     hdr_sz);  

