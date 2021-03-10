Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0032D3336DC
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCJICO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCJICF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:02:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFBDC06174A;
        Wed, 10 Mar 2021 00:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N8UCzR98Jt6vJfa17f+pjJWD3SJzTxoX5SicoIFhTp0=; b=cMmOgGhXrV4yOKYPxsK+qohPUM
        g0O1CVepJCqWPMhHA6YJDvQXdutVWG+8fY5F/+jM55VmxveFTEGAV+nKfQWAWEm9uIGBKs/ZIFle3
        Fcvi/FWL4ykwXTpX2t86u5DpzbmV2cb4SDg/80Nib143ygZBaBNaql4qK4hpAzxpkofGFSJiMzJMP
        hU3QxHtp5RcCXptnJGe+VZmuB1ia6kBu8Yye9+VrJmeCG1CGDlJ26P9OMakeKG35vrnkZF0gg3Ish
        NTHehMbdFYO48Tmtkf5O2igej0TzV+VMOW+bBMyfUxohJYKqSDigcymXyEynqGLCK6Qulalyr/DOE
        98l2CwDA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJtmv-002oEV-H2; Wed, 10 Mar 2021 08:01:52 +0000
Date:   Wed, 10 Mar 2021 08:01:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH v1 09/14] vfio/type1: Refactor pfn_list clearing
Message-ID: <20210310080149.GC662265@infradead.org>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524013398.3480.17180657517567370372.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524013398.3480.17180657517567370372.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +/* Return 1 if iommu->lock dropped and notified, 0 if done */

A bool would be more useful for that pattern.

> +static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
> +			      struct vfio_dma **dma_last, int *retries)
> +{
> +	if (!RB_EMPTY_ROOT(&dma->pfn_list)) {

Just return early when it is empty to remove a level of indentation for
the whole function?

> +		struct vfio_iommu_type1_dma_unmap nb_unmap;
> +
> +		if (*dma_last == dma) {
> +			BUG_ON(++(*retries) > 10);
> +		} else {
> +			*dma_last = dma;
> +			*retries = 0;
> +		}
> +
> +		nb_unmap.iova = dma->iova;
> +		nb_unmap.size = dma->size;
> +
> +		/*
> +		 * Notify anyone (mdev vendor drivers) to invalidate and
> +		 * unmap iovas within the range we're about to unmap.
> +		 * Vendor drivers MUST unpin pages in response to an
> +		 * invalidation.
> +		 */
> +		mutex_unlock(&iommu->lock);
> +		blocking_notifier_call_chain(&iommu->notifier,
> +					     VFIO_IOMMU_NOTIFY_DMA_UNMAP,
> +					     &nb_unmap);
> +		return 1;

Conditional locking is a horrible pattern.  I'd rather only factor the
code until before the unlock into the helper, and then leave the
unlock and notify to the caller to avoid that anti-pattern.

Also vendor driver isn't really Linux terminology for a subdriver,
so I'd suggest to switch to something else while you're at it.
