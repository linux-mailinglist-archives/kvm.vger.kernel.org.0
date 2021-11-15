Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC24520D5
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 01:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347437AbhKPA4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 19:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbhKOTUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BECC077949;
        Mon, 15 Nov 2021 10:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/j1kGg3Y3gXXMCKBT/FlrMPEzAkt4b0LfzEg1w0LaRY=; b=MiHTez0Qf+wX+jRQ5B/3EkMeSB
        TvxNL1Ov34NgD3bwoIg17g3//hLJW1J9conA8mIU+92DauDmRpeOBfGqiA+NBBYGONoovgPDaaoeT
        E9hbRqrey5lkoxXaOlQSqb3RveB7VNobb8j6oZMXpGtHVa1EjZvb84ijRMjafDoYjn/qi06lzFIA4
        t08ygSB4+Hxt81yRGLr3p5uBd+TEtPKsvy2hqjw+oLQ+qHd5zgxTZAGfK6xvoDdQihW4H2ydtA27R
        ylOo0xgaDgmTlW9rxr1QiFESRAn1mAZ7WrFwnQuCKV/52trgg6FZ6tiCPD0OlfG2au6V0ORG4Dkg6
        C8px0TLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmgVX-00Ge06-LZ; Mon, 15 Nov 2021 18:15:07 +0000
Date:   Mon, 15 Nov 2021 10:15:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YZKjq3sXb9+UTDSz@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZJeRomcJjDqDv9q@infradead.org>
 <20211115132442.GA2379906@nvidia.com>
 <8499f0ab-9701-2ca2-ac7a-842c36c54f8a@arm.com>
 <20211115155613.GA2388278@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115155613.GA2388278@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 11:56:13AM -0400, Jason Gunthorpe wrote:
> drivers/base/platform.c:        .dma_configure  = platform_dma_configure,
> drivers/bus/fsl-mc/fsl-mc-bus.c:        .dma_configure  = fsl_mc_dma_configure,
> drivers/pci/pci-driver.c:       .dma_configure  = pci_dma_configure,
> drivers/gpu/host1x/bus.c:       .dma_configure = host1x_dma_configure,
> 
> Other than host1x they all work with VFIO.
> 
> Also, there is no bus->dma_unconfigure() which would be needed to
> restore the device as well.
> 
> So, would you rather see duplicated code into the 4 drivers, and a new
> bus op to 'unconfigure dma'

The tend to mostly call into common helpers eventually.

> 
> Or, a 'dev_configure_dma()' function that is roughly:
> 
>         if (dev->bus->dma_configure) {
>                 ret = dev->bus->dma_configure(dev);
>                 if (ret)
>                         return ret;
>                 if (!drv->suppress_auto_claim_dma_owner) {
>                        ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL,
>                                                         NULL);
>                        if (ret)
>                                ret;
>                 }
>          }
> 
> And a pair'd undo.

But that seems like an even better idea to me.  Even better with an
early return and avoiding the pointless indentation.
