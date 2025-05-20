Return-Path: <kvm+bounces-47194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC810ABE7C7
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C7E37ADA8A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5AA26658A;
	Tue, 20 May 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="mqyLc1BR"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7019525FA0F;
	Tue, 20 May 2025 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781794; cv=none; b=tXy3wYofFYys6wFuumW3F8ZME43R0gpUMWG9Imaym99qAJZ7cB7WTOQFBOpUAkLurNZ50UJ3NB2ZghiYCuVea21FJUfLslezJGwRQLJ+MmaVOjqbgj2vRch8BzKVxU6ZPkaF8+0ZVjVu7kgQDuHw9giS+uqEl90ZbfQpGxMUJlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781794; c=relaxed/simple;
	bh=LSPBwF/h8fdoRSP5rra5dxI9Jgsh64MRZKZAeajtuFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FNYnWm6E7n09ICLwsCl1iYcvbkR84IWKo2/aEM6p812gNiQUUztE0Vp7vpabcQBqP+SRznx+9QNhDEdk+TpPYJyLr16+gljRxLbz+AtJ09SBGaV//uXvhHhjAO6lq8XCuCSJ7soIK6ign37p59jcLV8NbkqpSewAWF7FYfWiZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=mqyLc1BR; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsl-001MhU-K1; Wed, 21 May 2025 00:56:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=2cwdhH2ahVirQ/fffeWGbWy0yyPkZHiMvGUr/k2S5C4=; b=mqyLc1BRJ+yhwRKHYqH/xUHQr5
	EQjpejWv3vjT7gtS1x6749TiMg8CMLyYHsvVs4FygzdfKbanvR80H5azoInwDtOfxeozLYAw1KeOP
	QQgpl0ROjK0reKxr5ntogy+ueMR70yQCYgdvLaLFLR3nQpxZk5x9y4JOVTxu0lZxAtqHbjT2mSeWD
	p6gkDjWAaffRAJrNVBAVxqtYyYuzV09ERPCOz8S0/ag+GYvgG/jdg1cEHBlSIX0lxOAhAZRWepNeU
	gwm1JKNEMTErzpaPa0ReK+5sGxRDVIpOz4nwPx/2ZhtaG+UNl5HhBHNZvAZ/8ODlqXEPhlQ/8uX6c
	+omqtesg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsl-00083t-AZ; Wed, 21 May 2025 00:56:23 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsY-00CxGf-6E; Wed, 21 May 2025 00:56:10 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 21 May 2025 00:55:21 +0200
Subject: [PATCH net-next v5 3/5] vsock/test: Introduce vsock_wait_sent()
 helper
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250521-vsock-linger-v5-3-94827860d1d6@rbox.co>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
In-Reply-To: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Distill the virtio_vsock_sock::bytes_unsent checking loop (ioctl SIOCOUTQ)
and move it to utils. Tweak the comment.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/util.c       | 25 +++++++++++++++++++++++++
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 23 ++++++-----------------
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index de25892f865f07672da0886be8bd1a429ade8b05..120277be14ab2f58e0350adcdd56fc18861399c9 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -17,6 +17,7 @@
 #include <assert.h>
 #include <sys/epoll.h>
 #include <sys/mman.h>
+#include <linux/sockios.h>
 
 #include "timeout.h"
 #include "control.h"
@@ -96,6 +97,30 @@ void vsock_wait_remote_close(int fd)
 	close(epollfd);
 }
 
+/* Wait until transport reports no data left to be sent.
+ * Return non-zero if transport does not implement the unsent_bytes() callback.
+ */
+int vsock_wait_sent(int fd)
+{
+	int ret, sock_bytes_unsent;
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
+		if (ret < 0) {
+			if (errno == EOPNOTSUPP)
+				break;
+
+			perror("ioctl(SIOCOUTQ)");
+			exit(EXIT_FAILURE);
+		}
+		timeout_check("SIOCOUTQ");
+	} while (sock_bytes_unsent != 0);
+	timeout_end();
+
+	return ret;
+}
+
 /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
 int vsock_bind(unsigned int cid, unsigned int port, int type)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index d1f765ce3eeeed8f738630846bb47c4f3f6f946f..e307f0d4f6940e984b84a95fd0d57598e7c4e35f 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
+int vsock_wait_sent(int fd);
 void send_buf(int fd, const void *buf, size_t len, int flags,
 	      ssize_t expected_ret);
 void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 9ea33b78b9fcb532f4f9616b38b4d2b627b04d31..4c2c94151070d54d1ed6e6af5a6de0b262a0206e 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -21,7 +21,6 @@
 #include <poll.h>
 #include <signal.h>
 #include <sys/ioctl.h>
-#include <linux/sockios.h>
 #include <linux/time64.h>
 
 #include "vsock_test_zerocopy.h"
@@ -1280,7 +1279,7 @@ static void test_unsent_bytes_server(const struct test_opts *opts, int type)
 static void test_unsent_bytes_client(const struct test_opts *opts, int type)
 {
 	unsigned char buf[MSG_BUF_IOCTL_LEN];
-	int ret, fd, sock_bytes_unsent;
+	int fd;
 
 	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
 	if (fd < 0) {
@@ -1297,22 +1296,12 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
 	/* SIOCOUTQ isn't guaranteed to instantly track sent data. Even though
 	 * the "RECEIVED" message means that the other side has received the
 	 * data, there can be a delay in our kernel before updating the "unsent
-	 * bytes" counter. Repeat SIOCOUTQ until it returns 0.
+	 * bytes" counter. vsock_wait_sent() will repeat SIOCOUTQ until it
+	 * returns 0.
 	 */
-	timeout_begin(TIMEOUT);
-	do {
-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
-		if (ret < 0) {
-			if (errno == EOPNOTSUPP) {
-				fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
-				break;
-			}
-			perror("ioctl");
-			exit(EXIT_FAILURE);
-		}
-		timeout_check("SIOCOUTQ");
-	} while (sock_bytes_unsent != 0);
-	timeout_end();
+	if (vsock_wait_sent(fd))
+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+
 	close(fd);
 }
 

-- 
2.49.0


