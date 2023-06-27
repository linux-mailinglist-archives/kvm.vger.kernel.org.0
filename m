Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E360373F3BA
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 06:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjF0EuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 00:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjF0Et0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 00:49:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553F8DA;
        Mon, 26 Jun 2023 21:49:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 6EDAF5FD20;
        Tue, 27 Jun 2023 07:49:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687841362;
        bh=V807p3ZyYW7VozU/hpm/pDn0fspIsaxrEAjOe0RwcXk=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=YNLyR48lXTdxN1pDrPjV7DNMvfCrYTN7MclDPWLqdkk/m3+LfLc4i4/xjX0V6m9G4
         wQ6uf4Q+DqBk1FDaP45d6R7Y1tzGkF1467alGW+UY+NvnROGMnECphGRuQNCRjydWd
         +oDEED9WCO1fublh89dQHpLQWa0M/PD9WKJ6TN//u1vcavWa6O/Pf3uSraUgE8tdIP
         sj1dXj5h9wYRk6CPTSr8UKoi0opVFOAjQ3isBy5NdxhknX1v/YgKdd8F0pAkk9O2vj
         UJDvZOo+P3wMVZBdck49q4BaqdjUCJH3Rcnf0F116cIj4Sm2VtU23+jMfml7auhOwN
         syGCbNO81yBTA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 27 Jun 2023 07:49:22 +0300 (MSK)
Message-ID: <94a133e5-a180-a9b5-91cb-c0ca44af35ea@sberdevices.ru>
Date:   Tue, 27 Jun 2023 07:44:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 06/17] vsock: check error queue to set EPOLLERR
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
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-7-AVKrasnov@sberdevices.ru>
 <rg3qxgiqqi5ltt4jcf3k5tcnynh2so5ascvrte4gywcfffusv4@qjz3tkumeq7g>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <rg3qxgiqqi5ltt4jcf3k5tcnynh2so5ascvrte4gywcfffusv4@qjz3tkumeq7g>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/27 02:11:00 #21585463
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.2023 19:04, Stefano Garzarella wrote:
> On Sat, Jun 03, 2023 at 11:49:28PM +0300, Arseniy Krasnov wrote:
>> If socket's error queue is not empty, EPOLLERR must be set. Otherwise,
>> reader of error queue won't detect data in it using EPOLLERR bit.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/af_vsock.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This patch looks like it can go even without this series.
> 
> Is it a fix? Should we add a fixes tag?

Yes, it is fix and I can exclude it from this set to reduce number
of patches, but there is no reproducer for this without MSG_ZEROCOPY
support - at this moment this feature is the only user of error queue
for AF_VSOCK.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index efb8a0937a13..45fd20c4ed50 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1030,7 +1030,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>>     poll_wait(file, sk_sleep(sk), wait);
>>     mask = 0;
>>
>> -    if (sk->sk_err)
>> +    if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
>>         /* Signify that there has been an error on this socket. */
>>         mask |= EPOLLERR;
>>
>> -- 
>> 2.25.1
>>
> 
