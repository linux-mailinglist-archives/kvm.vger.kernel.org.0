Return-Path: <kvm+bounces-43727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE40A9586F
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84B5A3AB4C1
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA7B21C9E5;
	Mon, 21 Apr 2025 21:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="J90FhxkX"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB691D95A3;
	Mon, 21 Apr 2025 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272285; cv=none; b=BgQJTY0VVgHJ6qzQgyFTcedurLLCQ9N1AR8SYIFBpEU/mihw5WZAeTmeFocjpfEbjtDxEzeWgjXfeqQ9jW/hN3YWPzxmYNx1OQ207jHy+ozvTiicdI+Y4ztXYVO47fa20efJRvz3ZFsEU7VJM/natvO5MqwgiW4rz/7Y3RBEDFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272285; c=relaxed/simple;
	bh=bU72gZf0Mlr4a1DTEu4p6xddG7QuL34UyWY76ya9fjA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tfd60kmd4cwEtiIDTM/PlEgW+hHjy9l7c43Ia1FJQK1qgY3SfSEokW4eoMYdYzs7jSs8+jBciV9RO35aEceTzp52Oir7t1KG1tim85uRWOy7xgjONyRBt4LsLNJzqGss4tY9R9m+JnlinThOWcrJjFctLZfTnAYSrs+fw6PQSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=J90FhxkX; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2n-000P5i-7E; Mon, 21 Apr 2025 23:51:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=qswCCZ7zdNCGMNQd6xheEFi5M2DI/AzAcjRQmm33v3U=; b=J90FhxkXtWl335gXrcrN6soVBm
	Q6xbudBOn9/qMff9L5+o9kTYwOU11Y3t5HhhRR0YxY5UjwSU1hclxGgL1ezvDNg/MagJC5i/4vhe4
	4XxK+2vwetUSur5Tba/Ef81hulIVRsmBF5d6MYV99PCF/IsgCLbn92DPLcmYfALe02VxHoUWzdsFu
	iAzHJu942Fpqc+NNT0Em53nbg83EpXVoYJhj3zqNQnerfItzsdiJJ+jaWvNI1opUKHD968AkLGEp2
	0XgWbLMiAyG5rTK/Z+A8MApKTT6wujw5mAHOLzZbYfzbgwN1w5PxwRoWKw5wUWXbcf+mBnNhSIe8o
	b9UUbbQw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2m-0000Nf-T1; Mon, 21 Apr 2025 23:51:13 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u6z2j-0056xd-1t; Mon, 21 Apr 2025 23:51:09 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Mon, 21 Apr 2025 23:50:43 +0200
Subject: [PATCH net-next v2 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250421-vsock-linger-v2-3-fe9febd64668@rbox.co>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
In-Reply-To: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
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

Add a check to alert on close() lingering when it should not.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/vsock_test.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index d0f6d253ac72d08a957cb81a3c38fcc72bec5a53..82d0bc20dfa75041f04eada1b4310be2f7c3a0c1 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1788,13 +1788,16 @@ static void test_stream_connect_retry_server(const struct test_opts *opts)
 	close(fd);
 }
 
+#define	LINGER_TIMEOUT	1	/* seconds */
+
 static void test_stream_linger_client(const struct test_opts *opts)
 {
 	struct linger optval = {
 		.l_onoff = 1,
-		.l_linger = 1
+		.l_linger = LINGER_TIMEOUT
 	};
-	int fd;
+	int bytes_unsent, fd;
+	time_t ts;
 
 	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
@@ -1807,7 +1810,28 @@ static void test_stream_linger_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	/* Byte left unread to expose any incorrect behaviour. */
+	send_byte(fd, 1, 0);
+
+	/* Reuse LINGER_TIMEOUT to wait for bytes_unsent == 0. */
+	timeout_begin(LINGER_TIMEOUT);
+	do {
+		if (ioctl(fd, SIOCOUTQ, &bytes_unsent) < 0) {
+			perror("ioctl(SIOCOUTQ)");
+			exit(EXIT_FAILURE);
+		}
+		timeout_check("ioctl(SIOCOUTQ) == 0");
+	} while (bytes_unsent != 0);
+	timeout_end();
+
+	ts = current_nsec();
 	close(fd);
+	if ((current_nsec() - ts) / NSEC_PER_SEC > 0) {
+		fprintf(stderr, "Unexpected lingering on close()\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("DONE");
 }
 
 static void test_stream_linger_server(const struct test_opts *opts)
@@ -1820,7 +1844,7 @@ static void test_stream_linger_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	vsock_wait_remote_close(fd);
+	control_expectln("DONE");
 	close(fd);
 }
 

-- 
2.49.0


