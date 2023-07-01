Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B90174482A
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 11:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjGAJQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 05:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGAJQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 05:16:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABD2BC
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 02:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688202941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GfITF5Nr6pfDtbVnEECtEIPAa7wQ6lj7+UWe+mAgDnM=;
        b=a3DsB2jHdJqDvovN7Gke7WbgRAJxJJnSe6CxVbps6O9UxTczeb7Smduv2juv9zSJkGfImI
        Lcy115Js4H2Szm+RpMTNuvHUjCLapz+BxoiBed8n2zfe+geIDZkWz55PDujWPakFXv+hSw
        AO1LGt0k/zXjcfdgdPOIIGO/5DZKzVs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-jkBw8H7EMMqU9SmBnlhS3A-1; Sat, 01 Jul 2023 05:15:40 -0400
X-MC-Unique: jkBw8H7EMMqU9SmBnlhS3A-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fb40ec952bso15951075e9.0
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 02:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688202939; x=1690794939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GfITF5Nr6pfDtbVnEECtEIPAa7wQ6lj7+UWe+mAgDnM=;
        b=RtJn+6Ir31ZZYr+mGgPYiQeN9j4Zq6kk7HCATxAB11tHJtC0qDvA5a3CLF94cOMRbL
         Ls342Jdqumv8UjM9Q73gshsBQV6gowvmJBCrqxrxv/rNBNnhlu2rEB74MQeHf01DlPgs
         p2lgVZkxi+8ntpcGrFLKo8VEqYN7SrVLsLgHjQXrakNmI6QxPdBODjHc643MFX5Awnke
         CpDDeU5KRgDK0hAVoNblmlsDNu0cQuomINghJQqNfCx2JvTzGzap9iqTTpXAc1BQ0HSv
         1RwXUK4gbY5SzrerVnm7+7yGINTYeRPY42SJ3Gi1VUs5HhcvyFf3GuXLTVN8ZC9ua8vy
         5Ozg==
X-Gm-Message-State: ABy/qLbyOcG/WlT/BFtxr+u5rCkBlJ40GJwXK2caKI/tLkvbUxFM4XGg
        /P0IpmrD5ExKWT3GxMKCnTSu7uKRHnoIWZdSnXSX+XrwhgmPLf8AyWRS6Be6p0qoguMgEfBtQZP
        ovE75unbEqLAMyNMgTuOAKrvW8Mjo
X-Received: by 2002:a5d:694a:0:b0:314:23b:dc56 with SMTP id r10-20020a5d694a000000b00314023bdc56mr3505222wrw.71.1688202939204;
        Sat, 01 Jul 2023 02:15:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEGrNYok3BYAD44hlBqMA6GsZ4KoVuajbLDpOjK3Z46B5D8ua2rbfifRAqAiXpimAzGEQ+tG2Cn3Y3orabRcxE=
X-Received: by 2002:a5d:694a:0:b0:314:23b:dc56 with SMTP id
 r10-20020a5d694a000000b00314023bdc56mr3505207wrw.71.1688202938703; Sat, 01
 Jul 2023 02:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230628065919.54042-1-lulu@redhat.com> <20230628065919.54042-5-lulu@redhat.com>
 <CACGkMEtN7pE4FK2-504JC3A1tcfPjy9QejJiTyvXD7nt49KLvA@mail.gmail.com>
In-Reply-To: <CACGkMEtN7pE4FK2-504JC3A1tcfPjy9QejJiTyvXD7nt49KLvA@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Sat, 1 Jul 2023 17:14:57 +0800
Message-ID: <CACLfguV4PYpxJEtodWqnYwQ1WJrpjTx1XMqJOsDYsvNrfUKr1A@mail.gmail.com>
Subject: Re: [RFC 4/4] vduse: update the vq_info in ioctl
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 4:13=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Jun 28, 2023 at 3:00=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
> >
> > From: Your Name <you@example.com>
> >
> > in VDUSE_VQ_GET_INFO, driver will sync the last_avail_idx
> > with reconnect info, I have olny test the split mode, so
>
> Typo, should be "only".
>
sure will change this
> > only use this here, will add more information later
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > index 3df1256eccb4..b8e453eac0ce 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -141,6 +141,11 @@ static u32 allowed_device_id[] =3D {
> >         VIRTIO_ID_NET,
> >  };
> >
> > +struct vhost_reconnect_vring {
> > +       uint16_t last_avail_idx;
> > +       bool avail_wrap_counter;
> > +};
>
> Should this belong to uAPI?
>
will change this
> > +
> >  static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa=
)
> >  {
> >         struct vduse_vdpa *vdev =3D container_of(vdpa, struct vduse_vdp=
a, vdpa);
> > @@ -1176,6 +1181,17 @@ static long vduse_dev_ioctl(struct file *file, u=
nsigned int cmd,
> >                                 vq->state.split.avail_index;
> >
> >                 vq_info.ready =3D vq->ready;
> > +               struct vdpa_reconnect_info *area;
> > +
> > +               area =3D &dev->reconnect_info[index];
> > +               struct vhost_reconnect_vring *log_reconnect;
> > +
> > +               log_reconnect =3D (struct vhost_reconnect_vring *)area-=
>vaddr;
>
> What if userspace doesn't do mmap()?
>
> Thanks
>
sure will add the check for this
Thanks
Cindy
> > +               if (log_reconnect->last_avail_idx !=3D
> > +                   vq_info.split.avail_index) {
> > +                       vq_info.split.avail_index =3D
> > +                               log_reconnect->last_avail_idx;
> > +               }
> >
> >                 ret =3D -EFAULT;
> >                 if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
> > --
> > 2.34.3
> >
>

