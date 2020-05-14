Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F5E1D3717
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 18:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgENQ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 12:56:39 -0400
Received: from foss.arm.com ([217.140.110.172]:40586 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgENQ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 12:56:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33D031042;
        Thu, 14 May 2020 09:56:36 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D8B93F71E;
        Thu, 14 May 2020 09:56:35 -0700 (PDT)
Subject: Re: [PATCH v4 kvmtool 06/12] vfio/pci: Don't write configuration
 value twice
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com, maz@kernel.org
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
 <1589470709-4104-7-git-send-email-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <b1efa788-263a-07a7-95eb-a1d95aaa6a27@arm.com>
Date:   Thu, 14 May 2020 17:55:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589470709-4104-7-git-send-email-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/2020 16:38, Alexandru Elisei wrote:
> After writing to the device fd as part of the PCI configuration space
> emulation, we read back from the device to make sure that the write
> finished. The value is read back into the PCI configuration space and
> afterwards, the same value is copied by the PCI emulation code. Let's
> read from the device fd into a temporary variable, to prevent this
> double write.
> 
> The double write is harmless in itself. But when we implement
> reassignable BARs, we need to keep track of the old BAR value, and the
> VFIO code is overwritting it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks for the changes!

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/pci.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index 0b548e4bf9e2..2de893407574 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -3,6 +3,8 @@
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/vfio.h"
>  
> +#include <assert.h>
> +
>  #include <sys/ioctl.h>
>  #include <sys/eventfd.h>
>  #include <sys/resource.h>
> @@ -478,7 +480,10 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	struct vfio_region_info *info;
>  	struct vfio_pci_device *pdev;
>  	struct vfio_device *vdev;
> -	void *base = pci_hdr;
> +	u32 tmp;
> +
> +	/* Make sure a larger size will not overrun tmp on the stack. */
> +	assert(sz <= 4);
>  
>  	if (offset == PCI_ROM_ADDRESS)
>  		return;
> @@ -498,7 +503,7 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
>  	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
>  		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
>  
> -	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
> +	if (pread(vdev->fd, &tmp, sz, info->offset + offset) != sz)
>  		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
>  			      sz, offset);
>  }
> 

