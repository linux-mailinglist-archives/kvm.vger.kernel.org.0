Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4997758436
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 20:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjGRSIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 14:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjGRSI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 14:08:26 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7991733;
        Tue, 18 Jul 2023 11:08:22 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 6845612005D;
        Tue, 18 Jul 2023 21:08:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 6845612005D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1689703698;
        bh=tkRDIjgwoi7c8HuFjXoUTj2zb+RizwwV2GwfLVc5LoM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=Mmo1l+fK/0woxIqGezL0OflmOtkdmUafpFBEg3/9bvYgCR7Fp4ZhhkFtIUyv+/pRe
         mvuvuj26b29QPvvpXlg7xa27Yw6OdcS1L8MzFCLqNWKBCWuGSTdnviaWl7XSSoi/0g
         0bT1hAUvJ7F6hWyPb80Cj4g608o+tmuIBrUeSe3kRHulnQIj6tkehQKtiBenhQFVmh
         qQHhC3Tf/C/rRfDWhLh77fruHotLzGYCMAFIkoTPZz+lVn1f4hMav0Rer+a3emR4Of
         Q5uY2BqL76CPyb9Ro3zL2wBFlR6xUQmdnnAT2mCk+nUMuP32qNhx6nS4iYYVzefZvg
         AIgucssW0R1Yg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 18 Jul 2023 21:08:18 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 18 Jul 2023 21:08:17 +0300
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
Subject: [PATCH net-next v2 2/4] vsock/virtio: support to send non-linear skb
Date:   Tue, 18 Jul 2023 21:02:35 +0300
Message-ID: <20230718180237.3248179-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230718180237.3248179-1-AVKrasnov@sberdevices.ru>
References: <20230718180237.3248179-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178700 [Jul 18 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 524 524 9753033d6953787301affc41bead8ed49c47b39d, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/18 13:44:00 #21634370
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

For non-linear skb use its pages from fragment array as buffers in
virtio tx queue. These pages are already pinned by 'get_user_pages()'
during such skb creation.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 40 +++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..6cbb45bb12d2 100644
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
@@ -111,12 +113,38 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
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
+				void *va = page_to_virt(skb_frag->bv_page);
 
-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
-		sgs[out_sg++] = &hdr;
-		if (skb->len > 0) {
-			sg_init_one(&buf, skb->data, skb->len);
-			sgs[out_sg++] = &buf;
+				/* We will use 'page_to_virt()' for userspace page here,
+				 * because virtio layer will call 'virt_to_phys()' later
+				 * to fill buffer descriptor. We don't touch memory at
+				 * "virtual" address of this page.
+				 */
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

