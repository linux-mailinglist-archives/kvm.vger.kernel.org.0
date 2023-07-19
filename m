Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C740759EB9
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 21:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjGSTda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 15:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjGSTdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 15:33:20 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA21B268B;
        Wed, 19 Jul 2023 12:32:51 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id B094112007F;
        Wed, 19 Jul 2023 22:32:49 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B094112007F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1689795169;
        bh=xFK6wvHnDMcWR1WaNUgaOhaKf8/llnzNh96n/+7csqE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=l0v7DCbAdFJvikgtKrOlNcHeGkfzFDhYfYqHkQNUEfKLwwZ+bxt4xePmrzjHu3s0S
         qzU+hWYJByGI2Qg95558OZfWegyoumn3Fdxi9iSc+Uk3fru8DVXeDunTIJ6zz+bCSb
         ebScfgtoTcUgkaY7j2YD+iVuYj4QNogMvW9Tw9PZVTCVGoyZ5APsRMgRuNrb5FLEBd
         NzbH8gFsDcaCg1fWugYGqE/jVHiHnzlBa7VXqH2pXGXilszx/j5sqiUnPibYCbOhuX
         YCo7IDkKDnwfBlhwPrNlXQwShZkKr/yKPmRFl7an5Q7/RYqp/OlRVU0hpR/+O+y6gj
         jU0ZWcbv1GwDA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 22:32:49 +0300 (MSK)
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
Subject: [RFC PATCH v2 4/4] vsock/test: MSG_PEEK test for SOCK_SEQPACKET
Date:   Wed, 19 Jul 2023 22:27:08 +0300
Message-ID: <20230719192708.1775162-5-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 524 524 9753033d6953787301affc41bead8ed49c47b39d, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
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

This adds MSG_PEEK test for SOCK_SEQPACKET. It works in the same way as
SOCK_STREAM test, except it also tests MSG_TRUNC flag.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 58 +++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 444a3ff0681f..2ca2cbfa9808 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -257,14 +257,19 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 
 #define MSG_PEEK_BUF_LEN 64
 
-static void test_stream_msg_peek_client(const struct test_opts *opts)
+static void __test_msg_peek_client(const struct test_opts *opts,
+				   bool seqpacket)
 {
 	unsigned char buf[MSG_PEEK_BUF_LEN];
 	ssize_t send_size;
 	int fd;
 	int i;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (seqpacket)
+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	else
+		fd = vsock_stream_connect(opts->peer_cid, 1234);
+
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -290,7 +295,8 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
 	close(fd);
 }
 
-static void test_stream_msg_peek_server(const struct test_opts *opts)
+static void __test_msg_peek_server(const struct test_opts *opts,
+				   bool seqpacket)
 {
 	unsigned char buf_half[MSG_PEEK_BUF_LEN / 2];
 	unsigned char buf_normal[MSG_PEEK_BUF_LEN];
@@ -298,7 +304,11 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	ssize_t res;
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (seqpacket)
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	else
+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -340,6 +350,21 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	if (seqpacket) {
+		/* This type of socket supports MSG_TRUNC flag,
+		 * so check it with MSG_PEEK. We must get length
+		 * of the message.
+		 */
+		res = recv(fd, buf_half, sizeof(buf_half), MSG_PEEK |
+			   MSG_TRUNC);
+		if (res != sizeof(buf_peek)) {
+			fprintf(stderr,
+				"recv(2) + MSG_PEEK | MSG_TRUNC, exp %zu, got %zi\n",
+				sizeof(buf_half), res);
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	res = recv(fd, buf_normal, sizeof(buf_normal), 0);
 	if (res != sizeof(buf_normal)) {
 		fprintf(stderr, "recv(2), expected %zu, got %zi\n",
@@ -356,6 +381,16 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_msg_peek_client(const struct test_opts *opts)
+{
+	return __test_msg_peek_client(opts, false);
+}
+
+static void test_stream_msg_peek_server(const struct test_opts *opts)
+{
+	return __test_msg_peek_server(opts, false);
+}
+
 #define SOCK_BUF_SIZE (2 * 1024 * 1024)
 #define MAX_MSG_SIZE (32 * 1024)
 
@@ -1125,6 +1160,16 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_seqpacket_msg_peek_client(const struct test_opts *opts)
+{
+	return __test_msg_peek_client(opts, true);
+}
+
+static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
+{
+	return __test_msg_peek_server(opts, true);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1200,6 +1245,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET MSG_PEEK",
+		.run_client = test_seqpacket_msg_peek_client,
+		.run_server = test_seqpacket_msg_peek_server,
+	},
 	{},
 };
 
-- 
2.25.1

