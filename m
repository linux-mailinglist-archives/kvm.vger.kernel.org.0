Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D392783D13
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 11:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbjHVJkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 05:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbjHVJkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 05:40:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3B91A5
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 02:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692697164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txMvXVZ0kMppatMDVgUyzHmRHXS5/JZIN8KKI6DAuJ0=;
        b=FX+9EPPMa8D/JLYBa6JM6kzrqrghb2BqiC81a5QD+jASDrTE7Xa1NPGVuHr63KbS0D/ui+
        333sI3DPGWk0ls0QmfDZk8labNyi9mejPbb9KZi/7z1UTE2TFNmpRMkPyOjgWOY7CAhzMi
        k/dO2iMQSk7+NdnWJGr8yFJY+qkoVJI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-FmE6m208Mtqj2d0Vs4HQ0w-1; Tue, 22 Aug 2023 05:39:23 -0400
X-MC-Unique: FmE6m208Mtqj2d0Vs4HQ0w-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-40ff829c836so41348021cf.0
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 02:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692697163; x=1693301963;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txMvXVZ0kMppatMDVgUyzHmRHXS5/JZIN8KKI6DAuJ0=;
        b=N3MzRYIduu8DGnNSR7S3OzMHLA4y0IUg9sXwtQtnBeJ5NGrBA4oKs+CbNmb7xA08TQ
         oSXIoysYgbFdFdiDMBSJg9yJhfdhHbeZsT/rQkEh4QazNpKe8lh3AO2LC67wGrwHNkxu
         ivegZkccvF6OYz7HjirOYkOEbUJ/2jD/DvysAhmTRkmFPVyDPocYHXCqkOau9qwb64JJ
         15ZZeLlgBN55U6OvUEKtCX3S35aH52sXBs2urvkMSmtXKdf5Yc0/Zo+NVbx37AF8MZXV
         g/lF4utpcu8Hn5nZwYIY1u6pnI1QKrlbRhtLIdPQEzHI33sRS3KRlZSljmRxyfxjBaRG
         XPRA==
X-Gm-Message-State: AOJu0YxLZyYyxENcTivC0A55qUllLxCLj/NZ4yHFJUqmmrXg0XmlYrZw
        aUF7zCNrVQvi2905adQvBsMKy6JBxgTwtGI+Wgs7lglJ68zO8wAQa1KkE5n1dSUOMXFkyzuo2Wg
        7Og6zwezd6GNJ
X-Received: by 2002:ac8:59d6:0:b0:403:d440:2f99 with SMTP id f22-20020ac859d6000000b00403d4402f99mr10676958qtf.27.1692697163092;
        Tue, 22 Aug 2023 02:39:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaxVbCTddadOKHJPm9G0BiLMjQpMjKaJTOzsoyhtziZnLWJPPYe0RA489/BqQdosjs8bS+aw==
X-Received: by 2002:ac8:59d6:0:b0:403:d440:2f99 with SMTP id f22-20020ac859d6000000b00403d4402f99mr10676944qtf.27.1692697162819;
        Tue, 22 Aug 2023 02:39:22 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.203.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a05620a11b600b00767b4fa5d96sm3098824qkk.27.2023.08.22.02.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 02:39:22 -0700 (PDT)
Date:   Tue, 22 Aug 2023 11:39:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Arseniy Krasnov <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Message-ID: <2ce6e3eihhtjigwectlgrbiv7ygnpki6vfdkav4effpti5gtj4@lldtdljxkyrb>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
 <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
 <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
 <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
 <49cdd121-3389-2f08-c0cc-89c9ac32cd1e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49cdd121-3389-2f08-c0cc-89c9ac32cd1e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 10:46:05PM +0300, Arseniy Krasnov wrote:
>
>
>On 04.08.2023 17:28, Stefano Garzarella wrote:
>> On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>>> Hi Stefano,
>>>
>>> On 02.08.2023 10:46, Stefano Garzarella wrote:
>>>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>>>
>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>> ---
>>>>> net/vmw_vsock/af_vsock.c | 3 +++
>>>>> 1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>> index 020cf17ab7e4..013b65241b65 100644
>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>>             err = total_written;
>>>>>     }
>>>>> out:
>>>>> +    if (sk->sk_type == SOCK_STREAM)
>>>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>>>
>>>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>>>
>>> Yes, here is my explanation:
>>>
>>> This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>>> (except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>>>
>>> Page 367 (description of defines from sys/socket.h):
>>> MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>>> oriented socket that is no longer connected.
>>>
>>> Page 497 (description of SOCK_STREAM):
>>> A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>>> no longer connected).
>>
>> Okay, but I think we should do also for SEQPACKET:
>>
>> https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html
>>
>> In 2.10.6 Socket Types:
>>
>> "The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
>> is also connection-oriented. The only difference between these types is
>> that record boundaries ..."
>>
>> Then in  2.10.14 Signals:
>>
>> "The SIGPIPE signal shall be sent to a thread that attempts to send data
>> on a socket that is no longer able to send. In addition, the send
>> operation fails with the error [EPIPE]."
>>
>> It's honestly not super clear, but I assume the problem is similar with
>> seqpacket since it's connection-oriented, or did I miss something?
>>
>> For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
>> whether the socket is STREAM or SEQPACKET.
>
>Update about sending SIGPIPE for SOCK_SEQPACKET, I checked POSIX doc and kernel sources more deeply:
>
>
>1)
>
>I checked four types of sockets, which sends SIGPIPE for SOCK_SEQPACKET or not ('YES' if
>this socket sends SIGPIPE in SOCK_SEQPACKET case):
>
>net/kcm/: YES
>net/unix/: NO
>net/sctp/: YES
>net/caif/: NO
>
>Looking for this, I think it is impossible to get the right answer, as there is some
>mess - everyone implements it as wish.

Eheh, I had the same impression!

>
>2)
>
>I opened POSIX spec again, and here are details about returning EPIPE from pages
>for 'send()', 'sendto()', 'sendmsg()':
>
>[EPIPE] The socket is shut down for writing, or the socket is connection-mode and is
>no longer connected. In the latter case, and if the socket is of type
>SOCK_STREAM, the SIGPIPE signal is generated to the calling thread
>
>So my opinion is that we need to send SIGPIPE only for SOCK_STREAM. Another question
>is how to interpret this from above (but again - SIGPIPE is related for SOCK_STREAM
>only):
>
>**" and is no longer connected"**
>
>IIUC, if we follow POSIX strictly, this check must be like:
>
>/* socket is shut down for writing or no longer connected. */
>if (sk->sk_shutdown & SEND_SHUTDOWN ||
>    vsk->peer_shutdown & RCV_SHUTDOWN ||
>    sock_flag(SOCK_DONE)) {
>	err = -EPIPE;
>	goto out;
>}
>
>...
>
>out:
>	/* Handle -EPIPE for stream socket which is no longer connected. */
>	if (sk->sk_type == SOCK_STREAM &&
>		sock_flag(SOCK_DONE))
>		err = sk_stream_error();
>
>
>
>From the other side, we can just follow TCP/AF_UNIX implementations as both are
>popular types of socket. In this case I suggest to implement this check like
>(e.g. without sock_flag(SOCK_DONE)):
>
>
>if (sk->sk_shutdown & SEND_SHUTDOWN ||
>    vsk->peer_shutdown & RCV_SHUTDOWN) {
>	err = -EPIPE;
>	goto out;
>}
>
>...
>
>out:
>	if (sk->sk_type == SOCK_STREAM)
>		err = sk_stream_error();
>
>What do you think?

I'd follow TCP/AF_UNIX implementations, but it is up to you ;-)

Thanks,
Stefano

