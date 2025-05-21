Return-Path: <kvm+bounces-47325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC6AAC00A1
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 990521BC4C07
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35F2246777;
	Wed, 21 May 2025 23:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="tLOdnYy9"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEF6242D75
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747869537; cv=none; b=aWmZi57W6Kz7hmXy2zJb87CbCcJRRzJ72iMoMIQD87SSudfexJyDxitSokQnfUvkQl6Bx+xdgQ+2FYWatoUEnFzsX+MZuiUu3/kiwLB5FSmDJNiGTA1yNzI/IMITbXEPvvTVoFIMiFeEJDJDCogH6/7h3FJ9HKF40LCmMpBxPjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747869537; c=relaxed/simple;
	bh=RgHh53qO04IzdhQwdSdmt5/Eg9HVXvCfLyxgadPYTMs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SGqsP4SoiOHmJJALirP+2F/PSvQmcSGti7Eeb6BBDY9XncDp15Lz5vtQPYOCJXaONWcCULLedGIQGoZAeDWRBDWME+8PeSPe0mxRRtdIoe66uihZYbVCvNshB6wNdzr21ncWhxaJq+7WG6oC3B8Gj10+CermWcn5wtOHTIif5/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=tLOdnYy9; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi6-004Irb-BM; Thu, 22 May 2025 01:18:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=w5+hynXTnivL9b8zzxm+8KXzEt6wUm+ZgXKinlnqOoo=; b=tLOdnYy9OFpPcJX1QK6wziFfDb
	tzO7S/ZmMLv/ENR1x2IIyBZ69tAlhTFaLMQpRkX51sY2OlRlfwyRHK7q/jUGM+YZGYWRkENXGCLph
	FULa/JsmCoTMDesXqGtYYOT/QsPbiGX1AohLql5xm7hyUlGvb9ax84Q3ndJGxLcEt5cxGX5Hxh+yg
	yZBBVyJh7B144EhPx2MisFhxYWl9w6hzFGRTfi975gAiPooyStsyMskMj9tbTXbtgLzuHnhn9h5ih
	1mTEHA6ezxAH33I8XZ713Lk4cNu0lGaJmwnF1s9bxDf0h7WSvzNChlzo9nhJ9kpCW5olYlviBNBv9
	nw5h1GNw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi6-0000kU-1I; Thu, 22 May 2025 01:18:54 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHsht-002oFI-NQ; Thu, 22 May 2025 01:18:41 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 22 May 2025 01:18:25 +0200
Subject: [PATCH net-next v6 5/5] vsock/test: Add test for an unexpectedly
 lingering close()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-vsock-linger-v6-5-2ad00b0e447e@rbox.co>
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

There was an issue with SO_LINGER: instead of blocking until all queued
messages for the socket have been successfully sent (or the linger timeout
has been reached), close() would block until packets were handled by the
peer.

Add a test to alert on close() lingering when it should not.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/vsock_test.c | 52 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index b3258d6ba21a5f51cf4791514854bb40451399a9..f669baaa0dca3bebc678d00eafa80857d1f0fdd6 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1839,6 +1839,53 @@ static void test_stream_linger_server(const struct test_opts *opts)
 	close(fd);
 }
 
+/* Half of the default to not risk timing out the control channel */
+#define LINGER_TIMEOUT	(TIMEOUT / 2)
+
+static void test_stream_nolinger_client(const struct test_opts *opts)
+{
+	bool waited;
+	time_t ns;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	enable_so_linger(fd, LINGER_TIMEOUT);
+	send_byte(fd, 1, 0); /* Left unread to expose incorrect behaviour. */
+	waited = vsock_wait_sent(fd);
+
+	ns = current_nsec();
+	close(fd);
+	ns = current_nsec() - ns;
+
+	if (!waited) {
+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
+	} else if (DIV_ROUND_UP(ns, NSEC_PER_SEC) >= LINGER_TIMEOUT) {
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
@@ -1999,6 +2046,11 @@ static struct test_case test_cases[] = {
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


