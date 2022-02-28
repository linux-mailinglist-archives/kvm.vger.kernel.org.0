Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56284C7926
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 20:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiB1T5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 14:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiB1T5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 14:57:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453A9140C4;
        Mon, 28 Feb 2022 11:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D009D60A5B;
        Mon, 28 Feb 2022 19:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E835BC340F1;
        Mon, 28 Feb 2022 19:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646078190;
        bh=0OOU4ypDKyXvi1uajjSPnUmhPXeaSTp6ukVsSrlQHcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RTXisNBZzA45iz5I1nD1Q49iYcdgMwiouYVpm5sJdmQu/9H3Ov4Fq04ogI46PGsIA
         oaBc37LVfwkKEZGCfFvr/j6nXxvPNIVuYPdJshypg2oWys6+aYhwo/oVHDZ0rhpKY+
         +4mXh3fKy9RPjTyNheqYMVhvd9FlT6UZqMOgAL17c9ULCYs2cORvz/yNnrsPYMQQc0
         UsPcu4z97fXmbKmf7hrkgc98uhwRfmsW9ncPZar9gWRTnnR+05/5gM/is7Mp1mvv7y
         7xb/Zt2d7+4d+67ra8MyvoYhvG1UD37XJaFlwAMYuOJcjBzVy9IrI4UHnH5VWgi1+a
         HJ04Qzzd6J+DA==
Date:   Mon, 28 Feb 2022 13:56:28 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v7 06/11] PCI: portdrv: Set driver_managed_dma
Message-ID: <20220228195628.GA515785@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228005056.599595-7-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 08:50:51AM +0800, Lu Baolu wrote:
> If a switch lacks ACS P2P Request Redirect, a device below the switch can
> bypass the IOMMU and DMA directly to other devices below the switch, so
> all the downstream devices must be in the same IOMMU group as the switch
> itself.
> 
> The existing VFIO framework allows the portdrv driver to be bound to the
> bridge while its downstream devices are assigned to user space. The
> pci_dma_configure() marks the IOMMU group as containing only devices
> with kernel drivers that manage DMA. Avoid this default behavior for the
> portdrv driver in order for compatibility with the current VFIO usage.

It would be nice to explicitly say here how we can look at portdrv
(and pci_stub) and conclude that ".driver_managed_dma = true" is safe.

Otherwise I won't know what kind of future change to portdrv might
make it unsafe.

> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pcie/portdrv_pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 35eca6277a96..6b2adb678c21 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
>  
>  	.err_handler	= &pcie_portdrv_err_handler,
>  
> +	.driver_managed_dma = true,
> +
>  	.driver.pm	= PCIE_PORTDRV_PM_OPS,
>  };
>  
> -- 
> 2.25.1
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
