Return-Path: <kvm+bounces-49673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F211ADC123
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9919C3B519D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F95524E019;
	Tue, 17 Jun 2025 04:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPZhcL8C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90D23B618;
	Tue, 17 Jun 2025 04:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136054; cv=none; b=Ve13wohXWGibEdPF4LYKWEDdijHgutwIgvR0ec/J4eyHqGjpJpvfKatAe5wXkTi8rboJdCQhSP+pL0GQewACqs7Uzu7TUV85TK58qH7/3U864cb0y3U8z4+y3Kz7EQO+3EhgEHvSl7jtt3r6kKWxrcLcK+F/qs/n4I/o5mfa7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136054; c=relaxed/simple;
	bh=hgFFSeG/Y3hy3TRLWUuF2/wDRWFdJSGr2WyqIM1rJ5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JVz1Zg96P+H9MyIA7J4yGqoEE8JT4rxxLjGZFlAV5tvWadHwO1g8jU3kKiY2EvzOKS0/IdQM1TmfEK2QSYG8QIsvQ24Rk0oEDJJ/H4HFW7ShkBTWxdU90yuAV3Hq8vyHTues7qS8PjauihpUv02bPDZsauSw48G2M3m+VZfqnE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPZhcL8C; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b26f5f47ba1so4312728a12.1;
        Mon, 16 Jun 2025 21:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750136052; x=1750740852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8zzLDE6njEpryzHGmq8M68mZjr/gPDq07PO+JYQaTc=;
        b=QPZhcL8C+/qJoAr5KcBzS2GWrEhfU4T7RF9I3hy5ea2DG5asCqoIhSv1x/pJb9mUWg
         +7rxAT9h67LrEgXz5qIQBA23nQzN/Iw9YWd6SneHUXzAiSaBUrKyLNjduLVyaNyEaZgB
         yz15G5fP6Hebi4FWKDy5HloK9JM9sleLnpeY+R2l+JeWqfQBqQKcrIR7Yabj/dX4rm0t
         be8fcaCShIiOJySsA1cTwh726ryuD65ikr1LrvfE6uEZ3BTCJ7gxv6pjVdPvJwV201U1
         M7WVNDlzKHr+hNPFhQ8/4Q/zJtkgwCFZNSGVugPe7Zq8ns1Xb9zbzAeXxm+ao4fqTzF8
         hJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750136052; x=1750740852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8zzLDE6njEpryzHGmq8M68mZjr/gPDq07PO+JYQaTc=;
        b=SsWtYWguHq+uWEr4eKU1SUVW/BgP0ZaAvfEmGqVTrjOZxncetOtqUChjsZMU+ofmmU
         tzQnU6SNL8W6xngZqoPkGVtaAr+PYclgPGQ2V09AW7fePu9eWDoeTxeaJ6qre8/FBhbu
         7Gj1fj1fHAjzplcocgMyU0o0jv30SUClGwMFsf296KnovTtxGiD4kzmFPfUaTFyBicVF
         e0LkKvGeh6C5z/mviXE454WNlLfW90XnvPmR+3WPZercsUDCrTyreaJbQ+uo27fkzLCk
         nfUuhlF+1QaVWyboxLTRp3VstoDiPwBEPeQSAkIdG7SQZAAueqapLD8IE9uRdkRzjRpJ
         rLYA==
X-Forwarded-Encrypted: i=1; AJvYcCU+JS1qrVgvG8RInUDNnM1J0jf29Ubn3MNg02gARlrSeTpDMdrKMZAy8b07vxypvcCJF2vkbvv+@vger.kernel.org, AJvYcCWjCmhjNPDrMrMfN/ZLY5wzBsZ5tjQCJvRs4QSWFlAdIYWK9eG//LsBr4Cee1LI5aFj9f3SkD57L78C4EHv@vger.kernel.org, AJvYcCX1Q9INNsjgz6gU91nAbv5R3751dcg0QjyVzjOYd0Rl3U6s6iporkYI7qmue+e0hC66Ipw=@vger.kernel.org
X-Gm-Message-State: AOJu0YybsblKRJYJR1vhS8gzuRoO7/9VHrKdr6DDTYrucQ1VFObCgTfo
	enz1xt8NaB1v/vwPA+ZEVpleqlk6VRVahfd96ZM+4Qt9wsaO5Pd3vO3f
X-Gm-Gg: ASbGncunHhZwzBi/RPFAD0YYK1WluejYsswlnq1UbMkDgmMObsnIrLgbjxSbGg70QMO
	dEp9l90KvdwhTWHLyfRd2xXGKP3TolxzCmLcoEdcwk2TjVkOOey8E4LYEGr6R+IbFgd9Jv/8/7M
	RgbAxaMz9XD/qMfR1jeQR3WpyU6ex+aqk/1w8pyYGXtYiJ3EKBk+FBwM0un2yqdp++EkHcfkYb/
	PBMdkbdBb5Stah8Nxi6g+LXINZWtNqTsxNsCkOptXG0Ra8Qi/SvEHQaOClSBPlgwUAel+QnjXxv
	K96kAoZqs+07gsvlq/7sVqmTi0/WwAm0as7SVO/nUX1ukukdnBaaTlzeu/7VJIPRvJCfld3pfZ0
	puVFTYD8E
X-Google-Smtp-Source: AGHT+IHnBLa7t0ubsYSeKkayXhW4mKBqb1+QAMW9EvWq+u4JW6gRZtgfqBWqro4ZYC+uYeX68JLHRA==
X-Received: by 2002:a05:6a21:6005:b0:21a:e090:7b88 with SMTP id adf61e73a8af0-21fbd55a108mr18242268637.21.1750136052423;
        Mon, 16 Jun 2025 21:54:12 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890005f47sm8132852b3a.51.2025.06.16.21.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 21:54:12 -0700 (PDT)
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
	leonardi@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v3 3/3] test/vsock: Add ioctl SIOCINQ tests
Date: Tue, 17 Jun 2025 12:53:46 +0800
Message-Id: <20250617045347.1233128-4-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
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
 tools/testing/vsock/vsock_test.c | 82 ++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f669baaa0dca..66bb9fde7eca 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1305,6 +1305,58 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
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
+	control_expectln("RECEIVED");
+
+	close(client_fd);
+}
+
+static void test_unread_bytes_client(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int ret, fd;
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
+	ret = ioctl_int(fd, TIOCINQ, &sock_bytes_unread, MSG_BUF_IOCTL_LEN);
+	if (ret) {
+		fprintf(stderr, "Test skipped, TIOCINQ not supported.\n");
+		goto out;
+	}
+
+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
+	// All date has been consumed, so the expected is 0.
+	ioctl_int(fd, TIOCINQ, &sock_bytes_unread, 0);
+	control_writeln("RECEIVED");
+
+out:
+	close(fd);
+}
+
 static void test_stream_unsent_bytes_client(const struct test_opts *opts)
 {
 	test_unsent_bytes_client(opts, SOCK_STREAM);
@@ -1325,6 +1377,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
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
@@ -2051,6 +2123,16 @@ static struct test_case test_cases[] = {
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


