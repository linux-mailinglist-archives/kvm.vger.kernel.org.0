Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4097955F507
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 06:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiF2ESv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 00:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiF2ESr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 00:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C53015A23
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 21:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656476324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2h8ccNqJU95HAa4G/EVV71yAZ0Ts5Xe8taofTuRNpD4=;
        b=NURFtJqRXoDXTBLtcpVwwk6qQ5iyQEkrFLFTmTFhEdt4x71gjfT/OwYobfW7nWn8UXm/ke
        G0Db4F7mDSIb6KLbLxCiL95wg2l/vFKkiH9rXrWQNXqY4cw3bTnWHzcPdRdcA4VErd8sVo
        2UEJ9n6YCqdY1k6wFRxsaGx5ozVlcuU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-Ksru2X3CPWSgN3CmqWDYWQ-1; Wed, 29 Jun 2022 00:18:40 -0400
X-MC-Unique: Ksru2X3CPWSgN3CmqWDYWQ-1
Received: by mail-lf1-f71.google.com with SMTP id bq4-20020a056512150400b0047f7f36efc6so7115599lfb.9
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 21:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2h8ccNqJU95HAa4G/EVV71yAZ0Ts5Xe8taofTuRNpD4=;
        b=O77ZHn6TtFoLkGKCP8oieLICwZSxipkzwHT2AMjS3DhCu82KYqHtPKTMarpYbWwUkS
         POxQRgy7KQ+Rwe67qmnkNghjSBgoerwrk5VB2g/ghAScWtRgA9b7O9qSD2JDCstUURV/
         3SbJUfxJo/AnS2E/BlCNkF2c8O3+D3c7Ca8nV3OvOhEbRDKlmz4S1RIdAt19p4T7AKUX
         MSruASQKwfFvACUPN7iWSxsH9UWcw3lh35fnqLr3c0Nzceln9j04nv5lL4c8KEwDmatP
         8d/y/v0qwxSS+0Lwnl4sBAwHR2LJj3wWfu0GJksw4jmvfUz4PB1dMg7CoH007TL1x+dT
         m3bw==
X-Gm-Message-State: AJIora9kBM1XtDK/diLj63Zn5BaStIkG4txyFLZSk8q9OP1itGSZ4PR/
        o0lbOUwAYfl6F+xYS7X/yx+mTEXZi/TFDn5+e0Lhe6wSEipqGlDnuYNCFly2jxA9na3AAKftves
        CQyx3Px8MpT+VbV2IGbaKLqguYGgU
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id bp13-20020a056512158d00b0047f718c28b5mr811903lfb.397.1656476318727;
        Tue, 28 Jun 2022 21:18:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vZ6G4jroIyi6EDss7eqJRupKjJ6aAZH6PLBk1sX8uk6DRDfTN14oyEf9afhAJidDtEIQTSOcMcEre11YiA3MQ=
X-Received: by 2002:a05:6512:158d:b0:47f:718c:28b5 with SMTP id
 bp13-20020a056512158d00b0047f718c28b5mr811892lfb.397.1656476318523; Tue, 28
 Jun 2022 21:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-5-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 12:18:27 +0800
Message-ID: <CACGkMEtbukb4gcCHytotZr7FA+Dp1cFs4BpPJatR98zqAnNZjA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] vdpa_sim: Implement suspend vdpa op
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> Implement suspend operation for vdpa_sim devices, so vhost-vdpa will
> offer that backend feature and userspace can effectively suspend the
> device.
>
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>  4 files changed, 28 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdp=
a_sim.c
> index 0f2865899647..213883487f9b 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>         for (i =3D 0; i < vdpasim->dev_attr.nas; i++)
>                 vhost_iotlb_reset(&vdpasim->iommu[i]);
>
> +       vdpasim->running =3D true;
>         spin_unlock(&vdpasim->iommu_lock);
>
>         vdpasim->features =3D 0;
> @@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
>         return 0;
>  }
>
> +static int vdpasim_suspend(struct vdpa_device *vdpa)
> +{
> +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> +       int i;
> +
> +       spin_lock(&vdpasim->lock);
> +       vdpasim->running =3D false;
> +       if (vdpasim->running) {
> +               /* Check for missed buffers */
> +               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> +                       vdpasim_kick_vq(vdpa, i);

This seems only valid if we allow resuming?

Thanks

> +
> +       }
> +       spin_unlock(&vdpasim->lock);
> +
> +       return 0;
> +}
> +
>  static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
>  {
>         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> @@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_op=
s =3D {
>         .get_status             =3D vdpasim_get_status,
>         .set_status             =3D vdpasim_set_status,
>         .reset                  =3D vdpasim_reset,
> +       .suspend                =3D vdpasim_suspend,
>         .get_config_size        =3D vdpasim_get_config_size,
>         .get_config             =3D vdpasim_get_config,
>         .set_config             =3D vdpasim_set_config,
> @@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_con=
fig_ops =3D {
>         .get_status             =3D vdpasim_get_status,
>         .set_status             =3D vdpasim_set_status,
>         .reset                  =3D vdpasim_reset,
> +       .suspend                =3D vdpasim_suspend,
>         .get_config_size        =3D vdpasim_get_config_size,
>         .get_config             =3D vdpasim_get_config,
>         .set_config             =3D vdpasim_set_config,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdp=
a_sim.h
> index 622782e92239..061986f30911 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -66,6 +66,7 @@ struct vdpasim {
>         u32 generation;
>         u64 features;
>         u32 groups;
> +       bool running;
>         /* spinlock to synchronize iommu table */
>         spinlock_t iommu_lock;
>  };
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_blk.c
> index 42d401d43911..bcdb1982c378 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> @@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *work=
)
>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> +       if (!vdpasim->running)
> +               goto out;
> +
>         for (i =3D 0; i < VDPASIM_BLK_VQ_NUM; i++) {
>                 struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[i];
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim_net.c
> index 5125976a4df8..886449e88502 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work=
)
>
>         spin_lock(&vdpasim->lock);
>
> +       if (!vdpasim->running)
> +               goto out;
> +
>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> --
> 2.31.1
>

