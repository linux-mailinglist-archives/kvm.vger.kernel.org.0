Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7F75B076F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 16:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIGOrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 10:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIGOr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 10:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C762857E2;
        Wed,  7 Sep 2022 07:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F98D6191C;
        Wed,  7 Sep 2022 14:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B8EC4347C;
        Wed,  7 Sep 2022 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562045;
        bh=f2o1y7KshjpkY9lv8qUib+ioQ3G6ppr6671x+zJpSF4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aLkBQKdLoh3iU88fbas6ii+45gySIpTjxbicxQs534bhWawTDK6a9h/Y8dROIVnYt
         5HqJs+58zWLLHVpz5+ed2hF8NhGRkKPP555vl4nHw7q6ixSz+tPA9ilmxHx0MsAeYA
         xWIGsSs3YxTov4kyaEdIuTVVIp3A86248pvsxeb8mu4RQEkz87sLGuopFfcqzb3OSo
         9nSz3RS6bEKslJ8Or1KY5iNA0oRzTd3cyDOpW2ErfhwGE8LqhxGD/ir/2bSpFqoWo7
         9gRsrF/aiEtWxktJXYK2t9ntg0TqF/FFM6jTa3ma2wtLbw0K9iJvLqKzLvZVA3QA8R
         ph0+BOJIq6vwQ==
Received: by mail-il1-f176.google.com with SMTP id v15so7670138iln.6;
        Wed, 07 Sep 2022 07:47:25 -0700 (PDT)
X-Gm-Message-State: ACgBeo3txZrlFCEsr/+wbRopZTxZOWRA0Yo89lHC/gpU+LKnr0qXYTgh
        4ir55iNJ2bDMpQAsrEEt4H8IT9+J9FE8ZuODRk8=
X-Google-Smtp-Source: AA6agR4o6lWldMLAmLaGf8/79sK+50kODsD1YRVgj4S5LMXqrOSaAz5a6xplMki6HW5XZ9A7aIrChvyctdcUSFL6CzA=
X-Received: by 2002:a05:6e02:1548:b0:2ea:836d:ac6c with SMTP id
 j8-20020a056e02154800b002ea836dac6cmr2206779ilu.6.1662562044874; Wed, 07 Sep
 2022 07:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com> <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com> <YxczjNIloP7TWcf2@nvidia.com>
 <YxiJJYtWgh1l0wxg@infradead.org> <YxiPh4u/92chN02C@nvidia.com> <Yxiq5sjf/qA7xS8A@infradead.org>
In-Reply-To: <Yxiq5sjf/qA7xS8A@infradead.org>
From:   Oded Gabbay <ogabbay@kernel.org>
Date:   Wed, 7 Sep 2022 17:46:58 +0300
X-Gmail-Original-Message-ID: <CAFCwf13sz_KAKJm60A_yyqDRo_4MQXWKHaasdMH=-PTGPnOZtg@mail.gmail.com>
Message-ID: <CAFCwf13sz_KAKJm60A_yyqDRo_4MQXWKHaasdMH=-PTGPnOZtg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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
        Maor Gottlieb <maorg@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 7, 2022 at 5:30 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Sep 07, 2022 at 09:33:11AM -0300, Jason Gunthorpe wrote:
> > Yes, you said that, and I said that when the AMD driver first merged
> > it - but it went in anyhow and now people are using it in a bunch of
> > places.
>
> drm folks made up their own weird rules, if they internally stick
> to it they have to listen to it given that they ignore review comments,
> but it violates the scatterlist API and has not business anywhere
> else in the kernel.  And yes, there probably is a reason or two why
> the drm code is unusually error prone.
>
> > > Why would small BARs be problematic for the pages?  The pages are more
> > > a problem for gigantic BARs do the memory overhead.
> >
> > How do I get a struct page * for a 4k BAR in vfio?
>
> I guess we have different definitions of small then :)
>
> But unless my understanding of the code is out out of data,
> memremap_pages just requires the (virtual) start address to be 2MB
> aligned, not the size.  Adding Dan for comments.
>
> That being said, what is the point of mapping say a 4k BAR for p2p?
> You're not going to save a measurable amount of CPU overhead if that
> is the only place you transfer to.
I don't know what Jason had in mind, but I can see a use for that for
writing to doorbells of a device.
Today, usually what happens is that peer A reads/writes to peer B's
memory through the large bar and then signals the host the operation
was completed.
Then the host s/w writes to the doorbell of the peer B to let him know
he can continue with the execution as the data is now ready (or can be
recycled).
I can imagine peer A writing directly to the doorbell of peer B, and
usually for that we would like to expose a very small area, probably a
single 4K page.

Oded
