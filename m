Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7445AF4A7
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 21:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIFTpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 15:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIFTpO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 15:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1751647FA;
        Tue,  6 Sep 2022 12:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 476BE616A1;
        Tue,  6 Sep 2022 19:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0843C433D7;
        Tue,  6 Sep 2022 19:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662493512;
        bh=GAPAToTCx7gXUkrzTUwoqJISYnPKCy2tfT5iebINrSM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tGwstgZuj9Z64imazh26ooE3UzLgufjznvV3v16WxDTj16/HgijyyRFml6Vf0O0+U
         jaeforM99eT72Pj/w/a+cHIR7ssl0i2C6MXQ4aVLHCBFEGCXbZsQ79EOpmbs9LYZX2
         eAJ9y4GrpXYkr8KtjaF2rG1lENyvxh7T80AVh8NRxG8loeITmygSTDD9oua8/1xjWL
         qLnk8767upWUIyHhI/BvbSGlj87k3xJNCFI8mjmiPZD2vkUWVqxgdvxsozqwr8bAxT
         nIEfZ2DpwCHlT4+2uES7fGsE6WUXUT4J6L+YTbCKq+CV6ZAC3D49H/lMeMC8DZ92gu
         VBgtSLBrhq/ag==
Received: by mail-io1-f44.google.com with SMTP id y187so9860342iof.0;
        Tue, 06 Sep 2022 12:45:12 -0700 (PDT)
X-Gm-Message-State: ACgBeo1IHfoVXoNMN8hpukZwthCoImQqENPXBZHfiDRpzByy+XFViVH6
        dG8xG+bnMdcHvFzBYCyCHN8FKht3SPAntogxmfM=
X-Google-Smtp-Source: AA6agR40SFtA9e/jyuSLvHPeR/qz10eyjZNszDpE9fSz0SY/6vKAFpmaLy09d99d6NyP2KeEPClmlstOae64OsegAYg=
X-Received: by 2002:a05:6602:26cf:b0:68a:a688:20c7 with SMTP id
 g15-20020a05660226cf00b0068aa68820c7mr35586ioo.50.1662493511815; Tue, 06 Sep
 2022 12:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com>
 <4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com> <YxcYGzPv022G2vLm@infradead.org>
 <b6b5d236-c089-7428-4cc9-a08fe4f6b4a3@amd.com> <YxczjNIloP7TWcf2@nvidia.com>
 <CAFCwf115rwTWzgPXcpog4u5NAvH4JO+Qis_fcx0mRrNR5AQcaQ@mail.gmail.com> <YxeKb9qxFXodg832@nvidia.com>
In-Reply-To: <YxeKb9qxFXodg832@nvidia.com>
From:   Oded Gabbay <ogabbay@kernel.org>
Date:   Tue, 6 Sep 2022 22:44:45 +0300
X-Gmail-Original-Message-ID: <CAFCwf10YeG0vUL4dG0SJawikYb-FVSrxAt-r3iFA61rc330z=Q@mail.gmail.com>
Message-ID: <CAFCwf10YeG0vUL4dG0SJawikYb-FVSrxAt-r3iFA61rc330z=Q@mail.gmail.com>
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
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 8:59 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Sep 06, 2022 at 03:34:02PM +0300, Oded Gabbay wrote:
>
> > > > > > + /*
> > > > > > +  * Since the memory being mapped is a device memory it could never be in
> > > > > > +  * CPU caches.
> > > > > > +  */
> > > > > DMA_ATTR_SKIP_CPU_SYNC doesn't even apply to dma_map_resource, not sure
> > > > > where this wisdom comes from.
> > >
> > > Habana driver
> > I hate to throw the ball at someone else, but I actually copied the
> > code from the amdgpu driver, from amdgpu_vram_mgr_alloc_sgt() iirc.
> > And if you remember Jason, you asked why we use this specific define
> > in the original review you did and I replied the following (to which
> > you agreed and that's why we added the comment):
>
> Yes, I remember, but Christophs remark is that DMA_ATTR_SKIP_CPU_SYNC
> doesn't even do anything when passed to dma_map_resource().
>
> The only attr that seems to be used is DMA_ATTR_PRIVILEGED from what I
> can see.
>
> Jason
Yes, it appears he is correct.
Probably what happened is that either this was originally copied from
a use of dma_map_page or something similar that does check this
attribute, or maybe dma_map_resource used it in the past and the
underlying code has changed.

Regardless, it seems we can remove it from the calls to
dma_map_resource. I went over the kernel code and it seems only habana
and amdgpu (and amdkfd) are passing this property to dma_map_resource.
All other callers just pass 0.

Oded
