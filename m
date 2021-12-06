Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA3B4690FF
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 08:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhLFH6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 02:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhLFH6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 02:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7C7C0613F8;
        Sun,  5 Dec 2021 23:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A718B8100B;
        Mon,  6 Dec 2021 07:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53556C341C2;
        Mon,  6 Dec 2021 07:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638777292;
        bh=HHUnE2Gfs5Vvjz23mNZihfXP6yYatefE1twFLSI9jX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzmUkynWnHW5XZGrBtUotCZ+pnaRXBgpag2aEZkPbW+eoVqSM+zQ06cBKDqYmgO5b
         098y6mSOMXnbe4jBSl6e6yepDzcKO+5QwIWqw02UOqI8TIpDbmH/S+HbWCGO+MMW6W
         hWMoDrjfKsv7v2tp2tedUgPAaiVbTEAf6e/t9obo=
Date:   Mon, 6 Dec 2021 08:54:47 +0100
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
Subject: Re: [PATCH v3 04/18] driver core: platform: Add driver dma ownership
 management
Message-ID: <Ya3Bx7uDEs3VzP2G@kroah.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206015903.88687-5-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 09:58:49AM +0800, Lu Baolu wrote:
> Multiple platform devices may be placed in the same IOMMU group because
> they cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture. This
> checks and sets DMA ownership during driver binding, and release the
> ownership during driver unbinding.
> 
> Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
> claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
> the userspace framework drivers (vfio etc.) which need to manually claim
> DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/platform_device.h |  1 +
>  drivers/base/platform.c         | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 4381c34af7e0..f3926be7582f 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -210,6 +210,7 @@ struct platform_driver {
>  	struct device_driver driver;
>  	const struct platform_device_id *id_table;
>  	bool prevent_deferred_probe;
> +	bool suppress_auto_claim_dma_owner;

We now have "prevent_" and "suppress_" as prefixes.  Why the difference?

What is wrong with "prevent_" for your new flag?

thanks,

greg k-h
