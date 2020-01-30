Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9A014DD48
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 15:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgA3Oup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 09:50:45 -0500
Received: from foss.arm.com ([217.140.110.172]:53946 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgA3Ouo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 09:50:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7441D1FB;
        Thu, 30 Jan 2020 06:50:44 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E3213F68E;
        Thu, 30 Jan 2020 06:50:43 -0800 (PST)
Date:   Thu, 30 Jan 2020 14:50:41 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 13/30] vfio/pci: Ignore expansion ROM BAR
 writes
Message-ID: <20200130145041.37b8e6fc@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-14-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-14-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:48 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> To get the size of the expansion ROM, software writes 0xfffff800 to the
> expansion ROM BAR in the PCI configuration space. PCI emulation executes
> the optional configuration space write callback that a device can
> implement before emulating this write.
> 
> VFIO doesn't have support for emulating expansion ROMs.

With "VFIO doesn't have support" you mean kvmtool's VFIO implementation or the kernel's VFIO driver?
Because to me it looks like it should work in the kernel, at least for the BAR sizing on the expansion ROM BAR:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/vfio/pci/vfio_pci_config.c#n477

Am I missing something here?

QEMU seems to have code to load the ROM from the device and present that to the guest, but I am not sure exactly why.

Cheers,
Andre

> However, the
> callback writes the guest value to the hardware BAR, and then it reads
> it back to the BAR to make sure the write has completed successfully.
> 
> After this, we return to regular PCI emulation and because the BAR is
> no longer 0, we write back to the BAR the value that the guest used to
> get the size. As a result, the guest will think that the ROM size is
> 0x800 after the subsequent read and we end up unintentionally exposing
> to the guest a BAR which we don't emulate.
> 
> Let's fix this by ignoring writes to the expansion ROM BAR.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  vfio/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 1bdc20038411..1f38f90c3ae9 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -472,6 +472,9 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	struct vfio_device *vdev;
>  	void *base = pci_hdr;
>  
> +	if (offset == PCI_ROM_ADDRESS)
> +		return;
> +
>  	pdev = container_of(pci_hdr, struct vfio_pci_device, hdr);
>  	vdev = container_of(pdev, struct vfio_device, pci);
>  	info = &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;

