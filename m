Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6026B8A4D
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 06:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjCNF3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 01:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCNF3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 01:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112AA12858
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 22:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678771680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74YVjMeZYJ/+4qW5PTolxDEnVNnarX5wmoCeaFRiDfA=;
        b=DO18fwnR69gaUYNF9fk/SdZaBbV2+yvi9vdgObqD31/Xd+wdJoR7ninR2qKaOqd1YbTkDf
        kIkQaBjcaxpI5Z0ay93WDbrY+rPnXECBtKpmkWNI6Q1vVZp6YYKsUa2CcZt2nojXLbdyki
        Hw2rP5nQ4NyE0P3QkA3RmGBiRKEBCZk=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-Pf028v7UO4ag1xwGHc1BxA-1; Tue, 14 Mar 2023 01:27:56 -0400
X-MC-Unique: Pf028v7UO4ag1xwGHc1BxA-1
Received: by mail-ot1-f71.google.com with SMTP id e2-20020a9d5602000000b00694299f6ea9so7039251oti.19
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 22:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678771675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74YVjMeZYJ/+4qW5PTolxDEnVNnarX5wmoCeaFRiDfA=;
        b=wgOH2j5uZqNdqpyC//l50DxvhO6Crodwn/6jaXCrN+B+4m9ZEFHh/tue8sncLT8rCE
         hBGSogKvIIykY24OO9++0C3dCLv2DU5jbJnheqiPwdGr/33uKN6cBdf1TmPdMgxPbz/f
         UI8yGD7566tIq9/IRNZ2Fcl7YTMjFneOP85GbZi4Q1qcxf39blUAILLc+cHBCd6+zfUT
         fMcAzkK9XRoiDqyT69p4H1HCw+kme7kcEBwGkP73Nc5xYUlfttHOGo5knmiRlQKC0bxU
         bcxbrN180XaFxxzd311oF9IYf6Bigyn1ywl9OudK0hJ+v2MoJhLhgSYlqEl6hzyffFCP
         QUOQ==
X-Gm-Message-State: AO0yUKUZQSDOx3SIOH+j7AoCLX5HzrV4qpf2IKTZjYZ2n62GFYi/Ow8K
        AqGqb1NbRzHlzQ7UocrRcUi34tJEifAG1JAKMYEtQwEW7dyqAYga5gGkfjxkWKxTfbuvhrnsQbf
        42EcaqdpjU+Wqu2vLMNPR3W3ZdlZn
X-Received: by 2002:a05:6870:649f:b0:177:9f9c:dc5 with SMTP id cz31-20020a056870649f00b001779f9c0dc5mr3166806oab.9.1678771675400;
        Mon, 13 Mar 2023 22:27:55 -0700 (PDT)
X-Google-Smtp-Source: AK7set9QOJ7ciYFjVW3GiuDKQSvMWlshd6BM1hnDFL4Rhm/47+qNQ38RbqdkPnlBDKyx4GeN0ylotbZjEz8cf6SNE9I=
X-Received: by 2002:a05:6870:649f:b0:177:9f9c:dc5 with SMTP id
 cz31-20020a056870649f00b001779f9c0dc5mr3166800oab.9.1678771675172; Mon, 13
 Mar 2023 22:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-6-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-6-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 13:27:44 +0800
Message-ID: <CACGkMEvhpkOH-YAHdt4EGC2qQT0iNw7mhVA9nWuf7bd0yLrchQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] vdpa_sim: make devices agnostic for work management
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 2, 2023 at 7:35=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> Let's move work management inside the vdpa_sim core.
> This way we can easily change how we manage the works, without
> having to change the devices each time.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  3 ++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 17 +++++++++++++++--
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  6 ++----
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  6 ++----
>  4 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 144858636c10..acee20faaf6a 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -45,7 +45,7 @@ struct vdpasim_dev_attr {
>         u32 ngroups;
>         u32 nas;
>
> -       work_func_t work_fn;
> +       void (*work_fn)(struct vdpasim *vdpasim);
>         void (*get_config)(struct vdpasim *vdpasim, void *config);
>         void (*set_config)(struct vdpasim *vdpasim, const void *config);
>         int (*get_stats)(struct vdpasim *vdpasim, u16 idx,
> @@ -78,6 +78,7 @@ struct vdpasim {
>
>  struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *attr,
>                                const struct vdpa_dev_set_config *config);
> +void vdpasim_schedule_work(struct vdpasim *vdpasim);
>
>  /* TODO: cross-endian support */
>  static inline bool vdpasim_is_little_endian(struct vdpasim *vdpasim)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 481eb156658b..a6ee830efc38 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -116,6 +116,13 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim=
)
>  static const struct vdpa_config_ops vdpasim_config_ops;
>  static const struct vdpa_config_ops vdpasim_batch_config_ops;
>
> +static void vdpasim_work_fn(struct work_struct *work)
> +{
> +       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
> +
> +       vdpasim->dev_attr.work_fn(vdpasim);
> +}
> +
>  struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>                                const struct vdpa_dev_set_config *config)
>  {
> @@ -152,7 +159,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_att=
r *dev_attr,
>
>         vdpasim =3D vdpa_to_sim(vdpa);
>         vdpasim->dev_attr =3D *dev_attr;
> -       INIT_WORK(&vdpasim->work, dev_attr->work_fn);
> +       INIT_WORK(&vdpasim->work, vdpasim_work_fn);
>         spin_lock_init(&vdpasim->lock);
>         spin_lock_init(&vdpasim->iommu_lock);
>
> @@ -203,6 +210,12 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_at=
tr *dev_attr,
>  }
>  EXPORT_SYMBOL_GPL(vdpasim_create);
>
> +void vdpasim_schedule_work(struct vdpasim *vdpasim)
> +{
> +       schedule_work(&vdpasim->work);
> +}
> +EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
> +
>  static int vdpasim_set_vq_address(struct vdpa_device *vdpa, u16 idx,
>                                   u64 desc_area, u64 driver_area,
>                                   u64 device_area)
> @@ -237,7 +250,7 @@ static void vdpasim_kick_vq(struct vdpa_device *vdpa,=
 u16 idx)
>         }
>
>         if (vq->ready)
> -               schedule_work(&vdpasim->work);
> +               vdpasim_schedule_work(vdpasim);
>  }
>
>  static void vdpasim_set_vq_cb(struct vdpa_device *vdpa, u16 idx,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_blk.c
> index 5117959bed8a..eb4897c8541e 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -11,7 +11,6 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> -#include <linux/sched.h>
>  #include <linux/blkdev.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -286,9 +285,8 @@ static bool vdpasim_blk_handle_req(struct vdpasim *vd=
pasim,
>         return handled;
>  }
>
> -static void vdpasim_blk_work(struct work_struct *work)
> +static void vdpasim_blk_work(struct vdpasim *vdpasim)
>  {
> -       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
>         bool reschedule =3D false;
>         int i;
>
> @@ -326,7 +324,7 @@ static void vdpasim_blk_work(struct work_struct *work=
)
>         spin_unlock(&vdpasim->lock);
>
>         if (reschedule)
> -               schedule_work(&vdpasim->work);
> +               vdpasim_schedule_work(vdpasim);
>  }
>
>  static void vdpasim_blk_get_config(struct vdpasim *vdpasim, void *config=
)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index 862f405362de..e61a9ecbfafe 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -11,7 +11,6 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> -#include <linux/sched.h>
>  #include <linux/etherdevice.h>
>  #include <linux/vringh.h>
>  #include <linux/vdpa.h>
> @@ -192,9 +191,8 @@ static void vdpasim_handle_cvq(struct vdpasim *vdpasi=
m)
>         u64_stats_update_end(&net->cq_stats.syncp);
>  }
>
> -static void vdpasim_net_work(struct work_struct *work)
> +static void vdpasim_net_work(struct vdpasim *vdpasim)
>  {
> -       struct vdpasim *vdpasim =3D container_of(work, struct vdpasim, wo=
rk);
>         struct vdpasim_virtqueue *txq =3D &vdpasim->vqs[1];
>         struct vdpasim_virtqueue *rxq =3D &vdpasim->vqs[0];
>         struct vdpasim_net *net =3D sim_to_net(vdpasim);
> @@ -260,7 +258,7 @@ static void vdpasim_net_work(struct work_struct *work=
)
>                 vdpasim_net_complete(rxq, write);
>
>                 if (tx_pkts > 4) {
> -                       schedule_work(&vdpasim->work);
> +                       vdpasim_schedule_work(vdpasim);
>                         goto out;
>                 }
>         }
> --
> 2.39.2
>

