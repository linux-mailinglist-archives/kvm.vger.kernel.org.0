Return-Path: <kvm+bounces-47320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6E9AC0090
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 476C316B17C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C3CE23D289;
	Wed, 21 May 2025 23:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="RdGO1bEe"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBC51C8631;
	Wed, 21 May 2025 23:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747869532; cv=none; b=RiAgx5g7ewVY/0LsZwhRrUwut73URzAKlR0/LvZ/PWPH6YY6rZJa+QAfYlUkCz8yIR/cFMPYYXLHhLv32O4MWwbw00q9/3jIHQy474WfHSnHZTErRUoJ9xr7ZI9R1ECFR2HqXXDHf8Swuc7O6DfbiIwBPOEJgFV1ctzwtetrPZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747869532; c=relaxed/simple;
	bh=J4bNkTayjGwhnjiIZJMfORQDPb/lZ/bQHwxADQ9DMpg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=piLGsaW59INSvAJmSMz0q1uXU1bWrAG32OSn5f2CSTEgD2F//Sowsl17+iaeq89uientd1LkaPfdL2u8zlG8wAMOQYU/Q+bwMEvDkFgL3oAVyE5RX/kruyRFbBDhLyKLUUY2zWEJbbpzKCJ8/2c73PvTiXmLQzaVIIKyhgkGInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=RdGO1bEe; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi0-004Rnx-9Z; Thu, 22 May 2025 01:18:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=30Va3AN6LfNZbe0t0ezMLiASzcEn91Zs1pRfADE6gQQ=; b=RdGO1bEeHwcb1OyDDXHLxJ8+CU
	jf6qvrngu2OhXiHSXExzVWM3cr0JufxXPwTr67ci5Ey8HkR0dFj1Z0uqVfUKjN8kZPFsztxj+eSgf
	37k0K+uVlYVxbFWqN54i5R9tEkdQiXfRU/Pna5v8kqSh0GdHDJ6YzldYqpZx44yybCmLpMLJGOSe+
	U6WJjBZcd+uwR1JgJqKNE+Zj9M7uvN85zLC0bEoKuRPt5qpVdn0T+o7xwU+GMHQQjCTUze17A0B0Q
	ZH+l3XN26hsNh//TQa2j+A1gcAHQSNyHzfKMY/KfJp9JXT3BhRa5e8iEavtQRUn08w098TQjqYMOU
	3Px2XkJg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHshz-0000k5-6c; Thu, 22 May 2025 01:18:47 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHshs-002oFI-Ak; Thu, 22 May 2025 01:18:40 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 22 May 2025 01:18:23 +0200
Subject: [PATCH net-next v6 3/5] vsock/test: Introduce vsock_wait_sent()
 helper
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-vsock-linger-v6-3-2ad00b0e447e@rbox.co>
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
In-Reply-To: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
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
index de25892f865f07672da0886be8bd1a429ade8b05..4427d459e199f643d415dfc13e071f21a2e4d6ba 100644
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
+ * Return false if transport does not implement the unsent_bytes() callback.
+ */
+bool vsock_wait_sent(int fd)
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
+	return !ret;
+}
+
 /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
 int vsock_bind(unsigned int cid, unsigned int port, int type)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index d1f765ce3eeeed8f738630846bb47c4f3f6f946f..91f9df12f26a0858777e1a65456f8058544a5f18 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
+bool vsock_wait_sent(int fd);
 void send_buf(int fd, const void *buf, size_t len, int flags,
 	      ssize_t expected_ret);
 void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 9ea33b78b9fcb532f4f9616b38b4d2b627b04d31..9d3a77be26f4eb5854629bb1fce08c4ef5485c84 100644
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
+	if (!vsock_wait_sent(fd))
+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+
 	close(fd);
 }
 

-- 
2.49.0


