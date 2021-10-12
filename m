Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BFD42A676
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 15:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhJLNyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 09:54:08 -0400
Received: from foss.arm.com ([217.140.110.172]:43596 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236783AbhJLNyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 09:54:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63FD7ED1;
        Tue, 12 Oct 2021 06:52:05 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B092A3F66F;
        Tue, 12 Oct 2021 06:52:04 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:52:02 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v2 kvmtool 5/7] vfio/pci: Rework MSIX table and PBA
 physical size allocation
Message-ID: <20211012145202.63d27698@donnerap.cambridge.arm.com>
In-Reply-To: <20211012132510.42134-6-alexandru.elisei@arm.com>
References: <20211012132510.42134-1-alexandru.elisei@arm.com>
        <20211012132510.42134-6-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Oct 2021 14:25:08 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> When creating the MSIX table and PBA, kvmtool rounds up the table and
> pending bit array sizes to the host's page size. Unfortunately, when doing
> that, it doesn't take into account that the new size can exceed the device
> BAR size, leading to hard to diagnose errors for certain configurations.
> 
> [ ...]

> Fix this by aligning the table and PBA size to 8 bytes to allow for
> qword accesses, like PCI 3.0 mandates.
> 
> For the sake of simplicity, the PBA offset in a BAR, in case of a shared
> BAR, is kept the same as the offset of the physical device. One hopes that
> the device respects the recommendations set forth in PCI LOCAL BUS
> SPECIFICATION, REV. 3.0, section "MSI-X Capability and Table Structures"

Thanks for the changes!

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/vfio.h |  1 +
>  vfio/pci.c         | 69 +++++++++++++++++++++++++++-------------------
>  2 files changed, 42 insertions(+), 28 deletions(-)
> 
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index 8cdf04f..764ab9b 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -50,6 +50,7 @@ struct vfio_pci_msix_pba {
>  	size_t				size;
>  	off_t				fd_offset; /* in VFIO device fd */
>  	unsigned int			bar;
> +	u32				bar_offset; /* in the shared BAR */
>  	u32				guest_phys_addr;
>  };
>  
> diff --git a/vfio/pci.c b/vfio/pci.c
> index cc18311..582aedd 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -502,7 +502,7 @@ static int vfio_pci_bar_activate(struct kvm *kvm,
>  
>  	if (has_msix && (u32)bar_num == pba->bar) {
>  		if (pba->bar == table->bar)
> -			pba->guest_phys_addr = table->guest_phys_addr + table->size;
> +			pba->guest_phys_addr = table->guest_phys_addr + pba->bar_offset;
>  		else
>  			pba->guest_phys_addr = region->guest_phys_addr;
>  		ret = kvm__register_mmio(kvm, pba->guest_phys_addr,
> @@ -815,15 +815,21 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  	if (msix) {
>  		/* Add a shortcut to the PBA region for the MMIO handler */
>  		int pba_index = VFIO_PCI_BAR0_REGION_INDEX + pdev->msix_pba.bar;
> +		u32 pba_bar_offset = msix->pba_offset & PCI_MSIX_PBA_OFFSET;
> +
>  		pdev->msix_pba.fd_offset = vdev->regions[pba_index].info.offset +
> -					   (msix->pba_offset & PCI_MSIX_PBA_OFFSET);
> +					   pba_bar_offset;
>  
>  		/* Tidy up the capability */
>  		msix->table_offset &= PCI_MSIX_TABLE_BIR;
> -		msix->pba_offset &= PCI_MSIX_PBA_BIR;
> -		if (pdev->msix_table.bar == pdev->msix_pba.bar)
> -			msix->pba_offset |= pdev->msix_table.size &
> -					    PCI_MSIX_PBA_OFFSET;
> +		if (pdev->msix_table.bar == pdev->msix_pba.bar) {
> +			/* Keep the same offset as the MSIX cap. */
> +			pdev->msix_pba.bar_offset = pba_bar_offset;
> +		} else {
> +			/* PBA is at the start of the BAR. */
> +			msix->pba_offset &= PCI_MSIX_PBA_BIR;
> +			pdev->msix_pba.bar_offset = 0;
> +		}
>  	}
>  
>  	/* Install our fake Configuration Space */
> @@ -892,12 +898,11 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>  	table->bar = msix->table_offset & PCI_MSIX_TABLE_BIR;
>  	pba->bar = msix->pba_offset & PCI_MSIX_TABLE_BIR;
>  
> -	/*
> -	 * KVM needs memory regions to be multiple of and aligned on PAGE_SIZE.
> -	 */
>  	nr_entries = (msix->ctrl & PCI_MSIX_FLAGS_QSIZE) + 1;
> -	table->size = ALIGN(nr_entries * PCI_MSIX_ENTRY_SIZE, PAGE_SIZE);
> -	pba->size = ALIGN(DIV_ROUND_UP(nr_entries, 64), PAGE_SIZE);
> +
> +	/* MSIX table and PBA must support QWORD accesses. */
> +	table->size = ALIGN(nr_entries * PCI_MSIX_ENTRY_SIZE, 8);
> +	pba->size = ALIGN(DIV_ROUND_UP(nr_entries, 64), 8);
>  
>  	entries = calloc(nr_entries, sizeof(struct vfio_pci_msi_entry));
>  	if (!entries)
> @@ -911,23 +916,8 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>  		return ret;
>  	if (!info.size)
>  		return -EINVAL;
> -	map_size = info.size;
> -
> -	if (table->bar != pba->bar) {
> -		ret = vfio_pci_get_region_info(vdev, pba->bar, &info);
> -		if (ret)
> -			return ret;
> -		if (!info.size)
> -			return -EINVAL;
> -		map_size += info.size;
> -	}
>  
> -	/*
> -	 * To ease MSI-X cap configuration in case they share the same BAR,
> -	 * collapse table and pending array. The size of the BAR regions must be
> -	 * powers of two.
> -	 */
> -	map_size = ALIGN(map_size, PAGE_SIZE);
> +	map_size = ALIGN(info.size, PAGE_SIZE);
>  	table->guest_phys_addr = pci_get_mmio_block(map_size);
>  	if (!table->guest_phys_addr) {
>  		pr_err("cannot allocate MMIO space");
> @@ -943,7 +933,30 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
>  	 * between MSI-X table and PBA. For the sake of isolation, create a
>  	 * virtual PBA.
>  	 */
> -	pba->guest_phys_addr = table->guest_phys_addr + table->size;
> +	if (table->bar == pba->bar) {
> +		u32 pba_bar_offset = msix->pba_offset & PCI_MSIX_PBA_OFFSET;
> +
> +		/* Sanity checks. */
> +		if (table->size > pba_bar_offset)
> +			die("MSIX table overlaps with PBA");
> +		if (pba_bar_offset + pba->size > info.size)
> +			die("PBA exceeds the size of the region");
> +		pba->guest_phys_addr = table->guest_phys_addr + pba_bar_offset;
> +	} else {
> +		ret = vfio_pci_get_region_info(vdev, pba->bar, &info);
> +		if (ret)
> +			return ret;
> +		if (!info.size)
> +			return -EINVAL;
> +
> +		map_size = ALIGN(info.size, PAGE_SIZE);
> +		pba->guest_phys_addr = pci_get_mmio_block(map_size);
> +		if (!pba->guest_phys_addr) {
> +			pr_err("cannot allocate MMIO space");
> +			ret = -ENOMEM;
> +			goto out_free;
> +		}
> +	}
>  
>  	pdev->msix.entries = entries;
>  	pdev->msix.nr_entries = nr_entries;

