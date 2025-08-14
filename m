Return-Path: <kvm+bounces-54692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23310B27059
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 22:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747CA5C1558
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 20:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EDC2737E1;
	Thu, 14 Aug 2025 20:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGC+jnuk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA7192D97;
	Thu, 14 Aug 2025 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755204532; cv=none; b=NsKWo10y2PcLdEmjes5CWDtfoqwbIAFeO1W0x+eDXcDkX9X5QLqcXBGNBZ82jVKlVK7mhWlkldSI9Gr0LrqPsquCsJVU6tGlL3I+m8nq1AMxYWqcwAzkgO0reyWSXuPg94laWFh6+K/JKzLQozmZMQQLd7kLwKtZZB7e1Zrji+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755204532; c=relaxed/simple;
	bh=3XDu9rqcQti7BDstShCM5LqYWLf7ryGkfCAXwU5pojc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Gpz4mJCS8U3qEDj9aNkZlKdeW0YXT7RUfOW2WE5poDwcMcZMjbw/kdeM4ROKu+WhuhJiMfXRQRyrL0hwvWJwfrhPCLSQ7+uD4nIymtksV4ZyjevcHXQEt2iEWV4FemMKQY+pspGHcBV8Wb3BnSh3Lu0bYCADyDKFLzqYDLQ3IG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGC+jnuk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0671AC4CEED;
	Thu, 14 Aug 2025 20:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755204532;
	bh=3XDu9rqcQti7BDstShCM5LqYWLf7ryGkfCAXwU5pojc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=QGC+jnukHksRu2J6/IqOJVQkz+j8XnrY2YEqZpCFN/jPLaCdKdXQZcCSdBhJPLmsH
	 /qJ35hK1sBF8VGTj9lXgvp6RVggSb5BZ+YNrSsJjTiaayphADW8KIalkwZw00DtC4e
	 idVYJzchqke5iG9nZHlZXCfxDl8CbWfSwDROgogSisAUPv/MXdXNvx0lbpUsr+CrXT
	 FkdUOheqfWW4/4e9aPKrToEuJbofGlJQSLvW7UmVj8LD+5Aii1zRySPfwgr6L/+BlT
	 xqUyjLvgt+/fI07yNpb5uOIcK2+AylHFCTbITSyyPpipu08POpdQRUO8r0KWzr8MzF
	 Vsx4Wac3ReflA==
Date: Thu, 14 Aug 2025 15:48:50 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com, alex.williamson@redhat.com
Subject: Re: [PATCH v1 6/6] vfio: Allow error notification and recovery for
 ISM device
Message-ID: <20250814204850.GA346571@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813170821.1115-7-alifm@linux.ibm.com>

On Wed, Aug 13, 2025 at 10:08:20AM -0700, Farhan Ali wrote:
> VFIO allows error recovery and notification for devices that
> are PCIe (and thus AER) capable. But for PCI devices on IBM
> s390 error recovery involves platform firmware and
> notification to operating system is done by architecture
> specific way. The Internal Shared Memory(ISM) device is a legacy
> PCI device (so not PCIe capable), but can still be recovered
> when notified of an error.

"PCIe (and thus AER) capable" reads as though AER is required for all
PCIe devices, but AER is optional.

I don't know the details of VFIO and why it tests for PCIe instead of
AER.  Maybe AER is not relevant here and you don't need to mention
AER above at all?

> Relax the PCIe only requirement for ISM devices, so passthrough
> ISM devices can be notified and recovered on error.

Nit: it looks like all your commit logs could be rewrapped to fill
about 75 columns (to leave space for "git log" to indent them and
still fit in 80 columns).  IMHO not much value in using a smaller
width than that.

> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c  | 18 ++++++++++++++++--
>  drivers/vfio/pci/vfio_pci_intrs.c |  2 +-
>  drivers/vfio/pci/vfio_pci_priv.h  |  3 +++
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7220a22135a9..1faab80139c6 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -723,6 +723,20 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
>  
> +bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +
> +	if (pci_is_pcie(pdev))
> +		return true;
> +
> +	if (pdev->vendor == PCI_VENDOR_ID_IBM &&
> +			pdev->device == PCI_DEVICE_ID_IBM_ISM)
> +		return true;
> +
> +	return false;
> +}
> +
>  static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
>  {
>  	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
> @@ -749,7 +763,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
>  			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
>  		}
>  	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
> -		if (pci_is_pcie(vdev->pdev))
> +		if (vfio_pci_device_can_recover(vdev))
>  			return 1;
>  	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
>  		return 1;
> @@ -1150,7 +1164,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  	case VFIO_PCI_REQ_IRQ_INDEX:
>  		break;
>  	case VFIO_PCI_ERR_IRQ_INDEX:
> -		if (pci_is_pcie(vdev->pdev))
> +		if (vfio_pci_device_can_recover(vdev))
>  			break;
>  		fallthrough;
>  	default:
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 123298a4dc8f..f5384086ac45 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -838,7 +838,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  	case VFIO_PCI_ERR_IRQ_INDEX:
>  		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>  		case VFIO_IRQ_SET_ACTION_TRIGGER:
> -			if (pci_is_pcie(vdev->pdev))
> +			if (vfio_pci_device_can_recover(vdev))
>  				func = vfio_pci_set_err_trigger;
>  			break;
>  		}
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 5288577b3170..93c1e29fbbbb 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -36,6 +36,9 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  			size_t count, loff_t *ppos, bool iswrite);
>  
> +bool vfio_pci_device_can_recover(struct vfio_pci_core_device *vdev);
> +
> +
>  #ifdef CONFIG_VFIO_PCI_VGA
>  ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  			size_t count, loff_t *ppos, bool iswrite);
> -- 
> 2.43.0
> 

