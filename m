Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59B27AA853
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 07:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjIVFcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 01:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjIVFbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 01:31:53 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2337419C;
        Thu, 21 Sep 2023 22:31:46 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id A72F3120010;
        Fri, 22 Sep 2023 08:31:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A72F3120010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695360704;
        bh=0ymaEFOxCcF5BXOe/GUnbWDWMJ8NmVqVVdsnWkIEv2M=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=rsgsWjk19DFdnGl9ONh5xwynjjlEPQmMlfFo0rnm9zgsIxspXftFmsvREZW7HbV4B
         zGbyiK6vTnS1UwdHsOwp1NZCzj0c9SheCqTX1C2+s9VPJEG/CXVzJov2ygey8s22Bg
         jIeVDPwtpk6QtTOGeaE3w6J2b0fwU8jRI6diRMD2yC1MggVn+oyt7dacArTtUAunrX
         vVR5s/OPFKw+fKZXKdnkHRS7WmrzoBNUnTYh9eoE0TZbHg7Yw8cQO+PvTplObfCQ6F
         K8W4EHxtyW2Zsyiigszf0jfE2Rwa0zmFOUk3pZXXukrcqldB9heU7r3YM4f1p9VsIh
         2m9YJle1CilHQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 22 Sep 2023 08:31:44 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 22 Sep 2023 08:31:44 +0300
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
Subject: [PATCH net-next v1 08/12] vsock: enable setting SO_ZEROCOPY
Date:   Fri, 22 Sep 2023 08:24:24 +0300
Message-ID: <20230922052428.4005676-9-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180033 [Sep 21 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;127.0.0.199:7.1.2;salutedevices.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/22 02:22:00 #21944311
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
---
 Changelog:
 v5(big patchset) -> v1:
  * Compact 'if' conditions.
  * Rename 'zc_val' to 'zerocopy'.
  * Use 'zerocopy' value directly in 'sock_valbool_flag()', without
    ?: operator.
  * Set 'SOCK_CUSTOM_SOCKOPT' bit for connectible sockets only, as
    suggested by Bobby Eshleman <bobbyeshleman@gmail.com>.

 net/vmw_vsock/af_vsock.c | 46 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 482300eb88e0..c05a42e02a17 100644
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
@@ -1666,6 +1674,34 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 
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
+		sock_valbool_flag(sk, SOCK_ZEROCOPY,
+				  zerocopy);
+		goto exit;
+	}
+
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
 		COPY_IN(val);
@@ -2322,6 +2358,12 @@ static int vsock_create(struct net *net, struct socket *sock,
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

