Return-Path: <kvm+bounces-47324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1410DAC009F
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D0A61BC4F5C
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4189424500E;
	Wed, 21 May 2025 23:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="p9GDmG5A"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00F423ED68;
	Wed, 21 May 2025 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747869536; cv=none; b=RW8Y8QRUARrTgBjxD10eHPQU/Mlo5NnCGQnm+fOTcLmqQ6LcATirH3RZYkpS9JG889CqJAXwGFQiOxqqzpcHQC155IzcM9huJPqu0F6xebVn8ReaNomLRE+t/YdtDjMxOS8hMUID/J9xNJM2ND2HQxOr3k1WS09y93Wwf1sRHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747869536; c=relaxed/simple;
	bh=bF1QVDn3eLYTI2e2+sbNRcU/soBlBpz3dcmakzkYMzk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Oor62C14hxcHMLv0oms1NqgmuSghmM10VapZS8xmOMLxAtz9lAZrXeVuWyjq+fgQyEOEfISeUQc22z9uMyaPzNCeR2iCYmBl0/FlUowNQPLB01S8kVNMnYuKC3n/zqyJsLcIYfCTk1dLjIcF9Q0eCK95QJhMctiGmsnR8DE640I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=p9GDmG5A; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi5-004Rr9-0K; Thu, 22 May 2025 01:18:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=m3JgpIvbSc39Q2JNhDQANwveDNeRM+bXIUHcujWAtek=; b=p9GDmG5AMXkpXBN8MHneH6j5JH
	Q1nytoHL2TwG/rcB7Qo3TcG4M7/E6ha/EQFj0gtsIHtrV0Y89iUukmnrWiFeopVobup8ekJYL+vXE
	ILbC76xOcs9EWR6k44g7HK0gW+jnltcPJBzlK4JWQuDSkG0BqSZKC++flx/P3TIugPzmjYN4KeaeY
	fkZZcUM0JXqb8FmuuSrGHqk941jEC2KqMiU1JNbTzeuGBwTmFCCwJadEF+EYEQQpLON9Ed2m5xlX/
	Pg4PQJP7Dla2+sXy+sPnK8HdLYojlCjj+NCW259303KvmrZL2YpOBLmG6TO6Ve1u2OCMEhhmuvqyN
	6/CX3BEg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi4-0006IR-Kp; Thu, 22 May 2025 01:18:52 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHsht-002oFI-0s; Thu, 22 May 2025 01:18:41 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 22 May 2025 01:18:24 +0200
Subject: [PATCH net-next v6 4/5] vsock/test: Introduce enable_so_linger()
 helper
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-vsock-linger-v6-4-2ad00b0e447e@rbox.co>
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

Add a helper function that sets SO_LINGER. Adapt the caller.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/util.c       | 13 +++++++++++++
 tools/testing/vsock/util.h       |  1 +
 tools/testing/vsock/vsock_test.c | 10 +---------
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 4427d459e199f643d415dfc13e071f21a2e4d6ba..0c7e9cbcbc85cde9c8764fc3bb623cde2f6c77a6 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -823,3 +823,16 @@ void enable_so_zerocopy_check(int fd)
 	setsockopt_int_check(fd, SOL_SOCKET, SO_ZEROCOPY, 1,
 			     "setsockopt SO_ZEROCOPY");
 }
+
+void enable_so_linger(int fd, int timeout)
+{
+	struct linger optval = {
+		.l_onoff = 1,
+		.l_linger = timeout
+	};
+
+	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
+		perror("setsockopt(SO_LINGER)");
+		exit(EXIT_FAILURE);
+	}
+}
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 91f9df12f26a0858777e1a65456f8058544a5f18..5e2db67072d5053804a9bb93934b625ea78bcd7a 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -80,4 +80,5 @@ void setsockopt_int_check(int fd, int level, int optname, int val,
 void setsockopt_timeval_check(int fd, int level, int optname,
 			      struct timeval val, char const *errmsg);
 void enable_so_zerocopy_check(int fd);
+void enable_so_linger(int fd, int timeout);
 #endif /* UTIL_H */
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 9d3a77be26f4eb5854629bb1fce08c4ef5485c84..b3258d6ba21a5f51cf4791514854bb40451399a9 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1813,10 +1813,6 @@ static void test_stream_connect_retry_server(const struct test_opts *opts)
 
 static void test_stream_linger_client(const struct test_opts *opts)
 {
-	struct linger optval = {
-		.l_onoff = 1,
-		.l_linger = 1
-	};
 	int fd;
 
 	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
@@ -1825,11 +1821,7 @@ static void test_stream_linger_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
-		perror("setsockopt(SO_LINGER)");
-		exit(EXIT_FAILURE);
-	}
-
+	enable_so_linger(fd, 1);
 	close(fd);
 }
 

-- 
2.49.0


