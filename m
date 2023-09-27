Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8E77AFC2A
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 09:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjI0Hg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 03:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjI0HgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 03:36:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45022BF
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695800137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ap6jvf8/2CoqbMpAwThp0QoWymIsVaHbvqKSWQ1uNLM=;
        b=DxqZbid8+SG9xtUkotqnGYLLppNEf+Q7lITn0rNcTt4RqNFfk4TQ9tu9PI1fme8nrXa1cA
        150h+wGO8tagfGOGSLfqzs74ibdwKMQ1Gsr7g35SwoW9DmMuxQ21G/p+qOuCqFjos5m2HV
        r3yP+dOxVXMtwNHf5QlnB9E+oBIMxGQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-Dm47Ps5OOEmEO-v_dLb9oQ-1; Wed, 27 Sep 2023 03:35:36 -0400
X-MC-Unique: Dm47Ps5OOEmEO-v_dLb9oQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40647c6f71dso1630115e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 00:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695800135; x=1696404935;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ap6jvf8/2CoqbMpAwThp0QoWymIsVaHbvqKSWQ1uNLM=;
        b=gt9kQFDr4Y+ytszegpnCR9HD/QUl/52h/nayyUA2fKLlJXZBUb/QbEizgfnfVfH5Av
         gmjCBc9ZB372OdLZE4wHI+D94HlV36kGVD4sWdpeni7GtJLTBv8ffOxdsMK8U2+ZipzO
         y0Nz+yNIfDo3SQiFe3behMCEeObMDlrn8MNPw0we3HiqPQ9jne0u2PAiB9jtGIZpCFjn
         haN29BFnel5wEbBW4cudfx9BmyGyyktDMm3bf2Krt4ro4KuXTLMwnOGlVOvMiDpU1NF9
         XkZw86Yv/Pu0PugJ8BVOU+l9CqhP6+1OPZ9OAAVUdW+Tir6wtp7sbjwM1EFFJz2ji5pe
         fWgw==
X-Gm-Message-State: AOJu0Yx1fCyHW+KADTuh67nUkbxq3U9Guuv9Pyf2gZxHhPs0wM0o8bMz
        INRKofXZGkZ0ezeakmMFkHfn1DpBnGXhMMcMO4EVOtEwjqGHV6FU65dMsh3pBB8C+2b7WF8J+1o
        LN/QexZpFffcK
X-Received: by 2002:a7b:ce94:0:b0:401:c944:a4d6 with SMTP id q20-20020a7bce94000000b00401c944a4d6mr1190431wmj.28.1695800134939;
        Wed, 27 Sep 2023 00:35:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNeo+a3D1T3OSxeUepQ732xUxuE+Jh5ew/NsV6Yu1nas54YVkW3cnsBtEB4qZvL4QfCzEH8w==
X-Received: by 2002:a7b:ce94:0:b0:401:c944:a4d6 with SMTP id q20-20020a7bce94000000b00401c944a4d6mr1190398wmj.28.1695800134503;
        Wed, 27 Sep 2023 00:35:34 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.19.70])
        by smtp.gmail.com with ESMTPSA id 19-20020a05600c029300b004060f0a0fdbsm4495926wmk.41.2023.09.27.00.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 00:35:33 -0700 (PDT)
Date:   Wed, 27 Sep 2023 09:35:31 +0200
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
Subject: Re: [PATCH net-next v1 08/12] vsock: enable setting SO_ZEROCOPY
Message-ID: <n4si4yyqs2svmvhueyxxyev2v3wxugzjjb25wpyveg3ns5nv6i@cfb4fyq5kdaf>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-9-avkrasnov@salutedevices.com>
 <ynuctxau4ta4pk763ut7gfdaqzcuyve7uf2a2iltyspravs5uf@xrtqtbhuuvwq>
 <d27b863d-8576-2c9b-c6a6-c8e55d7dad68@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d27b863d-8576-2c9b-c6a6-c8e55d7dad68@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 10:38:06PM +0300, Arseniy Krasnov wrote:
>
>
>On 26.09.2023 15:56, Stefano Garzarella wrote:
>> On Fri, Sep 22, 2023 at 08:24:24AM +0300, Arseniy Krasnov wrote:
>>> For AF_VSOCK, zerocopy tx mode depends on transport, so this option must
>>> be set in AF_VSOCK implementation where transport is accessible (if
>>> transport is not set during setting SO_ZEROCOPY: for example socket is
>>> not connected, then SO_ZEROCOPY will be enabled, but once transport will
>>> be assigned, support of this type of transmission will be checked).
>>>
>>> To handle SO_ZEROCOPY, AF_VSOCK implementation uses SOCK_CUSTOM_SOCKOPT
>>> bit, thus handling SOL_SOCKET option operations, but all of them except
>>> SO_ZEROCOPY will be forwarded to the generic handler by calling
>>> 'sock_setsockopt()'.
>>>
>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> ---
>>> Changelog:
>>> v5(big patchset) -> v1:
>>>  * Compact 'if' conditions.
>>>  * Rename 'zc_val' to 'zerocopy'.
>>>  * Use 'zerocopy' value directly in 'sock_valbool_flag()', without
>>>    ?: operator.
>>>  * Set 'SOCK_CUSTOM_SOCKOPT' bit for connectible sockets only, as
>>>    suggested by Bobby Eshleman <bobbyeshleman@gmail.com>.
>>>
>>> net/vmw_vsock/af_vsock.c | 46 ++++++++++++++++++++++++++++++++++++++--
>>> 1 file changed, 44 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index 482300eb88e0..c05a42e02a17 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1406,8 +1406,16 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>>>             goto out;
>>>         }
>>>
>>> -        if (vsock_msgzerocopy_allow(transport))
>>> +        if (vsock_msgzerocopy_allow(transport)) {
>>>             set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
>>> +        } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>> +            /* If this option was set before 'connect()',
>>> +             * when transport was unknown, check that this
>>> +             * feature is supported here.
>>> +             */
>>> +            err = -EOPNOTSUPP;
>>> +            goto out;
>>> +        }
>>>
>>>         err = vsock_auto_bind(vsk);
>>>         if (err)
>>> @@ -1643,7 +1651,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>>     const struct vsock_transport *transport;
>>>     u64 val;
>>>
>>> -    if (level != AF_VSOCK)
>>> +    if (level != AF_VSOCK && level != SOL_SOCKET)
>>>         return -ENOPROTOOPT;
>>>
>>> #define COPY_IN(_v)                                       \
>>> @@ -1666,6 +1674,34 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>>
>>>     transport = vsk->transport;
>>>
>>> +    if (level == SOL_SOCKET) {
>>> +        int zerocopy;
>>> +
>>> +        if (optname != SO_ZEROCOPY) {
>>> +            release_sock(sk);
>>> +            return sock_setsockopt(sock, level, optname, optval, optlen);
>>> +        }
>>> +
>>> +        /* Use 'int' type here, because variable to
>>> +         * set this option usually has this type.
>>> +         */
>>> +        COPY_IN(zerocopy);
>>> +
>>> +        if (zerocopy < 0 || zerocopy > 1) {
>>> +            err = -EINVAL;
>>> +            goto exit;
>>> +        }
>>> +
>>> +        if (transport && !vsock_msgzerocopy_allow(transport)) {
>>> +            err = -EOPNOTSUPP;
>>> +            goto exit;
>>> +        }
>>> +
>>> +        sock_valbool_flag(sk, SOCK_ZEROCOPY,
>>> +                  zerocopy);
>>
>> it's not necessary to wrap this call.
>
>Sorry, what do you mean ?

I mean that can be on the same line:

	sock_valbool_flag(sk, SOCK_ZEROCOPY, zerocopy);

Stefano

