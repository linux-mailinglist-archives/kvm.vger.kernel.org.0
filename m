Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD23B30A9F0
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 15:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhBAOhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 09:37:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhBAOg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 09:36:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612190100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGH0ZSLBAZ/lXbnG+6O2ml/2vbQGE/imbivvvvyRaT4=;
        b=BDQxAuOOidOVKc0KvBu1eveEBKNaShublOWUpXITUnbcgTIKpFRC2IBxcFJ1jWciP/Q7go
        p9PQNTysd8DmE0YuQDSnTgSBvw62GsU4fQuKmy90GXMcM8bLelmXurxpGKX/VEPBZYmecZ
        WSM6+TcTNGcivPZNMLce8GRCFOG2ZjQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-i8Rce318Oo-jBk_ZkMKY0w-1; Mon, 01 Feb 2021 09:34:56 -0500
X-MC-Unique: i8Rce318Oo-jBk_ZkMKY0w-1
Received: by mail-wm1-f70.google.com with SMTP id y9so423895wmj.7
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 06:34:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iGH0ZSLBAZ/lXbnG+6O2ml/2vbQGE/imbivvvvyRaT4=;
        b=ch/N+/wZp+mJYfCE0hPT7JqwZBJ8oy+Pa6oR/KuBvfrKQ75KWLjUl74dwqOpBshe/s
         5XBf9Ln2bVHgfIi7XIjn41Q5Bh5TYxEHfw4Re40SA63fuSCEnuM0dxbfvsHyFuegizsg
         VRtng8fj7UibqBdqyECHE45KYS2/Yy4ZaTnPPxrqrHZ9O2bGKnimlZ1AnGV6AcP4E8ra
         VNAC2MeIcUUBoT7qB9gIuX24UrhxqLdDf8m8umEjT53geGwFx5nHSMOf4QNoPO8c6zfT
         k9v5Enq/qem97IgfyQwjQL0ESuMBdS7a0hxchTpY8S6oyEGlt8+1OeWIy/qA8gVaUI1z
         7wEA==
X-Gm-Message-State: AOAM5331MQgKLVhyhOymVJ9TwFNPKHv1Nqi4bdlRMsUYWtoy3Ze85Nig
        NIZyoHJJzSnw3qkVoBpMfrA5YDRyH4Dv8FeufbUaQOXkm7EvWUC627IiJs2nFb3cL9AlIZC/Vdo
        5CyI8z0B6N+M1
X-Received: by 2002:adf:e4c4:: with SMTP id v4mr17503508wrm.376.1612190095170;
        Mon, 01 Feb 2021 06:34:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBsgItRHswu5hBiL2QT2YHSQdpQb0FbvdxTnwiMJFgAMcNcvTM6ctxK1RJZn0uU74nZoqHvA==
X-Received: by 2002:adf:e4c4:: with SMTP id v4mr17503482wrm.376.1612190094843;
        Mon, 01 Feb 2021 06:34:54 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id h23sm3270334wmb.41.2021.02.01.06.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 06:34:54 -0800 (PST)
Date:   Mon, 1 Feb 2021 15:34:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v3 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210201143451.njs3fzbg3exguayx@steredhat>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210128171923.esyna5ccv5s27jyu@steredhat>
 <63459bb3-da22-b2a4-71ee-e67660fd2e12@kaspersky.com>
 <20210129092604.mgaw3ipiyv6xra3b@steredhat>
 <cb6d5a9c-fd49-a9dd-33b3-52027ae2f71c@kaspersky.com>
 <20210201110258.7ze7a7izl7gesv4w@steredhat>
 <1b80eb27-4818-50d7-7454-ff6cc398422e@kaspersky.com>
 <20210201142333.7zcgoqq432y7kktb@steredhat>
 <a8ff5600-c166-ee75-1e62-06ae127e2352@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8ff5600-c166-ee75-1e62-06ae127e2352@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 05:32:00PM +0300, Arseny Krasnov wrote:
>
>On 01.02.2021 17:23, Stefano Garzarella wrote:
>> On Mon, Feb 01, 2021 at 04:57:18PM +0300, Arseny Krasnov wrote:
>>> On 01.02.2021 14:02, Stefano Garzarella wrote:
>>>> On Fri, Jan 29, 2021 at 06:52:23PM +0300, Arseny Krasnov wrote:
>>>>> On 29.01.2021 12:26, Stefano Garzarella wrote:
>>>>>> On Fri, Jan 29, 2021 at 09:41:50AM +0300, Arseny Krasnov wrote:
>>>>>>> On 28.01.2021 20:19, Stefano Garzarella wrote:
>>>>>>>> Hi Arseny,
>>>>>>>> I reviewed a part, tomorrow I hope to finish the other patches.
>>>>>>>>
>>>>>>>> Just a couple of comments in the TODOs below.
>>>>>>>>
>>>>>>>> On Mon, Jan 25, 2021 at 02:09:00PM +0300, Arseny Krasnov wrote:
>>>>>>>>> 	This patchset impelements support of SOCK_SEQPACKET for virtio
>>>>>>>>> transport.
>>>>>>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>>>>>>> do it, new packet operation was added: it marks start of record (with
>>>>>>>>> record length in header), such packet doesn't carry any data.  To send
>>>>>>>>> record, packet with start marker is sent first, then all data is sent
>>>>>>>>> as usual 'RW' packets. On receiver's side, length of record is known
>>>>>>>> >from packet with start record marker. Now as  packets of one socket
>>>>>>>>> are not reordered neither on vsock nor on vhost transport layers, such
>>>>>>>>> marker allows to restore original record on receiver's side. If user's
>>>>>>>>> buffer is smaller that record length, when all out of size data is
>>>>>>>>> dropped.
>>>>>>>>> 	Maximum length of datagram is not limited as in stream socket,
>>>>>>>>> because same credit logic is used. Difference with stream socket is
>>>>>>>>> that user is not woken up until whole record is received or error
>>>>>>>>> occurred. Implementation also supports 'MSG_EOR' and 'MSG_TRUNC' flags.
>>>>>>>>> 	Tests also implemented.
>>>>>>>>>
>>>>>>>>> Arseny Krasnov (13):
>>>>>>>>>  af_vsock: prepare for SOCK_SEQPACKET support
>>>>>>>>>  af_vsock: prepare 'vsock_connectible_recvmsg()'
>>>>>>>>>  af_vsock: implement SEQPACKET rx loop
>>>>>>>>>  af_vsock: implement send logic for SOCK_SEQPACKET
>>>>>>>>>  af_vsock: rest of SEQPACKET support
>>>>>>>>>  af_vsock: update comments for stream sockets
>>>>>>>>>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>>>>>>  virtio/vsock: fetch length for SEQPACKET record
>>>>>>>>>  virtio/vsock: add SEQPACKET receive logic
>>>>>>>>>  virtio/vsock: rest of SOCK_SEQPACKET support
>>>>>>>>>  virtio/vsock: setup SEQPACKET ops for transport
>>>>>>>>>  vhost/vsock: setup SEQPACKET ops for transport
>>>>>>>>>  vsock_test: add SOCK_SEQPACKET tests
>>>>>>>>>
>>>>>>>>> drivers/vhost/vsock.c                   |   7 +-
>>>>>>>>> include/linux/virtio_vsock.h            |  12 +
>>>>>>>>> include/net/af_vsock.h                  |   6 +
>>>>>>>>> include/uapi/linux/virtio_vsock.h       |   9 +
>>>>>>>>> net/vmw_vsock/af_vsock.c                | 543 ++++++++++++++++------
>>>>>>>>> net/vmw_vsock/virtio_transport.c        |   4 +
>>>>>>>>> net/vmw_vsock/virtio_transport_common.c | 295 ++++++++++--
>>>>>>>>> tools/testing/vsock/util.c              |  32 +-
>>>>>>>>> tools/testing/vsock/util.h              |   3 +
>>>>>>>>> tools/testing/vsock/vsock_test.c        | 126 +++++
>>>>>>>>> 10 files changed, 862 insertions(+), 175 deletions(-)
>>>>>>>>>
>>>>>>>>> TODO:
>>>>>>>>> - Support for record integrity control. As transport could drop some
>>>>>>>>>   packets, something like "record-id" and record end marker need to
>>>>>>>>>   be implemented. Idea is that SEQ_BEGIN packet carries both record
>>>>>>>>>   length and record id, end marker(let it be SEQ_END) carries only
>>>>>>>>>   record id. To be sure that no one packet was lost, receiver checks
>>>>>>>>>   length of data between SEQ_BEGIN and SEQ_END(it must be same with
>>>>>>>>>   value in SEQ_BEGIN) and record ids of SEQ_BEGIN and SEQ_END(this
>>>>>>>>>   means that both markers were not dropped. I think that easiest way
>>>>>>>>>   to implement record id for SEQ_BEGIN is to reuse another field of
>>>>>>>>>   packet header(SEQ_BEGIN already uses 'flags' as record length).For
>>>>>>>>>   SEQ_END record id could be stored in 'flags'.
>>>>>>>> I don't really like the idea of reusing the 'flags' field for this
>>>>>>>> purpose.
>>>>>>>>
>>>>>>>>>     Another way to implement it, is to move metadata of both SEQ_END
>>>>>>>>>   and SEQ_BEGIN to payload. But this approach has problem, because
>>>>>>>>>   if we move something to payload, such payload is accounted by
>>>>>>>>>   credit logic, which fragments payload, while payload with record
>>>>>>>>>   length and id couldn't be fragmented. One way to overcome it is to
>>>>>>>>>   ignore credit update for SEQ_BEGIN/SEQ_END packet.Another solution
>>>>>>>>>   is to update 'stream_has_space()' function: current implementation
>>>>>>>>>   return non-zero when at least 1 byte is allowed to use,but updated
>>>>>>>>>   version will have extra argument, which is needed length. For 'RW'
>>>>>>>>>   packet this argument is 1, for SEQ_BEGIN it is sizeof(record len +
>>>>>>>>>   record id) and for SEQ_END it is sizeof(record id).
>>>>>>>> Is the payload accounted by credit logic also if hdr.op is not
>>>>>>>> VIRTIO_VSOCK_OP_RW?
>>>>>>> Yes, on send any packet with payload could be fragmented if
>>>>>>>
>>>>>>> there is not enough space at receiver. On receive 'fwd_cnt' and
>>>>>>>
>>>>>>> 'buf_alloc' are updated with header of every packet. Of course,
>>>>>>>
>>>>>>> to every such case i've described i can add check for 'RW'
>>>>>>>
>>>>>>> packet, to exclude payload from credit accounting, but this is
>>>>>>>
>>>>>>> bunch of dumb checks.
>>>>>>>
>>>>>>>> I think that we can define a specific header to put after the
>>>>>>>> virtio_vsock_hdr when hdr.op is SEQ_BEGIN or SEQ_END, and in this header
>>>>>>>> we can store the id and the length of the message.
>>>>>>> I think it is better than use payload and touch credit logic
>>>>>>>
>>>>>> Cool, so let's try this option, hoping there aren't a lot of issues.
>>>>> If i understand, current implementation has 'struct
>>>>> virtio_vsock_hdr',
>>>>>
>>>>> then i'll add 'struct virtio_vsock_hdr_seq' with message length and id.
>>>>>
>>>>> After that, in 'struct virtio_vsock_pkt' which describes packet, field for
>>>>>
>>>>> header(which is 'struct virtio_vsock_hdr') must be replaced with new
>>>>>
>>>>> structure which  contains both 'struct virtio_vsock_hdr' and 'struct
>>>>>
>>>>> virtio_vsock_hdr_seq', because header field of 'struct virtio_vsock_pkt'
>>>>>
>>>>> is buffer for virtio layer. After it all accesses to header(for example to
>>>>>
>>>>> 'buf_alloc' field will go accross new  structure with both headers:
>>>>>
>>>>> pkt->hdr.buf_alloc   ->   pkt->extended_hdr.classic_hdr.buf_alloc
>>>>>
>>>>> May be to avoid this, packet's header could be allocated dynamically
>>>>>
>>>>> in the same manner as packet's buffer? Size of allocation is always
>>>>>
>>>>> sizeof(classic header) + sizeof(seq header). In 'struct virtio_vsock_pkt'
>>>>>
>>>>> such header will be implemented as union of two pointers: class header
>>>>>
>>>>> and extended header containing classic and seq header. Which pointer
>>>>>
>>>>> to use is depends on packet's op.
>>>> I think that the 'classic header' can stay as is, and the extended
>>>> header can be dynamically allocated, as we do for the payload.
>>>>
>>>> But we have to be careful what happens if the other peer doesn't support
>>>> SEQPACKET and if it counts this extra header as a payload for the credit
>>>> mechanism.
>>> You mean put extra header to payload(buffer of second virtio desc),
>>>
>>> in this way on send/receive auxiliary 'if's are needed to avoid credit
>>>
>>> logic(or set length field in header of such packets to 0). But what
>>>
>>> about placing extra header after classic header in buffer of first virtio
>>>
>>> desc? In this case extra header is not payload and credit works as is.
>>>
>>> Or it is critical, that size of first buffer will be not same as size of
>>>
>>> classic header?
>> We need to think about compatibility with old drivers.
>Yes, compatibility seems to be a trouble.
>>
>> What would happen in this case?
>>
>> I think it's easier to use the second buffer, usually used for the
>> payload, to carry the extra header. Also, we can leave hdr.len = 0, so
>> we are sure that it is not counted in credit mechanism.
>
>Ok, that one of possible solutions. I just wanted to inform you,
>
>that way i'll use in v4
>
>> If the driver supports SEQPACKET, it knows it must fetch extra header
>> when it must handle SEQ_BEGIN/SEQ_END.
>>
>> If it is not clear, I'll try to provide a simple PoC of a patch.
>
>No, it is clear for me, i'll implement it in v4 also take care of
>
>review comments.

Great! Let me know if any issues we haven't considered come up.

Stefano

