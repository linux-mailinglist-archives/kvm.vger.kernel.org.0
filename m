Return-Path: <kvm+bounces-2856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3B47FEAF7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D8071C20E02
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF2A31A99;
	Thu, 30 Nov 2023 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PzZwHW+n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2866010F4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701333549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuNrzCx4xahsS/7j/jwf4UTh/OtxU2ehfXj/9UH3fEA=;
	b=PzZwHW+nmYzo/4+8fV4q7KIYf/vZROrZcllZF/6c6Qjhui7+TGLsqy6epn0nYdRAI+EIRR
	jbxLM5IPolOE4g2zjQcsSFmT46bSNtmRwdMTQshQVtfzoNyGfxmah0Y1y8zoQ0eBrLbqc3
	A5JxHFk36nl0FVmy5MCAF8CJzudcCFY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-D0p1bVAYPcmDbEGaV7gZVg-1; Thu, 30 Nov 2023 03:39:02 -0500
X-MC-Unique: D0p1bVAYPcmDbEGaV7gZVg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c8850a2d62so7017941fa.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:39:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701333540; x=1701938340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AuNrzCx4xahsS/7j/jwf4UTh/OtxU2ehfXj/9UH3fEA=;
        b=bfZuwv9eG00QoCPcjySi3HJYjxRtQZBllAmNHe6JRcSJtDiVJQRuagDaWFvN928qf1
         a3O3UwGgw8Korx1H7RDdjKb/VTTYjyDatr/ldbhGVJK0npL+HNjvyN7V665HRFrJwWAD
         Jg7s9csEtQyXOsF0Bubc8XMd46YB39anPVQz9SlxrxnZF8IHVluVl5uPsXjGZeoNkKBd
         4Pf2Ej1NZok6GIEhHWMYC2fr3UU38J9tSyNV1yFdJyw1WGVp/mnTfAmDcF359e2wybXO
         JAWtC58e+Bp4zFgTyOxxIzjXXWSLiTL3kXiWbAbEQZYnsOsc/6JeKJd66OtZNYceX6NW
         3SzQ==
X-Gm-Message-State: AOJu0YxF7K0DT/SpQjbSXTBFl0sBIZOAOhgkAXkYvNDsCnC/Mrw0gdKN
	8PfDxWgkajPh7oKVQmSAgC3oHNTMweub4ieVAwiReCvdZchHnEzj1Cfl4gYeKt9fSqj9vKDqeny
	/3zE1KMYJhm/Uw8wRBKcV
X-Received: by 2002:a2e:9954:0:b0:2c9:ba2f:ac73 with SMTP id r20-20020a2e9954000000b002c9ba2fac73mr3934589ljj.16.1701333540466;
        Thu, 30 Nov 2023 00:39:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqjjOHOs1PQiUSVLZnqTmub+NdORBII7kxiTreMC5zM9NYNdp4AleI9xrrM5E0kPgB2RzjPA==
X-Received: by 2002:a2e:9954:0:b0:2c9:ba2f:ac73 with SMTP id r20-20020a2e9954000000b002c9ba2fac73mr3934567ljj.16.1701333540119;
        Thu, 30 Nov 2023 00:39:00 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id v13-20020adfedcd000000b003331bd6f58esm869261wro.69.2023.11.30.00.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 00:38:59 -0800 (PST)
Date: Thu, 30 Nov 2023 09:38:54 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <cdgg4rtr6t3ez7l7vbgngmeitsmrplwg7vgpebodrxkpouh4yn@yb4aug7zergh>
References: <20231129212519.2938875-1-avkrasnov@salutedevices.com>
 <20231129212519.2938875-3-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231129212519.2938875-3-avkrasnov@salutedevices.com>

On Thu, Nov 30, 2023 at 12:25:18AM +0300, Arseniy Krasnov wrote:
>Send credit update message when SO_RCVLOWAT is updated and it is bigger
>than number of bytes in rx queue. It is needed, because 'poll()' will
>wait until number of bytes in rx queue will be not smaller than
>SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>for tx/rx is possible: sender waits for free space and receiver is
>waiting data in 'poll()'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Update commit message by removing 'This patch adds XXX' manner.
>  * Do not initialize 'send_update' variable - set it directly during
>    first usage.
> v3 -> v4:
>  * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>
> drivers/vhost/vsock.c                   |  3 ++-
> include/linux/virtio_vsock.h            |  1 +
> net/vmw_vsock/virtio_transport.c        |  3 ++-
> net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |  3 ++-
> 5 files changed, 34 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index f75731396b7e..c5e58a60a546 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -449,8 +449,9 @@ static struct virtio_transport vhost_transport = {
> 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>-		.read_skb = virtio_transport_read_skb,
>+		.read_skb = virtio_transport_read_skb

I think it is better to avoid this change, so when we will need to add
new callbacks, we don't need to edit this line again.

Please avoid it also in the other place in this patch.

The rest LGTM.

Thanks,
Stefano

> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index ebb3ce63d64d..c82089dee0c8 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct 
>virtio_vsock_sock *vvs, u32 credit);
> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
> int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>+int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
> #endif /* _LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index af5bab1acee1..8b7bb7ca8ea5 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -537,8 +537,9 @@ static struct virtio_transport virtio_transport = {
> 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>-		.read_skb = virtio_transport_read_skb,
>+		.read_skb = virtio_transport_read_skb
> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index f6dc896bf44c..1cb556ad4597 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock 
>*vsk, skb_read_actor_t recv_acto
> }
> EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>
>+int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	bool send_update;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	/* If number of available bytes is less than new SO_RCVLOWAT value,
>+	 * kick sender to send more data, because sender may sleep in its
>+	 * 'send()' syscall waiting for enough space at our side.
>+	 */
>+	send_update = vvs->rx_bytes < val;
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	if (send_update) {
>+		int err;
>+
>+		err = virtio_transport_send_credit_update(vsk);
>+		if (err < 0)
>+			return err;
>+	}
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
>+
> MODULE_LICENSE("GPL v2");
> MODULE_AUTHOR("Asias He");
> MODULE_DESCRIPTION("common code for virtio vsock");
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 048640167411..454f69838c2a 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -96,8 +96,9 @@ static struct virtio_transport loopback_transport = {
> 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
> 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>+		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>-		.read_skb = virtio_transport_read_skb,
>+		.read_skb = virtio_transport_read_skb
> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
>-- 
>2.25.1
>


