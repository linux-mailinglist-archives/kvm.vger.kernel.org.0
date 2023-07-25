Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A62762040
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjGYRe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjGYRe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:34:58 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AEFB3;
        Tue, 25 Jul 2023 10:34:56 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id A6F7010002C;
        Tue, 25 Jul 2023 20:34:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A6F7010002C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690306494;
        bh=D+9LJvg8IRaM6Cj/ORO/vtYh6oNi9GwhBNnVFiHcxdo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=ZUmAebYa6XqgAoeb+8KrAN5vAUxkM1ma8GT22c2868C5/ur3SoGfwsXFl4YF3VF3q
         U/L1gNJnR+X83Rq6hwc93Vf66N/+C1J3L5y+OlOnbNSglbiLmRe6uQHEVi8EuofgYN
         yaIM34BFaaXkW9whq+HJJ0QxMuyX47aPxqNLoQIKR7+aE5RwKrLV8+UsUU67HiW7YV
         q11NhfafsZDfoptj01iG2GHRbbu0FV34X1CRkkK/vwJ/5zUHz6KrztVG1ELFdEfQrY
         jBSb6hiO6Qrh4vFDEqH4MOEq1Y5Ji0gEmN0tD3QF3CR5i2xMJh1rZPbg5Q9H1qSewt
         rYZKD3r+mmWyw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 25 Jul 2023 20:34:54 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 25 Jul 2023 20:34:51 +0300
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
Subject: [PATCH net-next v3 1/4] virtio/vsock: rework MSG_PEEK for SOCK_STREAM
Date:   Tue, 25 Jul 2023 20:29:09 +0300
Message-ID: <20230725172912.1659970-2-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;sberdevices.ru:5.0.1,7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
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

This reworks current implementation of MSG_PEEK logic:
1) Replaces 'skb_queue_walk_safe()' with 'skb_queue_walk()'. There is
   no need in the first one, as there are no removes of skb in loop.
2) Removes nested while loop - MSG_PEEK logic could be implemented
   without it: just iterate over skbs without removing it and copy
   data from each until destination buffer is not full.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 41 ++++++++++++-------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..2ee40574c339 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -348,37 +348,34 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 				size_t len)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	size_t bytes, total = 0, off;
-	struct sk_buff *skb, *tmp;
-	int err = -EFAULT;
+	struct sk_buff *skb;
+	size_t total = 0;
+	int err;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
-		off = 0;
+	skb_queue_walk(&vvs->rx_queue, skb) {
+		size_t bytes;
 
-		if (total == len)
-			break;
+		bytes = len - total;
+		if (bytes > skb->len)
+			bytes = skb->len;
 
-		while (total < len && off < skb->len) {
-			bytes = len - total;
-			if (bytes > skb->len - off)
-				bytes = skb->len - off;
+		spin_unlock_bh(&vvs->rx_lock);
 
-			/* sk_lock is held by caller so no one else can dequeue.
-			 * Unlock rx_lock since memcpy_to_msg() may sleep.
-			 */
-			spin_unlock_bh(&vvs->rx_lock);
+		/* sk_lock is held by caller so no one else can dequeue.
+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 */
+		err = memcpy_to_msg(msg, skb->data, bytes);
+		if (err)
+			goto out;
 
-			err = memcpy_to_msg(msg, skb->data + off, bytes);
-			if (err)
-				goto out;
+		total += bytes;
 
-			spin_lock_bh(&vvs->rx_lock);
+		spin_lock_bh(&vvs->rx_lock);
 
-			total += bytes;
-			off += bytes;
-		}
+		if (total == len)
+			break;
 	}
 
 	spin_unlock_bh(&vvs->rx_lock);
-- 
2.25.1

