Return-Path: <kvm+bounces-51074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0D2AED65D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0AF31706EC
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F1124466B;
	Mon, 30 Jun 2025 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lus9NUyJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9992243378;
	Mon, 30 Jun 2025 07:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270276; cv=none; b=fNJRC18DLtsEEJBFqUH+C7kBA9/khIRTMYy2PezdQxVNNKnMXHVp9nEOzAqOQlkyN3ezHt6/IRi0VYm/uLpGfoxYE7Elsdvk7ejG6Ei/bqo6EnjEnl+Mxib1GPpNipEe9Iaem3K869dusy9HVwrbItG/imc2g/YnDcNbUhKB9AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270276; c=relaxed/simple;
	bh=6e8nhq3wAutajxTDZ1caB5Wt0cNk1tW6jl9nRmn/iB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aHogBag8NRsbfvIEGSQag94qXRMcOj8WmGneUP1SJeTJ08V/9Zto+DhjGAXoWt3eTwdwVcgQYBSwXslj0lDIBHDee/OMakbOJ1wvwXQ/9fJY1qoQV7owoG0eS48rRey8PIK4tKJIa+mHS33erLGekAOHTnfXiHOa43ucN4FnZW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lus9NUyJ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7494999de5cso3229992b3a.3;
        Mon, 30 Jun 2025 00:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270274; x=1751875074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCu94amvUYw2PYDfqBO7v4QOw2C4FxuMQOpeOs/4SKI=;
        b=Lus9NUyJRakV/vhL5YVPqcIZcZ03M/+agoK9aEGxryL/PkYyja/IQggsp8miZU0Xa1
         yH8W5xSJ1o0+NcxHOfbXFY3I513MwkQTEN//7utmnqz7cMhtV4uqs5dlDPDlFD1aVx8Z
         5QQ3OdmeHQdzl20RILrQ63B+WSRQOQgAMyTCX0dMTeqmYbVGbxYuMa+59bqZBqPIJEEL
         KyTYPZcBVor+kRF7vAuUbISsFS8m1915oiFThA7Nn0J1OZaZ3vQzi9rYUCH/jtBtUMu4
         jhVSjxAPd0XTCWULPXWEru9HGkrrw0JT9diuYDS9nWDuNre9SUOKaVhtj7iniQFbbK6G
         alfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270274; x=1751875074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCu94amvUYw2PYDfqBO7v4QOw2C4FxuMQOpeOs/4SKI=;
        b=ro5PUHl77sLz1SX6/dfe3fcAqquMSRzPEjbuQU3/4kRIHBSRtlyugeOY/R0rGpAHXv
         KQm++7p+V1e0JuTQGlnVHeeSui8k49lJXs8TWivjImxCEhNM8sft2JGwlXinf0JN4BB3
         27WkwQhsw14ICT8dmSu++YL6heGmX4G/TrrWib29I/csiZIhFcUnaTH8+CXRn0s86ztJ
         T5Cvr7gbeYmIPHJogH20WGd93+3DKSTnzClbbxzQ976v28VYntPPafp8CIbhaCh8MB0w
         s9rSCPGtMWMNSLVRMz37t1pacbq68pdLPXf3PzCu8Z9R6ysBlIP8wo/lV6FEFEDiOEUp
         WrYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/uANJtDpj/dKTK53eSBldR49bxPNpyJ8cukKZfoxAAyET8yMr+aKg35s+2360vx9YbVKQypNL@vger.kernel.org, AJvYcCVy7WPBYGxLQJZbSfKkdTCjcrtexPnGn5o7UGRCGPYE1qEh56i7d6LzwbYTRQNjFt6v5QA=@vger.kernel.org, AJvYcCWG+8Tt/ll+9Yq4sWoFU7ogKkGqIDKZyGrs4O19QkcfrSM9X4Sc0WccXd6FD5YZptTQmUol5BxwNezHhN3T@vger.kernel.org
X-Gm-Message-State: AOJu0YwOJEaUngIaGskRE6ocpByzUFVHEKyDWs6W6HigH40BWOhH9uBm
	ZgY9Qmk9u0BJeL5E0wxpwO0xT+wJt+Ib071fHGx3NKQYedyLejBHuZEpgt4MnBlrZNy7Gi9g
X-Gm-Gg: ASbGncvP9h58Ztk7ILNqGBN3cwa5cslY0i86fnMOBExQ/TxGc+f3Ja2jAymOAY/UdEx
	7w4GdcB925Se05N+5JGOJ2cqHVGaPDQkTsEiSj1eQ7AHCrWGQlZdpv8RbqwbTyb1v4b5Y6gem/N
	JaZhkpJIQfrsNihshKakTUUN6X+tlUCA1EcSSsQn1M1noRB7SEGK17xIwYTwfKswDf7PWddhn5M
	f/ick2HsB/ebDcWPTBtBgP8PVXn0leFQutDz/rBRzH5kPA6KMjTWeOnid1GkJ2zowpWuVeDXMW4
	HdyHJREZtpq8FzZjMlisCAYlZYl9tu4qolLL6eZx9VSkvSyPnp25QqnpmzlRWobUi7/3jsdrzZB
	WP2C7w+Bg
X-Google-Smtp-Source: AGHT+IEswJGvdxBSoFaPb2APxP0ZX96sIgqwRd8xIVVkz2BA3zKqHue5sohbeXX3Sz09j+bn0a3pig==
X-Received: by 2002:a05:6a20:734b:b0:220:2e32:4e28 with SMTP id adf61e73a8af0-220a17ffa45mr17177744637.42.1751270274104;
        Mon, 30 Jun 2025 00:57:54 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31db02esm7414931a12.63.2025.06.30.00.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:57:53 -0700 (PDT)
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
Subject: [RESEND PATCH net-next v4 3/4] test/vsock: Add retry mechanism to ioctl wrapper
Date: Mon, 30 Jun 2025 15:57:26 +0800
Message-Id: <20250630075727.210462-4-niuxuewei.nxw@antgroup.com>
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

Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
int value and an expected int value. The function will not return until
either the ioctl returns the expected value or a timeout occurs, thus
avoiding immediate failure.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 tools/testing/vsock/util.c | 32 +++++++++++++++++++++++---------
 tools/testing/vsock/util.h |  1 +
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 0c7e9cbcbc85..481c395227e4 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -16,6 +16,7 @@
 #include <unistd.h>
 #include <assert.h>
 #include <sys/epoll.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <linux/sockios.h>
 
@@ -97,28 +98,41 @@ void vsock_wait_remote_close(int fd)
 	close(epollfd);
 }
 
-/* Wait until transport reports no data left to be sent.
- * Return false if transport does not implement the unsent_bytes() callback.
+/* Wait until ioctl gives an expected int value.
+ * Return false if the op is not supported.
  */
-bool vsock_wait_sent(int fd)
+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected)
 {
-	int ret, sock_bytes_unsent;
+	int ret;
+	char name[32];
+
+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
 
 	timeout_begin(TIMEOUT);
 	do {
-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
+		ret = ioctl(fd, op, actual);
 		if (ret < 0) {
 			if (errno == EOPNOTSUPP)
 				break;
 
-			perror("ioctl(SIOCOUTQ)");
+			perror(name);
 			exit(EXIT_FAILURE);
 		}
-		timeout_check("SIOCOUTQ");
-	} while (sock_bytes_unsent != 0);
+		timeout_check(name);
+	} while (*actual != expected);
 	timeout_end();
 
-	return !ret;
+	return ret >= 0;
+}
+
+/* Wait until transport reports no data left to be sent.
+ * Return false if transport does not implement the unsent_bytes() callback.
+ */
+bool vsock_wait_sent(int fd)
+{
+	int sock_bytes_unsent;
+
+	return vsock_ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0);
 }
 
 /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 5e2db67072d5..d59581f68d61 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected);
 bool vsock_wait_sent(int fd);
 void send_buf(int fd, const void *buf, size_t len, int flags,
 	      ssize_t expected_ret);
-- 
2.34.1


