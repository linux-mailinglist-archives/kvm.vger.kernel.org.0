Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6344E7BC957
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 19:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbjJGR3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344083AbjJGR2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 13:28:52 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68186A6;
        Sat,  7 Oct 2023 10:28:49 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id DE01D120009;
        Sat,  7 Oct 2023 20:28:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru DE01D120009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696699726;
        bh=qp4gPdJCdlBgnNry5u1H6tbvvLqGQ0NsSlDugnr+6M8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=MDoetXuxFRP5g3LAEUTXjvr7GIJZ9e5vNtif4uN+gY+l9CigVHMKdk+BKUs8+2JyE
         Catu1XOgahXGn7wOs2b+12nc6MKp9lI5sAwWevd5AOeDhRNGxdTHV5wLJvLSgsLBqJ
         y/B3TSboaGv0OFsg7Im++/+ZZJei5vS0IHxF/eYLkpnLb9NnLdaCOKuU4Uaqhkzcze
         eFrQFVf8kdbNuwWMaufrQCS2hvSbuTVBWH8XqFtcicBnh1w+Gal/3h9f4ubOPP0TdX
         t6DYp5iqikpg6PZ0KoJQOZnE37hpElv8czMNMqNRvGxVOESlmNpo1x05TmlonFJnzO
         Ft7ptSwg/KBFA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  7 Oct 2023 20:28:46 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 7 Oct 2023 20:28:46 +0300
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
Subject: [PATCH net-next v3 02/12] vsock: read from socket's error queue
Date:   Sat, 7 Oct 2023 20:21:29 +0300
Message-ID: <20231007172139.1338644-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
References: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180453 [Oct 07 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/07 16:48:00 #22085983
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
 v2 -> v3:
  * Add comments to describe 'SOL_VSOCK' and 'VSOCK_RECVERR' in the file
    'vm_sockets.h'.
  * Reorder includes in 'af_vsock.c' in alphabetical order.

 include/linux/socket.h          |  1 +
 include/uapi/linux/vm_sockets.h | 12 ++++++++++++
 net/vmw_vsock/af_vsock.c        |  6 ++++++
 3 files changed, 19 insertions(+)

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
index c60ca33eac59..d9d703b2d45a 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -191,4 +191,16 @@ struct sockaddr_vm {
 
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
 
+/* For reading completion in case of MSG_ZEROCOPY flag transmission.
+ * This is value of 'cmsg_level' field of the 'struct cmsghdr'.
+ */
+
+#define SOL_VSOCK	287
+
+/* For reading completion in case of MSG_ZEROCOPY flag transmission.
+ * This is value of 'cmsg_type' field of the 'struct cmsghdr'.
+ */
+
+#define VSOCK_RECVERR	1
+
 #endif /* _UAPI_VM_SOCKETS_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d841f4de33b0..38486efd3d05 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -89,6 +89,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/cred.h>
+#include <linux/errqueue.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -110,6 +111,7 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
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

