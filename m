Return-Path: <kvm+bounces-21359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A51792DB04
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0C0A1F230A3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810DA16D336;
	Wed, 10 Jul 2024 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kf3kZVHe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5CB167DB9;
	Wed, 10 Jul 2024 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646771; cv=none; b=cOsg0OEtC/5eT2X6+kjaGLdG7ZmDLS0sPou1yDmDTG1R/HPxUfgIAS7HgSVxw4LHnf7wHB3wHDJNRL36KbDHeMrXCy0lhJZsHBn6oD2dKlpcImp5VnnywumZFqSQkrJZ/6PPae1WM+yfLnN2yLjcbsfci1HJL7tCCcsztImkCGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646771; c=relaxed/simple;
	bh=sR557xhxwcyuxSZQML21sRSI0z3n25HwRI+vwVpW1cs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LvFQ5KuiTD/a3MtjMtO4y/Vvua+a1/86YcARJ42AOy4Uu3gyZ/0Sqd3Q0d4e8pQLZGWppeFt0YBbTI2whAmTLvU9+tT4rZDNxStLKJqgyNQx3OclObHOLoSu+/fjj/bxQc2VG+S12Qme/fvK9PMNVAXKwkvikFOycaVe5bAFWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kf3kZVHe; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-79f08b01ba6so23494885a.0;
        Wed, 10 Jul 2024 14:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646767; x=1721251567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LswBaYYSMBfng2HelEjAHfOS4oI9VKZFcZ8sUgiEp7g=;
        b=kf3kZVHeW0qVV3j8+wvU/mt2XSlrk2R78KIRil2RTq1EFU+U65SoTH8iX1W9SHFNVB
         bGWPskRkXv9yCNcnpASLV1FnS8DslGjQP2Te3HOFURHonlm1DsS1+dJMRxFlqrhEc1f0
         q+97YPiEYbo5aEiwleicX/xxOJSS4t2PEO0oG+BtBrwMkVLXwT/wokMhhHzsh+Hapnv8
         lLTSnGSYmLHcDZbxnRqA4bKI/RUzD4NCXNhq6x/UXeYU7pUIiroA69XAMtETytNrV/zW
         LCQGW4Q8K8Mnb9DgY1X4wod2HMSAS5zieKXnTpw1mL3p3wzUKpuuL2faLgXk32a4ahtj
         cy3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646767; x=1721251567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LswBaYYSMBfng2HelEjAHfOS4oI9VKZFcZ8sUgiEp7g=;
        b=Je9vqkHKNgoGDxvQ7MVGWKQ72Tjj+/4GFIfGP1ZFJxVpmcp0xcTMpdcWuZtEylBJW5
         Yw5nQJVHVNl9NG30Crl7DWU0K2lNFzwo2TYjhQnxcmkhY9qdITO47Qt07XNHcsuBW74R
         2InDiSSQEQpOD8ucEWoJtczVaBPlsFerOEB4AfpmFOlFik+XdWpkciwKDjIJ+TaoGkE7
         FyCaBdp5hRzb/7ykWqbBqkNk/KygAGkBpgxAjD1eMN+0l3iIdE/ZI1Vtu05DJ+tKRKoa
         aImJPjsAdm6/BgzVMNHl8vJ2+ZipikuyI4tS7F0sSQ0p5bpBxmUUbo7f6bOdf0VW+IIH
         DFgw==
X-Forwarded-Encrypted: i=1; AJvYcCWipevcL6Npq9Pa5MPN6fH2GDblPqL8LlbzT1Ijj63o0zCFCNGyOIHS8kFdKqV6kSGLOZIDpgyXNJ2UR7igxcTQQHXZoOg/qlpgH4NZ/ODFaWhYsGEfVCWVWwEVuzN1ErpijB00Ad9YQNDTQNTUKmkZYpjFhqhQ7rpIMMxo+VzXxmq2riOE9+wiDrmS6UIm/984F+1si+cWcAnqKW0wFGMUT8A4fcFNta92rtRh
X-Gm-Message-State: AOJu0YxYVOAPnSnbpTyHrN2hhdarQMMgZqMvHfreU3+gMIZ4HB7P/iVa
	ohIRAkJ2bIRUl4v2zs9BCV7GgIFrqGp3I/4FHlUCyQnNxjItq+jk
X-Google-Smtp-Source: AGHT+IF6F6bBvVh8TU8NahoCtWH0KM8fFVbY1ljkchcwLXjsOcFl0z2Eaf8Jvw3BKu5aFIWwmTsHfw==
X-Received: by 2002:a05:620a:814:b0:79f:255:c861 with SMTP id af79cd13be357-7a1469fa08fmr138503085a.35.1720646767068;
        Wed, 10 Jul 2024 14:26:07 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:06 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 14/14] test/vsock: add vsock dgram tests
Date: Wed, 10 Jul 2024 21:25:55 +0000
Message-Id: <20240710212555.1617795-15-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

From: Jiang Wang <jiang.wang@bytedance.com>

This commit adds tests for vsock datagram.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 tools/testing/vsock/util.c       |  177 ++++-
 tools/testing/vsock/util.h       |   10 +
 tools/testing/vsock/vsock_test.c | 1032 ++++++++++++++++++++++++++----
 3 files changed, 1099 insertions(+), 120 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 554b290fefdc..14d6cd90ca15 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -154,7 +154,8 @@ static int vsock_connect(unsigned int cid, unsigned int port, int type)
 	int ret;
 	int fd;
 
-	control_expectln("LISTENING");
+	if (type != SOCK_DGRAM)
+		control_expectln("LISTENING");
 
 	fd = socket(AF_VSOCK, type, 0);
 	if (fd < 0) {
@@ -189,6 +190,11 @@ int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
 	return vsock_connect(cid, port, SOCK_SEQPACKET);
 }
 
+int vsock_dgram_connect(unsigned int cid, unsigned int port)
+{
+	return vsock_connect(cid, port, SOCK_DGRAM);
+}
+
 /* Listen on <cid, port> and return the file descriptor. */
 static int vsock_listen(unsigned int cid, unsigned int port, int type)
 {
@@ -287,6 +293,34 @@ int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
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
 /* Transmit bytes from a buffer and check the return value.
  *
  * expected_ret:
@@ -425,6 +459,147 @@ void recv_byte(int fd, int expected_ret, int flags)
 	}
 }
 
+/* Transmit bytes to the given address from a buffer and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *  >0 Success (bytes successfully written)
+ */
+void sendto_buf(int fd, void *buf, size_t len, struct sockaddr *dst, socklen_t addrlen,
+		int flags, ssize_t expected_ret)
+{
+	ssize_t nwritten = 0;
+	ssize_t ret;
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = sendto(fd, buf + nwritten, len - nwritten, flags, dst, addrlen);
+		timeout_check("sendto");
+
+		if (ret == 0 || (ret < 0 && errno != EINTR))
+			break;
+
+		nwritten += ret;
+	} while (nwritten < len);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nwritten != -1) {
+			fprintf(stderr, "bogus sendto(2) return value %zd\n",
+				nwritten);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("sendto");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (ret < 0) {
+		perror("sendto");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nwritten != expected_ret) {
+		if (ret == 0)
+			fprintf(stderr, "unexpected EOF while sending bytes\n");
+
+		fprintf(stderr, "bogus sendto(2) bytes written %zd (expected %zd)\n",
+			nwritten, expected_ret);
+		exit(EXIT_FAILURE);
+	}
+}
+
+/* Receive bytes from the given address in a buffer and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *  >0 Success (bytes successfully read)
+ */
+void recvfrom_buf(int fd, void *buf, size_t len, struct sockaddr *src, socklen_t *addrlen,
+		  int flags, ssize_t expected_ret)
+{
+	ssize_t nread = 0;
+	ssize_t ret;
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = recvfrom(fd, buf + nread, len - nread, flags, src, addrlen);
+		timeout_check("recvfrom");
+
+		if (ret == 0 || (ret < 0 && errno != EINTR))
+			break;
+
+		nread += ret;
+	} while (nread < len);
+	timeout_end();
+
+	if (expected_ret < 0) {
+		if (nread != -1) {
+			fprintf(stderr, "bogus recvfrom(2) return value %zd\n",
+				nread);
+			exit(EXIT_FAILURE);
+		}
+		if (errno != -expected_ret) {
+			perror("recvfrom");
+			exit(EXIT_FAILURE);
+		}
+		return;
+	}
+
+	if (ret < 0) {
+		perror("recvfrom");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nread != expected_ret) {
+		if (ret == 0)
+			fprintf(stderr, "unexpected EOF while receiving bytes\n");
+
+		fprintf(stderr, "bogus recv(2) bytes read %zd (expected %zd)\n",
+			nread, expected_ret);
+		exit(EXIT_FAILURE);
+	}
+}
+
+/* Transmit one byte to the given address and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void sendto_byte(int fd, struct sockaddr *dst, socklen_t addrlen,
+		 int expected_ret, int flags)
+{
+	uint8_t byte = 'A';
+
+	sendto_buf(fd, &byte, sizeof(byte), dst, addrlen, flags, expected_ret);
+}
+
+/* Receive one byte from the given address and check the return value.
+ *
+ * expected_ret:
+ *  <0 Negative errno (for testing errors)
+ *   0 End-of-file
+ *   1 Success
+ */
+void recvfrom_byte(int fd, struct sockaddr *src, socklen_t *addrlen,
+		   int expected_ret, int flags)
+{
+	uint8_t byte;
+
+	recvfrom_buf(fd, &byte, sizeof(byte), src, addrlen, flags, expected_ret);
+
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
index e95e62485959..3367262b53c9 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -43,17 +43,27 @@ int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_bind_connect(unsigned int cid, unsigned int port,
 		       unsigned int bind_port, int type);
 int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
+int vsock_dgram_connect(unsigned int cid, unsigned int port);
 int vsock_stream_accept(unsigned int cid, unsigned int port,
 			struct sockaddr_vm *clientaddrp);
 int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
+int vsock_dgram_bind(unsigned int cid, unsigned int port);
 void vsock_wait_remote_close(int fd);
 void send_buf(int fd, const void *buf, size_t len, int flags,
 	      ssize_t expected_ret);
 void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret);
 void send_byte(int fd, int expected_ret, int flags);
 void recv_byte(int fd, int expected_ret, int flags);
+void sendto_buf(int fd, void *buf, size_t len, struct sockaddr *dst,
+		socklen_t addrlen, int flags, ssize_t expected_ret);
+void recvfrom_buf(int fd, void *buf, size_t len, struct sockaddr *src,
+		  socklen_t *addrlen, int flags, ssize_t expected_ret);
+void sendto_byte(int fd, struct sockaddr *dst, socklen_t addrlen,
+		 int expected_ret, int flags);
+void recvfrom_byte(int fd, struct sockaddr *src, socklen_t *addrlen,
+		   int expected_ret, int flags);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
 void list_tests(const struct test_case *test_cases);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f851f8961247..1e1576ca87d0 100644
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
@@ -26,6 +27,12 @@
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
@@ -1403,125 +1410,912 @@ static void test_stream_cred_upd_on_set_rcvlowat(const struct test_opts *opts)
 	test_stream_credit_update_test(opts, false);
 }
 
-static struct test_case test_cases[] = {
-	{
-		.name = "SOCK_STREAM connection reset",
-		.run_client = test_stream_connection_reset,
-	},
-	{
-		.name = "SOCK_STREAM bind only",
-		.run_client = test_stream_bind_only_client,
-		.run_server = test_stream_bind_only_server,
-	},
-	{
-		.name = "SOCK_STREAM client close",
-		.run_client = test_stream_client_close_client,
-		.run_server = test_stream_client_close_server,
-	},
-	{
-		.name = "SOCK_STREAM server close",
-		.run_client = test_stream_server_close_client,
-		.run_server = test_stream_server_close_server,
-	},
-	{
-		.name = "SOCK_STREAM multiple connections",
-		.run_client = test_stream_multiconn_client,
-		.run_server = test_stream_multiconn_server,
-	},
-	{
-		.name = "SOCK_STREAM MSG_PEEK",
-		.run_client = test_stream_msg_peek_client,
-		.run_server = test_stream_msg_peek_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET msg bounds",
-		.run_client = test_seqpacket_msg_bounds_client,
-		.run_server = test_seqpacket_msg_bounds_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET MSG_TRUNC flag",
-		.run_client = test_seqpacket_msg_trunc_client,
-		.run_server = test_seqpacket_msg_trunc_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET timeout",
-		.run_client = test_seqpacket_timeout_client,
-		.run_server = test_seqpacket_timeout_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET invalid receive buffer",
-		.run_client = test_seqpacket_invalid_rec_buffer_client,
-		.run_server = test_seqpacket_invalid_rec_buffer_server,
-	},
-	{
-		.name = "SOCK_STREAM poll() + SO_RCVLOWAT",
-		.run_client = test_stream_poll_rcvlowat_client,
-		.run_server = test_stream_poll_rcvlowat_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET big message",
-		.run_client = test_seqpacket_bigmsg_client,
-		.run_server = test_seqpacket_bigmsg_server,
-	},
-	{
-		.name = "SOCK_STREAM test invalid buffer",
-		.run_client = test_stream_inv_buf_client,
-		.run_server = test_stream_inv_buf_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET test invalid buffer",
-		.run_client = test_seqpacket_inv_buf_client,
-		.run_server = test_seqpacket_inv_buf_server,
-	},
-	{
-		.name = "SOCK_STREAM virtio skb merge",
-		.run_client = test_stream_virtio_skb_merge_client,
-		.run_server = test_stream_virtio_skb_merge_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET MSG_PEEK",
-		.run_client = test_seqpacket_msg_peek_client,
-		.run_server = test_seqpacket_msg_peek_server,
-	},
-	{
-		.name = "SOCK_STREAM SHUT_WR",
-		.run_client = test_stream_shutwr_client,
-		.run_server = test_stream_shutwr_server,
-	},
-	{
-		.name = "SOCK_STREAM SHUT_RD",
-		.run_client = test_stream_shutrd_client,
-		.run_server = test_stream_shutrd_server,
-	},
-	{
-		.name = "SOCK_STREAM MSG_ZEROCOPY",
-		.run_client = test_stream_msgzcopy_client,
-		.run_server = test_stream_msgzcopy_server,
-	},
-	{
-		.name = "SOCK_SEQPACKET MSG_ZEROCOPY",
-		.run_client = test_seqpacket_msgzcopy_client,
-		.run_server = test_seqpacket_msgzcopy_server,
-	},
-	{
-		.name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
-		.run_client = test_stream_msgzcopy_empty_errq_client,
-		.run_server = test_stream_msgzcopy_empty_errq_server,
-	},
-	{
-		.name = "SOCK_STREAM double bind connect",
-		.run_client = test_double_bind_connect_client,
-		.run_server = test_double_bind_connect_server,
-	},
-	{
-		.name = "SOCK_STREAM virtio credit update + SO_RCVLOWAT",
-		.run_client = test_stream_rcvlowat_def_cred_upd_client,
-		.run_server = test_stream_cred_upd_on_set_rcvlowat,
-	},
-	{
-		.name = "SOCK_STREAM virtio credit update + low rx_bytes",
-		.run_client = test_stream_rcvlowat_def_cred_upd_client,
-		.run_server = test_stream_cred_upd_on_low_rx_bytes,
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
+	socklen_t addrlen = sizeof(addr.sa);
+	unsigned long sock_buf_size;
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
+	recvfrom_byte(fd, &addr.sa, &addrlen, 1, 0);
+
+	/* Wait for the client to finish */
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_sendto_auto_bind_client(const struct test_opts *opts)
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
+	struct sockaddr_vm bind_addr;
+	socklen_t addrlen;
+	unsigned int port;
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
+	/* Get auto-bound port after sendto */
+	addrlen = sizeof(bind_addr);
+	if (getsockname(fd, (struct sockaddr *)&bind_addr, &addrlen)) {
+		perror("getsockname");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Send the port number to the server */
+	port = bind_addr.svm_port;
+	sendto_buf(fd, &port, sizeof(port), &addr.sa, sizeof(addr.svm), 0, sizeof(port));
+
+	addr.svm.svm_port = port;
+	recvfrom_byte(fd, &addr.sa, &addrlen, 1, 0);
+
+	/* Notify the server that the client has finished */
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_dgram_sendto_auto_bind_server(const struct test_opts *opts)
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
+	socklen_t addrlen = sizeof(addr.sa);
+	unsigned long sock_buf_size;
+	unsigned int port;
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
+	recvfrom_byte(fd, &addr.sa, &addrlen, 1, 0);
+
+	/* Receive the port the client is listening to */
+	recvfrom_buf(fd, &port, sizeof(port), &addr.sa, &addrlen, 0, sizeof(port));
+
+	addr.svm.svm_port = port;
+	addr.svm.svm_cid = opts->peer_cid;
+	sendto_byte(fd, &addr.sa, sizeof(addr.svm), 1, 0);
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
+	size_t max_msg_size;
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
+	max_msg_size = MAX_MSG_PAGES * page_size;
+
+	for (i = 0; i < DGRAM_MSG_CNT; i++) {
+		ssize_t send_size;
+		size_t buf_size;
+		void *buf;
+
+		/* Use "small" buffers and "big" buffers. */
+		if (opts->peer_cid <= VMADDR_CID_HOST && (i & 1))
+			buf_size = page_size +
+					(rand() % (max_msg_size - page_size));
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
+	iov.iov_len = MAX_MSG_PAGES * getpagesize();
+	iov.iov_base = malloc(iov.iov_len);
+	if (!iov.iov_base) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
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
+	free(iov.iov_base);
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
+static struct test_case test_cases[] = {
+	{
+		.name = "SOCK_STREAM connection reset",
+		.run_client = test_stream_connection_reset,
+	},
+	{
+		.name = "SOCK_STREAM bind only",
+		.run_client = test_stream_bind_only_client,
+		.run_server = test_stream_bind_only_server,
+	},
+	{
+		.name = "SOCK_STREAM client close",
+		.run_client = test_stream_client_close_client,
+		.run_server = test_stream_client_close_server,
+	},
+	{
+		.name = "SOCK_STREAM server close",
+		.run_client = test_stream_server_close_client,
+		.run_server = test_stream_server_close_server,
+	},
+	{
+		.name = "SOCK_STREAM multiple connections",
+		.run_client = test_stream_multiconn_client,
+		.run_server = test_stream_multiconn_server,
+	},
+	{
+		.name = "SOCK_STREAM MSG_PEEK",
+		.run_client = test_stream_msg_peek_client,
+		.run_server = test_stream_msg_peek_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET msg bounds",
+		.run_client = test_seqpacket_msg_bounds_client,
+		.run_server = test_seqpacket_msg_bounds_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET MSG_TRUNC flag",
+		.run_client = test_seqpacket_msg_trunc_client,
+		.run_server = test_seqpacket_msg_trunc_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET timeout",
+		.run_client = test_seqpacket_timeout_client,
+		.run_server = test_seqpacket_timeout_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET invalid receive buffer",
+		.run_client = test_seqpacket_invalid_rec_buffer_client,
+		.run_server = test_seqpacket_invalid_rec_buffer_server,
+	},
+	{
+		.name = "SOCK_STREAM poll() + SO_RCVLOWAT",
+		.run_client = test_stream_poll_rcvlowat_client,
+		.run_server = test_stream_poll_rcvlowat_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET big message",
+		.run_client = test_seqpacket_bigmsg_client,
+		.run_server = test_seqpacket_bigmsg_server,
+	},
+	{
+		.name = "SOCK_STREAM test invalid buffer",
+		.run_client = test_stream_inv_buf_client,
+		.run_server = test_stream_inv_buf_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET test invalid buffer",
+		.run_client = test_seqpacket_inv_buf_client,
+		.run_server = test_seqpacket_inv_buf_server,
+	},
+	{
+		.name = "SOCK_STREAM virtio skb merge",
+		.run_client = test_stream_virtio_skb_merge_client,
+		.run_server = test_stream_virtio_skb_merge_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET MSG_PEEK",
+		.run_client = test_seqpacket_msg_peek_client,
+		.run_server = test_seqpacket_msg_peek_server,
+	},
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
+	{
+		.name = "SOCK_STREAM double bind connect",
+		.run_client = test_double_bind_connect_client,
+		.run_server = test_double_bind_connect_server,
+	},
+	{
+		.name = "SOCK_STREAM virtio credit update + SO_RCVLOWAT",
+		.run_client = test_stream_rcvlowat_def_cred_upd_client,
+		.run_server = test_stream_cred_upd_on_set_rcvlowat,
+	},
+	{
+		.name = "SOCK_STREAM virtio credit update + low rx_bytes",
+		.run_client = test_stream_rcvlowat_def_cred_upd_client,
+		.run_server = test_stream_cred_upd_on_low_rx_bytes,
+	},
+	{
+		.name = "SOCK_DGRAM client sendto",
+		.run_client = test_dgram_sendto_client,
+		.run_server = test_dgram_sendto_server,
+	},
+	{
+		.name = "SOCK_DGRAM client sendto auto bind",
+		.run_client = test_dgram_sendto_auto_bind_client,
+		.run_server = test_dgram_sendto_auto_bind_server,
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
 	},
 	{},
 };
-- 
2.20.1


