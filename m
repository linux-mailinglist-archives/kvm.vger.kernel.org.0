Return-Path: <kvm+bounces-49620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB37ADB2E5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B8607AA971
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8AA2980BF;
	Mon, 16 Jun 2025 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GSfgzVfT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4202877E3
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750082353; cv=none; b=m4Q4CQCXrz3xAAGyfLIGUYqjTsJ8jL8W3wcVy9yVzlS2JE/oQw8ahJpnc0RXyewB1T2R8/LS6kgPu43w1WKVFlu/+DVVSwgDGFTguasQ11f8iALXLa9eTZj4t5x5q2oVjtnjsoSpHC6t1xHoFQLj6LjL6LHszHfgvo7nzOwb4V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750082353; c=relaxed/simple;
	bh=vqy7nH2TRHhiiSz/OGaQv55N1pBGXt8kziKc5Kqy/AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=heFAH8DE+XYTjPs27wpgKKJwbDxpEks5ME3C72A7S5yI9p4iaz1eZARhLR6i+JLfIH3WSe3KYgK8NgAoznCW9ewpa45dtN9+JpAwf6qrcCO/xmFBzZy8RSpzZ0bumjKELBWzvIMFhQx77FXWuJE4BqxYCmcRLKo0NCRwQqX4ei4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GSfgzVfT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750082350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MDXOR2+9SFucAcceARHVMU6Tuqx3sff55HmAoDR3SqQ=;
	b=GSfgzVfTTzMuhSiD6GlCQqbvoRmHKJ1bo3jZtM7DebOrZnCnaMLicGEPYI1+oi3Qm1prZC
	keKUZ0sIY6q+yXjGZkiPSggg3iKD+namnCDL8rX0rM2J1AhsVV0Whku6OoKvJM3155DEum
	ALJ5/+MptkZbIuvtYYiHs7NoEhKL5G8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-B5jWeBEaP4-2UQcbneRCEQ-1; Mon, 16 Jun 2025 09:59:08 -0400
X-MC-Unique: B5jWeBEaP4-2UQcbneRCEQ-1
X-Mimecast-MFC-AGG-ID: B5jWeBEaP4-2UQcbneRCEQ_1750082347
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f7ebfd00so2117760f8f.2
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 06:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750082347; x=1750687147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDXOR2+9SFucAcceARHVMU6Tuqx3sff55HmAoDR3SqQ=;
        b=piqAssoDSR/rOhb35axGrv2yus0LlzzQuaxfmRZrGJn0IVh6m1u7mcKFW3WR8MPtNe
         V7AGBNLCV1iXuwWSkb6I7y5N1cHFbwGfDC75kZFGIE4TMNT/ALTlY29/1OHFc2G1+J29
         d5/nOH6118ydLARA+F767xO9nShJBw3P3ZrH9ow5P33rv6Cz1AmOxiOLRSgMR3hjmlds
         aVb3vpSHrhcMXPgPHm7gpyYjIqEg8hPCtMxo0r1FH4ijqpoU7fdtHUVwijcCYZj9xQOE
         jt9BO13YBZlmfMsYbwqvRC2nu/J5ik3Hmfwppl2oFC2esjP/4Eyghxb69UDAyKEbKcud
         f4Hg==
X-Forwarded-Encrypted: i=1; AJvYcCViOtH5GI3dyV0tzeqCmVIPS8qaf5HI3Dka66Cu0Z0TAiBsgUNdL50dsPv3127HhyW+x94=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3rwXymoEjnIF8Z61Uzwzug7CsKSOyKEHpt7d6QEQJkLb1HXzq
	GsUkHFlnpRQM9CeP+eYNLvTUdT4s4K9ERCAYhck01y0CWnQs+/2tMJYCp+6wYoaQFTxWrwhtjkA
	NDsxUFodtyVra2yDppRcuUQRTlpfeZSn8tj5qs4BvOZVlIoj9V1wU2g==
X-Gm-Gg: ASbGnctyDzSgzhV0FE+jmub9xacuKKMo36Nt4G7cDGfWFkCgV0gUsrgu1kj4NXH/AP6
	LJ/Te3Refo03twehl/YR3lkGvkSvgwDhEViP3YqJZHbA9KgKVSPolFnPNImHcCCdM0CJTI00+fE
	P17JvRF0ll/PratIrsVKnFKbFKNZRFYI8jV54Tlhx1H2v+/M/r8xTKLCyJjaekDkfPqpVl2SOKb
	MkFCWL4lqWTAk1koiI+j7XAfYWAv3xQZbPTkmW19DKn9PnVvwlvt2um5N7U/CQ0qFiVgs4Ogsjq
	UmLm+yKmG2ECZLvm5+WSm1sP9kE=
X-Received: by 2002:a05:6000:2913:b0:3a4:c2e4:11b with SMTP id ffacd0b85a97d-3a572e5889amr7854242f8f.51.1750082346885;
        Mon, 16 Jun 2025 06:59:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRgV7a2zE81Cn4q+8HsPH4Efg/1Yo3ECeuGZsn/U6pXmXm9DovaRfGerUSfCxyx2uouMUMag==
X-Received: by 2002:a05:6000:2913:b0:3a4:c2e4:11b with SMTP id ffacd0b85a97d-3a572e5889amr7854209f8f.51.1750082346294;
        Mon, 16 Jun 2025 06:59:06 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.202.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2354fbsm143617795e9.15.2025.06.16.06.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 06:59:05 -0700 (PDT)
Date: Mon, 16 Jun 2025 15:59:01 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	fupan.lfp@antgroup.com, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v2 3/3] test/vsock: Add ioctl SIOCINQ tests
Message-ID: <2oxz7toygswngn7kfmsrbmpikk5qggwbvk3oxb5ucrbq3pcfff@azc54m4hwlfb>
References: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
 <20250613031152.1076725-4-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250613031152.1076725-4-niuxuewei.nxw@antgroup.com>

On Fri, Jun 13, 2025 at 11:11:52AM +0800, Xuewei Niu wrote:
>This patch adds SIOCINQ ioctl tests for both SOCK_STREAM and
>SOCK_SEQPACKET.
>
>The client waits for the server to send data, and checks if the SIOCINQ
>ioctl value matches the data size. After consuming the data, the client
>checks if the SIOCINQ value is 0.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> tools/testing/vsock/util.c       | 36 ++++++++++----
> tools/testing/vsock/util.h       |  2 +
> tools/testing/vsock/vsock_test.c | 83 +++++++++++++++++++++++++++++++-
> 3 files changed, 111 insertions(+), 10 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 0c7e9cbcbc85..472246198966 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -97,28 +97,46 @@ void vsock_wait_remote_close(int fd)
> 	close(epollfd);
> }
>
>-/* Wait until transport reports no data left to be sent.
>- * Return false if transport does not implement the unsent_bytes() callback.
>+/* Wait until ioctl gives an expected int value.
>+ * Return a negative value if the op is not supported.
>  */
>-bool vsock_wait_sent(int fd)
>+int ioctl_int(int fd, unsigned long op, int *actual, int expected)
> {
>-	int ret, sock_bytes_unsent;
>+	int ret;
>+	char name[32];
>+
>+	if (!actual) {
>+		fprintf(stderr, "%s requires a non-null pointer\n", __func__);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
>
> 	timeout_begin(TIMEOUT);
> 	do {
>-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
>+		ret = ioctl(fd, op, actual);
> 		if (ret < 0) {
> 			if (errno == EOPNOTSUPP)
> 				break;
>
>-			perror("ioctl(SIOCOUTQ)");
>+			perror(name);
> 			exit(EXIT_FAILURE);
> 		}
>-		timeout_check("SIOCOUTQ");
>-	} while (sock_bytes_unsent != 0);
>+		timeout_check(name);
>+	} while (*actual != expected);
> 	timeout_end();
>
>-	return !ret;
>+	return ret;
>+}
>+
>+/* Wait until transport reports no data left to be sent.
>+ * Return false if transport does not implement the unsent_bytes() callback.
>+ */
>+bool vsock_wait_sent(int fd)
>+{
>+	int sock_bytes_unsent;
>+
>+	return !(ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0));
> }

Please split this patch in 2, one where you do the refactoring in 
util.c/h and one for the new test.

>
> /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index 5e2db67072d5..945c85ff8d22 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -3,6 +3,7 @@
> #define UTIL_H
>
> #include <sys/socket.h>
>+#include <sys/ioctl.h>

Why we need this in util.h?

> #include <linux/vm_sockets.h>
>
> /* Tests can either run as the client or the server */
>@@ -54,6 +55,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
>+int ioctl_int(int fd, unsigned long op, int *actual, int expected);
> bool vsock_wait_sent(int fd);
> void send_buf(int fd, const void *buf, size_t len, int flags,
> 	      ssize_t expected_ret);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index f669baaa0dca..43996447f9a2 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -20,7 +20,6 @@
> #include <sys/mman.h>
> #include <poll.h>
> #include <signal.h>
>-#include <sys/ioctl.h>
> #include <linux/time64.h>
>
> #include "vsock_test_zerocopy.h"
>@@ -1305,6 +1304,58 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> 	close(fd);
> }
>
>+static void test_unread_bytes_server(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int client_fd;
>+
>+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
>+	if (client_fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (int i = 0; i < sizeof(buf); i++)
>+		buf[i] = rand() & 0xFF;
>+
>+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
>+	control_writeln("SENT");
>+	control_expectln("RECEIVED");
>+
>+	close(client_fd);
>+}
>+
>+static void test_unread_bytes_client(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int ret, fd;
>+	int sock_bytes_unread;
>+
>+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENT");
>+	/* The data has arrived but has not been read. The expected is
>+	 * MSG_BUF_IOCTL_LEN.
>+	 */
>+	ret = ioctl_int(fd, TIOCINQ, &sock_bytes_unread, MSG_BUF_IOCTL_LEN);
>+	if (ret) {
>+		fprintf(stderr, "Test skipped, TIOCINQ not supported.\n");
>+		goto out;
>+	}
>+
>+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
>+	// All date has been consumed, so the expected is 0.
>+	ioctl_int(fd, TIOCINQ, &sock_bytes_unread, 0);
>+	control_writeln("RECEIVED");
>+
>+out:
>+	close(fd);
>+}
>+
> static void test_stream_unsent_bytes_client(const struct test_opts *opts)
> {
> 	test_unsent_bytes_client(opts, SOCK_STREAM);
>@@ -1325,6 +1376,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
> 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
> }
>
>+static void test_stream_unread_bytes_client(const struct test_opts *opts)
>+{
>+	test_unread_bytes_client(opts, SOCK_STREAM);
>+}
>+
>+static void test_stream_unread_bytes_server(const struct test_opts *opts)
>+{
>+	test_unread_bytes_server(opts, SOCK_STREAM);
>+}
>+
>+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
>+{
>+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
>+}
>+
>+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
>+{
>+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
>+}
>+
> #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
> /* This define is the same as in 'include/linux/virtio_vsock.h':
>  * it is used to decide when to send credit update message during
>@@ -2016,6 +2087,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_unsent_bytes_client,
> 		.run_server = test_seqpacket_unsent_bytes_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
>+		.run_client = test_stream_unread_bytes_client,
>+		.run_server = test_stream_unread_bytes_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
>+		.run_client = test_seqpacket_unread_bytes_client,
>+		.run_server = test_seqpacket_unread_bytes_server,
>+	},

I think I already mentioned in the previous version: please add new 
tests at the end of the array, so we can preserve test IDs.

Thanks,
Stefano

> 	{
> 		.name = "SOCK_STREAM leak accept queue",
> 		.run_client = test_stream_leak_acceptq_client,
>-- 
>2.34.1
>


