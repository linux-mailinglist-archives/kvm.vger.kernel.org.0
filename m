Return-Path: <kvm+bounces-47192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F83FABE7C6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A7224A770F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A22264F9F;
	Tue, 20 May 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="a1zwU4lC"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B925FA07;
	Tue, 20 May 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781794; cv=none; b=Lqb/MbmIvvHKbJ9PRoAyH4yjwUsQPnu1+6FRRdSPLSNrwL4RnlTjDlkG81JFphuqvCd9H52fiTbL9V2lyH4F5JwJJtbIA0z65hDDyCCnh3FC1DSe1kbu99NRfyl3ofP1BuIdEpZ187/ud9obE4TONEr/035BjpfovpaWbCAZjz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781794; c=relaxed/simple;
	bh=wQQubEBib3byNdfTnd7ko0vhCud06Uio7n09JluN5A0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JXnnQ5CDL4fekJ5U1e0ng7XeNpjW29GT6K/7t5akmDug/btZ1S03oSh74AO7cbtaFfRh3Cn51rvARNCqu936ctwD0b8rwHBRb1ZEDC5r3FZsgDGFlHZ1BShIX1TdjOPA5FkcFxeoy4MhTmDt4zxydkV2i598b9HOreJFUw0TfqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=a1zwU4lC; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsi-001MhD-En; Wed, 21 May 2025 00:56:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=J8ECBmbAYxlbH2+qPMrZpA1tVV7W3mma7W+7fWFHowY=; b=a1zwU4lCjIw4rl0eCGmePhdG70
	Kl5MZpMWS3dDQKCbhrvJuYTJICmXOGRkgD6tSjAQ8IiGd6MX/2NVB3J/JEe3jmdNkaYOXfkBX1HOF
	titg1QEnk4LOFk22l1ttevdjoS2E559+ym1/Zr00rZO5NdIEoVjphwk1Hp3p0R8gUlnrzJLBuROj+
	pppmsVvoNZRMHuK8sqZagfc63xgF3JBR7NtfRNnTW8LiXj7cX8GoI+d5HEpzwTzvSyIYrPX1mf6N7
	DnETfPryVxqiiBBRXqyfJ9Mx6vMFCvgEmhtHpV6ve+b6EDEpej9FLZ0Z8g+vSHgijXUKU4ri7JPAj
	6F2jVpdA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsi-0007nJ-6I; Wed, 21 May 2025 00:56:20 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsZ-00CxGf-Hx; Wed, 21 May 2025 00:56:11 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 21 May 2025 00:55:23 +0200
Subject: [PATCH net-next v5 5/5] vsock/test: Add test for an unexpectedly
 lingering close()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250521-vsock-linger-v5-5-94827860d1d6@rbox.co>
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

There was an issue with SO_LINGER: instead of blocking until all queued
messages for the socket have been successfully sent (or the linger timeout
has been reached), close() would block until packets were handled by the
peer.

Add a test to alert on close() lingering when it should not.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/vsock_test.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f401c6a79495bc7fda97012e5bfeabec7dbfb60a..1040503333cf315e52592c876f2c1809b36fdfdb 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1839,6 +1839,50 @@ static void test_stream_linger_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_nolinger_client(const struct test_opts *opts)
+{
+	bool nowait;
+	time_t ns;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	enable_so_linger(fd);
+	send_byte(fd, 1, 0); /* Left unread to expose incorrect behaviour. */
+	nowait = vsock_wait_sent(fd);
+
+	ns = current_nsec();
+	close(fd);
+	ns = current_nsec() - ns;
+
+	if (nowait) {
+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+	} else if ((ns + NSEC_PER_SEC - 1) / NSEC_PER_SEC >= LINGER_TIMEOUT) {
+		fprintf(stderr, "Unexpected lingering\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("DONE");
+}
+
+static void test_stream_nolinger_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1999,6 +2043,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_linger_client,
 		.run_server = test_stream_linger_server,
 	},
+	{
+		.name = "SOCK_STREAM SO_LINGER close() on unread",
+		.run_client = test_stream_nolinger_client,
+		.run_server = test_stream_nolinger_server,
+	},
 	{},
 };
 

-- 
2.49.0


