Return-Path: <kvm+bounces-22698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82ED09420E1
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E862C1F20C71
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B91218DF90;
	Tue, 30 Jul 2024 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdbqZI7j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D1F18C93F;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368604; cv=none; b=P3IIBSBx1xoVMEeopTPjOetG8kpAyDKSMGkJzdaHRc1XZ2OnC8/EYveWgVXjC9hbz16NwmvfOg3Y0QrRz15PpvE5NeGvdP+5QfsnAsj/l/F24Nx3XlDf4d5rBqoVxhBFQspSMWTvefat4ZntYjMvvXIVFGBp4myjaHqeZ8NBeJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368604; c=relaxed/simple;
	bh=j/fo2OFH999A9qSU4xh304Mv47Te5RJL6dmqOmXHt78=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AyMdo9BrRutevkGZZ6tQ7g9Wj7FeMzCySJUTYOE5QISDK7r6m+Sw7BA64XLJ+0/JP3LAbvmPFsJWiF4sJCq9Op3EhqpU1XD1nKDZftdFyOT2YR8pj8PdZWqNnE2tOOarimaajtKFbPs6cV9fNQJU+xA3YC9HFc066wek4nAJniI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NdbqZI7j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 173AAC4AF10;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368604;
	bh=j/fo2OFH999A9qSU4xh304Mv47Te5RJL6dmqOmXHt78=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NdbqZI7j1mwKpVlKIHiv4WHnHCpVfeKAcqqRkQgQHqfl1eudE6Bjh5MjkrdJGIUY/
	 S8axWZDy5X3t7qBgUgCdl2rdVhSEu1vpuxW2gu7PgDYPYCrtiUOSE4XRdTiQCPtdXo
	 f+R5K9qE9hUpB47alAOecHwfAPcFvhYmRLj8GAfEsYOVRReD9rCYjbn6pm+Dg5Y7ZC
	 hCTECxJaLEALk8GTDgCv+pb3AkGoGTqIf+1UZBuu4Ef9b0IWm8ElKkjqzeVe4OgAm0
	 H1GGI4h84Rss/s7dsPSGqyTlFQR8WWnbZuOyyZ4qPst1pxHg/dTQEdNp5mSERBz//2
	 EXYrRa/12JKeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2A5C52D1F;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Date: Tue, 30 Jul 2024 21:43:08 +0200
Subject: [PATCH net-next v4 3/3] test/vsock: add ioctl unsent bytes test
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240730-ioctl-v4-3-16d89286a8f0@outlook.com>
References: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
In-Reply-To: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368602; l=5479;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=APW6nchLTElCgi+y0wB3e/LaM6SJ5yQdNDfK3On80wM=;
 b=97r8rgp6DZOr8aqfPUPmSUoJA44xtHMwxUN0Qd1Fq+lBE3fV89JC0Hdhe3Vr/alBrGB3UwUTv
 gP1THUkXLHgDaGhyqwvFNLlIbMJHyqjYztEWQQVPTRTHmhhsnGz8eu3
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

From: Luigi Leonardi <luigi.leonardi@outlook.com>

Introduce two tests, one for SOCK_STREAM and one for SOCK_SEQPACKET,
which use SIOCOUTQ ioctl to check that the number of unsent bytes is
zero after delivering a packet.

vsock_connect and vsock_accept are no longer static: this is to
create more generic tests, allowing code to be reused for SEQPACKET
and STREAM.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 tools/testing/vsock/util.c       |  6 +--
 tools/testing/vsock/util.h       |  3 ++
 tools/testing/vsock/vsock_test.c | 85 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 554b290fefdc..a3d448a075e3 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -139,7 +139,7 @@ int vsock_bind_connect(unsigned int cid, unsigned int port, unsigned int bind_po
 }
 
 /* Connect to <cid, port> and return the file descriptor. */
-static int vsock_connect(unsigned int cid, unsigned int port, int type)
+int vsock_connect(unsigned int cid, unsigned int port, int type)
 {
 	union {
 		struct sockaddr sa;
@@ -226,8 +226,8 @@ static int vsock_listen(unsigned int cid, unsigned int port, int type)
 /* Listen on <cid, port> and return the first incoming connection.  The remote
  * address is stored to clientaddrp.  clientaddrp may be NULL.
  */
-static int vsock_accept(unsigned int cid, unsigned int port,
-			struct sockaddr_vm *clientaddrp, int type)
+int vsock_accept(unsigned int cid, unsigned int port,
+		 struct sockaddr_vm *clientaddrp, int type)
 {
 	union {
 		struct sockaddr sa;
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index e95e62485959..fff22d4a14c0 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -39,6 +39,9 @@ struct test_case {
 void init_signals(void);
 unsigned int parse_cid(const char *str);
 unsigned int parse_port(const char *str);
+int vsock_connect(unsigned int cid, unsigned int port, int type);
+int vsock_accept(unsigned int cid, unsigned int port,
+		 struct sockaddr_vm *clientaddrp, int type);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_bind_connect(unsigned int cid, unsigned int port,
 		       unsigned int bind_port, int type);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f851f8961247..8d38dbf8f41f 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -20,6 +20,8 @@
 #include <sys/mman.h>
 #include <poll.h>
 #include <signal.h>
+#include <sys/ioctl.h>
+#include <linux/sockios.h>
 
 #include "vsock_test_zerocopy.h"
 #include "timeout.h"
@@ -1238,6 +1240,79 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
 	}
 }
 
+#define MSG_BUF_IOCTL_LEN 64
+static void test_unsent_bytes_server(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int client_fd;
+
+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
+	if (client_fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	recv_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
+	control_writeln("RECEIVED");
+
+	close(client_fd);
+}
+
+static void test_unsent_bytes_client(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int ret, fd, sock_bytes_unsent;
+
+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	for (int i = 0; i < sizeof(buf); i++)
+		buf[i] = rand() & 0xFF;
+
+	send_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
+	control_expectln("RECEIVED");
+
+	ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP) {
+			fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+		} else {
+			perror("ioctl");
+			exit(EXIT_FAILURE);
+		}
+	} else if (ret == 0 && sock_bytes_unsent != 0) {
+		fprintf(stderr,
+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
+			sock_bytes_unsent);
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void test_stream_unsent_bytes_client(const struct test_opts *opts)
+{
+	test_unsent_bytes_client(opts, SOCK_STREAM);
+}
+
+static void test_stream_unsent_bytes_server(const struct test_opts *opts)
+{
+	test_unsent_bytes_server(opts, SOCK_STREAM);
+}
+
+static void test_seqpacket_unsent_bytes_client(const struct test_opts *opts)
+{
+	test_unsent_bytes_client(opts, SOCK_SEQPACKET);
+}
+
+static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
+{
+	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
+}
+
 #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
 /* This define is the same as in 'include/linux/virtio_vsock.h':
  * it is used to decide when to send credit update message during
@@ -1523,6 +1598,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_rcvlowat_def_cred_upd_client,
 		.run_server = test_stream_cred_upd_on_low_rx_bytes,
 	},
+	{
+		.name = "SOCK_STREAM ioctl(SIOCOUTQ) 0 unsent bytes",
+		.run_client = test_stream_unsent_bytes_client,
+		.run_server = test_stream_unsent_bytes_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET ioctl(SIOCOUTQ) 0 unsent bytes",
+		.run_client = test_seqpacket_unsent_bytes_client,
+		.run_server = test_seqpacket_unsent_bytes_server,
+	},
 	{},
 };
 

-- 
2.45.2



