Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB15C770311
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjHDO3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 10:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjHDO3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 10:29:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318546B2
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 07:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691159312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/6TKiUoe55IIrqSia7IbdrPQay+jmTfT+IM/4+k+lpc=;
        b=eIJX/cfGxTi17lgseDYrTmfI1jhQ1pRy1gjjFtAzQ7XPoEuc5ImPCeTvJLFLbXhAjlESHR
        nuaQuhPhMYFI/hzw1f0wIS+5Ei5MN/4E8GaULw/1EtnwOokrt14JBn1y6g3GLfHUAJG5jP
        S/Bj5QIZGuEImhC+r2T8r4ichUXi7nk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-aFvTPRnkOsGAeTe0XBIxdg-1; Fri, 04 Aug 2023 10:28:31 -0400
X-MC-Unique: aFvTPRnkOsGAeTe0XBIxdg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-63cceb8c21aso24373846d6.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 07:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691159311; x=1691764111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6TKiUoe55IIrqSia7IbdrPQay+jmTfT+IM/4+k+lpc=;
        b=Gj6RZQgWoa/g5lWE5ppYuRBdazc+WWsIULxsM85dqPBzCZx120wxpD/TSY97lnhhvt
         CgMgsUsF31ToOWuDODjm7R+s7JIuEOV0ukfP+eqCHqRj7GUqUW55mPMo06mUUEK4ex52
         019AJNPKzoaT5FkrAk7IPgdCOZt+jiHR3pn+Uxvf/nuUUFlRPvmxLll/9t0DsToblUqD
         jg3ip5OAMdpsbXfn7tsdZBFSV5IdqoodxVirPNtiq+9vwh2+mjDsZvcNZtpo86IBDt2F
         9aqCSDtjmiPyiN9TgGYxUwgvVdi88xem0RImHkx/G7VOBZSyA8VD6ucpXPCj25Qkf97P
         KO5g==
X-Gm-Message-State: AOJu0YwYguCH4IIc4rZyRkyyaBruJLyQ+MadtHEoGgCBsPQR0niZR2aI
        IDJqwNJS4UDGzuP+dxcmbniQX3+hlrcpcx/Sj5/wl6yb2vWwwt/4R66PkSr6n90LJ1uPJIW5SIc
        QiFu2nOPWzX/b
X-Received: by 2002:a0c:9d04:0:b0:63c:eb1e:e004 with SMTP id m4-20020a0c9d04000000b0063ceb1ee004mr1771021qvf.3.1691159310919;
        Fri, 04 Aug 2023 07:28:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQOm1oB5/xrHwYk3PxdGj4/DBN9i2DE5i3OHfDF64MaIhm95kSdYL67jDQe5etcx8sQx28kw==
X-Received: by 2002:a0c:9d04:0:b0:63c:eb1e:e004 with SMTP id m4-20020a0c9d04000000b0063ceb1ee004mr1770996qvf.3.1691159310619;
        Fri, 04 Aug 2023 07:28:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-214.retail.telecomitalia.it. [82.57.51.214])
        by smtp.gmail.com with ESMTPSA id d30-20020a0caa1e000000b00637abbfaac9sm698043qvb.98.2023.08.04.07.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 07:28:30 -0700 (PDT)
Date:   Fri, 4 Aug 2023 16:28:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <oxffffaa@gmail.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
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
Message-ID: <bzkwqp26joyzgvqyoypyv43wv7t3b6rzs3v5hkch45yggmrzp6@25byvzqwiztb>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
 <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
 <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44fef482-579a-fed6-6e8c-d400546285fc@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 03:46:47PM +0300, Arseniy Krasnov wrote:
>Hi Stefano,
>
>On 02.08.2023 10:46, Stefano Garzarella wrote:
>> On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>>> POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>>> shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>>> flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/af_vsock.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index 020cf17ab7e4..013b65241b65 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>>>             err = total_written;
>>>     }
>>> out:
>>> +    if (sk->sk_type == SOCK_STREAM)
>>> +        err = sk_stream_error(sk, msg->msg_flags, err);
>>
>> Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?
>
>Yes, here is my explanation:
>
>This function checks that input error is SIGPIPE, and if so it sends SIGPIPE to the 'current' thread
>(except case when MSG_NOSIGNAL flag is set). This behaviour is described in POSIX:
>
>Page 367 (description of defines from sys/socket.h):
>MSG_NOSIGNAL: No SIGPIPE generated when an attempt to send is made on a stream-
>oriented socket that is no longer connected.
>
>Page 497 (description of SOCK_STREAM):
>A SIGPIPE signal is raised if a thread sends on a broken stream (one that is
>no longer connected).

Okay, but I think we should do also for SEQPACKET:

https://pubs.opengroup.org/onlinepubs/009696699/functions/xsh_chap02_10.html

In 2.10.6 Socket Types:

"The SOCK_SEQPACKET socket type is similar to the SOCK_STREAM type, and
is also connection-oriented. The only difference between these types is
that record boundaries ..."

Then in  2.10.14 Signals:

"The SIGPIPE signal shall be sent to a thread that attempts to send data
on a socket that is no longer able to send. In addition, the send
operation fails with the error [EPIPE]."

It's honestly not super clear, but I assume the problem is similar with
seqpacket since it's connection-oriented, or did I miss something?

For example in sctp_sendmsg() IIUC we raise a SIGPIPE regardless of
whether the socket is STREAM or SEQPACKET.

>
>Page 1802 (description of 'send()' call):
>MSG_NOSIGNAL
>
>Requests not to send the SIGPIPE signal if an attempt to
>send is made on a stream-oriented socket that is no
>longer connected. The [EPIPE] error shall still be
>returned
>
>And the same for 'sendto()' and 'sendmsg()'
>
>Link to the POSIX document:
>https://www.open-std.org/jtc1/sc22/open/n4217.pdf
>
>TCP (I think we must rely on it), KCM, SMC sockets (all of them are stream) work in the same
>way by calling this function. AF_UNIX also works in the same way, but it implements SIGPIPE handling
>without this function.

I'm okay calling this function.

>
>The only thing that confused me a little bit, that sockets above returns EPIPE when
>we have only SEND_SHUTDOWN set, but for AF_VSOCK EPIPE is returned for RCV_SHUTDOWN
>also, but I think it is related to this patchset.

Do you mean that it is NOT related to this patchset?

Thanks,
Stefano

