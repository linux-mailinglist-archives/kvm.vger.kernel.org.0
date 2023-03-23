Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C76C5CFB
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 04:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCWDCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 23:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWDCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 23:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2110F7
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 20:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679540513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V020neUbbZWaZoIFJtWjwKXZ29/hnOcn6337E3R+7Xs=;
        b=aw63qbmQF7fZKF/MPeJNqCgR1hpYHbsh6OcceSsYf8YNeb5D76WPnKUENKWiVGXmj7SoNd
        bl4b4evfIr3qL0r99mhu1gDleHzHTR9jhTSScN9Ge8JcTVyvg7LpEbEW9AnIc9KxQ9IL2u
        gwgmRDATvAVX8PUu1oUZpO4v2ZdjoY8=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-vm7IrdHzPbyeNX0UqQLBJw-1; Wed, 22 Mar 2023 23:01:51 -0400
X-MC-Unique: vm7IrdHzPbyeNX0UqQLBJw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1777dadbde5so10744707fac.7
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 20:01:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679540511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V020neUbbZWaZoIFJtWjwKXZ29/hnOcn6337E3R+7Xs=;
        b=AxY/+sur6GP4Y4Vl7YKwNrb3LmoANN32YSbBvZVcseDeqKK+X9ZHikXKd0SGIzg8+f
         OjCNtGqfQ64r8kvXHBfR69/3ZO1/+oERiSdLwyxFxPf3JUg4Vg2LAzYoj2Lpbo77FJuw
         DwURYHXAMrQRNVDh+Y3gj09mFEFXD+lEAtxLiXxGJJoN9/v/h1LRpXI/1f/kkmJcSIxy
         p9e+sukAoDxcbhDzAcu2y3OCLdS41zs9szWy2OGDssk4w6C197b1aPEJsvQGAS5ZimNU
         pBFjfG6avWM5IVeOYOra6EqP3cacajtb10CaznTe88GUSLlJW0QOnyL6uwL/arUQL6cb
         ACNg==
X-Gm-Message-State: AO0yUKVFJxwflyt196eVUTT/U3W6ZqYRdFZqxlGz5xazY2NIS/zNPd2e
        UrZIHYTcvIuuqR9AahczRq+EDYIIM/A5Onh779SUsE+2bDDUAGPJFwb9s1y842m8iJ1dbgYiCjx
        /kFPE0UjVVVJkBTcMmNtxjfeHw/2b
X-Received: by 2002:a4a:da03:0:b0:536:c774:d6cc with SMTP id e3-20020a4ada03000000b00536c774d6ccmr1503649oou.0.1679540511116;
        Wed, 22 Mar 2023 20:01:51 -0700 (PDT)
X-Google-Smtp-Source: AK7set/tckm88ucwnaPIT76mp9XcG9XGO5SMDYk5qPRCnqR4YfUWsnGbFN7uYCec8c4MsR1rUwyhA1vi/LxnZGNE7ZQ=
X-Received: by 2002:a4a:da03:0:b0:536:c774:d6cc with SMTP id
 e3-20020a4ada03000000b00536c774d6ccmr1503644oou.0.1679540510894; Wed, 22 Mar
 2023 20:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154228.182769-1-sgarzare@redhat.com> <20230321154228.182769-3-sgarzare@redhat.com>
In-Reply-To: <20230321154228.182769-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 11:01:39 +0800
Message-ID: <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 11:42=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> When the user call VHOST_SET_OWNER ioctl and the vDPA device
> has `use_va` set to true, let's call the bind_mm callback.
> In this way we can bind the device to the user address space
> and directly use the user VA.
>
> The unbind_mm callback is called during the release after
> stopping the device.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v3:
>     - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
>     v2:
>     - call the new unbind_mm callback during the release [Jason]
>     - avoid to call bind_mm callback after the reset, since the device
>       is not detaching it now during the reset
>
>  drivers/vhost/vdpa.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..20250c3418b2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>         return vdpa_reset(vdpa);
>  }
>
> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->bind_mm)
> +               return 0;
> +
> +       return ops->bind_mm(vdpa, v->vdev.mm);
> +}
> +
> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->unbind_mm)
> +               return;
> +
> +       ops->unbind_mm(vdpa);
> +}
> +
>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *ar=
gp)
>  {
>         struct vdpa_device *vdpa =3D v->vdpa;
> @@ -709,6 +731,14 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>         case VHOST_VDPA_RESUME:
>                 r =3D vhost_vdpa_resume(v);
>                 break;
> +       case VHOST_SET_OWNER:
> +               r =3D vhost_dev_set_owner(d);

Nit:

I'd stick to the current way of passing the cmd, argp to
vhost_dev_ioctl() and introduce a new switch after the
vhost_dev_ioctl().

In this way, we are immune to any possible changes of dealing with
VHOST_SET_OWNER in vhost core.

Others look good.

Thanks

> +               if (r)
> +                       break;
> +               r =3D vhost_vdpa_bind_mm(v);
> +               if (r)
> +                       vhost_dev_reset_owner(d, NULL);
> +               break;
>         default:
>                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
>                 if (r =3D=3D -ENOIOCTLCMD)
> @@ -1287,6 +1317,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> +       vhost_vdpa_unbind_mm(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
> --
> 2.39.2
>

