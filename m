Return-Path: <kvm+bounces-2322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC237F4F0A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 922411C20AE0
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 18:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C894F615;
	Wed, 22 Nov 2023 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="JQ8JXRmA"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACBDB2;
	Wed, 22 Nov 2023 10:13:10 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 5F426100068;
	Wed, 22 Nov 2023 21:13:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 5F426100068
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700676786;
	bh=f3XkhHvZLw/2CD7IbNgZejqY3mMFhJAM3QeRUGk4nxs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=JQ8JXRmAX4D46TigD/mxC5oqm14QDseNAFSb2xyPM/bus60991vjju8BU+9rQ8tKI
	 9S6x/j0UET1EFpfsq31A6RXA5tY0MNPD9LbbcB8/ZGO3EUOqI4pJJPvawpQhkWLHyp
	 ToBHt76ejglY8ZvVGfthX+swdxndLbD72nHhTXqba85sZxQH7NUWnJUZvWCC8RaOgQ
	 H63n+NPw1og26JdjCos5iy+3ZoXLUxIAZZPopyh3/qNyG6+gQ8XuaKD2Q6RncyaCBr
	 3pm8xWspk+3AIh2ErZ+bhZjUVbKV9sRHXJjSdpLfo7bdFrP/S2RuBJ/57HD++ar06v
	 kv4Qt/wZFFU4g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 22 Nov 2023 21:13:06 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 22 Nov 2023 21:13:05 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v3 2/3] virtio/vsock: send credit update during setting SO_RCVLOWAT
Date: Wed, 22 Nov 2023 21:05:09 +0300
Message-ID: <20231122180510.2297075-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
References: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181545 [Nov 22 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 3 0.3.3 e5c6a18a9a9bff0226d530c5b790210c0bd117c8, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/22 11:24:00 #22501433
X-KSMG-AntiVirus-Status: Clean, skipped

Send credit update message when SO_RCVLOWAT is updated and it is bigger
than number of bytes in rx queue. It is needed, because 'poll()' will
wait until number of bytes in rx queue will be not smaller than
SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
for tx/rx is possible: sender waits for free space and receiver is
waiting data in 'poll()'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v1 -> v2:
  * Update commit message by removing 'This patch adds XXX' manner.
  * Do not initialize 'send_update' variable - set it directly during
    first usage.

 drivers/vhost/vsock.c                   |  2 ++
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport.c        |  2 ++
 net/vmw_vsock/virtio_transport_common.c | 28 +++++++++++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  2 ++
 5 files changed, 35 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f75731396b7e..ecfa5c11f5ee 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.set_rcvlowat             = virtio_transport_set_rcvlowat
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index ebb3ce63d64d..97dc1bebc69c 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
 int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
+int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index af5bab1acee1..cf3431189d0c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -539,6 +539,8 @@ static struct virtio_transport virtio_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.set_rcvlowat             = virtio_transport_set_rcvlowat
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f6dc896bf44c..4acee21b4350 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1684,6 +1684,34 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 }
 EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
 
+int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	bool send_update;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	/* If number of available bytes is less than new
+	 * SO_RCVLOWAT value, kick sender to send more
+	 * data, because sender may sleep in its 'send()'
+	 * syscall waiting for enough space at our side.
+	 */
+	send_update = vvs->rx_bytes < val;
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (send_update) {
+		int err;
+
+		err = virtio_transport_send_credit_update(vsk);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_set_rcvlowat);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Asias He");
 MODULE_DESCRIPTION("common code for virtio vsock");
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 048640167411..388c157f6633 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.set_rcvlowat             = virtio_transport_set_rcvlowat
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,
-- 
2.25.1


