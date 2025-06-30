Return-Path: <kvm+bounces-51075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01A1EAED661
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A16543B5F36
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D8D2459C4;
	Mon, 30 Jun 2025 07:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6AtyBEU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA25124469F;
	Mon, 30 Jun 2025 07:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270280; cv=none; b=ARue7Zk5m+tk7quGWP92julKGyGo1SZi03c284DOg6y+YpsLE8F0UiR5reOU+54g7TKtd+5RmK5feWJi3f6q79d9tlUFAewELg272/qGcEgzwsC0wMlHHOdlWEex41hsVdPrQsaq5jHA8cn+KcHcwcJUCPxKKpoHXsFHvc/lm4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270280; c=relaxed/simple;
	bh=AOZ6oVmWOkitNq/6qx+PmOOk2d4N55RYRHT6AyMe7Lk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NYhOqbFTgWetQz/nK4Ijguq1uyIbnNmQ8Zellj0jysa5HPQlqBYLIhsxLkF/N6wCEezK2NoH992Q/VzAqoFuBaSdcHNEFcZ+Q3yrT86kfaQ+Y35codaAIlFWJMNzrcJ7I+5+BiRa1599y+tWbRAfM8XpBdmeJupijTJgLLrRuZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6AtyBEU; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-742c3d06de3so2198059b3a.0;
        Mon, 30 Jun 2025 00:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270278; x=1751875078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NP7k3vrg3hSrjisvFnFBQDzzpUXz8NpLnGnPf2tMTWo=;
        b=d6AtyBEUrsSCo+Svb9kPlAITz9B+pgXOxQuWWs+dUPl+oOl+pTKwQzt/vpgUkbXC0y
         hUhIdbJYM122wTp9g63cLJFwQ4axYVnTtrTyGpD8EuNKTvG20rsQQQcZgPfFeAHlCPHG
         plkdE614KTKHz/vPYIeXSUVSolbsSVnMHLOQyPX5qda6+n/oybD09KeXiBHWqthWNsiF
         wKmK8rnDPr+HdL6LUVSjogFuWqaay63xbm29lgWG1uidZOIKhF2OycaWSHhsrBISGl6j
         2PGYzmt5idJBAJGlykXpRiZDcUUISH70adrIRPEVVDv0XlICioyvOA9DGSqvR/vjymK0
         jaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270278; x=1751875078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NP7k3vrg3hSrjisvFnFBQDzzpUXz8NpLnGnPf2tMTWo=;
        b=hRsdIXsz+DnTxLVKN+qk8oQEh4klSS0H/VCASyMv+PKvsRYiHULnQRb6kL15DLrkEL
         +d+N+tt4i/xgG+FRZZ1TBpJF7z1bLe8Shw8ARHYtdCa9+3cZEv36KWA/RDu4Hoi6DThN
         jS35tbcIaQ1WcyxdvanbycE277Ofh9TAf/dyyUmAwkBayKz7uPZ5CPGKef9F95FHULFy
         N8fRkiDl7SPNlltq3bBzpPQWYmWFBoa7PWAktVXMTR6z3qxwEZK8V/URoYi7/cPtlI4y
         /2YED7XpDhjJOA3oYrHp9Zq4MpA25qMg3APWCgbrz16GfVx8gEYy+S3pR5PYK/O/BZuw
         wsrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9hbHVQDhGSFDbs+HMAxvQufncsAOZq5m14Nn0vFzTqrnnMlweBwhjnOwNe144Bkl83zq75/HR@vger.kernel.org, AJvYcCVwcwYw6vc3nUdyGkX8khVG2HQE/e2upn2jcUu6XUJhWO9SC8p8SGuaGtabhI37iYuP1jI=@vger.kernel.org, AJvYcCWlwTYBwtvif9oNl9XEf1AIN0QzYNZYy9704Q+E0QNLjpEU1pu85INhGwjijE0pKAAoHZqCLtGAZDsg6ZU1@vger.kernel.org
X-Gm-Message-State: AOJu0YwUIz0GGuhVGF2oQt0HLAHrFcm2/DlTtudSAFIjSZERKVufCAKe
	G+NNlDdUG7+nNfLGJU8DbLeWc/CHXcFcUs2kev3cUW9ya/7XntK3zjM7dVisQp/wHQQDt4wH
X-Gm-Gg: ASbGncswYK1893nq8iWdNjdxjmnPLmnyEbKpk3Ats+MEUM/2t6D8UZfu4DHF/xThl7I
	MGiK7eFV0Gkliiup6N1CBootp+gddiOLQdH12mxtz5kUTo9JeCboz/opmxJ9ICr8WnsAzYhiTxB
	A0irUo2OjuIUgXFSVRitymWldtgW5L5dQJC2l5VaMsazw21eezNm03WnXI1IX670vn3q5uV6PEr
	J/FLoBCRa13L0ka7RFsZLXK7G1quhxTXC9YDO1kS8Pr/G6Ic2lKngrxhncUepCrNg0M6KgX8zQu
	H0gM0K7hktTLbmW1/u/MJwcNiQ91asNQWWSG2P91amdTsOVIf+k0pclSguj0GGp4CqzVLJaENxq
	LKVT4YC0X
X-Google-Smtp-Source: AGHT+IGJxQhOgdfS47I3apdJsqJnzzvU1y8CdHZhf/JDLt96PRag9x30UnOO4MrqUqcGY/sgql8/Iw==
X-Received: by 2002:a05:6a21:600a:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-220a16c9a36mr19882874637.38.1751270277975;
        Mon, 30 Jun 2025 00:57:57 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm7414931a12.63.2025.06.30.00.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:57:57 -0700 (PDT)
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
Subject: [RESEND PATCH net-next v4 4/4] test/vsock: Add ioctl SIOCINQ tests
Date: Mon, 30 Jun 2025 15:57:27 +0800
Message-Id: <20250630075727.210462-5-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
References: <20250630075727.210462-1-niuxuewei.nxw@antgroup.com>
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


