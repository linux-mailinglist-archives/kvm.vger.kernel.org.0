Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ECF4C1A80
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbiBWSBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiBWSBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:01:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82299424AF;
        Wed, 23 Feb 2022 10:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 283EE615BC;
        Wed, 23 Feb 2022 18:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49542C340E7;
        Wed, 23 Feb 2022 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645639258;
        bh=MKgM7o1ruy/HHVrV8jzkBEnkhlTNGQHGNcPOUmal/Q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Dn9BdjkvSFawU2lRdlkhhaSUHY0lCFtqhfLoKAK0O5Q6lp8y32dKlD7/1KueDIBVC
         2smUZEzG53JpiSnGMJ5sz0cYdkxfejWfGkoiEkmSkV2eEkwFtRel2evULq9t0gm/km
         /5KDF/pJP3ThdwCXxRAy3z8ZIpxrAvwaovzYBRkJ37rWa8Iaayi9FBz9pttnDrdMIJ
         rFgDagq7fBLz5dnl1Y0h8s9pZtEuUTRHFDkfWFwk+fNNFWxCVL6bwa+72WYubKLSE7
         mGAWO5e+SRHCPaNEKctvp7KtwZoO1w8nqoHA96iW90gagwxbfWorKsET1bawbW4lR3
         5r0Uhb1e3kvzA==
Date:   Wed, 23 Feb 2022 12:00:56 -0600
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
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <20220223180056.GA140951@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104015644.2294354-8-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In subject,

s/dma/DMA/ to match the other patches

On Tue, Jan 04, 2022 at 09:56:37AM +0800, Lu Baolu wrote:
> Multiple PCI devices may be placed in the same IOMMU group because
> they cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture. This
> checks and sets DMA ownership during driver binding, and release the
> ownership during driver unbinding.
> 
> The device driver may set a new flag (no_kernel_api_dma) to skip calling
> iommu_device_use_dma_api() during the binding process. For instance, the
> userspace framework drivers (vfio etc.) which need to manually claim
> their own dma ownership when assigning the device to userspace.

s/vfio/VFIO/ when used as an acronym (occurs in several patches)

> + * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
> + *		Drivers which don't require DMA or want to manually claim the
> + *		owner type (e.g. userspace driver frameworks) could set this
> + *		flag.

s/Drivers which/Drivers that/

>  static int pci_dma_configure(struct device *dev)
>  {
> +	struct pci_driver *driver = to_pci_driver(dev->driver);
>  	struct device *bridge;
>  	int ret = 0;
>  
> +	if (!driver->no_kernel_api_dma) {

Ugh.  Double negative, totally agree this needs a better name that
reverses the sense.  Every place you use it, you negate it again.

> +	if (ret && !driver->no_kernel_api_dma)
> +		iommu_device_unuse_dma_api(dev);

> +static void pci_dma_cleanup(struct device *dev)
> +{
> +	struct pci_driver *driver = to_pci_driver(dev->driver);
> +
> +	if (!driver->no_kernel_api_dma)
> +		iommu_device_unuse_dma_api(dev);
