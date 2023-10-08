Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9627BCC12
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 06:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbjJHEgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 00:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbjJHEgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 00:36:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB736BA
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 21:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696739745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOoZlfZQTFF53TPPF0ugCLV6miB6G9bhMJCsmxI+TZs=;
        b=Q20FFEfMkn/Us1BE9FLji2G30Ze9zjDsCM+FMhPa2Ch1EZ43Gpk80sf71BWNoPX1lxet5+
        2uc/Bnmo4EAGkjEakGg2G82ZHz5JUP1k0UIeThtCj3GecreXpoAfpfq5Q8F6Ejc8ZJwBhg
        ZcEBHRwqIqpq2uQPgYP2ftbuTHWrdss=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-U4lX5Ak3NLOSk5_w2KnnAg-1; Sun, 08 Oct 2023 00:35:43 -0400
X-MC-Unique: U4lX5Ak3NLOSk5_w2KnnAg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-503317b8d26so3017279e87.1
        for <kvm@vger.kernel.org>; Sat, 07 Oct 2023 21:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696739742; x=1697344542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOoZlfZQTFF53TPPF0ugCLV6miB6G9bhMJCsmxI+TZs=;
        b=nQsRLe4m9AFCZVYu4fGCCA7EkvYwghGfu0y34xJ4SBSkGcYZ9EixnwC50X7ICE56AM
         /VJohhdTee4L3NOou3XLC/75psNPEMxb3GTy3c4vZdqTxA9228+dFVEIzTudGw9UqvaV
         4SJ/zMQ/TzomtFtKP12CBCALs01C4Fx7zna8+e2shxgcsZkPNx1+uNfUQzjl7wI4rNwX
         AKzWitTMDcY3KWTOSD8sKDtpigirpZPFNN5KPo04vgybELwi0Q+FBY8IDB6RdHQqj1Yq
         /Z236DrDdvHK5IAm4dPsay572SQgmVlFwDJXyF11H1y5feGyfBRTcH6oKJnTmFCqneEj
         oKjQ==
X-Gm-Message-State: AOJu0YwRKNfDObRFWzeO8QeH627eU6sL5aEMfMW1weH5J8aFOjbC37wk
        NBeLIEmpUMangKYvJT5mehU+YGpmYYTw0mTceMrz+hZa9Hfx+6F8RotERx4MRGMa5hp6FLxi06L
        iYi1re2CTHpB5uVcqVb8fuYiPI2acGE4wmma3e5Vcsw==
X-Received: by 2002:a19:435c:0:b0:500:91c1:9642 with SMTP id m28-20020a19435c000000b0050091c19642mr10346148lfj.21.1696739741953;
        Sat, 07 Oct 2023 21:35:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEesW3+LqZnNyyPWhlp2aUtbUAkF/QV4pVuw/g7/p5xHxM6btq/MV1uwbCGf05M1pAxvqEdVbSQyK8H6pYHRZo=
X-Received: by 2002:a19:435c:0:b0:500:91c1:9642 with SMTP id
 m28-20020a19435c000000b0050091c19642mr10346138lfj.21.1696739741529; Sat, 07
 Oct 2023 21:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230926050021.717-1-liming.wu@jaguarmicro.com> <20230926050021.717-2-liming.wu@jaguarmicro.com>
In-Reply-To: <20230926050021.717-2-liming.wu@jaguarmicro.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 8 Oct 2023 12:35:30 +0800
Message-ID: <CACGkMEujvBtAx=1eTqSrzyjBde=0xpC9D0sRVC7wHHf_aqfqwg@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools/virtio: Add hints when module is not installed
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 1:00=E2=80=AFPM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Need to insmod vhost_test.ko before run virtio_test.
> Give some hints to users.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> ---
>  tools/virtio/virtio_test.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index 028f54e6854a..ce2c4d93d735 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev, un=
signed long long features)
>         dev->buf =3D malloc(dev->buf_size);
>         assert(dev->buf);
>         dev->control =3D open("/dev/vhost-test", O_RDWR);
> +
> +       if (dev->control < 0)
> +               fprintf(stderr, "Install vhost_test module" \
> +               "(./vhost_test/vhost_test.ko) firstly\n");

There should be many other reasons to fail for open().

Let's use strerror()?

Thanks


>         assert(dev->control >=3D 0);
>         r =3D ioctl(dev->control, VHOST_SET_OWNER, NULL);
>         assert(r >=3D 0);
> --
> 2.34.1
>

