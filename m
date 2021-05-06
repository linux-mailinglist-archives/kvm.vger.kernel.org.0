Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487693753F4
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 14:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhEFMla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 08:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFMl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 08:41:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0E2C061574;
        Thu,  6 May 2021 05:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AD0sAWVYmtsdfX/1qJIycAe6dGL+6Xym4wYSSCA/ZWA=; b=Knv76pWNR7EX+umtx0kknr9/zW
        4Cx84E+uUtdIKOw4KBknZRa9rQPuT0UKAytjyAeaiFMGcMJ4sdRYQEIInv+qpSdRYCMcpKVqXmeM8
        oXVNFhIf44UIR9zDAFInNMjJjblZca0Anf3ctjCUibF1hVQRi80ZJXwY6SRx1K63KnNpE1vgB6VPt
        E4vSa1UKZABtpAxlJ7qAg7HydfpvAR2VWF3aweASqb7UutsrASrZUn3fqyWe16JycCnSUJ09amKrO
        zT6oKwD0Mp17uaT6tUtwluYyFgzDEl4j1/zUv3bfWWu7H5yEWIH0teZBPkkeOzymiWYVaZivVLRsf
        FdWzGOhQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ledGv-001iN8-3b; Thu, 06 May 2021 12:38:43 +0000
Date:   Thu, 6 May 2021 13:38:29 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <20210506123829.GA403858@infradead.org>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
 <20210506041057-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506041057-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 04:12:17AM -0400, Michael S. Tsirkin wrote:
> Let's try for just a bit, won't make this window anyway:
> 
> I have an old idea. Add a way to find out that unmap is a nop
> (or more exactly does not use the address/length).
> Then in that case even with DMA API we do not need
> the extra data. Hmm?

So we actually do have a check for that from the early days of the DMA
API, but it only works at compile time: CONFIG_NEED_DMA_MAP_STATE.

But given how rare configs without an iommu or swiotlb are these days
it has stopped to be very useful.  Unfortunately a runtime-version is
not entirely trivial, but maybe if we allow for false positives we
could do something like this

bool dma_direct_need_state(struct device *dev)
{
	/* some areas could not be covered by any map at all */
	if (dev->dma_range_map)
		return false;
	if (force_dma_unencrypted(dev))
		return false;
	if (dma_direct_need_sync(dev))
		return false;
	return *dev->dma_mask == DMA_BIT_MASK(64);
}

bool dma_need_state(struct device *dev)
{
	const struct dma_map_ops *ops = get_dma_ops(dev);

	if (dma_map_direct(dev, ops))
		return dma_direct_need_state(dev);
	return ops->unmap_page ||
		ops->sync_single_for_cpu || ops->sync_single_for_device;
}
