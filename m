Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6A734518
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 08:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjFRGaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFRGaM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 02:30:12 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6059B1710;
        Sat, 17 Jun 2023 23:30:06 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 7FA155FD25;
        Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687069802;
        bh=9KIwX5m0AsbY8eFETkFbK8y/WZQO82su8tgmIiM0rvk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=oe5y8pf7qlvBMoNHAU3fzfQu1oOY315uLH+FTCBI1GZndpJn2SgvhR5uFxYqtsqFp
         4OwWflv5kft8X4teM5xw8iUKlAOpm6SB2uUh2YF/G5/1a+1KiuI/ELi3Zz0nDnbyxi
         gnAmRZFV0JVVQb++XqBN/SePB4Yc2vDROIfRNKGHdb23Gf811ltG6TQSwu9soiIZgq
         ep7xvBWO9dhoF/CMfD1/oS9QKDQ4qR9MqxoOAxcBKOFaOihy+/iOPFNQ6TtxVDRhJC
         rxX1PjY7wgmgnb5w3UCibzbYHDPBx2UJXF0tjm/zr3WMuN+MNdLSuCeUDEWlVU+Wl+
         4CShUG/hIdP/A==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 2/4] virtio/vsock: support MSG_PEEK for SOCK_SEQPACKET
Date:   Sun, 18 Jun 2023 09:24:49 +0300
Message-ID: <20230618062451.79980-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/18 01:53:00 #21507494
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds support of MSG_PEEK flag for SOCK_SEQPACKET type of socket.
Difference with SOCK_STREAM is that this callback returns either length
of the message or error.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 2ee40574c339..352d042b130b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -460,6 +460,63 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static ssize_t
+virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
+				   struct msghdr *msg)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct sk_buff *skb;
+	size_t total, len;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	if (!vvs->msg_count) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return 0;
+	}
+
+	total = 0;
+	len = msg_data_left(msg);
+
+	skb_queue_walk(&vvs->rx_queue, skb) {
+		struct virtio_vsock_hdr *hdr;
+
+		if (total < len) {
+			size_t bytes;
+			int err;
+
+			bytes = len - total;
+			if (bytes > skb->len)
+				bytes = skb->len;
+
+			spin_unlock_bh(&vvs->rx_lock);
+
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			err = memcpy_to_msg(msg, skb->data, bytes);
+			if (err)
+				return err;
+
+			spin_lock_bh(&vvs->rx_lock);
+		}
+
+		total += skb->len;
+		hdr = virtio_vsock_hdr(skb);
+
+		if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
+			if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
+				msg->msg_flags |= MSG_EOR;
+
+			break;
+		}
+	}
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	return total;
+}
+
 static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 struct msghdr *msg,
 						 int flags)
@@ -554,9 +611,9 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   int flags)
 {
 	if (flags & MSG_PEEK)
-		return -EOPNOTSUPP;
-
-	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
+		return virtio_transport_seqpacket_do_peek(vsk, msg);
+	else
+		return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
-- 
2.25.1

