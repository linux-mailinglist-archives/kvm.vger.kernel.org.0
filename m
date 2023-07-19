Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743C3759EB4
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 21:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjGSTdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 15:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjGSTdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 15:33:05 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4751FE9;
        Wed, 19 Jul 2023 12:32:51 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id E741E100015;
        Wed, 19 Jul 2023 22:32:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E741E100015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1689795168;
        bh=s/sX+uP8NaxFQI1Z6FWK+dZgh9F2MCCqp2PIf9LSW+c=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=oA78sp6p//UjnGcDr2cwb5lWq4pxJlLlc8tZlg7JTYjNhQYuHAFsPrV4/EqPHk/aS
         fMjxxc/Lv1oiCPZKn75OP8vqms33dHM9OIHsqXr7gS4FHmXqckZEgz+vI4RbOJUlF0
         mRO21TiqII7I512E48OK8EtRFiKz+yBKgBUWjqrrkAhP3ktGe/aRmZxx2p1GMOTflG
         T1dh+KvL4CFHpeugaLqGMpl/28rhQX9FNdXiFlJu2vFBdHKdHPUqDnlYoblMMgaXDd
         hrzDNHJJn62wfHp/KjOpkof2ODyglOIGUJw4JXf1TwaIG59UxJnXcaYr+s+dWdW0a8
         3/soyQq8lg+6A==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 22:32:48 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 22:32:48 +0300
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
Subject: [RFC PATCH v2 3/4] vsock/test: rework MSG_PEEK test for SOCK_STREAM
Date:   Wed, 19 Jul 2023 22:27:07 +0300
Message-ID: <20230719192708.1775162-4-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230719192708.1775162-1-AVKrasnov@sberdevices.ru>
References: <20230719192708.1775162-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178730 [Jul 19 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 524 524 9753033d6953787301affc41bead8ed49c47b39d, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/19 15:29:00 #21641898
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

This new version makes test more complicated by adding empty read,
partial read and data comparisons between MSG_PEEK and normal reads.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 78 ++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..444a3ff0681f 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -255,9 +255,14 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 		close(fds[i]);
 }
 
+#define MSG_PEEK_BUF_LEN 64
+
 static void test_stream_msg_peek_client(const struct test_opts *opts)
 {
+	unsigned char buf[MSG_PEEK_BUF_LEN];
+	ssize_t send_size;
 	int fd;
+	int i;
 
 	fd = vsock_stream_connect(opts->peer_cid, 1234);
 	if (fd < 0) {
@@ -265,12 +270,32 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	send_byte(fd, 1, 0);
+	for (i = 0; i < sizeof(buf); i++)
+		buf[i] = rand() & 0xFF;
+
+	control_expectln("SRVREADY");
+
+	send_size = send(fd, buf, sizeof(buf), 0);
+
+	if (send_size < 0) {
+		perror("send");
+		exit(EXIT_FAILURE);
+	}
+
+	if (send_size != sizeof(buf)) {
+		fprintf(stderr, "Invalid send size %zi\n", send_size);
+		exit(EXIT_FAILURE);
+	}
+
 	close(fd);
 }
 
 static void test_stream_msg_peek_server(const struct test_opts *opts)
 {
+	unsigned char buf_half[MSG_PEEK_BUF_LEN / 2];
+	unsigned char buf_normal[MSG_PEEK_BUF_LEN];
+	unsigned char buf_peek[MSG_PEEK_BUF_LEN];
+	ssize_t res;
 	int fd;
 
 	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
@@ -279,8 +304,55 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	recv_byte(fd, 1, MSG_PEEK);
-	recv_byte(fd, 1, 0);
+	/* Peek from empty socket. */
+	res = recv(fd, buf_peek, sizeof(buf_peek), MSG_PEEK | MSG_DONTWAIT);
+	if (res != -1) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != EAGAIN) {
+		perror("EAGAIN expected");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SRVREADY");
+
+	/* Peek part of data. */
+	res = recv(fd, buf_half, sizeof(buf_half), MSG_PEEK);
+	if (res != sizeof(buf_half)) {
+		fprintf(stderr, "recv(2) + MSG_PEEK, expected %zu, got %zi\n",
+			sizeof(buf_half), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Peek whole data. */
+	res = recv(fd, buf_peek, sizeof(buf_peek), MSG_PEEK);
+	if (res != sizeof(buf_peek)) {
+		fprintf(stderr, "recv(2) + MSG_PEEK, expected %zu, got %zi\n",
+			sizeof(buf_peek), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Compare partial and full peek. */
+	if (memcmp(buf_half, buf_peek, sizeof(buf_half))) {
+		fprintf(stderr, "Partial peek data mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	res = recv(fd, buf_normal, sizeof(buf_normal), 0);
+	if (res != sizeof(buf_normal)) {
+		fprintf(stderr, "recv(2), expected %zu, got %zi\n",
+			sizeof(buf_normal), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Compare full peek and normal read. */
+	if (memcmp(buf_peek, buf_normal, sizeof(buf_peek))) {
+		fprintf(stderr, "Full peek data mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
 	close(fd);
 }
 
-- 
2.25.1

