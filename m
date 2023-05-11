Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F966FECE0
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbjEKHcb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbjEKHcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:32:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DFD35A1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 00:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683790296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5V0/1s5ImrAvwwVL+7JYFZ+EKAgRU5k+UcpUCxvavT4=;
        b=QM2aIJ4cDLqPDMnaFveD925vZIJWfK3igvYhpuUb3rJgXsYoU7+L3d+TC/Yoj8oFTUTIoz
        WNP+owQFKzwvg6YvYZaL3Fu2QZnr8uV/pmrsuWgHvwmDFUWz25GTjWPjbn5j/48p68WlJu
        QOtxBC5cStUZhKq4VzhJ3HGA4qVToWE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-57xruogEP36Zpha8dQpqFA-1; Thu, 11 May 2023 03:31:34 -0400
X-MC-Unique: 57xruogEP36Zpha8dQpqFA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f26157450aso1001465e87.0
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 00:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683790293; x=1686382293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5V0/1s5ImrAvwwVL+7JYFZ+EKAgRU5k+UcpUCxvavT4=;
        b=mCIU5f0V223PtEFtNUOezzqBg7T0FWkqsFmjJqyLCEqPXS8PEPSrbaaVMyeep4UWN6
         +KLu0fzN9iA13TGaZLNIHEvXklkpUMjZXj75OZz2POy3DkkKEvoA0QJhqjdZTfHO2Y5J
         dqdaugZnpWprvsetQUZGhYPoySmV4oK7oCUiA1PKfndFGc4K6xOkfx4jghLZ5Yx76+LE
         HCSMHZkHYRFMAEFgXJDqLSIsUSk+rYYDFrW4K+C5KkEBDJb2eGId1haCcTbxuGzAzv96
         hnIT1fRoic2/C8VfvrrwuiwJhO5B+uqQTdodQNl/tKjalRsPy2iRXqgtDn1lid5QWglB
         7msg==
X-Gm-Message-State: AC+VfDyEiGWyo9rQ+NKQwojc+0kxnn/EWEv0xLBfQ6i993YpyO5fee8x
        C6bDMZuw6SvQ2+/05HxtCLQX3+Wa9Og5i/ZL5mvS5eIzUVB+bjsRRW9WPFnDYUwuuUuAlKw2Wwc
        QvCWlwP2LURKjf9fGPyPBZOkAkhbM
X-Received: by 2002:ac2:5398:0:b0:4f1:3ca4:926f with SMTP id g24-20020ac25398000000b004f13ca4926fmr2305164lfh.21.1683790293479;
        Thu, 11 May 2023 00:31:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Wbc1XZdl4sGlowrfd/KP1k6He8tT2ctNUXs3FHeEquzBLM1HwcZ4pHvc+WQU60ovxrcq99qQ+d/QbDRRb6OU=
X-Received: by 2002:ac2:5398:0:b0:4f1:3ca4:926f with SMTP id
 g24-20020ac25398000000b004f13ca4926fmr2305152lfh.21.1683790293117; Thu, 11
 May 2023 00:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230424204411.24888-1-asmetanin@yandex-team.ru>
In-Reply-To: <20230424204411.24888-1-asmetanin@yandex-team.ru>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 11 May 2023 15:31:22 +0800
Message-ID: <CACGkMEsqXoXPLAxuzs-2wAvouwnqe_Q7Z9A=EROoqfjHgD849A@mail.gmail.com>
Subject: Re: [PATCH v2] vhost_net: revert upend_idx only on retriable error
To:     Andrey Smetanin <asmetanin@yandex-team.ru>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023 at 4:44=E2=80=AFAM Andrey Smetanin
<asmetanin@yandex-team.ru> wrote:
>
> Fix possible virtqueue used buffers leak and corresponding stuck
> in case of temporary -EIO from sendmsg() which is produced by
> tun driver while backend device is not up.
>
> In case of no-retriable error and zcopy do not revert upend_idx
> to pass packet data (that is update used_idx in corresponding
> vhost_zerocopy_signal_used()) as if packet data has been
> transferred successfully.
>
> v2: set vq->heads[ubuf->desc].len equal to VHOST_DMA_DONE_LEN
> in case of fake successful transmit.
>
> Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/net.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 20265393aee7..0791fbdb3975 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -934,13 +934,18 @@ static void handle_tx_zerocopy(struct vhost_net *ne=
t, struct socket *sock)
>
>                 err =3D sock->ops->sendmsg(sock, &msg, len);
>                 if (unlikely(err < 0)) {
> +                       bool retry =3D err =3D=3D -EAGAIN || err =3D=3D -=
ENOMEM || err =3D=3D -ENOBUFS;
> +
>                         if (zcopy_used) {
>                                 if (vq->heads[ubuf->desc].len =3D=3D VHOS=
T_DMA_IN_PROGRESS)
>                                         vhost_net_ubuf_put(ubufs);
> -                               nvq->upend_idx =3D ((unsigned)nvq->upend_=
idx - 1)
> -                                       % UIO_MAXIOV;
> +                               if (retry)
> +                                       nvq->upend_idx =3D ((unsigned)nvq=
->upend_idx - 1)
> +                                               % UIO_MAXIOV;
> +                               else
> +                                       vq->heads[ubuf->desc].len =3D VHO=
ST_DMA_DONE_LEN;
>                         }
> -                       if (err =3D=3D -EAGAIN || err =3D=3D -ENOMEM || e=
rr =3D=3D -ENOBUFS) {
> +                       if (retry) {
>                                 vhost_discard_vq_desc(vq, 1);
>                                 vhost_net_enable_vq(net, vq);
>                                 break;
> --
> 2.25.1
>

