Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A0E63CF54
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 07:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiK3Goa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 01:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiK3Go3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 01:44:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E812A72F
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669790607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjd/oMdsjidgORS4x4dIOgj/JjLdO4P/IMxpTdg96xA=;
        b=HQeqM5vOAIateHtB9Wv0T+ooBVyoSoPH2vFdLFhtAfjHa0jKDbC7ATYvTHcsYUFgraKvXV
        O2K2nFZcsbBITVuumkas3/I9TmP43IzO+2JD+g07/Ja6oqek1WE3DvDlwFEaH+Uh2gMqkb
        oG4BiCqG1tEc/+3+hCsOT7V3jgvOQMs=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-176-kMX8xXeFOvODAa_xh1lpCg-1; Wed, 30 Nov 2022 01:43:26 -0500
X-MC-Unique: kMX8xXeFOvODAa_xh1lpCg-1
Received: by mail-oo1-f70.google.com with SMTP id c8-20020a4a87c8000000b0049f149a83fdso4183307ooi.19
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 22:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjd/oMdsjidgORS4x4dIOgj/JjLdO4P/IMxpTdg96xA=;
        b=HI6brszpx/uexccDPSKsB1ag20oGnubsPU7dOLAhzq+BsmoHb7SdcfvzW71LNDGL0h
         y0v4k5A8t1pwDDxY15DmR8KdjPhw2DKl0Yynj7gTT4kPnbpDr3m8pjT1p67LaeyhPlC1
         dFdSqC5blaeBvRAi36D1TFefkkLaeZgPKdvIFOZ9KsLWSuTETNi9HtU6C7VmrcQ7dvic
         OWrP96sX6LzCU7Sh9HiP8yvEjJ6FTaVzFqY7LuXIiXFtJfYV6kleK2LrOfDCOtLbQWjT
         Mvr8A6MRcSywEzgc85+v/ZhLThFx/CQWAxZ62MDGIvDTC1Hwm5IkP++hRikWppZxCpFI
         kHog==
X-Gm-Message-State: ANoB5pkMGEdVgVOf4esXElias9x9UKk2uf2D8m2CTS13cFfKkaB6g+7e
        KTZbFRGz5MDkFLp6hT7DM+qEOkucFdQrHBBL/WWfnS1cR9jxieOA1+Ofsz3XksBBQtfnmjT0n0t
        JDikEQ5MPPp2g61blscxTSW0uWTvu
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id cm5-20020a056830650500b0066cfb5b4904mr29927876otb.237.1669790605400;
        Tue, 29 Nov 2022 22:43:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6wxcs63mFAcy1jH7J5665PFD1BMgM89Ro6tgAYoev6mcYR4Dp5tkh800k5JC3UQ6Ue4Y1PO6VvmGKxC626baE=
X-Received: by 2002:a05:6830:6505:b0:66c:fb5b:4904 with SMTP id
 cm5-20020a056830650500b0066cfb5b4904mr29927873otb.237.1669790605193; Tue, 29
 Nov 2022 22:43:25 -0800 (PST)
MIME-Version: 1.0
References: <20221124155158.2109884-1-eperezma@redhat.com> <20221124155158.2109884-7-eperezma@redhat.com>
In-Reply-To: <20221124155158.2109884-7-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 30 Nov 2022 14:43:14 +0800
Message-ID: <CACGkMEubBA9NYR5ynT_2C=iMEk3fph2GEOBvcw73BOuqiFKzJg@mail.gmail.com>
Subject: Re: [PATCH for 8.0 v8 06/12] vdpa: extract vhost_vdpa_svq_allocate_iova_tree
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
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

On Thu, Nov 24, 2022 at 11:52 PM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> It can be allocated either if all virtqueues must be shadowed or if
> vdpa-net detects it can shadow only cvq.
>
> Extract in its own function so we can reuse it.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  net/vhost-vdpa.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
> index 88e0eec5fa..9ee3bc4cd3 100644
> --- a/net/vhost-vdpa.c
> +++ b/net/vhost-vdpa.c
> @@ -240,6 +240,22 @@ static NetClientInfo net_vhost_vdpa_info =3D {
>          .check_peer_type =3D vhost_vdpa_check_peer_type,
>  };
>
> +static int vhost_vdpa_get_iova_range(int fd,
> +                                     struct vhost_vdpa_iova_range *iova_=
range)
> +{
> +    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> +
> +    return ret < 0 ? -errno : 0;
> +}

I don't get why this needs to be moved to net specific code.

Thanks

> +
> +static VhostIOVATree *vhost_vdpa_svq_allocate_iova_tree(int vdpa_device_=
fd)
> +{
> +    struct vhost_vdpa_iova_range iova_range;
> +
> +    vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> +    return vhost_iova_tree_new(iova_range.first, iova_range.last);
> +}
> +
>  static void vhost_vdpa_cvq_unmap_buf(struct vhost_vdpa *v, void *addr)
>  {
>      VhostIOVATree *tree =3D v->iova_tree;
> @@ -587,14 +603,6 @@ static NetClientState *net_vhost_vdpa_init(NetClient=
State *peer,
>      return nc;
>  }
>
> -static int vhost_vdpa_get_iova_range(int fd,
> -                                     struct vhost_vdpa_iova_range *iova_=
range)
> -{
> -    int ret =3D ioctl(fd, VHOST_VDPA_GET_IOVA_RANGE, iova_range);
> -
> -    return ret < 0 ? -errno : 0;
> -}
> -
>  static int vhost_vdpa_get_features(int fd, uint64_t *features, Error **e=
rrp)
>  {
>      int ret =3D ioctl(fd, VHOST_GET_FEATURES, features);
> @@ -690,14 +698,11 @@ int net_init_vhost_vdpa(const Netdev *netdev, const=
 char *name,
>      }
>
>      if (opts->x_svq) {
> -        struct vhost_vdpa_iova_range iova_range;
> -
>          if (!vhost_vdpa_net_valid_svq_features(features, errp)) {
>              goto err_svq;
>          }
>
> -        vhost_vdpa_get_iova_range(vdpa_device_fd, &iova_range);
> -        iova_tree =3D vhost_iova_tree_new(iova_range.first, iova_range.l=
ast);
> +        iova_tree =3D vhost_vdpa_svq_allocate_iova_tree(vdpa_device_fd);
>      }
>
>      ncs =3D g_malloc0(sizeof(*ncs) * queue_pairs);
> --
> 2.31.1
>

