Return-Path: <kvm+bounces-2739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E72127FD194
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20818283245
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9C212B9F;
	Wed, 29 Nov 2023 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClaKvL5N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A608D50
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701248513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zwc9ieluISalwFh3TyYZ4gcQacsA94sf6qSa2kEUESI=;
	b=ClaKvL5NKcIJgeEC7015ezw7q4HePsEijIejXfOJ97W+Qr5y0WcnRTI6zSU1e8sQylIk2l
	aeMsuE8eGzIDEtCv3kmpfFRgtnllXzzYqp31Lap885DRhTBoYq2M/DfuJeYBDuOkkouoNF
	bUTTdCPdLSQoRHunR/znG1K8ccUIBhU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-wwWKikj9MHmvX6LrnnFAhg-1; Wed, 29 Nov 2023 04:01:51 -0500
X-MC-Unique: wwWKikj9MHmvX6LrnnFAhg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332f3c6614bso3047511f8f.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701248510; x=1701853310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwc9ieluISalwFh3TyYZ4gcQacsA94sf6qSa2kEUESI=;
        b=QYWF4XYt+EgXn1EU5F6sPBUeKroT/Izb/ZP9Fh3OQ0vduhKxkU2Jej2S2ivBCcCEuy
         nPh1FvupC45dewGKujT59M/mXNTrXLC8E3NQBPw7O1skF8MsW2/f3N1HebgOWA//+Xve
         8BidDYp9WaGcobJ7b1gxEPl673saNQ+yuuWcMW7xUz3wtg60MoouBkmASV6dgqoVitDB
         Xzr+LulmYm6dljDHKlIfQLdvyoYhOH6dzkv7V6FqM9W1U8xpEr4dFf3GzdQGOnXBt0EW
         IYf10XCTzrIWTBc0bigPq4ySdlAlF7Ni1xg0ojj43e7gFq/Cbd739+ic4Zd3NpYc6QAm
         Akxg==
X-Gm-Message-State: AOJu0Yzwa1SWKk3nSV8bB4AvXqwpaGoQWiKZauM7k2eccIZRFvJM5Rcd
	XmbLLW/LQ3QsJEwHODo3eWNLvHPrlRdFWVgplA/7IbkqU5F8EaJmS91+CFlBEciMdl+K0CrL380
	zsGQNps8W9uq+
X-Received: by 2002:adf:b1d5:0:b0:332:c441:70aa with SMTP id r21-20020adfb1d5000000b00332c44170aamr13788939wra.26.1701248510390;
        Wed, 29 Nov 2023 01:01:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFP2F6dczPE089a3r9AZSuxONM+6MsCslUykG0rwB+wpDrF0PpgPS4SUfoLewfpzCdrG2iGkA==
X-Received: by 2002:adf:b1d5:0:b0:332:c441:70aa with SMTP id r21-20020adfb1d5000000b00332c44170aamr13788889wra.26.1701248509534;
        Wed, 29 Nov 2023 01:01:49 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id c14-20020a056000104e00b00332f95ab44esm10548348wrx.57.2023.11.29.01.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 01:01:48 -0800 (PST)
Date: Wed, 29 Nov 2023 10:01:43 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Message-ID: <etuukjyedcdvkdxsql5qquvla6tuaaayph7vj2jdskqjwmkmoy@h2hkgjfyawyi>
References: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
 <20231122180510.2297075-3-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231122180510.2297075-3-avkrasnov@salutedevices.com>

On Wed, Nov 22, 2023 at 09:05:09PM +0300, Arseniy Krasnov wrote:
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
>
> drivers/vhost/vsock.c                   |  2 ++
> include/linux/virtio_vsock.h            |  1 +
> net/vmw_vsock/virtio_transport.c        |  2 ++
> net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |  2 ++
> 5 files changed, 35 insertions(+)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index f75731396b7e..ecfa5c11f5ee 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+
>+		.set_rcvlowat             = virtio_transport_set_rcvlowat

Since now we don't set it anymore in the callback, what about following
the notify_* callbacks and rename it in `notify_set_rcvlowat`?

Eventually I think we can rename it in the previous patch.

> 	},
>
> 	.send_pkt = vhost_transport_send_pkt,
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index ebb3ce63d64d..97dc1bebc69c 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
> int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>+int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val);
> #endif /* _LINUX_VIRTIO_VSOCK_H */
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index af5bab1acee1..cf3431189d0c 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -539,6 +539,8 @@ static struct virtio_transport virtio_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+
>+		.set_rcvlowat             = virtio_transport_set_rcvlowat
> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index f6dc896bf44c..4acee21b4350 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1684,6 +1684,34 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
> }
> EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>
>+int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	bool send_update;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+
>+	/* If number of available bytes is less than new
>+	 * SO_RCVLOWAT value, kick sender to send more
>+	 * data, because sender may sleep in its 'send()'
>+	 * syscall waiting for enough space at our side.
>+	 */

Let's try to use at least the full 80 characters so we can reduce the
lines in this comment block.

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
>+EXPORT_SYMBOL_GPL(virtio_transport_set_rcvlowat);
>+
> MODULE_LICENSE("GPL v2");
> MODULE_AUTHOR("Asias He");
> MODULE_DESCRIPTION("common code for virtio vsock");
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 048640167411..388c157f6633 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+
>+		.set_rcvlowat             = virtio_transport_set_rcvlowat
> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
>-- 
>2.25.1
>


