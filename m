Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F076E1906
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjDNA1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 20:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjDNA0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 20:26:44 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A2E4680
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:26:05 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id ay11so96451qtb.10
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 17:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681431964; x=1684023964;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfBI8GoEpVlIoOUgpQuqqFCS5QSMelByqywlut0pb20=;
        b=f5WeY63NGelZ6exnt0mYQlBCiBMkK2dEYltwEITstKwGHlnD8gbOn5NeTljftZSjs1
         Xw/61gi67+nbaSLCPXVJ0LfSyycFHYs85sFmRbMLDQ3WnlcOnjM1IwAC2BN43FcFQTzm
         qkUvNoEE99tlEcA520fYvV9Wwu3owsvqcHANuxC0saL/tomeOFIZMwxuwxLFs/KFqKgg
         7QtGMmNid1e7lWPYFFL6FiFZKxDV0udTbQP7bZ6g6jcMU6nY2DEl55MTJ37oxfiv8/me
         w9O1T10DSREi/U8BW1dzi71vivFpmsXyc8BtAUC2e58hLJHIrXq9Loh5wUwH7mNasKYe
         xI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681431964; x=1684023964;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfBI8GoEpVlIoOUgpQuqqFCS5QSMelByqywlut0pb20=;
        b=X96JUsLbGwOukRLTEks/ClahqLSjaf61aVTaM0pmtHPa7Kr2J77Hn9XqxxniA8ZD0y
         I87Q3Djt+Z67f/COsmKnR8pDKBl2revz4Xs3En6OL4yH2xtKSXE93HdmKAZbpWJSFl+K
         MS1nO1PLvKfvho7k9I/eY6oT9VxeawIzUQH4M6fqH11N+uAgQ3P30myD/Hxyy2pR4aci
         EmxA0jF/KxFnnashx7fSBBgfaMb1GL2aZpwPQj04piXp1DlzHX9ZZtscwBmPpQFCYnVN
         sKy9ZucMB8q6XIJEqS+oIO69pa1AzyVlIQqYHhMrQbSYrPxksmX/jpdCMdxb/793iQyt
         nT8A==
X-Gm-Message-State: AAQBX9dmS4GU3mFFiMIOWVq04TW+E/Xg7uBibBRyZ2e+cL+Am2nCSM49
        GexfnUTicMkps/e+FDPRZCvMgg==
X-Google-Smtp-Source: AKy350bU87AYbKuY6TwWSw6wGD1ygUr7c40clsRGzMOmOPGVuEFqgw1QPN3TKpFJwKxocYnukMn2sQ==
X-Received: by 2002:a05:622a:11ca:b0:3d8:fd72:b4b5 with SMTP id n10-20020a05622a11ca00b003d8fd72b4b5mr7308187qtk.31.1681431964366;
        Thu, 13 Apr 2023 17:26:04 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.122])
        by smtp.gmail.com with ESMTPSA id a1-20020ac844a1000000b003eabcc29132sm309928qto.29.2023.04.13.17.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 17:26:03 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Fri, 14 Apr 2023 00:26:00 +0000
Subject: [PATCH RFC net-next v2 4/4] tests: add vsock dgram tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v2-4-079cc7cee62e@bytedance.com>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
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
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jiang Wang <jiang.wang@bytedance.com>

This patch adds tests for vsock datagram.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 tools/testing/vsock/util.c       | 105 +++++++++++++++++++++
 tools/testing/vsock/util.h       |   4 +
 tools/testing/vsock/vsock_test.c | 193 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 302 insertions(+)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 01b636d3039a..45e35da48b40 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -260,6 +260,57 @@ void send_byte(int fd, int expected_ret, int flags)
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
@@ -313,6 +364,60 @@ void recv_byte(int fd, int expected_ret, int flags)
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
index fb99208a95ea..6e5cd610bf05 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -43,7 +43,11 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
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
index ac1bd3ac1533..851c3d65178d 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -202,6 +202,113 @@ static void test_stream_server_close_server(const struct test_opts *opts)
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
+	int fd;
+	int len = sizeof(addr.sa);
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
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
+	int fd;
+	int ret;
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
 /* With the standard socket sizes, VMCI is able to support about 100
  * concurrent stream connections.
  */
@@ -255,6 +362,77 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 		close(fds[i]);
 }
 
+static void test_dgram_multiconn_client(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
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
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		sendto_byte(fds[i], &addr.sa, sizeof(addr.svm), 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_dgram_multiconn_server(const struct test_opts *opts)
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
+	int fd;
+	int len = sizeof(addr.sa);
+	int i;
+
+	fd = socket(AF_VSOCK, SOCK_DGRAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Notify the client that the server is ready */
+	control_writeln("BIND");
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		recvfrom_byte(fd, &addr.sa, &len, 1, 0);
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
 static void test_stream_msg_peek_client(const struct test_opts *opts)
 {
 	int fd;
@@ -1128,6 +1306,21 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_DGRAM client close",
+		.run_client = test_dgram_sendto_client,
+		.run_server = test_dgram_sendto_server,
+	},
+	{
+		.name = "SOCK_DGRAM client connect",
+		.run_client = test_dgram_connect_client,
+		.run_server = test_dgram_connect_server,
+	},
+	{
+		.name = "SOCK_DGRAM multiple connections",
+		.run_client = test_dgram_multiconn_client,
+		.run_server = test_dgram_multiconn_server,
+	},
 	{},
 };
 

-- 
2.30.2

