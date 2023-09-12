Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F249879C863
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjILHlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 03:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjILHls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 03:41:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE160E79
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 00:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694504461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmEyY93Ck8WkDOQRoCLqGrbPgTcfdcNt9t1RcylOzYQ=;
        b=ibkztNctLiWa96/rf1B0qJANpKoVkP2z5st5lVROef4cpjLHK43RhDyUkG78HTLM4RPBZg
        cu2FY73m5I9B34gqdZq35un34M2jif5+FjT1g1x7OuiWZOQveoYtJ7AbV9zt1XV5+XVkSR
        RpXw1rVw7ApXDQv+78ds8fbKRNYvcD4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-n_-dL59jPy-8hxInT4WEkQ-1; Tue, 12 Sep 2023 03:39:21 -0400
X-MC-Unique: n_-dL59jPy-8hxInT4WEkQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50092034189so5410247e87.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 00:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694504360; x=1695109160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmEyY93Ck8WkDOQRoCLqGrbPgTcfdcNt9t1RcylOzYQ=;
        b=HGKA7YfUKbPHjIRRFgTqbDMbMkzpDtRrGf0My9ZO2H3n/8p54DXIlAm6r2UKExzIa3
         hW5kR0C2s2usC52EqXhSmns/Zoxj7s4wpwjikR0HGTNEYRLOaauZW6PwB6SAnAcJLHwY
         KiB4BTg/iClgP5P6aDA+qY+jXhYv8N6RaILfems2vAwytZ1LNQ8xvQKasM9O4wxwGkYR
         gZHUyb4jDi+wv2Lwq4m+Gx0JzdYUJ+7eQtF4XdP754j+bBrUFnD1kAzgLUNtqsC98Mhb
         LW0ioONlcOqF4MBGa1m7QsdI2qns4tSEpduSlMMnaYudcdTF7pMrNt+5/dWjJD8sOLoP
         YNpg==
X-Gm-Message-State: AOJu0YzKp+3UsdjY91wW/549YjY2UiBUVjFqWDCMc9u9YyzWhqRRXPTT
        AdK1L7DUXkQrq2d+XGapp4uxj2E3Xf/F8nUnEXizIGFaQjz4dhEKDL+UobJqt5ZpsNO4rDHb2Hu
        WczfBIUEGtsVdeZ6WQbGjrw6H9XIS
X-Received: by 2002:a05:6512:2316:b0:502:adbc:9b74 with SMTP id o22-20020a056512231600b00502adbc9b74mr7946543lfu.68.1694504360151;
        Tue, 12 Sep 2023 00:39:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5gCC4PBq6IeJnmSasULynPErX2GOpzHNHa9ZcLnpFdOr478ISKQkds33cuYD+0XpwR2uPx/pX3MJrAV2owaA=
X-Received: by 2002:a05:6512:2316:b0:502:adbc:9b74 with SMTP id
 o22-20020a056512231600b00502adbc9b74mr7946526lfu.68.1694504359782; Tue, 12
 Sep 2023 00:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-4-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-4-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 12 Sep 2023 15:39:08 +0800
Message-ID: <CACGkMEuKcgH0kdLPmWZ69fL6SYvoVPfeGv11QwhQDW2sr9DZ3Q@mail.gmail.com>
Subject: Re: [RFC v2 3/4] vduse: update the vq_info in ioctl
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 11:00=E2=80=AFAM Cindy Lu <lulu@redhat.com> wrote:
>
> In VDUSE_VQ_GET_INFO, the driver will sync the last_avail_idx
> with reconnect info, After mapping the reconnect pages to userspace
> The userspace App will update the reconnect_time in
> struct vhost_reconnect_vring, If this is not 0 then it means this
> vq is reconnected and will update the last_avail_idx
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 13 +++++++++++++
>  include/uapi/linux/vduse.h         |  6 ++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index 2c69f4004a6e..680b23dbdde2 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1221,6 +1221,8 @@ static long vduse_dev_ioctl(struct file *file, unsi=
gned int cmd,
>                 struct vduse_vq_info vq_info;
>                 struct vduse_virtqueue *vq;
>                 u32 index;
> +               struct vdpa_reconnect_info *area;
> +               struct vhost_reconnect_vring *vq_reconnect;
>
>                 ret =3D -EFAULT;
>                 if (copy_from_user(&vq_info, argp, sizeof(vq_info)))
> @@ -1252,6 +1254,17 @@ static long vduse_dev_ioctl(struct file *file, uns=
igned int cmd,
>
>                 vq_info.ready =3D vq->ready;
>
> +               area =3D &vq->reconnect_info;
> +
> +               vq_reconnect =3D (struct vhost_reconnect_vring *)area->va=
ddr;
> +               /*check if the vq is reconnect, if yes then update the la=
st_avail_idx*/
> +               if ((vq_reconnect->last_avail_idx !=3D
> +                    vq_info.split.avail_index) &&
> +                   (vq_reconnect->reconnect_time !=3D 0)) {
> +                       vq_info.split.avail_index =3D
> +                               vq_reconnect->last_avail_idx;
> +               }
> +
>                 ret =3D -EFAULT;
>                 if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
>                         break;
> diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
> index 11bd48c72c6c..d585425803fd 100644
> --- a/include/uapi/linux/vduse.h
> +++ b/include/uapi/linux/vduse.h
> @@ -350,4 +350,10 @@ struct vduse_dev_response {
>         };
>  };
>
> +struct vhost_reconnect_vring {
> +       __u16 reconnect_time;
> +       __u16 last_avail_idx;
> +       _Bool avail_wrap_counter;

Please add a comment for each field.

And I never saw _Bool is used in uapi before, maybe it's better to
pack it with last_avail_idx into a __u32.

Btw, do we need to track inflight descriptors as well?

Thanks

> +};
> +
>  #endif /* _UAPI_VDUSE_H_ */
> --
> 2.34.3
>

