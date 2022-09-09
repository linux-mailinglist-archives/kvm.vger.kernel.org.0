Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBB75B38E0
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiIINYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 09:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIINYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 09:24:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D118375;
        Fri,  9 Sep 2022 06:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iY0w1kh/xK+MCzo1rcnqvZqdmGxlHyuGkIUEG2fe/n0=; b=3wAl0TxsoTvU4WSk/aqxa6e9u/
        30XUqAlq7pk+SKpG5MSQFbT0MoWDiD1aYo7F1FJ3DrSUU/9qFFxdzWUyN2J66hZuW72TG3hUIDZdP
        P42VoYLJin+mebeMH4p6hwbaQ6n3DWx4lhsetBocd6lS+lVM+d40I3KLyzVAXt3CokaWpej/0paac
        cqzPcUqf/5srbDXkPIK36whHP4DZUpnSRlHspglNS5p77kTiy4b9zZUMLF3IIgBjcz6Br2jRoxYX+
        vWGuxJBluz3V6oi4VjQPpmc7mmu3iWRQ00Aie4He+c8ZFXrNNAodqvzzBHDQ6SOErfZj+lNQgw+to
        rptERk0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oWdzn-00GJ4H-M7; Fri, 09 Sep 2022 13:24:35 +0000
Date:   Fri, 9 Sep 2022 06:24:35 -0700
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
Message-ID: <Yxs+k6psNfBLDqdv@infradead.org>
References: <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org>
 <YxiPh4u/92chN02C@nvidia.com>
 <Yxiq5sjf/qA7xS8A@infradead.org>
 <Yxi3cFfs0SA4XWJw@nvidia.com>
 <Yxi5h09JAzIo4Kh8@infradead.org>
 <YxjDBOIavc79ZByZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxjDBOIavc79ZByZ@nvidia.com>
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

On Wed, Sep 07, 2022 at 01:12:52PM -0300, Jason Gunthorpe wrote:
> The PCI offset is some embedded thing - I've never seen it in a server
> platform.

That's not actually true, e.g. some power system definitively had it,
althiugh I don't know if the current ones do.

But that's not that point.  The offset is a configuration fully
supported by Linux, and someone that just works by using the proper
APIs.  Doing some handwaiving about embedded only or bad design doesn't
matter.  There is a reason why we have these proper APIs and no one
has any business bypassing them.

> I also seem to remember that iommu and PCI offset don't play nice
> together - so for the VFIO use case where the iommu is present I'm
> pretty sure we can very safely assume 0 offset. That seems confirmed
> by the fact that VFIO has never handled PCI offset in its own P2P path
> and P2P works fine in VMs across a wide range of platforms.

I think the offset is one of the reasons why IOVA windows can be
reserved (and maybe also why ppc is so weird).

> So, would you be OK with this series if I try to make a dma_map_p2p()
> that resolves the offset issue?

Well, if it also solves the other issue of invalid scatterlists leaking
outside of drm we can think about it.

> 
> > Last but not least I don't really see how the code would even work
> > when an IOMMU is used, as dma_map_resource will return an IOVA that
> > is only understood by the IOMMU itself, and not the other endpoint.
> 
> I don't understand this.
> 
> __iommu_dma_map() will put the given phys into the iommu_domain
> associated with 'dev' and return the IOVA it picked.

Yes, __iommu_dma_map creates an IOVA for the mapped remote BAR.  That
is the right thing if the I/O goes through the host bridge, but it is
the wrong thing if the I/O goes through the switch - in that case the
IOVA generated is not something that the endpoint that owns the BAR
can even understand.

Take a look at iommu_dma_map_sg and pci_p2pdma_map_segment to see how
this is handled.
