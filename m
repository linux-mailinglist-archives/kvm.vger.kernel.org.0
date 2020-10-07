Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF38D286A38
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 23:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgJGVcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 17:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgJGVce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 17:32:34 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C71EC0613D9
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 14:32:16 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id f10so3655043otb.6
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 14:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=01I5VHKcQ0Dg84F8780Uou6AbP019yNjabrXwkN3FWI=;
        b=EsRG22Aeif0x7Fbzs6uS7UAW1oFsXuKdkNN+DciLkMByiGR6/7rpuHQHKW6/AYGkAn
         zrXGNaV+G01Fb5dYxCysglSq8utf14bdInT6jX9GxymWnqFGPIlDsp8egMegVyGA9tVd
         bezdfQ1dOo3mL3oMRvpHXhZ6JlfgpDfbq6e/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=01I5VHKcQ0Dg84F8780Uou6AbP019yNjabrXwkN3FWI=;
        b=bnkZYtchOlhuibmpepsix/+VFgH8dHhMoyO60CPtqNRJWj+QKd/ZxL+BrlMkkjsDB9
         zudzy47D22OHuKiKdBFXGU0QrPwemZEwfQ1gpc1pJq+YlugkMgDeE2eHYo4AGGhmP8xH
         /gPZlfT9NBQ0y+DyTpdUFPImhkoUqY8zmr7s+pFreZ2IycZp1YnVECq1OVeZLHm+O/56
         hMMhrtH2xWeFViVDKKNKHHa2vKx4fh8cuW++YXieXnHoegv9WnNBUCa3hk16xO6h8mxr
         hUNNsa/Mwqivw0PwfnvyN7QWTMXXTgZV+5Zt8eqzOmEahTnK4qh8RbMFT7VU0jfS+TYE
         Rf7A==
X-Gm-Message-State: AOAM531+SfykFbx47ArsCbDeqiA47rTuTeRJgWh6tCYxCKt/TePZoLcX
        JtDqoYCV2FnUeP3szk1kh1zZ/mqSScqWRZOkOxQ8SQ==
X-Google-Smtp-Source: ABdhPJzxWMICpxSHWZnAhfWjQXFxsNyJBAQQUSj60l2wem5bqozDzlbaSID7bj3+IM7C+O1TUPt7xYaFL4y/8poAm3Q=
X-Received: by 2002:a05:6830:1e56:: with SMTP id e22mr2944031otj.303.1602106335551;
 Wed, 07 Oct 2020 14:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-2-daniel.vetter@ffwll.ch> <80718789-b3de-c30a-03c5-7c8cbf41f7d9@nvidia.com>
In-Reply-To: <80718789-b3de-c30a-03c5-7c8cbf41f7d9@nvidia.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 7 Oct 2020 23:32:04 +0200
Message-ID: <CAKMK7uEuwmCkpSeKxjDgHXWrE9P-TbawLoQ4dpu0nc4MYykScA@mail.gmail.com>
Subject: Re: [PATCH 01/13] drm/exynos: Stop using frame_vector helpers
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 7, 2020 at 10:33 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 10/7/20 9:44 AM, Daniel Vetter wrote:
> > All we need are a pages array, pin_user_pages_fast can give us that
> > directly. Plus this avoids the entire raw pfn side of get_vaddr_frames.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Inki Dae <inki.dae@samsung.com>
> > Cc: Joonyoung Shim <jy0922.shim@samsung.com>
> > Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Kukjin Kim <kgene@kernel.org>
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > ---
> >   drivers/gpu/drm/exynos/Kconfig          |  1 -
> >   drivers/gpu/drm/exynos/exynos_drm_g2d.c | 48 ++++++++++++------------=
-
> >   2 files changed, 22 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kc=
onfig
> > index 6417f374b923..43257ef3c09d 100644
> > --- a/drivers/gpu/drm/exynos/Kconfig
> > +++ b/drivers/gpu/drm/exynos/Kconfig
> > @@ -88,7 +88,6 @@ comment "Sub-drivers"
> >   config DRM_EXYNOS_G2D
> >       bool "G2D"
> >       depends on VIDEO_SAMSUNG_S5P_G2D=3Dn || COMPILE_TEST
> > -     select FRAME_VECTOR
> >       help
> >         Choose this option if you want to use Exynos G2D for DRM.
> >
> > diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/=
exynos/exynos_drm_g2d.c
> > index 967a5cdc120e..c83f6faac9de 100644
> > --- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> > +++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
> > @@ -205,7 +205,8 @@ struct g2d_cmdlist_userptr {
> >       dma_addr_t              dma_addr;
> >       unsigned long           userptr;
> >       unsigned long           size;
> > -     struct frame_vector     *vec;
> > +     struct page             **pages;
> > +     unsigned int            npages;
> >       struct sg_table         *sgt;
> >       atomic_t                refcount;
> >       bool                    in_pool;
> > @@ -378,7 +379,7 @@ static void g2d_userptr_put_dma_addr(struct g2d_dat=
a *g2d,
> >                                       bool force)
> >   {
> >       struct g2d_cmdlist_userptr *g2d_userptr =3D obj;
> > -     struct page **pages;
> > +     int i;
>
> The above line can also be deleted, see below.
>
> >
> >       if (!obj)
> >               return;
> > @@ -398,15 +399,11 @@ static void g2d_userptr_put_dma_addr(struct g2d_d=
ata *g2d,
> >       dma_unmap_sgtable(to_dma_dev(g2d->drm_dev), g2d_userptr->sgt,
> >                         DMA_BIDIRECTIONAL, 0);
> >
> > -     pages =3D frame_vector_pages(g2d_userptr->vec);
> > -     if (!IS_ERR(pages)) {
> > -             int i;
> > +     for (i =3D 0; i < g2d_userptr->npages; i++)
> > +             set_page_dirty_lock(g2d_userptr->pages[i]);
> >
> > -             for (i =3D 0; i < frame_vector_count(g2d_userptr->vec); i=
++)
> > -                     set_page_dirty_lock(pages[i]);
> > -     }
> > -     put_vaddr_frames(g2d_userptr->vec);
> > -     frame_vector_destroy(g2d_userptr->vec);
> > +     unpin_user_pages(g2d_userptr->pages, g2d_userptr->npages);
> > +     kvfree(g2d_userptr->pages);
>
> You can avoid writing your own loop, and just simplify the whole thing do=
wn to
> two lines:
>
>         unpin_user_pages_dirty_lock(g2d_userptr->pages, g2d_userptr->npag=
es,
>                                     true);
>         kvfree(g2d_userptr->pages);

Oh nice, this is neat. I'll also roll it out in the habanalabs patch,
that has the same thing. Well almost, it only uses set_page_dirty, not
the _lock variant. But I have no idea whether that matters or not?
-Daniel

>
>
> >
> >       if (!g2d_userptr->out_of_list)
> >               list_del_init(&g2d_userptr->list);
> > @@ -474,35 +471,34 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struc=
t g2d_data *g2d,
> >       offset =3D userptr & ~PAGE_MASK;
> >       end =3D PAGE_ALIGN(userptr + size);
> >       npages =3D (end - start) >> PAGE_SHIFT;
> > -     g2d_userptr->vec =3D frame_vector_create(npages);
> > -     if (!g2d_userptr->vec) {
> > +     g2d_userptr->pages =3D kvmalloc_array(npages, sizeof(*g2d_userptr=
->pages),
> > +                                         GFP_KERNEL);
> > +     if (!g2d_userptr->pages) {
> >               ret =3D -ENOMEM;
> >               goto err_free;
> >       }
> >
> > -     ret =3D get_vaddr_frames(start, npages, FOLL_FORCE | FOLL_WRITE,
> > -             g2d_userptr->vec);
> > +     ret =3D pin_user_pages_fast(start, npages, FOLL_FORCE | FOLL_WRIT=
E,
> > +                               g2d_userptr->pages);
> >       if (ret !=3D npages) {
> >               DRM_DEV_ERROR(g2d->dev,
> >                             "failed to get user pages from userptr.\n")=
;
> >               if (ret < 0)
> > -                     goto err_destroy_framevec;
> > -             ret =3D -EFAULT;
> > -             goto err_put_framevec;
> > -     }
> > -     if (frame_vector_to_pages(g2d_userptr->vec) < 0) {
> > +                     goto err_destroy_pages;
> > +             npages =3D ret;
> >               ret =3D -EFAULT;
> > -             goto err_put_framevec;
> > +             goto err_unpin_pages;
> >       }
> > +     g2d_userptr->npages =3D npages;
> >
> >       sgt =3D kzalloc(sizeof(*sgt), GFP_KERNEL);
> >       if (!sgt) {
> >               ret =3D -ENOMEM;
> > -             goto err_put_framevec;
> > +             goto err_unpin_pages;
> >       }
> >
> >       ret =3D sg_alloc_table_from_pages(sgt,
> > -                                     frame_vector_pages(g2d_userptr->v=
ec),
> > +                                     g2d_userptr->pages,
> >                                       npages, offset, size, GFP_KERNEL)=
;
> >       if (ret < 0) {
> >               DRM_DEV_ERROR(g2d->dev, "failed to get sgt from pages.\n"=
);
> > @@ -538,11 +534,11 @@ static dma_addr_t *g2d_userptr_get_dma_addr(struc=
t g2d_data *g2d,
> >   err_free_sgt:
> >       kfree(sgt);
> >
> > -err_put_framevec:
> > -     put_vaddr_frames(g2d_userptr->vec);
> > +err_unpin_pages:
> > +     unpin_user_pages(g2d_userptr->pages, npages);
> >
> > -err_destroy_framevec:
> > -     frame_vector_destroy(g2d_userptr->vec);
> > +err_destroy_pages:
> > +     kvfree(g2d_userptr->pages);
> >
> >   err_free:
> >       kfree(g2d_userptr);
> >
>
> The rest all looks good, you've avoided the usual API pitfalls. :)
>
> thanks,
> --
> John Hubbard
> NVIDIA



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
