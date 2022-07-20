Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9043357B3DE
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiGTJaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236865AbiGTJa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:30:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32D9A12D0F
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658309423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GDJ3pDuliBBFCjPRQRCyBqUtEOUMI1zRI5vOv79h/yg=;
        b=fpRFxwO6qrnnwzv+0lZ8VZhSlN/hNAMHPO/gEmiFUFJWwZOGPhwYVWbbJmtJ2RpRlSB0j6
        QdUJW/5rHTVkBXb60MoheyGtyfYcJy43pAuChYlhvCVFqDEYZb50yl4gaOLeiuZTVBbdzS
        Qdg7mrG8TfXvKwdnB8GQqsj87zUa0Z0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-SJUmewQcOUqa9ku5jlYQ4Q-1; Wed, 20 Jul 2022 05:30:13 -0400
X-MC-Unique: SJUmewQcOUqa9ku5jlYQ4Q-1
Received: by mail-qt1-f199.google.com with SMTP id u12-20020a05622a17cc00b0031ede432916so8949567qtk.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 02:30:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GDJ3pDuliBBFCjPRQRCyBqUtEOUMI1zRI5vOv79h/yg=;
        b=oNVQJKwI3rq3+gk9WqDFzmcCk62rVRAPvfP2Xh56UXqKSnJY9jT41TQuwsYbCA2Ruo
         Y5jHgy0Or0yLrFRjwTo8f1kX+e9JPPK+VZpfaS3WEsmAgYz4qg9Tj3oihIfRs9LdYh4X
         IaP+eYmdfhNlH0uf4EgGVZGtMIhEFZ+9/4y3DG9dbWZgOdKXKEw2XRno3cOqn0kGLVSP
         chTw/c6oUiEPSCk0mlSwWn2OrklF5Wc6PCCCH3FPo+dVCGTnOppwPmXfLcMUPIAUlxx1
         +aVdCaPnQDdDCdMykN7G4u7d1QdRsBtT1VIO9A3emfvbhXGgJD6YKp3FVlBbGKc6vjkO
         YOmA==
X-Gm-Message-State: AJIora9vTaErmQFUBjN326ejxo7p5u3lhi6hY8X3pSReBK7/jI9ogDtF
        O8YQkgEXRhefUyACP0E6V+IKFSfALJzQ/nPeKRW4U/ei2tIqBgORNoqE+jc13RSLyb/ola7OW2l
        IlluG/ecJDZds
X-Received: by 2002:ac8:59c7:0:b0:31e:ede9:971b with SMTP id f7-20020ac859c7000000b0031eede9971bmr10707670qtf.208.1658309413092;
        Wed, 20 Jul 2022 02:30:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s6mJMvfgOsm/KeVUVbnelP8FW2qMJbR3hxdq7pZeKI4iupDApN2I1fzLeoIKhfg5s7AfAEcg==
X-Received: by 2002:ac8:59c7:0:b0:31e:ede9:971b with SMTP id f7-20020ac859c7000000b0031eede9971bmr10707652qtf.208.1658309412863;
        Wed, 20 Jul 2022 02:30:12 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a0c4c00b006a6ebde4799sm17257649qki.90.2022.07.20.02.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:30:12 -0700 (PDT)
Date:   Wed, 20 Jul 2022 11:30:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 0/3] virtio/vsock: use SO_RCVLOWAT to set
 POLLIN/POLLRDNORM
Message-ID: <20220720093005.2unej4jnnvrn55f2@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <20220719125856.a6bfwrvy66gxxzqe@sgarzare-redhat>
 <ac05e1ee-23b3-75e0-f9a4-1056a68934d8@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac05e1ee-23b3-75e0-f9a4-1056a68934d8@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 06:07:47AM +0000, Arseniy Krasnov wrote:
>On 19.07.2022 15:58, Stefano Garzarella wrote:
>> On Mon, Jul 18, 2022 at 08:12:52AM +0000, Arseniy Krasnov wrote:
>>> Hello,
>>>
>>> during my experiments with zerocopy receive, i found, that in some
>>> cases, poll() implementation violates POSIX: when socket has non-
>>> default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>>> POLLRDNORM bits in 'revents' even number of bytes available to read
>>> on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>>> POLLIN flag and then tries to read data(for example using  'read()'
>>> call), but read call will be blocked, because  SO_RCVLOWAT logic is
>>> supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>>> requires that:
>>>
>>> "POLLIN     Data other than high-priority data may be read without
>>>            blocking.
>>> POLLRDNORM Normal data may be read without blocking."
>>>
>>> See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>>>
>>> So, we have, that poll() syscall returns POLLIN, but read call will
>>> be blocked.
>>>
>>> Also in man page socket(7) i found that:
>>>
>>> "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>>> socket as readable only if at least SO_RCVLOWAT bytes are available."
>>>
>>> I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>>> uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>>> this case for TCP socket, it works as POSIX required.
>>
>> I tried to look at the code and it seems that only TCP complies with it or am I wrong?
>Yes, i checked AF_UNIX, it also don't care about that. It calls skb_queue_empty() that of
>course ignores SO_RCVLOWAT.
>>
>>>
>>> I've added some fixes to af_vsock.c and virtio_transport_common.c,
>>> test is also implemented.
>>>
>>> What do You think guys?
>>
>> Nice, thanks for fixing this and for the test!
>>
>> I left some comments, but I think the series is fine if we will support it in all transports.
>Ack
>>
>> I'd just like to understand if it's just TCP complying with it or I'm missing some check included in the socket layer that we could reuse.
>Seems sock_poll() which is socket layer entry point for poll() doesn't contain any such checks
>>
>> @David, @Jakub, @Paolo, any advice?
>>
>> Thanks,
>> Stefano
>>
>
>PS: moreover, i found one more interesting thing with TCP and poll: TCP receive logic wakes up poll waiter
>only when number of available bytes > SO_RCVLOWAT. E.g. it prevents "spurious" wake ups, when poll will be
>woken up because new data arrived, but POLLIN to allow user dequeue this data won't be set(as amount of data
>is too small).
>See tcp_data_ready() in net/ipv4/tcp_input.c

Do you mean that we should call sk->sk_data_ready(sk) checking 
SO_RCVLOWAT?

It seems fine, maybe we can add vsock_data_ready() in af_vsock.c that 
transports should call instead of calling sk->sk_data_ready(sk) 
directly.

Then we can something similar to tcp_data_ready().

Thanks,
Stefano

