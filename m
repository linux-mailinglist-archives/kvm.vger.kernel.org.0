Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA63623B43
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKJFas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKJFao (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:30:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D5A10FEE
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668058189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIhAVnv+/+S3krzuCVUj1n9SXlWXtXtQLWkbB7aRrMc=;
        b=D4RLn66022/jyC5WLiJqw29RNYwmm7xNputUcXAESkxiIcJVMFdEg9LfZ6gSwlp8JHPBwP
        OJrAHYzGdc38sY6MC9+bH5SYcbS/R44K1TgvdH1Ra16B6ADoA2/LoAjquJDLvSCzxlZD6r
        KrUdU1JltU3/xS/RCgMDKhx+uyLdehw=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-18-aftOBiWGP9y0R1kP93UkSA-1; Thu, 10 Nov 2022 00:29:46 -0500
X-MC-Unique: aftOBiWGP9y0R1kP93UkSA-1
Received: by mail-oo1-f70.google.com with SMTP id h7-20020a4a6f07000000b0049f2024e47dso286927ooc.17
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 21:29:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MIhAVnv+/+S3krzuCVUj1n9SXlWXtXtQLWkbB7aRrMc=;
        b=enGmeU+qgA45KaxAlL3wyviiNCK+KbYrrcVJFez1MvhG39kGt2vsaegn9GCmqCc7nS
         eX7NtNiEZz3XLSCDalRi0PbbTxKSjarf18VyhiIwi9lN5ylxCpN2EGCkBc+bi95+kPGo
         jX2eFMKtmfxHe+FkpgDgHsLlpnxd+PVAvCxkNjwd+07qe+q7Vaj5vP+dXJhqfHkFGoA3
         +8FptKmYLjOMzMvmUTdSmj2TpgLggB+glau1AQOfYx+ldrf9TYNxTZXJFZEFYArdnd4W
         vvnUHGPRXBKbm3GJwYHuJ8T0UJPNropbOJF12wt2jIz73pSyKCyxhVJI8rlkhgtKukpQ
         KPcw==
X-Gm-Message-State: ACrzQf1MLL6lP3EdWKvDVVq00pbG9GyqPcVxEYnhDZnVTytq1y4+C1OK
        VC3m0PF/3DXyEnR7kp+ww5a3CRnpGiAItStjAP4cLijcr8yzsQM2vE8a7hw4XkEOMQB8lTIQpGI
        Rcjuq+0/mwSoZpijswn7QFHYB1F1A
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id t14-20020a056871054e00b0013b29b7e2e8mr45849462oal.35.1668058185488;
        Wed, 09 Nov 2022 21:29:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5hvq2a3d534EXhf5VZh8Fa4rg/SX3V11YbzbGDsvCqCrH5WxHXv9/kAXS+loSnWVxVAvFpzJXGcRagOwroa2Y=
X-Received: by 2002:a05:6871:54e:b0:13b:29b7:e2e8 with SMTP id
 t14-20020a056871054e00b0013b29b7e2e8mr45849448oal.35.1668058185297; Wed, 09
 Nov 2022 21:29:45 -0800 (PST)
MIME-Version: 1.0
References: <20221108170755.92768-1-eperezma@redhat.com> <20221108170755.92768-5-eperezma@redhat.com>
In-Reply-To: <20221108170755.92768-5-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Nov 2022 13:29:33 +0800
Message-ID: <CACGkMEvpXdAfSLXtpEsjsrRQ_iMjLk_PjmYh7p9HpuDpDvH_UA@mail.gmail.com>
Subject: Re: [PATCH v6 04/10] vdpa: add vhost_vdpa_net_valid_svq_features
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Wed, Nov 9, 2022 at 1:08 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wro=
te:
>
> It will be reused at vdpa device start so let's extract in its own functi=
on
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>  net/vhost-vdpa.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index e370ecb8eb..d3b1de481b 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -106,6 +106,22 @@ VHostNetState *vhost_vdpa_get_vhost_net(NetClientSta=
te *nc)
>      return s->vhost_net;
>  }
>
> +static bool vhost_vdpa_net_valid_svq_features(uint64_t features, Error *=
*errp)
> +{
> +    uint64_t invalid_dev_features =3D
> +        features & ~vdpa_svq_device_features &
> +        /* Transport are all accepted at this point */
> +        ~MAKE_64BIT_MASK(VIRTIO_TRANSPORT_F_START,
> +                         VIRTIO_TRANSPORT_F_END - VIRTIO_TRANSPORT_F_STA=
RT);
> +
> +    if (invalid_dev_features) {
> +        error_setg(errp, "vdpa svq does not work with features 0x%" PRIx=
64,
> +                   invalid_dev_features);
> +    }
> +
> +    return !invalid_dev_features;
> +}
> +
>  static int vhost_vdpa_net_check_device_id(struct vhost_net *net)
>  {
>      uint32_t device_id;
> @@ -675,15 +691,7 @@ int net_init_vhost_vdpa(const Netdev *netdev, const =
char *name,
>      if (opts->x_svq) {
>          struct vhost_vdpa_iova_range iova_range;
>
> -        uint64_t invalid_dev_features =3D
> -            features & ~vdpa_svq_device_features &
> -            /* Transport are all accepted at this point */
> -            ~MAKE_64BIT_MASK(VIRTIO_TRANSPORT_F_START,
> -                             VIRTIO_TRANSPORT_F_END - VIRTIO_TRANSPORT_F=
_START);
> -
> -        if (invalid_dev_features) {
> -            error_setg(errp, "vdpa svq does not work with features 0x%" =
PRIx64,
> -                       invalid_dev_features);
> +        if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
>              goto err_svq;
>          }
>
> --
> 2.31.1
>

