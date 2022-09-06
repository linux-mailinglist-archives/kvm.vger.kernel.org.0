Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04F05AE858
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 14:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbiIFMeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 08:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbiIFMec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 08:34:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D0495AC;
        Tue,  6 Sep 2022 05:34:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE16C6150E;
        Tue,  6 Sep 2022 12:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCE6C433D6;
        Tue,  6 Sep 2022 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662467670;
        bh=8rswhesIf7F5l4+vbHZDuYiPqhm8GcAPme7YzWlPZHo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PiNv1XmT/gpk9znR9JgMI4/e7BI81aa2qWYK/59dSmcexqrMxxpeHHNYXOVgORVT+
         aNtMJHQF/LYb4TJ6/fr8ZBihYhKffPcMD8aD7d13wtmrjdCf+DnuOBkzByBaCaFknF
         Ic16wmoX4NEG7XlyXqWG8ihyxJjA4XvwKBbUlyboZfuE7fZ0ukqZ36Ce90YO0bxj3Y
         SOw2c3ksDzdeopDl2TOjx2ac2k0vxwqXeVzVqq0yLGG6BIY+eMyLwQ7jHnoM/jgpBy
         y5DXqGO1Ciz/Mi2MxwFG9+1TVvjBtwXLIsXssWCGMTAmjfcvozXT4duoRTuhtXRc9K
         NeUL0L7nLF39w==
Received: by mail-il1-f176.google.com with SMTP id k9so2708231ils.12;
        Tue, 06 Sep 2022 05:34:30 -0700 (PDT)
X-Gm-Message-State: ACgBeo3B7DwB2Xwx5LbuQzw2Y5I6Zej8xGc6drcW0YVL0c5DO9ywVZh0
        E111Tw0A7iPTWJ73uFPqFpbb2sv5iED8bhahOyg=
X-Google-Smtp-Source: AA6agR5t2EEfOfqFt/KzpOaxtGy9C1ikdONdFt3Yo84P649uJqUH/4H9gMVQanRhVGUj+eh8dpntM2no5PF+qGxQBb0=
X-Received: by 2002:a92:c561:0:b0:2ed:a26a:8c65 with SMTP id
 b1-20020a92c561000000b002eda26a8c65mr12449599ilj.23.1662467669406; Tue, 06
 Sep 2022 05:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com> <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com> <YxczjNIloP7TWcf2@nvidia.com>
In-Reply-To: <YxczjNIloP7TWcf2@nvidia.com>
From:   Oded Gabbay <ogabbay@kernel.org>
Date:   Tue, 6 Sep 2022 15:34:02 +0300
X-Gmail-Original-Message-ID: <CAFCwf115rwTWzgPXcpog4u5NAvH4JO+Qis_fcx0mRrNR5AQcaQ@mail.gmail.com>
Message-ID: <CAFCwf115rwTWzgPXcpog4u5NAvH4JO+Qis_fcx0mRrNR5AQcaQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 2:48 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Sep 06, 2022 at 12:38:44PM +0200, Christian K=C3=B6nig wrote:
> > Am 06.09.22 um 11:51 schrieb Christoph Hellwig:
> > > > +{
> > > > + struct vfio_pci_dma_buf *priv =3D dmabuf->priv;
> > > > + int rc;
> > > > +
> > > > + rc =3D pci_p2pdma_distance_many(priv->vdev->pdev, &attachment->de=
v, 1,
> > > > +                               true);
> > > This should just use pci_p2pdma_distance.
>
> OK
>
> > > > + /*
> > > > +  * Since the memory being mapped is a device memory it could neve=
r be in
> > > > +  * CPU caches.
> > > > +  */
> > > DMA_ATTR_SKIP_CPU_SYNC doesn't even apply to dma_map_resource, not su=
re
> > > where this wisdom comes from.
>
> Habana driver
I hate to throw the ball at someone else, but I actually copied the
code from the amdgpu driver, from amdgpu_vram_mgr_alloc_sgt() iirc.
And if you remember Jason, you asked why we use this specific define
in the original review you did and I replied the following (to which
you agreed and that's why we added the comment):

"The memory behind this specific dma-buf has *always* resided on the
device itself, i.e. it lives only in the 'device' domain (after all,
it maps a PCI bar address which points to the device memory).
Therefore, it was never in the 'CPU' domain and hence, there is no
need to perform a sync of the memory to the CPU's cache, as it was
never inside that cache to begin with.

This is not the same case as with regular memory which is dma-mapped
and then copied into the device using a dma engine. In that case,
the memory started in the 'CPU' domain and moved to the 'device'
domain. When it is unmapped it will indeed be recycled to be used
for another purpose and therefore we need to sync the CPU cache."

Oded
>
> > > > + dma_addr =3D dma_map_resource(
> > > > +         attachment->dev,
> > > > +         pci_resource_start(priv->vdev->pdev, priv->index) +
> > > > +                 priv->offset,
> > > > +         priv->dmabuf->size, dir, DMA_ATTR_SKIP_CPU_SYNC);
> > > This is not how P2P addresses are mapped.  You need to use
> > > dma_map_sgtable and have the proper pgmap for it.
> >
> > The problem is once more that this is MMIO space, in other words regist=
er
> > BARs which needs to be exported/imported.
> >
> > Adding struct pages for it generally sounds like the wrong approach her=
e.
> > You can't even access this with the CPU or would trigger potentially
> > unwanted hardware actions.
>
> Right, this whole thing is the "standard" that dmabuf has adopted
> instead of the struct pages. Once the AMD GPU driver started doing
> this some time ago other drivers followed.
>
> Now we have struct pages, almost, but I'm not sure if their limits are
> compatible with VFIO? This has to work for small bars as well.
>
> Jason
