Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29A5680B86
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 12:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbjA3LCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 06:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbjA3LCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:02:16 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D83B433471
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 03:01:36 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA2DE16F2;
        Mon, 30 Jan 2023 03:02:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00A5F3F71E;
        Mon, 30 Jan 2023 03:01:34 -0800 (PST)
Date:   Mon, 30 Jan 2023 11:01:27 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Dongli Si <sidongli1997@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool 1/1] vfio/pci: Support NVM Express device
 passthrough
Message-ID: <Y9ejh4vpAFB8n1LO@monolith.localdoman>
References: <20230128073551.47527-1-sidongli1997@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230128073551.47527-1-sidongli1997@gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

(Adding the maintainers)

On Sat, Jan 28, 2023 at 03:35:51PM +0800, Dongli Si wrote:
> From: Dongli Si <sidongli1997@gmail.com>
> 
> When passthrough nvme SSD, the guest kernel will report the error:
> 
> [   18.339460] nvme nvme0: failed to register the CMB
> 
> This is because the mmio data of region 0 of the nvme device is
> not mapped, causing the nvme driver to read the wrong cmb size.
> 
> Nvme devices have only one region, we need to setup the mmio data
> and msix table to this region, and prevent them from overlay.

Thank you for doing this, this has been a known issue for years.

This is actually more than about CMB (controller memory buffers), the root
problem is that the NVME controller registers are not mapped because
kvmtool doesn't support mapping something else alongside MSIX/PBA in the
same BAR.

> 
> Signed-off-by: Dongli Si <sidongli1997@gmail.com>
> ---
>  include/kvm/vfio.h |  1 +
>  vfio/pci.c         | 33 +++++++++++++++++++++++++++++++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index 764ab9b..c30a0d3 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -43,6 +43,7 @@ struct vfio_pci_msi_entry {
>  struct vfio_pci_msix_table {
>  	size_t				size;
>  	unsigned int			bar;
> +	u32				bar_offset; /* in the shared BAR */
>  	u32				guest_phys_addr;
>  };
>  
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 78f5ca5..f38c0b5 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -497,10 +497,31 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  		region->guest_phys_addr = bar_addr;
>  
>  	if (has_msix && (u32)bar_num == table->bar) {
> -		table->guest_phys_addr = region->guest_phys_addr;
> +		table->guest_phys_addr = region->guest_phys_addr + table->bar_offset;
>  		ret = kvm__register_mmio(kvm, table->guest_phys_addr,
>  					 table->size, false,
>  					 vfio_pci_msix_table_access, pdev);
> +
> +		/*
> +		 * This is to support nvme devices, because the msix table
> +		 * shares a region with the mmio data, we need to avoid overlay
> +		 * the memory of the msix table during the vfio_map_region.
> +		 *
> +		 * Here let the end address of the vfio_map_region mapped memory
> +		 * not exceed the start address of the msix table. In theory,
> +		 * we should also map the memory between the end address of the
> +		 * msix table to the end address of the region, but the linux
> +		 * nvme driver does not use the latter.
> +		 *
> +		 * Because the linux nvme driver does not use pba, so skip the
> +		 * pba simulation directly.

There is no need to remove PBA emulation. This patch adds the MSIX table
offset and kvmtool already tracks the PBA offset in the BAR, so kvmtool has
everything it needs (guest physical address and size) to trap and emulate
accesses.

> +		 */
> +		if (pdev->hdr.class[0] == 2 && pdev->hdr.class[1] == 8
> +		    && pdev->hdr.class[2] == 1) {
> +			region->info.size = table->bar_offset;
> +			goto map;
> +		}

I would prefer this to be more generic, so any device can put a MMIO region
in the same bar as the MSIX table/PBA. Do you have concerns about this?

kvmtool can check that region.info.size is larger than the size of the MSIX
table + PBA (if they share the same BAR), and call vfio_map_region() for
the rest of the BAR.

Thanks,
Alex

> +
>  		/*
>  		 * The MSIX table and the PBA structure can share the same BAR,
>  		 * but for convenience we register different regions for mmio
> @@ -522,6 +543,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  		goto out;
>  	}
>  
> +map:
>  	ret = vfio_map_region(kvm, vdev, region);
>  out:
>  	return ret;
> @@ -548,6 +570,12 @@ static int vfio_pci_bar_deactivate(struct kvm *kvm,
>  		success = kvm__deregister_mmio(kvm, table->guest_phys_addr);
>  		/* kvm__deregister_mmio fails when the region is not found. */
>  		ret = (success ? 0 : -ENOENT);
> +
> +		/* See vfio_pci_bar_activate(). */
> +		if (pdev->hdr.class[0] == 2 && pdev->hdr.class[1] == 8
> +		    && pdev->hdr.class[2] == 1)
> +			goto unmap;
> +
>  		/* See vfio_pci_bar_activate(). */
>  		if (ret < 0 || table->bar!= pba->bar)
>  			goto out;
> @@ -559,6 +587,7 @@ static int vfio_pci_bar_deactivate(struct kvm *kvm,
>  		goto out;
>  	}
>  
> +unmap:
>  	vfio_unmap_region(kvm, region);
>  	ret = 0;
>  
> @@ -832,7 +861,6 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  					   pba_bar_offset;
>  
>  		/* Tidy up the capability */
> -		msix->table_offset &= PCI_MSIX_TABLE_BIR;
>  		if (pdev->msix_table.bar == pdev->msix_pba.bar) {
>  			/* Keep the same offset as the MSIX cap. */
>  			pdev->msix_pba.bar_offset = pba_bar_offset;
> @@ -907,6 +935,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>  	struct vfio_region_info info;
>  
>  	table->bar = msix->table_offset & PCI_MSIX_TABLE_BIR;
> +	table->bar_offset = msix->table_offset & PCI_MSIX_TABLE_OFFSET;
>  	pba->bar = msix->pba_offset & PCI_MSIX_TABLE_BIR;
>  
>  	nr_entries = (msix->ctrl & PCI_MSIX_FLAGS_QSIZE) + 1;
> -- 
> 2.37.3
> 
