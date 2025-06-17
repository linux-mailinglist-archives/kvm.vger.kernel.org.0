Return-Path: <kvm+bounces-49672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D59ADC11F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C992B174EAC
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014942417F2;
	Tue, 17 Jun 2025 04:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFD7oag4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49B23F26B;
	Tue, 17 Jun 2025 04:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136051; cv=none; b=ulG10SLoVN9jFskR4/xlWQCtvIcAUZg4HzJtAW0Dh2F7T+qpU0Xrshz5OpHxVLZctyWBDDwx0cCCruWPqW52YSgeO1aZf0FeD5ZYm7LGofR5UwkaL+gfivhbge4NQLQyxDdcYpg02OKKp68mnvpkkju9vImjzIhNfmqtBZ2xJxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136051; c=relaxed/simple;
	bh=qAAEyNvoPsG1J2rvH/RjZ+lSWAbM8Y+vzxmxNzalfo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MpI1ZmBXyQs/33i5tNt+EuvMtTF/nzQJLzYnHZYfQTHoW1z//wY/DAL3/HgUkD8+D2op2+/hkeBvL9MT81+yLQotXPQKqI0loE1BFqQQSjWrG986hOfbQU+ALYRL1Z5Oj3nwQWuBcMvzrAEOKv5xBeM6G8vr10vBSPg31sbluK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFD7oag4; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b2c49373c15so4059798a12.3;
        Mon, 16 Jun 2025 21:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750136049; x=1750740849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgHC0F7sRFE0xD766MwngM3VrQ1DYAvaKq5Aq9oTyWQ=;
        b=jFD7oag4wIRgOuduHBpoxkdYG3nxhd6H+q6awhxpvVubDuQPsuuuLSEjEV+v3Gorbg
         cfZReirfZoiDdBahIbOm/kmN03tpys9JcC8FGjatujP0uAUVtBf9chQvXNRtHWUsLDh5
         72MWZqa/mJuXdNyaKc7NSAMaF+LfI68339aKyZ/+tvKQslYwA5PxrugH+8yBYfkSp57I
         Pm85x6O1jF619WMiYaUlGYOw91xF/DJgfRCdcTLRDnQ9qQBFFK22NEMlXyyWu+vb2GhB
         PudbRdZT5GcU7xAsv2FvOSUHxJzG6PFQAIbNOsGmon+6PYEX2+d3z3lPbmOT6807XYx1
         wFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750136049; x=1750740849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgHC0F7sRFE0xD766MwngM3VrQ1DYAvaKq5Aq9oTyWQ=;
        b=KfNEewcpqV+yoTNyb5ezrkfUsk/DdcJgrDBbanZzJaYjVcWKwLxOfVNp3iz5QWsXfM
         drlOKoACGgq5P9VlXdviq56WMHfNR195H3KOcs0WLVTSkIDrx5pAHJSX/ZvtJbDODLiR
         HO6GtUVicAFJXYxzfuurtFmiZVwdNgQIfE4CQe2fWwU03tWlwDOG+3bPa4YNtdavKfEf
         t004f68hkvyFjHQX4Ss24ggbr+B8/kktlci2xP6mBUc1fVYpnZ9FsWwA2yNGv+BI9FfR
         0Md4LUjvCqeKhiAXc/v8R2lEbOrfEA8hZ1oCbTZaLJfmzFU5GS8ub2o0L8XIXllLVJRj
         8ciQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw3wCWuUV3a/r09UcvexJab0h9cG1+V2IFxkiFWDD3KNrwo6rrgkuIZg90+Ik3KHGcj5zEp19BLT4nvVdX@vger.kernel.org, AJvYcCWMpLuPTd2g7wQ2bLd92KJp9SI8cHHnTYr3x7SGOkn0+TYOfhxlmvUKXvwj+1T8MQ3+bNYoqCio@vger.kernel.org, AJvYcCXOjIjRNRPHCItbM/tPBrdS6hTa70C71y18buDLZ5aHzDXC4qAwIum7i7VJsDKLxXVJnrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYlRhNd3zbsLiYgkMoUCTQ6dSSvhmDQ2j4w/E4Js1InF2aDaDU
	pkB3C0M5uwt6UY1xmAu3hxq8IQqV+1oUUAtncPJ2ERXTOoc1W5FV5sY2
X-Gm-Gg: ASbGncsDVsF/qNHJjvM61uiJ40s0Kdr6WgqjyBuf/cQ+Rq+PN0jr69SS3HLrsAv2ylG
	q/Gpcd4TdSOsnUvoGLx7xC1fPulvZgN0rBkiOJTXwcP+mIlmdPaYJ01o78TyC+cex9W8mZ9bTU3
	HfZGG+Viodi5xmzAEiHZuoO418jbpyFodWroQG1sMCUV2mvOWR5NpK1fwAR3G4w9r0bIBLb7bB3
	ah1bmxcvM0XmNs9fWW6OyFCQ0vBARhUgghFQTxUVUi87YwASz1vOcMCEAJHHBnIXF8gXkRjFTQh
	M15Ggq2fUuuvVel0+BTIequ5cwrYwfjUCBeXse/YTymryyJnCCqkOJ6BPTwBUB2SSvkM+HTJOES
	qTzhJrMbK
X-Google-Smtp-Source: AGHT+IEfXDDzD9PnwNIYIzF/TekNHe0XANz+pvj6cipCHX/lkoLuDej0R9GMax6kH5rGQiod4Tat0w==
X-Received: by 2002:a05:6a21:648b:b0:21f:53e4:1925 with SMTP id adf61e73a8af0-21fbd523a1dmr15565101637.10.1750136048640;
        Mon, 16 Jun 2025 21:54:08 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890005f47sm8132852b3a.51.2025.06.16.21.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 21:54:08 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/3] test/vsock: Add retry mechanism to ioctl wrapper
Date: Tue, 17 Jun 2025 12:53:45 +0800
Message-Id: <20250617045347.1233128-3-niuxuewei.nxw@antgroup.com>
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

Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
int value and an expected int value. The function will not return until
either the ioctl returns the expected value or a timeout occurs, thus
avoiding immediate failure.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 tools/testing/vsock/util.c | 37 ++++++++++++++++++++++++++++---------
 tools/testing/vsock/util.h |  1 +
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 0c7e9cbcbc85..ecfbe52efca2 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -16,6 +16,7 @@
 #include <unistd.h>
 #include <assert.h>
 #include <sys/epoll.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <linux/sockios.h>
 
@@ -97,28 +98,46 @@ void vsock_wait_remote_close(int fd)
 	close(epollfd);
 }
 
-/* Wait until transport reports no data left to be sent.
- * Return false if transport does not implement the unsent_bytes() callback.
+/* Wait until ioctl gives an expected int value.
+ * Return a negative value if the op is not supported.
  */
-bool vsock_wait_sent(int fd)
+int ioctl_int(int fd, unsigned long op, int *actual, int expected)
 {
-	int ret, sock_bytes_unsent;
+	int ret;
+	char name[32];
+
+	if (!actual) {
+		fprintf(stderr, "%s requires a non-null pointer\n", __func__);
+		exit(EXIT_FAILURE);
+	}
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
+	return ret;
+}
+
+/* Wait until transport reports no data left to be sent.
+ * Return false if transport does not implement the unsent_bytes() callback.
+ */
+bool vsock_wait_sent(int fd)
+{
+	int sock_bytes_unsent;
+
+	return !(ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0));
 }
 
 /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 5e2db67072d5..f3fe725cdeab 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
 int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
 			   struct sockaddr_vm *clientaddrp);
 void vsock_wait_remote_close(int fd);
+int ioctl_int(int fd, unsigned long op, int *actual, int expected);
 bool vsock_wait_sent(int fd);
 void send_buf(int fd, const void *buf, size_t len, int flags,
 	      ssize_t expected_ret);
-- 
2.34.1


