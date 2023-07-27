Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3D5765F8C
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjG0WcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 18:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjG0WcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 18:32:17 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A932D7E;
        Thu, 27 Jul 2023 15:32:14 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8DADC120006;
        Fri, 28 Jul 2023 01:32:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8DADC120006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690497132;
        bh=q2L8Aprxr7L3JdhqehKzgX5TwglfdvsCDN/hciIXqRg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=ErewW2HFhBN8H0IaSaZJ6Oij7qHR1ZgFnFF21MT93X8vJwx5F8DHGvItZiwGR3KPi
         98eR9WHjHvuxtT2DgNbXv+vzIp96vCnBUl7ZKZ4G/j8uPoZoFUOpmiYxzo52NtXdMs
         Lpib8A6bR4NjTQS8unUeZhUelYtPDCwL+SnQISzgOO+lx1m/nuY8YP9a0M1DyEEXT+
         9SlFuj1ljuJAp8MHkTFLGLT0Y9uZv/3IZ0lQUfilB8xMNP6e7WK3I9h4z92Oky97jX
         6yIl3bvBn9cZxkD/BT6+8zcEayT01dHCfNpPthA8sdPVAHSWMSFfZjst02DfnzJsq9
         z9oW3cmd7+kBg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 28 Jul 2023 01:32:12 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 01:31:52 +0300
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
Subject: [PATCH net-next v4 2/4] vsock/virtio: support to send non-linear skb
Date:   Fri, 28 Jul 2023 01:26:25 +0300
Message-ID: <20230727222627.1895355-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
References: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
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
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For non-linear skb use its pages from fragment array as buffers in
virtio tx queue. These pages are already pinned by 'get_user_pages()'
during such skb creation.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 Changelog:
 v2 -> v3:
  * Comment about 'page_to_virt()' is updated. I don't remove R-b,
    as this change is quiet small I guess.

 net/vmw_vsock/virtio_transport.c | 41 +++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..7bbcc8093e51 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
-		struct scatterlist hdr, buf, *sgs[2];
+		/* +1 is for packet header. */
+		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
+		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
 		int ret, in_sg = 0, out_sg = 0;
 		struct sk_buff *skb;
 		bool reply;
@@ -111,12 +113,39 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
+		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
+			    sizeof(*virtio_vsock_hdr(skb)));
+		sgs[out_sg] = &bufs[out_sg];
+		out_sg++;
+
+		if (!skb_is_nonlinear(skb)) {
+			if (skb->len > 0) {
+				sg_init_one(&bufs[out_sg], skb->data, skb->len);
+				sgs[out_sg] = &bufs[out_sg];
+				out_sg++;
+			}
+		} else {
+			struct skb_shared_info *si;
+			int i;
+
+			si = skb_shinfo(skb);
+
+			for (i = 0; i < si->nr_frags; i++) {
+				skb_frag_t *skb_frag = &si->frags[i];
+				void *va;
 
-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
-		sgs[out_sg++] = &hdr;
-		if (skb->len > 0) {
-			sg_init_one(&buf, skb->data, skb->len);
-			sgs[out_sg++] = &buf;
+				/* We will use 'page_to_virt()' for the userspace page
+				 * here, because virtio or dma-mapping layers will call
+				 * 'virt_to_phys()' later to fill the buffer descriptor.
+				 * We don't touch memory at "virtual" address of this page.
+				 */
+				va = page_to_virt(skb_frag->bv_page);
+				sg_init_one(&bufs[out_sg],
+					    va + skb_frag->bv_offset,
+					    skb_frag->bv_len);
+				sgs[out_sg] = &bufs[out_sg];
+				out_sg++;
+			}
 		}
 
 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
-- 
2.25.1

