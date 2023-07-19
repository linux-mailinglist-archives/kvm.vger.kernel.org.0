Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0543758A62
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjGSAvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjGSAvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:51:07 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64B81FD7
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:22 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-7653bd3ff2fso692935485a.3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727821; x=1692319821;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zcl4aN/43X4Lf9KimpBG0GZiJLNoqreLRjXoCG4dakY=;
        b=HoM9cbyI5odaUiKbIqWF35MzV6k1piobOfjvDaSFB9OOJS1Yx4Z+K6kIPk7ETDiTzw
         d/BEP+F2Vq7VE7SwglxHtkmOyah0R4rKrMTv1WFPOGAxmPlVkkAq9LYs8pnU2hpIYNq3
         qxE/B+1A89StKhWCZoSo1xIRsAOj3ZfCQoq4j0WopnOueetRbBr0DyiAp/Cdr9i0Nxnv
         yF/7JsU1pTbRTnncKkWPb+HxalipkEp4pEspbEtwITisOatAEsoM0w55Ax7u7p5i1W9J
         koCu8uSPpJ4uZbCyo2CCJmHzuUUxbR2MbGgzDJxeC90hDwd2aKcwtx99mSZPUMZwi6ei
         AIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727821; x=1692319821;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zcl4aN/43X4Lf9KimpBG0GZiJLNoqreLRjXoCG4dakY=;
        b=aXavzZdTCJsZciSUh3zLM5kQzqk7YyugoNGf4snukX29v/dCpkes/BAomRdqKz9i10
         AQeGowlsZPFY3D7uuPXAdQjHwA++h7ItfDqJZ7PZOP5LGlrQ2k4jl4Tmiv7dkLAfkRRB
         GsZpwO7MWDumXbRQ1uLl60CieypQgEIidUrZJy5CKyGhWCV/AHJ16WgfEnJKQu+d7nz2
         NOnSi23e/1u1ppAsdAICPxUMPn3nL5CH4/ehMKfm1FG+sg3OX4ETYNJjJ9uiqvdsssqT
         vaod43ptNwgkymJlf9jSIDxPFm75Pxx4tJQuOOBhPgKkwRfzD1LciL6B/JRFbCTd7tOw
         9U1w==
X-Gm-Message-State: ABy/qLZulp8mZIs3iYinCX0Qh1aEU65Ce3tDLmwV3dTK/fVVgV/mO31L
        SeMDT6+ycJ/ErG318ENMgyotYg==
X-Google-Smtp-Source: APBJJlHIWaVJAEEmSxRjgHP7yBN8AFpmk0bnBtVK/JcEbs1WnCV4LaY70/t+Bpe9TQIrwzq3st5Apg==
X-Received: by 2002:a05:620a:1a09:b0:767:39c5:652d with SMTP id bk9-20020a05620a1a0900b0076739c5652dmr6310672qkb.64.1689727821151;
        Tue, 18 Jul 2023 17:50:21 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:20 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:18 +0000
Subject: [PATCH RFC net-next v5 14/14] test/vsock: add vsock dgram tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-14-581bd37fdb26@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiang Wang <jiang.wang@bytedance.com>

This commit adds tests for vsock datagram.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 tools/testing/vsock/util.c       | 141 +++++++-
 tools/testing/vsock/util.h       |   6 +
 tools/testing/vsock/vsock_test.c | 680 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 826 insertions(+), 1 deletion(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 01b636d3039a..811e70d7cf1e 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -99,7 +99,8 @@ static int vsock_connect(unsigned int cid, unsigned int port, int type)
 	int ret;
 	int fd;
 
-	control_expectln("LISTENING");
+	if (type != SOCK_DGRAM)
+		control_expectln("LISTENING");
 
 	fd = socket(AF_VSOCK, type, 0);
 
@@ -130,6 +131,11 @@ int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
 	return vsock_connect(cid, port, SOCK_SEQPACKET);
 }
 
+int vsock_dgram_connect(unsigned int cid, unsigned int port)
+{
+	return vsock_connect(cid, port, SOCK_DGRAM);
+}
+
 /* Listen on <cid, port> and return the first incoming connection.  The remote
  * address is stored to clientaddrp.  clientaddrp may be NULL.
  */
@@ -211,6 +217,34 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
 }
 
+int vsock_dgram_bind(unsigned int cid, unsigned int port)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = port,
+			.svm_cid = cid,
+		},
+	};
+	int fd;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return fd;
+}
+
 /* Transmit one byte and check the return value.
  *
  * expected_ret:
@@ -260,6 +294,57 @@ void send_byte(int fd, int expected_ret, int flags)
 	}
 }
 
+/* Transmit one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
+		 int flags)
+{
+	const uint8_t byte = 'A';
+	ssize_t nwritten;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nwritten = sendto(fd, &byte, sizeof(byte), flags, dest_addr,
+				  len);
+		timeout_check("write");
+	} while (nwritten < 0 && errno == EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nwritten != -1) {
+			fprintf(stderr, "bogus sendto(2) return value %zd\n",
+				nwritten);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("write");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nwritten < 0) {
+		perror("write");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten == 0) {
+		if (expected_ret == 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while sending byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nwritten != sizeof(byte)) {
+		fprintf(stderr, "bogus sendto(2) return value %zd\n", nwritten);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /* Receive one byte and check the return value.
  *
  * expected_ret:
@@ -313,6 +398,60 @@ void recv_byte(int fd, int expected_ret, int flags)
 	}
 }
 
+/* Receive one byte and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
+		   int expected_ret, int flags)
+{
+	uint8_t byte;
+	ssize_t nread;
+
+	timeout_begin(TIMEOUT);
+	do {
+		nread = recvfrom(fd, &byte, sizeof(byte), flags, src_addr, addrlen);
+		timeout_check("read");
+	} while (nread < 0 && errno == EINTR);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nread != -1) {
+			fprintf(stderr, "bogus recvfrom(2) return value %zd\n",
+				nread);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("read");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (nread < 0) {
+		perror("read");
+		exit(EXIT_FAILURE);
+	}
+	if (nread == 0) {
+		if (expected_ret == 0)
+			return;
+
+		fprintf(stderr, "unexpected EOF while receiving byte\n");
+		exit(EXIT_FAILURE);
+	}
+	if (nread != sizeof(byte)) {
+		fprintf(stderr, "bogus recvfrom(2) return value %zd\n", nread);
+		exit(EXIT_FAILURE);
+	}
+	if (byte != 'A') {
+		fprintf(stderr, "unexpected byte read %c\n", byte);
+		exit(EXIT_FAILURE);
+	}
+}
+
 /* Run test cases.  The program terminates if a failure occurs. */
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts)
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index fb99208a95ea..a69e128d120c 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -37,13 +37,19 @@ void init_signals(void);
 unsigned int parse_cid(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
+int vsock_dgram_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
+int vsock_dgram_bind(unsigned int cid, unsigned int port);
 void vsock_wait_remote_close(int fd);
 void send_byte(int fd, int expected_ret, int flags);
+void sendto_byte(int fd, const struct sockaddr *dest_addr, int len, int expected_ret,
+		 int flags);
 void recv_byte(int fd, int expected_ret, int flags);
+void recvfrom_byte(int fd, struct sockaddr *src_addr, socklen_t *addrlen,
+		   int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
 void list_tests(const struct test_case *test_cases);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..c9904a3376ce 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
+#include <linux/errqueue.h>
 #include <linux/kernel.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -24,6 +25,12 @@
 #include "control.h"
 #include "util.h"
 
+#ifndef SOL_VSOCK
+#define SOL_VSOCK 287
+#endif
+
+#define DGRAM_MSG_CNT 16
+
 static void test_stream_connection_reset(const struct test_opts *opts)
 {
 	union {
@@ -1053,6 +1060,644 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_dgram_sendto_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int fd;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	sendto_byte(fd, &addr.sa, sizeof(addr.svm), 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_sendto_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	unsigned long sock_buf_size;
+	int len = sizeof(addr.sa);
+	int fd;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Set receive buffer to maximum */
+	sock_buf_size = -1;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
+		       &sock_buf_size, sizeof(sock_buf_size))) {
+		perror("setsockopt(SO_RECVBUF)");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	recvfrom_byte(fd, &addr.sa, &len, 1, 0);
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_connect_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int ret;
+	int fd;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = connect(fd, &addr.sa, sizeof(addr.svm));
+	if (ret < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_connect_server(const struct test_opts *opts)
+{
+	test_dgram_sendto_server(opts);
+}
+
+static void test_dgram_multiconn_sendto_client(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int fds[MULTICONN_NFDS];
+	int i;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		fds[i] = socket(AF_VSOCK, SOCK_DGRAM, 0);
+		if (fds[i] < 0) {
+			perror("socket");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		sendto_byte(fds[i], &addr.sa, sizeof(addr.svm), 1, 0);
+
+		/* This is here to make explicit the case of the test failing
+		 * due to packet loss. The test fails when recv() times out
+		 * otherwise, which is much more confusing.
+		 */
+		control_expectln("PKTRECV");
+	}
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_dgram_multiconn_sendto_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	int len = sizeof(addr.sa);
+	int fd;
+	int i;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		recvfrom_byte(fd, &addr.sa, &len, 1, 0);
+		control_writeln("PKTRECV");
+	}
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_multiconn_send_client(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
+
+	/* Wait for the server to be ready */
+	control_expectln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		fds[i] = vsock_dgram_connect(opts->peer_cid, 1234);
+		if (fds[i] < 0) {
+			perror("connect");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		send_byte(fds[i], 1, 0);
+		/* This is here to make explicit the case of the test failing
+		 * due to packet loss.
+		 */
+		control_expectln("PKTRECV");
+	}
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_dgram_multiconn_send_server(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = VMADDR_CID_ANY,
+		},
+	};
+	unsigned long sock_buf_size;
+	int fd;
+	int i;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Set receive buffer to maximum */
+	sock_buf_size = -1;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
+		       &sock_buf_size, sizeof(sock_buf_size))) {
+		perror("setsockopt(SO_RECVBUF)");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		recv_byte(fd, 1, 0);
+		control_writeln("PKTRECV");
+	}
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+/*
+ * This test is similar to the seqpacket msg bounds tests, but it is unreliable
+ * because it may also fail in the unlikely case that packets are dropped.
+ */
+static void test_dgram_bounds_unreliable_client(const struct test_opts *opts)
+{
+	unsigned long recv_buf_size;
+	unsigned long *hashes;
+	int page_size;
+	int fd;
+	int i;
+
+	fd = vsock_dgram_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	hashes = malloc(DGRAM_MSG_CNT * sizeof(unsigned long));
+	if (!hashes) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Let the server know the client is ready */
+	control_writeln("CLNTREADY");
+
+	/* Wait, until receiver sets buffer size. */
+	control_expectln("SRVREADY");
+
+	recv_buf_size = control_readulong();
+
+	page_size = getpagesize();
+
+	for (i = 0; i < DGRAM_MSG_CNT; i++) {
+		ssize_t send_size;
+		size_t buf_size;
+		void *buf;
+
+		/* Use "small" buffers and "big" buffers. */
+		if (opts->peer_cid <= VMADDR_CID_HOST && (i & 1))
+			buf_size = page_size +
+					(rand() % (MAX_MSG_SIZE - page_size));
+		else
+			buf_size = 1 + (rand() % page_size);
+
+		buf_size = min(buf_size, recv_buf_size);
+
+		buf = malloc(buf_size);
+
+		if (!buf) {
+			perror("malloc");
+			exit(EXIT_FAILURE);
+		}
+
+		memset(buf, rand() & 0xff, buf_size);
+
+		send_size = send(fd, buf, buf_size, 0);
+		if (send_size < 0) {
+			perror("send");
+			exit(EXIT_FAILURE);
+		}
+
+		if (send_size != buf_size) {
+			fprintf(stderr, "Invalid send size\n");
+			exit(EXIT_FAILURE);
+		}
+
+		/* In theory the implementation isn't required to transmit
+		 * these packets in order, so we use this PKTSENT/PKTRECV
+		 * message sequence so that server and client coordinate
+		 * sending and receiving one packet at a time. The client sends
+		 * a packet and waits until it has been received before sending
+		 * another.
+		 *
+		 * Also in theory these packets can be lost and the test will
+		 * fail for that reason.
+		 */
+		control_writeln("PKTSENT");
+		control_expectln("PKTRECV");
+
+		/* Send the server a hash of the packet */
+		hashes[i] = hash_djb2(buf, buf_size);
+		free(buf);
+	}
+
+	control_writeln("SENDDONE");
+	close(fd);
+
+	for (i = 0; i < DGRAM_MSG_CNT; i++) {
+		if (hashes[i] != control_readulong())
+			fprintf(stderr, "broken dgram message bounds or packet loss\n");
+	}
+	free(hashes);
+}
+
+static void test_dgram_bounds_unreliable_server(const struct test_opts *opts)
+{
+	unsigned long hashes[DGRAM_MSG_CNT];
+	unsigned long sock_buf_size;
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	char buf[MAX_MSG_SIZE];
+	socklen_t len;
+	int fd;
+	int i;
+
+	fd = vsock_dgram_bind(VMADDR_CID_ANY, 1234);
+	if (fd < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Set receive buffer to maximum */
+	sock_buf_size = -1;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF,
+		       &sock_buf_size, sizeof(sock_buf_size))) {
+		perror("setsockopt(SO_RECVBUF)");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Retrieve the receive buffer size */
+	len = sizeof(sock_buf_size);
+	if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF,
+		       &sock_buf_size, &len)) {
+		perror("getsockopt(SO_RECVBUF)");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Client ready to receive parameters */
+	control_expectln("CLNTREADY");
+
+	/* Ready to receive data. */
+	control_writeln("SRVREADY");
+
+	if (opts->peer_cid > VMADDR_CID_HOST)
+		control_writeulong(sock_buf_size);
+	else
+		control_writeulong(getpagesize());
+
+	iov.iov_base = buf;
+	iov.iov_len = sizeof(buf);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	for (i = 0; i < DGRAM_MSG_CNT; i++) {
+		ssize_t recv_size;
+
+		control_expectln("PKTSENT");
+		recv_size = recvmsg(fd, &msg, 0);
+		control_writeln("PKTRECV");
+
+		if (!recv_size)
+			break;
+
+		if (recv_size < 0) {
+			perror("recvmsg");
+			exit(EXIT_FAILURE);
+		}
+
+		hashes[i] = hash_djb2(msg.msg_iov[0].iov_base, recv_size);
+	}
+
+	control_expectln("SENDDONE");
+
+	close(fd);
+
+	for (i = 0; i < DGRAM_MSG_CNT; i++)
+		control_writeulong(hashes[i]);
+}
+
+#define POLL_TIMEOUT_MS		1000
+void vsock_recv_error(int fd)
+{
+	struct sock_extended_err *serr;
+	struct msghdr msg = { 0 };
+	struct pollfd fds = { 0 };
+	char cmsg_data[128];
+	struct cmsghdr *cm;
+	ssize_t res;
+
+	fds.fd = fd;
+	fds.events = 0;
+
+	if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
+		perror("poll");
+		exit(EXIT_FAILURE);
+	}
+
+	if (!(fds.revents & POLLERR)) {
+		fprintf(stderr, "POLLERR expected\n");
+		exit(EXIT_FAILURE);
+	}
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
+	if (cm->cmsg_type != 0) {
+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	serr = (void *)CMSG_DATA(cm);
+	if (serr->ee_origin != 0) {
+		fprintf(stderr, "serr: unexpected 'ee_origin'\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (serr->ee_errno != EHOSTUNREACH) {
+		fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
+		exit(EXIT_FAILURE);
+	}
+}
+
+/*
+ * Attempt to send a packet larger than the client's RX buffer. Test that the
+ * packet was dropped and that there is an error in the error queue.
+ */
+static void test_dgram_drop_big_packets_server(const struct test_opts *opts)
+{
+	unsigned long client_rx_buf_size;
+	size_t buf_size;
+	void *buf;
+	int fd;
+
+	if (opts->peer_cid <= VMADDR_CID_HOST) {
+		printf("The server's peer must be a guest (not CID %u), skipped...\n",
+		       opts->peer_cid);
+		return;
+	}
+
+	/* Wait for the server to be ready */
+	control_expectln("READY");
+
+	fd = vsock_dgram_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	client_rx_buf_size = control_readulong();
+
+	buf_size = client_rx_buf_size + 1;
+	buf = malloc(buf_size);
+	if (!buf) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Even though the buffer is exceeded, the send() should still succeed. */
+	if (send(fd, buf, buf_size, 0) < 0) {
+		perror("send");
+		exit(EXIT_FAILURE);
+	}
+
+	vsock_recv_error(fd);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_drop_big_packets_client(const struct test_opts *opts)
+{
+	unsigned long buf_size = getpagesize();
+
+	if (opts->peer_cid > VMADDR_CID_HOST) {
+		printf("The client's peer must be the host (not CID %u), skipped...\n",
+		       opts->peer_cid);
+		return;
+	}
+
+	control_writeln("READY");
+	control_writeulong(buf_size);
+	control_expectln("DONE");
+}
+
+static void test_stream_dgram_address_collision_client(const struct test_opts *opts)
+{
+	int dgram_fd, stream_fd;
+
+	stream_fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (stream_fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	/* This simply tests if connect() causes address collision client-side.
+	 * Keep in mind that there is no exchange of packets with the
+	 * bound socket on the server.
+	 */
+	dgram_fd = vsock_dgram_connect(opts->peer_cid, 1234);
+	if (dgram_fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	close(stream_fd);
+	close(dgram_fd);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+}
+
+static void test_stream_dgram_address_collision_server(const struct test_opts *opts)
+{
+	int dgram_fd, stream_fd;
+	struct sockaddr_vm addr;
+	socklen_t addrlen;
+
+	stream_fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, 0);
+	if (stream_fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Retrieve the CID/port for re-use. */
+	addrlen = sizeof(addr);
+	if (getsockname(stream_fd, (struct sockaddr *)&addr, &addrlen)) {
+		perror("getsockname");
+		exit(EXIT_FAILURE);
+	}
+
+	/* See not in the client function about the pairwise connect call. */
+	dgram_fd = vsock_dgram_bind(addr.svm_cid, addr.svm_port);
+	if (dgram_fd < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+
+	close(stream_fd);
+	close(dgram_fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1128,6 +1773,41 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_DGRAM client sendto",
+		.run_client = test_dgram_sendto_client,
+		.run_server = test_dgram_sendto_server,
+	},
+	{
+		.name = "SOCK_DGRAM client connect",
+		.run_client = test_dgram_connect_client,
+		.run_server = test_dgram_connect_server,
+	},
+	{
+		.name = "SOCK_DGRAM multiple connections using sendto",
+		.run_client = test_dgram_multiconn_sendto_client,
+		.run_server = test_dgram_multiconn_sendto_server,
+	},
+	{
+		.name = "SOCK_DGRAM multiple connections using send",
+		.run_client = test_dgram_multiconn_send_client,
+		.run_server = test_dgram_multiconn_send_server,
+	},
+	{
+		.name = "SOCK_DGRAM msg bounds unreliable",
+		.run_client = test_dgram_bounds_unreliable_client,
+		.run_server = test_dgram_bounds_unreliable_server,
+	},
+	{
+		.name = "SOCK_DGRAM drop big packets",
+		.run_client = test_dgram_drop_big_packets_client,
+		.run_server = test_dgram_drop_big_packets_server,
+	},
+	{
+		.name = "SOCK_STREAM and SOCK_DGRAM address collision",
+		.run_client = test_stream_dgram_address_collision_client,
+		.run_server = test_stream_dgram_address_collision_server,
+	},
 	{},
 };
 

-- 
2.30.2

