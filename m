Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9AD8A7BF
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfHLUCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 16:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfHLUCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 16:02:37 -0400
Received: from localhost (c-73-15-1-175.hsd1.ca.comcast.net [73.15.1.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0576E20673;
        Mon, 12 Aug 2019 20:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565640156;
        bh=Hgk9UHUApZbtNg0FsoyC8h3y2/SPiTA/8aD6c1C2q1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rdr60RX2R/Kwwbm8L8fg+qjER6l4hEvSUfwp4dAeHw7HUMBwjS4UBPqy0DaXyKeG7
         NmoeKjgYEs00MC6AXfpOs6FtGWGnwQBAeWhcJlHRI+Ivvw5YvAFozLQxd17QAsQ8YR
         NkiuR2QrV9RdDhoaYA6qsmR2u15/hxnQlETY5MV4=
Date:   Mon, 12 Aug 2019 15:02:34 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] vfio_pci: Use PCI_STD_NUM_BARS in loops instead of
 PCI_STD_RESOURCE_END
Message-ID: <20190812200234.GE11785@google.com>
References: <20190811150802.2418-1-efremov@linux.com>
 <20190811150802.2418-8-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811150802.2418-8-efremov@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 11, 2019 at 06:08:04PM +0300, Denis Efremov wrote:
> This patch refactors the loop condition scheme from
> 'i <= PCI_STD_RESOURCE_END' to 'i < PCI_STD_NUM_BARS'.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 4 ++--
>  drivers/vfio/pci/vfio_pci_config.c  | 2 +-
>  drivers/vfio/pci/vfio_pci_private.h | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 703948c9fbe1..13f5430e3f3c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -115,7 +115,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
>  
>  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
>  
> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> +	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>  		res = vdev->pdev->resource + bar;

PCI_STD_RESOURCES is indeed 0, but since the original went to the
trouble of avoiding that assumption, I would probably do this:

        for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
                res = vdev->pdev->resource + bar + PCI_STD_RESOURCES;

or maybe even this:

                res = &vdev->pdev->resource[bar + PCI_STD_RESOURCES];

which is more common outside vfio.  But I wouldn't change to using the
&dev->resource[] form if other vfio code that you're *not* changing
uses the dev->resource + bar form.

>  		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> @@ -399,7 +399,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  
>  	vfio_config_free(vdev);
>  
> -	for (bar = PCI_STD_RESOURCES; bar <= PCI_STD_RESOURCE_END; bar++) {
> +	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
>  		if (!vdev->barmap[bar])
>  			continue;
>  		pci_iounmap(pdev, vdev->barmap[bar]);
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index f0891bd8444c..6035a2961160 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -455,7 +455,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>  
>  	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>  
> -	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++, bar++) {
>  		if (!pci_resource_start(pdev, i)) {
>  			*bar = 0; /* Unmapped by host = unimplemented to user */
>  			continue;
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
