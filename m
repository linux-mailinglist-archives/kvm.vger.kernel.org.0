Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1435905B0
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHPQXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Aug 2019 12:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfHPQXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Aug 2019 12:23:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2ABD3084295;
        Fri, 16 Aug 2019 16:23:49 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F213F27C49;
        Fri, 16 Aug 2019 16:23:48 +0000 (UTC)
Date:   Fri, 16 Aug 2019 10:23:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] vfio_pci: Loop using PCI_STD_NUM_BARS
Message-ID: <20190816102347.781a2ee1@x1.home>
In-Reply-To: <20190816092437.31846-9-efremov@linux.com>
References: <20190816092437.31846-1-efremov@linux.com>
        <20190816092437.31846-9-efremov@linux.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 16 Aug 2019 16:23:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Aug 2019 12:24:35 +0300
Denis Efremov <efremov@linux.com> wrote:

> Refactor loops to use 'i < PCI_STD_NUM_BARS' instead of
> 'i <= PCI_STD_RESOURCE_END'.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 11 +++++++----
>  drivers/vfio/pci/vfio_pci_config.c  | 10 ++++++----
>  drivers/vfio/pci/vfio_pci_private.h |  4 ++--
>  3 files changed, 15 insertions(+), 10 deletions(-)
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
> index f0891bd8444c..df8772395219 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -455,16 +455,18 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
>  
>  	bar = (__le32 *)&vdev->vconfig[PCI_BASE_ADDRESS_0];
>  
> -	for (i = PCI_STD_RESOURCES; i <= PCI_STD_RESOURCE_END; i++, bar++) {
> -		if (!pci_resource_start(pdev, i)) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++, bar++) {
> +		int ibar = i + PCI_STD_RESOURCES;
> +
> +		if (!pci_resource_start(pdev, ibar)) {
>  			*bar = 0; /* Unmapped by host = unimplemented to user */
>  			continue;
>  		}
>  
> -		mask = ~(pci_resource_len(pdev, i) - 1);
> +		mask = ~(pci_resource_len(pdev, ibar) - 1);
>  
>  		*bar &= cpu_to_le32((u32)mask);
> -		*bar |= vfio_generate_bar_flags(pdev, i);
> +		*bar |= vfio_generate_bar_flags(pdev, ibar);
>  
>  		if (*bar & cpu_to_le32(PCI_BASE_ADDRESS_MEM_TYPE_64)) {
>  			bar++;

It might be a bit cleaner to rename the 'bar' variable to 'vbar', then
we have 'bar' available to use as the BAR number.  It seems more
consistent with other uses.  Otherwise the logic looks fine.  Thanks,

Alex

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

