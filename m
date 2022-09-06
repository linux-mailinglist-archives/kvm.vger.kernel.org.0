Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0680B5AE4CD
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiIFJvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 05:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239192AbiIFJvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 05:51:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17856DFAD;
        Tue,  6 Sep 2022 02:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8/NrZAK5q7MnGYfTuWbWU8dghg9PZc1WBiUJ2nOuaC4=; b=IAyCiQiRvm+ndIADZzUDg2ER2+
        8Kz7YGsP3iYQq/EykkXdB+9anNfClC1OCd4udP7exSyBmsfShITgu4AW/cekmSy00tpbcV6w4Z3ZZ
        CTMbiYiO7uLS00CKzrENWw+PQGegQwk90oJdjBXZmHwsjYekKt9L6qB7xjRqB8yDzIrx9UJL2ta09
        9Cz4KilqnGfnvm3x2ffIqJ9TDiR0OTwKzgUuzbHyespz4Z5GO5DTrsxW6DHKFoR9/VyJfyCj3vTwx
        ++lwBFxBrxfqK99GFdt/TfVWWYD9+Lw5yNmEk+PUrQtcDxl8AOZh3hu+Djvhp+LkaWj2Ifs4NGa/j
        bvHemi+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVVEq-00C5Pm-08; Tue, 06 Sep 2022 09:51:24 +0000
Date:   Tue, 6 Sep 2022 02:51:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Cornelia Huck <cohuck@redhat.com>,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Oded Gabbay <ogabbay@kernel.org>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <YxcYGzPv022G2vLm@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +{
> +	struct vfio_pci_dma_buf *priv = dmabuf->priv;
> +	int rc;
> +
> +	rc = pci_p2pdma_distance_many(priv->vdev->pdev, &attachment->dev, 1,
> +				      true);

This should just use pci_p2pdma_distance.

> +	/*
> +	 * Since the memory being mapped is a device memory it could never be in
> +	 * CPU caches.
> +	 */

DMA_ATTR_SKIP_CPU_SYNC doesn't even apply to dma_map_resource, not sure
where this wisdom comes from.

> +	dma_addr = dma_map_resource(
> +		attachment->dev,
> +		pci_resource_start(priv->vdev->pdev, priv->index) +
> +			priv->offset,
> +		priv->dmabuf->size, dir, DMA_ATTR_SKIP_CPU_SYNC);

This is not how P2P addresses are mapped.  You need to use
dma_map_sgtable and have the proper pgmap for it.

The above is just a badly implemented version of the dma-direct
PCI_P2PDMA_MAP_BUS_ADDR case, ignoring mappings through the host
bridge or dma-map-ops interactions.
