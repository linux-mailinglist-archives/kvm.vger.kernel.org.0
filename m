Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62EF79BEF6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbjIKUsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244424AbjIKU3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 16:29:40 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244EA1A7;
        Mon, 11 Sep 2023 13:29:35 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id B6CBC100015;
        Mon, 11 Sep 2023 23:29:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B6CBC100015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694464173;
        bh=ydabQREpbRq8IHz33yeNk7fQnK9tCpQlj2QjNTuHLPs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=qhMs5BL3nGBS51iuupK7j/zZBhqBVPfJ8SaHWpaoH8nDSHd/lVkxh/+uYeZipSX/6
         KtS6L6ZVwmXeaVAW7bB8rBDFVwCQ6lcS3grJfIiAl7lcbNbO7jYa0TA1O8Pt1V/uAm
         q8HrL34VVWrb6rpRFH/LeZYZB1cRB2GclUBOzT2zwnF5FcVWNv2v2G2Dp170VEztH6
         Ms4lEfRsNEYbglTYdG5AmOi3K3Je309LfDMiu1m6pXRgOMy062nDoWFhK2jt/R25hC
         e1lMvqbEGZQKxYQaLGmn3aUrvdd/eWsgx3nI1YYb6XJw7YCIFvNq8vxBCdcd7812lG
         j1cz4G77YVtjA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 11 Sep 2023 23:29:33 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 11 Sep 2023 23:29:33 +0300
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
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
        <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v8 2/4] vsock/virtio: support to send non-linear skb
Date:   Mon, 11 Sep 2023 23:22:32 +0300
Message-ID: <20230911202234.1932024-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179791 [Sep 11 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/11 15:53:00 #21884588
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For non-linear skb use its pages from fragment array as buffers in
virtio tx queue. These pages are already pinned by 'get_user_pages()'
during such skb creation.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v2 -> v3:
  * Comment about 'page_to_virt()' is updated. I don't remove R-b,
    as this change is quiet small I guess.
 v6 -> v7:
  * Move arrays '*sgs' and 'bufs' to 'virtio_vsock' instead of being
    local variables. This allows to save stack space in cases of too
    big MAX_SKB_FRAGS.
  * Add 'WARN_ON_ONCE()' for handling nonlinear skbs - it checks that
    linear part of such skb contains only header.
  * R-b tag removed due to updates above.
 v7 -> v8:
  * Add comment in 'struct virtio_vsock' for both 'struct scatterlist'
    fields.
  * Rename '*sgs' and 'bufs' to '*out_sgs' and 'out_bufs'.
  * Initialize '*out_sgs' in 'virtio_vsock_probe()' by always pointing
    to the corresponding element of 'out_bufs'.

 net/vmw_vsock/virtio_transport.c | 60 ++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..73d730156349 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -63,6 +63,17 @@ struct virtio_vsock {
 
 	u32 guest_cid;
 	bool seqpacket_allow;
+
+	/* These fields are used only in tx path in function
+	 * 'virtio_transport_send_pkt_work()', so to save
+	 * stack space in it, place both of them here. Each
+	 * pointer from 'out_sgs' points to the corresponding
+	 * element in 'out_bufs' - this is initialized in
+	 * 'virtio_vsock_probe()'. Both fields are protected
+	 * by 'tx_lock'. +1 is needed for packet header.
+	 */
+	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
+	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
 };
 
 static u32 virtio_transport_get_local_cid(void)
@@ -100,8 +111,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
-		struct scatterlist hdr, buf, *sgs[2];
 		int ret, in_sg = 0, out_sg = 0;
+		struct scatterlist **sgs;
 		struct sk_buff *skb;
 		bool reply;
 
@@ -111,12 +122,43 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 
 		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
-
-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
-		sgs[out_sg++] = &hdr;
-		if (skb->len > 0) {
-			sg_init_one(&buf, skb->data, skb->len);
-			sgs[out_sg++] = &buf;
+		sgs = vsock->out_sgs;
+		sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
+			    sizeof(*virtio_vsock_hdr(skb)));
+		out_sg++;
+
+		if (!skb_is_nonlinear(skb)) {
+			if (skb->len > 0) {
+				sg_init_one(sgs[out_sg], skb->data, skb->len);
+				out_sg++;
+			}
+		} else {
+			struct skb_shared_info *si;
+			int i;
+
+			/* If skb is nonlinear, then its buffer must contain
+			 * only header and nothing more. Data is stored in
+			 * the fragged part.
+			 */
+			WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
+
+			si = skb_shinfo(skb);
+
+			for (i = 0; i < si->nr_frags; i++) {
+				skb_frag_t *skb_frag = &si->frags[i];
+				void *va;
+
+				/* We will use 'page_to_virt()' for the userspace page
+				 * here, because virtio or dma-mapping layers will call
+				 * 'virt_to_phys()' later to fill the buffer descriptor.
+				 * We don't touch memory at "virtual" address of this page.
+				 */
+				va = page_to_virt(skb_frag->bv_page);
+				sg_init_one(sgs[out_sg],
+					    va + skb_frag->bv_offset,
+					    skb_frag->bv_len);
+				out_sg++;
+			}
 		}
 
 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
@@ -621,6 +663,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 {
 	struct virtio_vsock *vsock = NULL;
 	int ret;
+	int i;
 
 	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
 	if (ret)
@@ -663,6 +706,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (ret < 0)
 		goto out;
 
+	for (i = 0; i < ARRAY_SIZE(vsock->out_sgs); i++)
+		vsock->out_sgs[i] = &vsock->out_bufs[i];
+
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.25.1

