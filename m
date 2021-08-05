Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85FA3E10D3
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhHEJHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 05:07:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232808AbhHEJHQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 05:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628154422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYnPAindt7gqrNcKUm5J79oEdrV+LI995OyYx3zHpCI=;
        b=C0haqXC85luvlxWQg0bM6Cg30vZZRKzlrRweSOw2SsNpNvtz6hvOhJWLUmcQPN5QAY72rL
        /t8MCbG9wggeRfpEtX5riB2xltwUIXQDDpBPIiZfytJDfg1ciRVUDYjzfI9WPuqsWXBpCo
        aQ/8vbenLvO27rpbAncxw7OEfck1wDY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-SuqKKn_xPHqRF9OqQUGgGQ-1; Thu, 05 Aug 2021 05:07:01 -0400
X-MC-Unique: SuqKKn_xPHqRF9OqQUGgGQ-1
Received: by mail-ed1-f71.google.com with SMTP id dh21-20020a0564021d35b02903be0aa37025so561757edb.7
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 02:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KYnPAindt7gqrNcKUm5J79oEdrV+LI995OyYx3zHpCI=;
        b=fGpcaXFqBMEtFFZgxJvrhc8QoYREW3jt0P1Bz03837G1yIRka7UeqOjej541g/uT/H
         JOg4eih2F2ofjX+Ym5v0uOhtxyReURWgz7n4zVuSZJ+dDwh46g0wLpFYMUxtrrqE9Giq
         uopQIlk3v109/SeJXvH+M3U5iEW0nq1DYHx9aZIWDPnugr9RaY1HmkukG1lJnFiKxx9f
         9pyuEbzXxpN+r0SerVy88x2d9d7IXjpsWpyrSfBiiuwZxoOqQr7kehC0Y7n9R2jKMiPC
         95gWXZiXLMHDrhSvdTOtwUPFAlalm1ySQXcH+/SHfLPCrGcFV7WRPQUleirp2Gs9LULr
         GB+A==
X-Gm-Message-State: AOAM530/uxFIT9v8yZVU/l1WqYoeLp93p/+e1Z9voVhv1dIOwtqtak3o
        grhHr4WvDndAJmKUOSGt9deMCYWOC0GUzviGyf++8mx+Mqp9QpneB1BVXYvHf8qI7/DlZZzLrfK
        alQNQv11UAcSM
X-Received: by 2002:a05:6402:6cb:: with SMTP id n11mr5231288edy.112.1628154420099;
        Thu, 05 Aug 2021 02:07:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAbJ7jQEOwJQWtXjn6en2nBVwYWl56AzaGjrhqay1J4fO2ol2L+YJReWWqxkCDxYEG9cHRUg==
X-Received: by 2002:a05:6402:6cb:: with SMTP id n11mr5231265edy.112.1628154419930;
        Thu, 05 Aug 2021 02:06:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id b25sm2018211edv.9.2021.08.05.02.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 02:06:59 -0700 (PDT)
Date:   Thu, 5 Aug 2021 11:06:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 0/7] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210805090657.y2sz3pzhruuolncq@steredhat>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210804125737.kbgc6mg2v5lw25wu@steredhat>
 <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:33:12AM +0300, Arseny Krasnov wrote:
>
>On 04.08.2021 15:57, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> Hi Arseny,
>>
>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>> AF_VSOCK sockets over virtio transport.
>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>> etc. It has fixed maximum length, and it bounds are visible using
>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>> Current implementation based on message definition above.
>> Okay, so the implementation we merged is wrong right?
>> Should we disable the feature bit in stable kernels that contain it? Or
>> maybe we can backport the fixes...
>
>Hi,
>
>No, this is correct and it is message boundary based. Idea of this
>patchset is to add extra boundaries marker which i think could be
>useful when we want to send data in seqpacket mode which length
>is bigger than maximum message length(this is limited by transport).
>Of course we can fragment big piece of data too small messages, but 
>this
>requires to carry fragmentation info in data protocol. So In this case
>when we want to maintain boundaries receiver calls recvmsg() until 
>MSG_EOR found.
>But when receiver knows, that data is fit in maximum datagram length,
>it doesn't care about checking MSG_EOR just calling recv() or 
>read()(e.g.
>message based mode).

I'm not sure we should maintain boundaries of multiple send(), from 
POSIX standard [1]:

   SOCK_SEQPACKET
     Provides sequenced, reliable, bidirectional, connection-mode 
     transmission paths for records. A record can be sent using one or 
     more output operations and received using one or more input 
     operations, but a single operation never transfers part of more than 
     one record. Record boundaries are visible to the receiver via the 
     MSG_EOR flag.

 From my understanding a record could be sent with multiple send() and 
received, for example, with a single recvmsg().
The only boundary should be the MSG_EOR flag set by the user on the last 
send() of a record.

 From send() description [2]:

   MSG_EOR
     Terminates a record (if supported by the protocol).

 From recvmsg() description [3]:

   MSG_EOR
     End-of-record was received (if supported by the protocol).

Thanks,
Stefano

[1] 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/socket.html
[2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/send.html
[3] 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/recvmsg.html

