Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE745B08A5
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiIGPcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIGPcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:32:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEB37695C;
        Wed,  7 Sep 2022 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aoNCEd3G2h5oJitKSRVecj6qINXspk8RoWUpFU3QgrE=; b=tCCcEUDdBTy1gWyfW9YlNG/Jia
        azpaKa4Vhsw29BawZm5vkl0bhNs2r5JPa4G6HvoB86C50nitowwurSg3bzRjVx2WZhWwoAhiQAmVn
        /oT7MA7/SWWCc8f8+o9D4Mfq2IBQOQ4PPxdBNHKqMN3P/sWe7Ttp3EszfE6OzWoqHe3YEPWs0eyO9
        jpCx9TEhmKvhFD0ZcYsfFTYekZBR1omjitNqvA2cy1f4syPWthiukLGuozipk5tQrpDhLzu4ihLth
        QSPNF/ojETiUJOgURCWfEFBPHav5pDhp9feHgfz6yk5RxCHpVde8WMEVKomsY+Jgne51OLrnG9Tpe
        HeWIjtag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVx2N-007MrO-F7; Wed, 07 Sep 2022 15:32:23 +0000
Date:   Wed, 7 Sep 2022 08:32:23 -0700
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
Message-ID: <Yxi5h09JAzIo4Kh8@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org>
 <YxiPh4u/92chN02C@nvidia.com>
 <Yxiq5sjf/qA7xS8A@infradead.org>
 <Yxi3cFfs0SA4XWJw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxi3cFfs0SA4XWJw@nvidia.com>
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

On Wed, Sep 07, 2022 at 12:23:28PM -0300, Jason Gunthorpe wrote:
>  2) DMABUF abuses dma_map_resource() for P2P and thus doesn't work in
>     certain special cases.

Not just certain special cases, but one of the main use cases.
Basically P2P can happen in two ways:

 a) through a PCIe switch, or
 b) through connected root ports

The open code version here only supports a), only supports it when there
is no offset between the 'phyiscal' address of the BAR seen PCIe
endpoint and the Linux way.  x86 usually (always?) doesn't have an
offset there, but other architectures often do.

Last but not least I don't really see how the code would even work
when an IOMMU is used, as dma_map_resource will return an IOVA that
is only understood by the IOMMU itself, and not the other endpoint.

How was this code even tested?
