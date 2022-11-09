Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD34622296
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiKID3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKID3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:29:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B60B2408E
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vD224Hogxka5wNQa91Zymh6Ygmv+WpD4Z+GDd/Nec64=;
        b=KI8Bh2AKVRgiuJ9ox06JgNEYlfJcuLzZJjt9mcOJDFKWrLUk9ZW+C4cITtf02YVFx58iFV
        Wh9sU3CVk5LQSo2QsryqA3n5cQw+Qem0B+2AoHkImP5B1jMH8YWxGTzwrhfCkP1L52erWR
        wuOU91tMY8TRblJQhwE+BimAH+4CY24=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-S8Ad27HaNnSo_BHtd0Dk0A-1; Tue, 08 Nov 2022 22:28:55 -0500
X-MC-Unique: S8Ad27HaNnSo_BHtd0Dk0A-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13b88262940so8025865fac.15
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 19:28:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD224Hogxka5wNQa91Zymh6Ygmv+WpD4Z+GDd/Nec64=;
        b=4pWEsjEuUFk+8dxewFN5cdghir8SJGu+CsCF1fIDVA518lhIUsoxAkpay1t7pUxl5O
         aWJwcHoi88VpoM3HaEFckoIebj6/BM2wPeQw/29xJKrWTP47x/SlTJKdQ6zEDkMQ9Wlm
         3LYhyEFuogON6KUGr0YMUGwKEG8r25mIvwIZvmQpZJi/8zRRTFxK3g9kFuv9AUqjc63h
         5qFxSDjo0hwSi7xgjNB/a9Bq3B0///fSeHSHiN2RTAZLyIQZdu9rhpqVlzQbmByNB8lO
         palgfq8Gt+AAIr9fEYXl4W3tPls6Ih/U2+UdNE2R1Ddw/DeCWYdRx7wcYvjXQVwykO/9
         v7+w==
X-Gm-Message-State: ACrzQf19B0m1nnZ5UqmKTEWs6zdoaO68yhqYqQL4DlNkS5y8UI95nDDT
        2ycnrMzcGajJ9hlbuJovvKN7cX41kubXKlBgp+OR2GnbvB1J9N/elcAKNCpZ7+tVyxkDuK5txQS
        YstEMJ1dVdv2zsyx4XSBxhSOhm0JT
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id o198-20020a4a2ccf000000b0049eb5023a2bmr9793071ooo.57.1667964533309;
        Tue, 08 Nov 2022 19:28:53 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7F+ESUW02GevhFXeHeZiWN+C8qmGvnQrxAgchRgTHWuxrTWr/5I2RPYR7pW6CVQHNQHYEXuWSbcbl1kJXQxyk=
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id
 o198-20020a4a2ccf000000b0049eb5023a2bmr9793067ooo.57.1667964533083; Tue, 08
 Nov 2022 19:28:53 -0800 (PST)
MIME-Version: 1.0
References: <20221108103437.105327-1-sgarzare@redhat.com> <20221108103437.105327-3-sgarzare@redhat.com>
In-Reply-To: <20221108103437.105327-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:28:41 +0800
Message-ID: <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
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
> In translate_desc() we cyclically call vhost_iotlb_itree_first(),
> incrementing `addr` by the amount already translated, so rightly
> we move the `start` parameter passed to vhost_iotlb_itree_first(),
> but we should hold the `last` parameter constant.
>
> Let's fix it by saving the `last` parameter value before incrementing
> `addr` in the loop.
>
> Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> I'm not sure about the fixes tag. On the one I used this patch should
> apply cleanly, but looking at the latest stable (4.9), maybe we should
> use
>
> Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")

I think this should be the right commit to fix.

Other than this

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>
> Suggestions?
> ---
>  drivers/vhost/vhost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..3c2359570df9 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2053,7 +2053,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>         struct vhost_dev *dev = vq->dev;
>         struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
>         struct iovec *_iov;
> -       u64 s = 0;
> +       u64 s = 0, last = addr + len - 1;
>         int ret = 0;
>
>         while ((u64)len > s) {
> @@ -2063,7 +2063,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>                         break;
>                 }
>
> -               map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
> +               map = vhost_iotlb_itree_first(umem, addr, last);
>                 if (map == NULL || map->start > addr) {
>                         if (umem != dev->iotlb) {
>                                 ret = -EFAULT;
> --
> 2.38.1
>

