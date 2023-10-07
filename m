Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D507BC96B
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 19:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbjJGR3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 13:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344121AbjJGR2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 13:28:53 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A614AC;
        Sat,  7 Oct 2023 10:28:50 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id B8436100009;
        Sat,  7 Oct 2023 20:28:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B8436100009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696699728;
        bh=BVnyD6Lt1FrFXSSQeHs6eVOE9pbjlICI2PT9aGf8hlo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=tqrjglHr42IoAWXjQI/Q0REFdqh91C+cqcfu38I4xxZYzVLr1bri+f4Sv5hcpBkO+
         e8W9jXa0OsSPV8JJFXqFU1gxalY+KTTHTE47T9ES9T1phBPIfSYs/ypCYuJdn3WxnL
         u7zy+VhYtkXgoEaEIeCwQmA6RFZMaDI6Qyfutu6gI9s7XFAHHqjH6/Y5iWsLP7E0rE
         544xOfoJ2a+ROlCCkd42DPEUQ5goNyWN8Rk4td2CP/6SVKwIItQ9UTIPxVAf5GEXJ0
         DfVJXMdBpP6cxX8834qQxOvMxW8Cq3Wk2C44TWeSQIFNOCtR5mVMQ8CQoFNJJoCJZq
         nxZPmqlJL+6nw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  7 Oct 2023 20:28:48 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 7 Oct 2023 20:28:48 +0300
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
Subject: [PATCH net-next v3 10/12] test/vsock: MSG_ZEROCOPY flag tests
Date:   Sat, 7 Oct 2023 20:21:37 +0300
Message-ID: <20231007172139.1338644-11-avkrasnov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
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

This adds three tests for MSG_ZEROCOPY feature:
1) SOCK_STREAM tx with different buffers.
2) SOCK_SEQPACKET tx with different buffers.
3) SOCK_STREAM test to read empty error queue of the socket.

Patch also works as preparation for the next patches for tools in this
patchset: vsock_perf and vsock_uring_test:
1) Adds several new functions to util.c - they will be also used by
   vsock_uring_test.
2) Adds two new functions for MSG_ZEROCOPY handling to a new header
   file - such header will be shared between vsock_test, vsock_perf and
   vsock_uring_test, thus avoiding code copy-pasting.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v1 -> v2:
  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
 v2 -> v3:
  * Patch was reworked. Now it is also preparation patch (see commit
    message). Shared stuff for 'vsock_perf' and tests is placed to a
    new header file, while shared code between current test tool and
    future uring test is placed to the 'util.c'. I think, that making
    this patch as preparation allows to reduce number of changes in the
    next patches in this patchset.
  * Make 'struct vsock_test_data' private by placing it to the .c file.
    Also add comments to this struct to clarify sense of its fields.

 tools/testing/vsock/Makefile              |   2 +-
 tools/testing/vsock/msg_zerocopy_common.h |  92 ++++++
 tools/testing/vsock/util.c                | 110 +++++++
 tools/testing/vsock/util.h                |   5 +
 tools/testing/vsock/vsock_test.c          |  16 +
 tools/testing/vsock/vsock_test_zerocopy.c | 367 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  15 +
 7 files changed, 606 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index 21a98ba565ab..1a26f60a596c 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 all: test vsock_perf
 test: vsock_test vsock_diag_test
-vsock_test: vsock_test.o timeout.o control.o util.o
+vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
 vsock_perf: vsock_perf.o
 
diff --git a/tools/testing/vsock/msg_zerocopy_common.h b/tools/testing/vsock/msg_zerocopy_common.h
new file mode 100644
index 000000000000..ce89f1281584
--- /dev/null
+++ b/tools/testing/vsock/msg_zerocopy_common.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef MSG_ZEROCOPY_COMMON_H
+#define MSG_ZEROCOPY_COMMON_H
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/errqueue.h>
+
+#ifndef SOL_VSOCK
+#define SOL_VSOCK	287
+#endif
+
+#ifndef VSOCK_RECVERR
+#define VSOCK_RECVERR	1
+#endif
+
+static void enable_so_zerocopy(int fd)
+{
+	int val = 1;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
+		perror("setsockopt");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void vsock_recv_completion(int fd, const bool *zerocopied) __maybe_unused;
+static void vsock_recv_completion(int fd, const bool *zerocopied)
+{
+	struct sock_extended_err *serr;
+	struct msghdr msg = { 0 };
+	char cmsg_data[128];
+	struct cmsghdr *cm;
+	ssize_t res;
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (res) {
+		fprintf(stderr, "failed to read error queue: %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (!cm) {
+		fprintf(stderr, "cmsg: no cmsg\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (cm->cmsg_level != SOL_VSOCK) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (cm->cmsg_type != VSOCK_RECVERR) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	serr = (void *)CMSG_DATA(cm);
+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
+		fprintf(stderr, "serr: wrong origin: %u\n", serr->ee_origin);
+		exit(EXIT_FAILURE);
+	}
+
+	if (serr->ee_errno) {
+		fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
+		exit(EXIT_FAILURE);
+	}
+
+	/* This flag is used for tests, to check that transmission was
+	 * performed as expected: zerocopy or fallback to copy. If NULL
+	 * - don't care.
+	 */
+	if (!zerocopied)
+		return;
+
+	if (*zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
+		fprintf(stderr, "serr: was copy instead of zerocopy\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!*zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
+		fprintf(stderr, "serr: was zerocopy instead of copy\n");
+		exit(EXIT_FAILURE);
+	}
+}
+
+#endif /* MSG_ZEROCOPY_COMMON_H */
diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 6779d5008b27..b1770edd8cc1 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -11,10 +11,12 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <string.h>
 #include <signal.h>
 #include <unistd.h>
 #include <assert.h>
 #include <sys/epoll.h>
+#include <sys/mman.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -444,3 +446,111 @@ unsigned long hash_djb2(const void *data, size_t len)
 
 	return hash;
 }
+
+size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
+{
+	size_t bytes;
+	int i;
+
+	for (bytes = 0, i = 0; i < iovnum; i++)
+		bytes += iov[i].iov_len;
+
+	return bytes;
+}
+
+unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum)
+{
+	unsigned long hash;
+	size_t iov_bytes;
+	size_t offs;
+	void *tmp;
+	int i;
+
+	iov_bytes = iovec_bytes(iov, iovnum);
+
+	tmp = malloc(iov_bytes);
+	if (!tmp) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	for (offs = 0, i = 0; i < iovnum; i++) {
+		memcpy(tmp + offs, iov[i].iov_base, iov[i].iov_len);
+		offs += iov[i].iov_len;
+	}
+
+	hash = hash_djb2(tmp, iov_bytes);
+	free(tmp);
+
+	return hash;
+}
+
+struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int iovnum)
+{
+	struct iovec *iovec;
+	int i;
+
+	iovec = malloc(sizeof(*iovec) * iovnum);
+	if (!iovec) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	for (i = 0; i < iovnum; i++) {
+		iovec[i].iov_len = test_iovec[i].iov_len;
+
+		iovec[i].iov_base = mmap(NULL, iovec[i].iov_len,
+					 PROT_READ | PROT_WRITE,
+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
+					 -1, 0);
+		if (iovec[i].iov_base == MAP_FAILED) {
+			perror("mmap");
+			exit(EXIT_FAILURE);
+		}
+
+		if (test_iovec[i].iov_base != MAP_FAILED)
+			iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
+	}
+
+	/* Unmap "invalid" elements. */
+	for (i = 0; i < iovnum; i++) {
+		if (test_iovec[i].iov_base == MAP_FAILED) {
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	for (i = 0; i < iovnum; i++) {
+		int j;
+
+		if (test_iovec[i].iov_base == MAP_FAILED)
+			continue;
+
+		for (j = 0; j < iovec[i].iov_len; j++)
+			((uint8_t *)iovec[i].iov_base)[j] = rand() & 0xff;
+	}
+
+	return iovec;
+}
+
+void free_iovec_test_data(const struct iovec *test_iovec,
+			  struct iovec *iovec, int iovnum)
+{
+	int i;
+
+	for (i = 0; i < iovnum; i++) {
+		if (test_iovec[i].iov_base != MAP_FAILED) {
+			if (test_iovec[i].iov_base)
+				iovec[i].iov_base -= (uintptr_t)test_iovec[i].iov_base;
+
+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
+				perror("munmap");
+				exit(EXIT_FAILURE);
+			}
+		}
+	}
+
+	free(iovec);
+}
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index e5407677ce05..4cacb8d804c1 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -53,4 +53,9 @@ void list_tests(const struct test_case *test_cases);
 void skip_test(struct test_case *test_cases, size_t test_cases_len,
 	       const char *test_id_str);
 unsigned long hash_djb2(const void *data, size_t len);
+size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
+unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum);
+struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int iovnum);
+void free_iovec_test_data(const struct iovec *test_iovec,
+			  struct iovec *iovec, int iovnum);
 #endif /* UTIL_H */
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index da4cb819a183..c1f7bc9abd22 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -21,6 +21,7 @@
 #include <poll.h>
 #include <signal.h>
 
+#include "vsock_test_zerocopy.h"
 #include "timeout.h"
 #include "control.h"
 #include "util.h"
@@ -1269,6 +1270,21 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_shutrd_client,
 		.run_server = test_stream_shutrd_server,
 	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY",
+		.run_client = test_stream_msgzcopy_client,
+		.run_server = test_stream_msgzcopy_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET MSG_ZEROCOPY",
+		.run_client = test_seqpacket_msgzcopy_client,
+		.run_server = test_seqpacket_msgzcopy_server,
+	},
+	{
+		.name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
+		.run_client = test_stream_msgzcopy_empty_errq_client,
+		.run_server = test_stream_msgzcopy_empty_errq_server,
+	},
 	{},
 };
 
diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
new file mode 100644
index 000000000000..af14efdf334b
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* MSG_ZEROCOPY feature tests for vsock
+ *
+ * Copyright (C) 2023 SberDevices.
+ *
+ * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+#include <poll.h>
+#include <linux/errqueue.h>
+#include <linux/kernel.h>
+#include <errno.h>
+
+#include "control.h"
+#include "vsock_test_zerocopy.h"
+#include "msg_zerocopy_common.h"
+
+#define PAGE_SIZE		4096
+
+#define VSOCK_TEST_DATA_MAX_IOV 3
+
+struct vsock_test_data {
+	/* This test case if for SOCK_STREAM only. */
+	bool stream_only;
+	/* Data must be zerocopied. This field is checked against
+	 * field 'ee_code' of the 'struct sock_extended_err', which
+	 * contains bit to detect that zerocopy transmission was
+	 * fallbacked to copy mode.
+	 */
+	bool zerocopied;
+	/* Enable SO_ZEROCOPY option on the socket. Without enabled
+	 * SO_ZEROCOPY, every MSG_ZEROCOPY transmission will behave
+	 * like without MSG_ZEROCOPY flag.
+	 */
+	bool so_zerocopy;
+	/* 'errno' after 'sendmsg()' call. */
+	int sendmsg_errno;
+	/* Number of valid elements in 'vecs'. */
+	int vecs_cnt;
+	/* Array how to allocate buffers for test.
+	 * 'iov_base' == NULL -> valid buf: mmap('iov_len').
+	 *
+	 * 'iov_base' == MAP_FAILED -> invalid buf:
+	 *               mmap('iov_len'), then munmap('iov_len').
+	 *               'iov_base' still contains result of
+	 *               mmap().
+	 *
+	 * 'iov_base' == number -> unaligned valid buf:
+	 *               mmap('iov_len') + number.
+	 */
+	struct iovec vecs[VSOCK_TEST_DATA_MAX_IOV];
+};
+
+static struct vsock_test_data test_data_array[] = {
+	/* Last element has non-page aligned size. */
+	{
+		.zerocopied = true,
+		.so_zerocopy = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE },
+			{ NULL, 200 }
+		}
+	},
+	/* All elements have page aligned base and size. */
+	{
+		.zerocopied = true,
+		.so_zerocopy = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, PAGE_SIZE * 2 },
+			{ NULL, PAGE_SIZE * 3 }
+		}
+	},
+	/* All elements have page aligned base and size. But
+	 * data length is bigger than 64Kb.
+	 */
+	{
+		.zerocopied = true,
+		.so_zerocopy = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE * 16 },
+			{ NULL, PAGE_SIZE * 16 },
+			{ NULL, PAGE_SIZE * 16 }
+		}
+	},
+	/* Middle element has both non-page aligned base and size. */
+	{
+		.zerocopied = true,
+		.so_zerocopy = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 100 },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Middle element is unmapped. */
+	{
+		.zerocopied = false,
+		.so_zerocopy = true,
+		.sendmsg_errno = ENOMEM,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ MAP_FAILED, PAGE_SIZE },
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Valid data, but SO_ZEROCOPY is off. This
+	 * will trigger fallback to copy.
+	 */
+	{
+		.zerocopied = false,
+		.so_zerocopy = false,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 1,
+		{
+			{ NULL, PAGE_SIZE }
+		}
+	},
+	/* Valid data, but message is bigger than peer's
+	 * buffer, so this will trigger fallback to copy.
+	 * This test is for SOCK_STREAM only, because
+	 * for SOCK_SEQPACKET, 'sendmsg()' returns EMSGSIZE.
+	 */
+	{
+		.stream_only = true,
+		.zerocopied = false,
+		.so_zerocopy = true,
+		.sendmsg_errno = 0,
+		.vecs_cnt = 1,
+		{
+			{ NULL, 100 * PAGE_SIZE }
+		}
+	},
+};
+
+#define POLL_TIMEOUT_MS		100
+
+static void test_client(const struct test_opts *opts,
+			const struct vsock_test_data *test_data,
+			bool sock_seqpacket)
+{
+	struct pollfd fds = { 0 };
+	struct msghdr msg = { 0 };
+	ssize_t sendmsg_res;
+	struct iovec *iovec;
+	int fd;
+
+	if (sock_seqpacket)
+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	else
+		fd = vsock_stream_connect(opts->peer_cid, 1234);
+
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	if (test_data->so_zerocopy)
+		enable_so_zerocopy(fd);
+
+	iovec = iovec_from_test_data(test_data->vecs, test_data->vecs_cnt);
+
+	msg.msg_iov = iovec;
+	msg.msg_iovlen = test_data->vecs_cnt;
+
+	errno = 0;
+
+	sendmsg_res = sendmsg(fd, &msg, MSG_ZEROCOPY);
+	if (errno != test_data->sendmsg_errno) {
+		fprintf(stderr, "expected 'errno' == %i, got %i\n",
+			test_data->sendmsg_errno, errno);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!errno) {
+		if (sendmsg_res != iovec_bytes(iovec, test_data->vecs_cnt)) {
+			fprintf(stderr, "expected 'sendmsg()' == %li, got %li\n",
+				iovec_bytes(iovec, test_data->vecs_cnt),
+				sendmsg_res);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	fds.fd = fd;
+	fds.events = 0;
+
+	if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
+		perror("poll");
+		exit(EXIT_FAILURE);
+	}
+
+	if (fds.revents & POLLERR) {
+		vsock_recv_completion(fd, &test_data->zerocopied);
+	} else if (test_data->so_zerocopy && !test_data->sendmsg_errno) {
+		/* If we don't have data in the error queue, but
+		 * SO_ZEROCOPY was enabled and 'sendmsg()' was
+		 * successful - this is an error.
+		 */
+		fprintf(stderr, "POLLERR expected\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!test_data->sendmsg_errno)
+		control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
+	else
+		control_writeulong(0);
+
+	control_writeln("DONE");
+	free_iovec_test_data(test_data->vecs, iovec, test_data->vecs_cnt);
+	close(fd);
+}
+
+void test_stream_msgzcopy_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		test_client(opts, &test_data_array[i], false);
+}
+
+void test_seqpacket_msgzcopy_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
+		if (test_data_array[i].stream_only)
+			continue;
+
+		test_client(opts, &test_data_array[i], true);
+	}
+}
+
+static void test_server(const struct test_opts *opts,
+			const struct vsock_test_data *test_data,
+			bool sock_seqpacket)
+{
+	unsigned long remote_hash;
+	unsigned long local_hash;
+	ssize_t total_bytes_rec;
+	unsigned char *data;
+	size_t data_len;
+	int fd;
+
+	if (sock_seqpacket)
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	else
+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+
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
+	total_bytes_rec = 0;
+
+	while (total_bytes_rec != data_len) {
+		ssize_t bytes_rec;
+
+		bytes_rec = read(fd, data + total_bytes_rec,
+				 data_len - total_bytes_rec);
+		if (bytes_rec <= 0)
+			break;
+
+		total_bytes_rec += bytes_rec;
+	}
+
+	if (test_data->sendmsg_errno == 0)
+		local_hash = hash_djb2(data, data_len);
+	else
+		local_hash = 0;
+
+	free(data);
+
+	/* Waiting for some result. */
+	remote_hash = control_readulong();
+	if (remote_hash != local_hash) {
+		fprintf(stderr, "hash mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	close(fd);
+}
+
+void test_stream_msgzcopy_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		test_server(opts, &test_data_array[i], false);
+}
+
+void test_seqpacket_msgzcopy_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
+		if (test_data_array[i].stream_only)
+			continue;
+
+		test_server(opts, &test_data_array[i], true);
+	}
+}
+
+void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts)
+{
+	struct msghdr msg = { 0 };
+	char cmsg_data[128];
+	ssize_t res;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (res != -1) {
+		fprintf(stderr, "expected 'recvmsg(2)' failure, got %zi\n",
+			res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("DONE");
+	close(fd);
+}
+
+void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	close(fd);
+}
diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
new file mode 100644
index 000000000000..3ef2579e024d
--- /dev/null
+++ b/tools/testing/vsock/vsock_test_zerocopy.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef VSOCK_TEST_ZEROCOPY_H
+#define VSOCK_TEST_ZEROCOPY_H
+#include "util.h"
+
+void test_stream_msgzcopy_client(const struct test_opts *opts);
+void test_stream_msgzcopy_server(const struct test_opts *opts);
+
+void test_seqpacket_msgzcopy_client(const struct test_opts *opts);
+void test_seqpacket_msgzcopy_server(const struct test_opts *opts);
+
+void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts);
+void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts);
+
+#endif /* VSOCK_TEST_ZEROCOPY_H */
-- 
2.25.1

