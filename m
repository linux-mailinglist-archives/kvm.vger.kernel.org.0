Return-Path: <kvm+bounces-2913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 301BC7FF040
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 14:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8010AB20EA3
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 13:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E97C482CA;
	Thu, 30 Nov 2023 13:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKyBQfx/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635ACE6
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701351373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d7NbcS23obYuAf1xLnepErpBcuJF3mxbRXVeb1/aOyk=;
	b=FKyBQfx/9NjM/u6Ve5yW579MwhtpcogrJIue1EplIGpCuwLQZxSwdvYJHsgDRu3wquMhPg
	TMQsDPd3ge+lPfHae8dGYp/7xiNam5m25WKmqOQ4cUKC/rvVBfBmKshoG0C01lMkNqf0nT
	nlATinwgPhv73/7FrOLJBCROW8Qo+aA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-wh1a0dzHMFWE8rG9F-57RA-1; Thu, 30 Nov 2023 08:36:10 -0500
X-MC-Unique: wh1a0dzHMFWE8rG9F-57RA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332e71b8841so828485f8f.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 05:36:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701351369; x=1701956169;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7NbcS23obYuAf1xLnepErpBcuJF3mxbRXVeb1/aOyk=;
        b=cO7NGkRyLXNIFQPLZAfTllOSjQS9o15Z6pGbv3WYe4iVUQzcj42Rtx37o8OaVGkJoY
         9FxrvP/L5kOakcANSbRiW01eWPsKZldYAfxmNTrQeLBIIFW5E/0oGxqJYMmFpGQI92LS
         ry2FA47je29M81FdcYmkiL1l9FFrpqIQwsFb84ueza4ngocAXNKZCMgjJSW3izLdSM9O
         Rfo2j8nu3YhVqa9yX0yV0s4cL7TmrTBvVDXfRfMS4LMbKJrvK0tafnYvIeyV0luky0ot
         8Oqs5lfET6e0AghtW9mzopl0h0o0hAK/GUsjzavLGv9bJCAb9fGWwv51r8e1CmeEXXzv
         gcZQ==
X-Gm-Message-State: AOJu0Ywa07dmAZwvplwcDYKmrtE8Lb1JKrLT1PubBkzl46P/hwlTngLW
	9ZjWQi5WnUfi+ditZtBfiTqLLm8me0zrkc0RGhPZ4YEloJ2CbXGYYkPMUDCIdOEoGVTWMgbfECd
	TJgYIdnT73ZVI
X-Received: by 2002:a5d:448f:0:b0:332:c593:16c with SMTP id j15-20020a5d448f000000b00332c593016cmr14884083wrq.45.1701351369123;
        Thu, 30 Nov 2023 05:36:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR3jKJGt6tBdWO3pDi42NqgbDR7i64AOzGM0BK73Ce9FYmYXkKqlaQaBsR/IcPbXWMWnLT+Q==
X-Received: by 2002:a5d:448f:0:b0:332:c593:16c with SMTP id j15-20020a5d448f000000b00332c593016cmr14884068wrq.45.1701351368725;
        Thu, 30 Nov 2023 05:36:08 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id j14-20020a5d464e000000b003330f9287a8sm1582694wrs.51.2023.11.30.05.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 05:36:08 -0800 (PST)
Date: Thu, 30 Nov 2023 14:36:03 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v5 3/3] vsock/test: SO_RCVLOWAT + deferred
 credit update test
Message-ID: <3i2ohqtxyncvd7n32rgoui3gf44jpupdbsa3yue7dnflgftalj@7ldbyg5deytj>
References: <20231130130840.253733-1-avkrasnov@salutedevices.com>
 <20231130130840.253733-4-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231130130840.253733-4-avkrasnov@salutedevices.com>

On Thu, Nov 30, 2023 at 04:08:40PM +0300, Arseniy Krasnov wrote:
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
> v4 -> v5:
>  * Use 'recv_buf(MSG_DONTWAIT)' instead of 'recv(MSG_DONTWAIT)'.
>
> tools/testing/vsock/vsock_test.c | 142 +++++++++++++++++++++++++++++++
> 1 file changed, 142 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 01fa816868bc..d66bc4987026 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1232,6 +1232,143 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
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

I would add a comment here, like this:

   We expect poll to wake up only after receiving all the
   bytes requested with SO_RCVLOWAT, so we don't want the
   read to block waiting for more.

The rest LGTM.

Thanks,
Stefano

>+		recv_buf(fd, buf, recv_buf_size, MSG_DONTWAIT, recv_buf_size);
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
>@@ -1342,6 +1479,11 @@ static struct test_case test_cases[] = {
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


