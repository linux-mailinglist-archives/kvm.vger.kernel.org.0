Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD625B1AD7
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiIHLFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiIHLFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:05:18 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDA05C37C;
        Thu,  8 Sep 2022 04:05:13 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id y25-20020a056830109900b0063b3c1fe018so12128946oto.2;
        Thu, 08 Sep 2022 04:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=iQ9amRmmVnRxpXcE5umaGoOgZh5PL9H2v0qg5K1KUpw=;
        b=FkR3LY1OY2JlwgbK6I/79qBwFZ73IHRrFlPC3Iffg8LBfgJI+AqFA8VCbA9YE08PrM
         INNJheZf5j3f73H1vhNLXMuDn70X9fPyBDD+jCAnobS0TZSBROZVNzWOwqOmrgPiR4X3
         5P7VcB5k9mDpdICWiiDFuC5zPWrB6/u8xAf8+sncmS8kb7Bla+CKu8u5p4fm/+T+x7+m
         dVz1nz6q8dgK0oHfSgFXiMdXIxuSj2U0NLURb/c2Xdq8uxAGwp277ar3dM0xycpTJOf/
         3tpo4502HhrG7LSDWMES8UIi0wMv9BZgOCaIN64EAIxm68OLr/LWLrGVsUeoP4n+T6rZ
         L/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iQ9amRmmVnRxpXcE5umaGoOgZh5PL9H2v0qg5K1KUpw=;
        b=mHXv9pmiPYaaVeRIZZZ2z6krnmRQ7Z5i92456O1S95u/OCJtIFSgmWtYA9xHFl7cfN
         DUQDx5mjzPTP//leg1KZSVVCOOSkLNYneJe2XDDYulrFP9QybOm88KLVhOM3i3hIsUQA
         0Gr4dqqLQBTX0Ja2GmMzMqU8T1smWP+RVlaZ4QL5qYW1MFftv4iW0lwpre1fkVnApcN/
         sOT82DCKSzgkMtFzrsXSQv6gUkYKllEmtOT299DQpj+oMTquaSKr0v6UFxg5S8EYLFVK
         BmXIE+p7gY9IYRVVNwLQ/W/f7fEOKj/FjegOMX1v0qQGecQPEB9Y5kWbYF543RuCeKjG
         gMKA==
X-Gm-Message-State: ACgBeo0zoB/SN5MiuM0IFdmWQehGxvpX5ftw5+J179NK9Rwwf8ifBHkr
        9GSReET2J3JVl2kERNQOtdi8muih2fQvRpPCzps=
X-Google-Smtp-Source: AA6agR6oPYe4JrZ5gu/uerMql5gyw17AaKYCYrvVsF0ZW3UpTBIJiNqJdevV3y7ZXiQ0z0Vsm5Xr0IU+z9DCnUfOgxg=
X-Received: by 2002:a9d:809:0:b0:637:80b:3a3e with SMTP id 9-20020a9d0809000000b00637080b3a3emr3135706oty.328.1662635112371;
 Thu, 08 Sep 2022 04:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220815095423.11131-1-dmitry.osipenko@collabora.com>
 <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com> <YxenK8xZHC6Q4Eu4@phenom.ffwll.local>
In-Reply-To: <YxenK8xZHC6Q4Eu4@phenom.ffwll.local>
From:   Rob Clark <robdclark@gmail.com>
Date:   Thu, 8 Sep 2022 04:04:56 -0700
Message-ID: <CAF6AEGupz-2Kg9NtDB-agHXaWHT+RV3YAvDnxN0-5N+BLakbgg@mail.gmail.com>
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
To:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 6, 2022 at 1:01 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Mon, Aug 15, 2022 at 12:05:19PM +0200, Christian K=C3=B6nig wrote:
> > Am 15.08.22 um 11:54 schrieb Dmitry Osipenko:
> > > Higher order pages allocated using alloc_pages() aren't refcounted an=
d they
> > > need to be refcounted, otherwise it's impossible to map them by KVM. =
This
> > > patch sets the refcount of the tail pages and fixes the KVM memory ma=
pping
> > > faults.
> > >
> > > Without this change guest virgl driver can't map host buffers into gu=
est
> > > and can't provide OpenGL 4.5 profile support to the guest. The host
> > > mappings are also needed for enabling the Venus driver using host GPU
> > > drivers that are utilizing TTM.
> > >
> > > Based on a patch proposed by Trigger Huang.
> >
> > Well I can't count how often I have repeated this: This is an absolutel=
y
> > clear NAK!
> >
> > TTM pages are not reference counted in the first place and because of t=
his
> > giving them to virgl is illegal.
> >
> > Please immediately stop this completely broken approach. We have discus=
sed
> > this multiple times now.
>
> Yeah we need to get this stuff closed for real by tagging them all with
> VM_IO or VM_PFNMAP asap.
>
> It seems ot be a recurring amount of fun that people try to mmap dma-buf
> and then call get_user_pages on them.
>
> Which just doesn't work. I guess this is also why Rob Clark send out that
> dma-buf patch to expos mapping information (i.e. wc vs wb vs uncached).

No, not really.. my patch was simply so that the VMM side of virtgpu
could send the correct cache mode to the guest when handed a dma-buf
;-)

BR,
-R

>
> There seems to be some serious bonghits going on :-/
> -Daniel
>
> >
> > Regards,
> > Christian.
> >
> > >
> > > Cc: stable@vger.kernel.org
> > > Cc: Trigger Huang <Trigger.Huang@gmail.com>
> > > Link: https://www.collabora.com/news-and-blog/blog/2021/11/26/venus-o=
n-qemu-enabling-new-virtual-vulkan-driver/#qcom1343
> > > Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # AMDGPU (=
Qemu and crosvm)
> > > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > > ---
> > >   drivers/gpu/drm/ttm/ttm_pool.c | 25 ++++++++++++++++++++++++-
> > >   1 file changed, 24 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm=
_pool.c
> > > index 21b61631f73a..11e92bb149c9 100644
> > > --- a/drivers/gpu/drm/ttm/ttm_pool.c
> > > +++ b/drivers/gpu/drm/ttm/ttm_pool.c
> > > @@ -81,6 +81,7 @@ static struct page *ttm_pool_alloc_page(struct ttm_=
pool *pool, gfp_t gfp_flags,
> > >     unsigned long attr =3D DMA_ATTR_FORCE_CONTIGUOUS;
> > >     struct ttm_pool_dma *dma;
> > >     struct page *p;
> > > +   unsigned int i;
> > >     void *vaddr;
> > >     /* Don't set the __GFP_COMP flag for higher order allocations.
> > > @@ -93,8 +94,10 @@ static struct page *ttm_pool_alloc_page(struct ttm=
_pool *pool, gfp_t gfp_flags,
> > >     if (!pool->use_dma_alloc) {
> > >             p =3D alloc_pages(gfp_flags, order);
> > > -           if (p)
> > > +           if (p) {
> > >                     p->private =3D order;
> > > +                   goto ref_tail_pages;
> > > +           }
> > >             return p;
> > >     }
> > > @@ -120,6 +123,23 @@ static struct page *ttm_pool_alloc_page(struct t=
tm_pool *pool, gfp_t gfp_flags,
> > >     dma->vaddr =3D (unsigned long)vaddr | order;
> > >     p->private =3D (unsigned long)dma;
> > > +
> > > +ref_tail_pages:
> > > +   /*
> > > +    * KVM requires mapped tail pages to be refcounted because put_pa=
ge()
> > > +    * is invoked on them in the end of the page fault handling, and =
thus,
> > > +    * tail pages need to be protected from the premature releasing.
> > > +    * In fact, KVM page fault handler refuses to map tail pages to g=
uest
> > > +    * if they aren't refcounted because hva_to_pfn_remapped() checks=
 the
> > > +    * refcount specifically for this case.
> > > +    *
> > > +    * In particular, unreferenced tail pages result in a KVM "Bad ad=
dress"
> > > +    * failure for VMMs that use VirtIO-GPU when guest's Mesa VirGL d=
river
> > > +    * accesses mapped host TTM buffer that contains tail pages.
> > > +    */
> > > +   for (i =3D 1; i < 1 << order; i++)
> > > +           page_ref_inc(p + i);
> > > +
> > >     return p;
> > >   error_free:
> > > @@ -133,6 +153,7 @@ static void ttm_pool_free_page(struct ttm_pool *p=
ool, enum ttm_caching caching,
> > >   {
> > >     unsigned long attr =3D DMA_ATTR_FORCE_CONTIGUOUS;
> > >     struct ttm_pool_dma *dma;
> > > +   unsigned int i;
> > >     void *vaddr;
> > >   #ifdef CONFIG_X86
> > > @@ -142,6 +163,8 @@ static void ttm_pool_free_page(struct ttm_pool *p=
ool, enum ttm_caching caching,
> > >     if (caching !=3D ttm_cached && !PageHighMem(p))
> > >             set_pages_wb(p, 1 << order);
> > >   #endif
> > > +   for (i =3D 1; i < 1 << order; i++)
> > > +           page_ref_dec(p + i);
> > >     if (!pool || !pool->use_dma_alloc) {
> > >             __free_pages(p, order);
> >
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
