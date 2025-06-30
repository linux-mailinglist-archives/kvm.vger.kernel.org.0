Return-Path: <kvm+bounces-51067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0451FAED5E8
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D3B516F8DC
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DBA239E68;
	Mon, 30 Jun 2025 07:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kr/RquQu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45F2367D1;
	Mon, 30 Jun 2025 07:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751269140; cv=none; b=EEskfv+gIAn/XFXzQ7NiiIqBb5cybwDKcKz/9zMsIYI42bXklLWvlJyder0NaXcLybHDQyUjNlx21BmzIz4konJt2eO7gTUI4zvD5REtdOKAg6FW1GFfflTISLMqRTbZsFMSQYeBmO096CwpIpM8+W2BhD7MnUXlgrgv+7PaV5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751269140; c=relaxed/simple;
	bh=6e8nhq3wAutajxTDZ1caB5Wt0cNk1tW6jl9nRmn/iB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aFfOGjnG/MMaYIXbWMeJyiLVI/Ul8LmZAuHTVcxr0kpg586Avwo6VSBuG3tjiIwOslhDvcH/U0lhh51zRzB3cKrCJ5h+iABSCeaJAumZwKkHjbWDSMg7ukwiA1ey/KoPmc5pHoJF4FU8o4chNBwNoUg+jMWKcQZQ54ZgR77LBc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kr/RquQu; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-73c17c770a7so2353848b3a.2;
        Mon, 30 Jun 2025 00:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751269138; x=1751873938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCu94amvUYw2PYDfqBO7v4QOw2C4FxuMQOpeOs/4SKI=;
        b=kr/RquQu05Mcf/lCUKFnVwItA3uHvdavoikEZkISWkYM06ewjNwgoPHi8c3c0m+XL0
         +pr4euS+mY2Ed8rzLEVSVbxXArb9mYSe5ktrECGcb/XBr5JyCBGl6GCB+RZf8OcGISYW
         bsDpTvrSVOjfCkYJiVrJ/fFe+VCj6AnA2cmDmY+irdd2+VLHQCx6+91zZp2HE2MEx8uN
         RxO2MCzZRj62CTSDSr15C+lA7cwwtxf/6SkqJperP2IxjT3pIxxIXPsKr7h+kSmZH7BA
         HDW5TTB9d1regzg0i2vX9nmnoWw7fFOiM80IMwIXYkaGVvyE9AjRn1j5ESEh+Xo0y5Ew
         cFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751269138; x=1751873938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCu94amvUYw2PYDfqBO7v4QOw2C4FxuMQOpeOs/4SKI=;
        b=s9jSo61Tc2soHDi7kdjlC+XtDVHkgn6MJQpEyEIhFP6u1G7QrjGZV4LOnuxS9/W3+t
         hXiI0SXuPsRvCSn7i3hwekb+TV19K+2VoQNNZKo64Xe5fD0XIlngWEdb/3G1BlPzxc8H
         iZq39MMbsVcnM45W1Mb2fCZTP6Mbnf+NCatW0yzHQC8NGF05btZ4vAWfDX2uLtPnFNMK
         5CVm8ifR99R87tSCO0d+e6FK9dc2L/3mO30LjFaCXp76JNaM2GFktIfbfXPOypnWUcqd
         S6qnwzqjmonTCKQEJunY7C9wXqn8z4QhApuoVCLnTfNTH1JteUsagt3RgPaYBNtrK0/H
         D6cw==
X-Forwarded-Encrypted: i=1; AJvYcCVBJ7hYjygFUj6AsNclOYcxB+HQbBVDuG4zx38KsIsDICM8kElyAClRYZn6kdk1whxf+RE=@vger.kernel.org, AJvYcCVLYMtIn93rzpzAGeZ0LGAElaqrsnQtu7xTLg72GfBNDqbptNw69zYcXExCrNe43M7+Cx1p66uk@vger.kernel.org, AJvYcCVN1H4R+LbUJCb0Sus7vrS1CMoaoQLV/RYeWbpmBsJSlMB5JkD4MeF06BkhLnRCWQba3qrE5Q0A/9IR4QyU@vger.kernel.org
X-Gm-Message-State: AOJu0YxqwQdNFtSkq6yYDJr3kmZfcHpKTOnFzGjf08fMf4+Z6ddilJef
	fnskXrBc/NzYh/F+oy1OA7oA45jOLpgZOvvWkdYCOMu+qL33bItNrOBr
X-Gm-Gg: ASbGncuvgP0JUo8GWs/3nieSL+bYzfrbCtlheBHI8dMRuBEbr3otg2xxhvZHd7ozn1W
	47+Vfyjc+sr9y+ObNP902SDX7bvruAf1Edp38Fy263X6T6Vz9NIgKS6x3zGkaKY3VTB5OXa+zWg
	0/4oYodndsD5CKpSrWOPf3aAnvGQp9g1HhJPYWV6o/zwbepVIWLyAgUbXzWgszCE8zT9IpSlyts
	kxuMz6Nv2NKN/Js7ajII7RKYmjH3M64TbuXARwFIgEWr95aAw5FXEAxcwf8h4FeOnvcmtAO1iNE
	7WZnJdPoyZ1FjYAIwMl3nzqtyZTE/OOZ863gi9GbVWAvkfQV0lkZn3x94gJftAc6oETtZqMLBVB
	B1F8LMqKx
X-Google-Smtp-Source: AGHT+IG/jR+dNY+ztEgPJIk4JDK34oOEoYzWT7UbmazWLOyYpCAQk+M2Lag6gLOzU5qTgSOklpp6uA==
X-Received: by 2002:a05:6a00:b8e:b0:742:b3a6:db16 with SMTP id d2e1a72fcca58-74af6f6d21amr19468497b3a.20.1751269138035;
        Mon, 30 Jun 2025 00:38:58 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af55c8437sm8075175b3a.115.2025.06.30.00.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:38:57 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/3] test/vsock: Add retry mechanism to ioctl wrapper
Date: Mon, 30 Jun 2025 15:38:26 +0800
Message-Id: <20250630073827.208576-3-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
References: <20250630073827.208576-1-niuxuewei.nxw@antgroup.com>
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


