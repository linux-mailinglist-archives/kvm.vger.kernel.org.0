Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B7574473F
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjGAGks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjGAGjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:39:47 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EEE4239;
        Fri, 30 Jun 2023 23:39:34 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 4E81B120008;
        Sat,  1 Jul 2023 09:28:41 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 4E81B120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688192921;
        bh=DaiKPxzYsqdAcaKBay/Cxep1Ax7Uwh6y3azpG4f7wPI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=K8gArG2va7fDnIbHexfVRCq04H6pTCpLyy+yMGtzg6MwzUUBIn7ehWBNKp17FtA2w
         MpU2dGFmAhXqkWOt9ScsBdis1GoYH83ND/pqLQBiUDEMEf+qGSXdxPbrgYdSO5Xbc3
         Y17nRV5cy4gRELPFYLwPHxQ+8D5VqPRfiSDilpWxAUV21FbPzP1GFzUN+CgEKvpJi/
         b69wXFcqpn0X9NFGc4ERrb2LfxGpCSm9GLN24zL3ZRSjpC4NEcxP1bayWAO2A3vt4m
         cJBn3/0LCZz+rkxDSOXQjOcelXOz/IGUTJeu7O4SG5cydESrpeviLdzynzgP/EyScG
         QHHLcmJ5ybjhg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:28:40 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:28:19 +0300
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
Date:   Sat, 1 Jul 2023 09:22:57 +0300
Message-ID: <20230701062310.3397129-5-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230701062310.3397129-1-AVKrasnov@sberdevices.ru>
References: <20230701062310.3397129-1-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 517 517 b0056c19d8e10afbb16cb7aad7258dedb0179a79, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/01 00:58:00 #21597365
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

