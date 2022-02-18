Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121674BB3A3
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 08:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiBRH4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 02:56:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiBRH4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 02:56:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A68C5597;
        Thu, 17 Feb 2022 23:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADEB161149;
        Fri, 18 Feb 2022 07:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E961C340E9;
        Fri, 18 Feb 2022 07:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645170962;
        bh=JsBUt67lBl87g1fuiSB/RVaxBrwVBKkrB8bcypGwUbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XjVsoi7Z/c+mYAKm2LjxR3hGvRBIU7XQJoO6tsa+cHUPWw30wEuaSNTYh+DEr7FHM
         ZWb6zwn2JYPBg2Kbu1EGRMM9F2KIASyi/prYKPfl9J3pOSF4OUgUNFm5B34LPjRztj
         +vyImsRb8HTKGQ5Nuj2bYg19qwl3sgp0q0WpEHlY=
Date:   Fri, 18 Feb 2022 08:55:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/11] bus: platform,amba,fsl-mc,PCI: Add device DMA
 ownership management
Message-ID: <Yg9RD3OHGl73Ag1P@kroah.com>
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218005521.172832-5-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022 at 08:55:14AM +0800, Lu Baolu wrote:
> The devices on platform/amba/fsl-mc/PCI buses could be bound to drivers
> with the device DMA managed by kernel drivers or user-space applications.
> Unfortunately, multiple devices may be placed in the same IOMMU group
> because they cannot be isolated from each other. The DMA on these devices
> must either be entirely under kernel control or userspace control, never
> a mixture. Otherwise the driver integrity is not guaranteed because they
> could access each other through the peer-to-peer accesses which by-pass
> the IOMMU protection.
> 
> This checks and sets the default DMA mode during driver binding, and
> cleanups during driver unbinding. In the default mode, the device DMA is
> managed by the device driver which handles DMA operations through the
> kernel DMA APIs (see Documentation/core-api/dma-api.rst).
> 
> For cases where the devices are assigned for userspace control through the
> userspace driver framework(i.e. VFIO), the drivers(for example, vfio_pci/
> vfio_platfrom etc.) may set a new flag (driver_managed_dma) to skip this
> default setting in the assumption that the drivers know what they are
> doing with the device DMA.
> 
> With the IOMMU layer knowing DMA ownership of each device, above problem
> can be solved.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Stuart Yoder <stuyoder@gmail.com>
> Cc: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/amba/bus.h        |  8 ++++++++
>  include/linux/fsl/mc.h          |  8 ++++++++
>  include/linux/pci.h             |  8 ++++++++
>  include/linux/platform_device.h |  8 ++++++++
>  drivers/amba/bus.c              | 20 ++++++++++++++++++++
>  drivers/base/platform.c         | 20 ++++++++++++++++++++
>  drivers/bus/fsl-mc/fsl-mc-bus.c | 26 ++++++++++++++++++++++++--
>  drivers/pci/pci-driver.c        | 21 +++++++++++++++++++++
>  8 files changed, 117 insertions(+), 2 deletions(-)

For the platform.c stuff:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


thanks for renaming this.

greg k-h
