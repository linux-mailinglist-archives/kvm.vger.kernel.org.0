Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB6A46991B
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 15:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344430AbhLFOkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 09:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344364AbhLFOkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 09:40:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE5EC061746;
        Mon,  6 Dec 2021 06:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4l1EyDlzIIv+1SIRD0zZn4HUbfQJMuJ4Y2dEvO1gf1I=; b=Ae2mosQSSIN3/Ou9+CZAfKfpnP
        WOxt9x5/Z6YXFpVax628Ud7NOehUpL/RiSlkeCvSFaGy6mwZBbStPzxBATjSut3Vhrlj+uIOHJvsz
        aMLDZZCYdoOfEGEJSqpYWO8mQVMzrrsVDWx+P5CBjJVG+1jMa6wSv4fUkjoCk4Gq5RQUQqipuTWO6
        70i+4AOeEB/wBPZV3lA2N+ntCzKz68xJ5XThuwFTi0+Q8vVALv2RqdwOZkSxuf3hw8Q2NButSmMlU
        rFnRjQHr6vRqaalJaRX7Piori3OFsCeee3Q3hZGhWCOc9RxjBFhz13xw5CpwXp+N9HeZYrxG0mX/B
        AL8WRRsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1muF6R-004FGQ-GK; Mon, 06 Dec 2021 14:36:27 +0000
Date:   Mon, 6 Dec 2021 06:36:27 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <Ya4f662Af+8kE2F/@infradead.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206015903.88687-5-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I really hate the amount of boilerplate code that having this in each
bus type causes.

Between that and the suggestion from Joerg I wonder if we could do the
following again:

 - add new no_kernel_dma flag to struct device_driver
 - set this flag for the various vfio drivers
 - skip claiming the kernel dma ownership for those (or rather release
   it if the suggestion from Joerg works out)
