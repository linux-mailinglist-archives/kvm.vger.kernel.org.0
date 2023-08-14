Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC2E77C110
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 21:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjHNTwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 15:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjHNTwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 15:52:01 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DB1FA;
        Mon, 14 Aug 2023 12:51:58 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 688C8100005;
        Mon, 14 Aug 2023 22:51:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 688C8100005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1692042716;
        bh=Uu/F/7BfivOj4WsQ0lGhlOQbXHsj65lDecxOZ8eeGo0=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=CH5T9HnojLUkhDzU5ptkvi9wA4A1ptvH15Ls6SKOGYGdy08av2Jqem2EFwZQ1s8nQ
         YEHwThLqBAS///XGeqPzXyuqiPA+0eXGF1yWQXDYoZgHOJCMCoexoKTlZ/aVVKkIal
         n8sbIOeLxPwvSapqmjckAuPVz6OytvZqGqM+sjKiVWzHVhgo/vOit2Zp8jTqU0WWBy
         oGnHbfsNdZPeLsTyzl6R53+iaCPI7BJLTGr1UOrwfseS2JhBZ892K1lL8V4yXK762Z
         RQF1GV6y8lYYMleoqJB82XLGs0mf3fXXx5vkwnlK2WJp1JYh8m8WdIkUDZxUXPCIlh
         ayvil5en5yb4Q==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 14 Aug 2023 22:51:56 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 14 Aug 2023 22:51:53 +0300
Message-ID: <49cdd121-3389-2f08-c0cc-89c9ac32cd1e@sberdevices.ru>
Date:   Mon, 14 Aug 2023 22:46:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>
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
        <kernel@sberdevices.ru>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
 <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
 <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
 <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179234 [Aug 14 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 526 526 7a6a9b19f6b9b3921b5701490f189af0e0cd5310, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;pubs.opengroup.org:7.1.1;www.open-std.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/08/14 18:25:00
X-KSMG-LinksScanning: Clean, bases: 2023/08/14 18:25:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/14 14:11:00 #21610501
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.08.2023 17:28, Stefano Garzarella wrote:
> On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>> Hi Stefano,
>>
>> On 02.08.2023 10:46, Stefano Garzarella wrote:
>>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> net/vmw_vsock/af_vsock.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index 020cf17ab7e4..013b65241b65 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>             err = total_written;
>>>>     }
>>>> out:
>>>> +    if (sk->sk_type == SOCK_STREAM)
>>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>>
>>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>>
>> Yes, here is my explanation:
>>
>> This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>> (except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>>
>> Page 367 (description of defines from sys/socket.h):
>> MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>> oriented socket that is no longer connected.
>>
>> Page 497 (description of SOCK_STREAM):
>> A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>> no longer connected).
> 
> Okay, but I think we should do also for SEQPACKET:
> 
> https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html
> 
> In 2.10.6 Socket Types:
> 
> "The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
> is also connection-oriented. The only difference between these types is
> that record boundaries ..."
> 
> Then in  2.10.14 Signals:
> 
> "The SIGPIPE signal shall be sent to a thread that attempts to send data
> on a socket that is no longer able to send. In addition, the send
> operation fails with the error [EPIPE]."
> 
> It's honestly not super clear, but I assume the problem is similar with
> seqpacket since it's connection-oriented, or did I miss something?
> 
> For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
> whether the socket is STREAM or SEQPACKET.

Update about sending SIGPIPE for SOCK_SEQPACKET, I checked POSIX doc and kernel sources more deeply:


1)

I checked four types of sockets, which sends SIGPIPE for SOCK_SEQPACKET or not ('YES' if
this socket sends SIGPIPE in SOCK_SEQPACKET case):

net/kcm/: YES
net/unix/: NO
net/sctp/: YES
net/caif/: NO

Looking for this, I think it is impossible to get the right answer, as there is some
mess - everyone implements it as wish.

2)

I opened POSIX spec again, and here are details about returning EPIPE from pages
for 'send()', 'sendto()', 'sendmsg()':

[EPIPE] The socket is shut down for writing, or the socket is connection-mode and is
no longer connected. In the latter case, and if the socket is of type
SOCK_STREAM, the SIGPIPE signal is generated to the calling thread

So my opinion is that we need to send SIGPIPE only for SOCK_STREAM. Another question
is how to interpret this from above (but again - SIGPIPE is related for SOCK_STREAM
only):

**" and is no longer connected"**

IIUC, if we follow POSIX strictly, this check must be like:

/* socket is shut down for writing or no longer connected. */
if (sk->sk_shutdown & SEND_SHUTDOWN ||
    vsk->peer_shutdown & RCV_SHUTDOWN ||
    sock_flag(SOCK_DONE)) {
	err = -EPIPE;
	goto out;
}

...

out:
	/* Handle -EPIPE for stream socket which is no longer connected. */
	if (sk->sk_type == SOCK_STREAM &&
		sock_flag(SOCK_DONE))
		err = sk_stream_error();



From the other side, we can just follow TCP/AF_UNIX implementations as both are
popular types of socket. In this case I suggest to implement this check like
(e.g. without sock_flag(SOCK_DONE)):


if (sk->sk_shutdown & SEND_SHUTDOWN ||
    vsk->peer_shutdown & RCV_SHUTDOWN) {
	err = -EPIPE;
	goto out;
}

...

out:
	if (sk->sk_type == SOCK_STREAM)
		err = sk_stream_error();

What do you think?

Thanks, Arseniy

> 
>>
>> Page 1802 (description of 'send()' call):
>> MSG_NOSIGNAL
>>
>> Requests not to send the SIGPIPE signal if an attempt to
>> send is made on a stream-oriented socket that is no
>> longer connected. The [EPIPE] error shall still be
>> returned
>>
>> And the same for 'sendto()' and 'sendmsg()'
>>
>> Link to the POSIX document:
>> https://www.open-std.org/jtc1/sc22/open/n4217.pdf
>>
>> TCP (I think we must rely on it), KCM, SMC sockets (all of them are stream) work in the same
>> way by calling this function. AF_UNIX also works in the same way, but it implements SIGPIPE handling
>> without this function.
> 
> I'm okay calling this function.
> 
>>
>> The only thing that confused me a little bit, that sockets above returns EPIPE when
>> we have only SEND_SHUTDOWN set, but for AF_VSOCK EPIPE is returned for RCV_SHUTDOWN
>> also, but I think it is related to this patchset.
> 
> Do you mean that it is NOT related to this patchset?
> 
> Thanks,
> Stefano
> 
