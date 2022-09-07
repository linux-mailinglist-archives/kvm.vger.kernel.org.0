Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58D55B086F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiIGPXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiIGPXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:23:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11A7B69CA;
        Wed,  7 Sep 2022 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=BcNIY2A5Ly0NVEPOgKCjZNwABZLi+n/SzSXVZWXlSVk=; b=xIWn7jJIvte4o9iMUtkRREt3f0
        BRgZUmNIzYgCa5tmtZ9nBKViJYapzQV1p6WxYLbAQaiZCiKu5JWRHGktRBxzU751H3L8t25lEqK8a
        F8QDMVWX984jCkXgYLIgl9uNv/2gEHsTwiYarCe5wlvIypBCIOjnQ7l+mp8cbz0MbRRJMDlo3gTsR
        qvNf77EoZcMP/Dl8fiq4Q8pueQQGY4xUgPlNWdfp/IO+AVtBvvW/Vi6H1NeI6IU0/J9D05KHtbJ7t
        9UzSAffrFHiq5pTccuTCB3MFIBAm/GOUGQqHM6hp7zfPXb2j/JffgczYTL8XIJdLKBuE/QoeC1SXW
        BeJWkEoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVwtk-007JlI-GO; Wed, 07 Sep 2022 15:23:28 +0000
Date:   Wed, 7 Sep 2022 08:23:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
Message-ID: <Yxi3cClg39/QX+gP@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxiIkh/yeWQkZ54x@infradead.org>
 <58d6e892-82df-7aa7-4798-9e5da7c634ad@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58d6e892-82df-7aa7-4798-9e5da7c634ad@amd.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 05:08:37PM +0200, Christian König wrote:
> The key point is that you can't do any CPU fallback with this as long as the
> CPU wouldn't do exactly the same thing as the original hardware device. E.g.
> not write combine nor do any fully page copies etc...

That is true for MMIO in general.  You need to use the mmio accessors,
and even then it needs to match what the hardware expects

> This is not even a memory write, but rather just some trigger event. That's
> essentially the background why I think having struct pages and sg_tables
> doesn't make any sense at all for this use case.

Well, Jasons patch uses a sg_table, just in a very broken way.

> > > Would you mind if I start to tackle this problem?
> > Yes, I've been waiting forever for someone to tacke how the scatterlist
> > is abused in dma-buf..
> 
> How about we separate the scatterlist into page and DMA address container?

As said before that is fundamentally the right thing to do.  It just
takes a lot of work.  I think on the dma mapping side we're finally
getting ready for it now that arm uses the common dma-direct code,
although getting rid of the arm iommu ops first would be even better.

Note that this only solves the problem of needing the pages to hold
the physical address.  The other thing the pages are used for in p2p
is that (through the pgmap) it points to the owning device of the p2p
memory and thus allows figuring out how it needs to be accessed.
