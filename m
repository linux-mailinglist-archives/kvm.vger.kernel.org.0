Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9223367F05
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhDVKtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235513AbhDVKsz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619088499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W56Co4nmu9futOlRgTdRc7GGowpj4sKz++PgS6J5tsk=;
        b=dlqBfDXOPLAAthq3eU+GFg8nSm5PKmrKr5EzImFVCrKAovkON0hRU4n+bkR1F1FpRCSW2h
        OkG9wFFfJxV7OWqPYYVvVLqaX2EP3QSnP93znGnOGPW5+CImK8+9i2vfi1Uufz0WlJQoI6
        tGBv79/rl8rQfpV6rrWKRoZGgfs+xuI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-nQzW2o-RM9CK5PRPWQi-qg-1; Thu, 22 Apr 2021 06:48:17 -0400
X-MC-Unique: nQzW2o-RM9CK5PRPWQi-qg-1
Received: by mail-ej1-f71.google.com with SMTP id bx15-20020a170906a1cfb029037415131f28so7092968ejb.18
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W56Co4nmu9futOlRgTdRc7GGowpj4sKz++PgS6J5tsk=;
        b=jzAZJ17b5SEg6aeNgWFNoGD4hMwNTVLrwHlMNemlwezpTZJRmfCGazSz90mvNFjH7s
         /SxyPL+lADBOL8DKDSY5Z+2zXwRHCR1kO0Cnej+0WnYwxhafEvtUfKdZXpD68pI1nAEU
         hzTAdkJClmXJCq3O3AYBvPReErSGBCSaxqIRpJD8Yv9pPYT9Dm3l9XKr2EuIhDNbJsme
         Oodmxg35jOAQsScTBOiDlv7oXmH27eKf9yCJFbAlRxD0FY06K0I5cKZgBV2I9X72K638
         55E13yLySjf5kp8ekctTDO5cGXolREh/Idi8dnTgbsv6K2aZmf+MMkN51FD4KjJm9L7x
         v4CA==
X-Gm-Message-State: AOAM531Uw9E2WLzMO/djPkguhkTYnTvmLI68CjdbWFPHipNl6jeVw5ub
        ngm+yocnkmkYGdH2wnGyHGgRfMTRiFwMwvng8v4Me2NdZ8dy4UfuV74lFV9SHXOQNUZP+epCtyA
        RvzSPYS9hiRzX
X-Received: by 2002:a17:906:cec2:: with SMTP id si2mr2807091ejb.234.1619088496488;
        Thu, 22 Apr 2021 03:48:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3/JpW1+yllDt8fPHdvJEi1YttSx3GfTb7YhzmFF4NC8d2xAOCwtXohAtzSrborDsblnu1zw==
X-Received: by 2002:a17:906:cec2:: with SMTP id si2mr2807055ejb.234.1619088496251;
        Thu, 22 Apr 2021 03:48:16 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id d10sm1577096ejw.125.2021.04.22.03.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 03:48:15 -0700 (PDT)
Date:   Thu, 22 Apr 2021 12:48:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v8 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210422104813.e2p4wzuk2ahw7af7@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210421095213.25hnfi2th7gzyzt2@steredhat>
 <2c3d0749-0f41-e064-0153-b6130268add2@kaspersky.com>
 <20210422084638.bvblk33b4oi6cec6@steredhat>
 <bfefdd94-a84f-8bed-331e-274654a7426f@kaspersky.com>
 <20210422100217.jmpgevtrukqyukfo@steredhat>
 <bc649d1b-80d8-835c-6f47-8a7d402dd0b7@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bc649d1b-80d8-835c-6f47-8a7d402dd0b7@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 01:29:54PM +0300, Arseny Krasnov wrote:
>
>On 22.04.2021 13:02, Stefano Garzarella wrote:
>> On Thu, Apr 22, 2021 at 12:40:17PM +0300, Arseny Krasnov wrote:
>>> On 22.04.2021 11:46, Stefano Garzarella wrote:
>>>> On Wed, Apr 21, 2021 at 06:06:28PM +0300, Arseny Krasnov wrote:
>>>>> Thank You, i'll prepare next version. Main question is: does this
>>>>> approach(no SEQ_BEGIN, SEQ_END, 'msg_len' and 'msg_id') considered
>>>>> good? In this case it will be easier to prepare final version, because
>>>>> is smaller and more simple than previous logic. Also patch to spec
>>>>> will be smaller.
>>>> Yes, it's definitely much better than before.
>>>>
>>>> The only problem I see is that we add some overhead per fragment
>>>> (header). We could solve that with the mergeable buffers that Jiang is
>>>> considering for DGRAM.
>>> If we are talking about receive, i think, i can reuse merge logic for
>> Yep, for TX the guest can potentially enqueue a big buffer.
>> Maybe it's still worth keeping a maximum size and fragmenting as we do
>> now.
>>
>>> stream sockets, the only difference is that buffers are mergeable
>>> until previous EOR(e.g. previous message) bit is found in rx queue.
>>>
>> I got a little lost.
>> Can you elaborate more?
>
>I'm talking about 'virtio_transport_recv_enqueue()': it tries to copy
>
>data of new packet to buffer of tail packet in rx queue. In case of
>
>SEQPACKET i can reuse it, just adding logic that check EOR bit of
>
>tail packet.

This might be a good idea.
It doesn't save us the transmitted header though, but at least it saves 
us from queuing it.
Even if with SEQPACKET I don't expect small packets, since it's the 
driver that divides them and I think it does everything to use the 
maximum available.

Instead the mergeable buffers I was referring to are based on the 
virito-net feature VIRTIO_NET_F_MRG_RXBUF.
Jiang is investigating whether we can reuse them for DGRAM.

Thanks,
Stefano

