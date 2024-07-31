Return-Path: <kvm+bounces-22731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1839427A4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 09:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24A32B22C42
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 07:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8981A71FE;
	Wed, 31 Jul 2024 07:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="En9m1EoA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C51A4B46
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 07:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722410122; cv=none; b=r4U+AA+JiAAtaQ434+UB5yVIL0eyABO4WWY3/6moxUg2VJmytmgL3tPJjZmCabGpb80bYW4/lWjqjXYuyuKuOM/kayKmY8pcyBGh6CTVGIotW3lOapl7zUBFqKjHUbCTSAmK9m4KM0EAAn/6CTcFOxmdTY+F23gBftjMwlC4E6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722410122; c=relaxed/simple;
	bh=8oseWXYY1PGF5AOw1vfqrpeG+ikyCbdgrVmMBb0g03U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQFXyW3L32vYXDK05o1dmUmX5ccSrHaklbR9pwuGbGrYk+NzubmJ3ey2SuuCKK1eTTowdIi+t1HpC0tk/T7KhrJxAzo76gKmpgZ+v+ea/OOcLCnJ+/BHkbqd7bRTyjlmc4RRFR4T4WHvRCMbQiZX8DYAoSRECANtUohgwDpOF+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=En9m1EoA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722410119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCHxNOFdaKwXTtDSCAVXRL/vK07RzkYGpljriv1iQnE=;
	b=En9m1EoAodpm5pWCHZZQ9/3/hUrJwhiKL5SC8Eht1PBArcioXKBC4W1Q8f+75oTVVY5SMW
	UH/RgMSp1LfHmqogysPZyzbGP5kEgvI8QVhiqMVuLwoPGeGxc8KdGGm5X7fuzHcohfveOi
	I9gB262TR6rhqDOjDh5UWLGsKEp+UnE=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-Md_KeSZHMhGvOMwhMnsERw-1; Wed, 31 Jul 2024 03:15:17 -0400
X-MC-Unique: Md_KeSZHMhGvOMwhMnsERw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2ef2b0417cdso52011631fa.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 00:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722410116; x=1723014916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCHxNOFdaKwXTtDSCAVXRL/vK07RzkYGpljriv1iQnE=;
        b=OPXEEZub0WBpc7afahhWqT36o3wgD4k/mPJ9E7hWtO1GuHoT4wpb0P64WjGsLaB4YV
         26cbia/XhogLfBF4vxJvp/Mib05L835AjhBDRPC2xarYm2wIGZFU0czl6LyoVEKMast/
         w7o92Wum109RrusfD3N/1RPNuNw0d8vSqj2EwoQrtCTe8quE8Q+UnqeNXUFso8JZuKvz
         ActlNcKlKt20YZb4bltkmsf2Z2L3fPnMDs3ESgpDXOVs0nPVPBzgwJEfvq7VMjw3mUeS
         rdn0k8vlok/Ky/yzZEx3l37qCjkzWam8Vmn8Egfqfz4JvvEVbED37IG6Da9qtQp88N5j
         Wyaw==
X-Forwarded-Encrypted: i=1; AJvYcCWM+zkHt2VI4Ltk7inoN4V0HtiL6BvEyxHspKrTd7WraBBjlbtcnqQMRQhhH80mRob/ZHkuM+sFkTYhNYPxVu6+vi2Y
X-Gm-Message-State: AOJu0YxKUYgY2btPmNfQtJrUiw7bg9ulTBN028R7GMq2EW4IsQ9lnfTe
	nrGuj6tB90dgvqdWvsU557ISHqcqxIr0TUIDtEAmYwuu3xI2ofXjD8QlfyXy+QbgCm5pP13E0wv
	EbJA/TgvCdZxjNch6s7wIwTB5M4Zsib86a4dHBycdshv1t0BGOA==
X-Received: by 2002:a2e:be86:0:b0:2ee:84af:dfc4 with SMTP id 38308e7fff4ca-2f12ee2eedemr101453991fa.43.1722410115982;
        Wed, 31 Jul 2024 00:15:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEsBUkMwRKeXTctJ1Rx00ufB9nE6PMBC7H1gIa98K97WCJq154sBgrYw4JnAr7eVOkTGPHQg==
X-Received: by 2002:a2e:be86:0:b0:2ee:84af:dfc4 with SMTP id 38308e7fff4ca-2f12ee2eedemr101453381fa.43.1722410115023;
        Wed, 31 Jul 2024 00:15:15 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-79.retail.telecomitalia.it. [82.57.51.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282babaa2esm10231995e9.25.2024.07.31.00.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jul 2024 00:15:14 -0700 (PDT)
Date: Wed, 31 Jul 2024 09:15:12 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: luigi.leonardi@outlook.com
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] vsock/virtio: add SIOCOUTQ support for
 all virtio based transports
Message-ID: <vfgguhcj45a3k5k6jcbjzgwfoiecryvvxploswnvjmehcctqeu@rbw2ac4jk5ik>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
 <20240730-ioctl-v4-2-16d89286a8f0@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240730-ioctl-v4-2-16d89286a8f0@outlook.com>

On Tue, Jul 30, 2024 at 09:43:07PM GMT, Luigi Leonardi via B4 Relay wrote:
>From: Luigi Leonardi <luigi.leonardi@outlook.com>
>
>Introduce support for virtio_transport_unsent_bytes
>ioctl for virtio_transport, vhost_vsock and vsock_loopback.
>
>For all transports the unsent bytes counter is incremented
>in virtio_transport_get_credit.
>
>In virtio_transport (G2H) and in vhost-vsock (H2G) the counter
>is decremented when the skbuff is consumed. In vsock_loopback the
>same skbuff is passed from the transmitter to the receiver, so
>the counter is decremented before queuing the skbuff to the
>receiver.
>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> drivers/vhost/vsock.c                   |  4 +++-
> include/linux/virtio_vsock.h            |  6 ++++++
> net/vmw_vsock/virtio_transport.c        |  4 +++-
> net/vmw_vsock/virtio_transport_common.c | 35 +++++++++++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |  6 ++++++
> 5 files changed, 53 insertions(+), 2 deletions(-)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index bf664ec9341b..802153e23073 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -244,7 +244,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 					restart_tx = true;
> 			}
>
>-			consume_skb(skb);
>+			virtio_transport_consume_skb_sent(skb, true);
> 		}
> 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> 	if (added)
>@@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>+		.unsent_bytes             = virtio_transport_unsent_bytes,
>+
> 		.read_skb = virtio_transport_read_skb,
> 	},
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index c82089dee0c8..0387d64e2c66 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -133,6 +133,7 @@ struct virtio_vsock_sock {
> 	u32 tx_cnt;
> 	u32 peer_fwd_cnt;
> 	u32 peer_buf_alloc;
>+	size_t bytes_unsent;
>
> 	/* Protected by rx_lock */
> 	u32 fwd_cnt;
>@@ -193,6 +194,11 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
> s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
> u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
>
>+ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
>+
>+void virtio_transport_consume_skb_sent(struct sk_buff *skb,
>+				       bool consume);
>+
> int virtio_transport_do_socket_init(struct vsock_sock *vsk,
> 				 struct vsock_sock *psk);
> int
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 64a07acfef12..e0160da4ef43 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -311,7 +311,7 @@ static void virtio_transport_tx_work(struct work_struct *work)
>
> 		virtqueue_disable_cb(vq);
> 		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
>-			consume_skb(skb);
>+			virtio_transport_consume_skb_sent(skb, true);
> 			added = true;
> 		}
> 	} while (!virtqueue_enable_cb(vq));
>@@ -540,6 +540,8 @@ static struct virtio_transport virtio_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>+		.unsent_bytes             = virtio_transport_unsent_bytes,
>+
> 		.read_skb = virtio_transport_read_skb,
> 	},
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 16ff976a86e3..884ee128851e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -463,6 +463,26 @@ void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *
> }
> EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
>
>+void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
>+{
>+	struct sock *s = skb->sk;
>+
>+	if (s && skb->len) {
>+		struct vsock_sock *vs = vsock_sk(s);
>+		struct virtio_vsock_sock *vvs;
>+
>+		vvs = vs->trans;
>+
>+		spin_lock_bh(&vvs->tx_lock);
>+		vvs->bytes_unsent -= skb->len;
>+		spin_unlock_bh(&vvs->tx_lock);
>+	}
>+
>+	if (consume)
>+		consume_skb(skb);
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>+
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>@@ -475,6 +495,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> 	if (ret > credit)
> 		ret = credit;
> 	vvs->tx_cnt += ret;
>+	vvs->bytes_unsent += ret;
> 	spin_unlock_bh(&vvs->tx_lock);
>
> 	return ret;
>@@ -488,6 +509,7 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
>
> 	spin_lock_bh(&vvs->tx_lock);
> 	vvs->tx_cnt -= credit;
>+	vvs->bytes_unsent -= credit;
> 	spin_unlock_bh(&vvs->tx_lock);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
>@@ -1090,6 +1112,19 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_destruct);
>
>+ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	size_t ret;
>+
>+	spin_lock_bh(&vvs->tx_lock);
>+	ret = vvs->bytes_unsent;
>+	spin_unlock_bh(&vvs->tx_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
>+
> static int virtio_transport_reset(struct vsock_sock *vsk,
> 				  struct sk_buff *skb)
> {
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 6dea6119f5b2..6e78927a598e 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
>+		.unsent_bytes             = virtio_transport_unsent_bytes,
>+
> 		.read_skb = virtio_transport_read_skb,
> 	},
>
>@@ -123,6 +125,10 @@ static void vsock_loopback_work(struct work_struct *work)
> 	spin_unlock_bh(&vsock->pkt_queue.lock);
>
> 	while ((skb = __skb_dequeue(&pkts))) {
>+		/* Decrement the bytes_unsent counter without deallocating skb
>+		 * It is freed by the receiver.
>+		 */
>+		virtio_transport_consume_skb_sent(skb, false);
> 		virtio_transport_deliver_tap_pkt(skb);
> 		virtio_transport_recv_pkt(&loopback_transport, skb);
> 	}
>
>-- 
>2.45.2
>
>


