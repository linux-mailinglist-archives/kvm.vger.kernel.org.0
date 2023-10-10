Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274C57C047B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 21:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjJJTX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 15:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343926AbjJJTXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 15:23:11 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0515B9E;
        Tue, 10 Oct 2023 12:23:01 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 46365100012;
        Tue, 10 Oct 2023 22:22:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 46365100012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696965768;
        bh=hyIGlf+ofcmewsxGX6OnpFcWfx6UKAX91IJ5SwaELh0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=Pk/CSw4uydWBeqerNqUh/IlmIbcE7UPQuaYMK+7BciQ322qytITSWFcVOItM1uUsI
         XM9fmRDFW6dGe4H7Tc5/JdrOMA7+bdjgRVfYTV84TXvFKirls/R4I9hMjS974G6Bph
         bSKvygT1cAZ1qr9bHPY474zxOt1F1ORKuKJR014671uawmX+lIk7r3EcDdkI38KtEk
         jG3v7/LsbSlJb+FFFY8OPkZBXxIjCgFXjGoQ0B3f0blgxylzhIch9d1hk2iGxzSN8N
         5O6/XouMVHlu86DBrkt0HTsRDTUTZJkwZwYjySUcw0yQXi2yFEnoYMwg81aaInF+Mm
         QGmaCXQUU6k2g==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 10 Oct 2023 22:22:48 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 10 Oct 2023 22:22:47 +0300
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
Subject: [PATCH net-next v4 11/12] test/vsock: MSG_ZEROCOPY support for vsock_perf
Date:   Tue, 10 Oct 2023 22:15:23 +0300
Message-ID: <20231010191524.1694217-12-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180515 [Oct 10 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 536 536 1ae19c7800f69da91432b5e67ed4a00b9ade0d03, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/10 16:15:00 #22148151
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

To use this option pass '--zerocopy' parameter:

./vsock_perf --zerocopy --sender <cid> ...

With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 Changelog:
 v1 -> v2:
  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
 v2 -> v3:
  * Use 'msg_zerocopy_common.h' for MSG_ZEROCOPY related things.
  * Rename '--zc' option to '--zerocopy'.
  * Add detail in help that zerocopy mode is for sender mode only.
 v3 -> v4:
  * Keep R-b from v3, despite updating 'Makefile' by adding new obj
    file - msg_zerocopy_common.o.

 tools/testing/vsock/Makefile     |  2 +-
 tools/testing/vsock/vsock_perf.c | 80 ++++++++++++++++++++++++++++----
 2 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index bb938e4790b5..228470ae33c2 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -3,7 +3,7 @@ all: test vsock_perf
 test: vsock_test vsock_diag_test
 vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o msg_zerocopy_common.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
-vsock_perf: vsock_perf.o
+vsock_perf: vsock_perf.o msg_zerocopy_common.o
 
 CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
index a72520338f84..4e8578f815e0 100644
--- a/tools/testing/vsock/vsock_perf.c
+++ b/tools/testing/vsock/vsock_perf.c
@@ -18,6 +18,9 @@
 #include <poll.h>
 #include <sys/socket.h>
 #include <linux/vm_sockets.h>
+#include <sys/mman.h>
+
+#include "msg_zerocopy_common.h"
 
 #define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
 #define DEFAULT_TO_SEND_BYTES	(64 * 1024)
@@ -31,6 +34,7 @@
 static unsigned int port = DEFAULT_PORT;
 static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
 static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
+static bool zerocopy;
 
 static void error(const char *s)
 {
@@ -252,10 +256,15 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
 	time_t tx_begin_ns;
 	time_t tx_total_ns;
 	size_t total_send;
+	time_t time_in_send;
 	void *data;
 	int fd;
 
-	printf("Run as sender\n");
+	if (zerocopy)
+		printf("Run as sender MSG_ZEROCOPY\n");
+	else
+		printf("Run as sender\n");
+
 	printf("Connect to %i:%u\n", peer_cid, port);
 	printf("Send %lu bytes\n", to_send_bytes);
 	printf("TX buffer %lu bytes\n", buf_size_bytes);
@@ -265,38 +274,82 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
 	if (fd < 0)
 		exit(EXIT_FAILURE);
 
-	data = malloc(buf_size_bytes);
+	if (zerocopy) {
+		enable_so_zerocopy(fd);
 
-	if (!data) {
-		fprintf(stderr, "'malloc()' failed\n");
-		exit(EXIT_FAILURE);
+		data = mmap(NULL, buf_size_bytes, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (data == MAP_FAILED) {
+			perror("mmap");
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		data = malloc(buf_size_bytes);
+
+		if (!data) {
+			fprintf(stderr, "'malloc()' failed\n");
+			exit(EXIT_FAILURE);
+		}
 	}
 
 	memset(data, 0, buf_size_bytes);
 	total_send = 0;
+	time_in_send = 0;
 	tx_begin_ns = current_nsec();
 
 	while (total_send < to_send_bytes) {
 		ssize_t sent;
+		size_t rest_bytes;
+		time_t before;
 
-		sent = write(fd, data, buf_size_bytes);
+		rest_bytes = to_send_bytes - total_send;
+
+		before = current_nsec();
+		sent = send(fd, data, (rest_bytes > buf_size_bytes) ?
+			    buf_size_bytes : rest_bytes,
+			    zerocopy ? MSG_ZEROCOPY : 0);
+		time_in_send += (current_nsec() - before);
 
 		if (sent <= 0)
 			error("write");
 
 		total_send += sent;
+
+		if (zerocopy) {
+			struct pollfd fds = { 0 };
+
+			fds.fd = fd;
+
+			if (poll(&fds, 1, -1) < 0) {
+				perror("poll");
+				exit(EXIT_FAILURE);
+			}
+
+			if (!(fds.revents & POLLERR)) {
+				fprintf(stderr, "POLLERR expected\n");
+				exit(EXIT_FAILURE);
+			}
+
+			vsock_recv_completion(fd, NULL);
+		}
 	}
 
 	tx_total_ns = current_nsec() - tx_begin_ns;
 
 	printf("total bytes sent: %zu\n", total_send);
 	printf("tx performance: %f Gbits/s\n",
-	       get_gbps(total_send * 8, tx_total_ns));
-	printf("total time in 'write()': %f sec\n",
+	       get_gbps(total_send * 8, time_in_send));
+	printf("total time in tx loop: %f sec\n",
 	       (float)tx_total_ns / NSEC_PER_SEC);
+	printf("time in 'send()': %f sec\n",
+	       (float)time_in_send / NSEC_PER_SEC);
 
 	close(fd);
-	free(data);
+
+	if (zerocopy)
+		munmap(data, buf_size_bytes);
+	else
+		free(data);
 }
 
 static const char optstring[] = "";
@@ -336,6 +389,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'R',
 	},
+	{
+		.name = "zerocopy",
+		.has_arg = no_argument,
+		.val = 'Z',
+	},
 	{},
 };
 
@@ -351,6 +409,7 @@ static void usage(void)
 	       "  --help			This message\n"
 	       "  --sender   <cid>		Sender mode (receiver default)\n"
 	       "                                <cid> of the receiver to connect to\n"
+	       "  --zerocopy			Enable zerocopy (for sender mode only)\n"
 	       "  --port     <port>		Port (default %d)\n"
 	       "  --bytes    <bytes>KMG		Bytes to send (default %d)\n"
 	       "  --buf-size <bytes>KMG		Data buffer size (default %d). In sender mode\n"
@@ -413,6 +472,9 @@ int main(int argc, char **argv)
 		case 'H': /* Help. */
 			usage();
 			break;
+		case 'Z': /* Zerocopy. */
+			zerocopy = true;
+			break;
 		default:
 			usage();
 		}
-- 
2.25.1

