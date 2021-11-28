Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD31F460536
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 09:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356943AbhK1IKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 03:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356950AbhK1IIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 03:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182BAC061746;
        Sun, 28 Nov 2021 00:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA4A60F78;
        Sun, 28 Nov 2021 08:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BFC004E1;
        Sun, 28 Nov 2021 08:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638086583;
        bh=c1E12B24n2UtL0dGKDH+q6K5l5U1okMOFCx+76uFZHI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=brdjryZqUIgLGgqgV7RXAsoWJa7Gj6kzflFAjHTU+uDtldSFpsqovul15jP5MJqvn
         AEHZY3urZnY/MXvBXTJcQtBEv/X5SXU+ukuKqYjYk7NFUScRq/I+5tl8yY8AxQz/SH
         iEMbnQNq5gAF+6EiGYtS9C4hzqDRuqwNwNqdualk=
Date:   Sun, 28 Nov 2021 09:02:58 +0100
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/17] driver core: Add dma_unconfigure callback in
 bus_type
Message-ID: <YaM3slBGozqxsQ+m@kroah.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <20211128025051.355578-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128025051.355578-3-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 10:50:36AM +0800, Lu Baolu wrote:
> The bus_type structure defines dma_configure() callback for bus drivers
> to configure DMA on the devices. This adds the paired dma_unconfigure()
> callback and calls it during driver unbinding so that bus drivers can do
> some cleanup work.
> 
> One use case for this paired DMA callbacks is for the bus driver to check
> for DMA ownership conflicts during driver binding, where multiple devices
> belonging to a same IOMMU group (the minimum granularity of isolation and
> protection) may be assigned to kernel drivers or user space respectively.
> 
> Without this change, for example, the vfio driver has to listen to a bus
> BOUND_DRIVER event and then BUG_ON() in case of dma ownership conflict.
> This leads to bad user experience since careless driver binding operation
> may crash the system if the admin overlooks the group restriction. Aside
> from bad design, this leads to a security problem as a root user, even with
> lockdown=integrity, can force the kernel to BUG.
> 
> With this change, the bus driver could check and set the DMA ownership in
> driver binding process and fail on ownership conflicts. The DMA ownership
> should be released during driver unbinding.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-iommu/20210922123931.GI327412@nvidia.com/
> Link: https://lore.kernel.org/linux-iommu/20210928115751.GK964074@nvidia.com/
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/device/bus.h | 3 +++
>  drivers/base/dd.c          | 7 ++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
> index a039ab809753..ef54a71e5f8f 100644
> --- a/include/linux/device/bus.h
> +++ b/include/linux/device/bus.h
> @@ -59,6 +59,8 @@ struct fwnode_handle;
>   *		bus supports.
>   * @dma_configure:	Called to setup DMA configuration on a device on
>   *			this bus.
> + * @dma_unconfigure:	Called to cleanup DMA configuration on a device on
> + *			this bus.

"dma_cleanup()" is a better name for this, don't you think?

thanks,

greg k-h
