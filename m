Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBB07B43BA
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjI3VKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 17:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbjI3VKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 17:10:35 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A955DD;
        Sat, 30 Sep 2023 14:10:31 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 57F0B100008;
        Sun,  1 Oct 2023 00:10:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 57F0B100008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696108228;
        bh=pjRLVcanszV3gLFIT2A933nz3OurK+IMeMTruxmdgt8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=geMbEnU0v6CXGIvL+Qqu++8Nt0Z/j/g3JR8pti1jcUGaHLT/+Na+fcX1mR61cO0dD
         E4fTkYyjLXw40L9xwRkzvIG9p9cAx2etjexSMaKuJu/+BfFE5yOqCpsw6FyoG5TWuJ
         wqrhuF8tHjxjMndq2HU/m4e/aIpLPvGLfLWr/CduoWbfbVs31k8LgHRtC3SJccrvZW
         6CwmQRllwsom0/5MSaQRPUrjCZy5IbiiZ5u9ZjKgFnlYN0nBzatmpF5YiBkRmvSgkN
         Bor94vIy/92SnEx/5O6ozRJtHMp6B8ej03XtMYW4FBE35pbyepMkaM2oOl6ey/5j8i
         Oo9L97+7Z0wRw==
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
Subject: [PATCH net-next v2 02/12] vsock: read from socket's error queue
Date:   Sun, 1 Oct 2023 00:02:58 +0300
Message-ID: <20230930210308.2394919-3-avkrasnov@salutedevices.com>
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

This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
is used to read socket's error queue instead of data queue. Possible
scenario of error queue usage is receiving completions for transmission
with MSG_ZEROCOPY flag. This patch also adds new defines: 'SOL_VSOCK'
and 'VSOCK_RECVERR'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v1 -> v2:
  * Place new defines for userspace to the existing file 'vm_sockets.h'
    instead of creating new one.

 include/linux/socket.h          | 1 +
 include/uapi/linux/vm_sockets.h | 4 ++++
 net/vmw_vsock/af_vsock.c        | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 39b74d83c7c4..cfcb7e2c3813 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -383,6 +383,7 @@ struct ucred {
 #define SOL_MPTCP	284
 #define SOL_MCTP	285
 #define SOL_SMC		286
+#define SOL_VSOCK	287
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index c60ca33eac59..b1a66c1a7054 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -191,4 +191,8 @@ struct sockaddr_vm {
 
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
 
+#define SOL_VSOCK	287
+
+#define VSOCK_RECVERR	1
+
 #endif /* _UAPI_VM_SOCKETS_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d841f4de33b0..0365382beab6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -110,6 +110,8 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <linux/errqueue.h>
+#include <uapi/linux/vm_sockets.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -2137,6 +2139,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	int err;
 
 	sk = sock->sk;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, VSOCK_RECVERR);
+
 	vsk = vsock_sk(sk);
 	err = 0;
 
-- 
2.25.1

