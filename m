Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7956556B8AE
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 13:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbiGHLjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 07:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbiGHLjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 07:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3648248E0
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 04:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657280376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNVgEcpzM+/vCThcvSnZLW7eVIEstg9RdMdX8L07Sh8=;
        b=YTPEHZGGnO9dcMmYG5IGYZ4xkHktHPx3+BhYSpkrfwG6cW8JPHtPI3QeYhJdAN/Q1PyEgG
        QqVULC9nFp5FRnBdvMJCkKCJoKxVQ0s8aoDI4pETvygFt55O4A3LK2fzl7Qgym/Cj849j/
        dy9XqP3dJYENWTKE+B4dYeeKWr1/8ag=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-oYsj8hJONWKSABa0B0E8ow-1; Fri, 08 Jul 2022 07:39:22 -0400
X-MC-Unique: oYsj8hJONWKSABa0B0E8ow-1
Received: by mail-qk1-f197.google.com with SMTP id bs42-20020a05620a472a00b006b550b57229so4691763qkb.15
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 04:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yNVgEcpzM+/vCThcvSnZLW7eVIEstg9RdMdX8L07Sh8=;
        b=IrTaHdC0xu3BbNphr8YSmkDKG3+vuUbCEi3A9Mz2eihzOp6MrX11OFHM6XtlMZgRzZ
         MoHjfsY7AMC0CoViHFYRtwGaNdPCl4NEzxelr68pfurGo3X7x6jg/Lec9nkkesb7m5bT
         q3Gvply9J+NTGtzJgWmmI7I9vn4HeJfjiniyNL9SayvqVrxLFyNQ7td/Iv099Ncl832H
         mhXt50JHlkRizlsItEtEQQbYjtTT/NC3P+YGImacs7YZYWZDWqyy78nX6LGmMDdNHqZm
         EO74m9itVQUU3UhG88a5HN4LuZC8h6eaRBT8noee08/J8ggUaXq37CynfOTZCJd0cbym
         j10w==
X-Gm-Message-State: AJIora+1FPhrGNYWxGsxqny926fFdsG3do5blA4DJ3qPqowXJxLu2HFd
        tl7nCPoNnWdNMoy8xiZ/uftzDK6Rd6X+gx+erPLolW637um4wz5Xf5NjyeWaYYoS96ybJCXJJKW
        HXC2YKj0WGYRZxVywRRT46WAEnY9W
X-Received: by 2002:ac8:5b51:0:b0:317:3513:cf60 with SMTP id n17-20020ac85b51000000b003173513cf60mr2417324qtw.495.1657280362062;
        Fri, 08 Jul 2022 04:39:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1soiGPuYi6lPEQoes6ARy4+/8RPHSCSMZr4aOnahYYSe/CRsKbh0ARoAmkh8O+3KdBJ8y9F4eA5swcgFXLLDQ8=
X-Received: by 2002:ac8:5b51:0:b0:317:3513:cf60 with SMTP id
 n17-20020ac85b51000000b003173513cf60mr2417280qtw.495.1657280361792; Fri, 08
 Jul 2022 04:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-3-eperezma@redhat.com>
 <20220628134340.5fla7surd34bwnq3@sgarzare-redhat>
In-Reply-To: <20220628134340.5fla7surd34bwnq3@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 8 Jul 2022 13:38:45 +0200
Message-ID: <CAJaqyWd8yNdfGEDJ3Zesruh_Q0_9u_j80pad-FUA=oK=mvnLGQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] vhost-vdpa: introduce SUSPEND backend feature bit
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 3:43 PM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, Jun 23, 2022 at 06:07:36PM +0200, Eugenio P=C3=A9rez wrote:
> >Userland knows if it can suspend the device or not by checking this feat=
ure
> >bit.
> >
> >It's only offered if the vdpa driver backend implements the suspend()
> >operation callback, and to offer it or userland to ack it if the backend
> >does not offer that callback is an error.
>
> Should we document in the previous patch that the callback must be
> implemented only if the drive/device support it?
>

It's marked as optional in the doc, following other optional callbacks
like set_group_asid for example. But I'm ok with documenting this
behavior further.

> The rest LGTM although I have a doubt whether it is better to move this
> patch after patch 3, or merge it with patch 3, for bisectability since
> we enable the feature here but if the userspace calls ioctl() with
> VHOST_VDPA_SUSPEND we reply back that it is not supported.
>

I'm fine with moving it, but we will have that behavior with all the
devices anyway. Regarding userspace, we just replace ENOIOCTL with
EOPNOTSUPP. Or I'm missing something?

Thanks!

> Thanks,
> Stefano
>
> >
> >Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >---
> > drivers/vhost/vdpa.c             | 16 +++++++++++++++-
> > include/uapi/linux/vhost_types.h |  2 ++
> > 2 files changed, 17 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >index 23dcbfdfa13b..3d636e192061 100644
> >--- a/drivers/vhost/vdpa.c
> >+++ b/drivers/vhost/vdpa.c
> >@@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa=
 *v,
> >       return 0;
> > }
> >
> >+static bool vhost_vdpa_can_suspend(const struct vhost_vdpa *v)
> >+{
> >+      struct vdpa_device *vdpa =3D v->vdpa;
> >+      const struct vdpa_config_ops *ops =3D vdpa->config;
> >+
> >+      return ops->suspend;
> >+}
> >+
> > static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *f=
eaturep)
> > {
> >       struct vdpa_device *vdpa =3D v->vdpa;
> >@@ -577,7 +585,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >       if (cmd =3D=3D VHOST_SET_BACKEND_FEATURES) {
> >               if (copy_from_user(&features, featurep, sizeof(features))=
)
> >                       return -EFAULT;
> >-              if (features & ~VHOST_VDPA_BACKEND_FEATURES)
> >+              if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
> >+                               BIT_ULL(VHOST_BACKEND_F_SUSPEND)))
> >+                      return -EOPNOTSUPP;
> >+              if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> >+                   !vhost_vdpa_can_suspend(v))
> >                       return -EOPNOTSUPP;
> >               vhost_set_backend_features(&v->vdev, features);
> >               return 0;
> >@@ -628,6 +640,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
> >               break;
> >       case VHOST_GET_BACKEND_FEATURES:
> >               features =3D VHOST_VDPA_BACKEND_FEATURES;
> >+              if (vhost_vdpa_can_suspend(v))
> >+                      features |=3D BIT_ULL(VHOST_BACKEND_F_SUSPEND);
> >               if (copy_to_user(featurep, &features, sizeof(features)))
> >                       r =3D -EFAULT;
> >               break;
> >diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost=
_types.h
> >index 634cee485abb..1bdd6e363f4c 100644
> >--- a/include/uapi/linux/vhost_types.h
> >+++ b/include/uapi/linux/vhost_types.h
> >@@ -161,5 +161,7 @@ struct vhost_vdpa_iova_range {
> >  * message
> >  */
> > #define VHOST_BACKEND_F_IOTLB_ASID  0x3
> >+/* Device can be suspended */
> >+#define VHOST_BACKEND_F_SUSPEND  0x4
> >
> > #endif
> >--
> >2.31.1
> >
>

