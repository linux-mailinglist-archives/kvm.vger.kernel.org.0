Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA48A7BCC40
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 07:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344346AbjJHFSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 01:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344375AbjJHFSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 01:18:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AC3BF
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 22:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696742267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XIBFYES1oNSbgdg44IpiRY5MDLveYfd/44xts2VnIss=;
        b=QC4Mm8ZFz02yIcA1EwbMIypdoElK6XV33KqM1d1f8xjM/lvE8HU0P9D4Es3Bucnl86NimW
        B1mXW4+o2aQx8NicVXkC2CDKcTI/SrxH0Rah/IdVW+8++LOvjsfIF4vcq6eGPnldMzSNrH
        iAthzHx0bqhJmt5BkcSOZDtIJ18+kNc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-sm56jJFCNKqQ3F0q4gVTFA-1; Sun, 08 Oct 2023 01:17:36 -0400
X-MC-Unique: sm56jJFCNKqQ3F0q4gVTFA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5068bf0b425so1403888e87.0
        for <kvm@vger.kernel.org>; Sat, 07 Oct 2023 22:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696742254; x=1697347054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIBFYES1oNSbgdg44IpiRY5MDLveYfd/44xts2VnIss=;
        b=EPxs5ocj88Vf/rn2NLBNqdJsug5AHrMH9WKaX2PNCAN1wDJoLbaMeRHzEnrPrQPdBZ
         ZQsl++Cg8feaGCiMAd5DK4y2AeZWUfc6FO4TwMJ5JOwn++Eb1P9iEFOcI4MV43M6asix
         w+WFuykjcPC2tPvjwB3tXH0CYJH5sfRKCI6GW6zxLDT0LvraAo0Xe8jc4XFDDneicio1
         zEU0UTc6Pre10vuCcQRmumACxTMbwdIPRMigf0ixrvrODwbwO1q2ClO4feKSySnh6baS
         cKgYb9/pvHn7lJ9DPP7OzC013HPGvAN+n6a+v7lSStgYM1yZAX59muAjBNJp7ptgT+8X
         tlSA==
X-Gm-Message-State: AOJu0YyazuLbKIscBwhS4sf12YMyZW776l6XGZFbJtdAQXnYik0RaxNP
        qs4izHfTwu+z769NqydvivDAyJChuXVdqqoLasqG3nNTOZpCXlnLt1UvtWElLoXuWL4RtX8GxUq
        9iXra/c8gd4b2ybngq3c1T7RBG9SN
X-Received: by 2002:a05:6512:31d2:b0:500:acf1:b432 with SMTP id j18-20020a05651231d200b00500acf1b432mr12100670lfe.63.1696742254620;
        Sat, 07 Oct 2023 22:17:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHih9jNBj+mm3gln1ZCsXonlccj1/oAiZNJ1d8VXWVWaywkwRq06DB7RjMZgwJPLinVPauKckcWGYfUL6bhA9o=
X-Received: by 2002:a05:6512:31d2:b0:500:acf1:b432 with SMTP id
 j18-20020a05651231d200b00500acf1b432mr12100655lfe.63.1696742254306; Sat, 07
 Oct 2023 22:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-4-lulu@redhat.com>
 <CACGkMEuKcgH0kdLPmWZ69fL6SYvoVPfeGv11QwhQDW2sr9DZ3Q@mail.gmail.com> <db93d5aa-64c4-42a4-73dc-ae25e9e3833e@redhat.com>
In-Reply-To: <db93d5aa-64c4-42a4-73dc-ae25e9e3833e@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 8 Oct 2023 13:17:23 +0800
Message-ID: <CACGkMEsNfLOQkmnWUH53iTptAmhELs_U8B4D-CfO49rs=+HfLw@mail.gmail.com>
Subject: Re: [RFC v2 3/4] vduse: update the vq_info in ioctl
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     Cindy Lu <lulu@redhat.com>, mst@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 5:12=E2=80=AFPM Maxime Coquelin
<maxime.coquelin@redhat.com> wrote:
>
>
>
> On 9/12/23 09:39, Jason Wang wrote:
> > On Tue, Sep 12, 2023 at 11:00=E2=80=AFAM Cindy Lu <lulu@redhat.com> wro=
te:
> >>
> >> In VDUSE_VQ_GET_INFO, the driver will sync the last_avail_idx
> >> with reconnect info, After mapping the reconnect pages to userspace
> >> The userspace App will update the reconnect_time in
> >> struct vhost_reconnect_vring, If this is not 0 then it means this
> >> vq is reconnected and will update the last_avail_idx
> >>
> >> Signed-off-by: Cindy Lu <lulu@redhat.com>
> >> ---
> >>   drivers/vdpa/vdpa_user/vduse_dev.c | 13 +++++++++++++
> >>   include/uapi/linux/vduse.h         |  6 ++++++
> >>   2 files changed, 19 insertions(+)
> >>
> >> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_us=
er/vduse_dev.c
> >> index 2c69f4004a6e..680b23dbdde2 100644
> >> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> >> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >> @@ -1221,6 +1221,8 @@ static long vduse_dev_ioctl(struct file *file, u=
nsigned int cmd,
> >>                  struct vduse_vq_info vq_info;
> >>                  struct vduse_virtqueue *vq;
> >>                  u32 index;
> >> +               struct vdpa_reconnect_info *area;
> >> +               struct vhost_reconnect_vring *vq_reconnect;
> >>
> >>                  ret =3D -EFAULT;
> >>                  if (copy_from_user(&vq_info, argp, sizeof(vq_info)))
> >> @@ -1252,6 +1254,17 @@ static long vduse_dev_ioctl(struct file *file, =
unsigned int cmd,
> >>
> >>                  vq_info.ready =3D vq->ready;
> >>
> >> +               area =3D &vq->reconnect_info;
> >> +
> >> +               vq_reconnect =3D (struct vhost_reconnect_vring *)area-=
>vaddr;
> >> +               /*check if the vq is reconnect, if yes then update the=
 last_avail_idx*/
> >> +               if ((vq_reconnect->last_avail_idx !=3D
> >> +                    vq_info.split.avail_index) &&
> >> +                   (vq_reconnect->reconnect_time !=3D 0)) {
> >> +                       vq_info.split.avail_index =3D
> >> +                               vq_reconnect->last_avail_idx;
> >> +               }
> >> +
> >>                  ret =3D -EFAULT;
> >>                  if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
> >>                          break;
> >> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> >> index 11bd48c72c6c..d585425803fd 100644
> >> --- a/include/uapi/linux/vduse.h
> >> +++ b/include/uapi/linux/vduse.h
> >> @@ -350,4 +350,10 @@ struct vduse_dev_response {
> >>          };
> >>   };
> >>
> >> +struct vhost_reconnect_vring {
> >> +       __u16 reconnect_time;
> >> +       __u16 last_avail_idx;
> >> +       _Bool avail_wrap_counter;
> >
> > Please add a comment for each field.
> >
> > And I never saw _Bool is used in uapi before, maybe it's better to
> > pack it with last_avail_idx into a __u32.
>
> Better as two distincts __u16 IMHO.

Fine with me.

Thanks

>
> Thanks,
> Maxime
>
> >
> > Btw, do we need to track inflight descriptors as well?
> >
> > Thanks
> >
> >> +};
> >> +
> >>   #endif /* _UAPI_VDUSE_H_ */
> >> --
> >> 2.34.3
> >>
> >
>

