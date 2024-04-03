Return-Path: <kvm+bounces-13451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4711896A5E
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 11:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 305221F24F72
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 09:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22D373164;
	Wed,  3 Apr 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2L5gkRQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5757670CA7
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712136025; cv=none; b=c7QG7umjf2ZqVX536RU6E/RzxizVi4VblaK8NKiLTB+Z7f5BNtWiCwOOtKxj/92GNnrv/TUoSg/2tjcxhEanbYPoMIbmr6YppZWb51E3BcNsetbtppWSWZG7Z2kOeK36oVMGqNVIzjfYM0det7L26q2FNXL2GB+bZiE3OTHSUiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712136025; c=relaxed/simple;
	bh=aVcBN45Xfck08qQ/abgvdWiQt9e3NFHvI+SBznc9rf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elWT4qzw9XZTiWPvOoDa/AKcSmMoJDEiSYrePoKPsiID8NJ5dyATVqEPAFK2d47kQRURUUvccDfsieY29BtFqCHf0Uyqso70fPifM4u2qk4synNLaTUTHL23HpMF151NEdNRROYy1a7xA3WX0DPE8aCTmeBU8ULUN0eViHx0HM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F2L5gkRQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712136022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7eVpcKNoPKOT5GjI4amQQ4jUKbgRtaP6DtVP6eeUayE=;
	b=F2L5gkRQI1Sfx4PojyKXhEcQJe2VSDcKtVNVSTZrE89hmJCM/3Zxszfq9P/Re9hIkHaee+
	g4cy/4aGsUUdaKfCfDiuHQmIIhrocWcfZYOVzSVJzIqS3Bt7b8sAQez6vg6fjHgepB5uUp
	JeK+8sExopzibQpmwR2riIrNgpWVgBo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-ODLJ6UbIN8a5wvTZHStuug-1; Wed, 03 Apr 2024 05:20:20 -0400
X-MC-Unique: ODLJ6UbIN8a5wvTZHStuug-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4155db7b58cso16968155e9.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 02:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712136019; x=1712740819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eVpcKNoPKOT5GjI4amQQ4jUKbgRtaP6DtVP6eeUayE=;
        b=mHMooL4ed86rc38WKSZQXwQupA44sYnC8sLZihGoZHLtG7r+WU02WoBbzGKNEz8hzw
         /UIyt9mL0BFOOKhV4lf9xgFeueNkemKtxZ1Gy1IB1xZaGskGTzjn/FC5QZTlzKZ0lEkP
         v7dW8koLRKnHmzzw56/oYz9NXbVBVKzX9Zj/WLXljo9TfaI+iq0eMEe5d38lUm04SJG/
         u+wkmZ/n4JWN+JLxUZgkGM/Xufn7TNaixBz9fonSLXVkVQuKu/g/NCrQZyatH8C82UZt
         Vx8cy0v47dQQnR229cksSycB8FqCNi68m2UIdxNWkvIEG9kkowhJJ68ULOry69a0IOtB
         JJ9g==
X-Gm-Message-State: AOJu0YxVjwHGAcoHq8yvKQu6alslIe5kL47Rq2oVrHiQT4mzMpDMIArq
	vOUBhL8jm4bD4DEwXFuCmnAOszUueTy6efOftBlhaly8dRH4QhxO+kZ+CZtABgPZ/UPgN8W5YE6
	qFADbjGSUJnQBRI4WK91+05xD9caQt0QnVDSo4DSguirXs1rIPA==
X-Received: by 2002:a05:600c:190f:b0:414:93ae:396d with SMTP id j15-20020a05600c190f00b0041493ae396dmr13447743wmq.32.1712136019734;
        Wed, 03 Apr 2024 02:20:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpPRLEixd0sNanUNIse0jfTMcCXcGZLbYnktjnv+/KAjawSRllq9bpUKMcQ9mEZUSuNo/uGA==
X-Received: by 2002:a05:600c:190f:b0:414:93ae:396d with SMTP id j15-20020a05600c190f00b0041493ae396dmr13447724wmq.32.1712136019364;
        Wed, 03 Apr 2024 02:20:19 -0700 (PDT)
Received: from sgarzare-redhat ([185.95.145.60])
        by smtp.gmail.com with ESMTPSA id fa14-20020a05600c518e00b004159df274d5sm5729524wmb.6.2024.04.03.02.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 02:20:18 -0700 (PDT)
Date: Wed, 3 Apr 2024 11:20:13 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: kvm@vger.kernel.org, jasowang@redhat.com, 
	virtualization@lists.linux.dev, mst@redhat.com, kuba@kernel.org, xuanzhuo@linux.alibaba.com, 
	netdev@vger.kernel.org, stefanha@redhat.com, pabeni@redhat.com, davem@davemloft.net, 
	edumazet@google.com
Subject: Re: [PATCH net-next 3/3] test/vsock: add ioctl unsent bytes test
Message-ID: <etx5zujgdrhnjz2dmavz6it5smkzhwvkzm3go6sesz2ya4aj5s@du3wfitew4il>
References: <20240402150539.390269-1-luigi.leonardi@outlook.com>
 <AS2P194MB2170D78CDB7BDF00F0ACCB079A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB2170D78CDB7BDF00F0ACCB079A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Tue, Apr 02, 2024 at 05:05:39PM +0200, Luigi Leonardi wrote:
>This test that after a packet is delivered the number
>of unsent bytes is zero.
>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>---
> tools/testing/vsock/util.c       |  6 +--
> tools/testing/vsock/util.h       |  3 ++
> tools/testing/vsock/vsock_test.c | 83 ++++++++++++++++++++++++++++++++
> 3 files changed, 89 insertions(+), 3 deletions(-)
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
>index f851f8961247..58c94e04e3af 100644
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
>@@ -1238,6 +1240,77 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
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
>+	if (ret < 0 && errno != EOPNOTSUPP) {

What about adding a warning when it is not supported?

Something like this (untested):

	if (ret < 0) {
		perror("ioctl");

		if (errno != EOPNOTSUPP) {
     			exit(EXIT_FAILURE);
		}

		fprintf(stderr, "Test skipped\n");
	}

The rest LGTM.

Thanks,
Stefano

>+		perror("ioctl");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (ret == 0 && sock_bytes_unsent != 0) {
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
>@@ -1523,6 +1596,16 @@ static struct test_case test_cases[] = {
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
>


