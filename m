Return-Path: <kvm+bounces-68393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A76AD386EA
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D8816300EB82
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A853A783D;
	Fri, 16 Jan 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T5B/djuM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqnZ2UTG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D23A4AD9
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594546; cv=none; b=KzxJFL1uWBnj7sebSM2C7gyZxvd59A61fmPG7ckxT9Z5nIDvn9lxB3ge4ndenoY1Q5DZBU0Ol3XG6aJ1so2cAb+55PHcFfwmdijOWsAoLZEFNCnT/oy7i9ElcwWoDUlVs3o4YmJwla5LL1KEDUYG/s56VZ+NDYdNpeMb6TANK9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594546; c=relaxed/simple;
	bh=SoO7meievLXiEt+HOkmT+4mC7UVVo+dr6edO43jcmvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ8GGG/C8qidG+aWBERiU1fnv0D+R6YLn9nCmLo975Nl5gZWeD139vKBzVyFYApku8FsDLBw2zO3gEVtjnFTPspEvM3iV6rs9Mphjv98TJg1a2/Fv9GYDEZs/2uABeYovbIcxnHXcBal20TVjBB1r8B2vKa2gpNJPKg4cS9LXbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T5B/djuM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gqnZ2UTG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IeRZ4N2lg6mPjyH8cqV8u8lDtZLcsrjhMu6bgHYQOx8=;
	b=T5B/djuMRkOF7cdEliYMhk5TGe7jvYFYGhkvfyKgrA2SvdFiI/2ZYYfG5KcgsTOlSuDkn1
	avCUS/5x4+jNgR5n/G8OAtvoLVTvQUQOsHdR91kpXZ6PAKmsA1DkhZj5KlsCuDe0sBOlAb
	sjSr1t60h4kPtdnOcnjEm92poYXLeXE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-XVZSOXS5NJm3PI1sGBekrg-1; Fri, 16 Jan 2026 15:15:41 -0500
X-MC-Unique: XVZSOXS5NJm3PI1sGBekrg-1
X-Mimecast-MFC-AGG-ID: XVZSOXS5NJm3PI1sGBekrg_1768594540
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47ee9a53e8fso14282285e9.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594540; x=1769199340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IeRZ4N2lg6mPjyH8cqV8u8lDtZLcsrjhMu6bgHYQOx8=;
        b=gqnZ2UTGU+LVgE1pbQQ8tbCY77BwwdKIH7BtjPhuCZ77qfHsrmY6V8rnWCwZw2/PWd
         irc/Y9bviFPlYyVLxs/Bu/JxeXNWepCkH5Ec8DMqKWuBK6xpa0Rnwg4d0a5kA4PTfbse
         O78AZvMRSHnzwQdZIT1ncguifp3+5lGyJWfQR9fu/l1F3w18BmsGztpghQ4BJxYAS4i7
         Bjoa4ETxyQo43lU/U8Yz1oyfVJ2qFG9/ElQbMN6b6lsqXzQWF2W3VPXi7kA0NeCzaAxN
         KzzxHMnHWWpQSPVCBqCbSa78mHPiwVVjq+wUsWiSuMVUxYg+SRpRpH63cuNYSU8iLq7h
         hfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594540; x=1769199340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IeRZ4N2lg6mPjyH8cqV8u8lDtZLcsrjhMu6bgHYQOx8=;
        b=CBIsWeMy6WYxcjcrLQ2O5+9fhNCSOAitmY18YdiHDQ4QAHHqIZnBWUGssZx3/cKD8e
         ym5nrui1bcx+7QUKHOkt3cmnnv09EgZtt2aTw54wjW/y7QOfw3MV/ncMYwsp50ErxfCT
         VsmKLoB15tP0fxVOJS2m0ztwpgtk74bxxKew/9fg7TkK6A3LWb1scrs0s6aw1REe0sNp
         rbSPbJ55V/1rneyZ8A0DtQ3Nw+ZgbZsv1BJqNeZRzCX6+5OoPQGY8HAo19CNEQ8shIKp
         4vuGC9lpY1Hg6MahKcUrjra26P778wd/26Npyjpy1RYDUNm79LgAgF8mArwQ/5AfA3Jk
         JFnQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0hhZ7bjRzXxavc8dmW821vlUTuMJ/L3MIWKvkMPJEbzbj9CQ5MbH8glveO7WHarYrx1k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYh5CCflVlC2vGa72ue6SNTgwaEe8xwYC64OQTDEZ+/GYh/o/A
	T5dWI1i663O1ZOWJsdM/nMmqBVMRRkwwLVrLQTTyvDZRQDS1K5KAFJyNGhtPjQE0C+vGikwaw2H
	mtgooa2BKUVk3j0qXKKkdIFD9L+iPKcuLFSzkcRQpGtw/xeRYRb319g==
X-Gm-Gg: AY/fxX40DWG1GPSsuDvqC3j0RVK8kd/U5xOEExvUpbyR5e2kQSxkmg0pDIrc6rMh1rv
	69YhIU3FQl3ZgAjz9U4U3bWUyx/mV0QSJ04JK1LEbRK//EVjX1RX7bD03rgq5V5LfHO0v52AJ6O
	XpA3JJoye9ouLJqMihjDYdqY5Rx7Gr/L59TacEKB8usBGp1Dqw/Mgz8K6YRRpCgmGsxLbsbNt76
	ljLzRMteirxWkRau44zkR8BTwtG+sey+nEpN2cXtq1Am15VChXT7BHRouY+oarbx/B55RzMWHiY
	3Mzchomo9zxS21dnvVVQF9KUpYQ9tj4dJ133qLtWuioxTKRZrWxRJAONX4SUFr/XZP9WWoaET27
	AcddXXAdquyqdFxyWcSYAOwXlL3YYHiCcdtoT0A1/KmuDEMqnGouHcDnmV6YP
X-Received: by 2002:a05:600c:4e93:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-4801eb09274mr39557055e9.19.1768594540391;
        Fri, 16 Jan 2026 12:15:40 -0800 (PST)
X-Received: by 2002:a05:600c:4e93:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-4801eb09274mr39556825e9.19.1768594539909;
        Fri, 16 Jan 2026 12:15:39 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801ea09747sm24213175e9.7.2026.01.16.12.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:15:38 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: virtualization@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	kvm@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Asias He <asias@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH RESEND net v5 4/4] vsock/test: add stream TX credit bounds test
Date: Fri, 16 Jan 2026 21:15:17 +0100
Message-ID: <20260116201517.273302-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116201517.273302-1-sgarzare@redhat.com>
References: <20260116201517.273302-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Melbin K Mathew <mlbnkm1@gmail.com>

Add a regression test for the TX credit bounds fix. The test verifies
that a sender with a small local buffer size cannot queue excessive
data even when the peer advertises a large receive buffer.

The client:
  - Sets a small buffer size (64 KiB)
  - Connects to server (which advertises 2 MiB buffer)
  - Sends in non-blocking mode until EAGAIN
  - Verifies total queued data is bounded

This guards against the original vulnerability where a remote peer
could cause unbounded kernel memory allocation by advertising a large
buffer and reading slowly.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: use sock_buf_size to check the bytes sent + small fixes]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 101 +++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ad1eea0f5ab8..6933f986ef2a 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -347,6 +347,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 }
 
 #define SOCK_BUF_SIZE (2 * 1024 * 1024)
+#define SOCK_BUF_SIZE_SMALL (64 * 1024)
 #define MAX_MSG_PAGES 4
 
 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
@@ -2230,6 +2231,101 @@ static void test_stream_accepted_setsockopt_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_tx_credit_bounds_client(const struct test_opts *opts)
+{
+	unsigned long long sock_buf_size;
+	size_t total = 0;
+	char buf[4096];
+	int fd;
+
+	memset(buf, 'A', sizeof(buf));
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	sock_buf_size = SOCK_BUF_SIZE_SMALL;
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
+	if (fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_NONBLOCK) < 0) {
+		perror("fcntl(F_SETFL)");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SRVREADY");
+
+	for (;;) {
+		ssize_t sent = send(fd, buf, sizeof(buf), 0);
+
+		if (sent == 0) {
+			fprintf(stderr, "unexpected EOF while sending bytes\n");
+			exit(EXIT_FAILURE);
+		}
+
+		if (sent < 0) {
+			if (errno == EINTR)
+				continue;
+
+			if (errno == EAGAIN || errno == EWOULDBLOCK)
+				break;
+
+			perror("send");
+			exit(EXIT_FAILURE);
+		}
+
+		total += sent;
+	}
+
+	control_writeln("CLIDONE");
+	close(fd);
+
+	/* We should not be able to send more bytes than the value set as
+	 * local buffer size.
+	 */
+	if (total > sock_buf_size) {
+		fprintf(stderr,
+			"TX credit too large: queued %zu bytes (expected <= %llu)\n",
+			total, sock_buf_size);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void test_stream_tx_credit_bounds_server(const struct test_opts *opts)
+{
+	unsigned long long sock_buf_size;
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	sock_buf_size = SOCK_BUF_SIZE;
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
+	control_writeln("SRVREADY");
+	control_expectln("CLIDONE");
+
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -2414,6 +2510,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_accepted_setsockopt_client,
 		.run_server = test_stream_accepted_setsockopt_server,
 	},
+	{
+		.name = "SOCK_STREAM TX credit bounds",
+		.run_client = test_stream_tx_credit_bounds_client,
+		.run_server = test_stream_tx_credit_bounds_server,
+	},
 	{},
 };
 
-- 
2.52.0


