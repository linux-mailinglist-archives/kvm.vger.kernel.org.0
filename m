Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC277B43BB
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjI3VKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 17:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbjI3VKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 17:10:35 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCF0E6;
        Sat, 30 Sep 2023 14:10:31 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 2AD8A120008;
        Sun,  1 Oct 2023 00:10:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 2AD8A120008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696108230;
        bh=fEJQti7ceoE6AyBEhx+DKLgL95M2rOp2QmrRdlL9YHI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=iw+5ABCRQUf2C0CsGwjO356cs/40j/4RF4HNTe1VYGPR4yqU9XjeRgIE+Lisylce4
         20PR48IHalSe4J14e7CbR0C2VQYdiGCoL9ASCQ09uUoyW3GRkKxmm3yLtHa9acjmIo
         Oq16rhaIomA3V9gwlkdK1j65+KPRVMRenN4AfWrGs7Jj0v+b3luzDwjVvMH0o+UTBZ
         s6l2csM1dkiWfL+hIX8Rkugt/SH6Z5srgORmAT6GA1zLdgH17AQoQfym7Fwbldj/gG
         fMMNHpiJd0kM+O6mPwbbRc+7GRriH8Km7sOXV6dx/XXoACb6aQUZRnLAhWPrrdqQWo
         6tiXIoYJrZPHA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sun,  1 Oct 2023 00:10:29 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sun, 1 Oct 2023 00:10:29 +0300
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
Subject: [PATCH net-next v2 11/12] test/vsock: MSG_ZEROCOPY support for vsock_perf
Date:   Sun, 1 Oct 2023 00:03:07 +0300
Message-ID: <20230930210308.2394919-12-avkrasnov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
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

To use this option pass '--zc' parameter:

./vsock_perf --zc --sender <cid> --port <port> --bytes <bytes to send>

With this option MSG_ZEROCOPY flag will be passed to the 'send()' call.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 tools/testing/vsock/vsock_perf.c | 143 +++++++++++++++++++++++++++++--
 1 file changed, 134 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
index a72520338f84..f0f183f3f9e8 100644
--- a/tools/testing/vsock/vsock_perf.c
+++ b/tools/testing/vsock/vsock_perf.c
@@ -18,6 +18,8 @@
 #include <poll.h>
 #include <sys/socket.h>
 #include <linux/vm_sockets.h>
+#include <sys/mman.h>
+#include <linux/errqueue.h>
 
 #define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
 #define DEFAULT_TO_SEND_BYTES	(64 * 1024)
@@ -28,9 +30,18 @@
 #define BYTES_PER_GB		(1024 * 1024 * 1024ULL)
 #define NSEC_PER_SEC		(1000000000ULL)
 
+#ifndef SOL_VSOCK
+#define SOL_VSOCK	287
+#endif
+
+#ifndef VSOCK_RECVERR
+#define VSOCK_RECVERR	1
+#endif
+
 static unsigned int port = DEFAULT_PORT;
 static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
 static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
+static bool zerocopy;
 
 static void error(const char *s)
 {
@@ -247,15 +258,76 @@ static void run_receiver(unsigned long rcvlowat_bytes)
 	close(fd);
 }
 
+static void recv_completion(int fd)
+{
+	struct sock_extended_err *serr;
+	char cmsg_data[128];
+	struct cmsghdr *cm;
+	struct msghdr msg = { 0 };
+	ssize_t ret;
+
+	msg.msg_control = cmsg_data;
+	msg.msg_controllen = sizeof(cmsg_data);
+
+	ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
+	if (ret) {
+		fprintf(stderr, "recvmsg: failed to read err: %zi\n", ret);
+		return;
+	}
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (!cm) {
+		fprintf(stderr, "cmsg: no cmsg\n");
+		return;
+	}
+
+	if (cm->cmsg_level != SOL_VSOCK) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
+		return;
+	}
+
+	if (cm->cmsg_type != VSOCK_RECVERR) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
+		return;
+	}
+
+	serr = (void *)CMSG_DATA(cm);
+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
+		fprintf(stderr, "serr: wrong origin\n");
+		return;
+	}
+
+	if (serr->ee_errno) {
+		fprintf(stderr, "serr: wrong error code\n");
+		return;
+	}
+
+	if (zerocopy && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED))
+		fprintf(stderr, "warning: copy instead of zerocopy\n");
+}
+
+static void enable_so_zerocopy(int fd)
+{
+	int val = 1;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val)))
+		error("setsockopt(SO_ZEROCOPY)");
+}
+
 static void run_sender(int peer_cid, unsigned long to_send_bytes)
 {
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
@@ -265,38 +337,82 @@ static void run_sender(int peer_cid, unsigned long to_send_bytes)
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
+			recv_completion(fd);
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
@@ -336,6 +452,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'R',
 	},
+	{
+		.name = "zc",
+		.has_arg = no_argument,
+		.val = 'Z',
+	},
 	{},
 };
 
@@ -351,6 +472,7 @@ static void usage(void)
 	       "  --help			This message\n"
 	       "  --sender   <cid>		Sender mode (receiver default)\n"
 	       "                                <cid> of the receiver to connect to\n"
+	       "  --zc				Enable zerocopy\n"
 	       "  --port     <port>		Port (default %d)\n"
 	       "  --bytes    <bytes>KMG		Bytes to send (default %d)\n"
 	       "  --buf-size <bytes>KMG		Data buffer size (default %d). In sender mode\n"
@@ -413,6 +535,9 @@ int main(int argc, char **argv)
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

