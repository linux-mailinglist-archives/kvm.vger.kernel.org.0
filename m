Return-Path: <kvm+bounces-66191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 119D0CC93C1
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 19:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DBE14303BFFA
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 18:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26CB340A63;
	Wed, 17 Dec 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdGlgC/4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53607283C83
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995162; cv=none; b=OCrI4CMF7d4bstkxpXKlRwI0+qRliEBWcMpOOYG/jurpalT58RhYTvxWOttv2dXYkQ23sDSs2yVs9+7eVp11jhGsMHoxX40eSaA+13CtzHvzKXVUOY7BG8pd6H9KpE82NYmrhydHeHdIajgb9hbJ2HKIcZIQyuuk0U2vxhIAADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995162; c=relaxed/simple;
	bh=Btn/e79eN7ovQAPmHnhb0d8yhq10fIOSyLkws8LR2uE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBOSGOXEP+uMugxp/p6xUJ3HHzZM+D8UvNPZ+Vud2JtHuV26S/UaDGFKuHm612P9DPsKAcYqERse6chueCrqoVvM4HnDvhgGKfFlPhk/vEy/e3J1B6kgsEzksK3+k5lCPl4tWCAUZchqhnm/qSvsz/ftQA1oytlCTPnaG2YVFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdGlgC/4; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5959d9a8eceso7427757e87.3
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 10:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995155; x=1766599955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWDVTcbeN5bBA7b/fB7A8gJyMmAFiIZBGr/pLyGnvWw=;
        b=mdGlgC/4bGskD8vhG1bF6wfwggtrbIVUqUKc0jeWmrX0OXpDzcOG5esv177Upxk4eb
         Z7tNO16HKVWRRsisHP2qDSCkbFmMn0mdNpc0I0QDOjyaZlH8Jo2nf+7Rru4y5JiQ3IE2
         lR4zBE3SXnQm/ifLg2X2G9XF2o4Q8lS+Fj9n900r9pvFaPue3Ldo0jXPTUwCrNbvycPa
         18/LGl7CvoelkAoioM+KuQHWPSHiwHV7zWvIJcWn8YmTnnq7+y5NRKZ61+NB2srUm4Ne
         ZDKl/D/Vzn+38JMDsbHSyOUHId3vy0yDp0jwFH8vkY+bo3oQv7qQefwGOlOrY+cMo9QL
         +CtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995155; x=1766599955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YWDVTcbeN5bBA7b/fB7A8gJyMmAFiIZBGr/pLyGnvWw=;
        b=MoyixVDb2ABKoV9Eh4uYY4i4h94ithqPY44CzYV+ogZF97e4jRtZzGiJdAyBRC0I+3
         UCAk4hbtbeIAMqN4ogskCQ6w4u384+B/5JohTGqbgvpx8Y9AIqHF713D7jhUrA40YhBN
         Rn/pqma0uSKV3P3nDfz2xxKju4b+PnaBan8KL1tcxJhfKlfMQd6dOusTno0Gpv39g/Ct
         whe0lNastP93wtamCQQUkyhUTrh6e9AMMHHUE+SMb3gt4ezSa6RnMUFOaWpC+m4AMYhh
         GYEc8v5uYfYhRNoSzcEnXc4dPQjtptWygU8G8GrHqm64aAZB0nu29qIn2Bim/Sp6wT0b
         a0Zg==
X-Gm-Message-State: AOJu0YyFJEBxF24MqII8Ar6pZrkkLSdik0EjyPUMVRSK6s03LT9qeTn6
	nwrPlW3CTAwr7MA1jbGQsOliyZBcsgrbGQD9JuhbUkyiudATFy1lxFgk
X-Gm-Gg: AY/fxX5v0FHc3Osj1DfZMcr7isCxITqHqQzsXDI0FwGnVCOxL86q+8I1o5JHzkoJQWb
	sXiyvuAdDFsW2GTkj/0poIE6o1zcwWU5t3WQa+704mh2eTiMvDZZTsO0pHDUPabNLBhvibfoM9I
	UdJyX9uZvBP5MzvF7dIPE7QMTZrgw9jSAjPWTEy4C1dCjUu/BMff1nVxYGlMjPTGMFuY2eiO2hI
	m0d+InrDHqiFVq3liIJ0eOGx55kyXmKXO9iKCyC1tO7HpUZh7Uh+Pps9wEckfYzQe6fjzic4ZW1
	FE73H6oOQUfofZiuQ3pyXbt/WjyCaMMzZozA7yElLes32HuENGYOd9q70l0QgRd7hjXhXEOtCZK
	YKjf/K+Drivsfz1JxYqbKeQyKLvqBsVsZpXDIZWYsqRXS5we2aIpy3tT0M6Xp+r7wqkQPAKcYZ3
	rhS+zy0TDQeew=
X-Google-Smtp-Source: AGHT+IGKE6+oXrVS7pwbxHPAdksD1QodGnRBGOe+h7uD8J+gXsamVw7BpLRSwSnFwpf8bb0Jng+hIA==
X-Received: by 2002:a05:6512:3d07:b0:59a:107a:45a5 with SMTP id 2adb3069b0e04-59a107a46cdmr754855e87.23.1765995154644;
        Wed, 17 Dec 2025 10:12:34 -0800 (PST)
Received: from Ubuntu-2204-jammy-amd64-base.. ([2a01:4f9:6a:4e9f::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da790efsm2591419e87.102.2025.12.17.10.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 10:12:34 -0800 (PST)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v4 4/4] vsock/test: add stream TX credit bounds test
Date: Wed, 17 Dec 2025 19:12:06 +0100
Message-Id: <20251217181206.3681159-5-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251217181206.3681159-1-mlbnkm1@gmail.com>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 tools/testing/vsock/vsock_test.c | 103 +++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 0e8e173dfbdc..9f4598ee45f9 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -347,6 +347,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 }
 
 #define SOCK_BUF_SIZE (2 * 1024 * 1024)
+#define SMALL_SOCK_BUF_SIZE (64 * 1024ULL)
 #define MAX_MSG_PAGES 4
 
 static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
@@ -2203,6 +2204,103 @@ static void test_stream_nolinger_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_tx_credit_bounds_client(const struct test_opts *opts)
+{
+	unsigned long long sock_buf_size;
+	char buf[4096];
+	size_t total = 0;
+	ssize_t sent;
+	int fd;
+	int flags;
+
+	memset(buf, 'A', sizeof(buf));
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	sock_buf_size = SMALL_SOCK_BUF_SIZE;
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
+
+	flags = fcntl(fd, F_GETFL);
+	if (flags < 0) {
+		perror("fcntl(F_GETFL)");
+		exit(EXIT_FAILURE);
+	}
+
+	if (fcntl(fd, F_SETFL, flags | O_NONBLOCK) < 0) {
+		perror("fcntl(F_SETFL)");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SRVREADY");
+
+	for (;;) {
+		sent = send(fd, buf, sizeof(buf), 0);
+		if (sent > 0) {
+			total += sent;
+			continue;
+		}
+		if (sent < 0 && (errno == EAGAIN || errno == EWOULDBLOCK))
+			break;
+
+		perror("send");
+		exit(EXIT_FAILURE);
+	}
+
+	/*
+	 * With TX credit bounded by local buffer size, sending should
+	 * stall quickly. Allow some overhead but fail if we queued an
+	 * unreasonable amount.
+	 */
+	if (total > (size_t)(SMALL_SOCK_BUF_SIZE * 4)) {
+		fprintf(stderr,
+			"TX credit too large: queued %zu bytes (expected <= %llu)\n",
+			total, (unsigned long long)(SMALL_SOCK_BUF_SIZE * 4));
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("CLIDONE");
+	close(fd);
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
+	/* Server advertises large buffer; client should still be bounded */
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
@@ -2382,6 +2480,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_unread_bytes_client,
 		.run_server = test_seqpacket_unread_bytes_server,
 	},
+	{
+		.name = "SOCK_STREAM TX credit bounds",
+		.run_client = test_stream_tx_credit_bounds_client,
+		.run_server = test_stream_tx_credit_bounds_server,
+	},
 	{},
 };
 
-- 
2.34.1


