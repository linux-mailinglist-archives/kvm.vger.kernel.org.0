Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E38B5FF3
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfIRJRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 05:17:23 -0400
Received: from foss.arm.com ([217.140.110.172]:37960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfIRJRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 05:17:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63918337;
        Wed, 18 Sep 2019 02:17:22 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE9563F59C;
        Wed, 18 Sep 2019 02:17:21 -0700 (PDT)
Date:   Wed, 18 Sep 2019 10:17:20 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v3 17/26] vfio_pci: Loop using PCI_STD_NUM_BARS
Message-ID: <20190918091719.GA9720@e119886-lin.cambridge.arm.com>
References: <20190916204158.6889-1-efremov@linux.com>
 <20190916204158.6889-18-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916204158.6889-18-efremov@linux.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 11:41:49PM +0300, Denis Efremov wrote:
> Refactor loops to use idiomatic C style and avoid the fencepost error
> of using "i < PCI_STD_RESOURCE_END" when "i <= PCI_STD_RESOURCE_END"
> is required, e.g., commit 2f686f1d9bee ("PCI: Correct PCI_STD_RESOURCE_END
> usage").
> 
> To iterate through all possible BARs, loop conditions changed to the
> *number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
> valid BAR "i <= PCI_STD_RESOURCE_END".
> 
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 11 ++++++----
>  drivers/vfio/pci/vfio_pci_config.c  | 32 +++++++++++++++--------------
>  drivers/vfio/pci/vfio_pci_private.h |  4 ++--
>  3 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 703948c9fbe1..cb7d220d3246 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -110,13 +110,15 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>  static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
>  {
>  	struct resource *res;
> -	int bar;
> +	int i;
>  	struct vfio_pci_dummy_resource *dummy_res;
>  
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  
> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> -		res = vdev->pdev->resource + bar;
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		int bar = i + PCI_STD_RESOURCES;
> +
> +		res = &vdev->pdev->resource[bar];

Why can't we just drop PCI_STD_RESOURCES and replace it was 0. I understand
the abstraction here, but we don't do it elsewhere across the kernel. Is this
necessary?

Thanks,

Andrew Murray

>  
>  		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
>  			goto no_mmap;
> @@ -399,7 +401,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  
>  	vfio_config_free(vdev);
>  
> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
> +		bar = i + PCI_STD_RESOURCES;
>  		if (!vdev->barmap[bar])
>  			continue;
>  		pci_iounmap(pdev, vdev->barmap[bar]);
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index f0891bd8444c..90c0b80f8acf 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -450,30 +450,32 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	int i;
> -	__le32 *bar;
> +	__le32 *vbar;
>  	u64 mask;
>  
> -	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
> +	vbar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>  
> -	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
> -		if (!pci_resource_start(pdev, i)) {
> -			*bar = 0; /* Unmapped by host = unimplemented to user */
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++, vbar++) {
> +		int bar = i + PCI_STD_RESOURCES;
> +
> +		if (!pci_resource_start(pdev, bar)) {
> +			*vbar = 0; /* Unmapped by host = unimplemented to user */
>  			continue;
>  		}
>  
> -		mask = ~(pci_resource_len(pdev, i) - 1);
> +		mask = ~(pci_resource_len(pdev, bar) - 1);
>  
> -		*bar &= cpu_to_le32((u32)mask);
> -		*bar |= vfio_generate_bar_flags(pdev, i);
> +		*vbar &= cpu_to_le32((u32)mask);
> +		*vbar |= vfio_generate_bar_flags(pdev, bar);
>  
> -		if (*bar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
> -			bar++;
> -			*bar &= cpu_to_le32((u32)(mask >> 32));
> +		if (*vbar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
> +			vbar++;
> +			*vbar &= cpu_to_le32((u32)(mask >> 32));
>  			i++;
>  		}
>  	}
>  
> -	bar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
> +	vbar = (__le32 *)&vdev->vconfig[PCI_ROM_ADDRESS];
>  
>  	/*
>  	 * NB. REGION_INFO will have reported zero size if we weren't able
> @@ -483,14 +485,14 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>  	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
>  		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
>  		mask |= PCI_ROM_ADDRESS_ENABLE;
> -		*bar &= cpu_to_le32((u32)mask);
> +		*vbar &= cpu_to_le32((u32)mask);
>  	} else if (pdev->resource[PCI_ROM_RESOURCE].flags &
>  					IORESOURCE_ROM_SHADOW) {
>  		mask = ~(0x20000 - 1);
>  		mask |= PCI_ROM_ADDRESS_ENABLE;
> -		*bar &= cpu_to_le32((u32)mask);
> +		*vbar &= cpu_to_le32((u32)mask);
>  	} else
> -		*bar = 0;
> +		*vbar = 0;
>  
>  	vdev->bardirty = false;
>  }
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index ee6ee91718a4..8a2c7607d513 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -86,8 +86,8 @@ struct vfio_pci_reflck {
>  
>  struct vfio_pci_device {
>  	struct pci_dev		*pdev;
> -	void __iomem		*barmap[PCI_STD_RESOURCE_END + 1];
> -	bool			bar_mmap_supported[PCI_STD_RESOURCE_END + 1];
> +	void __iomem		*barmap[PCI_STD_NUM_BARS];
> +	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
>  	u8			*pci_config_map;
>  	u8			*vconfig;
>  	struct perm_bits	*msi_perm;
> -- 
> 2.21.0
> 
