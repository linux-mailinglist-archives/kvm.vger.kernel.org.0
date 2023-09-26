Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13CF7AE3D5
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 04:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjIZC6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 22:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjIZC6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 22:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2C8A3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695697064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n8rCoPOuaYDCIDe0rlK/tHfmdP2Iqj9+uLvJ1lMY8pc=;
        b=fDeFD6gQ3r8Ft5jxz9JY7/SdB/7SDrOa6ighst+ZZyCyFA+c+aanZg81WEQX4fo9LQPkit
        UZGbcN/O5GQtEatHWuQWYRWLCZ4osgBA930UcbO1cd5HykQ2upJqpKHpuydKbWLxa1zmYy
        LzSiAUFkAI5SeDBJCBg45tM2/GVk4fE=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-p6iR5798NlWVfuOTTt9few-1; Mon, 25 Sep 2023 22:57:41 -0400
X-MC-Unique: p6iR5798NlWVfuOTTt9few-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50467783718so4190951e87.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 19:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695697060; x=1696301860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8rCoPOuaYDCIDe0rlK/tHfmdP2Iqj9+uLvJ1lMY8pc=;
        b=j00hHTYAELdKU8wfcIgIAxR2RYz34+DWxzajIC74NAMRkRKywHHLzL3bi4wGyhtHnO
         QhdOfj348UGYz9mHEfLi1TMFxrD1/T5I10l4O+0j0UVmnjnoc+XtalzKnsKlzl7lfmJO
         dBSuanb6NPuZ3W3AqPmm6fhcvIeWldECxV2EYichHDUqrMtckQAhIWG+K1fjQIinWuBu
         AdzMaXsT7G9JNhV7KaDlKQEjPP6X1qlFwh6haPkM4IydWnXvwYd2925ILRa6NnlsssZ2
         5mCiTL4GSh5Wa2gwjKlgCfiouZreALYWBKXl9ZcTIcKGD0swgTiqcfo+FWzbYYB7j7CM
         UvoA==
X-Gm-Message-State: AOJu0YxWhECZUu13Utaxag0MDyQ7qnUxrq9v4T09bAxQevMfQUV3TExp
        E/pqpYRV28josIMn0QrlnmbiPKdHFSk4eRsUURlvtUdjj/s0elqTwwIzuJ1nVMFrjKt1KMfnx4T
        PrLaQGzhYIKXXaJylGcOM76S5aTZa
X-Received: by 2002:ac2:48ac:0:b0:503:a76:4eeb with SMTP id u12-20020ac248ac000000b005030a764eebmr5830375lfg.16.1695697060330;
        Mon, 25 Sep 2023 19:57:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3RwYqaYdD2D197Rxxx50AyfpQufQFfgo1/JwgJGy62/rNkyDXHkQuYdQhZ6f74/Yi67MydQBhjJAzFfg+eVI=
X-Received: by 2002:ac2:48ac:0:b0:503:a76:4eeb with SMTP id
 u12-20020ac248ac000000b005030a764eebmr5830366lfg.16.1695697060053; Mon, 25
 Sep 2023 19:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230925103057.104541-1-sgarzare@redhat.com>
In-Reply-To: <20230925103057.104541-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 26 Sep 2023 10:57:29 +0800
Message-ID: <CACGkMEvWKCoB+u2GO2mRroZDmmxcvd8+ytUjpu6wNcBOAu5RYQ@mail.gmail.com>
Subject: Re: [PATCH] vringh: don't use vringh_kiov_advance() in vringh_iov_xfer()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 6:31=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> In the while loop of vringh_iov_xfer(), `partlen` could be 0 if one of
> the `iov` has 0 lenght.
> In this case, we should skip the iov and go to the next one.
> But calling vringh_kiov_advance() with 0 lenght does not cause the
> advancement, since it returns immediately if asked to advance by 0 bytes.
>
> Let's restore the code that was there before commit b8c06ad4d67d
> ("vringh: implement vringh_kiov_advance()"), avoiding using
> vringh_kiov_advance().
>
> Fixes: b8c06ad4d67d ("vringh: implement vringh_kiov_advance()")
> Cc: stable@vger.kernel.org
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/vringh.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 955d938eb663..7b8fd977f71c 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -123,8 +123,18 @@ static inline ssize_t vringh_iov_xfer(struct vringh =
*vrh,
>                 done +=3D partlen;
>                 len -=3D partlen;
>                 ptr +=3D partlen;
> +               iov->consumed +=3D partlen;
> +               iov->iov[iov->i].iov_len -=3D partlen;
> +               iov->iov[iov->i].iov_base +=3D partlen;
>
> -               vringh_kiov_advance(iov, partlen);
> +               if (!iov->iov[iov->i].iov_len) {
> +                       /* Fix up old iov element then increment. */
> +                       iov->iov[iov->i].iov_len =3D iov->consumed;
> +                       iov->iov[iov->i].iov_base -=3D iov->consumed;
> +
> +                       iov->consumed =3D 0;
> +                       iov->i++;
> +               }
>         }
>         return done;
>  }
> --
> 2.41.0
>

