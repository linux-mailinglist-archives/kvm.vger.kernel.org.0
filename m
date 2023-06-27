Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F3273FBA8
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjF0MEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 08:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjF0MEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 08:04:23 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D842B10EC;
        Tue, 27 Jun 2023 05:04:19 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9EC795FD71;
        Tue, 27 Jun 2023 15:04:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687867456;
        bh=N+yr4uUtudu6mibyumvLqyo/EuSagL5a4hQI4FKGs9M=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=WqOl7HPJIkLi8Rw+yzXRCdsLyZGIZsnXdFAtGq/6NNVl69IhYX/kS+yNCH3KCIgQU
         9zrk856UEbqQ5sQ5wlanmnvuUDqCXdO7RSifPbXjwA0jfxxdYAVM8YO03NXMLTLNI4
         tzn7Dph4Kvs4TOXtIUfyI8UZeshz/A7WrD+HfYBioZiPv3FQs9ioYXqEuzQvUsib22
         EutXfXCYSYvcMnmBimRjuxnigbocHApZ+eAJQHTyWEhKiB9ubFK+ZvarFM4R42K6J+
         gLwB28NZVdeflb+3JCy4mklpEGImVwEujcxKGmnY5QevTgEXbMkMqGqvLMUKjKdOix
         rziDJ6njzO8tA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 27 Jun 2023 15:03:56 +0300 (MSK)
Message-ID: <bb1c0271-bd0d-7a2d-01a8-b7777af67017@sberdevices.ru>
Date:   Tue, 27 Jun 2023 14:58:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 0/4] virtio/vsock: some updates for MSG_PEEK flag
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
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
 <tmcj34lrgk7rxlnp4qvkpljwovowlz3wnosqboxssv6f6enr6u@qnf422n6lu6j>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <tmcj34lrgk7rxlnp4qvkpljwovowlz3wnosqboxssv6f6enr6u@qnf422n6lu6j>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/27 09:07:00 #21586757
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



On 26.06.2023 19:30, Stefano Garzarella wrote:
> On Sun, Jun 18, 2023 at 09:24:47AM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>> This patchset does several things around MSG_PEEK flag support. In
>> general words it reworks MSG_PEEK test and adds support for this flag
>> in SOCK_SEQPACKET logic. Here is per-patch description:
>>
>> 1) This is cosmetic change for SOCK_STREAM implementation of MSG_PEEK:
>>   1) I think there is no need of "safe" mode walk here as there is no
>>      "unlink" of skbs inside loop (it is MSG_PEEK mode - we don't change
>>      queue).
>>   2) Nested while loop is removed: in case of MSG_PEEK we just walk
>>      over skbs and copy data from each one. I guess this nested loop
>>      even didn't behave as loop - it always executed just for single
>>      iteration.
>>
>> 2) This adds MSG_PEEK support for SOCK_SEQPACKET. It could be implemented
>>   be reworking MSG_PEEK callback for SOCK_STREAM to support SOCK_SEQPACKET
>>   also, but I think it will be more simple and clear from potential
>>   bugs to implemented it as separate function thus not mixing logics
>>   for both types of socket. So I've added it as dedicated function.
>>
>> 3) This is reworked MSG_PEEK test for SOCK_STREAM. Previous version just
>>   sent single byte, then tried to read it with MSG_PEEK flag, then read
>>   it in normal way. New version is more complex: now sender uses buffer
>>   instead of single byte and this buffer is initialized with random
>>   values. Receiver tests several things:
>>   1) Read empty socket with MSG_PEEK flag.
>>   2) Read part of buffer with MSG_PEEK flag.
>>   3) Read whole buffer with MSG_PEEK flag, then checks that it is same
>>      as buffer from 2) (limited by size of buffer from 2) of course).
>>   4) Read whole buffer without any flags, then checks that is is same
>>      as buffer from 3).
>>
>> 4) This is MSG_PEEK test for SOCK_SEQPACKET. It works in the same way
>>   as for SOCK_STREAM, except it also checks combination of MSG_TRUNC
>>   and MSG_PEEK.
>>
>> Head is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
> 
> Nice cleanup, LGTM, but I'd like a comment from Bobby.

Got it, thanks!

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
