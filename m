Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F3046BC72
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 14:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhLGN3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 08:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhLGN3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 08:29:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17835C061574;
        Tue,  7 Dec 2021 05:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KQcvNXZoBrFT1ECPJOgCbdB29JRbYvjVmyy9Ekguwm0=; b=IxkRHghcRV+MwUHxxCscISSv1H
        JWfGjMs6J311R3KzxeMKQI70SqgGVzCrJCSkjIwuHg5wb7rig3HLmlWtaxNXxhRS9M0uYVHmY4FYq
        9zAekfWiNA1jT70Bpx8ggBQ2xNGDJ53xYMGnppPu+sRvaPn32jNYy8djwi0z6jIewZK2kKhj0GpMo
        j0EAnGDM/jnBvjSKZOint4tBnJrmEGlO+r+RL9EGpgmAe/xvIFHdBZH656HyJQHdKtUiBOUzs4XfL
        pEb1dfxu7j5ZLekpnfWu2aT0F8F/urGkz6WlDf4GdSlHFsv3rI45VyGv4aXazeOOPXfsZ980MBNxY
        gE9V0xJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muaSu-008gW5-68; Tue, 07 Dec 2021 13:25:04 +0000
Date:   Tue, 7 Dec 2021 05:25:04 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <Ya9gsMmQnVdQ0hyj@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
 <Ya4f662Af+8kE2F/@infradead.org>
 <20211206150647.GE4670@nvidia.com>
 <56a63776-48ca-0d6e-c25c-016dc016e0d5@linux.intel.com>
 <20211207131627.GA6385@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207131627.GA6385@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 09:16:27AM -0400, Jason Gunthorpe wrote:
> Yes, the suggestion was to put everything that 'if' inside a function
> and then of course a matching undo function.

Can't we simplify things even more?  Do away with the DMA API owner
entirely, and instead in iommu_group_set_dma_owner iterate over all
devices in a group and check that they all have the no_dma_api flag
set (plus a similar check on group join).  With that most of the
boilerplate code goes away entirely in favor of a little more work at
iommu_group_set_dma_owner time.
