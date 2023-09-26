Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EEA7AF450
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjIZToM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 15:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjIZToL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 15:44:11 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F829D;
        Tue, 26 Sep 2023 12:44:03 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 2F0B0100003;
        Tue, 26 Sep 2023 22:44:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 2F0B0100003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695757441;
        bh=t3IvS31bI7a9Eofr4b9E0vnjGLlMHgTojZ+Zo/pyiAQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=ttwecfiNBQeOhZnkECWhdSfEz9V7mQgYGWtj4EY6LTD/8QpJRN6HcL3Lp5Fn5dEql
         HPOP7ilNIepOrcR8MNS4MPbe8LCqEjG3Q2JvwsrycJcieI3wnJ36dYum+ueN9PiPij
         nK9uNIHDavq/3dKigjECM7hyWMIl7DSUwpP5NXN/rkkBRJWNaGxGjcFNLfddOWLy/6
         jzmkt74NLN0BaqHdWxwod9gUxa978XvzsH7pCKaz4Adu+tzW3hDqvltWhW//2W/fPR
         t40qnLrGcyxfhhjLgoe5ApeQEARi/DfMwMoz6beF2TYsq7XFBn+yJlCNxobomJKjKA
         o27beEk42Bl2g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 26 Sep 2023 22:43:59 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 26 Sep 2023 22:43:59 +0300
Message-ID: <ed26b2b7-bafc-a964-00e2-70da66640e46@salutedevices.com>
Date:   Tue, 26 Sep 2023 22:36:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 02/12] vsock: read from socket's error queue
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
 <20230922052428.4005676-3-avkrasnov@salutedevices.com>
 <3oys2ouhlkitsjx7q7utp7wkitnnl4kisl2r54wwa2addd644p@jzyu7ubfrcog>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <3oys2ouhlkitsjx7q7utp7wkitnnl4kisl2r54wwa2addd644p@jzyu7ubfrcog>
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
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/26 14:54:00 #21988070
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.09.2023 15:55, Stefano Garzarella wrote:
> On Fri, Sep 22, 2023 at 08:24:18AM +0300, Arseniy Krasnov wrote:
>> This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
>> is used to read socket's error queue instead of data queue. Possible
>> scenario of error queue usage is receiving completions for transmission
>> with MSG_ZEROCOPY flag. This patch also adds new defines: 'SOL_VSOCK'
>> and 'VSOCK_RECVERR'.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v5(big patchset) -> v1:
>>  * R-b tag removed, due to added defines to 'include/uapi/linux/vsock.h'.
>>    Both 'SOL_VSOCK' and 'VSOCK_RECVERR' are needed by userspace, so
>>    they were placed to 'include/uapi/linux/vsock.h'. At the same time,
>>    the same define for 'SOL_VSOCK' was placed to 'include/linux/socket.h'.
>>    This is needed because this file contains SOL_XXX defines for different
>>    types of socket, so it prevents situation when another new SOL_XXX
>>    will use constant 287.
>>
>> include/linux/socket.h     | 1 +
>> include/uapi/linux/vsock.h | 9 +++++++++
>> net/vmw_vsock/af_vsock.c   | 6 ++++++
>> 3 files changed, 16 insertions(+)
>> create mode 100644 include/uapi/linux/vsock.h
>>
>> diff --git a/include/linux/socket.h b/include/linux/socket.h
>> index 39b74d83c7c4..cfcb7e2c3813 100644
>> --- a/include/linux/socket.h
>> +++ b/include/linux/socket.h
>> @@ -383,6 +383,7 @@ struct ucred {
>> #define SOL_MPTCP    284
>> #define SOL_MCTP    285
>> #define SOL_SMC        286
>> +#define SOL_VSOCK    287
>>
>> /* IPX options */
>> #define IPX_TYPE    1
>> diff --git a/include/uapi/linux/vsock.h b/include/uapi/linux/vsock.h
>> new file mode 100644
>> index 000000000000..b25c1347a3b8
>> --- /dev/null
>> +++ b/include/uapi/linux/vsock.h
> 
> We already have include/uapi/linux/vm_sockets.h
> 
> Should we include these changes there instead of creating a new header?
> 
>> @@ -0,0 +1,9 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +#ifndef _UAPI_LINUX_VSOCK_H
>> +#define _UAPI_LINUX_VSOCK_H
>> +
>> +#define SOL_VSOCK    287
> 
> Why we need to re-define this also here?

Reason of this re-define is that SOL_VSOCK must be exported to userspace, so
i place it to include/uapi/XXX. At the same time include/linux/socket.h contains
constants for SOL_XXX and they goes sequentially in this file (e.g. one by one,
each new value is +1 to the previous). So if I add SOL_VSOCK to include/uapi/XXX
only, it is possible that someone will add new SOL_VERY_NEW_SOCKET == 287 to
include/linux/socket.h in future. I think it is not good that two SOL_XXX will
have same value.

For example SOL_RDS and SOL_TIPS uses the same approach - there are two same defines:
one in include/uapi/ and another is in include/linux/socket.h

> 
> In that case, should we protect with some guards to avoid double
> defines?

May be:

in include/linux/socket.h

#ifndef SOL_VSOCK
#define SOL_VSOCK 287
#endif

But not sure...

> 
>> +
>> +#define VSOCK_RECVERR    1
>> +
>> +#endif /* _UAPI_LINUX_VSOCK_H */
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index d841f4de33b0..4fd11bf34bc7 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -110,6 +110,8 @@
>> #include <linux/workqueue.h>
>> #include <net/sock.h>
>> #include <net/af_vsock.h>
>> +#include <linux/errqueue.h>
>> +#include <uapi/linux/vsock.h>
>>
>> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
>> static void vsock_sk_destruct(struct sock *sk);
>> @@ -2137,6 +2139,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>     int err;
>>
>>     sk = sock->sk;
>> +
>> +    if (unlikely(flags & MSG_ERRQUEUE))
>> +        return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, VSOCK_RECVERR);
>> +
>>     vsk = vsock_sk(sk);
>>     err = 0;
>>
>> -- 
>> 2.25.1
>>
> 
