Return-Path: <kvm+bounces-51068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F34F7AED5EC
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F39CB3AAE5A
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A76423F40A;
	Mon, 30 Jun 2025 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUmSn2GL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A9224240;
	Mon, 30 Jun 2025 07:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269144; cv=none; b=HpbgFYmrV4FoNkLgc4dEK0sKinrdI/4D6Dy+DfKw6vI9s+hcZEd5QSDtHBe+AqZ1UqgGe2w1LIhke6F7M4qd/UxEoIsCp8yQXyFDq5D4BC4G67pfJMmhSyLAfBuzi7Pdk29kvxTZa9hLL52cRIucs5t7IV7G7dIYKiH6oXYbp18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269144; c=relaxed/simple;
	bh=AOZ6oVmWOkitNq/6qx+PmOOk2d4N55RYRHT6AyMe7Lk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VEJU7ZjxIItVspoMmj+ZsrRx4KsCNi5GQL1/xHW34BFJxXul/3qsL87fqHwT4x00Wqv/Q9sTF9eSxFjiVYSAaAXbS1jM2HEGYLEyle0i4vYQ4Y6zWkA74BSngxHThtaVk/LJAkGnk4KBKBuyHz6QXF3pUFfWWvOVYtMwVJsdDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LUmSn2GL; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b31c84b8052so5143524a12.1;
        Mon, 30 Jun 2025 00:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751269142; x=1751873942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NP7k3vrg3hSrjisvFnFBQDzzpUXz8NpLnGnPf2tMTWo=;
        b=LUmSn2GLmfuvXswg7XauO3hJFMUhqjTS35gXA3lhiVBPsr0ojyghpsFqDW4bBTclwM
         l5TXYTKc7DYKHiziFso3sXIxUO8fat04R+qILwUtLW5r/Hs8HS1QiH4VoxNFqxm6c3Pm
         Z4FUiU0MkOTG+c/9yExAXPNrPHCczLWTtI9jT7P1oX7A7ZQzCgEBSXhwjQ1rfyHGDVTg
         x+K5cR5tZPmCPk4TFuWbiG3B9Lkw4E6SNH0J1lFCXWtTwgkDInhGCHJsEGf8ndJ/rewK
         7wJP0gRaAGvX5v9m3jJxjU+84fDXwaS0/ReepHUHfV+Qd38fZ/Dk1ZvWrZUw9KRWUy/Q
         aijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751269142; x=1751873942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NP7k3vrg3hSrjisvFnFBQDzzpUXz8NpLnGnPf2tMTWo=;
        b=OyeKYquhiVLVKnvo9CPkvSL6176aFfPtvqsqmfqkMBbnykkBBTbcj1T6jHKV3ihZK+
         TIKshdHDQChdM4shPYwc3ctDtrAnKdO7uiXJHiplHNn5hdeKHSu4YePhWCCePpVqu7An
         OmaWG/oiIvM8VJq2/RRPgZxHMQ7sFZXrRuYpLHNpAkKcE7Pdr2sMNI3AvxoWyFyGeQOI
         0KEGDqXu+nSGiIgxaBtIGhDZGjYIrXh8P4yYhOU5QG0ehsgTM2ikFf6nWxvfdxSnnH5f
         Rba2mvdH2aXqzghI9ZGoSJ0FmDFDtC+xrgwovCkYcXgtz8KC2pPikx+vF14QduWfLkUH
         R/Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUoWHPh8zVmEFkJJCPLMlyw62WinosBHkYPsOWvjAR+ejNjJLIIKCLH3asoNfjpkXCJE0UUK8Ps92ykefgB@vger.kernel.org, AJvYcCVd7sp1aQ217G8Lutr3VqSLNB3oV0AXFMKdsP1wZV0IKWAbMeei3LJLjxgpzmn12D/pXww=@vger.kernel.org, AJvYcCXbf6xzhOqH6F8UorRZW3JXxURcQWnqwjc008Kr8CyW455tbQf4lPjN+ym41aQIaux7rV9Zsuwi@vger.kernel.org
X-Gm-Message-State: AOJu0YytlKSoFvgC7VF+cBM3aZuoRnDLp6a/d4LyPWkzz4U8rdufaAlp
	ddvgJXtzK50K+Vok5mu9pZ211KHpXT5ScrZW5QRB21jGqjR+sIFh0+q3kuXpD5AMf2i2K1in
X-Gm-Gg: ASbGncv+YCJu4bV2+r6Sil1/8D6JvDg5UO//+zaqJuuxaKl0cVTI6nOcXi6upmqBaC/
	KMEegjk8b0X4IQ1a0CmXr6r4w5mWvMSOa9Y1paZv7KXh43ZeYdk0Anj6XXO6mzzJpqCmnHeFpid
	UQfI3Uvzl/ufyBRYgq7jZZheR6TWBFTLPioUfNhW7iZpDzEpueXcSOfDngy4oCroWsNO7yLHyLZ
	q2vPddcNFC7jQulNVopOm+hk3I5LF4acAJLIzfyel5vANx8pKIUZnjvmiDVZqhT/J8JCVEQ2MXV
	T+U1g60uqW5MixX6GGHtTCsU7KR0bJ1aAL9e9wV9sDGiXFYfwwIXV2P0Y87qeCUCET/3541GJqy
	Ubjkk6OSm
X-Google-Smtp-Source: AGHT+IFsEXxcldaRKPnifcj924EJJK7H2ZTMlfpiPLPTt1OR+FEiYFdG6Niq3uwrDxXy9YRewc/0jA==
X-Received: by 2002:a05:6a20:a111:b0:1f5:6f95:2544 with SMTP id adf61e73a8af0-220a1834a51mr18403660637.33.1751269142145;
        Mon, 30 Jun 2025 00:39:02 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af55c8437sm8075175b3a.115.2025.06.30.00.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:39:01 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	leonardi@redhat.com,
	decui@microsoft.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v4 3/3] test/vsock: Add ioctl SIOCINQ tests
Date: Mon, 30 Jun 2025 15:38:27 +0800
Message-Id: <20250630073827.208576-4-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
References: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add SIOCINQ ioctl tests for both SOCK_STREAM and SOCK_SEQPACKET.

The client waits for the server to send data, and checks if the SIOCINQ
ioctl value matches the data size. After consuming the data, the client
checks if the SIOCINQ value is 0.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f669baaa0dca..1f525a7e0098 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1305,6 +1305,56 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
 	close(fd);
 }
 
+static void test_unread_bytes_server(const struct test_opts *opts, int type)
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
+	for (int i = 0; i < sizeof(buf); i++)
+		buf[i] = rand() & 0xFF;
+
+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
+	control_writeln("SENT");
+
+	close(client_fd);
+}
+
+static void test_unread_bytes_client(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int fd;
+	int sock_bytes_unread;
+
+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SENT");
+	/* The data has arrived but has not been read. The expected is
+	 * MSG_BUF_IOCTL_LEN.
+	 */
+	if (!vsock_ioctl_int(fd, TIOCINQ, &sock_bytes_unread,
+			     MSG_BUF_IOCTL_LEN)) {
+		fprintf(stderr, "Test skipped, TIOCINQ not supported.\n");
+		goto out;
+	}
+
+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
+	/* All data has been consumed, so the expected is 0. */
+	vsock_ioctl_int(fd, TIOCINQ, &sock_bytes_unread, 0);
+
+out:
+	close(fd);
+}
+
 static void test_stream_unsent_bytes_client(const struct test_opts *opts)
 {
 	test_unsent_bytes_client(opts, SOCK_STREAM);
@@ -1325,6 +1375,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
 }
 
+static void test_stream_unread_bytes_client(const struct test_opts *opts)
+{
+	test_unread_bytes_client(opts, SOCK_STREAM);
+}
+
+static void test_stream_unread_bytes_server(const struct test_opts *opts)
+{
+	test_unread_bytes_server(opts, SOCK_STREAM);
+}
+
+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
+{
+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
+}
+
+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
+{
+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
+}
+
 #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
 /* This define is the same as in 'include/linux/virtio_vsock.h':
  * it is used to decide when to send credit update message during
@@ -2051,6 +2121,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_nolinger_client,
 		.run_server = test_stream_nolinger_server,
 	},
+	{
+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
+		.run_client = test_stream_unread_bytes_client,
+		.run_server = test_stream_unread_bytes_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
+		.run_client = test_seqpacket_unread_bytes_client,
+		.run_server = test_seqpacket_unread_bytes_server,
+	},
 	{},
 };
 
-- 
2.34.1


