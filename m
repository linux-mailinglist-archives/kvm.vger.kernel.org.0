Return-Path: <kvm+bounces-42866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC5D2A7EC43
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 21:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2F68188E220
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 19:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24B621504F;
	Mon,  7 Apr 2025 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="MkNl/SjG"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F902550AC;
	Mon,  7 Apr 2025 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744051345; cv=none; b=UMhQc+W+zdfbZyLbdDea8ts/UkdE1Dkqa4xvLfnXbaElIjBmOujE735i9S46kbADe9j0d7YBGYP2N+wngczVWh8mwSFieTluyamM3EjCivLhBbOmXvw3FarvrTaA76lKGZ+LBpivTSZAdAkOCwQ1oDb/a75eFWjA+f6MbsT5t0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744051345; c=relaxed/simple;
	bh=66/2ZeAPmkg9fyE8w4hJm69H4r9Q5lXU+AnHbNWGddg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nJc9X9d/nPTiidfWJ6uFGFDZ6M7UScirsxL2bfxcFVR0Ao8RqB9oIjhaD1BHKVzH7omndGSZHE2uCCFoWuI+VsmJ8OL1u3z++HIKAKy0SMTXor14jKYWyfPWugcxnU6cF6xCdSxTSwBCxfuGBIGNbotgcsLRtWBCHUgFfmJXvMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=MkNl/SjG; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u1rQF-00Cjv4-0L; Mon, 07 Apr 2025 20:42:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=xBudmVevJFsZ3uAgbV+lQgDpPPKHbTZb+0QykClR98Q=; b=MkNl/SjGGlHH/cWhJjha3cmo0q
	TXDBfQns2rj1o7sm3zUj9ZYtmshxjgAVSYe//uV0NnJYwddSP0pra6a9710OfIRl+wIfIj4CGpHVO
	ifKOlHB1bKTf2XJ7AxIL1IX0bLeTVZmXvI5KxTRToTiimeqL6nZ5OhcTSfbgAMxn2uklmiHJ/Vzdv
	/ANUykAt6P3gMW+gpvjpUlqPm9G0PMJMyvG4Xl9w0XmC+wEZRhnbb5gc/xwu7a0ziwG1/uHLqQvbX
	KqJaVYCVxzqCUfxmQ6nrUB3y22N5yO2zmGgX+EqQjkThDG97FlpwI+XdDT3Y13OJRRG72SQANa6ii
	kORyQohg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u1rQE-0007v8-Lu; Mon, 07 Apr 2025 20:42:14 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u1rQ0-008fhd-Kz; Mon, 07 Apr 2025 20:42:00 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Mon, 07 Apr 2025 20:41:44 +0200
Subject: [PATCH net-next 2/2] vsock/test: Expand linger test to ensure
 close() does not misbehave
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250407-vsock-linger-v1-2-1458038e3492@rbox.co>
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
In-Reply-To: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
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


