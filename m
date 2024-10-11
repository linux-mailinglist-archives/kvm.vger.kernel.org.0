Return-Path: <kvm+bounces-28650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E3699AD98
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 22:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E488B228BB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 20:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71D6F1D1518;
	Fri, 11 Oct 2024 20:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7nD/nG7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D48119B3CB
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 20:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728679048; cv=none; b=Am2GbBXhTrRGG0sjglgp8zauN+MZ/QBxGCm0gr62OG7AlL5FqRLYileEY9Q1jMCkdeKjwG/RltGqYu8i3w4f6W1f3pDO+/HdKUWjPLSZOa7pqCRV507w/ihte3llLXqOnrkn+vQcD+/S+oCNmnYB0hk/0ElOFEduEa+G5d9HfCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728679048; c=relaxed/simple;
	bh=ok3Uhus4o1fHHNgAgze2m5cCgEgSOBzJ+bu2Lk58iQM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdBC127qzIOAfIxk4cuIuNkMd3zQzFU5PslLXlHVWIt3xXghvU5sc3kQ5tZuaeTOh0/oOvXjpDTgJlq1UiMx6Rlifjlj9BklBXi4WCbCV7oI2Ozs4fZGDnzv71AcfSd1iQUtrVVo02Szrlc69fotm7ovsXBsRH6gxk766pFKpOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W7nD/nG7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728679045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83b1hPyOJcDieDQ667domh+NlBgqeUhWWW1JcLYMgsI=;
	b=W7nD/nG7ZogSGduJ+FPGiglZmfV/NfY0xzksITADd95suxFlIn38NzpHDYesY9xnllTFVr
	ihc1fVP2eVwXcPQhneHVtEh0ypyCPRbGtUXUEMJv9Yk3PyapKrWQs+Ivvz9PYlRMkQtHSP
	ZzN+e0HTjut+wqcH+kK0ogHSIIURyE4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-mbIQeizzP2WBcGejORqSpg-1; Fri, 11 Oct 2024 16:37:24 -0400
X-MC-Unique: mbIQeizzP2WBcGejORqSpg-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-834add432f3so34591439f.2
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 13:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728679043; x=1729283843;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=83b1hPyOJcDieDQ667domh+NlBgqeUhWWW1JcLYMgsI=;
        b=gb0UFfhOWLkcoWFY2qLwrT1xJjEMMI0kn1xDfsWd6E6Jq2oACu7xICIa+myefb/jMk
         hTAFm11fCPeczNR4mpKCoSDFA5fr2mm3uBKZpJWdIoMr0hNpKcLj5wOkcjCqrfxa3iaX
         nH/AHKMgD1kkKoZuTDwxu/1JKxKMqtTlDwqbMUgakwRVTujMQQ581JRL+P7ZlmiqM4zz
         7bxtI2GtHzOPYQ4UQAMnawk7JTaQ+jBUSOzYtsxYjyCfK10aL9srzm5rQh9BwFa1427V
         VDd4cYpNDxvpF1SYXynSaGA87wT4CV0j+OivCtqebYTjrTnhwSa2WvOzG1jb7z+A4PB1
         4n3w==
X-Gm-Message-State: AOJu0YxBdYvcoj6LCVfOsf98IFy7mdgqDP6Fetc+LO3Y7SUPXW8yoJfV
	YGuLlhtytzuBlRmUuo+kyKgdmUn8JBY1nMYC5u2qv/xjj68FmG9WmqmXUPmph9c2Tbxyapf8EDE
	Ke77BWKN1oCHsZi77omsI8i0kdO03EFxhQop1lCgcI1VmX0Kjvg==
X-Received: by 2002:a5e:8e4d:0:b0:82a:a4f0:c95d with SMTP id ca18e2360f4ac-83794b58cf0mr91139239f.4.1728679043377;
        Fri, 11 Oct 2024 13:37:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGzr9L4tEu39Z7uqjYgxawSTwRkH6yKP4IuMAlzewyi0uMldGhyZLXRBPlAt1XieJJwhU9vw==
X-Received: by 2002:a5e:8e4d:0:b0:82a:a4f0:c95d with SMTP id ca18e2360f4ac-83794b58cf0mr91136739f.4.1728679042876;
        Fri, 11 Oct 2024 13:37:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbadaa9f67sm780452173.153.2024.10.11.13.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 13:37:22 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:37:19 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <alison.schofield@intel.com>,
 <dan.j.williams@intel.com>, <dave.jiang@intel.com>, <dave@stgolabs.net>,
 <jonathan.cameron@huawei.com>, <ira.weiny@intel.com>,
 <vishal.l.verma@intel.com>, <alucerop@amd.com>, <acurrid@nvidia.com>,
 <cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
 <aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
 <zhiwang@kernel.org>
Subject: Re: [RFC 09/13] vfio/pci: introduce CXL device awareness
Message-ID: <20241011143719.2c6e0458.alex.williamson@redhat.com>
In-Reply-To: <20240920223446.1908673-10-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
	<20240920223446.1908673-10-zhiw@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 20 Sep 2024 15:34:42 -0700
Zhi Wang <zhiw@nvidia.com> wrote:

> CXL device programming interfaces are built upon PCI interfaces. Thus
> the vfio-pci-core can be leveraged to handle a CXL device.
> 
> However, CXL device also has difference with PCI devicce:
> 
> - No INTX support, only MSI/MSIX is supported.
> - Resest is one via CXL reset. FLR only resets CXL.io.
> 
> Introduce the CXL device awareness to the vfio-pci-core. Expose a new
> VFIO device flags to the userspace to identify the VFIO device is a CXL
> device. Disable INTX support in the vfio-pci-core. Disable FLR reset for
> the CXL device as the kernel CXL core hasn't support CXL reset yet.
> Disable mmap support on the CXL MMIO BAR in vfio-pci-core.

Why are we disabling mmap on the entire BAR when we have sparse mmap
support to handle disabling mmap only on a portion of the BAR, which
seems to be the case needed here.  Am I mistaken?
 
> Signed-off-by: Zhi Wang <zhiw@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_cxl_core.c |  8 ++++++
>  drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++-----------
>  include/linux/vfio_pci_core.h    |  2 ++
>  include/uapi/linux/vfio.h        |  1 +
>  4 files changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
> index bbb968cb1b70..d8b51f8792a2 100644
> --- a/drivers/vfio/pci/vfio_cxl_core.c
> +++ b/drivers/vfio/pci/vfio_cxl_core.c
> @@ -391,6 +391,8 @@ int vfio_cxl_core_enable(struct vfio_pci_core_device *core_dev)
>  	if (ret)
>  		return ret;
>  
> +	vfio_pci_core_enable_cxl(core_dev);
> +
>  	ret = vfio_pci_core_enable(core_dev);
>  	if (ret)
>  		goto err_pci_core_enable;
> @@ -618,6 +620,12 @@ ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *bu
>  }
>  EXPORT_SYMBOL_GPL(vfio_cxl_core_write);
>  
> +void vfio_pci_core_enable_cxl(struct vfio_pci_core_device *core_dev)
> +{
> +	core_dev->has_cxl = true;
> +}
> +EXPORT_SYMBOL(vfio_pci_core_enable_cxl);
> +
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 9373942f1acb..e0f23b538858 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -126,6 +126,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  		if (!(res->flags & IORESOURCE_MEM))
>  			goto no_mmap;
>  
> +		if (vdev->has_cxl && bar == vdev->cxl.comp_reg_bar)
> +			goto no_mmap;
> +
>  		/*
>  		 * The PCI core shouldn't set up a resource with a
>  		 * type but zero size. But there may be bugs that
> @@ -487,10 +490,15 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (ret)
>  		goto out_power;
>  
> -	/* If reset fails because of the device lock, fail this path entirely */
> -	ret = pci_try_reset_function(pdev);
> -	if (ret == -EAGAIN)
> -		goto out_disable_device;
> +	if (!vdev->has_cxl) {
> +		/* If reset fails because of the device lock, fail this path entirely */
> +		ret = pci_try_reset_function(pdev);
> +		if (ret == -EAGAIN)
> +			goto out_disable_device;
> +	} else {
> +		/* CXL Reset is missing in CXL core. FLR only resets CXL.io path. */
> +		ret = -ENODEV;
> +	}

Seems like this should perhaps be a prerequisite to exposing the device
to userspace, otherwise how is the state sanitized between uses?

>  
>  	vdev->reset_works = !ret;
>  	pci_save_state(pdev);
> @@ -498,14 +506,17 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (!vdev->pci_saved_state)
>  		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
>  
> -	if (likely(!nointxmask)) {
> -		if (vfio_pci_nointx(pdev)) {
> -			pci_info(pdev, "Masking broken INTx support\n");
> -			vdev->nointx = true;
> -			pci_intx(pdev, 0);
> -		} else
> -			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
> -	}
> +	if (!vdev->has_cxl) {
> +		if (likely(!nointxmask)) {
> +			if (vfio_pci_nointx(pdev)) {
> +				pci_info(pdev, "Masking broken INTx support\n");
> +				vdev->nointx = true;
> +				pci_intx(pdev, 0);
> +			} else
> +				vdev->pci_2_3 = pci_intx_mask_supported(pdev);
> +		}
> +	} else
> +		vdev->nointx = true; /* CXL device doesn't have INTX. */
>  

Why do we need to do anything here?  nointx is for exposing a device
with INTx support as if it does not have INTx support.  If a CXL device
simply does not support INTx, like SR-IOV VFs, this is not necessary,
the interrupt pin register should be zero.  Is that not the case on a
CXL device?

>  	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
>  	if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
> @@ -541,7 +552,6 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
>  		vdev->has_vga = true;
>  
> -

Gratuitous whitespace change.

>  	return 0;
>  
>  out_free_zdev:
> @@ -657,7 +667,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 * Disable INTx and MSI, presumably to avoid spurious interrupts
>  	 * during reset.  Stolen from pci_reset_function()
>  	 */
> -	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
> +	if (!vdev->nointx)
> +		pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);

No, this is not what nointx is for.  Regardless it should be a no-op on
a device that doesn't support INTx.

>  
>  	/*
>  	 * Try to get the locks ourselves to prevent a deadlock. The
> @@ -973,6 +984,9 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  	if (vdev->reset_works)
>  		info.flags |= VFIO_DEVICE_FLAGS_RESET;
>  
> +	if (vdev->has_cxl)
> +		info.flags |= VFIO_DEVICE_FLAGS_CXL;
> +

So the proposal is that a vfio-cxl device will expose *both* PCI and
CXL device compatibility flags?  That means existing userspace
expecting only a PCI device will try to make use of this.  Shouldn't
the device be bound to vfio-pci rather than a vfio-cxl driver for that,
if it's even valid?

>  	info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
>  	info.num_irqs = VFIO_PCI_NUM_IRQS;
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 9d295ca9382a..e5646aad3eb3 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -113,6 +113,7 @@ struct vfio_pci_core_device {
>  	bool			needs_pm_restore:1;
>  	bool			pm_intx_masked:1;
>  	bool			pm_runtime_engaged:1;
> +	bool			has_cxl:1;

I wonder if has_cxl is based on has_vga, I would have expected is_cxl.
A PCI device that supports VGA is a much more discrete add-on, versus
my limited understanding of CXL is that it is a CXL device where PCI is
mostly just the configuration and enumeration interface, ie. CXL.io.

>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;
> @@ -208,5 +209,6 @@ ssize_t vfio_cxl_core_read(struct vfio_device *core_vdev, char __user *buf,
>  			   size_t count, loff_t *ppos);
>  ssize_t vfio_cxl_core_write(struct vfio_device *core_vdev, const char __user *buf,
>  			    size_t count, loff_t *ppos);
> +void vfio_pci_core_enable_cxl(struct vfio_pci_core_device *core_dev);
>  
>  #endif /* VFIO_PCI_CORE_H */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 71f766c29060..0895183feaac 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -214,6 +214,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
>  #define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
>  #define VFIO_DEVICE_FLAGS_CDX	(1 << 8)	/* vfio-cdx device */
> +#define VFIO_DEVICE_FLAGS_CXL	(1 << 9)	/* Device supports CXL support */

Comment wording.  Thanks,

Alex

>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */


