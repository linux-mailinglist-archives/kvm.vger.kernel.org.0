Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF972744753
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjGAGwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjGAGvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:51:32 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380FB55AF;
        Fri, 30 Jun 2023 23:45:23 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id C69D8120008;
        Sat,  1 Jul 2023 09:45:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru C69D8120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688193906;
        bh=DaiKPxzYsqdAcaKBay/Cxep1Ax7Uwh6y3azpG4f7wPI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=fNZX92UyA9gQ91/wo2qOd1NWbAVFfl+7mtbsywqMyyBRPIn9bexJ4aHrQmv+Dx6CS
         UqMT/IPiSv5BHMTuPbLLiMl4s3VI+xvnUG0e8DHKMi+knZYiESuILEj6VpARhGpqzH
         3U8JLRr1E0oXAdfxDsQHVUEMIT7oBpA+hQzRaxEMpudxBt5TEKlwrvfT5DfO1uEQkV
         zjmp7jZn9FcrUEYVBbZNobtf/vTDHTpbh9MMGIHE9f4N/GlNHg8utHwXU4BH7lXac7
         UjQrdD0wgY+CsjYVOnqsWCJjbdQd+WztyTIORKsPueB+6IgsJr5s/y0tJmRAFOlaN4
         24aHxVzzVbHbQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:45:05 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:44:45 +0300
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
Subject: [RFC PATCH v5 04/17] vsock/virtio: non-linear skb handling for tap
Date:   Sat, 1 Jul 2023 09:39:34 +0300
Message-ID: <20230701063947.3422088-5-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178380 [Jun 30 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 517 517 b0056c19d8e10afbb16cb7aad7258dedb0179a79, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/01 04:02:00 #21597763
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For tap device new skb is created and data from the current skb is
copied to it. This adds copying data from non-linear skb to new
the skb.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Changelog:
 v4 -> v5:
  * Make 'skb' pointer constant because it is source.

 net/vmw_vsock/virtio_transport_common.c | 31 ++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e5683af23e60..dfc48b56d0a2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -106,6 +106,27 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	return NULL;
 }
 
+static void virtio_transport_copy_nonlinear_skb(const struct sk_buff *skb,
+						void *dst,
+						size_t len)
+{
+	struct iov_iter iov_iter = { 0 };
+	struct kvec kvec;
+	size_t to_copy;
+
+	kvec.iov_base = dst;
+	kvec.iov_len = len;
+
+	iov_iter.iter_type = ITER_KVEC;
+	iov_iter.kvec = &kvec;
+	iov_iter.nr_segs = 1;
+
+	to_copy = min_t(size_t, len, skb->len);
+
+	skb_copy_datagram_iter(skb, VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
+			       &iov_iter, to_copy);
+}
+
 /* Packet capture */
 static struct sk_buff *virtio_transport_build_skb(void *opaque)
 {
@@ -114,7 +135,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	struct af_vsockmon_hdr *hdr;
 	struct sk_buff *skb;
 	size_t payload_len;
-	void *payload_buf;
 
 	/* A packet could be split to fit the RX buffer, so we can retrieve
 	 * the payload length from the header and the buffer pointer taking
@@ -122,7 +142,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	 */
 	pkt_hdr = virtio_vsock_hdr(pkt);
 	payload_len = pkt->len;
-	payload_buf = pkt->data;
 
 	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,
 			GFP_ATOMIC);
@@ -165,7 +184,13 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 	skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));
 
 	if (payload_len) {
-		skb_put_data(skb, payload_buf, payload_len);
+		if (skb_is_nonlinear(pkt)) {
+			void *data = skb_put(skb, payload_len);
+
+			virtio_transport_copy_nonlinear_skb(pkt, data, payload_len);
+		} else {
+			skb_put_data(skb, pkt->data, payload_len);
+		}
 	}
 
 	return skb;
-- 
2.25.1

