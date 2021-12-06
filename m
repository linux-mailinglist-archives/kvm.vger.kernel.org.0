Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA614698F8
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbhLFOdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344284AbhLFOdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:33:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2D9C0613F8;
        Mon,  6 Dec 2021 06:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wUoLiSn51OKyZKPLXHrwnmgPjRpnvpvyNU8vXyEVvE8=; b=il/9NTD05MPaaylKKrpQt7dzHY
        zRXxWas+vo63olsRGM5IHckhvmwDXk98hanMLtbb6G6BTqx/SBYZhyb0iJu1VHK8gMMFJg3/ii79E
        vkaK/17F0Gxg4Kz9YGlf7eUiQeE5b6L0CohSjfbMgZ5+I3GgHR2lUenGJ4VKKOp8PLPERyCTilzUQ
        NcTsKC59hEftqUDEmNZPvaofOh5AgkPoccTcIo/Prhs6+evpXQK7jTZrpVCDMXhynTDiTclNXaST7
        ZyQ2bRRXXrCecJJgNMesx9hpA5gBbnw8EcfoFlBzTs1srWc2Uk6+9Eqev46AHJz0LZ2kExspIggfr
        hZdb/3Sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muF01-004Cm0-LS; Mon, 06 Dec 2021 14:29:49 +0000
Date:   Mon, 6 Dec 2021 06:29:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH v3 01/18] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <Ya4eXZtdMGhEP7GO@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-2-baolu.lu@linux.intel.com>
 <Ya4Ru/GtILJYzI6j@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya4Ru/GtILJYzI6j@8bytes.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 02:35:55PM +0100, Joerg Roedel wrote:
> >                 enum iommu_dma_owner type, void *owner_cookie);
> >         void iommu_device_release_dma_owner(struct device *dev,
> >                 enum iommu_dma_owner type);
> 
> It the owner is a group-wide setting, it should be called with the group
> instead of the device. I have seen the group-specific funcitons are
> added later, but that leaves the question why the device-specific ones
> are needed at all.

They aren't really.  A lot of bus drivers need helpers to set/release
the dma API domain if there is an iommu group, but tegra which actually
sets a non-default value would be much better off with just open coding
them.

> > @@ -621,6 +624,7 @@ struct iommu_group *iommu_group_alloc(void)
> >  	INIT_LIST_HEAD(&group->devices);
> >  	INIT_LIST_HEAD(&group->entry);
> >  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> > +	group->dma_owner = DMA_OWNER_NONE;
> 
> 
> DMA_OWNER_NONE is also questionable. All devices are always in one
> domain, and the default domain is always the one used for DMA-API, so
> why isn't the initial value DMA_OWNER_DMA_API?

The interesting part is the suppress_auto_claim_dma_owner flag, but it
might make more sense to release the dma API ownership for that rather
than requesting it if it is not set.
