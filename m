Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964A65336D8
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbiEYGne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 02:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244084AbiEYGnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 02:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7BE05D644
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653461010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t2Zld6JK1r8zgbUydwUdmco7GN3nEwbTaFoGldh5jsg=;
        b=abmB+yS2IO2djQn1lWcV1T6g0o7r7MlMUx60sb9J2zMjTEOZ/9jdA/IdxTdlLCOLXPDmcF
        b3LcZtixnRHVLq0P+SnqeBAbj0I6bzoyN4bsvBRvdCUcZnJek8F2h7t0lHpHCqZEzP5y1T
        Ip90vgVI4a4s9sQpsZt+lwEbmc6+HNw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-KK7SPX3sOI-YEQQd0bTHEw-1; Wed, 25 May 2022 02:43:28 -0400
X-MC-Unique: KK7SPX3sOI-YEQQd0bTHEw-1
Received: by mail-qv1-f72.google.com with SMTP id v11-20020a0ced4b000000b004625b80c284so2420939qvq.18
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 23:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t2Zld6JK1r8zgbUydwUdmco7GN3nEwbTaFoGldh5jsg=;
        b=n0+zRrnhVXKZ4/yVE26riBc0L0aEEPEuCEVhsjQuWY9ucWQ5ofcszbTz0EVliHwvhh
         ba4Q7GqEWKop03TyIdMh1qO2aU5A++xr3cVVe1hXZnpTbK+eBf3Ik23S+Gi3+Cn6S75M
         kB7kYLJyMoNNMVLMe0JcVKjyIte8IzTpAlNc2xP2HHH794a9vzZDmvfawSo+0d/cdrPI
         UIYdLmmDsXD1p/IJtVXd9ROYkBcGcACY2Q+tzO9j66sj699hHxvMnV9BN6d4Fg/zebq5
         qMD6sEaGqFQJU1Hs9kHJ30Nt4rpNFNiu39/h5d6EqvI8WcPxAuea2pKSE5hFL8DpIo95
         +WEA==
X-Gm-Message-State: AOAM5301GTr1YF5BznIOmxE93XyagJTRDks6TUSXJCuMbt8W+DmJ8oha
        RtyjcTSXVJoTiNzGIb4vmt0prDbkskNkg61BYpuj44U8kt8Sp17JS0GBwLqvRbefpuis1Bu6vQ7
        m2xUiFeXP287bIyX4x2BEWh90hov7
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id e12-20020a05622a110c00b002f3d3476f8dmr23194810qty.403.1653461008266;
        Tue, 24 May 2022 23:43:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ8dcSHGHtQp++R04NfX6dSXKduh/QL7dOUX4GVwi7PAAfVXD8vq1JEMSqOxOdTaSi+fQ4h/y0zxXauU4VgvY=
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id
 e12-20020a05622a110c00b002f3d3476f8dmr23194805qty.403.1653461008055; Tue, 24
 May 2022 23:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com> <CACGkMEvHRL7a6njivA0+ae-+nXUB9Dng=oaQny0cHu-Ra+bcFg@mail.gmail.com>
In-Reply-To: <CACGkMEvHRL7a6njivA0+ae-+nXUB9Dng=oaQny0cHu-Ra+bcFg@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 25 May 2022 08:42:52 +0200
Message-ID: <CAJaqyWd6vwPJqFRrY6z0-Q9CpW-FABE_8+hw77q_x5qXQTXKfw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Implement vdpasim stop operation
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cindy Lu <lulu@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Martin Porter <martinpo@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 25, 2022 at 4:49 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> =
wrote:
> >
> > Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> > that backend feature and userspace can effectively stop the device.
> >
> > This is a must before get virtqueue indexes (base) for live migration,
> > since the device could modify them after userland gets them. There are
> > individual ways to perform that action for some devices
> > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> > way to perform it for any vhost device (and, in particular, vhost-vdpa)=
.
> >
> > After the return of ioctl with stop !=3D 0, the device MUST finish any
> > pending operations like in flight requests. It must also preserve all
> > the necessary state (the virtqueue vring base plus the possible device
> > specific states) that is required for restoring in the future. The
> > device must not change its configuration after that point.
>
> I'd suggest documenting this in the code maybe around ops->stop()?
>

I agree it'd be better to put in the source code, but both
vdpa_config_ops and ops->stop don't have a lot of space for docs.

Would it work to document at drivers/vdpa/vdpa.c:vhost_vdpa_stop() and
redirect config ops like "for more info, see vhost_vdpa_stop"?

Thanks!

> Thanks
>
> >
> > After the return of ioctl with stop =3D=3D 0, the device can continue
> > processing buffers as long as typical conditions are met (vq is enabled=
,
> > DRIVER_OK status bit is enabled, etc).
> >
> > In the future, we will provide features similar to VHOST_USER_GET_INFLI=
GHT_FD
> > so the device can save pending operations.
> >
> > Comments are welcome.
> >
> > v2:
> > * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> > * Fix obtaining of stop ioctl arg (it was not obtained but written).
> > * Add stop to vdpa_sim_blk.
> >
> > Eugenio P=C3=A9rez (4):
> >   vdpa: Add stop operation
> >   vhost-vdpa: introduce STOP backend feature bit
> >   vhost-vdpa: uAPI to stop the device
> >   vdpa_sim: Implement stop vdpa op
> >
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
> >  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
> >  include/linux/vdpa.h                 |  6 +++++
> >  include/uapi/linux/vhost.h           |  3 +++
> >  include/uapi/linux/vhost_types.h     |  2 ++
> >  8 files changed, 72 insertions(+), 1 deletion(-)
> >
> > --
> > 2.27.0
> >
> >
>

