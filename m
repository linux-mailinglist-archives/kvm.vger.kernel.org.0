Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56B614BFA8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgA1S05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:26:57 -0500
Received: from foss.arm.com ([217.140.110.172]:33450 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgA1S0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 13:26:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68849328;
        Tue, 28 Jan 2020 10:26:54 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D9FF3F52E;
        Tue, 28 Jan 2020 10:26:53 -0800 (PST)
Date:   Tue, 28 Jan 2020 18:26:50 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: Re: [PATCH kvmtool 07/16] pci: Fix ioport allocation size
Message-ID: <20200128182650.12b4430b@donnerap.cambridge.arm.com>
In-Reply-To: <20191125103033.22694-8-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
        <20191125103033.22694-8-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Nov 2019 10:30:24 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Julien Thierry <julien.thierry@arm.com>
> 
> The PCI Local Bus Specification, Rev. 3.0, Section 6.2.5.1. "Address Maps"
> states: "Devices that map control functions into I/O Space must not consume
> more than 256 bytes per I/O Base Address register."
> 
> Yet all the PCI devices allocate IO ports of IOPORT_SIZE (= 1024 bytes).
> 
> Fix this by having PCI devices use 256 bytes ports for IO BARs.
> 
> There is no hard requirement on the size of the memory region described
> by memory BARs. However, the region must be big enough to hold the
> virtio common interface described in [1], which is 20 bytes, and other
> MSI-X and/or device specific configuration. To be consistent, let's also
> limit the memory region described by BAR1 to 256. This is the same size
> used by BAR2 for each of the two MSI-X vectors.

So the I/O port size is surely fine, QEMU seems to get away with 64 or even 32 bytes.
But QEMU also reports a memory region size of 4K, is that something we need to consider?
 
> [1] VIRTIO Version 1.0 Committee Specification 04, section 4.4.8.

I think that should read section 4.1.4.8.

The rest looks OK.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> Cc: julien.thierry.kdev@gmail.com
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> [Added rationale for changing BAR1 size to PCI_IO_SIZE]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  hw/vesa.c            |  4 ++--
>  include/kvm/ioport.h |  1 -
>  pci.c                |  2 +-
>  virtio/pci.c         | 15 +++++++--------
>  4 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index 70ab59974f76..0191e9264666 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -62,8 +62,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>  		return NULL;
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &vesa_io_ops, PCI_IO_SIZE, NULL);
>  	if (r < 0)
>  		return ERR_PTR(r);
>  
> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> index b10fcd5b4412..8c86b7151f25 100644
> --- a/include/kvm/ioport.h
> +++ b/include/kvm/ioport.h
> @@ -14,7 +14,6 @@
>  
>  /* some ports we reserve for own use */
>  #define IOPORT_DBG			0xe0
> -#define IOPORT_SIZE			0x400
>  
>  struct kvm;
>  
> diff --git a/pci.c b/pci.c
> index 32a07335a765..b4677434c50c 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -20,7 +20,7 @@ static u16 io_port_blocks		= PCI_IOPORT_START;
>  
>  u16 pci_get_io_port_block(u32 size)
>  {
> -	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
> +	u16 port = ALIGN(io_port_blocks, PCI_IO_SIZE);
>  
>  	io_port_blocks = port + size;
>  	return port;
> diff --git a/virtio/pci.c b/virtio/pci.c
> index d73414abde05..eeb5b5efa6e1 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -421,7 +421,7 @@ static void virtio_pci__io_mmio_callback(struct kvm_cpu *vcpu,
>  {
>  	struct virtio_pci *vpci = ptr;
>  	int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> -	u16 port = vpci->port_addr + (addr & (IOPORT_SIZE - 1));
> +	u16 port = vpci->port_addr + (addr & (PCI_IO_SIZE - 1));
>  
>  	kvm__emulate_io(vcpu, port, data, direction, len, 1);
>  }
> @@ -435,17 +435,16 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->kvm = kvm;
>  	vpci->dev = dev;
>  
> -	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>  
> -	r = pci_get_io_port_block(IOPORT_SIZE);
> -	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
> +	r = pci_get_io_port_block(PCI_IO_SIZE);
> +	r = ioport__register(kvm, r, &virtio_pci__io_ops, PCI_IO_SIZE, vdev);
>  	if (r < 0)
>  		return r;
>  	vpci->port_addr = (u16)r;
>  
> -	vpci->mmio_addr = pci_get_mmio_block(IOPORT_SIZE);
> -	r = kvm__register_mmio(kvm, vpci->mmio_addr, IOPORT_SIZE, false,
> +	vpci->mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
> +	r = kvm__register_mmio(kvm, vpci->mmio_addr, PCI_IO_SIZE, false,
>  			       virtio_pci__io_mmio_callback, vpci);
>  	if (r < 0)
>  		goto free_ioport;
> @@ -475,8 +474,8 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  							| PCI_BASE_ADDRESS_SPACE_MEMORY),
>  		.status			= cpu_to_le16(PCI_STATUS_CAP_LIST),
>  		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
> -		.bar_size[0]		= cpu_to_le32(IOPORT_SIZE),
> -		.bar_size[1]		= cpu_to_le32(IOPORT_SIZE),
> +		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
> +		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
>  		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
>  	};
>  

