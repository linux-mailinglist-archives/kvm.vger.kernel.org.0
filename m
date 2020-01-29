Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC02914D03E
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgA2SQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 13:16:54 -0500
Received: from foss.arm.com ([217.140.110.172]:44524 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgA2SQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 13:16:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B917B328;
        Wed, 29 Jan 2020 10:16:53 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8ADF3F67D;
        Wed, 29 Jan 2020 10:16:52 -0800 (PST)
Date:   Wed, 29 Jan 2020 18:16:50 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 11/30] vfio/pci: Allocate correct size for
 MSIX table and PBA BARs
Message-ID: <20200129181650.5ce2669e@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-12-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-12-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:46 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> kvmtool assumes that the BAR that holds the address for the MSIX table
> and PBA structure has a size which is equal to their total size and it
> allocates memory from MMIO space accordingly.  However, when
> initializing the BARs, the BAR size is set to the region size reported
> by VFIO. When the physical BAR size is greater than the mmio space that
> kvmtool allocates, we can have a situation where the BAR overlaps with
> another BAR, in which case kvmtool will fail to map the memory. This was
> found when trying to do PCI passthrough with a PCIe Realtek r8168 NIC,
> when the guest was also using virtio-block and virtio-net devices:

Good catch!

> 
> [..]
> [    0.197926] PCI: OF: PROBE_ONLY enabled
> [    0.198454] pci-host-generic 40000000.pci: host bridge /pci ranges:
> [    0.199291] pci-host-generic 40000000.pci:    IO 0x00007000..0x0000ffff -> 0x00007000
> [    0.200331] pci-host-generic 40000000.pci:   MEM 0x41000000..0x7fffffff -> 0x41000000
> [    0.201480] pci-host-generic 40000000.pci: ECAM at [mem 0x40000000-0x40ffffff] for [bus 00]
> [    0.202635] pci-host-generic 40000000.pci: PCI host bridge to bus 0000:00
> [    0.203535] pci_bus 0000:00: root bus resource [bus 00]
> [    0.204227] pci_bus 0000:00: root bus resource [io  0x0000-0x8fff] (bus address [0x7000-0xffff])
> [    0.205483] pci_bus 0000:00: root bus resource [mem 0x41000000-0x7fffffff]
> [    0.206456] pci 0000:00:00.0: [10ec:8168] type 00 class 0x020000
> [    0.207399] pci 0000:00:00.0: reg 0x10: [io  0x0000-0x00ff]
> [    0.208252] pci 0000:00:00.0: reg 0x18: [mem 0x41002000-0x41002fff]
> [    0.209233] pci 0000:00:00.0: reg 0x20: [mem 0x41000000-0x41003fff]
> [    0.210481] pci 0000:00:01.0: [1af4:1000] type 00 class 0x020000
> [    0.211349] pci 0000:00:01.0: reg 0x10: [io  0x0100-0x01ff]
> [    0.212118] pci 0000:00:01.0: reg 0x14: [mem 0x41003000-0x410030ff]
> [    0.212982] pci 0000:00:01.0: reg 0x18: [mem 0x41003200-0x410033ff]
> [    0.214247] pci 0000:00:02.0: [1af4:1001] type 00 class 0x018000
> [    0.215096] pci 0000:00:02.0: reg 0x10: [io  0x0200-0x02ff]
> [    0.215863] pci 0000:00:02.0: reg 0x14: [mem 0x41003400-0x410034ff]
> [    0.216723] pci 0000:00:02.0: reg 0x18: [mem 0x41003600-0x410037ff]
> [    0.218105] pci 0000:00:00.0: can't claim BAR 4 [mem 0x41000000-0x41003fff]: address conflict with 0000:00:00.0 [mem 0x41002000-0x41002fff]
> [..]
> 
> Guest output of lspci -vv:
> 
> 00:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> 	Subsystem: TP-LINK Technologies Co., Ltd. TG-3468 Gigabit PCI Express Network Adapter
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: I/O ports at 0000 [size=256]
> 	Region 2: Memory at 41002000 (64-bit, non-prefetchable) [size=4K]
> 	Region 4: Memory at 41000000 (64-bit, prefetchable) [size=16K]
> 	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
> 		Vector table: BAR=4 offset=00000000
> 		PBA: BAR=4 offset=00001000
> 
> Let's fix this by allocating an amount of MMIO memory equal to the size
> of the BAR that contains the MSIX table and/or PBA.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Looks alright to me:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/pci.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 52 insertions(+), 16 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 8e5d8572bc0c..bbb8469c8d93 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -715,17 +715,44 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  	return 0;
>  }
>  
> -static int vfio_pci_create_msix_table(struct kvm *kvm,
> -				      struct vfio_pci_device *pdev)
> +static int vfio_pci_get_region_info(struct vfio_device *vdev, u32 index,
> +				    struct vfio_region_info *info)
> +{
> +	int ret;
> +
> +	*info = (struct vfio_region_info) {
> +		.argsz = sizeof(*info),
> +		.index = index,
> +	};
> +
> +	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_REGION_INFO, info);
> +	if (ret) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "cannot get info for BAR %u", index);
> +		return ret;
> +	}
> +
> +	if (info->size && !is_power_of_two(info->size)) {
> +		vfio_dev_err(vdev, "region is not power of two: 0x%llx",
> +				info->size);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
>  	size_t i;
> -	size_t mmio_size;
> +	size_t map_size;
>  	size_t nr_entries;
>  	struct vfio_pci_msi_entry *entries;
> +	struct vfio_pci_device *pdev = &vdev->pci;
>  	struct vfio_pci_msix_pba *pba = &pdev->msix_pba;
>  	struct vfio_pci_msix_table *table = &pdev->msix_table;
>  	struct msix_cap *msix = PCI_CAP(&pdev->hdr, pdev->msix.pos);
> +	struct vfio_region_info info;
>  
>  	table->bar = msix->table_offset & PCI_MSIX_TABLE_BIR;
>  	pba->bar = msix->pba_offset & PCI_MSIX_TABLE_BIR;
> @@ -744,15 +771,31 @@ static int vfio_pci_create_msix_table(struct kvm *kvm,
>  	for (i = 0; i < nr_entries; i++)
>  		entries[i].config.ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
>  
> +	ret = vfio_pci_get_region_info(vdev, table->bar, &info);
> +	if (ret)
> +		return ret;
> +	if (!info.size)
> +		return -EINVAL;
> +	map_size = info.size;
> +
> +	if (table->bar != pba->bar) {
> +		ret = vfio_pci_get_region_info(vdev, pba->bar, &info);
> +		if (ret)
> +			return ret;
> +		if (!info.size)
> +			return -EINVAL;
> +		map_size += info.size;
> +	}
> +
>  	/*
>  	 * To ease MSI-X cap configuration in case they share the same BAR,
>  	 * collapse table and pending array. The size of the BAR regions must be
>  	 * powers of two.
>  	 */
> -	mmio_size = roundup_pow_of_two(table->size + pba->size);
> -	table->guest_phys_addr = pci_get_mmio_block(mmio_size);
> +	map_size = ALIGN(map_size, PAGE_SIZE);
> +	table->guest_phys_addr = pci_get_mmio_block(map_size);
>  	if (!table->guest_phys_addr) {
> -		pr_err("cannot allocate IO space");
> +		pr_err("cannot allocate MMIO space");
>  		ret = -ENOMEM;
>  		goto out_free;
>  	}
> @@ -816,17 +859,10 @@ static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
>  
>  	region->vdev = vdev;
>  	region->is_ioport = !!(bar & PCI_BASE_ADDRESS_SPACE_IO);
> -	region->info = (struct vfio_region_info) {
> -		.argsz = sizeof(region->info),
> -		.index = nr,
> -	};
>  
> -	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_REGION_INFO, &region->info);
> -	if (ret) {
> -		ret = -errno;
> -		vfio_dev_err(vdev, "cannot get info for BAR %zu", nr);
> +	ret = vfio_pci_get_region_info(vdev, nr, &region->info);
> +	if (ret)
>  		return ret;
> -	}
>  
>  	/* Ignore invalid or unimplemented regions */
>  	if (!region->info.size)
> @@ -871,7 +907,7 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
>  		return ret;
>  
>  	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX) {
> -		ret = vfio_pci_create_msix_table(kvm, pdev);
> +		ret = vfio_pci_create_msix_table(kvm, vdev);
>  		if (ret)
>  			return ret;
>  	}

