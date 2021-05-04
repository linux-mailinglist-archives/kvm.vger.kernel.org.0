Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1BB3727C8
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 11:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhEDJGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 05:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhEDJGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 05:06:15 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9298FC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 02:05:20 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v123so6445066ioe.10
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 02:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbsIVpSzOqKCxf1/BEytXw5/aJTW1x58VGkF7dnUL34=;
        b=DVWU+Dsi8RKxW0nOLNSUUPIpmLx909iDNX+6P78T3nnEn/BrPxyOA/ZKimt2FxXDe0
         pDBHzh53J4o7GkZxdaEm+OzzNRcwX2LFICD36eNa9nY6LX1nQNcCjQuwv8sq+cN+ovuW
         Bn+uxyDk8YUCTNuBztjnuTuXpMNGLw5vU+wn/7Jpm1mNyVoGubosHvnUqpf3+JweZWfH
         y2cmZqqIaUOHQTm2jXE5WS+VkLuLexQkMo5AFu97Ua+RW153KLfn4stTLDCIF5N45PSK
         acgnZJO5Ht7Yv7lGlK9/6v66VzfyIh8vtPRx06eymH8fMe+P3rsb1/+dsvkuni71gVWP
         l4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbsIVpSzOqKCxf1/BEytXw5/aJTW1x58VGkF7dnUL34=;
        b=EMpo1NEX+hduMLTWlJxfjCjGVGPmFdU0JR0OFKHab7qx7T/I+35w0yVI1h+fQDE2Ja
         N/r+qkR39NmE17NyXxvqA2FdihA8UNWP50WXIpdCYo7BBDm+Bcd+P3xjjmRVJZE03JS4
         RzWPPTEluyCM/Fs9mqKJwuJ6wSJOZRZPmOfhzMBngiqNo9x4ShB2Bp0anrQVdUaUnN94
         i8eqcciDn54UPoexQSNL0aAsJ0Ym459t6EIu23q9v4lGyRwbyYAADE3cHzVODJ4jX2iV
         3OOvVfRycRZolvMaVeL30QiWrvLGEKn+out5fBGa2x444qdWDX5f3d54I9H6ZJY3UJjU
         gS5Q==
X-Gm-Message-State: AOAM533DBahwYgFcV8g4nWRrF6B9H4zxDIbf3d/h2Vinb/9vvzLNVB2Z
        BlZM/aXvsS+2imDHD/PQohThLyiIadiojBu1/i7gkvjyd/RQfQ==
X-Google-Smtp-Source: ABdhPJzZIrxVdXV1y+Ga2yUVf6D/4eMeE/k/ecvvmyY3YiSfSMFQvUrpGtKJS5mFhPe6fg3gnHB8qm1NqxSylqgMPq4=
X-Received: by 2002:a05:6638:a2c:: with SMTP id 12mr22329922jao.99.1620119120085;
 Tue, 04 May 2021 02:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210502093319.61313-1-mgurtovoy@nvidia.com>
In-Reply-To: <20210502093319.61313-1-mgurtovoy@nvidia.com>
From:   Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Date:   Tue, 4 May 2021 11:05:08 +0200
Message-ID: <CAM9Jb+iOBxu0o5THFNNTJx4qQ8ZXHpD020T5ZwfZYnsHy+8Hjg@mail.gmail.com>
Subject: Re: [PATCH 1/1] virtio-net: don't allocate control_buf if not supported
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Not all virtio_net devices support the ctrl queue feature. Thus, there
> is no need to allocate unused resources.
>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/net/virtio_net.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7fda2ae4c40f..9b6a4a875c55 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2870,9 +2870,13 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>  {
>         int i;
>
> -       vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> -       if (!vi->ctrl)
> -               goto err_ctrl;
> +       if (vi->has_cvq) {
> +               vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> +               if (!vi->ctrl)
> +                       goto err_ctrl;
> +       } else {
> +               vi->ctrl = NULL;
> +       }
>         vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
>         if (!vi->sq)
>                 goto err_sq;

Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
