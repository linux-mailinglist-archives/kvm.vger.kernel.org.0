Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310F47865D2
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 05:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239598AbjHXDZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 23:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239592AbjHXDY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 23:24:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95D610EC
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 20:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692847446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPglN9jWCOWkDHiaVESzd3fbifjjVGG3Y2tLlmCAqyw=;
        b=VxK3WDYbTykeW3YuyAts0vGA7HmODQhnNmzV8yauMtAgjaTW30n5bfxkrhidypQXvMW2/B
        +NAIEBWyK4/WCBz5seGelMR1IF2BNPdzaynd2qK3mTwzv7Gn1/NbM+nSKtpBdcWY6lykqo
        JpM85qjPreGIEUzG2erR0i49dZ8Duik=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-lUOBWhmTMpazIf8N8SNgVw-1; Wed, 23 Aug 2023 23:24:04 -0400
X-MC-Unique: lUOBWhmTMpazIf8N8SNgVw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bcc5098038so38886871fa.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 20:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692847443; x=1693452243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yPglN9jWCOWkDHiaVESzd3fbifjjVGG3Y2tLlmCAqyw=;
        b=Pj/xLowXhzVw7sfHv9SE+6dyr8Rgd8zbvJr/59f7wNS/EvfQLOoR/pXpwxwas4D+UN
         phJYxpLTzr1jSm6evPRyqj0pCa6v+wsDR4nkP/gV2rjLp6Sd2y9e94TUQ1Ue59ytA9RJ
         /EAL+d4Ly3zIoCqQAvuUxTmh81Y9+qIM11ZUVmZD8oZuCkRcvTmVt6VpvkhXgpVhfpxZ
         ZWCK1oFmC+RBGAzafFYmGGK68iM7oXCmO5iPKx4jXeQaswG5PyydY0rtySYOvTr0PsSu
         6TU4DauWMxGToESAA6gabG7aJhExjOVMtjWPsm81x4ZBu3I6xd2KqYWZ7rq9WcmkY8p+
         J2oA==
X-Gm-Message-State: AOJu0YzZuXDW7efMb2E8Q7RONCr4g1hiCnTZU1ej4OPz0r6SCBNdVPmC
        vf2buySTKpyNLqGdRKCO5BBvli5XhM4vSSqU3AofNvh1MElH0FzG0C7tzYFy3lj8ZEnvX5qSJln
        XOXFFMKQd5u5M8Am71RgMVOPCt3/N
X-Received: by 2002:a2e:b710:0:b0:2b5:80e0:f18e with SMTP id j16-20020a2eb710000000b002b580e0f18emr11256986ljo.3.1692847443057;
        Wed, 23 Aug 2023 20:24:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjkeGqdviCPH5wTUExjQLr+CqEbEiWt/ba0nY6S4lLgHFwDlCy0ER84ojf2Z39Sci9dtg33fDr0zJFePv+spQ=
X-Received: by 2002:a2e:b710:0:b0:2b5:80e0:f18e with SMTP id
 j16-20020a2eb710000000b002b580e0f18emr11256978ljo.3.1692847442724; Wed, 23
 Aug 2023 20:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230823153032.239304-1-eric.auger@redhat.com>
In-Reply-To: <20230823153032.239304-1-eric.auger@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 24 Aug 2023 11:23:51 +0800
Message-ID: <CACGkMEseBgbQx1ESA+QV_Y+BDdmwYPVg1UjUu2G0S2B6ksDeyQ@mail.gmail.com>
Subject: Re: [PATCH] vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, elic@nvidia.com, mail@anirudhrb.com,
        mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023 at 11:30=E2=80=AFPM Eric Auger <eric.auger@redhat.com>=
 wrote:
>
> Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
> entries") Forbade vhost iotlb msg with null size to prevent entries
> with size =3D start =3D 0 and last =3D ULONG_MAX to end up in the iotlb.
>
> Then commit 95932ab2ea07 ("vhost: allow batching hint without size")
> only applied the check for VHOST_IOTLB_UPDATE and VHOST_IOTLB_INVALIDATE
> message types to fix a regression observed with batching hit.
>
> Still, the introduction of that check introduced a regression for
> some users attempting to invalidate the whole ULONG_MAX range by
> setting the size to 0. This is the case with qemu/smmuv3/vhost
> integration which does not work anymore. It Looks safe to partially
> revert the original commit and allow VHOST_IOTLB_INVALIDATE messages
> with null size. vhost_iotlb_del_range() will compute a correct end
> iova. Same for vhost_vdpa_iotlb_unmap().
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Cc: stable@vger.kernel.org

I think we need to document the usage of 0 as msg.size for
IOTLB_INVALIDATE in uapi.

Other than this:

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entri=
es")
> ---
>  drivers/vhost/vhost.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c71d573f1c94..e0c181ad17e3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1458,9 +1458,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>                 goto done;
>         }
>
> -       if ((msg.type =3D=3D VHOST_IOTLB_UPDATE ||
> -            msg.type =3D=3D VHOST_IOTLB_INVALIDATE) &&
> -            msg.size =3D=3D 0) {
> +       if (msg.type =3D=3D VHOST_IOTLB_UPDATE && msg.size =3D=3D 0) {
>                 ret =3D -EINVAL;
>                 goto done;
>         }
> --
> 2.41.0
>

