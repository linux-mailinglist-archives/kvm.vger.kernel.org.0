Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D20C4240EF
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhJFPMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:12:51 -0400
Received: from foss.arm.com ([217.140.110.172]:35626 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhJFPMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:12:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AA0C6D;
        Wed,  6 Oct 2021 08:10:57 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85CD03F66F;
        Wed,  6 Oct 2021 08:10:56 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:10:54 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 4/7] vfio/pci: Rename PBA offset in device
 descriptor to fd_offset
Message-ID: <20211006161054.66e2fa75@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-5-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
        <20210913154413.14322-5-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:10 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> The MSI-X capability defines a PBA offset, which is the offset of the PBA
> array in the BAR that holds the array.
> 
> kvmtool uses the field "pba_offset" in struct msix_cap (which represents
> the MSIX capability) to refer to the [PBA offset:BAR] field of the
> capability; and the field "offset" in the struct vfio_pci_msix_pba to refer
> to offset of the PBA array in the device descriptor created by the VFIO
> driver.
> 
> As we're getting ready to add yet another field that represents an offset
> to struct vfio_pci_msix_pba, try to avoid ambiguities by renaming the
> struct's "offset" field to "fd_offset".
> 
> No functional change intended.

Makes sense, too many offsets.

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/vfio.h | 2 +-
>  vfio/pci.c         | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
> index 28223cf..8cdf04f 100644
> --- a/include/kvm/vfio.h
> +++ b/include/kvm/vfio.h
> @@ -48,7 +48,7 @@ struct vfio_pci_msix_table {
>  
>  struct vfio_pci_msix_pba {
>  	size_t				size;
> -	off_t				offset; /* in VFIO device fd */
> +	off_t				fd_offset; /* in VFIO device fd */
>  	unsigned int			bar;
>  	u32				guest_phys_addr;
>  };
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 10ff99e..cc18311 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -256,7 +256,7 @@ static void vfio_pci_msix_pba_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
>  	 * TODO: emulate PBA. Hardware MSI-X is never masked, so reading the PBA
>  	 * is completely useless here. Note that Linux doesn't use PBA.
>  	 */
> -	if (pread(vdev->fd, data, len, pba->offset + offset) != (ssize_t)len)
> +	if (pread(vdev->fd, data, len, pba->fd_offset + offset) != (ssize_t)len)
>  		vfio_dev_err(vdev, "cannot access MSIX PBA\n");
>  }
>  
> @@ -815,8 +815,8 @@ static int vfio_pci_fixup_cfg_space(struct vfio_device *vdev)
>  	if (msix) {
>  		/* Add a shortcut to the PBA region for the MMIO handler */
>  		int pba_index = VFIO_PCI_BAR0_REGION_INDEX + pdev->msix_pba.bar;
> -		pdev->msix_pba.offset = vdev->regions[pba_index].info.offset +
> -					(msix->pba_offset & PCI_MSIX_PBA_OFFSET);
> +		pdev->msix_pba.fd_offset = vdev->regions[pba_index].info.offset +
> +					   (msix->pba_offset & PCI_MSIX_PBA_OFFSET);
>  
>  		/* Tidy up the capability */
>  		msix->table_offset &= PCI_MSIX_TABLE_BIR;

