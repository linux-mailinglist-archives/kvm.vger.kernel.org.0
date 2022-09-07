Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDFC5B039E
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 14:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiIGMHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 08:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGMHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 08:07:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85B12C11B;
        Wed,  7 Sep 2022 05:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FjhohLdrRh9xpRQPVS0aHusJU1Ni6J6xZeu0FQRmyX4=; b=asnYOPXbmCEhbqBDW7KarVLBU/
        PTNtLB+5pIHAXlKZNUVzxCeGMbpIzVscPJhEG5iHxpFKdYjIPaGIiaSX6IgbXZyQZ27R/BmJ9pol7
        +qmtmai0Wj5Q8ZzO2SoE2+oYYwmL9a2O1eQG2nSgz9rL/AgzMr1j8iC1988Z8+QamWo8OJ6FWGxGC
        MqXD6o1no5UOmjGdokf1cGJ1UjKwddlSpGENRL/WRBhVLrVqpUp0GC0klpRisLuJAWsF5F2etfCZw
        T2vwEOj1xffqPbx59GcybwkSZvjTCaV2akgYOLQBS08lwLmjrP4bGq7X/EtvqDDOiGmc/gVy1JdMD
        AicOLcaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oVtpp-005xb9-W5; Wed, 07 Sep 2022 12:07:13 +0000
Date:   Wed, 7 Sep 2022 05:07:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Oded Gabbay <ogabbay@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, KVM list <kvm@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <YxiJcQ72ogLBpY25@infradead.org>
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com>
 <YxczjNIloP7TWcf2@nvidia.com>
 <CAFCwf115rwTWzgPXcpog4u5NAvH4JO+Qis_fcx0mRrNR5AQcaQ@mail.gmail.com>
 <YxeKb9qxFXodg832@nvidia.com>
 <CAFCwf10YeG0vUL4dG0SJawikYb-FVSrxAt-r3iFA61rc330z=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf10YeG0vUL4dG0SJawikYb-FVSrxAt-r3iFA61rc330z=Q@mail.gmail.com>
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

On Tue, Sep 06, 2022 at 10:44:45PM +0300, Oded Gabbay wrote:
> Regardless, it seems we can remove it from the calls to
> dma_map_resource. I went over the kernel code and it seems only habana
> and amdgpu (and amdkfd) are passing this property to dma_map_resource.
> All other callers just pass 0.

What really need to happen is a revert of that entire commit, given that
dma_map_resource must not be used for PCIe P2P transactions as explained
in my previous mail.
