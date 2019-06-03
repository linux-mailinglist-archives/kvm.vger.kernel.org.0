Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5645A33B4E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFCWbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 18:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfFCWbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 18:31:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D896D307D945;
        Mon,  3 Jun 2019 22:31:34 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 707CF5D9C6;
        Mon,  3 Jun 2019 22:31:31 +0000 (UTC)
Date:   Mon, 3 Jun 2019 16:31:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        jean-philippe.brucker@arm.com, will.deacon@arm.com,
        robin.murphy@arm.com, kevin.tian@intel.com, ashok.raj@intel.com,
        marc.zyngier@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
Subject: Re: [PATCH v8 28/29] vfio-pci: Add VFIO_PCI_DMA_FAULT_IRQ_INDEX
Message-ID: <20190603163130.3f7497ba@x1.home>
In-Reply-To: <20190526161004.25232-29-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
        <20190526161004.25232-29-eric.auger@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 03 Jun 2019 22:31:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 18:10:03 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Add a new VFIO_PCI_DMA_FAULT_IRQ_INDEX index. This allows to
> set/unset an eventfd that will be triggered when DMA translation
> faults are detected at physical level when the nested mode is used.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c       |  3 +++
>  drivers/vfio/pci/vfio_pci_intrs.c | 19 +++++++++++++++++++
>  include/uapi/linux/vfio.h         |  1 +
>  3 files changed, 23 insertions(+)


Note that I suggested to Intel folks trying to add a GVT-g page
flipping eventfd to convert to device specific interrupts the same way
we added device specific regions:

https://patchwork.kernel.org/patch/10962337/

I'd probably suggest the same here so we can optionally expose it when
supported.  Thanks,

Alex

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index a9c8af2a774a..65a1e6814f5c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -746,6 +746,8 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
>  			return 1;
>  	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>  		return 1;
> +	} else if (irq_type == VFIO_PCI_DMA_FAULT_IRQ_INDEX) {
> +		return 1;
>  	}
>  
>  	return 0;
> @@ -1082,6 +1084,7 @@ static long vfio_pci_ioctl(void *device_data,
>  		switch (info.index) {
>  		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
>  		case VFIO_PCI_REQ_IRQ_INDEX:
> +		case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
>  			break;
>  		case VFIO_PCI_ERR_IRQ_INDEX:
>  			if (pci_is_pcie(vdev->pdev))
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 1c46045b0e7f..28a96117daf3 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -622,6 +622,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
>  					       count, flags, data);
>  }
>  
> +static int vfio_pci_set_dma_fault_trigger(struct vfio_pci_device *vdev,
> +					  unsigned index, unsigned start,
> +					  unsigned count, uint32_t flags,
> +					  void *data)
> +{
> +	if (index != VFIO_PCI_DMA_FAULT_IRQ_INDEX || start != 0 || count > 1)
> +		return -EINVAL;
> +
> +	return vfio_pci_set_ctx_trigger_single(&vdev->dma_fault_trigger,
> +					       count, flags, data);
> +}
> +
>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>  			    unsigned index, unsigned start, unsigned count,
>  			    void *data)
> @@ -671,6 +683,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>  			break;
>  		}
>  		break;
> +	case VFIO_PCI_DMA_FAULT_IRQ_INDEX:
> +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> +			func = vfio_pci_set_dma_fault_trigger;
> +			break;
> +		}
> +		break;
>  	}
>  
>  	if (!func)
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 13e041b84d48..66b6b08c4a38 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -559,6 +559,7 @@ enum {
>  	VFIO_PCI_MSIX_IRQ_INDEX,
>  	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_REQ_IRQ_INDEX,
> +	VFIO_PCI_DMA_FAULT_IRQ_INDEX,
>  	VFIO_PCI_NUM_IRQS
>  };
>  

