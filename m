Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076DA73E43E
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjFZQJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjFZQJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:09:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BC910F6
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVw/Wv9H1+jgHlFyXB8K46FNsZdoHq7Qo4C7jHkkuH8=;
        b=Uq8bXJlN3GE4NZs1yzqFs78sDoboE5uODq3+WLMvNtXTr84noXM5Zgcde7/v4HQ/bTMbiY
        E7lU1/b6Hoj7rFg7zBLq92acUdXpcMSUlBY6Cvi9bH/Zb2XDSVUhmMIVT++sVHgKvdCd2T
        6ntrWUXgQk7LskN5jgVYJFWYVwNmy4E=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-0EoqNQ1_PGGIPDfUapP0fQ-1; Mon, 26 Jun 2023 12:08:46 -0400
X-MC-Unique: 0EoqNQ1_PGGIPDfUapP0fQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-635d9e482f1so18567766d6.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795722; x=1690387722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVw/Wv9H1+jgHlFyXB8K46FNsZdoHq7Qo4C7jHkkuH8=;
        b=UC7KY8S7VaE6VliMk/Ehof380BgSkeu9ypgcxPAUAeICUyWAuL044+Yhf50iUyDQbr
         ult336d5raikmzzpqXrT/mTEl1hC4XD7VpzU9InTTqNuWK3wcV1pq6xSVORdMGf5326q
         vwqUiUUfxpS4dBQbDqjG+37HSEnHArBsyvQi6MafHPJJ2B0D6EWV2gXnYkloCClyxMxY
         CZ0h6Ic4Oxu+PhxPKJk9pBsc0x2vc3nqMe4LKQIX8I7NynblN+3pKeVlM1oJRTXUXV++
         3GJqaMrK8pr3yz1urCX4L+imX+Zo2ueaL9liCdXZp7UfmMGASxah8VQhSW0zG914uA27
         VcQA==
X-Gm-Message-State: AC+VfDzBMsvmLLdv10at8neE98eGrxt8k/tbNfZwX/Mai0drgJKzU1a+
        FkcrUd/iOyOQONsHLfhHaJ7lu14hT2cReGyT7bdnYVdDXcsFwisG3pejp4S9mwi5kg6NbWs1bLE
        tle4rUSabPzbV
X-Received: by 2002:a05:6214:27c9:b0:62d:f515:9320 with SMTP id ge9-20020a05621427c900b0062df5159320mr36074262qvb.28.1687795722195;
        Mon, 26 Jun 2023 09:08:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5raYOLH44gjALQWDUf6IbJggeYwYWXvVHtOWcRvbl3wuo2Ee6zIMMrWONEOeu5ohWrGHlbZg==
X-Received: by 2002:a05:6214:27c9:b0:62d:f515:9320 with SMTP id ge9-20020a05621427c900b0062df5159320mr36074244qvb.28.1687795721957;
        Mon, 26 Jun 2023 09:08:41 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id l13-20020ad44d0d000000b0063227969cf7sm3308298qvl.96.2023.06.26.09.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:08:41 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:08:36 +0200
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
Subject: Re: [RFC PATCH v4 07/17] vsock: read from socket's error queue
Message-ID: <sq5jlfhhlj347uapazqnotc5rakzdvj33ruzqwxdjsfx275m5r@dxujwphcffkl>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-8-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-8-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 03, 2023 at 11:49:29PM +0300, Arseniy Krasnov wrote:
>This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
>is used to read socket's error queue instead of data queue. Possible
>scenario of error queue usage is receiving completions for transmission
>with MSG_ZEROCOPY flag.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/linux/socket.h   | 1 +
> net/vmw_vsock/af_vsock.c | 5 +++++
> 2 files changed, 6 insertions(+)
>
>diff --git a/include/linux/socket.h b/include/linux/socket.h
>index bd1cc3238851..d79efd026880 100644
>--- a/include/linux/socket.h
>+++ b/include/linux/socket.h
>@@ -382,6 +382,7 @@ struct ucred {
> #define SOL_MPTCP	284
> #define SOL_MCTP	285
> #define SOL_SMC		286
>+#define SOL_VSOCK	287

Maybe this change should go in another patch where we describe that
we need to support setsockopt()

>
> /* IPX options */
> #define IPX_TYPE	1
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 45fd20c4ed50..07803d9fbf6d 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -110,6 +110,7 @@
> #include <linux/workqueue.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>+#include <linux/errqueue.h>
>
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
>@@ -2135,6 +2136,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	int err;
>
> 	sk = sock->sk;
>+
>+	if (unlikely(flags & MSG_ERRQUEUE))
>+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
>+
> 	vsk = vsock_sk(sk);
> 	err = 0;
>
>-- 
>2.25.1
>

