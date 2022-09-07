Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ACD5B069F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 16:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiIGOar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 10:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIGOaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 10:30:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E502A73D;
        Wed,  7 Sep 2022 07:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2l7eopzr/mSNZZDgV9tkZ0XntKy0XuXzIO3nOXotg4k=; b=mphsyxJhKDUVK5RBxhAHtdvWi2
        jNXtUct8LS44ITwnw64hqzo5kmIoDqPPUfWhWRMMO9OVboa7RdnB/GgkKGPxIMze414KcEXmOK3YN
        YxA8NSddMLrJckJZPfmTtDmRgHm/roVjbPbxC2t5VRr1H/0IgHUqVEZzkohOgjihNHiuofn/2bGAl
        UcAznerDMMF+UDGBUALmm7NCuygA/ThL9g/gWRrjk9RfqBtvZpIsloJ++xyq2uKLzjfYrjeLGM+Th
        WvVI1AEZNBUmFfnKZMkimlU2X7IX14CSGkaTMPpOHytqtoyJn6BOtRHBv8VXuHM3jsAXU67bb0rxL
        zXAGAdUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVw3y-006tuK-Vl; Wed, 07 Sep 2022 14:29:58 +0000
Date:   Wed, 7 Sep 2022 07:29:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Oded Gabbay <ogabbay@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <Yxiq5sjf/qA7xS8A@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org>
 <YxiPh4u/92chN02C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxiPh4u/92chN02C@nvidia.com>
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

On Wed, Sep 07, 2022 at 09:33:11AM -0300, Jason Gunthorpe wrote:
> Yes, you said that, and I said that when the AMD driver first merged
> it - but it went in anyhow and now people are using it in a bunch of
> places.

drm folks made up their own weird rules, if they internally stick
to it they have to listen to it given that they ignore review comments,
but it violates the scatterlist API and has not business anywhere
else in the kernel.  And yes, there probably is a reason or two why
the drm code is unusually error prone.

> > Why would small BARs be problematic for the pages?  The pages are more
> > a problem for gigantic BARs do the memory overhead.
> 
> How do I get a struct page * for a 4k BAR in vfio?

I guess we have different definitions of small then :)

But unless my understanding of the code is out out of data,
memremap_pages just requires the (virtual) start address to be 2MB
aligned, not the size.  Adding Dan for comments.

That being said, what is the point of mapping say a 4k BAR for p2p?
You're not going to save a measurable amount of CPU overhead if that
is the only place you transfer to.
