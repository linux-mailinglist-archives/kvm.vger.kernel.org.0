Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6515A7AF459
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbjIZTpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjIZTpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:45:18 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E3192;
        Tue, 26 Sep 2023 12:45:10 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id BD1E2120002;
        Tue, 26 Sep 2023 22:45:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru BD1E2120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695757508;
        bh=8AuffhX+jKHctjHjPx7p+8GVegWHoivqohrQEfoGK/0=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=BV6PyM7r85zpn7irrJsvdDDV4tgyyI1kAB44aKLDKw/+X7Ko/W9wew56mJj2Ju8MV
         fO1ef5kvoDmeRAANu0P8t19x75/7ThqMp3vgwi5WU58v7abvHBaQsTHYFigyja2CuF
         I9L2CWcBJDGBrMi8YFrBRDRJDwt8jm2Ik++d9XTLYg1w4VOCT8yLT66T/OzoTjDtfW
         e9F5FeHGhflL+oUX3RkRThtq1cHGhcfLJOax4+BLgX77RtPbI3oh9W67D4kMnPgNg+
         mVBYxvW0iLVZtfYs3HyFldRlWddz4LtXM8jgzJN0k4VSdnfG5edghRhgGBxwfoa0ox
         fhqH+ruqMiJEw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 26 Sep 2023 22:45:08 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 26 Sep 2023 22:45:08 +0300
Message-ID: <d27b863d-8576-2c9b-c6a6-c8e55d7dad68@salutedevices.com>
Date:   Tue, 26 Sep 2023 22:38:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 08/12] vsock: enable setting SO_ZEROCOPY
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-9-avkrasnov@salutedevices.com>
 <ynuctxau4ta4pk763ut7gfdaqzcuyve7uf2a2iltyspravs5uf@xrtqtbhuuvwq>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <ynuctxau4ta4pk763ut7gfdaqzcuyve7uf2a2iltyspravs5uf@xrtqtbhuuvwq>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180147 [Sep 26 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/26 14:54:00 #21988070
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.09.2023 15:56, Stefano Garzarella wrote:
> On Fri, Sep 22, 2023 at 08:24:24AM +0300, Arseniy Krasnov wrote:
>> For AF_VSOCK, zerocopy tx mode depends on transport, so this option must
>> be set in AF_VSOCK implementation where transport is accessible (if
>> transport is not set during setting SO_ZEROCOPY: for example socket is
>> not connected, then SO_ZEROCOPY will be enabled, but once transport will
>> be assigned, support of this type of transmission will be checked).
>>
>> To handle SO_ZEROCOPY, AF_VSOCK implementation uses SOCK_CUSTOM_SOCKOPT
>> bit, thus handling SOL_SOCKET option operations, but all of them except
>> SO_ZEROCOPY will be forwarded to the generic handler by calling
>> 'sock_setsockopt()'.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v5(big patchset) -> v1:
>>  * Compact 'if' conditions.
>>  * Rename 'zc_val' to 'zerocopy'.
>>  * Use 'zerocopy' value directly in 'sock_valbool_flag()', without
>>    ?: operator.
>>  * Set 'SOCK_CUSTOM_SOCKOPT' bit for connectible sockets only, as
>>    suggested by Bobby Eshleman <bobbyeshleman@gmail.com>.
>>
>> net/vmw_vsock/af_vsock.c | 46 ++++++++++++++++++++++++++++++++++++++--
>> 1 file changed, 44 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 482300eb88e0..c05a42e02a17 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1406,8 +1406,16 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>>             goto out;
>>         }
>>
>> -        if (vsock_msgzerocopy_allow(transport))
>> +        if (vsock_msgzerocopy_allow(transport)) {
>>             set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
>> +        } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>> +            /* If this option was set before 'connect()',
>> +             * when transport was unknown, check that this
>> +             * feature is supported here.
>> +             */
>> +            err = -EOPNOTSUPP;
>> +            goto out;
>> +        }
>>
>>         err = vsock_auto_bind(vsk);
>>         if (err)
>> @@ -1643,7 +1651,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>     const struct vsock_transport *transport;
>>     u64 val;
>>
>> -    if (level != AF_VSOCK)
>> +    if (level != AF_VSOCK && level != SOL_SOCKET)
>>         return -ENOPROTOOPT;
>>
>> #define COPY_IN(_v)                                       \
>> @@ -1666,6 +1674,34 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>>
>>     transport = vsk->transport;
>>
>> +    if (level == SOL_SOCKET) {
>> +        int zerocopy;
>> +
>> +        if (optname != SO_ZEROCOPY) {
>> +            release_sock(sk);
>> +            return sock_setsockopt(sock, level, optname, optval, optlen);
>> +        }
>> +
>> +        /* Use 'int' type here, because variable to
>> +         * set this option usually has this type.
>> +         */
>> +        COPY_IN(zerocopy);
>> +
>> +        if (zerocopy < 0 || zerocopy > 1) {
>> +            err = -EINVAL;
>> +            goto exit;
>> +        }
>> +
>> +        if (transport && !vsock_msgzerocopy_allow(transport)) {
>> +            err = -EOPNOTSUPP;
>> +            goto exit;
>> +        }
>> +
>> +        sock_valbool_flag(sk, SOCK_ZEROCOPY,
>> +                  zerocopy);
> 
> it's not necessary to wrap this call.

Sorry, what do you mean ?

Thanks, Arseniy

> 
>> +        goto exit;
>> +    }
>> +
>>     switch (optname) {
>>     case SO_VM_SOCKETS_BUFFER_SIZE:
>>         COPY_IN(val);
>> @@ -2322,6 +2358,12 @@ static int vsock_create(struct net *net, struct socket *sock,
>>         }
>>     }
>>
>> +    /* SOCK_DGRAM doesn't have 'setsockopt' callback set in its
>> +     * proto_ops, so there is no handler for custom logic.
>> +     */
>> +    if (sock_type_connectible(sock->type))
>> +        set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
>> +
>>     vsock_insert_unbound(vsk);
>>
>>     return 0;
>> -- 
>> 2.25.1
>>
> 
