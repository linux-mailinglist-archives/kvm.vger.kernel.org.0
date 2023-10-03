Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5957B6E4F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjJCQXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjJCQXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:23:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9AB9E
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696350172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r147ix/t4ru4DZEC+DJrb4DBuvtWEoQLF9djs4ZSusI=;
        b=dmK00MI8rUdz8dNMG+dXtZHXscOaDR2C5QlfCVfAOQXsKlk6KILwQInDAuJo8dwtGKoE8K
        GAOJq6PMUGvUsJFriRxmadQMw0f06FMga9oN/F3Q/nRACd009ljLbY3eGBD5To5USHoYF4
        jceXA1fieHXGBUKYf5oT/5PJ9CaTyq0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-UOF2X8p9MdmSsdvyAyI87A-1; Tue, 03 Oct 2023 12:22:46 -0400
X-MC-Unique: UOF2X8p9MdmSsdvyAyI87A-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-65af758fa1eso12137856d6.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696350166; x=1696954966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r147ix/t4ru4DZEC+DJrb4DBuvtWEoQLF9djs4ZSusI=;
        b=JHsQtdDuKmjPZx0rIv2VH/Hd07RhCQdGL1+3G6pveouxMPQs1r7ke1M0wm5mdlSfJf
         jGHPP6UpuUaXAOU+NNYTJbEHOi0o9qErGBVLQnK5Y2w5aLVFSmBh2maxLw7o0qlwoqH3
         8Se4chtmy36yqUWr6vHKBSKnVN/86uG82Li8kwzRDkVZ8o47k7s1zolvP0DZxGBOT6JF
         KwnmYr5GlVDssQo/7C9BEE/qEJgAAmp945AOetCXxr9sAbzNxTQ35UHYJihATrVebT8Y
         AobgowBvLvZXwnbcG7V1Gg4pi4zs+wU4xT2aFqrgyLsf7Yt260NolrliI3fdE8p0/Urs
         no1w==
X-Gm-Message-State: AOJu0YxXRkJFFZsNN8UyVSF1468PXO+xgXzJcUBYSaSUYcmYNeGdvKw1
        bGHPzO4wYDYjF/Ldh86EVdlM9/8ceuhM1dEGRUvjmJ6u8LgmFFjMNe7x4ElzqiI2uu1Jgbi7ONy
        FzPCaoaTC+jlD
X-Received: by 2002:a05:6214:488d:b0:64f:51fe:859c with SMTP id pc13-20020a056214488d00b0064f51fe859cmr17355775qvb.43.1696350165791;
        Tue, 03 Oct 2023 09:22:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqvM306M50A2rjJC5L4OkATm7mDAd1KWNSEosWc5K4oFW+hSL2rCEcu1U+nylxnoxNFfNg/Q==
X-Received: by 2002:a05:6214:488d:b0:64f:51fe:859c with SMTP id pc13-20020a056214488d00b0064f51fe859cmr17355759qvb.43.1696350165512;
        Tue, 03 Oct 2023 09:22:45 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id a21-20020a0ca995000000b0063d162a8b8bsm612637qvb.19.2023.10.03.09.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:22:44 -0700 (PDT)
Date:   Tue, 3 Oct 2023 18:22:39 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v2 01/12] vsock: set EPOLLERR on non-empty error
 queue
Message-ID: <qylubfxwihribskuw25sc6rvvjv7rz2loz6h6sdea464hzpq36@5gdhsu363gnx>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-2-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230930210308.2394919-2-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 12:02:57AM +0300, Arseniy Krasnov wrote:
>If socket's error queue is not empty, EPOLLERR must be set. Otherwise,
>reader of error queue won't detect data in it using EPOLLERR bit.
>Currently for AF_VSOCK this is actual only with MSG_ZEROCOPY, as this
>feature is the only user of an error queue of the socket.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Update commit message by removing 'fix' word.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 013b65241b65..d841f4de33b0 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1030,7 +1030,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 	poll_wait(file, sk_sleep(sk), wait);
> 	mask = 0;
>
>-	if (sk->sk_err)
>+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
> 		/* Signify that there has been an error on this socket. */
> 		mask |= EPOLLERR;
>
>-- 
>2.25.1
>

