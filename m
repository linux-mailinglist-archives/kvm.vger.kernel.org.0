Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABFD744727
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjGAGjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjGAGjW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:39:22 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFBA4236;
        Fri, 30 Jun 2023 23:39:13 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 0471F12000F;
        Sat,  1 Jul 2023 09:28:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0471F12000F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688192926;
        bh=dXr+GIu8Zm+IAJzZ6mwmY2cDmvd5mo+b/fOvW2U8kdk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=QZrmFC4PlO3klITr+HkONqkpFls4BdprnTeeTQTqOtzY1jdkG1gkcCealFq6Or26O
         cq5Sqv/oe02NjDDJvpERpE8gXUWUlHSy5CkgLkeEhbqsCPGF5Hdn5vB9IXmHWcSJiq
         fYEHxrDxcaNlslan/4xH3DsCwOQtYsLLLqpE7Q1tymrdtuOY5mJbppN0AF3wZI5uda
         SUYo6QVINahM8F8t+O7TpP4rl0hpYxKBbzUxALHBOQnnDXllhCqqMZInb0TDCCKkpP
         9KxE73F/TFZkgm7Et72x0Np2D8ADKlNW4sp1kt4tAXh5sW3n4f6MgUaByYoEhAIIK3
         8jZo4ZUH2Iveg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:28:44 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:28:21 +0300
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
Subject: [RFC PATCH v5 08/17] vsock: check for MSG_ZEROCOPY support on send
Date:   Sat, 1 Jul 2023 09:23:01 +0300
Message-ID: <20230701062310.3397129-9-AVKrasnov@sberdevices.ru>
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

This feature totally depends on transport, so if transport doesn't
support it, return error.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/net/af_vsock.h   | 7 +++++++
 net/vmw_vsock/af_vsock.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0e7504a42925..ec09edc5f3a0 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -177,6 +177,9 @@ struct vsock_transport {
 
 	/* Read a single skb */
 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
+
+	/* Zero-copy. */
+	bool (*msgzerocopy_allow)(void);
 };
 
 /**** CORE ****/
@@ -243,4 +246,8 @@ static inline void __init vsock_bpf_build_proto(void)
 {}
 #endif
 
+static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
+{
+	return t->msgzerocopy_allow && t->msgzerocopy_allow();
+}
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 07803d9fbf6d..033006e1b5ad 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1824,6 +1824,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
+	if (msg->msg_flags & MSG_ZEROCOPY &&
+	    !vsock_msgzerocopy_allow(transport)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* Wait for room in the produce queue to enqueue our user's data. */
 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
-- 
2.25.1

