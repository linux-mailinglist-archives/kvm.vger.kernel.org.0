Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC32784158
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 14:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbjHVM5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 08:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbjHVM5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 08:57:23 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93181CD2;
        Tue, 22 Aug 2023 05:57:16 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 2D6A0100004;
        Tue, 22 Aug 2023 15:57:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 2D6A0100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1692709035;
        bh=FiQb2EVn5ypleg6BQsERBl+GZe543bd0nkARjCdth2g=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=a4x2BOd0BS1zaK5ukbZ8qhyp4LXJ8zN9nk63I79E/rgP2f92h15c9dBoolbb71Q9d
         0NN95Bn9Myl/FKY4N3yKZ3HsRW27fFj/mRAt8YRmgFJoEYmbKCFOKr8fwE/Phinegi
         4Fx6FKWlbCC25ihofhkc3Qiao/eJ2EZbVWgx9hg/D7GZt441Gl/cVlCzXMx02MDZwx
         MO5y2TYaBxzoWk+TnB+lU15BNAJCyNP4k42NMHK4UfMbYdKCu23+oLqoUn6pVoc0S0
         myKWkP658V7XrKnSHUbwfOQamcbMSeUndl730ZTyc9tTUfzsjLdxFbg58HcmWh2Z9C
         QgNZ/sBkT3vmg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 22 Aug 2023 15:57:14 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 22 Aug 2023 15:57:13 +0300
Message-ID: <7a368021-95f3-8a9d-7fe5-c0fc352b888b@sberdevices.ru>
Date:   Tue, 22 Aug 2023 15:51:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Arseniy Krasnov <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
 <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
 <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
 <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
 <49cdd121-3389-2f08-c0cc-89c9ac32cd1e@sberdevices.ru>
 <2ce6e3eihhtjigwectlgrbiv7ygnpki6vfdkav4effpti5gtj4@lldtdljxkyrb>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <2ce6e3eihhtjigwectlgrbiv7ygnpki6vfdkav4effpti5gtj4@lldtdljxkyrb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179376 [Aug 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 527 527 5bb611be2ca2baa31d984ccbf4ef4415504fc308, {Tracking_smtp_not_equal_from}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;pubs.opengroup.org:7.1.1;100.64.160.123:7.1.2;sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: n, {Tracking_smtp_domain_mismatch}, {Tracking_smtp_domain_2level_mismatch}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/08/22 12:20:00
X-KSMG-LinksScanning: Clean, bases: 2023/08/22 12:20:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/22 09:22:00 #21674243
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.08.2023 12:39, Stefano Garzarella wrote:
> On Mon, Aug 14, 2023 at 10:46:05PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 04.08.2023 17:28, Stefano Garzarella wrote:
>>> On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>>>> Hi Stefano,
>>>>
>>>> On 02.08.2023 10:46, Stefano Garzarella wrote:
>>>>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>>>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>>>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>>>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>>>>
>>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>>> ---
>>>>>> net/vmw_vsock/af_vsock.c | 3 +++
>>>>>> 1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>>> index 020cf17ab7e4..013b65241b65 100644
>>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>>>             err = total_written;
>>>>>>     }
>>>>>> out:
>>>>>> +    if (sk->sk_type == SOCK_STREAM)
>>>>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>>>>
>>>>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>>>>
>>>> Yes, here is my explanation:
>>>>
>>>> This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>>>> (except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>>>>
>>>> Page 367 (description of defines from sys/socket.h):
>>>> MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>>>> oriented socket that is no longer connected.
>>>>
>>>> Page 497 (description of SOCK_STREAM):
>>>> A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>>>> no longer connected).
>>>
>>> Okay, but I think we should do also for SEQPACKET:
>>>
>>> https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html
>>>
>>> In 2.10.6 Socket Types:
>>>
>>> "The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
>>> is also connection-oriented. The only difference between these types is
>>> that record boundaries ..."
>>>
>>> Then in  2.10.14 Signals:
>>>
>>> "The SIGPIPE signal shall be sent to a thread that attempts to send data
>>> on a socket that is no longer able to send. In addition, the send
>>> operation fails with the error [EPIPE]."
>>>
>>> It's honestly not super clear, but I assume the problem is similar with
>>> seqpacket since it's connection-oriented, or did I miss something?
>>>
>>> For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
>>> whether the socket is STREAM or SEQPACKET.
>>
>> Update about sending SIGPIPE for SOCK_SEQPACKET, I checked POSIX doc and kernel sources more deeply:
>>
>>
>> 1)
>>
>> I checked four types of sockets, which sends SIGPIPE for SOCK_SEQPACKET or not ('YES' if
>> this socket sends SIGPIPE in SOCK_SEQPACKET case):
>>
>> net/kcm/: YES
>> net/unix/: NO
>> net/sctp/: YES
>> net/caif/: NO
>>
>> Looking for this, I think it is impossible to get the right answer, as there is some
>> mess - everyone implements it as wish.
> 
> Eheh, I had the same impression!
> 
>>
>> 2)
>>
>> I opened POSIX spec again, and here are details about returning EPIPE from pages
>> for 'send()', 'sendto()', 'sendmsg()':
>>
>> [EPIPE] The socket is shut down for writing, or the socket is connection-mode and is
>> no longer connected. In the latter case, and if the socket is of type
>> SOCK_STREAM, the SIGPIPE signal is generated to the calling thread
>>
>> So my opinion is that we need to send SIGPIPE only for SOCK_STREAM. Another question
>> is how to interpret this from above (but again - SIGPIPE is related for SOCK_STREAM
>> only):
>>
>> **" and is no longer connected"**
>>
>> IIUC, if we follow POSIX strictly, this check must be like:
>>
>> /* socket is shut down for writing or no longer connected. */
>> if (sk->sk_shutdown & SEND_SHUTDOWN ||
>>    vsk->peer_shutdown & RCV_SHUTDOWN ||
>>    sock_flag(SOCK_DONE)) {
>>     err = -EPIPE;
>>     goto out;
>> }
>>
>> ...
>>
>> out:
>>     /* Handle -EPIPE for stream socket which is no longer connected. */
>>     if (sk->sk_type == SOCK_STREAM &&
>>         sock_flag(SOCK_DONE))
>>         err = sk_stream_error();
>>
>>
>>
>> From the other side, we can just follow TCP/AF_UNIX implementations as both are
>> popular types of socket. In this case I suggest to implement this check like
>> (e.g. without sock_flag(SOCK_DONE)):
>>
>>
>> if (sk->sk_shutdown & SEND_SHUTDOWN ||
>>    vsk->peer_shutdown & RCV_SHUTDOWN) {
>>     err = -EPIPE;
>>     goto out;
>> }
>>
>> ...
>>
>> out:
>>     if (sk->sk_type == SOCK_STREAM)
>>         err = sk_stream_error();
>>
>> What do you think?
> 
> I'd follow TCP/AF_UNIX implementations, but it is up to you ;-)

Got it, I'll use this approach

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
