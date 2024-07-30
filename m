Return-Path: <kvm+bounces-22695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C039420DA
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9405B2556A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD1918DF7A;
	Tue, 30 Jul 2024 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qktH8i96"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F9718C905;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368604; cv=none; b=N+6T2cv2Bx5tN0Nu8FFp37f8M9iRRk64bRzD7Tb5rENb9h90WAuvk8/PL/n0v42uPpIFGvkHCdvfn+jHvVzMl0Gs618iyNqMGXLPpkdxaM5EEwywlmea4+3lkE5IQ4Nz1CV0W9dt6LjSfUWsLB4OR0RchdTnMfcB9yWrkMnQqNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368604; c=relaxed/simple;
	bh=6lCPGgT/MjQ71CyNAkh9/mHfe5+s94LaNyBMunL30ug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YxNirjLH07JU16luBQMLbc61E0Bhb5rER+3tq6EimCZ7mXBhkWpsXqOS0dEm4e+BIh1I3HAUWsCIzv3y3pgHvX0IKuefdtglbss8NX+p8QiJ8jFlGBb6lWnprQFNxe6gMJ2ik5/d7aEHGka78vREij9qKaLAAj9kTIqVHeMhNWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qktH8i96; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B3A6C4AF0A;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368604;
	bh=6lCPGgT/MjQ71CyNAkh9/mHfe5+s94LaNyBMunL30ug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qktH8i96nf7OMM662osvtEDoFegl2szUZkLc+7RnC58qxhGLYwK6Jvg+sZVfSOCNh
	 8VK0Vv7NSg1uZ/GOmqsajCXr4kapxf3qfGErTQ+35WlnCPPiJ2xmXbKdT+f4VFUK+1
	 bJJb6FaPCLe5OgtaygM6yiWrfCLXLBAkd5xfCKl2LlPAgQQKg/8+Ral+RWiSQazCVG
	 ArHj+bpwpvMN+GAX16w1qz4tmDlVz3jsafLlhvhebaEqDmPNjP0LatAXPud1ZRWiFx
	 W19EXFgXaYW8npjE+VimCA0jNoO8UjK1TWOC+t9Sur4avxa4BL7kSvz1QLh2CuiNYE
	 3hMzoYMl/46RQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD37C3DA49;
	Tue, 30 Jul 2024 19:43:23 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Tue, 30 Jul 2024 21:43:07 +0200
Subject: [PATCH net-next v4 2/3] vsock/virtio: add SIOCOUTQ support for all
 virtio based transports
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-ioctl-v4-2-16d89286a8f0@outlook.com>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
In-Reply-To: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
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
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368602; l=6312;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=WM5tJQ1sMl6dPQu1pIvYS3xrLkM7dMksggWh3AWnClI=;
 b=7Ojx1gE9NnSDikaMVsaz93NrWsStuAfd1/SUnR9xgkS9GPgrokXgxWZA5dlwMmbmIKIiiTfc6
 4Y/HE6BjCg+D6gmA8jb40qnVhOKCl2P6XlxA0TJ7xLhdyQgHlI05eWS
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

Introduce support for virtio_transport_unsent_bytes
ioctl for virtio_transport, vhost_vsock and vsock_loopback.

For all transports the unsent bytes counter is incremented
in virtio_transport_get_credit.

In virtio_transport (G2H) and in vhost-vsock (H2G) the counter
is decremented when the skbuff is consumed. In vsock_loopback the
same skbuff is passed from the transmitter to the receiver, so
the counter is decremented before queuing the skbuff to the
receiver.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 drivers/vhost/vsock.c                   |  4 +++-
 include/linux/virtio_vsock.h            |  6 ++++++
 net/vmw_vsock/virtio_transport.c        |  4 +++-
 net/vmw_vsock/virtio_transport_common.c | 35 +++++++++++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  6 ++++++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index bf664ec9341b..802153e23073 100644
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
 
+		.unsent_bytes             = virtio_transport_unsent_bytes,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..0387d64e2c66 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -133,6 +133,7 @@ struct virtio_vsock_sock {
 	u32 tx_cnt;
 	u32 peer_fwd_cnt;
 	u32 peer_buf_alloc;
+	size_t bytes_unsent;
 
 	/* Protected by rx_lock */
 	u32 fwd_cnt;
@@ -193,6 +194,11 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
+ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
+
+void virtio_transport_consume_skb_sent(struct sk_buff *skb,
+				       bool consume);
+
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
 int
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 64a07acfef12..e0160da4ef43 100644
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
 
+		.unsent_bytes             = virtio_transport_unsent_bytes,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 16ff976a86e3..884ee128851e 100644
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
 
+ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
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
+EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
+
 static int virtio_transport_reset(struct vsock_sock *vsk,
 				  struct sk_buff *skb)
 {
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6dea6119f5b2..6e78927a598e 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
+		.unsent_bytes             = virtio_transport_unsent_bytes,
+
 		.read_skb = virtio_transport_read_skb,
 	},
 
@@ -123,6 +125,10 @@ static void vsock_loopback_work(struct work_struct *work)
 	spin_unlock_bh(&vsock->pkt_queue.lock);
 
 	while ((skb = __skb_dequeue(&pkts))) {
+		/* Decrement the bytes_unsent counter without deallocating skb
+		 * It is freed by the receiver.
+		 */
+		virtio_transport_consume_skb_sent(skb, false);
 		virtio_transport_deliver_tap_pkt(skb);
 		virtio_transport_recv_pkt(&loopback_transport, skb);
 	}

-- 
2.45.2



