Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62528155C78
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgBGRCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:02:46 -0500
Received: from foss.arm.com ([217.140.110.172]:42234 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgBGRCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:02:46 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 275571FB;
        Fri,  7 Feb 2020 09:02:45 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AF483F68E;
        Fri,  7 Feb 2020 09:02:43 -0800 (PST)
Date:   Fri, 7 Feb 2020 17:02:39 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v2 kvmtool 07/30] ioport: pci: Move port allocations to
 PCI devices
Message-ID: <20200207170239.67eabb9d@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-8-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-8-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:42 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> From: Julien Thierry <julien.thierry@arm.com>
> 
> The dynamic ioport allocation with IOPORT_EMPTY is currently only used
> by PCI devices. Other devices use fixed ports for which they request
> registration to the ioport API.
> 
> PCI ports need to be in the PCI IO space and there is no reason ioport
> API should know a PCI port is being allocated and needs to be placed in
> PCI IO space. This currently just happens to be the case.
> 
> Move the responsability of dynamic allocation of ioports from the ioport
> API to PCI.
> 
> In the future, if other types of devices also need dynamic ioport
> allocation, they'll have to figure out the range of ports they are
> allowed to use.
> 
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> [Renamed functions for clarity]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I replied to the wrong series version of this patch before, so for the sake for completeness, here on the right thread:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/vesa.c                      |  4 ++--
>  include/kvm/ioport.h           |  3 ---
>  include/kvm/pci.h              |  4 +++-
>  ioport.c                       | 18 ------------------
>  pci.c                          | 17 +++++++++++++----
>  powerpc/include/kvm/kvm-arch.h |  2 +-
>  vfio/core.c                    |  6 ++++--
>  vfio/pci.c                     |  4 ++--
>  virtio/pci.c                   |  7 ++++---
>  x86/include/kvm/kvm-arch.h     |  2 +-
>  10 files changed, 30 insertions(+), 37 deletions(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index d75b4b316a1e..24fb46faad3b 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -63,8 +63,8 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  
>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>  		return NULL;
> -
> -	r = ioport__register(kvm, IOPORT_EMPTY, &vesa_io_ops, IOPORT_SIZE, NULL);
> +	r = pci_get_io_port_block(IOPORT_SIZE);
> +	r = ioport__register(kvm, r, &vesa_io_ops, IOPORT_SIZE, NULL);
>  	if (r < 0)
>  		return ERR_PTR(r);
>  
> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> index db52a479742b..b10fcd5b4412 100644
> --- a/include/kvm/ioport.h
> +++ b/include/kvm/ioport.h
> @@ -14,11 +14,8 @@
>  
>  /* some ports we reserve for own use */
>  #define IOPORT_DBG			0xe0
> -#define IOPORT_START			0x6200
>  #define IOPORT_SIZE			0x400
>  
> -#define IOPORT_EMPTY			USHRT_MAX
> -
>  struct kvm;
>  
>  struct ioport {
> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
> index a86c15a70e6d..ccb155e3e8fe 100644
> --- a/include/kvm/pci.h
> +++ b/include/kvm/pci.h
> @@ -19,6 +19,7 @@
>  #define PCI_CONFIG_DATA		0xcfc
>  #define PCI_CONFIG_BUS_FORWARD	0xcfa
>  #define PCI_IO_SIZE		0x100
> +#define PCI_IOPORT_START	0x6200
>  #define PCI_CFG_SIZE		(1ULL << 24)
>  
>  struct kvm;
> @@ -152,7 +153,8 @@ struct pci_device_header {
>  int pci__init(struct kvm *kvm);
>  int pci__exit(struct kvm *kvm);
>  struct pci_device_header *pci__find_dev(u8 dev_num);
> -u32 pci_get_io_space_block(u32 size);
> +u32 pci_get_mmio_block(u32 size);
> +u16 pci_get_io_port_block(u32 size);
>  void pci__assign_irq(struct device_header *dev_hdr);
>  void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
>  void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
> diff --git a/ioport.c b/ioport.c
> index a6dc65e3e6c6..a72e4035881a 100644
> --- a/ioport.c
> +++ b/ioport.c
> @@ -16,24 +16,8 @@
>  
>  #define ioport_node(n) rb_entry(n, struct ioport, node)
>  
> -DEFINE_MUTEX(ioport_mutex);
> -
> -static u16			free_io_port_idx; /* protected by ioport_mutex */
> -
>  static struct rb_root		ioport_tree = RB_ROOT;
>  
> -static u16 ioport__find_free_port(void)
> -{
> -	u16 free_port;
> -
> -	mutex_lock(&ioport_mutex);
> -	free_port = IOPORT_START + free_io_port_idx * IOPORT_SIZE;
> -	free_io_port_idx++;
> -	mutex_unlock(&ioport_mutex);
> -
> -	return free_port;
> -}
> -
>  static struct ioport *ioport_search(struct rb_root *root, u64 addr)
>  {
>  	struct rb_int_node *node;
> @@ -85,8 +69,6 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
>  	int r;
>  
>  	br_write_lock(kvm);
> -	if (port == IOPORT_EMPTY)
> -		port = ioport__find_free_port();
>  
>  	entry = ioport_search(&ioport_tree, port);
>  	if (entry) {
> diff --git a/pci.c b/pci.c
> index 3198732935eb..80b5c5d3d7f3 100644
> --- a/pci.c
> +++ b/pci.c
> @@ -15,15 +15,24 @@ static u32 pci_config_address_bits;
>   * (That's why it can still 32bit even with 64bit guests-- 64bit
>   * PCI isn't currently supported.)
>   */
> -static u32 io_space_blocks		= KVM_PCI_MMIO_AREA;
> +static u32 mmio_blocks			= KVM_PCI_MMIO_AREA;
> +static u16 io_port_blocks		= PCI_IOPORT_START;
> +
> +u16 pci_get_io_port_block(u32 size)
> +{
> +	u16 port = ALIGN(io_port_blocks, IOPORT_SIZE);
> +
> +	io_port_blocks = port + size;
> +	return port;
> +}
>  
>  /*
>   * BARs must be naturally aligned, so enforce this in the allocator.
>   */
> -u32 pci_get_io_space_block(u32 size)
> +u32 pci_get_mmio_block(u32 size)
>  {
> -	u32 block = ALIGN(io_space_blocks, size);
> -	io_space_blocks = block + size;
> +	u32 block = ALIGN(mmio_blocks, size);
> +	mmio_blocks = block + size;
>  	return block;
>  }
>  
> diff --git a/powerpc/include/kvm/kvm-arch.h b/powerpc/include/kvm/kvm-arch.h
> index 8126b96cb66a..26d440b22bdd 100644
> --- a/powerpc/include/kvm/kvm-arch.h
> +++ b/powerpc/include/kvm/kvm-arch.h
> @@ -34,7 +34,7 @@
>  #define KVM_MMIO_START			PPC_MMIO_START
>  
>  /*
> - * This is the address that pci_get_io_space_block() starts allocating
> + * This is the address that pci_get_io_port_block() starts allocating
>   * from.  Note that this is a PCI bus address.
>   */
>  #define KVM_IOPORT_AREA			0x0
> diff --git a/vfio/core.c b/vfio/core.c
> index 17b5b0cfc9ac..0ed1e6fee6bf 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -202,8 +202,10 @@ static int vfio_setup_trap_region(struct kvm *kvm, struct vfio_device *vdev,
>  				  struct vfio_region *region)
>  {
>  	if (region->is_ioport) {
> -		int port = ioport__register(kvm, IOPORT_EMPTY, &vfio_ioport_ops,
> -					    region->info.size, region);
> +		int port = pci_get_io_port_block(region->info.size);
> +
> +		port = ioport__register(kvm, port, &vfio_ioport_ops,
> +					region->info.size, region);
>  		if (port < 0)
>  			return port;
>  
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 76e24c156906..8e5d8572bc0c 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -750,7 +750,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm,
>  	 * powers of two.
>  	 */
>  	mmio_size = roundup_pow_of_two(table->size + pba->size);
> -	table->guest_phys_addr = pci_get_io_space_block(mmio_size);
> +	table->guest_phys_addr = pci_get_mmio_block(mmio_size);
>  	if (!table->guest_phys_addr) {
>  		pr_err("cannot allocate IO space");
>  		ret = -ENOMEM;
> @@ -846,7 +846,7 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  	if (!region->is_ioport) {
>  		/* Grab some MMIO space in the guest */
>  		map_size = ALIGN(region->info.size, PAGE_SIZE);
> -		region->guest_phys_addr = pci_get_io_space_block(map_size);
> +		region->guest_phys_addr = pci_get_mmio_block(map_size);
>  	}
>  
>  	/* Map the BARs into the guest or setup a trap region. */
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 04e801827df9..d73414abde05 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -438,18 +438,19 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
>  	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
>  
> -	r = ioport__register(kvm, IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
> +	r = pci_get_io_port_block(IOPORT_SIZE);
> +	r = ioport__register(kvm, r, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
>  	if (r < 0)
>  		return r;
>  	vpci->port_addr = (u16)r;
>  
> -	vpci->mmio_addr = pci_get_io_space_block(IOPORT_SIZE);
> +	vpci->mmio_addr = pci_get_mmio_block(IOPORT_SIZE);
>  	r = kvm__register_mmio(kvm, vpci->mmio_addr, IOPORT_SIZE, false,
>  			       virtio_pci__io_mmio_callback, vpci);
>  	if (r < 0)
>  		goto free_ioport;
>  
> -	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE * 2);
> +	vpci->msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
>  	r = kvm__register_mmio(kvm, vpci->msix_io_block, PCI_IO_SIZE * 2, false,
>  			       virtio_pci__msix_mmio_callback, vpci);
>  	if (r < 0)
> diff --git a/x86/include/kvm/kvm-arch.h b/x86/include/kvm/kvm-arch.h
> index bfdd3438a9de..85cd336c7577 100644
> --- a/x86/include/kvm/kvm-arch.h
> +++ b/x86/include/kvm/kvm-arch.h
> @@ -16,7 +16,7 @@
>  
>  #define KVM_MMIO_START		KVM_32BIT_GAP_START
>  
> -/* This is the address that pci_get_io_space_block() starts allocating
> +/* This is the address that pci_get_io_port_block() starts allocating
>   * from.  Note that this is a PCI bus address (though same on x86).
>   */
>  #define KVM_IOPORT_AREA		0x0

