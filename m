Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC911762043
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjGYRfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjGYRe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:34:58 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D3D193;
        Tue, 25 Jul 2023 10:34:56 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 5B14412002E;
        Tue, 25 Jul 2023 20:34:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 5B14412002E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690306495;
        bh=hkPVZZW7FY29VzrDqyCApfvhv3kL+ZGFwXryqGExqv8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=Re9/ZO1DwCfTipC74HkGlGhlVzGdfjrre2WDK5Bc9vX1kgBjUouyee7HDajbOYCBN
         YPcy7xpaDbujgQODiC/G0qGlMaSX/ioQ4JH7mA9oZRivLCgC6I091ty8QwoGrOhpqS
         cUTh1+x2uI/apM4cuwISKgJ7LlQoGI4eLgjF6LVD3oajTcCzL3CNDqbLJhpkQQ4Q91
         2pFoHX+JRR7iTd41kQycE+5FvWk325Cxr5bNggioiF8LtF72i7UnZK5C0uat/0YEzU
         EfMdUxFmdjdrKy0N43XG4qf5ajvxVxrJehL0W/bYd099Hkqcazejdv9s6ObxhTlojZ
         6fJSomb9KJ7oA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 25 Jul 2023 20:34:55 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 25 Jul 2023 20:34:52 +0300
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
Subject: [PATCH net-next v3 2/4] virtio/vsock: support MSG_PEEK for SOCK_SEQPACKET
Date:   Tue, 25 Jul 2023 20:29:10 +0300
Message-ID: <20230725172912.1659970-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230725172912.1659970-1-AVKrasnov@sberdevices.ru>
References: <20230725172912.1659970-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds support of MSG_PEEK flag for SOCK_SEQPACKET type of socket.
Difference with SOCK_STREAM is that this callback returns either length
of the message or error.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

