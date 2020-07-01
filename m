Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796F4211510
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 23:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgGAVYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 17:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGAVYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 17:24:40 -0400
Received: from localhost (mobile-166-175-191-139.mycingular.net [166.175.191.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3C9B2085B;
        Wed,  1 Jul 2020 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593638679;
        bh=y7Tj7NAUhvu0M9VijaEG0Jdd9zOA89epyoyiU3TDZxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=j1Z+d1i5LcEvbJzOmf03DnZGUtej26H5zKgrH68wE1n1Gb5zYpaO77D08hZfYD3SA
         a/bPOI2iSGCNdUI9smIf6JON7/ej/h0E5t3Dvq2CQtJqTqVbtAZuiFzFGEV9N7PDqU
         kQHb7jW7OsaqMSAq9/65dw3B6Nwpfx4sdE3xXs/8=
Date:   Wed, 1 Jul 2020 16:24:37 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     alex.williamson@redhat.com, herbert@gondor.apana.org.au,
        cohuck@redhat.com, nhorman@redhat.com, vdronov@redhat.com,
        bhelgaas@google.com, mark.a.chambers@intel.com,
        gordon.mcfadden@intel.com, ahsan.atta@intel.com,
        qat-linux@intel.com, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] vfio/pci: add device blocklist
Message-ID: <20200701212437.GA3660694@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701110302.75199-3-giovanni.cabiddu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 01, 2020 at 12:02:59PM +0100, Giovanni Cabiddu wrote:
> Add blocklist of devices that by default are not probed by vfio-pci.

> Devices in this list may be susceptible to untrusted application, even
> if the IOMMU is enabled. 

I can't quite parse this sentence.  I think it means something about
these devices being able to bypass an IOMMU or otherwise cause
problems via DMA.  It would be nice to know exactly what problem this
is avoiding.

I assume *all* applications are untrusted, right?  The wording above
makes it sound like there may be a class of trusted applications in
addition to the untrusted ones.  But I don't see anything like that in
the patch.

> To be accessed via vfio-pci, the user has to
> explicitly disable the blocklist.
> 
> The blocklist can be disabled via the module parameter disable_blocklist.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 7c0779018b1b..ea5904ca6cbf 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -60,6 +60,10 @@ module_param(enable_sriov, bool, 0644);
>  MODULE_PARM_DESC(enable_sriov, "Enable support for SR-IOV configuration.  Enabling SR-IOV on a PF typically requires support of the userspace PF driver, enabling VFs without such support may result in non-functional VFs or PF.");
>  #endif
>  
> +static bool disable_blocklist;
> +module_param(disable_blocklist, bool, 0444);
> +MODULE_PARM_DESC(disable_blocklist, "Disable device blocklist. If set, i.e. blocklist disabled, then blocklisted devices are allowed to be probed by vfio-pci.");
> +
>  static inline bool vfio_vga_disabled(void)
>  {
>  #ifdef CONFIG_VFIO_PCI_VGA
> @@ -69,6 +73,29 @@ static inline bool vfio_vga_disabled(void)
>  #endif
>  }
>  
> +static bool vfio_pci_dev_in_blocklist(struct pci_dev *pdev)
> +{
> +	return false;
> +}
> +
> +static bool vfio_pci_is_blocklisted(struct pci_dev *pdev)
> +{
> +	if (!vfio_pci_dev_in_blocklist(pdev))
> +		return false;
> +
> +	if (disable_blocklist) {
> +		pci_warn(pdev,
> +			 "device blocklist disabled - allowing device %04x:%04x.\n",
> +			 pdev->vendor, pdev->device);
> +		return false;
> +	}
> +
> +	pci_warn(pdev, "%04x:%04x is blocklisted - probe will fail.\n",
> +		 pdev->vendor, pdev->device);
> +
> +	return true;
> +}
> +
>  /*
>   * Our VGA arbiter participation is limited since we don't know anything
>   * about the device itself.  However, if the device is the only VGA device
> @@ -1847,6 +1874,9 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct iommu_group *group;
>  	int ret;
>  
> +	if (vfio_pci_is_blocklisted(pdev))
> +		return -EINVAL;
> +
>  	if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>  		return -EINVAL;
>  
> @@ -2336,6 +2366,9 @@ static int __init vfio_pci_init(void)
>  
>  	vfio_pci_fill_ids();
>  
> +	if (disable_blocklist)
> +		pr_warn("device blocklist disabled.\n");
> +
>  	return 0;
>  
>  out_driver:
> -- 
> 2.26.2
> 
