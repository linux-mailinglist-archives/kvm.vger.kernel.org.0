Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDDC56B994
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbiGHMVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 08:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiGHMVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 08:21:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68C67175BD
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 05:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657282897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV8xoC3y9hIFRs0EdEXsmHEyMQd08dlvoH49hw0Txkw=;
        b=HHvhIdTFnz7DRNwSivzUA14HTSWCFZF5mBx+Ud7yLjG26v0+HqtTiZytV/OnFICdOP+F0x
        E6THWw/0SgwZvJuMzsPHYs43BJAU3uIW8JY9JaOVew3pdwpnwcMLuKNr4uJAN5tZwTjBIy
        pIj/jwHpiDQ8XMWFTA8F18nRNPCHSKY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-KThxSsHBOV26ifIQAcCfBw-1; Fri, 08 Jul 2022 08:21:36 -0400
X-MC-Unique: KThxSsHBOV26ifIQAcCfBw-1
Received: by mail-qt1-f197.google.com with SMTP id o17-20020ac84291000000b003170097ad3bso18274069qtl.12
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 05:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JV8xoC3y9hIFRs0EdEXsmHEyMQd08dlvoH49hw0Txkw=;
        b=v/YyK212TJIkb8CkofvpnoB2lZOcNYOA6yZ6kgMmtHUJPQQbpTbEyY7vm+PO4DJDHI
         0dp1OuBP+qbdzSoR1B3WRMYrrnOa+RkEIpQqqGLIuY5+Qq69WM8MLT3htmb/eCSdtf8I
         JETtRh7/JHwu8+9SKiYwLCFXml4hLuQV+bHtCEILNfRu/gR66Jrgyi9Ci5FZyzZTAXK5
         gEPV3Zy6jctzEdUUrJ3rfuNrE3TJ5b/AKxmOkM7hDHPcUlmxBeZbP9b5SkGhFA0W1INO
         +XRMNI0Bu8rfP9l0PzrthlTI3WcdArk53ffEQ+DlVTR3DVQEJ2aPLTHEdN8gGtWkthYR
         Ip1A==
X-Gm-Message-State: AJIora9bUREX16iKDq+J84wGRUGBz7Eqw2t3Dr7U6wUfE1E69/riv4Br
        i5+CzIL41Dg2/e7Fve9Trw2s5tLmFyQXq7uZwAVSw42nRTlPvnqi9wvKv/og91Cu9V0UAB8/3CA
        TIN4eeAdqsZboQhDfqdjhOXhMVRM0
X-Received: by 2002:a05:620a:1a28:b0:6b1:4d4d:c7c3 with SMTP id bk40-20020a05620a1a2800b006b14d4dc7c3mr1982427qkb.522.1657282895270;
        Fri, 08 Jul 2022 05:21:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vNb4tLEjtAGJ8T9AOWGPWW+rg1FhyWgvJiv4aTu/TFJ/A87tKh6sa+dbG85bUkhiXO1dbzAoy/+8kaDsp6XTA=
X-Received: by 2002:a05:620a:1a28:b0:6b1:4d4d:c7c3 with SMTP id
 bk40-20020a05620a1a2800b006b14d4dc7c3mr1982401qkb.522.1657282895012; Fri, 08
 Jul 2022 05:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-5-eperezma@redhat.com>
 <CACGkMEtbukb4gcCHytotZr7FA+Dp1cFs4BpPJatR98zqAnNZjA@mail.gmail.com>
In-Reply-To: <CACGkMEtbukb4gcCHytotZr7FA+Dp1cFs4BpPJatR98zqAnNZjA@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 14:20:58 +0200
Message-ID: <CAJaqyWc6c0q2dZGyJkd2PPszW=FPzqhGUM8=K-k=XbJcAZn1Uw@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] vdpa_sim: Implement suspend vdpa op
To:     Jason Wang <jasowang@redhat.com>
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
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 6:18 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, Jun 24, 2022 at 12:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com>=
 wrote:
> >
> > Implement suspend operation for vdpa_sim devices, so vhost-vdpa will
> > offer that backend feature and userspace can effectively suspend the
> > device.
> >
> > This is a must before get virtqueue indexes (base) for live migration,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> >  4 files changed, 28 insertions(+)
> >
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index 0f2865899647..213883487f9b 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasi=
m)
> >         for (i =3D 0; i < vdpasim->dev_attr.nas; i++)
> >                 vhost_iotlb_reset(&vdpasim->iommu[i]);
> >
> > +       vdpasim->running =3D true;
> >         spin_unlock(&vdpasim->iommu_lock);
> >
> >         vdpasim->features =3D 0;
> > @@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
> >         return 0;
> >  }
> >
> > +static int vdpasim_suspend(struct vdpa_device *vdpa)
> > +{
> > +       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> > +       int i;
> > +
> > +       spin_lock(&vdpasim->lock);
> > +       vdpasim->running =3D false;
> > +       if (vdpasim->running) {
> > +               /* Check for missed buffers */
> > +               for (i =3D 0; i < vdpasim->dev_attr.nvqs; ++i)
> > +                       vdpasim_kick_vq(vdpa, i);
>
> This seems only valid if we allow resuming?
>

Right, deleting for v7.

Thanks!

> Thanks
>
> > +
> > +       }
> > +       spin_unlock(&vdpasim->lock);
> > +
> > +       return 0;
> > +}
> > +
> >  static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> >  {
> >         struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> > @@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_=
ops =3D {
> >         .get_status             =3D vdpasim_get_status,
> >         .set_status             =3D vdpasim_set_status,
> >         .reset                  =3D vdpasim_reset,
> > +       .suspend                =3D vdpasim_suspend,
> >         .get_config_size        =3D vdpasim_get_config_size,
> >         .get_config             =3D vdpasim_get_config,
> >         .set_config             =3D vdpasim_set_config,
> > @@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_c=
onfig_ops =3D {
> >         .get_status             =3D vdpasim_get_status,
> >         .set_status             =3D vdpasim_set_status,
> >         .reset                  =3D vdpasim_reset,
> > +       .suspend                =3D vdpasim_suspend,
> >         .get_config_size        =3D vdpasim_get_config_size,
> >         .get_config             =3D vdpasim_get_config,
> >         .set_config             =3D vdpasim_set_config,
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/v=
dpa_sim.h
> > index 622782e92239..061986f30911 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> > @@ -66,6 +66,7 @@ struct vdpasim {
> >         u32 generation;
> >         u64 features;
> >         u32 groups;
> > +       bool running;
> >         /* spinlock to synchronize iommu table */
> >         spinlock_t iommu_lock;
> >  };
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_s=
im/vdpa_sim_blk.c
> > index 42d401d43911..bcdb1982c378 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
> > @@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *wo=
rk)
> >         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> >                 goto out;
> >
> > +       if (!vdpasim->running)
> > +               goto out;
> > +
> >         for (i =3D 0; i < VDPASIM_BLK_VQ_NUM; i++) {
> >                 struct vdpasim_virtqueue *vq =3D &vdpasim->vqs[i];
> >
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_s=
im/vdpa_sim_net.c
> > index 5125976a4df8..886449e88502 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> > @@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *wo=
rk)
> >
> >         spin_lock(&vdpasim->lock);
> >
> > +       if (!vdpasim->running)
> > +               goto out;
> > +
> >         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
> >                 goto out;
> >
> > --
> > 2.31.1
> >
>

