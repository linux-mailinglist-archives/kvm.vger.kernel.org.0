Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE27B43B6
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 23:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbjI3VKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 17:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjI3VKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 17:10:34 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C2DA;
        Sat, 30 Sep 2023 14:10:31 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8555B100009;
        Sun,  1 Oct 2023 00:10:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8555B100009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696108228;
        bh=s97vVZ6AdQilCZkxxPA5FVFX3AoinEVoU+I3gTxfJbg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=uvHX8JX/v4heOGOFP3ahtkecx63S5sS4g1b3h1pboJXNbLUMYI7B/wjze/lzSHQhi
         y4BdXwg/izjqoyjY7TX3j/3GGxDsK4yS7xuJtBB5oTYlFxdT66Tq1fI8FEzAc+B6xo
         b2OGFpPwmI7Vl8ZNhVbR7CpX7/CDKSFdue0nLIa2BaSYR8Jsmg5q2pe7P6FnLzfUGa
         kVUBigVCXy0ifvyq/BK/LQD4f5q8F/qYawSJvWS2MQMl9XLuIQp765GPKi7dj/Fl2S
         7EPxBLNMWE3//Qpe8zxb4iQjKo6dWKSdxWGyxKNE0QhNivXXZSIqsLKUC7oqcJ+thM
         OjmOPli7AWEDQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sun,  1 Oct 2023 00:10:28 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sun, 1 Oct 2023 00:10:27 +0300
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
Subject: [PATCH net-next v2 03/12] vsock: check for MSG_ZEROCOPY support on send
Date:   Sun, 1 Oct 2023 00:02:59 +0300
Message-ID: <20230930210308.2394919-4-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180254 [Sep 30 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/30 19:49:00 #22015058
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This feature totally depends on transport, so if transport doesn't
support it, return error.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   | 7 +++++++
 net/vmw_vsock/af_vsock.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b01cf9ac2437..e302c0e804d0 100644
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
@@ -241,4 +244,8 @@ static inline void __init vsock_bpf_build_proto(void)
 {}
 #endif
 
+static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
+{
+	return t->msgzerocopy_allow && t->msgzerocopy_allow();
+}
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 0365382beab6..f1da06aa6b00 100644
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

