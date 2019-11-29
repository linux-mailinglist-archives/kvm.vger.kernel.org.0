Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C6A10D8C8
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 18:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfK2RFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 12:05:38 -0500
Received: from foss.arm.com ([217.140.110.172]:50198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfK2RFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 12:05:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7471FB;
        Fri, 29 Nov 2019 09:05:37 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB6943F68E;
        Fri, 29 Nov 2019 09:05:36 -0800 (PST)
Subject: Re: [PATCH kvmtool 13/16] vfio: Add support for BAR configuration
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
 <20191125103033.22694-14-alexandru.elisei@arm.com>
Message-ID: <97d8c250-6546-bdda-bd89-8980a111dc8e@arm.com>
Date:   Fri, 29 Nov 2019 17:05:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125103033.22694-14-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/25/19 10:30 AM, Alexandru Elisei wrote:
> From: Julien Thierry <julien.thierry@arm.com>
>
> When a guest can reassign BARs, kvmtool needs to maintain the vfio_region
> consistent with their corresponding BARs. Take the new updated addresses
> from the PCI header read back from the vfio driver.
>
> Also, to modify the BARs, it is expected that guests will disable
> IO/Memory response in the PCI command. Support this by mapping/unmapping
> regions when the corresponding response gets enabled/disabled.
>
> Cc: julien.thierry.kdev@gmail.com
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> [Fixed BAR selection]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  vfio/core.c |  8 ++---
>  vfio/pci.c  | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 87 insertions(+), 9 deletions(-)

I've finally had the chance to do more testing for PCI passthrough, and this patch
is pretty broken, so far I've found that: kvmtool does trap-and-emulate for the
BAR(s) dedicated to the MSI-X table and MSI-X PBA structure, and we don't take
that into account; vfio_unmap_region doesn't destroy the memslot; when the guest
enables memory or I/O accesses, we call vfio_map_region for all 6 BARs, even
though some of them might be unimplemented (their value is 0).

Thanks,
Alex
> diff --git a/vfio/core.c b/vfio/core.c
> index 0ed1e6fee6bf..b554897fc8c1 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -202,14 +202,13 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
>  				  struct vfio_region *region)
>  {
>  	if (region->is_ioport) {
> -		int port = pci_get_io_port_block(region->info.size);
> +		int port = ioport__register(kvm, region->port_base,
> +					    &vfio_ioport_ops,
> +					    region->info.size, region);
>  
> -		port = ioport__register(kvm, port, &vfio_ioport_ops,
> -					region->info.size, region);
>  		if (port < 0)
>  			return port;
>  
> -		region->port_base = port;
>  		return 0;
>  	}
>  
> @@ -258,6 +257,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  {
>  	if (region->host_addr) {
>  		munmap(region->host_addr, region->info.size);
> +		region->host_addr = NULL;
>  	} else if (region->is_ioport) {
>  		ioport__unregister(kvm, region->port_base);
>  	} else {
> diff --git a/vfio/pci.c b/vfio/pci.c
> index bc5a6d452f7a..28f895c06b27 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -1,3 +1,4 @@
> +#include "kvm/ioport.h"
>  #include "kvm/irq.h"
>  #include "kvm/kvm.h"
>  #include "kvm/kvm-cpu.h"
> @@ -464,6 +465,67 @@ static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr
>  			      sz, offset);
>  }
>  
> +static void vfio_pci_cfg_handle_command(struct kvm *kvm, struct vfio_device *vdev,
> +					void *data, int sz)
> +{
> +	struct pci_device_header *hdr = &vdev->pci.hdr;
> +	bool toggle_io;
> +	bool toggle_mem;
> +	u16 cmd;
> +	int i;
> +
> +	cmd = ioport__read16(data);
> +	toggle_io = !!((cmd ^ hdr->command) & PCI_COMMAND_IO);
> +	toggle_mem = !!((cmd ^ hdr->command) & PCI_COMMAND_MEMORY);
> +
> +	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
> +		struct vfio_region *region = &vdev->regions[i];
> +
> +		if (region->is_ioport && toggle_io) {
> +			if (cmd & PCI_COMMAND_IO)
> +				vfio_map_region(kvm, vdev, region);
> +			else
> +				vfio_unmap_region(kvm, region);
> +		}
> +
> +		if (!region->is_ioport && toggle_mem) {
> +			if (cmd & PCI_COMMAND_MEMORY)
> +				vfio_map_region(kvm, vdev, region);
> +			else
> +				vfio_unmap_region(kvm, region);
> +		}
> +	}
> +}
> +
> +static void vfio_pci_cfg_update_bar(struct kvm *kvm, struct vfio_device *vdev,
> +				    int bar_num, void *data, int sz)
> +{
> +	struct pci_device_header *hdr = &vdev->pci.hdr;
> +	struct vfio_region *region;
> +	uint32_t bar;
> +
> +	region = &vdev->regions[bar_num + VFIO_PCI_BAR0_REGION_INDEX];
> +	bar = ioport__read32(data);
> +
> +	if (region->is_ioport) {
> +		if (hdr->command & PCI_COMMAND_IO)
> +			vfio_unmap_region(kvm, region);
> +
> +		region->port_base = bar & PCI_BASE_ADDRESS_IO_MASK;
> +
> +		if (hdr->command & PCI_COMMAND_IO)
> +			vfio_map_region(kvm, vdev, region);
> +	} else {
> +		if (hdr->command & PCI_COMMAND_MEMORY)
> +			vfio_unmap_region(kvm, region);
> +
> +		region->guest_phys_addr = bar & PCI_BASE_ADDRESS_MEM_MASK;
> +
> +		if (hdr->command & PCI_COMMAND_MEMORY)
> +			vfio_map_region(kvm, vdev, region);
> +	}
> +}
> +
>  static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
>  			       u8 offset, void *data, int sz)
>  {
> @@ -471,6 +533,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	struct vfio_pci_device *pdev;
>  	struct vfio_device *vdev;
>  	void *base = pci_hdr;
> +	int bar_num;
>  
>  	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
>  	vdev = container_of(pdev, struct vfio_device, pci);
> @@ -487,9 +550,17 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
>  		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
>  
> +	if (offset == PCI_COMMAND)
> +		vfio_pci_cfg_handle_command(kvm, vdev, data, sz);
> +
>  	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
>  		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
>  			      sz, offset);
> +
> +	if (offset >= PCI_BASE_ADDRESS_0 && offset <= PCI_BASE_ADDRESS_5) {
> +		bar_num = (offset - PCI_BASE_ADDRESS_0) / sizeof(u32);
> +		vfio_pci_cfg_update_bar(kvm, vdev, bar_num, data, sz);
> +	}
>  }
>  
>  static ssize_t vfio_pci_msi_cap_size(struct msi_cap_64 *cap_hdr)
> @@ -808,6 +879,7 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  	size_t map_size;
>  	struct vfio_pci_device *pdev = &vdev->pci;
>  	struct vfio_region *region = &vdev->regions[nr];
> +	bool map_now;
>  
>  	if (nr >= vdev->info.num_regions)
>  		return 0;
> @@ -848,16 +920,22 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  		}
>  	}
>  
> -	if (!region->is_ioport) {
> +	if (region->is_ioport) {
> +		region->port_base = pci_get_io_port_block(region->info.size);
> +		map_now = !!(pdev->hdr.command & PCI_COMMAND_IO);
> +	} else {
>  		/* Grab some MMIO space in the guest */
>  		map_size = ALIGN(region->info.size, PAGE_SIZE);
>  		region->guest_phys_addr = pci_get_mmio_block(map_size);
> +		map_now = !!(pdev->hdr.command & PCI_COMMAND_MEMORY);
>  	}
>  
> -	/* Map the BARs into the guest or setup a trap region. */
> -	ret = vfio_map_region(kvm, vdev, region);
> -	if (ret)
> -		return ret;
> +	if (map_now) {
> +		/* Map the BARs into the guest or setup a trap region. */
> +		ret = vfio_map_region(kvm, vdev, region);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	return 0;
>  }
