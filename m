Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0924010AD
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbhIEP4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 11:56:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235352AbhIEP4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 11:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630857333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FkqlDLwxY15uPA5cvtZn8WB/ij23mnSGY7u9OAsR1+Q=;
        b=Rs8BKOvSH1U4pHq+wAtCjVwyt8FTP8bSzs2F082KK6anN/z4edwqSqhlHJ2a8C8pGdYUcr
        TGF0VLbj3Os0FlaLNGhBzQh8MirTfCwKpoW6/WConwXBITMj92eMEWc+25KGKImXRm6/t+
        CBAYw8Hb5x32Z3LMe0sjH6jB8BjyYIU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Cdr7eH0hPhmCtLthmcDcqA-1; Sun, 05 Sep 2021 11:55:32 -0400
X-MC-Unique: Cdr7eH0hPhmCtLthmcDcqA-1
Received: by mail-wm1-f69.google.com with SMTP id h1-20020a05600c350100b002e751bf6733so2155650wmq.8
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 08:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FkqlDLwxY15uPA5cvtZn8WB/ij23mnSGY7u9OAsR1+Q=;
        b=hfC7qYjQTKPrgOo7rEM7LMQD92KrqEo0gZE+VFJQJFkq5IyVDxHPJCjB9Luth6j8Xe
         nxpzsovZ3sajGZ2eOZH7BP0y1iQ7YZpuC/xVIYUSaQ4Z7wJkKdJseWww7Tf+n4Ah+X2q
         fqa/kzdu/gN5UwWzPoXu5J3IQql5MfUEDFa6yqKCKAw94SeX61QE8ZlytQ5Jdre43M1o
         2auRkDp1SksvEhoOF30OUSpv2wDTLA1UmNw2iQ31GLWn4MAbPBguAYnXtYp2AspCkrfN
         v6VGIegMBhAR1+vcbhZMoilKTmkSKXt/ctVfURs+hl58vBnton1Nt4IAGDk5exj8/HUc
         cqfg==
X-Gm-Message-State: AOAM532beMbSiTS0IpYmUD1dM2kTh7NQRMWQdZy+vOIC2+lPbLg8QyFd
        J6+KPrvAh9SaMKxaSgWr7Iz2h9OLwVezaomqbbnd1eYimpt3XV20A22O0NhLOneLO5+1kt4xsxN
        s2laf5dQQOAoc
X-Received: by 2002:adf:e901:: with SMTP id f1mr9157534wrm.13.1630857331164;
        Sun, 05 Sep 2021 08:55:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoTItRtnLZijeuCdThieRPiWw2ARQXOEWH6eQ4SZ+adLnfig/pueE4P6suOA4XEsTs9sRHXg==
X-Received: by 2002:adf:e901:: with SMTP id f1mr9157499wrm.13.1630857330868;
        Sun, 05 Sep 2021 08:55:30 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id a10sm5294954wrd.51.2021.09.05.08.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:55:30 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:55:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v5 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210905115139-mutt-send-email-mst@kernel.org>
References: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 03:30:13PM +0300, Arseny Krasnov wrote:
> 	This patchset implements support of MSG_EOR bit for SEQPACKET
> AF_VSOCK sockets over virtio transport.
> 	First we need to define 'messages' and 'records' like this:
> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
> etc. It has fixed maximum length, and it bounds are visible using
> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
> Current implementation based on message definition above.
> 	Record has unlimited length, it consists of multiple message,
> and bounds of record are visible via MSG_EOR flag returned from
> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
> receiver will see MSG_EOR when corresponding message will be processed.
> 	Idea of patchset comes from POSIX: it says that SEQPACKET
> supports record boundaries which are visible for receiver using
> MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
> and we don't need to maintain boundaries of corresponding send -
> receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
> that all these calls operates with messages, e.g. 'sendXXX()' sends
> message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
> must read one entire message from socket, dropping all out of size
> bytes. Thus, both message boundaries and MSG_EOR bit must be supported
> to follow POSIX rules.
> 	To support MSG_EOR new bit was added along with existing
> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
> is used to mark 'MSG_EOR' bit passed from userspace.
> 	This patchset includes simple test for MSG_EOR.


I'm prepared to merge this for this window,
but I'm not sure who's supposed to ack the net/vmw_vsock/af_vsock.c
bits. It's a harmless variable renaming so maybe it does not matter.

The rest is virtio stuff so I guess my tree is ok.

Objections, anyone?



>  Arseny Krasnov(6):
>   virtio/vsock: rename 'EOR' to 'EOM' bit.
>   virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOR' bit.
>   vhost/vsock: support MSG_EOR bit processing
>   virtio/vsock: support MSG_EOR bit processing
>   af_vsock: rename variables in receive loop
>   vsock_test: update message bounds test for MSG_EOR
> 
>  drivers/vhost/vsock.c                   | 28 +++++++++++++----------
>  include/uapi/linux/virtio_vsock.h       |  3 ++-
>  net/vmw_vsock/af_vsock.c                | 10 ++++----
>  net/vmw_vsock/virtio_transport_common.c | 23 ++++++++++++-------
>  tools/testing/vsock/vsock_test.c        |  8 ++++++-
>  5 files changed, 45 insertions(+), 27 deletions(-)
> 
>  v4 -> v5:
>  - Move bitwise and out of le32_to_cpu() in 0003.
> 
>  v3 -> v4:
>  - 'sendXXX()' renamed to 'send*()' in 0002- commit msg.
>  - Comment about bit restore updated in 0003-.
>  - 'same' renamed to 'similar' in 0003- commit msg.
>  - u32 used instead of uint32_t in 0003-.
> 
>  v2 -> v3:
>  - 'virtio/vsock: rename 'EOR' to 'EOM' bit.' - commit message updated.
>  - 'VIRTIO_VSOCK_SEQ_EOR' bit add moved to separate patch.
>  - 'vhost/vsock: support MSG_EOR bit processing' - commit message
>    updated.
>  - 'vhost/vsock: support MSG_EOR bit processing' - removed unneeded
>    'le32_to_cpu()', because input argument was already in CPU
>    endianness.
> 
>  v1 -> v2:
>  - 'VIRTIO_VSOCK_SEQ_EOR' is renamed to 'VIRTIO_VSOCK_SEQ_EOM', to
>    support backward compatibility.
>  - use bitmask of flags to restore in vhost.c, instead of separated
>    bool variable for each flag.
>  - test for EAGAIN removed, as logically it is not part of this
>    patchset(will be sent separately).
>  - cover letter updated(added part with POSIX description).
> 
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> -- 
> 2.25.1

