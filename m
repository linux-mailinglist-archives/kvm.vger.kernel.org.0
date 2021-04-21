Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03067366819
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 11:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbhDUJfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 05:35:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhDUJfT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 05:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618997686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpoI9NRVB9qsYiKBOjY+ZdCUBK0VWmcEa3eQmAnrZgM=;
        b=UxgBFB/2qt04JFHa9Jh09ox+L5/EYD/Iyfa3KskazMAqCTI/QilLKidE8qyCJsAGzGWcSd
        vclCPPy2pzYXEcCdJhI0PGRCkXBJYcuCPGMt8oRdrALLE/JfaobjQtmEvTeyuC8/wSaERC
        AxMpqFQPSiMBa1ad4OEd08jKRjSpy+Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-3QHHbbXRO4O0c38PS1_FlA-1; Wed, 21 Apr 2021 05:34:12 -0400
X-MC-Unique: 3QHHbbXRO4O0c38PS1_FlA-1
Received: by mail-ed1-f69.google.com with SMTP id r14-20020a50d68e0000b0290385504d6e4eso4777219edi.7
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 02:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lpoI9NRVB9qsYiKBOjY+ZdCUBK0VWmcEa3eQmAnrZgM=;
        b=RTuS6YVmgQ5JKLZKOtNIY7eD+BrADrgP1clx0drEzm4+Y8ZLvQ1yLIw7u0TXrGifSX
         L/Ij0MFK7PcUwWVt4QnCJbhOFzI0C37ch3ptySd39753P0kjfNtvkn8W7Gki/Ow7oGIl
         RCeS8J2qkmMTmEhwYfNh1FTItywGKvr3OTHVapgli7dyTJHRFeEeu9S9PINKZ3Q03Gm1
         mlQVtyRd+lsVTHQHoXyRtd1qicZLdiQK4sg6VU6AeSU/NscD+0xnoz8pe8wyXvz9kX/d
         +z/xPJEJEJ9yOfitNWeL12bYsdtSFVw9HhBU04fEXBBNDyDUjbSU6ctW1OFJzBrwdQzk
         8kuA==
X-Gm-Message-State: AOAM530V2OKzgBv8lxAvb40qsVpJpdQEE1ywPEIBTy88fxSxyBMLub/f
        sLQo6BWpXVMpCS2QWE7+gv8p67fpnE5ZxzZNFOdrJtIqEhOzHTDqOcXWFAkrJhvL4ed//9kzxd4
        CNb5RlR5aTDTb
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr16652033ejq.50.1618997651890;
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydZjMGm8LWfdlf7IEz5Kzgw+nZROXo4yoyEKgJ4CVcOLHoFG40yO1hYMeXrSjiHD1qHIw/Iw==
X-Received: by 2002:a17:906:5a83:: with SMTP id l3mr16652025ejq.50.1618997651755;
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id f19sm2606693edu.12.2021.04.21.02.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:34:11 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:34:09 +0200
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
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v8 16/19] vsock/loopback: enable SEQPACKET for
 transport
Message-ID: <20210421093409.latwryhd7scomdav@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124642.3406320-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210413124642.3406320-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:46:39PM +0300, Arseny Krasnov wrote:
>This adds SEQPACKET ops for loopback transport and 'seqpacket_allow()'
>callback.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> net/vmw_vsock/vsock_loopback.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index a45f7ffca8c5..d38ffdbecc84 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -63,6 +63,8 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> 	return 0;
> }
>
>+static bool vsock_loopback_seqpacket_allow(void);
>+
> static struct virtio_transport loopback_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -89,6 +91,10 @@ static struct virtio_transport loopback_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = vsock_loopback_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -103,8 +109,14 @@ static struct virtio_transport loopback_transport = {
> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
>+	.seqpacket_allow = true
> };
>
>+static bool vsock_loopback_seqpacket_allow(void)
>+{
>+	return loopback_transport.seqpacket_allow;
>+}

here I think we could always return true, since we will remove 
`.seqpacket_allow` from struct virtio_transport.

>+
> static void vsock_loopback_work(struct work_struct *work)
> {
> 	struct vsock_loopback *vsock =
>-- 
>2.25.1
>

