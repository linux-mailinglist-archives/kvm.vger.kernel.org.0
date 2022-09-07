Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70825B0396
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiIGMGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 08:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIGMGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 08:06:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B4E87696;
        Wed,  7 Sep 2022 05:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PL4jqJSZwguCLJFS7x1XcjFdKcqtAwO9wLYAU4zCSeY=; b=B1zQg9TljsLy1gW4922VnSw5a7
        /1ZBtwdH0raFVAxXXejqmksPyqcSXzbTlcgd8KVyQKkoDSUO+YCd1mW4VK/Mbt3LOK4j13rEhwZVX
        ovAQe/bl2lc/X88QINqsfbL+MrXEUa2mLdvKbhmdBgiC170xmQIuyOGybhCrYlcqMicTMOSN1saz8
        f/+F5YbhE/kuzf0Bu7WtM4MNPeXtFX+U7tMBeIRW1nXq208fEenOgB4CM0rDeAZcmlz44DzbxK3Wh
        GTrbSP4P/at1OZnaYZqlkWf+0uygb45WyZFbxkQHVGcaw+cE3RA1op17K1aNKmOqGKnzTz5+4JSlu
        wDM/3fBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVtoc-005x71-0M; Wed, 07 Sep 2022 12:05:58 +0000
Date:   Wed, 7 Sep 2022 05:05:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <YxiJJYtWgh1l0wxg@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxczjNIloP7TWcf2@nvidia.com>
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

On Tue, Sep 06, 2022 at 08:48:28AM -0300, Jason Gunthorpe wrote:
> Right, this whole thing is the "standard" that dmabuf has adopted
> instead of the struct pages. Once the AMD GPU driver started doing
> this some time ago other drivers followed.

But it is simple wrong.  The scatterlist requires struct page backing.
In theory a physical address would be enough, but when Dan Williams
sent patches for that Linus shot them down.

That being said the scatterlist is the wrong interface here (and
probably for most of it's uses).  We really want a lot-level struct
with just the dma_address and length for the DMA side, and leave it
separate from that what is used to generate it (in most cases that
would be a bio_vec).

> Now we have struct pages, almost, but I'm not sure if their limits are
> compatible with VFIO? This has to work for small bars as well.

Why would small BARs be problematic for the pages?  The pages are more
a problem for gigantic BARs do the memory overhead.
