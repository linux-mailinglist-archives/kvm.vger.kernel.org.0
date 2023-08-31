Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F41878F1B3
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346130AbjHaRKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbjHaRKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:10:42 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AB91B2;
        Thu, 31 Aug 2023 10:10:37 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8AD1D120009;
        Thu, 31 Aug 2023 20:10:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8AD1D120009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1693501833;
        bh=U7WOQB5SYQHqP+B3KeYZ1/+2ZrmmQCAK40U7/k61lho=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=ZTC65bNT3c5Vn+sjGor0A1bjvGv7JUmXe9yZwyZL8D4HYnCCs1jRQKQscD4OzSDPg
         HteSX8e5c9kw/hHponCh/QnMh7ARe9LxpBWT8TpY75uap+xitSENmu0GxnRneT3uyT
         +7m9WOpEYHqayiyPTJwyHx9kIzQdscY1+egt03d8J6aLlrBWp/TCkQOosGIY5sc4/D
         JlkLTS8hX6v2YrQTnk3bk93+D/B97zK1r8KQWLHNE8NRb7Lyjm2gJvMVnTwmCOhlUZ
         owIEPJqNosRAiaNKxcQfvMhLk+K7/k7cbJmqCnU5Q80hez02oTBXXCIxgvcT1XRiAj
         CQ4qLqC9C1guA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Thu, 31 Aug 2023 20:10:33 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 31 Aug 2023 20:10:02 +0300
Message-ID: <d4e46f76-b245-3815-3dde-00d81f02942f@salutedevices.com>
Date:   Thu, 31 Aug 2023 20:04:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 0/2] vsock: handle writes to shutdowned socket
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
References: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
 <7byt3iwpo5ewpxkjwh6adlzq2nerrbv7trlreujuchsrkworxk@2jxzyul3o5cz>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <7byt3iwpo5ewpxkjwh6adlzq2nerrbv7trlreujuchsrkworxk@2jxzyul3o5cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179574 [Aug 31 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 529 529 a773548e495283fecef97c3e587259fde2135fef, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2;git.kernel.org:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/08/31 14:51:00
X-KSMG-LinksScanning: Clean, bases: 2023/08/31 14:51:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/31 11:36:00 #21745758
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 31.08.2023 18:23, Stefano Garzarella wrote:
> Hi Arseniy,
> 
> On Sat, Aug 26, 2023 at 08:58:58PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> this small patchset adds POSIX compliant behaviour on writes to the
>> socket which was shutdowned with 'shutdown()' (both sides - local with
>> SHUT_WR flag, peer - with SHUT_RD flag). According POSIX we must send
>> SIGPIPE in such cases (but SIGPIPE is not send when MSG_NOSIGNAL is set).
>>
>> First patch is implemented in the same way as net/ipv4/tcp.c:tcp_sendmsg_locked().
>> It uses 'sk_stream_error()' function which handles EPIPE error. Another
>> way is to use code from net/unix/af_unix.c:unix_stream_sendmsg() where
>> same logic from 'sk_stream_error()' is implemented "from scratch", but
>> it doesn't check 'sk_err' field. I think error from this field has more
>> priority to be returned from syscall. So I guess it is better to reuse
>> currently implemented 'sk_stream_error()' function.
>>
>> Test is also added.
>>
>> Head for this patchset is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=b38460bc463c54e0c15ff3b37e81f7e2059bb9bb
>>
>> Link to v1:
>> https://lore.kernel.org/netdev/20230801141727.481156-1-AVKrasnov@sberdevices.ru/
>>
>> Changelog:
>> v1 -> v2:
>> * 0001 stills the same - SIGPIPE is sent only for SOCK_STREAM as discussed in v1
>>   with Stefano Garzarella <sgarzare@redhat.com>.
>> * 0002 - use 'sig_atomic_t' instead of 'bool' for flag variables updated from
>>   signal handler.
>>
>> Arseniy Krasnov (2):
>>  vsock: send SIGPIPE on write to shutdowned socket
>>  test/vsock: shutdowned socket test
> 
> Thanks for this series, I fully reviewed it, LGTM!
> 
> Please send it targeting net-next when it reopens.

Hi Stefano,

Ok and thanks for review!

Thanks, Arseniy

> 
> Stefano
> 
