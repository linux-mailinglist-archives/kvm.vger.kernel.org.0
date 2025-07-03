Return-Path: <kvm+bounces-51359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D36AF687B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 05:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FC7C4E6F4B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 03:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D250722A4EF;
	Thu,  3 Jul 2025 03:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="futhr3sV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8472D1F9F70;
	Thu,  3 Jul 2025 03:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751512005; cv=none; b=BZdLhM6S5MKz2miPC+51+Q9GgiuGFunFz/rSrt4K4Tf+cqghFWvpAWk/lY0nHTwe6YrUUuH0zV4yTZzPNkxWanaSOG4UJpZnXH7xt2p96Fmw8c2z16SxvassjqOxExCxMqgTtJ53zjZcjjcZjfSTdhM0LuRqg5yOy5fZ7hEP3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751512005; c=relaxed/simple;
	bh=g0goUqpz0H5nqzeA/3fuXMeQmy/4V6hWpW6/CbP1VvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l5TFl84bpBDACE9sqF1cQ1Wl2i28AEFzKb+Gunskc/SxFXtvSGyIPJQapND/CSyzVifl0Fl1kg8H+2VNYzafeAAXybcHOuXuv2dBMCtpwVH08o5dJmXJUkuPGDyJw3CBDCypn7+2zf3UkssiPCoDPR7lK/zllqCrwHli4DEjjEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=futhr3sV; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-74801bc6dc5so435571b3a.1;
        Wed, 02 Jul 2025 20:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751512003; x=1752116803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUDKiPyVRQeazWkY4m2jYwgTMEJufvXw/+pCwXThNj0=;
        b=futhr3sVqvVbv5PeFK1/8Ra+MBVeYj2V8zlzgc04nQ8endPFnj7RW4svet9lZJAbKT
         cEV31cLqDBFLmLsQm8Jf2skGo0hnsMqRKGabEQ0+URkjaSgtorhH/wAkLPhJtkaLxbHu
         xRawBoNzzdEBBjOvcBAFqdIhYdzewB/jVEe+/9/bhTVpMcSfm0UCFAzY//iLgxD8b4qJ
         kLEmggdEfn7meLgubbgeUxiA/2KSQf+ja531OjxqS93vfSikUQVAoeSS/fKcwyeU0rbd
         XJ6Q05pJiPJGMYXwoUxonU9Y3JT/E/6ofoy1Dvff6NyQYk+NCkO4IWcq/M74ortV5BOJ
         kbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751512003; x=1752116803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUDKiPyVRQeazWkY4m2jYwgTMEJufvXw/+pCwXThNj0=;
        b=s//J6L/Vqfb67EakcIr8mJTjchfNGz8YC0O6EZqIFanGX/JFQEYyyyTbwne7xqEjmR
         FkpREPXIZcVOxyS0D1SDlhFx3YJXe0AxQ1G28EDDjblLynQg9s9pPi0n/7L/50ROkYno
         yCTMwHS8rHEi03qUWb9Gb52SZerZyPvhCGb/P/DsxOM1jVwcq7Wolw9lXdLc9NbOswVZ
         vWokrceVcdBHfCOjy6VghkZUsbfGN4COqjMT4p+FBTMgn2qFwfjLRWMQEXdzAB8+A1/J
         Any/GvpWIG3/ghpx1XCI46Lykhi4yIfUgAgCp2uAScRT5FKINYhEMQ3cZ53vAKbdtjrk
         McWg==
X-Forwarded-Encrypted: i=1; AJvYcCVeWs739Os2K1UWjy0HwGDr+LHiy6FI/NfWysizNPhri8m3QRzlyZ+nhHSmq1Uz3Sdxxo0=@vger.kernel.org, AJvYcCWRiudUrqgxVZ+gickPFuFMQVD2ieUJox5uPsfQdS2z4mIdhAgQ4KXWwQwYnf8XFDq684SUUNn5d1VcxROS@vger.kernel.org, AJvYcCWoTqS8OahUvQLE/zhC2jTqr1P5A1DpF/lwfTbuKzZiJaOt3hGR+tV9mPlMKQkl58470PpgqVrf@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt32Kx+S4dc+vKhofa7FdVj+vQ15w0Adx+yqCIwt3NRbuDs1O+
	iZTSzficQ/svkybPbjP45vACNXlU22RyrR4iQ+G72E+dKndgOIJlvJPg
X-Gm-Gg: ASbGnctMiu5CgI+KFQjPoCxvbPcJZS04RdoISpqM/XuHiOwPgaVe6XZOxVYTWo1+UTZ
	nPC8VqIi8J7mrghw8L1S6hWvAI92zBHblXuKicf4GdO7irjbfp8OhV4tPtvZ/2dqK+ERjPbSG15
	mX7ssyAPilzZui/zK45j1S0IAmZ8cBn55RwBwszT5FEVAuyTl/rKxaN8epkQ7Fv5JHUV420JuO/
	5IpmT4y2SGurcNGS2+llaJKJGyatMAnbCapxG6Rwo+PIRIVZX1UQaX9/Oilh/ofu7ZqLiOJEGti
	FfoUO3ry+X451X05mrmfb/PiqOwyueXfQkfKx+NdMpEj8zOmRaS5o8deYj7CJ9l3qWCKU5xblUI
	qQ64F3rdd
X-Google-Smtp-Source: AGHT+IFz7kt0Nb7vZz+tzUh5I+gOTwteT4lcjZk9zNPo6PfyuL6H+Px1Zb73lqI3Wo071I67AWpnGQ==
X-Received: by 2002:a05:6a00:2d94:b0:736:9f2e:1357 with SMTP id d2e1a72fcca58-74cd5b575bdmr707117b3a.12.1751512002612;
        Wed, 02 Jul 2025 20:06:42 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af541d9a5sm16108617b3a.62.2025.07.02.20.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 20:06:42 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	decui@microsoft.com,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	leonardi@redhat.com,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [RESEND PATCH net-next v4 3/4] test/vsock: Add retry mechanism to ioctl wrapper
Date: Thu,  3 Jul 2025 11:05:14 +0800
Message-Id: <20250703030514.845623-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2cpqw23kr4qiatpzcty6wve4qdyut5su7g7fr4kg52dx33ikdu@ljicf6mktu5z>
References: <2cpqw23kr4qiatpzcty6wve4qdyut5su7g7fr4kg52dx33ikdu@ljicf6mktu5z>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Resend: the previous message was rejected due to HTML
Resend: forgot to reply all...

> On Mon, Jun 30, 2025 at 03:57:26PM +0800, Xuewei Niu wrote:
> >Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
> >int value and an expected int value. The function will not return until
> >either the ioctl returns the expected value or a timeout occurs, thus
> >avoiding immediate failure.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > tools/testing/vsock/util.c | 32 +++++++++++++++++++++++---------
> > tools/testing/vsock/util.h |  1 +
> > 2 files changed, 24 insertions(+), 9 deletions(-)
> >
> >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> >index 0c7e9cbcbc85..481c395227e4 100644
> >--- a/tools/testing/vsock/util.c
> >+++ b/tools/testing/vsock/util.c
> >@@ -16,6 +16,7 @@
> > #include <unistd.h>
> > #include <assert.h>
> > #include <sys/epoll.h>
> >+#include <sys/ioctl.h>
> > #include <sys/mman.h>
> > #include <linux/sockios.h>
> >
> >@@ -97,28 +98,41 @@ void vsock_wait_remote_close(int fd)
> > 	close(epollfd);
> > }
> >
> >-/* Wait until transport reports no data left to be sent.
> >- * Return false if transport does not implement the unsent_bytes() 
> >callback.
> >+/* Wait until ioctl gives an expected int value.
> >+ * Return false if the op is not supported.
> >  */
> >-bool vsock_wait_sent(int fd)
> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected)
> 
> Why we need the `actual` parameter?

We can exit early `if (*actual == expected)`, and the `expected` can be any integer.
I also make it to be a pointer, because the caller might need to have the actual value.

Thanks,
Xuewei
 
> > {
> >-	int ret, sock_bytes_unsent;
> >+	int ret;
> >+	char name[32];
> >+
> >+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
> >
> > 	timeout_begin(TIMEOUT);
> > 	do {
> >-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
> >+		ret = ioctl(fd, op, actual);
> > 		if (ret < 0) {
> > 			if (errno == EOPNOTSUPP)
> > 				break;
> >
> >-			perror("ioctl(SIOCOUTQ)");
> >+			perror(name);
> > 			exit(EXIT_FAILURE);
> > 		}
> >-		timeout_check("SIOCOUTQ");
> >-	} while (sock_bytes_unsent != 0);
> >+		timeout_check(name);
> >+	} while (*actual != expected);
> > 	timeout_end();
> >
> >-	return !ret;
> >+	return ret >= 0;
> >+}
> >+
> >+/* Wait until transport reports no data left to be sent.
> >+ * Return false if transport does not implement the unsent_bytes() callback.
> >+ */
> >+bool vsock_wait_sent(int fd)
> >+{
> >+	int sock_bytes_unsent;
> >+
> >+	return vsock_ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0);
> > }
> >
> > /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> >diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> >index 5e2db67072d5..d59581f68d61 100644
> >--- a/tools/testing/vsock/util.h
> >+++ b/tools/testing/vsock/util.h
> >@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> > int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> > 			   struct sockaddr_vm *clientaddrp);
> > void vsock_wait_remote_close(int fd);
> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected);
> > bool vsock_wait_sent(int fd);
> > void send_buf(int fd, const void *buf, size_t len, int flags,
> > 	      ssize_t expected_ret);
> >-- 
> >2.34.1
> >

