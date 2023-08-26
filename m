Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391C678988E
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjHZSF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjHZSFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 14:05:32 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05392E7B;
        Sat, 26 Aug 2023 11:05:28 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 8ED53120008;
        Sat, 26 Aug 2023 21:05:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8ED53120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1693073125;
        bh=rQXoRSPidGXZ/90/QcfVKN3XYzjgSA5gOdaZ5Bz14gU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=WiFHIORQnnK9qxktNIqluIB/PyXrlOHWMphFJcoaMeHPsQGlYc9IF/NEy5wiTocw1
         NVMoj226/08jU6znRkN7ZhJGsad2Er2546Lg4uTEOLo6ND2h7FGHatH1i/m48KRpzE
         YMJyZGHDl2Y+cy6mwEOtRj3Z8zr5Aszw/rn6bZnokFzVS8KjsGAPWlSkU0FjaCNwgn
         ULbSUk7LntA/0zl8wxnAhI6ppCuHaUjYTk1H3Zp/z/sAAnWQ/5f32AHE1n5sYsSv9i
         yIPXkutZwaECF+j4QNbefb7eI1meqMJh+ipQ6ACo0vC3NTFeGJkyHs/ZYC16cI3W57
         oPl1ps8p8/Gjw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat, 26 Aug 2023 21:05:25 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 26 Aug 2023 21:05:09 +0300
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
Subject: [RFC PATCH v2 2/2] test/vsock: shutdowned socket test
Date:   Sat, 26 Aug 2023 20:59:00 +0300
Message-ID: <20230826175900.3693844-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
References: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179455 [Aug 25 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 527 527 5bb611be2ca2baa31d984ccbf4ef4415504fc308, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/26 15:09:00 #21728460
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

