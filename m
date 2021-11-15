Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCBE450540
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhKONXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhKONWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:22:16 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F643C061207;
        Mon, 15 Nov 2021 05:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=69jae/wjyQfkyaDaAim/24/42ZGsXhbhGlXLbyRhrMU=; b=yAo36Onanje4bf94Z46twaSwfn
        pnAWuBY6xcx2AvbUZlko+Bqska2HYn9n4YMse1lB4EyF5WvSoMIEqJuv8BelI0bf40ea3FNSejYUC
        n58rgjMnllP7V9cZHuQQFvWsX2s8EXm+GXBz389X8cWQVcDl5LMhlDOoHEf1bbDAgOsziF8WVS70I
        Tk4pgIEVi+Y/HfbAHeg0VYU35QtCKa8aeWK+wInu5qhspe+2XIuxknoOydCrjxDTlVTjKWbs+tuY3
        5aUzbHkO7J4mCDo7IxtWVtVD3rf9SN8+5AFlpBvhpFhAFZNbbsMD6qTKdrB7zM7ZoXR1dFOqonWQW
        4TjlWxyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbt0-00FdmM-EI; Mon, 15 Nov 2021 13:19:02 +0000
Date:   Mon, 15 Nov 2021 05:19:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YZJeRomcJjDqDv9q@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-3-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:43AM +0800, Lu Baolu wrote:
> @@ -566,6 +567,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  		goto done;
>  	}
>  
> +	if (!drv->suppress_auto_claim_dma_owner) {
> +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL, NULL);
> +		if (ret)
> +			return ret;
> +	}

I'd expect this to go into iommu_setup_dma_ops (and its arm and s390
equivalents), as that is what claims an IOMMU for in-kernel usage
