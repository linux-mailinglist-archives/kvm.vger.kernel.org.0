Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08264B4D15
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiBNKtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:49:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349297AbiBNKtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:49:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC44BBF968;
        Mon, 14 Feb 2022 02:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D9B61073;
        Mon, 14 Feb 2022 10:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EBAC340E9;
        Mon, 14 Feb 2022 10:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833550;
        bh=7NYDUafZDceGQPElb2hl+Hd5rp37LJZRhhfQjS2vSeY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIA94p4J7BkmTeN192s/A8IemcJzGjBWor/XAvftRUl2OnKHj1JcdIwkXM4WhhTxP
         eoyys+e7YJRpTBpF2UCcoDVWqVl1VgB1QoSg6p9zpK4lEQhSYTPSD0yqpnvZlZC4Fh
         YvBMlrTmTr8m62V/aKo0ZVrsFC30ht5DbB/euNWo=
Date:   Mon, 14 Feb 2022 11:03:42 +0100
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
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <Ygoo/lCt/G6tWDz9@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104015644.2294354-8-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/pci.h      |  5 +++++
>  drivers/pci/pci-driver.c | 21 +++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 18a75c8e615c..d29a990e3f02 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -882,6 +882,10 @@ struct module;
>   *              created once it is bound to the driver.
>   * @driver:	Driver model structure.
>   * @dynids:	List of dynamically added device IDs.
> + * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
> + *		Drivers which don't require DMA or want to manually claim the
> + *		owner type (e.g. userspace driver frameworks) could set this
> + *		flag.

Again with the bikeshedding, but this name is a bit odd.  Of course it's
in the kernel, this is all kernel code, so you can drop that.  And
again, "negative" flags are rough.  So maybe just "prevent_dma"?

thanks,

greg k-h
