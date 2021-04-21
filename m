Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3111E3667D8
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 11:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbhDUJWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 05:22:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238008AbhDUJWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 05:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618996936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tqz+ILNRVJkY3d8AEaA0cGa9hOYYSpYKO+GI5Wbje3M=;
        b=KNcP5bn3TYk0V/wAiyABoN5QD48ovk4UKkeP8bilAcglF32ptgpyllN6yCxd5WskKsW+uF
        z5ae6aMlBxi59HuQ2B16f18+a5937Ty/qjdaOz+q/Chx8Kg8ETdIZQJD2vqvS6iNnGuU84
        U2KzhHUkjB6zZdeh4MhUWdnTToxyWJU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-1jEQOUpNOgW6O5f12H6Qug-1; Wed, 21 Apr 2021 05:22:12 -0400
X-MC-Unique: 1jEQOUpNOgW6O5f12H6Qug-1
Received: by mail-ed1-f72.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so7302379edb.8
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 02:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tqz+ILNRVJkY3d8AEaA0cGa9hOYYSpYKO+GI5Wbje3M=;
        b=rL1OQb+c2vbJrvhYdmxHZd8hpl8a6QKJDZHZ17O0xGt/8lpnvG4cgNBo6yOT27AFxY
         eyxIoZ9HfhcjtGJQQdBa3AIZK0BA2CAE1mHlmz5csAWPgPKcn4UGLN1s3kfAy+uUYDFq
         bAQyPZ5GHVtznH23i4Lrw7pqIaxUMpj8r/Jd4FvspwKDQ0WvREqnVasBp6L8EH33c12K
         b2eHyuYWfyWEbhmkKbzmfDgMQiJP3xY/YoGWtuJP0XRGh6UgJcHPC8kXsJ9494+w8C4f
         dIqxWMu9xZuWWrmAGRmE7jWyzuh0kb5j+9/XtUb9a7/ftTv5OCb47+MVV5CU3NbpSEeL
         TWiw==
X-Gm-Message-State: AOAM531S8QEkxjIqmpRSBFsXutNrSYq6Uhcl2rWV2uMCCylAP6ItelBX
        w3V/GCXlUdUtzRHGlpirIktN6np292vH8MwOPDWUse8MiLd7Jsgjq4NrssE8ol1vhuSni/eYPJF
        U98TJZe3khFue
X-Received: by 2002:a17:907:205c:: with SMTP id pg28mr21587947ejb.185.1618996931505;
        Wed, 21 Apr 2021 02:22:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ1GKcB5m8ic7Uze0zxQ+IL9dAu0rGNwXFSEggtrJZNLeSX8wEQPoYN+/aKzNoisB+znsktw==
X-Received: by 2002:a17:907:205c:: with SMTP id pg28mr21587928ejb.185.1618996931356;
        Wed, 21 Apr 2021 02:22:11 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id g11sm2480790edt.35.2021.04.21.02.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:22:11 -0700 (PDT)
Date:   Wed, 21 Apr 2021 11:22:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v8 14/19] virtio/vsock: enable SEQPACKET for transport
Message-ID: <20210421092208.hjng7pv7loh4fj3t@steredhat>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124552.3404877-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210413124552.3404877-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 03:45:49PM +0300, Arseny Krasnov wrote:
>This adds
>1) SEQPACKET ops for virtio transport and 'seqpacket_allow()' callback.
>2) Handling of SEQPACKET bit: guest tries to negotiate it with vhost.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
>v7 -> v8:
> - This patch merged with patch which adds SEQPACKET feature bit to
>   virtio transport.
>
> net/vmw_vsock/virtio_transport.c | 17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..ee99bd919a12 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -443,6 +443,8 @@ static void virtio_vsock_rx_done(struct virtqueue 
>*vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+static bool virtio_transport_seqpacket_allow(void);
>+
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -469,6 +471,10 @@ static struct virtio_transport virtio_transport = {
> 		.stream_is_active         = virtio_transport_stream_is_active,
> 		.stream_allow             = virtio_transport_stream_allow,
>
>+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
>+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
>+		.seqpacket_allow          = virtio_transport_seqpacket_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = 
> 		virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>@@ -483,8 +489,14 @@ static struct virtio_transport virtio_transport = {
> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>+	.seqpacket_allow = false
> };
>
>+static bool virtio_transport_seqpacket_allow(void)
>+{
>+	return virtio_transport.seqpacket_allow;
>+}
>+
> static void virtio_transport_rx_work(struct work_struct *work)
> {
> 	struct virtio_vsock *vsock =
>@@ -612,6 +624,10 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>+
>+	if (vdev->features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
>+		virtio_transport.seqpacket_allow = true;
>+

virtio-vsock devices can be hot-plugged and hot-unplugged, so we should 
reset virtio_transport.seqpacket_allow at every probe.

Now thinking about it more, would it be better to save this information 
in struct virtio_vsock instead of struct virtio_transport?

> 	return 0;
>
> out:
>@@ -695,6 +711,7 @@ static struct virtio_device_id id_table[] = {
> };
>
> static unsigned int features[] = {
>+	VIRTIO_VSOCK_F_SEQPACKET
> };
>
> static struct virtio_driver virtio_vsock_driver = {
>-- 
>2.25.1
>

