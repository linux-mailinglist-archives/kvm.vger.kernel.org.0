Return-Path: <kvm+bounces-20549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A4591809F
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EF2DB25A04
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2F6183073;
	Wed, 26 Jun 2024 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orJD1PPt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFD2180A83;
	Wed, 26 Jun 2024 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719403719; cv=none; b=XNuTRWW+YEJqGZs/8CVBNzRRJ3zjmjubXhODYHtuGNqHIj379EZk/BLFJpOgmqYO2n42/v7uGvQVYBMHFnrwWLi+WA5eLhofGr5foMwN/OHAupR0DNgCI2zhD/zU2TIqG639Ptco3LkQhB60qgfoNEj4MptvS3HmDAVttwkKcl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719403719; c=relaxed/simple;
	bh=87xO/t3Pwhz0ct0Y0iGmuW6ljRW180gEkDhXDa6Qlis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pgzd7rVckQp7m3bU6Of6nLVuIk7E1Vi35QikwQH9bPVHFSKLZbC+Z+0StVbrtBoyw7ScnRLm+Wc4Q6x9qPh0LGECvaap/uQqYzdWxcpN+WI9X/U0RNtZzG3WFMbjVG8BPYPZ/nj4o+4EqnpQ8JAyceiVuO4kTgFT1bf9Ct+dn7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orJD1PPt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7081C4AF07;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719403718;
	bh=87xO/t3Pwhz0ct0Y0iGmuW6ljRW180gEkDhXDa6Qlis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=orJD1PPtkOdpcy1PQspPOWKVCdbPrmXaCVylIHDlFnx8T2nbBXEnjzeludEr0v2zI
	 5Epy0UqqfzaO0XkFALekfjW9j6qLIbDqi/C0CUxPxtAT5cIQvjCeeigA4zWA7WoEki
	 kfrfoUYR0EIjcn8k9n8PqkGQnpY6R1V/rs18EDVdZ+JfdwR7Eyq8PZL6KMSar59PX3
	 jEkCTPRc6GX6/GFFRPAF/ITT8iavhBZgSbndq/B8aDJSoBZsIsz90OG8PqYtYb8E5j
	 pFkgcgeHFWSXmOq+QiE7EjwLcEO9xBmXdRP9BUNbJnZiFOxoUQmA9eSIfy7TRdCRvt
	 TGaBPjezHiJ9Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12D3C3065A;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Wed, 26 Jun 2024 14:08:36 +0200
Subject: [PATCH net-next v3 2/3] vsock/virtio: add SIOCOUTQ support for all
 virtio based transports
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-ioctl_next-v3-2-63be5bf19a40@outlook.com>
References: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
In-Reply-To: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719403717; l=6371;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=sI4aKzv65G8Vd6esvUjfpOdcZxrW87hFO3L+yINHGpI=;
 b=MJgAWqdl5ujUmscMJMELnSlpGJy6V8fNgMjp8s4GaxTHDXY+3yYOEW3ILFijsBEwDC2rigKza
 DbwuczPf0d/BzEWuW0Wz6oONwx/49gtUR6QmaXWW7aeLBI2GvApKe0g
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

Introduce support for stream_bytes_unsent and seqpacket_bytes_unsent
ioctl for virtio_transport, vhost_vsock and vsock_loopback.

For all transports the unsent bytes counter is incremented
in virtio_transport_get_credit.

In the virtio_transport (G2H) the counter is decremented each
time the host notifies the guest that it consumed the skbuffs.
In vhost-vsock (H2G) the counter is decremented after the skbuff
is queued in the virtqueue.
In vsock_loopback the counter is decremented after the skbuff is
dequeued.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 drivers/vhost/vsock.c                   |  4 +++-
 include/linux/virtio_vsock.h            |  7 +++++++
 net/vmw_vsock/virtio_transport.c        |  4 +++-
 net/vmw_vsock/virtio_transport_common.c | 35 +++++++++++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  7 +++++++
 5 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..dba8b3ea37bf 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -244,7 +244,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 					restart_tx = true;
 			}
 
-			consume_skb(skb);
+			virtio_transport_consume_skb_sent(skb, true);
 		}
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 	if (added)
@@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..e74c12878213 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -134,6 +134,8 @@ struct virtio_vsock_sock {
 	u32 peer_fwd_cnt;
 	u32 peer_buf_alloc;
 
+	size_t bytes_unsent;
+
 	/* Protected by rx_lock */
 	u32 fwd_cnt;
 	u32 last_fwd_cnt;
@@ -193,6 +195,11 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
+size_t virtio_transport_bytes_unsent(struct vsock_sock *vsk);
+
+void virtio_transport_consume_skb_sent(struct sk_buff *skb,
+				       bool consume);
+
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
 int
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 43d405298857..fc62d2818c2c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -311,7 +311,7 @@ static void virtio_transport_tx_work(struct work_struct *work)
 
 		virtqueue_disable_cb(vq);
 		while ((skb = virtqueue_get_buf(vq, &len)) != NULL) {
-			consume_skb(skb);
+			virtio_transport_consume_skb_sent(skb, true);
 			added = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
@@ -540,6 +540,8 @@ static struct virtio_transport virtio_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..3a7fa36f306b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -463,6 +463,26 @@ void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct sk_buff *
 }
 EXPORT_SYMBOL_GPL(virtio_transport_inc_tx_pkt);
 
+void virtio_transport_consume_skb_sent(struct sk_buff *skb, bool consume)
+{
+	struct sock *s = skb->sk;
+
+	if (s && skb->len) {
+		struct vsock_sock *vs = vsock_sk(s);
+		struct virtio_vsock_sock *vvs;
+
+		vvs = vs->trans;
+
+		spin_lock_bh(&vvs->tx_lock);
+		vvs->bytes_unsent -= skb->len;
+		spin_unlock_bh(&vvs->tx_lock);
+	}
+
+	if (consume)
+		consume_skb(skb);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
+
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
 	u32 ret;
@@ -475,6 +495,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 	if (ret > credit)
 		ret = credit;
 	vvs->tx_cnt += ret;
+	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
 
 	return ret;
@@ -488,6 +509,7 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
 
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->tx_cnt -= credit;
+	vvs->bytes_unsent -= credit;
 	spin_unlock_bh(&vvs->tx_lock);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_put_credit);
@@ -1090,6 +1112,19 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_destruct);
 
+size_t virtio_transport_bytes_unsent(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	size_t ret;
+
+	spin_lock_bh(&vvs->tx_lock);
+	ret = vvs->bytes_unsent;
+	spin_unlock_bh(&vvs->tx_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_bytes_unsent);
+
 static int virtio_transport_reset(struct vsock_sock *vsk,
 				  struct sk_buff *skb)
 {
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6dea6119f5b2..9098613561e3 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_bytes_unsent,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
@@ -123,6 +125,11 @@ static void vsock_loopback_work(struct work_struct *work)
 	spin_unlock_bh(&vsock->pkt_queue.lock);
 
 	while ((skb = __skb_dequeue(&pkts))) {
+		/* Decrement the bytes_sent counter without deallocating skb
+		 * It is freed by the receiver.
+		 */
+		virtio_transport_consume_skb_sent(skb, false);
+
 		virtio_transport_deliver_tap_pkt(skb);
 		virtio_transport_recv_pkt(&loopback_transport, skb);
 	}

-- 
2.45.2



