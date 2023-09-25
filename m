Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8EA7ACF0B
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 06:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjIYEQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 00:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjIYEQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 00:16:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CF2EE
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 21:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695615348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruu6yd/F7PRRg3zU9933sMPG2y+61a3R2Ou0YGttbMk=;
        b=BzyL8BnvDMZM3MwXeVufFBXbkJPyO0gztoOXDezQbU6Ots6F6fULVGojr/8Zf+ESbo+8cp
        6vZiaRUmgNS0JetbRb3EBsehFp6PVRQDBCF8tIfY3ewXWXu9YRmkoFoW1FnTMXxbgkn4aQ
        2CuPqgv0qcGkXNYHu9XD10YSdShoyns=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-p9ikma5vMMCO_7cmoekaRg-1; Mon, 25 Sep 2023 00:15:47 -0400
X-MC-Unique: p9ikma5vMMCO_7cmoekaRg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31fd49d8f2aso4515487f8f.1
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 21:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695615346; x=1696220146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruu6yd/F7PRRg3zU9933sMPG2y+61a3R2Ou0YGttbMk=;
        b=LghCjqMrAl+QQxktZIRTsoeydpGIQfAIYIEFCMNfy4AV2jcMqE71DwzMxjcy/HoSQU
         Ij0aF1T3Hqi6u0yWDnY8Q5LzHXZ8Ix4dfpXxMhZXCIRP0W8G2/caDTnu6ZEUgZEePI37
         FfZ6TnLOtp5yRX8QbqYAVipKLWlA5jZYaegq32vVB7l9t9BFTqZOHUcO3dGKD3CCqsjr
         7NOKtEPpFLgZY3/cWECE+ttN1t96hZs5AXScv7R5LhYTlMFLjYaINleYQ3M/ouLcrrKD
         +4aqTUKqIM6Ou4GVpLYA2GtvvfYjwJ/iZYuvnjzaBegqhOs0wkShmv6YgjZOlhNn5CDi
         q1CA==
X-Gm-Message-State: AOJu0Yyez7r6c8W1R3Y0X7zgokBRtz6+HwcaK3rYhyaD8jXDF+B9LAiA
        ei4b7B+pUwsWPkayzEnJqlhX3/T6e1t4hpfa75HursjPN+g0feyj+BNFpmBDpCbqboaZRQ0m0OZ
        bIRPkWEp9bWivJ6dl27OOFjJd1ofI
X-Received: by 2002:adf:e508:0:b0:321:64a6:e417 with SMTP id j8-20020adfe508000000b0032164a6e417mr5651726wrm.1.1695615345913;
        Sun, 24 Sep 2023 21:15:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnA4ZFQjTUBgTF/yRHLzrWbDlET+Op3hd/JEQz2wnKypNLgRCsF6S3FP3xbZGRGT0UII1pqjFKnSqeq1FS/AQ=
X-Received: by 2002:adf:e508:0:b0:321:64a6:e417 with SMTP id
 j8-20020adfe508000000b0032164a6e417mr5651717wrm.1.1695615345660; Sun, 24 Sep
 2023 21:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-4-lulu@redhat.com>
 <CACGkMEuKcgH0kdLPmWZ69fL6SYvoVPfeGv11QwhQDW2sr9DZ3Q@mail.gmail.com>
In-Reply-To: <CACGkMEuKcgH0kdLPmWZ69fL6SYvoVPfeGv11QwhQDW2sr9DZ3Q@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Mon, 25 Sep 2023 12:15:08 +0800
Message-ID: <CACLfguVRPV_8HOy3mQbKvpWRGpM_tnjmC=oQqrEbvEz6YkMi0w@mail.gmail.com>
Subject: Re: [RFC v2 3/4] vduse: update the vq_info in ioctl
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 3:39=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Tue, Sep 12, 2023 at 11:00=E2=80=AFAM Cindy Lu <lulu@redhat.com> wrote=
:
> >
> > In VDUSE_VQ_GET_INFO, the driver will sync the last_avail_idx
> > with reconnect info, After mapping the reconnect pages to userspace
> > The userspace App will update the reconnect_time in
> > struct vhost_reconnect_vring, If this is not 0 then it means this
> > vq is reconnected and will update the last_avail_idx
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  drivers/vdpa/vdpa_user/vduse_dev.c | 13 +++++++++++++
> >  include/uapi/linux/vduse.h         |  6 ++++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > index 2c69f4004a6e..680b23dbdde2 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -1221,6 +1221,8 @@ static long vduse_dev_ioctl(struct file *file, un=
signed int cmd,
> >                 struct vduse_vq_info vq_info;
> >                 struct vduse_virtqueue *vq;
> >                 u32 index;
> > +               struct vdpa_reconnect_info *area;
> > +               struct vhost_reconnect_vring *vq_reconnect;
> >
> >                 ret =3D -EFAULT;
> >                 if (copy_from_user(&vq_info, argp, sizeof(vq_info)))
> > @@ -1252,6 +1254,17 @@ static long vduse_dev_ioctl(struct file *file, u=
nsigned int cmd,
> >
> >                 vq_info.ready =3D vq->ready;
> >
> > +               area =3D &vq->reconnect_info;
> > +
> > +               vq_reconnect =3D (struct vhost_reconnect_vring *)area->=
vaddr;
> > +               /*check if the vq is reconnect, if yes then update the =
last_avail_idx*/
> > +               if ((vq_reconnect->last_avail_idx !=3D
> > +                    vq_info.split.avail_index) &&
> > +                   (vq_reconnect->reconnect_time !=3D 0)) {
> > +                       vq_info.split.avail_index =3D
> > +                               vq_reconnect->last_avail_idx;
> > +               }
> > +
> >                 ret =3D -EFAULT;
> >                 if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
> >                         break;
> > diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> > index 11bd48c72c6c..d585425803fd 100644
> > --- a/include/uapi/linux/vduse.h
> > +++ b/include/uapi/linux/vduse.h
> > @@ -350,4 +350,10 @@ struct vduse_dev_response {
> >         };
> >  };
> >
> > +struct vhost_reconnect_vring {
> > +       __u16 reconnect_time;
> > +       __u16 last_avail_idx;
> > +       _Bool avail_wrap_counter;
>
> Please add a comment for each field.
>
Sure will do

> And I never saw _Bool is used in uapi before, maybe it's better to
> pack it with last_avail_idx into a __u32.
>
Thanks will fix this
> Btw, do we need to track inflight descriptors as well?
>
I will check this
Thanks

cindy
> Thanks
>
> > +};
> > +
> >  #endif /* _UAPI_VDUSE_H_ */
> > --
> > 2.34.3
> >
>

