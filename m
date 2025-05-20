Return-Path: <kvm+bounces-47193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A35ABE7C9
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86BF91BC368D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63462264F99;
	Tue, 20 May 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="bZpY3pKB"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC0425FA0E;
	Tue, 20 May 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781794; cv=none; b=sfgnA5teRmA7iOWbwVxl1j9PVwobwg3+zWrgWb1+Q2VQUzr9SSB5vR0hoYzgCOQZdeXt7DuN6bIILAYlAcvF92e6WZQmVnc48tHzDiIyXdER6eH8kj1ECJn6MzyBw4pzAPRJZZBe/W2t3uMpqeQA85JSFn9H4BH64/pfzKC7dyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781794; c=relaxed/simple;
	bh=GObFbfN2wVKimWgzJ9n0XeVJJnRB7nn/JUvS5QfYToA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DlPdyhh3tD88XPCjhzHKK584iIS5WadKjom258EDfRBUOT1GlnkaE9ZIspwQ90YHJ3uCKpmsfONEgwKFi9OJgy5aOq+s/syLmsO3Zu508i4rNt/hUcT5wa6vprbzMQvs5N+pX9MJ30eErtiCl6DjlfGGZQCs0sD8yR0FlkkFla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=bZpY3pKB; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsk-001MhP-KB; Wed, 21 May 2025 00:56:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=Ddvvjug14RF0dGT1UP+nZlt4T3wLWAXlbRy9MG84HCs=; b=bZpY3pKBQC8gEzbquxd94ltjNS
	QuZWRKqhGby4mM7Ie09oGwO2X23GQ5s2QasdSusi0jj7r1Xbsk7Z+g2vgiB46IpXSaWJn/5GYIXAY
	hNwynsVWH4gjM0ipRe1bWen9f7hNMgGBcOrAODx47ixVBCJUnTEsbvOFUBromrHLli7VvUlV99grx
	AYyV5zfDjga4j8kn7MPGqgiqDv/dk6uJaGmBzi1vB8yrWu980nNoEl2O0RPaPnemIa7TWNbmk5GIo
	wRg0URn0V/bjpMAgaWXBvcJb040LjDlNXgHn5A07rILCqijurvm6tsHUoVAmeMNtrnU9ggtL0py1m
	//9v2HaA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsk-00083n-Ah; Wed, 21 May 2025 00:56:22 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsY-00CxGf-S9; Wed, 21 May 2025 00:56:10 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 21 May 2025 00:55:22 +0200
Subject: [PATCH net-next v5 4/5] vsock/test: Introduce enable_so_linger()
 helper
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250521-vsock-linger-v5-4-94827860d1d6@rbox.co>
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

Add a helper function that sets SO_LINGER. Adapt the caller.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 tools/testing/vsock/util.c       | 13 +++++++++++++
 tools/testing/vsock/util.h       |  4 ++++
 tools/testing/vsock/vsock_test.c | 10 +---------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 120277be14ab2f58e0350adcdd56fc18861399c9..41b47f7deadcda68fddc2b22a6d9bb7847cc0a14 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -823,3 +823,16 @@ void enable_so_zerocopy_check(int fd)
 	setsockopt_int_check(fd, SOL_SOCKET, SO_ZEROCOPY, 1,
 			     "setsockopt SO_ZEROCOPY");
 }
+
+void enable_so_linger(int fd)
+{
+	struct linger optval = {
+		.l_onoff = 1,
+		.l_linger = LINGER_TIMEOUT
+	};
+
+	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
+		perror("setsockopt(SO_LINGER)");
+		exit(EXIT_FAILURE);
+	}
+}
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index e307f0d4f6940e984b84a95fd0d57598e7c4e35f..1b3d8eb2c4b3c41c9007584177455c4fa442334c 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -14,6 +14,9 @@ enum test_mode {
 
 #define DEFAULT_PEER_PORT	1234
 
+/* Half of the default to not risk timing out the control channel */
+#define LINGER_TIMEOUT		(TIMEOUT / 2)
+
 /* Test runner options */
 struct test_opts {
 	enum test_mode mode;
@@ -80,4 +83,5 @@ void setsockopt_int_check(int fd, int level, int optname, int val,
 void setsockopt_timeval_check(int fd, int level, int optname,
 			      struct timeval val, char const *errmsg);
 void enable_so_zerocopy_check(int fd);
+void enable_so_linger(int fd);
 #endif /* UTIL_H */
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 4c2c94151070d54d1ed6e6af5a6de0b262a0206e..f401c6a79495bc7fda97012e5bfeabec7dbfb60a 100644
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
+	enable_so_linger(fd);
 	close(fd);
 }
 

-- 
2.49.0


