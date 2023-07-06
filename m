Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264B074A2A2
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjGFQ4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjGFQ4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C91B1BDB
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78X1P2RbA2naQ6uRnxp6k32HKAIUnBp53PzVIigmGLg=;
        b=KE+98sW5HUo9y6qy3S42o6Q/92kmS0eiW1Ugg3eIuicm1eEMq//f8ZiXeYuM3EGnJOAor2
        mt5HXn6wDxJJgHv7Q6Gncuxe7dHxEQo2qX6+sTgTcP6AKXDJhMFn+CnFZ4kPY2VvpvJg1S
        y218uq3yME4sX3u68ZSw/1tEwr8BliI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-IE3SzW_lM1O3-YX0xYc8kQ-1; Thu, 06 Jul 2023 12:55:07 -0400
X-MC-Unique: IE3SzW_lM1O3-YX0xYc8kQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a355cf318so69156666b.2
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662506; x=1691254506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78X1P2RbA2naQ6uRnxp6k32HKAIUnBp53PzVIigmGLg=;
        b=BXUq6RC5fiVyDefvWMx8TDC/jsjsIOPKUxkWJZWmv3d7cvD6YT9NJim0sjp6ONAUTz
         p+L40Q+tWb1R2ZOqxTiEQEh1hhKhEneBFTQPj71EDQbP6vMNyslK3BA2W7nxP0C96KRB
         2Q8TJR+Q29I8bnBsrAGaAhmZLz8TWqVcgEA2uBA2y0pSzPcCBaYXW7K9BkOHJIVodX+H
         +5i86oXH7H2KNyh3wnMa3XogcsZ0AV7djjpwQdy9Q/J1WGb8LF8kLLoDmBLpUZA9a/om
         wu7Px8oZMG7Cacfnv7aNGtVdJR/JtoSykTaMcRSR6feUkjYjCxTz79GlGVqjWyaPo4Jw
         IK/w==
X-Gm-Message-State: ABy/qLY+2vBFtJoHSm+iFFjdspDXm6tQiLQe/wwZDBbN2kOdkQgbHBVn
        74dRupIre7OjsEBCpqsFzE1GVp9EiQtQTKeBHotchZRmEP913HHKg1LZhrFKwH/pqFQrsul40j3
        hddkBtXjjGWiM
X-Received: by 2002:a17:906:5185:b0:992:a9c3:244f with SMTP id y5-20020a170906518500b00992a9c3244fmr1583461ejk.4.1688662506006;
        Thu, 06 Jul 2023 09:55:06 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFnbcCuNIs/OppuWQYxPKp5Z8HDqdwHBAM1xNlziO52ksP44T7cMIPX6GA9m+5cSy54n0kP6Q==
X-Received: by 2002:a17:906:5185:b0:992:a9c3:244f with SMTP id y5-20020a170906518500b00992a9c3244fmr1583447ejk.4.1688662505832;
        Thu, 06 Jul 2023 09:55:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id hk15-20020a170906c9cf00b00991bba473e1sm1041884ejb.3.2023.07.06.09.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:55:05 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:55:03 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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
Subject: Re: [RFC PATCH v5 08/17] vsock: check for MSG_ZEROCOPY support on
 send
Message-ID: <xpc5urpiwj5adhqqtiumlnxwnljuv3jtepkzn6owju5quzuojh@m2bbycr6bnnj>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-9-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-9-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:38AM +0300, Arseniy Krasnov wrote:
>This feature totally depends on transport, so if transport doesn't
>support it, return error.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   | 7 +++++++
> net/vmw_vsock/af_vsock.c | 6 ++++++
> 2 files changed, 13 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 0e7504a42925..ec09edc5f3a0 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -177,6 +177,9 @@ struct vsock_transport {
>
> 	/* Read a single skb */
> 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>+
>+	/* Zero-copy. */
>+	bool (*msgzerocopy_allow)(void);
> };
>
> /**** CORE ****/
>@@ -243,4 +246,8 @@ static inline void __init vsock_bpf_build_proto(void)
> {}
> #endif
>
>+static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
>+{
>+	return t->msgzerocopy_allow && t->msgzerocopy_allow();
>+}
> #endif /* __AF_VSOCK_H__ */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 07803d9fbf6d..033006e1b5ad 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1824,6 +1824,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 		goto out;
> 	}
>
>+	if (msg->msg_flags & MSG_ZEROCOPY &&
>+	    !vsock_msgzerocopy_allow(transport)) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
> 	/* Wait for room in the produce queue to enqueue our user's data. */
> 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>
>-- 
>2.25.1
>

