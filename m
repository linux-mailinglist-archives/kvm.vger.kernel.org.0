Return-Path: <kvm+bounces-46964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E356CABB596
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30D971707A5
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26625267715;
	Mon, 19 May 2025 07:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRXnaKva"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C792673BB;
	Mon, 19 May 2025 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638440; cv=none; b=Eo0+6vv8tmfD6XppD/BDLEziQITAxe4ztGD2eEJoE3A+q8UW0foyugGtvA85oBJhHfBAvIZD8PMCEEuLLXtTAJ1MnrJi7ciwHWUOLW6yXQEVdu+SzG0u3RbFd5U7ay2WRkWtLQixInLXiUN4H6YBAOP1knWZ7Rxnq3LHLpYZijU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638440; c=relaxed/simple;
	bh=lR0efES/TyHPp4CcTBk6Ai5txdkjK+8TK75tfxkp6xo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=caF4hgMZLxAD8L6MUzLF35R63JBevCU2D/eNEp8yfXg52RIex9fg4goiK0ziX+gZKEVPkTvEldvM59nW9xKeKntS+bZPvw2DEurz/ZIatMCFk3E90iOtwhtlSPvlwrpvvGpN8Qet8T3RXfEWMp5WGOFKeowxVfICRAztosBJqpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRXnaKva; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30ed99132abso856230a91.3;
        Mon, 19 May 2025 00:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747638438; x=1748243238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAhF0WSXalG9ecvsiVvvYCkMdMtzERZ5TCfWvYr6e80=;
        b=BRXnaKvau65pK8KVehl/e3XKszZoOs9OdD1WE0YsmllgsRngihTBJ8xrJfIiMPfnon
         R3Kv1qGeYrvVuAIrdCmptFHV9V0ILITaCxv/8Mhviu+SzUkkJPUMu3fQuFKg8MIoEu2y
         4lM5Y+0I83Drz9lQD6wFJacd2GtSPOJtUQwIBxUlaUNStIpmvw/FwyhEBOsYoQgD+RjL
         4pHZr3NFvoJdHrt7y8ibVdDImKtUUtlPwfUWRLQ/CgHNcd7QTMigBYP1COAurvIEaJPA
         siinFsn1opCgkUYH2yPsSqLuYQuGpWPCWJFoVMhg9vm/4v2JOfomI+EJXGjlGDbar97y
         xWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747638438; x=1748243238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAhF0WSXalG9ecvsiVvvYCkMdMtzERZ5TCfWvYr6e80=;
        b=tbAPljk3JIasP2fnBwcGlFgFzilatdKdone+VDoIxieOS21vWVZabfIUvu2hX84k2o
         NPO4xYdrua3Ph+gCq2T1/ClNiG11uEw5shC38QMb4iLmMFuzAlzj6V4PycnwzedR4aSH
         VBLEVc7erblBnPRjKLfFxgRoaAMr/AqhjiQfwfpLlPwRLvBEac8m0WEbvDRt4MhqJ12V
         vPJ6sj1KkvpQ/UervQfBqz74Kvm77o2aPxRS0eKp/zdstgXRHZaAoDB4NXBtq6NdfE8X
         2QYPgN7yO0figACroTi4Ru96VjboyBqbKhGeFcp3g8lwm2S7ovXgLNQf+rYrKORhFFVX
         D0Mg==
X-Forwarded-Encrypted: i=1; AJvYcCU6LnNfjdZtCrJY+iPeal8w6jX+y4ehPHVFFk2UdAFfak6g95bGKswdahIlDIdGQ/prBBY=@vger.kernel.org, AJvYcCXLLjVMZX6rx6ABwBhzIljYXSmWRTkvUxRXW73czA9IYyMroA2XAtVnUsAqEiYXaI3bJP8qAT3a8MpWNew7@vger.kernel.org
X-Gm-Message-State: AOJu0YxQV69teFFXmbBnroS/eom4Ovik082pCs8A6JNHT8AmC5c8j/lO
	hbVnlQ5QzCm62KiqSqM1Ydf+rD6DrQPmRF6FO4lRo7SLiJjK/oQe1Wil
X-Gm-Gg: ASbGnctcLirESvzTuW0Sflguk3y3kQJIpwA36hEOTi9ZqH66x7ui26ZT4Z8iRbIziqH
	gwUPJ5AuCjEJBBsyJixq80yFcMf4PwOE19ZsHwJ44JkBgjtwhZQdhNPUkoee0IepXrCrrBfY9Wa
	/Ll1+dNw8yzC4h/n6ywGMUy6xr01nOoEhSEMprw6QI8iTNrqKjP5rnxfKLcxlO2pKMDiZtpFxyI
	lTMgMcRGr1UktQU1/43lJUArP4hpGLGvqMtQ+pDkxHw+7YqGONJoa0H6x0qywK4CmR9NrERE4KE
	JcoEd9bzXOmcBBy9OdUSKXANyL25Pig+uIgKtpz+ECjLRYNfTbPqvF5rWNdvEPVnm5mkJh0pug=
	=
X-Google-Smtp-Source: AGHT+IFjhVjo/YrTw1poiwjhhCJqVvrXmUL2/CBsKqcYhLdcps3ekIFTWSzHoLUkzwFSdsZU0sLlMw==
X-Received: by 2002:a17:90b:5251:b0:308:5273:4dee with SMTP id 98e67ed59e1d1-30e7d542b40mr17676836a91.15.1747638437921;
        Mon, 19 May 2025 00:07:17 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a0120sm5574336a12.63.2025.05.19.00.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 00:07:17 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	fupan.lfp@antgroup.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH 3/3] test/vsock: Add ioctl SIOCINQ tests
Date: Mon, 19 May 2025 15:06:49 +0800
Message-Id: <20250519070649.3063874-4-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds two tests for ioctl SIOCINQ for SOCK_STREAM and
SOCK_SEQPACKET. The client waits for the server to send data, and checks if
the return value of the SIOCINQ is the size of the data. Then, consumes the
data and checks if the value is 0.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 tools/testing/vsock/vsock_test.c | 102 +++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index d0f6d253ac72..8b3fb88e2877 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1282,6 +1282,78 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
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
+	// The data have come in but is not read, the expected value is
+	// MSG_BUF_IOCTL_LEN.
+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
+	if (ret < 0) {
+		if (errno == EOPNOTSUPP) {
+			fprintf(stderr,
+				"Test skipped, SIOCINQ not supported.\n");
+			goto out;
+		} else {
+			perror("ioctl");
+			exit(EXIT_FAILURE);
+		}
+	} else if (ret == 0 && sock_bytes_unread != MSG_BUF_IOCTL_LEN) {
+		fprintf(stderr,
+			"Unexpected 'SIOCOUTQ' value, expected %d, got %i\n",
+			MSG_BUF_IOCTL_LEN, sock_bytes_unread);
+		exit(EXIT_FAILURE);
+	}
+
+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
+	// The data is consumed, so the expected is 0.
+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
+	if (ret < 0) {
+		// Don't ignore EOPNOTSUPP since we have already checked it!
+		perror("ioctl");
+		exit(EXIT_FAILURE);
+	} else if (ret == 0 && sock_bytes_unread != 0) {
+		fprintf(stderr,
+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
+			sock_bytes_unread);
+		exit(EXIT_FAILURE);
+	}
+	control_writeln("RECEIVED");
+
+out:
+	close(fd);
+}
+
 static void test_stream_unsent_bytes_client(const struct test_opts *opts)
 {
 	test_unsent_bytes_client(opts, SOCK_STREAM);
@@ -1302,6 +1374,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
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
@@ -1954,6 +2046,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_unsent_bytes_client,
 		.run_server = test_seqpacket_unsent_bytes_server,
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
 	{
 		.name = "SOCK_STREAM leak accept queue",
 		.run_client = test_stream_leak_acceptq_client,
-- 
2.34.1


