Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446BD79BA3F
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjIKUrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244416AbjIKU1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 16:27:32 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4211A7;
        Mon, 11 Sep 2023 13:27:25 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 347F6100015;
        Mon, 11 Sep 2023 23:27:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 347F6100015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694464043;
        bh=rqasP/v92NSYLxxo86wWQ86EzlGraPrIdOaNbxND9VE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=tXvLiHycWrvWPPRRV0kAGA0UTJsmnxTlLLV75If8EflTDipYvEJlsXQaSd9YNVID2
         dvhmjNPb1zJukD2nJbX2l4sD64oqc0AjSBX1YlE68hSDix6qNXxzVjoQHeAoqOFikt
         uq2kvdnMUUmP7uIRSBsC2KoCktR4JikVYGuT6p9UPhWQa/XqMybAhWUOs30ukrqxFQ
         Mj77Dm4NViJOjNsINCPsLQEyNKUGPxFbp+e+HrHIICWcO7LFjWZz3en0p8x+5BhLb8
         3EBM2oLfTV1E+psxNkgfPAuf2mNQfwaaNLYz+Rs51Vk3phHuqL/ZLBUWvfTj/7IjTr
         0qNY7kphcMWLg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Mon, 11 Sep 2023 23:27:23 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Mon, 11 Sep 2023 23:27:22 +0300
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
Subject: [PATCH net-next v2 2/2] test/vsock: shutdowned socket test
Date:   Mon, 11 Sep 2023 23:20:27 +0300
Message-ID: <20230911202027.1928574-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230911202027.1928574-1-avkrasnov@salutedevices.com>
References: <20230911202027.1928574-1-avkrasnov@salutedevices.com>
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

This adds two tests for 'shutdown()' call. It checks that SIGPIPE is
sent when MSG_NOSIGNAL is not set and vice versa. Both flags SHUT_WR
and SHUT_RD are tested.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 90718c2fd4ea..148fc9c47c50 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -19,6 +19,7 @@
 #include <time.h>
 #include <sys/mman.h>
 #include <poll.h>
+#include <signal.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -1170,6 +1171,133 @@ static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
 	return test_msg_peek_server(opts, true);
 }
 
+static sig_atomic_t have_sigpipe;
+
+static void sigpipe(int signo)
+{
+	have_sigpipe = 1;
+}
+
+static void test_stream_check_sigpipe(int fd)
+{
+	ssize_t res;
+
+	have_sigpipe = 0;
+
+	res = send(fd, "A", 1, 0);
+	if (res != -1) {
+		fprintf(stderr, "expected send(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!have_sigpipe) {
+		fprintf(stderr, "SIGPIPE expected\n");
+		exit(EXIT_FAILURE);
+	}
+
+	have_sigpipe = 0;
+
+	res = send(fd, "A", 1, MSG_NOSIGNAL);
+	if (res != -1) {
+		fprintf(stderr, "expected send(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	if (have_sigpipe) {
+		fprintf(stderr, "SIGPIPE not expected\n");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void test_stream_shutwr_client(const struct test_opts *opts)
+{
+	int fd;
+
+	struct sigaction act = {
+		.sa_handler = sigpipe,
+	};
+
+	sigaction(SIGPIPE, &act, NULL);
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (shutdown(fd, SHUT_WR)) {
+		perror("shutdown");
+		exit(EXIT_FAILURE);
+	}
+
+	test_stream_check_sigpipe(fd);
+
+	control_writeln("CLIENTDONE");
+
+	close(fd);
+}
+
+static void test_stream_shutwr_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLIENTDONE");
+
+	close(fd);
+}
+
+static void test_stream_shutrd_client(const struct test_opts *opts)
+{
+	int fd;
+
+	struct sigaction act = {
+		.sa_handler = sigpipe,
+	};
+
+	sigaction(SIGPIPE, &act, NULL);
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SHUTRDDONE");
+
+	test_stream_check_sigpipe(fd);
+
+	control_writeln("CLIENTDONE");
+
+	close(fd);
+}
+
+static void test_stream_shutrd_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	if (shutdown(fd, SHUT_RD)) {
+		perror("shutdown");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SHUTRDDONE");
+	control_expectln("CLIENTDONE");
+
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1250,6 +1378,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_msg_peek_client,
 		.run_server = test_seqpacket_msg_peek_server,
 	},
+	{
+		.name = "SOCK_STREAM SHUT_WR",
+		.run_client = test_stream_shutwr_client,
+		.run_server = test_stream_shutwr_server,
+	},
+	{
+		.name = "SOCK_STREAM SHUT_RD",
+		.run_client = test_stream_shutrd_client,
+		.run_server = test_stream_shutrd_server,
+	},
 	{},
 };
 
-- 
2.25.1

