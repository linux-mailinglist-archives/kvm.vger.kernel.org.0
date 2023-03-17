Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C46BE5E5
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjCQJu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCQJuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A2E57099
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 02:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679046605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIjz5dsv/dg9VYh+9CXThg5ObzG/xNMA+jvhP6AWg7g=;
        b=fKLmhtPaiL6qYHWvUSl6QJ0F+pK8hKdJW/NAwOGJWL7WVnGhu6YXEeG7i0F0uGkL/Af4Mq
        +d/fFDshNA+vW+1OwVHRgWESwf8turKiVRldGrZK1UKmnrUgwe8k5gBHyywMtalItQe45t
        HnEGslhMxbt/bDZS5pYMGLCOh9ka/KE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-vxxecgKqMriJdDRb75zoLg-1; Fri, 17 Mar 2023 05:50:04 -0400
X-MC-Unique: vxxecgKqMriJdDRb75zoLg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-541888850d4so42109797b3.21
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 02:50:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679046603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cIjz5dsv/dg9VYh+9CXThg5ObzG/xNMA+jvhP6AWg7g=;
        b=cnJS+CwhAWV5yrgL7Bgd0kpJHVEydC04XLoidgQjRKySQEN9Ycy2HEl6rINYR67AG7
         HwFC29Z4O0OHG+NcbHzfVKwovkEkWqUKpifsoVmYWUiOmp/2KrDozPscE0DY5blfaBOj
         EBCwAn9FkHzkTiFe/sEPWTnKO+y3Uuwgh0XtJyt587x3m4DuOvUfCwZYA9QBUZt5rXvw
         xXGq/6n8eDEN0ZYwsYLy22ge/UmfXMEMsP7Y9KCqyjJG/hwQwDx5alJWqpAJQJZumsYS
         VJbNa42bj+sQEl8hSSb5wOEP5MhQ6wm+1fSMUISSHqpZcXrGDr5GPtf2zVABp9vwJduk
         ZPnw==
X-Gm-Message-State: AO0yUKVJTR2r+CmUGgUPJ7kLaSUQpWtuS5bcxKfBZn9aSdGZDDsXJdCN
        7WRdlwGwO3uoDGnrRR49Huj8Yte21l36W5l6wv0h4a0jNhod7+qWSMnfUOPpsnPFDUuhAqX2U9f
        OFOcSwkOYrsx+mn+f1P0R8f/mPY4S
X-Received: by 2002:a81:af63:0:b0:52e:d380:ab14 with SMTP id x35-20020a81af63000000b0052ed380ab14mr2783813ywj.3.1679046603430;
        Fri, 17 Mar 2023 02:50:03 -0700 (PDT)
X-Google-Smtp-Source: AK7set/g7TjoXhX9YrJrHBG0q5oaOfbqdr1UHnhY/7B2j60EyqRZ6PSrTZ/nlJcE85yupZ7mvozduX8LpHbbRgU/Dgo=
X-Received: by 2002:a81:af63:0:b0:52e:d380:ab14 with SMTP id
 x35-20020a81af63000000b0052ed380ab14mr2783803ywj.3.1679046603134; Fri, 17 Mar
 2023 02:50:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-5-sgarzare@redhat.com>
 <CAJaqyWdeEzKnYuX-c348vVg0PpUH4y-e1dSLhRvYem=MEDKE=Q@mail.gmail.com> <CAGxU2F7GZxMwLNsAebaPx61MoePYYmFS1q66An-EDhq4u+a9ng@mail.gmail.com>
In-Reply-To: <CAGxU2F7GZxMwLNsAebaPx61MoePYYmFS1q66An-EDhq4u+a9ng@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 17 Mar 2023 10:49:27 +0100
Message-ID: <CAJaqyWcAfyANeShsdV55vVkK=sHxGNVef7E7jj-CqTL7SbqhCg@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 5:07=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Fri, Mar 3, 2023 at 3:39=E2=80=AFPM Eugenio Perez Martin <eperezma@red=
hat.com> wrote:
> >
> > On Thu, Mar 2, 2023 at 12:35 PM Stefano Garzarella <sgarzare@redhat.com=
> wrote:
> > >
> > > vDPA supports the possibility to use user VA in the iotlb messages.
> > > So, let's add support for user VA in vringh to use it in the vDPA
> > > simulators.
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >
> > > Notes:
> > >     v2:
> > >     - replace kmap_atomic() with kmap_local_page() [see previous patc=
h]
> > >     - fix cast warnings when build with W=3D1 C=3D1
> > >
> > >  include/linux/vringh.h            |   5 +-
> > >  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
> > >  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
> > >  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++----=
--
> > >  4 files changed, 205 insertions(+), 53 deletions(-)
> > >
>
> [...]
>
> >
> > It seems to me iotlb_translate_va and iotlb_translate_pa are very
> > similar, their only difference is that the argument is that iov is
> > iovec instead of bio_vec. And how to fill it, obviously.
> >
> > It would be great to merge both functions, only differing with a
> > conditional on vrh->use_va, or generics, or similar. Or, if following
> > the style of the rest of vringh code, to provide a callback to fill
> > iovec (although I like conditional more).
> >
> > However I cannot think of an easy way to perform that without long
> > macros or type erasure.
>
> Thank you for pushing me :-)
> I finally managed to avoid code duplication (partial patch attached,
> but not yet fully tested).
>
> @Jason: with this refactoring I removed copy_to_va/copy_to_pa, so I
> also avoided getu16_iotlb_va/pa.
>
> I will send the full patch in v3, but I would like to get your opinion
> first ;-)
>
>
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 0ba3ef809e48..71dd67700e36 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1096,8 +1096,7 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
>
>  static int iotlb_translate(const struct vringh *vrh,
>                            u64 addr, u64 len, u64 *translated,
> -                          struct bio_vec iov[],
> -                          int iov_size, u32 perm)
> +                          void *iov, int iov_size, bool iovec, u32 perm)

I think this is an improvement, but we're doing type erasure here. I
don't think it is a big deal since the function is not exported, it's
pretty contained in this file, so I'd ack this version too. I'm just
throwing ideas here:

a) typedef the union {iovec, bio_vec} and use that type in the parameter.

As a drawback, that union feels out of place in this file. Is this the
only place where it is needed? I don't see other similar uses in the
kernel.

b) To convert from iov to bio_iov at return
The drawback is the extra processing if the compiler is not smart
enough to inline it. I prefer the previous one but I didn't want to
omit it, just in case.

Thanks!

>  {
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb =3D vrh->iotlb;
> @@ -1107,7 +1106,7 @@ static int iotlb_translate(const struct vringh *vrh=
,
>         spin_lock(vrh->iotlb_lock);
>
>         while (len > s) {
> -               u64 size, pa, pfn;
> +               u64 size;
>
>                 if (unlikely(ret >=3D iov_size)) {
>                         ret =3D -ENOBUFS;
> @@ -1124,10 +1123,22 @@ static int iotlb_translate(const struct vringh *v=
rh,
>                 }
>
>                 size =3D map->size - addr + map->start;
> -               pa =3D map->addr + addr - map->start;
> -               pfn =3D pa >> PAGE_SHIFT;
> -               bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, s=
ize),
> -                             pa & (PAGE_SIZE - 1));
> +               if (iovec) {
> +                       struct iovec *iovec =3D iov;
> +
> +                       iovec[ret].iov_len =3D min(len - s, size);
> +                       iovec[ret].iov_base =3D (void __user *)(unsigned =
long)
> +                                             (map->addr + addr - map->st=
art);
> +               } else {
> +                       u64 pa =3D map->addr + addr - map->start;
> +                       u64 pfn =3D pa >> PAGE_SHIFT;
> +                       struct bio_vec *bvec =3D iov;
> +
> +                       bvec_set_page(&bvec[ret], pfn_to_page(pfn),
> +                                     min(len - s, size),
> +                                     pa & (PAGE_SIZE - 1));
> +               }
> +
>                 s +=3D size;
>                 addr +=3D size;
>                 ++ret;
> @@ -1141,26 +1152,38 @@ static int iotlb_translate(const struct vringh *v=
rh,
>         return ret;
>  }
>
> +#define IOTLB_IOV_SIZE 16
> +
>  static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>                                   void *src, size_t len)
>  {
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               union {
> +                       struct iovec iovec[IOTLB_IOV_SIZE];
> +                       struct bio_vec bvec[IOTLB_IOV_SIZE];
> +               } iov;
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_RO)=
;
> +                                     &iov, IOTLB_IOV_SIZE, vrh->use_va,
> +                                     VHOST_MAP_RO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       iov_iter_init(&iter, ITER_SOURCE, iov.iovec, ret,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_SOURCE, iov.bvec, ret,
> +                                     translated);
> +               }
>
>                 ret =3D copy_from_iter(dst, translated, &iter);
>                 if (ret < 0)
> @@ -1180,20 +1203,30 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>         u64 total_translated =3D 0;
>
>         while (total_translated < len) {
> -               struct bio_vec iov[16];
> +               union {
> +                       struct iovec iovec[IOTLB_IOV_SIZE];
> +                       struct bio_vec bvec[IOTLB_IOV_SIZE];
> +               } iov;
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
>                                       len - total_translated, &translated=
,
> -                                     iov, ARRAY_SIZE(iov), VHOST_MAP_WO)=
;
> +                                     &iov, IOTLB_IOV_SIZE, vrh->use_va,
> +                                     VHOST_MAP_WO);
>                 if (ret =3D=3D -ENOBUFS)
> -                       ret =3D ARRAY_SIZE(iov);
> +                       ret =3D IOTLB_IOV_SIZE;
>                 else if (ret < 0)
>                         return ret;
>
> -               iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
> +               if (vrh->use_va) {
> +                       iov_iter_init(&iter, ITER_DEST, iov.iovec, ret,
> +                                     translated);
> +               } else {
> +                       iov_iter_bvec(&iter, ITER_DEST, iov.bvec, ret,
> +                                     translated);
> +               }
>
>                 ret =3D copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
> @@ -1210,20 +1243,32 @@ static inline int copy_to_iotlb(const struct vrin=
gh *vrh, void *dst,
>  static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *from;
> +       union {
> +               struct iovec iovec;
> +               struct bio_vec bvec;
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
>         /* Atomic read is needed for getu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_RO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       from =3D kaddr + iov.bv_offset;
> -       *val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_local(kaddr);
> +       if (vrh->use_va) {
> +               ret =3D __get_user(tmp, (__virtio16 __user *)iov.iovec.io=
v_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(iov.bvec.bv_page);
> +               void *from =3D kaddr + iov.bvec.bv_offset;
> +
> +               tmp =3D READ_ONCE(*(__virtio16 *)from);
> +               kunmap_local(kaddr);
> +       }
> +
> +       *val =3D vringh16_to_cpu(vrh, tmp);
>
>         return 0;
>  }
> @@ -1231,20 +1276,32 @@ static inline int getu16_iotlb(const struct vring=
h *vrh,
>  static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
> -       struct bio_vec iov;
> -       void *kaddr, *to;
> +       union {
> +               struct iovec iovec;
> +               struct bio_vec bvec;
> +       } iov;
> +       __virtio16 tmp;
>         int ret;
>
>         /* Atomic write is needed for putu16 */
> -       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
> -                             &iov, 1, VHOST_MAP_WO);
> +       ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
> +                             NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
>         if (ret < 0)
>                 return ret;
>
> -       kaddr =3D kmap_local_page(iov.bv_page);
> -       to =3D kaddr + iov.bv_offset;
> -       WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_local(kaddr);
> +       tmp =3D cpu_to_vringh16(vrh, val);
> +
> +       if (vrh->use_va) {
> +               ret =3D __put_user(tmp, (__virtio16 __user *)iov.iovec.io=
v_base);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               void *kaddr =3D kmap_local_page(iov.bvec.bv_page);
> +               void *to =3D kaddr + iov.bvec.bv_offset;
> +
> +               WRITE_ONCE(*(__virtio16 *)to, tmp);
> +               kunmap_local(kaddr);
> +       }
>
>         return 0;
>  }
>

