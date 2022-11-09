Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD0362228C
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiKIDZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiKIDZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:25:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0A91A056
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1qirjMG3kZUXL8rp78PkVsEriIi9ata3YC3IMmDFgo=;
        b=Rigx1i/2Ku9x3DLO5JOv66QoRAjFAwSu3neFsFQP7BdHMOqVhaPvr6OhOmOTdFtYqXCjG8
        Vsx7rRBBKheMAVSShyfO8qKpYM+iMbfvvDYGK5gdiS2bkkwCIIkqQAVVBv3FFIia1vSjV7
        xhwEL7dH2PAnBcJMIYO1JbuKUThpkLw=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-glIbiI6LM_ey842m3t2gXg-1; Tue, 08 Nov 2022 22:24:36 -0500
X-MC-Unique: glIbiI6LM_ey842m3t2gXg-1
Received: by mail-oo1-f70.google.com with SMTP id t9-20020a4a6049000000b00496bbda4343so4506679oof.22
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 19:24:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1qirjMG3kZUXL8rp78PkVsEriIi9ata3YC3IMmDFgo=;
        b=w4QQTkHu0q0mswh2Tqx+KFJsVVZLuH6snj1HVRJKL2XpY+9bnfq3RjU+TkcoxzFMpv
         nqyTw3GGsOXMKvJ9TLgKBbRB+uofm18l94neZd3khDn58s6LFecVw5ZllHl7WwzxYKZC
         113uYulj5E8T4hlkdoLIINP2AeAlRjsPxw2JoL6nhpBu+tdHmlSgCZqzmqQXcm2Oexpn
         SgB7QxBnN+7A4RcaqMtPA57lbJm8ApOQx7aEvDRVpg9lmIBt0+plMK4bSddPwH9PyVzh
         e4qe8pO7P6sx5peR+TNmP5DfPlLWotajFvMFvU/kgNOzjr9GeWYo8OWbT/U9MwolhA7D
         5RQQ==
X-Gm-Message-State: ACrzQf1LFqg0hIiLk9yXRkRCpqji2NnrKLx/4gkIkycUtLWAqyt3F0Is
        2E1diJHht1Ak1lViK9YzrpH95gd1MMzLzSdW/TWR09wc/08Aet/nZ7/K9gb/ndkbPx2Qrrdiv7Z
        53cjQGXIBt21myRxXS7kcd3odOesq
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id o198-20020a4a2ccf000000b0049eb5023a2bmr9788970ooo.57.1667964275440;
        Tue, 08 Nov 2022 19:24:35 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4TS8SZHDk+F11XcIXyOjWg7x3CStUwgN7DXqTHrvfbCTUgELD600O6A1TkWZj32gJcP6VoqsHMRgJlXrNy6A0=
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id
 o198-20020a4a2ccf000000b0049eb5023a2bmr9788965ooo.57.1667964275202; Tue, 08
 Nov 2022 19:24:35 -0800 (PST)
MIME-Version: 1.0
References: <20221108103437.105327-1-sgarzare@redhat.com> <20221108103437.105327-2-sgarzare@redhat.com>
In-Reply-To: <20221108103437.105327-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:24:23 +0800
Message-ID: <CACGkMEu+T1zX0XQbe2NR24MBC1LfV6ECv6vOm7ofrvqCJZ4avA@mail.gmail.com>
Subject: Re: [PATCH 1/2] vringh: fix range used in iotlb_translate()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_iotlb_itree_first() requires `start` and `last` parameters
> to search for a mapping that overlaps the range.
>
> In iotlb_translate() we cyclically call vhost_iotlb_itree_first(),
> incrementing `addr` by the amount already translated, so rightly
> we move the `start` parameter passed to vhost_iotlb_itree_first(),
> but we should hold the `last` parameter constant.
>
> Let's fix it by saving the `last` parameter value before incrementing
> `addr` in the loop.
>
> Fixes: 9ad9c49cfe97 ("vringh: IOTLB support")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vringh.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 11f59dd06a74..828c29306565 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1102,7 +1102,7 @@ static int iotlb_translate(const struct vringh *vrh,
>         struct vhost_iotlb_map *map;
>         struct vhost_iotlb *iotlb = vrh->iotlb;
>         int ret = 0;
> -       u64 s = 0;
> +       u64 s = 0, last = addr + len - 1;
>
>         spin_lock(vrh->iotlb_lock);
>
> @@ -1114,8 +1114,7 @@ static int iotlb_translate(const struct vringh *vrh,
>                         break;
>                 }
>
> -               map = vhost_iotlb_itree_first(iotlb, addr,
> -                                             addr + len - 1);
> +               map = vhost_iotlb_itree_first(iotlb, addr, last);
>                 if (!map || map->start > addr) {
>                         ret = -EINVAL;
>                         break;
> --
> 2.38.1
>

