Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC80874AA12
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 06:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjGGEu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 00:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjGGEu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 00:50:58 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE07DD;
        Thu,  6 Jul 2023 21:50:55 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8DA21120006;
        Fri,  7 Jul 2023 07:50:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8DA21120006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688705454;
        bh=FmK6nWbAjVAWkNNorY5E7FVMZ25C0PmKlvlL0zT+jaA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=DywWOWeZT85QSKWjq9BJ3d2AbSzTut2sL+Po/X7pjN+5j+noecFE/dr2uiKAXtAYw
         KHE4sSsLZfeMWp15XECXuUOO/kbpggf5M6CxJSH0QAU9O6zD8NuqUeoLJiW6XPExyR
         nlVvCt2D6L52J+qJj8oU+7mBBWT9rlugoPZjW2iEyBCG+6S34AMU3m6YcZ4UehDfhH
         VYgTe3/ISi2mOm/3g8sRa/dVD3GNQtAMYqwYaBMMhjzgverycZXDfLBIFL2vQ9j8wd
         eTYRYuVgEmX/TCJgu+lGmC1rjEuypVsZNPVOqiNJnmHFdPy0AIztmEbEL6bD8oHsHA
         cdRLiR88FavQA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri,  7 Jul 2023 07:50:54 +0300 (MSK)
Received: from [192.168.0.12] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 7 Jul 2023 07:50:39 +0300
Message-ID: <7e2407b7-fcdd-f047-66be-87ab371301f0@sberdevices.ru>
Date:   Fri, 7 Jul 2023 07:45:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v5 14/17] docs: net: description of MSG_ZEROCOPY for
 AF_VSOCK
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
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-15-AVKrasnov@sberdevices.ru>
 <CAGxU2F410NSNSzdNS4m-9UM8rZFBFpe5LeNZtkF0VzJc5_JFmg@mail.gmail.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <CAGxU2F410NSNSzdNS4m-9UM8rZFBFpe5LeNZtkF0VzJc5_JFmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178485 [Jul 06 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 520 520 ccb018a655251011855942a2571029252d3d69a2, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/07 00:05:00 #21574510
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



On 06.07.2023 20:06, Stefano Garzarella wrote:
> On Sat, Jul 01, 2023 at 09:39:44AM +0300, Arseniy Krasnov wrote:
>> This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
>> socket.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> Documentation/networking/msg_zerocopy.rst | 12 ++++++++++--
>> 1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
>> index b3ea96af9b49..34bc7ff411ce 100644
>> --- a/Documentation/networking/msg_zerocopy.rst
>> +++ b/Documentation/networking/msg_zerocopy.rst
>> @@ -7,7 +7,8 @@ Intro
>> =====
>>
>> The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
>> -The feature is currently implemented for TCP and UDP sockets.
>> +The feature is currently implemented for TCP, UDP and VSOCK (with
>> +virtio transport) sockets.
>>
>>
>> Opportunity and Caveats
>> @@ -174,7 +175,7 @@ read_notification() call in the previous snippet. A notification
>> is encoded in the standard error format, sock_extended_err.
>>
>> The level and type fields in the control data are protocol family
>> -specific, IP_RECVERR or IPV6_RECVERR.
>> +specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
>>
>> Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
>> as explained before, to avoid blocking read and write system calls on
>> @@ -201,6 +202,7 @@ undefined, bar for ee_code, as discussed below.
>>
>>       printf("completed: %u..%u\n", serr->ee_info, serr->ee_data);
>>
>> +For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be 0.
> 
> Maybe better to move up, just under the previous change.
> 
> By the way, should we define a valid type value for vsock
> (e.g. VSOCK_RECVERR)?

Yes I think, I'll add it in the same patch which adds SOL_VSOCK.

Thanks, Arseniy

> 
>>
>> Deferred copies
>> ~~~~~~~~~~~~~~~
>> @@ -235,12 +237,15 @@ Implementation
>> Loopback
>> --------
>>
>> +For TCP and UDP:
>> Data sent to local sockets can be queued indefinitely if the receive
>> process does not read its socket. Unbound notification latency is not
>> acceptable. For this reason all packets generated with MSG_ZEROCOPY
>> that are looped to a local socket will incur a deferred copy. This
>> includes looping onto packet sockets (e.g., tcpdump) and tun devices.
>>
>> +For VSOCK:
>> +Data path sent to local sockets is the same as for non-local sockets.
>>
>> Testing
>> =======
>> @@ -254,3 +259,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
>> namespaces, the test will not show any improvement. For testing, the
>> loopback restriction can be temporarily relaxed by making
>> skb_orphan_frags_rx identical to skb_orphan_frags.
>> +
>> +For VSOCK type of socket example can be found in  tools/testing/vsock/
>> +vsock_test_zerocopy.c.
> 
> For VSOCK socket, example can be found in
> tools/testing/vsock/vsock_test_zerocopy.c
> 
> (we should leave the entire path on the same line)
> 
>> --
>> 2.25.1
>>
> 
