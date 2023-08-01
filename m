Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD2476B744
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbjHAOXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjHAOXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:23:34 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E184810FD;
        Tue,  1 Aug 2023 07:23:32 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 73CF4120017;
        Tue,  1 Aug 2023 17:23:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 73CF4120017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690899811;
        bh=aoZdDQ/3Ig4eVm/2+lIxfpYEQW/u4NLnWkC8fXi/GUU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=CfE9tUfHgvtH6tVMZCP3SBfqnB2kktaDmSD8gs40ryKb2XPd+HTKeIhylFglbG8Gs
         qqmCvf0pzDIyz9vroXDJ/iuyaXGWQ7qHGRuMTyH6iEI9rYnxNfXkiGzNuSlWIY/+4f
         bNgn8VurwHB/hqw16yi1ge5O0Kso4FUk5QCtwyf5PjIRxee86YPqCwzSAQ/TunGQ+I
         hG4RSdRvWCn1ZMO0Gw4YM0FakUH1Aa/CAeqvllCkcnwmh7DL18JL+Mq6sBlzJ0cf0s
         LCV43a+Qic9wBLhD9nMNFqOWd+Vv5Lz+DKQl5WWLdTe3aj+3GD+kRDLP5gCbu7rZOY
         ACX8NVvv7kK4w==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue,  1 Aug 2023 17:23:31 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 1 Aug 2023 17:23:27 +0300
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
Subject: [RFC PATCH v1 2/2] test/vsock: shutdowned socket test
Date:   Tue, 1 Aug 2023 17:17:27 +0300
Message-ID: <20230801141727.481156-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
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

This adds two tests for 'shutdown()' call. It checks that SIGPIPE is
sent when MSG_NOSIGNAL is not set and vice versa. Both flags SHUT_WR
and SHUT_RD are tested.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 90718c2fd4ea..21d40a8d881c 100644
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
 
+static bool have_sigpipe;
+
+static void sigpipe(int signo)
+{
+	have_sigpipe = true;
+}
+
+static void test_stream_check_sigpipe(int fd)
+{
+	ssize_t res;
+
+	have_sigpipe = false;
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
+	have_sigpipe = false;
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

