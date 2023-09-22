Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73E57AA867
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 07:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjIVFcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 01:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjIVFb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 01:31:56 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253C91A1;
        Thu, 21 Sep 2023 22:31:49 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id ACE5410000E;
        Fri, 22 Sep 2023 08:31:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru ACE5410000E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695360705;
        bh=9H/u/jBUK5iRTxO+H/WMgQBFkOH1RZf9afXoxrj2Ttw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=UFP2Jh/AhYkEWM8NiGFMuOCnGxUh2prYT57/sczyoPh2lxi/nBp2/6l3mrSeblzw/
         aDWqDCn3VpuP88IhijTI/jq1TMzkGjuAjw9+Wr36xkzAZLu2apTPnbuShqoZnM1ReB
         GF9NJ7Lmizv9Tu3DEZZOG/1PgE7Kpy10a6j/pMkPcnntSy/jnWU16Az+/taQJuSiZt
         3cH2wDXvxCaMxVp8Kk5vLIruP0tEw613SOCvHjil+0dhLfre9RRmJCxA0JegvwE0UO
         o9OeQeGNHtdAwRucxM1Tz02eNE0nsDqRj6swTMRQ0BDfYJENVyIKfp3uejd3xn1DX4
         n/FY47ylK9zKg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 22 Sep 2023 08:31:45 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 22 Sep 2023 08:31:45 +0300
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
Subject: [PATCH net-next v1 12/12] test/vsock: io_uring rx/tx tests
Date:   Fri, 22 Sep 2023 08:24:28 +0300
Message-ID: <20230922052428.4005676-13-avkrasnov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
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

This adds set of tests which use io_uring for rx/tx. This test suite is
implemented as separated util like 'vsock_test' and has the same set of
input arguments as 'vsock_test'. These tests only cover cases of data
transmission (no connect/bind/accept etc).

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v5(big patchset) -> v1:
  * Use LDLIBS instead of LDFLAGS.

 tools/testing/vsock/Makefile           |   7 +-
 tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
 2 files changed, 327 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/vsock/vsock_uring_test.c

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index 1a26f60a596c..c84380bfc18d 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,12 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-only
+ifeq ($(MAKECMDGOALS),vsock_uring_test)
+LDLIBS = -luring
+endif
+
 all: test vsock_perf
 test: vsock_test vsock_diag_test
 vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
 vsock_perf: vsock_perf.o
+vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
 
 CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
 clean:
-	${RM} *.o *.d vsock_test vsock_diag_test vsock_perf
+	${RM} *.o *.d vsock_test vsock_diag_test vsock_perf vsock_uring_test
 -include *.d
diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
new file mode 100644
index 000000000000..5ecc4c0d62ab
--- /dev/null
+++ b/tools/testing/vsock/vsock_uring_test.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* io_uring tests for vsock
+ *
+ * Copyright (C) 2023 SaluteDevices.
+ *
+ * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
+ */
+
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <liburing.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <linux/kernel.h>
+#include <error.h>
+
+#include "util.h"
+#include "control.h"
+
+#define PAGE_SIZE		4096
+#define RING_ENTRIES_NUM	4
+
+static struct vsock_test_data test_data_array[] = {
+	/* All elements have page aligned base and size. */
+	{
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, 2 * PAGE_SIZE },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	},
+	/* Middle element has both non-page aligned base and size. */
+	{
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 200  },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	}
+};
+
+static void vsock_io_uring_client(const struct test_opts *opts,
+				  const struct vsock_test_data *test_data,
+				  bool msg_zerocopy)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec *iovec;
+	struct msghdr msg;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (msg_zerocopy)
+		enable_so_zerocopy(fd);
+
+	iovec = iovec_from_test_data(test_data);
+
+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
+		error(1, errno, "io_uring_queue_init");
+
+	if (io_uring_register_buffers(&ring, iovec, test_data->vecs_cnt))
+		error(1, errno, "io_uring_register_buffers");
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_iov = iovec;
+	msg.msg_iovlen = test_data->vecs_cnt;
+	sqe = io_uring_get_sqe(&ring);
+
+	if (msg_zerocopy)
+		io_uring_prep_sendmsg_zc(sqe, fd, &msg, 0);
+	else
+		io_uring_prep_sendmsg(sqe, fd, &msg, 0);
+
+	if (io_uring_submit(&ring) != 1)
+		error(1, errno, "io_uring_submit");
+
+	if (io_uring_wait_cqe(&ring, &cqe))
+		error(1, errno, "io_uring_wait_cqe");
+
+	io_uring_cqe_seen(&ring, cqe);
+
+	control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
+
+	control_writeln("DONE");
+	io_uring_queue_exit(&ring);
+	free_iovec_test_data(test_data, iovec);
+	close(fd);
+}
+
+static void vsock_io_uring_server(const struct test_opts *opts,
+				  const struct vsock_test_data *test_data)
+{
+	unsigned long remote_hash;
+	unsigned long local_hash;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec iovec;
+	size_t data_len;
+	void *data;
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
+
+	data = malloc(data_len);
+	if (!data) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
+		error(1, errno, "io_uring_queue_init");
+
+	sqe = io_uring_get_sqe(&ring);
+	iovec.iov_base = data;
+	iovec.iov_len = data_len;
+
+	io_uring_prep_readv(sqe, fd, &iovec, 1, 0);
+
+	if (io_uring_submit(&ring) != 1)
+		error(1, errno, "io_uring_submit");
+
+	if (io_uring_wait_cqe(&ring, &cqe))
+		error(1, errno, "io_uring_wait_cqe");
+
+	if (cqe->res != data_len) {
+		fprintf(stderr, "expected %zu, got %u\n", data_len,
+			cqe->res);
+		exit(EXIT_FAILURE);
+	}
+
+	local_hash = hash_djb2(data, data_len);
+
+	remote_hash = control_readulong();
+	if (remote_hash != local_hash) {
+		fprintf(stderr, "hash mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	io_uring_queue_exit(&ring);
+	free(data);
+}
+
+void test_stream_uring_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_server(opts, &test_data_array[i]);
+}
+
+void test_stream_uring_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_client(opts, &test_data_array[i], false);
+}
+
+void test_stream_uring_msg_zc_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_server(opts, &test_data_array[i]);
+}
+
+void test_stream_uring_msg_zc_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_client(opts, &test_data_array[i], true);
+}
+
+static struct test_case test_cases[] = {
+	{
+		.name = "SOCK_STREAM io_uring test",
+		.run_server = test_stream_uring_server,
+		.run_client = test_stream_uring_client,
+	},
+	{
+		.name = "SOCK_STREAM io_uring MSG_ZEROCOPY test",
+		.run_server = test_stream_uring_msg_zc_server,
+		.run_client = test_stream_uring_msg_zc_client,
+	},
+	{},
+};
+
+static const char optstring[] = "";
+static const struct option longopts[] = {
+	{
+		.name = "control-host",
+		.has_arg = required_argument,
+		.val = 'H',
+	},
+	{
+		.name = "control-port",
+		.has_arg = required_argument,
+		.val = 'P',
+	},
+	{
+		.name = "mode",
+		.has_arg = required_argument,
+		.val = 'm',
+	},
+	{
+		.name = "peer-cid",
+		.has_arg = required_argument,
+		.val = 'p',
+	},
+	{
+		.name = "help",
+		.has_arg = no_argument,
+		.val = '?',
+	},
+	{},
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
+		"\n"
+		"  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
+		"  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
+		"\n"
+		"Run transmission tests using io_uring. Usage is the same as\n"
+		"in ./vsock_test\n"
+		"\n"
+		"Options:\n"
+		"  --help                 This help message\n"
+		"  --control-host <host>  Server IP address to connect to\n"
+		"  --control-port <port>  Server port to listen on/connect to\n"
+		"  --mode client|server   Server or client mode\n"
+		"  --peer-cid <cid>       CID of the other side\n"
+		);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char **argv)
+{
+	const char *control_host = NULL;
+	const char *control_port = NULL;
+	struct test_opts opts = {
+		.mode = TEST_MODE_UNSET,
+		.peer_cid = VMADDR_CID_ANY,
+	};
+
+	init_signals();
+
+	for (;;) {
+		int opt = getopt_long(argc, argv, optstring, longopts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'H':
+			control_host = optarg;
+			break;
+		case 'm':
+			if (strcmp(optarg, "client") == 0) {
+				opts.mode = TEST_MODE_CLIENT;
+			} else if (strcmp(optarg, "server") == 0) {
+				opts.mode = TEST_MODE_SERVER;
+			} else {
+				fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'p':
+			opts.peer_cid = parse_cid(optarg);
+			break;
+		case 'P':
+			control_port = optarg;
+			break;
+		case '?':
+		default:
+			usage();
+		}
+	}
+
+	if (!control_port)
+		usage();
+	if (opts.mode == TEST_MODE_UNSET)
+		usage();
+	if (opts.peer_cid == VMADDR_CID_ANY)
+		usage();
+
+	if (!control_host) {
+		if (opts.mode != TEST_MODE_SERVER)
+			usage();
+		control_host = "0.0.0.0";
+	}
+
+	control_init(control_host, control_port,
+		     opts.mode == TEST_MODE_SERVER);
+
+	run_tests(test_cases, &opts);
+
+	control_cleanup();
+
+	return 0;
+}
-- 
2.25.1

