Return-Path: <kvm+bounces-2742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 434EB7FD232
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 769CCB21E70
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F260E13AE6;
	Wed, 29 Nov 2023 09:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IepD+0Af"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33A12137
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701249380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CADU4JVHWbofrhTxkjgO6G/zYvZ/xrMuPSze9yms4VY=;
	b=IepD+0AfjVbALHqym8dxM7Re6W1/xcM3TbCSt7v8Rt7+SHkyaf9GxTffJCd2fbKtMPdy7c
	4Ti7bsAuem0NkhJsq7/B0RV+JJ9kty7fM8RI4imz0E43/hVgZSZnkC/FMboO+iwW/Bdlfd
	8U6xsYwqOnW4FZgrEw14s6V1jHtA8As=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-NGn0dVT1OmGFRR4ejcUTZg-1; Wed, 29 Nov 2023 04:16:18 -0500
X-MC-Unique: NGn0dVT1OmGFRR4ejcUTZg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-332ed7c0955so4053596f8f.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701249377; x=1701854177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CADU4JVHWbofrhTxkjgO6G/zYvZ/xrMuPSze9yms4VY=;
        b=nTkHZmTHw0gE+zU8tY1jp5/quqRWQgmMgu7ts7KUnioXu3V0hue/eZdcc1qWNy8rpx
         /14LL+Dg8Rn7kWPTvWtiJQJH6gXYQdIiJQ4xRr8OY4eE0d3Ty8y33yQPqpL89FBKDyi3
         LT2nlQN20dmSxeM1erXJ7p00TnBWCTR7On7UAkgjLzb2SYy1QdMRoM45Hk7utqe50bic
         EKlFZtbVFuHItRXzbth8EilC7F8qN7cOlSnou8g5Px861YVe2TF8pvW14A6IMRTv9J/M
         HnliixsEMujCjXlb7/BDWWw7Vk0aYgusCSp15zDqBKWHHUBYYynHKBT1SN/57Q7WqnpD
         hHUQ==
X-Gm-Message-State: AOJu0YyhkL1dJiub6ffnjJZ40LvzoCAJ80t32rdXrFY2l/er5cBIGHtV
	xzlDHZCmJRdsyeRdpD5dazPTgjy2vabFa2lA17NNcE//uK1GITm3MsvWspQBJkTW7JBWmJeWFgR
	72dEMx89I8jf9
X-Received: by 2002:a5d:4851:0:b0:332:e9f7:9a97 with SMTP id n17-20020a5d4851000000b00332e9f79a97mr12521036wrs.9.1701249377275;
        Wed, 29 Nov 2023 01:16:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgcDMmL2apMpExV/0IAafmUSGR6gwe+ShyMCEJQoVYlbBpIMfN71Gtgs9zs7GunIGSxHIvTg==
X-Received: by 2002:a5d:4851:0:b0:332:e9f7:9a97 with SMTP id n17-20020a5d4851000000b00332e9f79a97mr12521015wrs.9.1701249376936;
        Wed, 29 Nov 2023 01:16:16 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b00332c6a52040sm17152954wrt.100.2023.11.29.01.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 01:16:16 -0800 (PST)
Date: Wed, 29 Nov 2023 10:16:10 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 3/3] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Message-ID: <mklk6i6frkms33qntatlejbyl2czf7sp4quorkuxy6lpwmmlcn@foknxen36olr>
References: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
 <20231122180510.2297075-4-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231122180510.2297075-4-avkrasnov@salutedevices.com>

On Wed, Nov 22, 2023 at 09:05:10PM +0300, Arseniy Krasnov wrote:
>Test which checks, that updating SO_RCVLOWAT value also sends credit
>update message. Otherwise mutual hungup may happen when receiver didn't
>send credit update and then calls 'poll()' with non default SO_RCVLOWAT
>value (e.g. waiting enough bytes to read), while sender waits for free
>space at receiver's side. Important thing is that this test relies on
>kernel's define for maximum packet size for virtio transport and this
>value is not exported to user: VIRTIO_VSOCK_MAX_PKT_BUF_SIZE (this
>define is used to control moment when to send credit update message).
>If this value or its usage will be changed in kernel - this test may
>become useless/broken.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Update commit message by removing 'This patch adds XXX' manner.
>  * Update commit message by adding details about dependency for this
>    test from kernel internal define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>  * Add comment for this dependency in 'vsock_test.c' where this define
>    is duplicated.
> v2 -> v3:
>  * Replace synchronization based on control TCP socket with vsock
>    data socket - this is needed to allow sender transmit data only
>    when new buffer size of receiver is visible to sender. Otherwise
>    there is race and test fails sometimes.
>
> tools/testing/vsock/vsock_test.c | 142 +++++++++++++++++++++++++++++++
> 1 file changed, 142 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 5b0e93f9996c..773a71260fba 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1225,6 +1225,143 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
> 	}
> }
>
>+#define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
>+/* This define is the same as in 'include/linux/virtio_vsock.h':
>+ * it is used to decide when to send credit update message during
>+ * reading from rx queue of a socket. Value and its usage in
>+ * kernel is important for this test.
>+ */
>+#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE	(1024 * 64)
>+
>+static void test_stream_rcvlowat_def_cred_upd_client(const struct test_opts *opts)
>+{
>+	size_t buf_size;
>+	void *buf;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send 1 byte more than peer's buffer size. */
>+	buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE + 1;
>+
>+	buf = malloc(buf_size);
>+	if (!buf) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Wait until peer sets needed buffer size. */
>+	recv_byte(fd, 1, 0);
>+
>+	if (send(fd, buf, buf_size, 0) != buf_size) {
>+		perror("send failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	free(buf);
>+	close(fd);
>+}
>+
>+static void test_stream_rcvlowat_def_cred_upd_server(const struct test_opts *opts)
>+{
>+	size_t recv_buf_size;
>+	struct pollfd fds;
>+	size_t buf_size;
>+	void *buf;
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE;
>+
>+	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>+		       &buf_size, sizeof(buf_size))) {
>+		perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send one dummy byte here, because 'setsockopt()' above also
>+	 * sends special packet which tells sender to update our buffer
>+	 * size. This 'send_byte()' will serialize such packet with data
>+	 * reads in a loop below. Sender starts transmission only when
>+	 * it receives this single byte.
>+	 */
>+	send_byte(fd, 1, 0);
>+
>+	buf = malloc(buf_size);
>+	if (!buf) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Wait until there will be 128KB of data in rx queue. */
>+	while (1) {
>+		ssize_t res;
>+
>+		res = recv(fd, buf, buf_size, MSG_PEEK);
>+		if (res == buf_size)
>+			break;
>+
>+		if (res <= 0) {
>+			fprintf(stderr, "unexpected 'recv()' return: %zi\n", res);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+	/* There is 128KB of data in the socket's rx queue,
>+	 * dequeue first 64KB, credit update is not sent.
>+	 */
>+	recv_buf_size = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>+	recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>+	recv_buf_size++;
>+
>+	/* Updating SO_RCVLOWAT will send credit update. */
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>+		       &recv_buf_size, sizeof(recv_buf_size))) {
>+		perror("setsockopt(SO_RCVLOWAT)");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	memset(&fds, 0, sizeof(fds));
>+	fds.fd = fd;
>+	fds.events = POLLIN | POLLRDNORM | POLLERR |
>+		     POLLRDHUP | POLLHUP;
>+
>+	/* This 'poll()' will return once we receive last byte
>+	 * sent by client.
>+	 */
>+	if (poll(&fds, 1, -1) < 0) {
>+		perror("poll");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (fds.revents & POLLERR) {
>+		fprintf(stderr, "'poll()' error\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (fds.revents & (POLLIN | POLLRDNORM)) {
>+		recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);

Should we set the socket non-blocking?

Otherwise, here poll() might wake up even if there are not all the
expected bytes due to some bug and recv() block waiting for the
remaining bytes, so we might not notice the bug.

Stefano

>+	} else {
>+		/* These flags must be set, as there is at
>+		 * least 64KB of data ready to read.
>+		 */
>+		fprintf(stderr, "POLLIN | POLLRDNORM expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	free(buf);
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1335,6 +1472,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_double_bind_connect_client,
> 		.run_server = test_double_bind_connect_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM virtio SO_RCVLOWAT + deferred cred update",
>+		.run_client = test_stream_rcvlowat_def_cred_upd_client,
>+		.run_server = test_stream_rcvlowat_def_cred_upd_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>


