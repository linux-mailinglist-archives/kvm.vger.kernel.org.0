Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AA04C7953
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 20:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiB1TzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 14:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiB1TzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 14:55:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF6B2AD8;
        Mon, 28 Feb 2022 11:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C2BCCE1850;
        Mon, 28 Feb 2022 19:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAD7C340F1;
        Mon, 28 Feb 2022 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646078059;
        bh=ONxRshZXU9sTf+2igTSe3xpdN1ybB8ozak/Pf50aaAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FQdVqA8T/y015/V6feFrGYtnl9N3bso2NN5eZ+xCOfi7Adw4x0bBZLjivwfnQ+Hnj
         XBKOAdDLk6HXa3gmIN+uyEXJ+PyCDCBcPc4eDzgQUVTcZMsFZiGH3EaE/y9r2Eghhn
         PdNvBu2OiFERxMOjWVBnhgney/Wk3CrpR8P6MqNG/YtyOoevR6JE5V4eaTwd/X2/Y6
         Q813ZsuDZSZxkXD3VFLyqpsRh54rXV5y3kFSAbiUyTHmXRkJprv4A6LDBPxTuhwQm7
         1bOzd9JpS/g7xCmxQfZH9v/ZcfHUgwJ6ExQWA0SwndMqlfAxAEsIUt5U0B7v0xOSY8
         GTD/XZl2dRNAQ==
Date:   Mon, 28 Feb 2022 13:54:18 -0600
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
Subject: Re: [PATCH v7 05/11] PCI: pci_stub: Set driver_managed_dma
Message-ID: <20220228195418.GA515725@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228005056.599595-6-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 08:50:50AM +0800, Lu Baolu wrote:
> The current VFIO implementation allows pci-stub driver to be bound to
> a PCI device with other devices in the same IOMMU group being assigned
> to userspace. The pci-stub driver has no dependencies on DMA or the
> IOVA mapping of the device, but it does prevent the user from having
> direct access to the device, which is useful in some circumstances.
> 
> The pci_dma_configure() marks the iommu_group as containing only devices
> with kernel drivers that manage DMA. For compatibility with the VFIO
> usage, avoid this default behavior for the pci_stub. This allows the
> pci_stub still able to be used by the admin to block driver binding after
> applying the DMA ownership to VFIO.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-stub.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
> index e408099fea52..d1f4c1ce7bd1 100644
> --- a/drivers/pci/pci-stub.c
> +++ b/drivers/pci/pci-stub.c
> @@ -36,6 +36,7 @@ static struct pci_driver stub_driver = {
>  	.name		= "pci-stub",
>  	.id_table	= NULL,	/* only dynamic id's */
>  	.probe		= pci_stub_probe,
> +	.driver_managed_dma = true,
>  };
>  
>  static int __init pci_stub_init(void)
> -- 
> 2.25.1
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
