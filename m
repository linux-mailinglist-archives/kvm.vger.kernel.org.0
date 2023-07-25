Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549CA761DD4
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjGYP5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjGYP5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:57:17 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAB12109;
        Tue, 25 Jul 2023 08:57:04 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 1FFB912001D;
        Tue, 25 Jul 2023 18:57:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 1FFB912001D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690300621;
        bh=qRRLuDnRuBKRCx1jBfu7VwVe6z3jQqq3ZtmI3beDyTo=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=BDDFU9xeEgJRrgJnCbrHOFTvPXKJJ5hHg00/m8gtoGuULQPLD0TiVXzyXm7eAmzKB
         KYNsM8GJwqD4J3dIqDmJNbUuAHhOcM0Z8IKvgwfqa/VpbOgOjeYogs1QHwcmd+N44U
         o6xDWNDJMaQrb9xfDQEjFpLD6RSfYDnRPEOvRAi5HNGzsdhjUDwcknRj81lorwdLvB
         zd4u0S5wgyr9Vh0vFYgE2ivq0CWLqVzXzD5rYJy2bNtprH/KdRs/N8PHso/FJM35V7
         nkm5+PIvH47eyHAyKAyKNq0H64JaQldbh9NsqrxK18e0nZn+uqUQ4gAutjlrLdQsxW
         wNbfNOmyz2nOw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 25 Jul 2023 18:57:00 +0300 (MSK)
Received: from [192.168.0.104] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 25 Jul 2023 18:56:58 +0300
Message-ID: <bd49fd49-a6c8-cbe7-abd8-e8e990d9ee05@sberdevices.ru>
Date:   Tue, 25 Jul 2023 18:51:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 4/4] vsock/test: MSG_PEEK test for SOCK_SEQPACKET
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
References: <20230719192708.1775162-1-AVKrasnov@sberdevices.ru>
 <20230719192708.1775162-5-AVKrasnov@sberdevices.ru>
 <lkfzuvv53lyycpun27knppjhk46lyqrz4idvzj7fzer2566y5t@mtc7v33q3erg>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <lkfzuvv53lyycpun27knppjhk46lyqrz4idvzj7fzer2566y5t@mtc7v33q3erg>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
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



On 25.07.2023 18:41, Stefano Garzarella wrote:
> On Wed, Jul 19, 2023 at 10:27:08PM +0300, Arseniy Krasnov wrote:
>> This adds MSG_PEEK test for SOCK_SEQPACKET. It works in the same way as
>> SOCK_STREAM test, except it also tests MSG_TRUNC flag.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> tools/testing/vsock/vsock_test.c | 58 +++++++++++++++++++++++++++++---
>> 1 file changed, 54 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 444a3ff0681f..2ca2cbfa9808 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -257,14 +257,19 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
>>
>> #define MSG_PEEK_BUF_LEN 64
>>
>> -static void test_stream_msg_peek_client(const struct test_opts *opts)
>> +static void __test_msg_peek_client(const struct test_opts *opts,
> 
> Let's stay with just test_msg_peek_client(), WDYT?
> 
>> +                   bool seqpacket)
>> {
>>     unsigned char buf[MSG_PEEK_BUF_LEN];
>>     ssize_t send_size;
>>     int fd;
>>     int i;
>>
>> -    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (seqpacket)
>> +        fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>> +    else
>> +        fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +
>>     if (fd < 0) {
>>         perror("connect");
>>         exit(EXIT_FAILURE);
>> @@ -290,7 +295,8 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
>>     close(fd);
>> }
>>
>> -static void test_stream_msg_peek_server(const struct test_opts *opts)
>> +static void __test_msg_peek_server(const struct test_opts *opts,
> 
> Same here.
> 
> The rest LGTM!

Ok! I'll update.

> 
> Also the whole series should be ready for net-next, right?

Yes, I'll fix these two things and resend this as 'net-next'

Thanks, Arseniy

> 
> Stefano
> 
