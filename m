Return-Path: <kvm+bounces-2857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC057FEB08
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09445B20EAD
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E63730339;
	Thu, 30 Nov 2023 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPlKKki1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2C210E2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701333751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7D3F6df4inV556FrwBxrc42REjXaDfM0mMQ3apZMcjc=;
	b=TPlKKki1tjQ54rLaoiKCx4rxi071mv/x+gW4f+CQ3bFwRo4R17aqgjONwBbD+VAyrJntNR
	z+6C6xXsxPq2Dp4KVs/q8C8ModG8yBi6UCFXf1NgY9MCWct81ASN8kz5wwe80PGZKvHsOe
	WXdjudy7yigp3+n005fC08ArLMBOzXE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-BGqliz2IOX6XMhzcqgEJPg-1; Thu, 30 Nov 2023 03:42:29 -0500
X-MC-Unique: BGqliz2IOX6XMhzcqgEJPg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50abbf4ee79so869954e87.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 00:42:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701333748; x=1701938548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7D3F6df4inV556FrwBxrc42REjXaDfM0mMQ3apZMcjc=;
        b=FwlX83xZFDCPy3JS/JOvuLgtL+JoST7L34FdFu0SG1GiYCrgCVNCVYYX2GJQW+yhQ0
         7ObMYmYsfiMIQ7lueZO7LlsVt4KTni+H7KVPNTtKatyQFfVS1ph+HGMo8C2rBbphD8bx
         EaPBQh9xUVb0VF7fwG/HjHc3a1Gm9hK7mzlo0G0Ve96Gkb4b/pwZgQSFztye109nYO7B
         tyMksidhm/uForj2XYQh38E8zpkBU+8zt3CSd2Q2bA0zQ6pmEJ2Jf0wKxiUO1Wnr2iy/
         t0Cupgusyd3KlGXgk/V4PBk9Qx4/423jXMNG5w4HFoIVpo7FwtLtb0h0hgDU3err5+bM
         fgRQ==
X-Gm-Message-State: AOJu0Yyk3QBAiOTr9xAS6lo9+57kMSq+jigsOkMyZaWUy3WctsXKeQaY
	H66Z6KmXKyxG5IwssJiORJ46xNNjzI1ulSoiDziGjlQgUCr3FAjM2jl9ju+xfHR/uPiULt1P94E
	f8soRYbZuOOi1
X-Received: by 2002:a05:6512:3b9c:b0:50b:c699:b4f7 with SMTP id g28-20020a0565123b9c00b0050bc699b4f7mr3397305lfv.38.1701333747853;
        Thu, 30 Nov 2023 00:42:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF46tsSMx3GFRMB0rEht8D0BV08VBU38MMS0vijWpyoDx69xdzGo0P1yQaSYch0IvV8BhAW0Q==
X-Received: by 2002:a05:6512:3b9c:b0:50b:c699:b4f7 with SMTP id g28-20020a0565123b9c00b0050bc699b4f7mr3397292lfv.38.1701333747517;
        Thu, 30 Nov 2023 00:42:27 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id v9-20020a05600c470900b004063cd8105csm4856905wmo.22.2023.11.30.00.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 00:42:26 -0800 (PST)
Date: Thu, 30 Nov 2023 09:42:21 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 3/3] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Message-ID: <gllsmqbutpu3c7lmnkwmxjh6qz5efdmihdxu4sln3fybg6dmyk@morgqd5xyqyl>
References: <20231129212519.2938875-1-avkrasnov@salutedevices.com>
 <20231129212519.2938875-4-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231129212519.2938875-4-avkrasnov@salutedevices.com>

On Thu, Nov 30, 2023 at 12:25:19AM +0300, Arseniy Krasnov wrote:
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
> v3 -> v4:
>  * Replace 'recv_buf()' to 'recv(MSG_DONTWAIT)' in last read operation
>    in server part. This is needed to ensure that 'poll()' wake up us
>    when number of bytes ready to read is equal to SO_RCVLOWAT value.
>
> tools/testing/vsock/vsock_test.c | 149 +++++++++++++++++++++++++++++++
> 1 file changed, 149 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 01fa816868bc..68f7037834db 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1232,6 +1232,150 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
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
>+		ssize_t res;
>+
>+		res = recv(fd, buf, recv_buf_size, MSG_DONTWAIT);
>+		if (res != recv_buf_size) {
>+			fprintf(stderr, "recv(2), expected %zu, got %zu\n",
>+				recv_buf_size, res);
>+			exit(EXIT_FAILURE);
>+		}

Why not just passing MSG_DONTWAIT to recv_buf()?

Thanks,
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
>@@ -1342,6 +1486,11 @@ static struct test_case test_cases[] = {
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


