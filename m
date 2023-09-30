Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996887B43D3
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 23:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbjI3VKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 17:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbjI3VKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 17:10:38 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A718F9;
        Sat, 30 Sep 2023 14:10:35 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 7BA7910000E;
        Sun,  1 Oct 2023 00:10:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 7BA7910000E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696108229;
        bh=n0+6JFJdHIxCPS2RMgfbz1r2mOTVd0SebyW4nxVs89s=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=WNKc6de527O6halcmg/j7JgwoDhaCWrJxv4FgnNPpOFsHOKiPbtJkeFkbplHHIY57
         BQv7yWFIFdS52Q3pLo42hSoOjLAoMQLRx0K1xLtJEXk8Ar3+DZCMheE43yOa9YzW1o
         zCB+aFEEDtmoniUh0T8TkxCMRX9aJTNYWfs0ghav9BxB4AjnED976LnLSZuHJlR0vS
         xUSlHtcvahDupGaT7LApbg0QnAcxn3uHFNgXvJse63K/Oow2fkjjYbevQmlpW+Qywh
         jGZbHTFqUERNOHc0xuv0dn6qkXJQYYmF5RkrCx1sjcAVc4B14tKdmOe+wGwJIge/6W
         sYOi658y3QubQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sun,  1 Oct 2023 00:10:29 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sun, 1 Oct 2023 00:10:28 +0300
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
Subject: [PATCH net-next v2 08/12] vsock: enable setting SO_ZEROCOPY
Date:   Sun, 1 Oct 2023 00:03:04 +0300
Message-ID: <20230930210308.2394919-9-avkrasnov@salutedevices.com>
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

For AF_VSOCK, zerocopy tx mode depends on transport, so this option must
be set in AF_VSOCK implementation where transport is accessible (if
transport is not set during setting SO_ZEROCOPY: for example socket is
not connected, then SO_ZEROCOPY will be enabled, but once transport will
be assigned, support of this type of transmission will be checked).

To handle SO_ZEROCOPY, AF_VSOCK implementation uses SOCK_CUSTOM_SOCKOPT
bit, thus handling SOL_SOCKET option operations, but all of them except
SO_ZEROCOPY will be forwarded to the generic handler by calling
'sock_setsockopt()'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v1 -> v2:
  * Place 'sock_valbool_flag()' in a single line.

 net/vmw_vsock/af_vsock.c | 45 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ff44bab05191..a84f242466cf 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1406,8 +1406,16 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			goto out;
 		}
 
-		if (vsock_msgzerocopy_allow(transport))
+		if (vsock_msgzerocopy_allow(transport)) {
 			set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			/* If this option was set before 'connect()',
+			 * when transport was unknown, check that this
+			 * feature is supported here.
+			 */
+			err = -EOPNOTSUPP;
+			goto out;
+		}
 
 		err = vsock_auto_bind(vsk);
 		if (err)
@@ -1643,7 +1651,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 	const struct vsock_transport *transport;
 	u64 val;
 
-	if (level != AF_VSOCK)
+	if (level != AF_VSOCK && level != SOL_SOCKET)
 		return -ENOPROTOOPT;
 
 #define COPY_IN(_v)                                       \
@@ -1666,6 +1674,33 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 
 	transport = vsk->transport;
 
+	if (level == SOL_SOCKET) {
+		int zerocopy;
+
+		if (optname != SO_ZEROCOPY) {
+			release_sock(sk);
+			return sock_setsockopt(sock, level, optname, optval, optlen);
+		}
+
+		/* Use 'int' type here, because variable to
+		 * set this option usually has this type.
+		 */
+		COPY_IN(zerocopy);
+
+		if (zerocopy < 0 || zerocopy > 1) {
+			err = -EINVAL;
+			goto exit;
+		}
+
+		if (transport && !vsock_msgzerocopy_allow(transport)) {
+			err = -EOPNOTSUPP;
+			goto exit;
+		}
+
+		sock_valbool_flag(sk, SOCK_ZEROCOPY, zerocopy);
+		goto exit;
+	}
+
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
 		COPY_IN(val);
@@ -2322,6 +2357,12 @@ static int vsock_create(struct net *net, struct socket *sock,
 		}
 	}
 
+	/* SOCK_DGRAM doesn't have 'setsockopt' callback set in its
+	 * proto_ops, so there is no handler for custom logic.
+	 */
+	if (sock_type_connectible(sock->type))
+		set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
+
 	vsock_insert_unbound(vsk);
 
 	return 0;
-- 
2.25.1

