Return-Path: <kvm+bounces-16992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A2B8BFAAC
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:15:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0F551F254A8
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 10:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6552E8172E;
	Wed,  8 May 2024 10:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K3Z6O0rn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84A8120A
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 10:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715162913; cv=none; b=qdQ8HCYsTcPS9xrv7uW2MRnttejr9TPKH3lWYWBkXthm88P6MhndSfbRTmxdlApV/BB3+3qsrc6zWHpDQS5kVHtdOgodFt2ApNYpPmgFjCJRw6CDx+PSPwyZwcT4fJnm54fqSsqI849b80OvSjEqiQ+Syz9WwIeChQaVmTRm0ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715162913; c=relaxed/simple;
	bh=fi5pC29LO2MTYzLsdcgBABcp9yab2yR9OaBiP6QzX5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fc1cZfUSCbTD+ez5+BB+KSb9oOqdVcCkMCYup8IjEWWlUjtd6o2TvPpokdKoeaKAFhr2IhM6XU4ajbMLRx59b8WjKDrmzd/SWyN1CaoUskvs0ZvkhZFlczo8WSnjm04jlh2Lmai7z0xX7UerjSE5NUVVC/9N+fBCwRLb6B4KMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K3Z6O0rn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715162911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNHp8YfOUWVmU5olVJkx6F71bvtRkNzxWX8Xu+Hbano=;
	b=K3Z6O0rnx6QKrg1n4p7Ar+gCBs4mlrpfa85EAq2ACcG9JfZBTCjTi0f+gEDbPd5fhPO7ux
	mzpcf4rhd6XgSuv5H1EAmQSF+GRUVMNkfoeVCh8I94KCvfzoHD3UMEUr33Yf1cxBgrUkFq
	Ruqehu7NmR4fJr68Uqr7KDa0C9DK0Oo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-Ic5CwhECNJGD8i-KiTRFng-1; Wed, 08 May 2024 06:08:29 -0400
X-MC-Unique: Ic5CwhECNJGD8i-KiTRFng-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34db1830d7cso290499f8f.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 03:08:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715162908; x=1715767708;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNHp8YfOUWVmU5olVJkx6F71bvtRkNzxWX8Xu+Hbano=;
        b=kH1MsIb7u8AM+f9IrbNxM0p+SxBJY/k15T5DpW+/ECQJ2F8oDK95AxjKmjlrEaj46N
         gl9l8wRpVReiclviu+uVP9L3gAmqtLxomwwQ5aSc+bDK94J8R1KEvXxUwgxpwSGiMEoL
         Yi/uVP9TNZNpl6EP2iiS+Uqf1T60uoi3+sU1aMYh5ZxKKinN5CNp9NK0gmfLFsan6Ncd
         u+5XKcyYDnPut28TxKnaU3bNc/8egXqCQzf5lJwr5JHVlgF55ZR/9BiyTTqVAtQEdJg+
         HQgEJ6XhIxRGLuG3eWv8b2QlBdCFS9FaxyZQZd8+nHwWjDrIJjwE80m5oXHONe/WgJn9
         ayBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVku95ZqDPozP6heQpWX8b59KHSrlDT0QPX6PA1grWvbAFnpIyUFF+NSEbr647DMURhiEADgW5Bx7Wkx3xeuCQSoIVk
X-Gm-Message-State: AOJu0YxENw6+Sop6rIonCShMaq4iubr0R20+gkDEvt24VoMjI6DaMbCz
	UAHgws7kUSqYwImTiIVw5RRTjUr01faRmsYggrFr65eUyfMxxrdsdjj5tvnASfNLiK1fynVR8aL
	PDMHvWdwCyiIHm3u4mY8/qUr0joRR8TGdghW93gR8k8kXtFqAbg==
X-Received: by 2002:a5d:4609:0:b0:34c:e6ca:b844 with SMTP id ffacd0b85a97d-34fca4326ebmr2122111f8f.10.1715162908503;
        Wed, 08 May 2024 03:08:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXUixP71qOqmXCHqtiRcSiizWmrb8/jKc+n3jGLXeQk7JyzOLQn2I+FaO4/fik1qwM/2xdcQ==
X-Received: by 2002:a5d:4609:0:b0:34c:e6ca:b844 with SMTP id ffacd0b85a97d-34fca4326ebmr2121859f8f.10.1715162904757;
        Wed, 08 May 2024 03:08:24 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-56.business.telecomitalia.it. [87.12.25.56])
        by smtp.gmail.com with ESMTPSA id t3-20020a05600001c300b0034df7313bf1sm15103289wrx.0.2024.05.08.03.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 03:08:24 -0700 (PDT)
Date: Wed, 8 May 2024 12:08:19 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: mst@redhat.com, xuanzhuo@linux.alibaba.com, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kuba@kernel.org, stefanha@redhat.com, 
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com, kvm@vger.kernel.org, 
	jasowang@redhat.com
Subject: Re: [PATCH net-next v2 3/3] test/vsock: add ioctl unsent bytes test
Message-ID: <ziml6kzajkzrtzhl5t7ygselpwqggukrrfdcewfteuvbnehud4@gbu6qomjpvc7>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
 <AS2P194MB217007992597CC2E1BF71D679A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AS2P194MB217007992597CC2E1BF71D679A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Mon, Apr 08, 2024 at 03:37:49PM GMT, Luigi Leonardi wrote:
>This test that after a packet is delivered the number
>of unsent bytes is zero.
>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> tools/testing/vsock/util.c       |  6 +--
> tools/testing/vsock/util.h       |  3 ++
> tools/testing/vsock/vsock_test.c | 85 ++++++++++++++++++++++++++++++++
> 3 files changed, 91 insertions(+), 3 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 554b290fefdc..a3d448a075e3 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -139,7 +139,7 @@ int vsock_bind_connect(unsigned int cid, unsigned int port, unsigned int bind_po
> }
>
> /* Connect to <cid, port> and return the file descriptor. */
>-static int vsock_connect(unsigned int cid, unsigned int port, int type)
>+int vsock_connect(unsigned int cid, unsigned int port, int type)
> {
> 	union {
> 		struct sockaddr sa;
>@@ -226,8 +226,8 @@ static int vsock_listen(unsigned int cid, unsigned int port, int type)
> /* Listen on <cid, port> and return the first incoming connection.  The remote
>  * address is stored to clientaddrp.  clientaddrp may be NULL.
>  */
>-static int vsock_accept(unsigned int cid, unsigned int port,
>-			struct sockaddr_vm *clientaddrp, int type)
>+int vsock_accept(unsigned int cid, unsigned int port,
>+		 struct sockaddr_vm *clientaddrp, int type)
> {
> 	union {
> 		struct sockaddr sa;
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e95e62485959..fff22d4a14c0 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -39,6 +39,9 @@ struct test_case {
> void init_signals(void);
> unsigned int parse_cid(const char *str);
> unsigned int parse_port(const char *str);
>+int vsock_connect(unsigned int cid, unsigned int port, int type);
>+int vsock_accept(unsigned int cid, unsigned int port,
>+		 struct sockaddr_vm *clientaddrp, int type);
> int vsock_stream_connect(unsigned int cid, unsigned int port);
> int vsock_bind_connect(unsigned int cid, unsigned int port,
> 		       unsigned int bind_port, int type);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index f851f8961247..c19ffbcca9dd 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -20,6 +20,8 @@
> #include <sys/mman.h>
> #include <poll.h>
> #include <signal.h>
>+#include <sys/ioctl.h>
>+#include <linux/sockios.h>
>
> #include "vsock_test_zerocopy.h"
> #include "timeout.h"
>@@ -1238,6 +1240,79 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
> 	}
> }
>
>+#define MSG_BUF_IOCTL_LEN 64
>+static void test_unsent_bytes_server(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int client_fd;
>+
>+	client_fd = vsock_accept(VMADDR_CID_ANY, 1234, NULL, type);
>+	if (client_fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	recv_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
>+	control_writeln("RECEIVED");
>+
>+	close(client_fd);
>+}
>+
>+static void test_unsent_bytes_client(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int ret, fd, sock_bytes_unsent;
>+
>+	fd = vsock_connect(opts->peer_cid, 1234, type);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (int i = 0; i < sizeof(buf); i++)
>+		buf[i] = rand() & 0xFF;
>+
>+	send_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
>+	control_expectln("RECEIVED");
>+
>+	ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
>+	if (ret < 0) {
>+		perror("ioctl");
>+
>+		if (errno != EOPNOTSUPP)

I'm not sure `errno` is preserved after calling perror().

I'd suggest something like this:

	if (ret < 0) {
		if (errno == EOPNOTSUPP) {
			fprintf(stderr, "Test skipped\n");
		} else {
			perror("ioctl");
			exit(EXIT_FAILURE);
		}
	} else if ...

Or if you prefer, we can avoid the “Test skipped” message and still fail 
as we do for other tests.

Users already have ways of skipping tests and maybe in this way they are 
sure of what they are doing whether or not they expect this test to pass 
or not.

The rest LGTM!
Stefano

>+			exit(EXIT_FAILURE);
>+
>+		fprintf(stderr, "Test skipped\n");
>+	} else if (ret == 0 && sock_bytes_unsent != 0) {
>+		fprintf(stderr,
>+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
>+			sock_bytes_unsent);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>+
>+static void test_stream_unsent_bytes_client(const struct test_opts *opts)
>+{
>+	test_unsent_bytes_client(opts, SOCK_STREAM);
>+}
>+
>+static void test_stream_unsent_bytes_server(const struct test_opts *opts)
>+{
>+	test_unsent_bytes_server(opts, SOCK_STREAM);
>+}
>+
>+static void test_seqpacket_unsent_bytes_client(const struct test_opts *opts)
>+{
>+	test_unsent_bytes_client(opts, SOCK_SEQPACKET);
>+}
>+
>+static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
>+{
>+	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
>+}
>+
> #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
> /* This define is the same as in 'include/linux/virtio_vsock.h':
>  * it is used to decide when to send credit update message during
>@@ -1523,6 +1598,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_rcvlowat_def_cred_upd_client,
> 		.run_server = test_stream_cred_upd_on_low_rx_bytes,
> 	},
>+	{
>+		.name = "SOCK_STREAM ioctl(SIOCOUTQ) 0 unsent bytes",
>+		.run_client = test_stream_unsent_bytes_client,
>+		.run_server = test_stream_unsent_bytes_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET ioctl(SIOCOUTQ) 0 unsent bytes",
>+		.run_client = test_seqpacket_unsent_bytes_client,
>+		.run_server = test_seqpacket_unsent_bytes_server,
>+	},
> 	{},
> };
>
>-- 
>2.34.1
>


