Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69297C0478
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 21:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343889AbjJJTXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 15:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbjJJTXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 15:23:01 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F93112C;
        Tue, 10 Oct 2023 12:22:49 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 08EC412000A;
        Tue, 10 Oct 2023 22:22:47 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 08EC412000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696965767;
        bh=kGOX7KRZssqewqFGDS+mcXvNDZDJ0bNBmxn/zkWOFe4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=sxcSimr4oeNJXcGssrXrj7p8gzj4N4ZIkjLPUkdA6xU0M5te2PHQCrxUDrLB+mfEB
         6bnCj5+GB3kE0BpOUdahXELPylJW8U5jSIZSXhc14nH1JnsfTX48LvjGnFuNE939y6
         ZvfACzFmjhNcicPUQE7oxfcErtpfPVM1aCW/qnSpmm1EdWNbUps1NOPk4YVzZc+X9W
         Ml6PpUpWJp0u8nt2Z9Ku2vvuIaGGnFiwh1Oag4Dh9B72vpPfYNjx5WSl+phNwCmiC6
         yZJEBMpLBqpfDuvk/RVkHq16HTtAKdmK+tY4tpMCl420/TZkdVOHCbzby59qLqxvza
         A1rLSxKPwWIgQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 10 Oct 2023 22:22:46 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 10 Oct 2023 22:22:46 +0300
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
Subject: [PATCH net-next v4 08/12] vsock: enable setting SO_ZEROCOPY
Date:   Tue, 10 Oct 2023 22:15:20 +0300
Message-ID: <20231010191524.1694217-9-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180515 [Oct 10 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 536 536 1ae19c7800f69da91432b5e67ed4a00b9ade0d03, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/10 16:15:00 #22148151
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 Changelog:
 v1 -> v2:
  * Place 'sock_valbool_flag()' in a single line.

 net/vmw_vsock/af_vsock.c | 45 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 37b1c0432941..816725af281f 100644
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

