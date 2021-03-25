Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886F5348DB9
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCYKJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 06:09:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230155AbhCYKJT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 06:09:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616666959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kHwyM01WyqgWKCfJirzSlimPQ/XDp3q0BkoluHcHB6k=;
        b=OZlZqvDSASd+2XrkeMQs1YXRFqryjJKYedeQkbAhTi6YZh/wdRetle2swy5EuhIQ0VV0KF
        kdyPh7wYeDnGUzo+Taessuj/U30o27HE8ZSQqbGWxypqeSnfmyKsYb/0LS9ztK8tKjA5/A
        e0rPUU/vATfuTCPnEgEe8NAn+dZREuk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-V85tL7bUPH2JZaR-aOWpRQ-1; Thu, 25 Mar 2021 06:09:17 -0400
X-MC-Unique: V85tL7bUPH2JZaR-aOWpRQ-1
Received: by mail-wm1-f70.google.com with SMTP id o9-20020a05600c4fc9b029010cea48b602so750347wmq.0
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 03:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kHwyM01WyqgWKCfJirzSlimPQ/XDp3q0BkoluHcHB6k=;
        b=e8J2Bm2UEN2Dd1rd0N61bjrRDzpjFC75ilzOIOO0IygC66bV9/oJHTA/auzNMnrMFQ
         ck5fYbAONrqKf5tMkVswV9bZGJnfguOoayWomyFbXHwnfRAxxjOtQlBnsmlPk2yzzvcT
         QvlHrTMLAuJssDnWU/kJXbYNPUBZXedYZ3OOhWhd+l+ktaF6KYw9xUWvLYdLywLpywMw
         UoSMvFfaPEc4RRxPjBxjxJCU5pEmYJOPL06ZNeA263DAlC4uEMjFjO9J10Alt6jEtM+P
         8e/GU8vXrqP56JgKQLhjocogMKPmhzJNzUVvuyh0haInB6B0dPMynxKrAfQvh6paDvYU
         jotA==
X-Gm-Message-State: AOAM53118BKiDopqw8JmqeWMW2+/dZ9qmAqJ9yRxCKHoewfLenM0fJfN
        qbj/Qai+Ej35/Klzyz7wt+T0G1XWYJ10Vg3megy4yfYDKnFv/9QlV0ISwieHfbgn+QmIUqaW0pm
        mnd8h6mNEAzbj
X-Received: by 2002:adf:a18a:: with SMTP id u10mr8019014wru.197.1616666956447;
        Thu, 25 Mar 2021 03:09:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzyIyWOSmU8uyQs1/B6aVWJTTtn53k7n4EHV1c4wLdktCa9Xv2dMFQu8Wdv5ezJuNgAsU+aw==
X-Received: by 2002:adf:a18a:: with SMTP id u10mr8018978wru.197.1616666956222;
        Thu, 25 Mar 2021 03:09:16 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id s83sm6216998wms.16.2021.03.25.03.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:09:15 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:09:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 13/22] virtio/vsock: add SEQPACKET receive logic
Message-ID: <20210325100913.7rewuc4wn7zwtrqf@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131316.2461284-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131316.2461284-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:13:13PM +0300, Arseny Krasnov wrote:
>This modifies current receive logic for SEQPACKET support:
>1) Inserts 'SEQ_BEGIN' packet to socket's rx queue.
>2) Inserts 'RW' packet to socket's rx queue, but without merging with
>   buffer of last packet in queue.
>3) Performs check for packet and socket types on receive(if mismatch,
>   then reset connection).
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> v6 -> v7:
> In 'virtio_transport_recv_pkt()', 'sock_put()' is added, when type of
> received packet does not match to the type of socket.
>
> net/vmw_vsock/virtio_transport_common.c | 64 +++++++++++++++++--------
> 1 file changed, 45 insertions(+), 19 deletions(-)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

