Return-Path: <kvm+bounces-47281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA96ABF8AF
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBE457B5098
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF67B20CCE5;
	Wed, 21 May 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7yYBdER"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307041E04AC
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839706; cv=none; b=lbWW+RjGzny/vIT2kNI9fxu+Gi9F/EyjF0cglkGvBZSypWRF07BLJEipLESnFZfX/oCebXQGD8LJ9rRiw66eJLcr2j/oZt7qtuo8ER9uCIFedrsDigb+b/3FnIgrastJfugpEi2WA9ZP1cJ3SF3BnXw1nBQmv6cdfVlCtINbcxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839706; c=relaxed/simple;
	bh=xehhInAtDXNQ/n5gfDz6llbpaPNmLMER2GgFqEhTcvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IOG0MHOmeQhzZdkWSwLVVgDiMCqBQTViYxhVkqGxOekUG/1cvyo0XqapGOL/I5QhMBs9QOQD+iYbfnohpJdIxhzyaRVDokgSYnnejDcnlR/vbm5FoJz/jgXq1bGm0kvscPvQlX5VBRlMZiF5jv4Bh+AOchFx3PjEa5z07Jlo6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U7yYBdER; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747839703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IQaN0Uw5ksNxoFenF66ughGD5YHdupsTVLr1isPbs2c=;
	b=U7yYBdERsCRL1nYh6RWCHrWHFe3seSzxqiwWJujCJC+j7uiBPwXBR+Ay9img+4x/BmbTjS
	xtW2/pMPEgSU7bqvvAsiiFvQYFx8TYJKCmh3B5S6sNflw+miyQo1sqa+dz3H7ZL3xkIUn5
	Tj1WB9P81/1z/XP3180oUks6ZEMCeEc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-_hbkbRE3Nd-Hwqyj2asnlw-1; Wed, 21 May 2025 11:01:42 -0400
X-MC-Unique: _hbkbRE3Nd-Hwqyj2asnlw-1
X-Mimecast-MFC-AGG-ID: _hbkbRE3Nd-Hwqyj2asnlw_1747839701
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-601a8371d0cso4396014a12.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839701; x=1748444501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQaN0Uw5ksNxoFenF66ughGD5YHdupsTVLr1isPbs2c=;
        b=uKOuiZbOVNNLAVG40Sgyp3HPGI8+X1P6tJIj+Hr1oruiep/bHuqbUep3EkcuvwMVzC
         Z4O+ZHHwLg6kDC6tL9zbEB1sRLIqoO46l0J8c4o73q8hbrRuq00beeyCHmF1iow4okdP
         1TVvJ6QSWfdeB+j68fS2i5eXnItQCvcEdJx1Mjf1cDccclCF+/VGaCVmwqPqpyWd8R+I
         IZ5XM9Q7t2Bm2z46XB/wkWn7R/CXwBEzWK2T/IOE8hBzrGuJ7bOkgrpiAWloh9dzsBqO
         50PK0EH9l0H29kLdVvQyKiVZBZvS62kaMWr87OXHDdD6BlGu8KK4vldTJHkCsIFkdy5s
         E+zw==
X-Forwarded-Encrypted: i=1; AJvYcCUrFigNFtcpvflKfRyy/NxY0zmxEBzthZcszKCCL6KL0ycATPcN4mbkOZBBkwN59gOrvRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzORVQ6RyOFtlj87HL0gUDnYYWhk2RA3MlN4hJZy8nNYsQmrXOa
	1dMDBxWwmAitkYvfj1w8jNpgBm/EpiZHkCxShBqrzyX2TZTJACTkmcyUlbekZBqOqqb1ujc3wj9
	DZiPpVcq7g1CL/7vl5KIc2KGBamKrgYdNog1zyfe8EDQR9GFZCrNvNA==
X-Gm-Gg: ASbGncseGIvBEsSozrTcguAmgV7kolRPPoOBg/lp54b8d7AkGkhUDI1sd6vTWl6i2et
	DAqWu9jDlYmyjQK4r+YkqRsCN9vD0gGQXQbvq3gcRc8LA6sy4SLiejVg3vuskMzzdzqF45NXoUM
	jwBIUGMvaDVUsm1XKt9XSUS1vT4UwjvkvapgS5MsaFo/UvUHCR9BTWNfRUTfL24c+MRaPSGd2nu
	08aXTbOur9N1GEBER7P+zk4LDKuOiBfNyvwlbwx/zmjDAd5Q1JHb35F6Mby4OW5UHs7WpRMftcU
	0dHoa6bkxOU+g2XhHDAaIpTzVLEcCwXZq7ctHJcDca0vuasamYmrez4tPorl
X-Received: by 2002:a17:907:7da2:b0:ad4:d9c9:c758 with SMTP id a640c23a62f3a-ad536b7c8dfmr1808154566b.11.1747839694908;
        Wed, 21 May 2025 08:01:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlYrXcyUQ/GFhKIGPeqwLg3L9B+4cCMXz+eKCUeTZ4xCrnP7r7wqBOBXYGqGyAGakMiIi6NQ==
X-Received: by 2002:a17:907:7da2:b0:ad4:d9c9:c758 with SMTP id a640c23a62f3a-ad536b7c8dfmr1808102866b.11.1747839690863;
        Wed, 21 May 2025 08:01:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4ca5c5sm909001966b.162.2025.05.21.08.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 08:01:30 -0700 (PDT)
Date: Wed, 21 May 2025 17:01:25 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 3/5] vsock/test: Introduce vsock_wait_sent()
 helper
Message-ID: <kva35i6sjyxuugywlanlnkbdunbyauadgnciteakxu2jsb2kl7@24fgdq2glxk6>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-3-94827860d1d6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521-vsock-linger-v5-3-94827860d1d6@rbox.co>

On Wed, May 21, 2025 at 12:55:21AM +0200, Michal Luczaj wrote:
>Distill the virtio_vsock_sock::bytes_unsent checking loop (ioctl SIOCOUTQ)
>and move it to utils. Tweak the comment.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/util.c       | 25 +++++++++++++++++++++++++
> tools/testing/vsock/util.h       |  1 +
> tools/testing/vsock/vsock_test.c | 23 ++++++-----------------
> 3 files changed, 32 insertions(+), 17 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index de25892f865f07672da0886be8bd1a429ade8b05..120277be14ab2f58e0350adcdd56fc18861399c9 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -17,6 +17,7 @@
> #include <assert.h>
> #include <sys/epoll.h>
> #include <sys/mman.h>
>+#include <linux/sockios.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -96,6 +97,30 @@ void vsock_wait_remote_close(int fd)
> 	close(epollfd);
> }
>
>+/* Wait until transport reports no data left to be sent.
>+ * Return non-zero if transport does not implement the unsent_bytes() callback.
>+ */
>+int vsock_wait_sent(int fd)

nit: I just see we use `bool` in the test to store the result of this 
function, so maybe we can return `bool` directl from here...

(not a strong opinion, it's fine also this).

Thanks,
Stefano

>+{
>+	int ret, sock_bytes_unsent;
>+
>+	timeout_begin(TIMEOUT);
>+	do {
>+		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
>+		if (ret < 0) {
>+			if (errno == EOPNOTSUPP)
>+				break;
>+
>+			perror("ioctl(SIOCOUTQ)");
>+			exit(EXIT_FAILURE);
>+		}
>+		timeout_check("SIOCOUTQ");
>+	} while (sock_bytes_unsent != 0);
>+	timeout_end();
>+
>+	return ret;
>+}
>+
> /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> int vsock_bind(unsigned int cid, unsigned int port, int type)
> {
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index d1f765ce3eeeed8f738630846bb47c4f3f6f946f..e307f0d4f6940e984b84a95fd0d57598e7c4e35f 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
>+int vsock_wait_sent(int fd);
> void send_buf(int fd, const void *buf, size_t len, int flags,
> 	      ssize_t expected_ret);
> void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 9ea33b78b9fcb532f4f9616b38b4d2b627b04d31..4c2c94151070d54d1ed6e6af5a6de0b262a0206e 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -21,7 +21,6 @@
> #include <poll.h>
> #include <signal.h>
> #include <sys/ioctl.h>
>-#include <linux/sockios.h>
> #include <linux/time64.h>
>
> #include "vsock_test_zerocopy.h"
>@@ -1280,7 +1279,7 @@ static void test_unsent_bytes_server(const struct test_opts *opts, int type)
> static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> {
> 	unsigned char buf[MSG_BUF_IOCTL_LEN];
>-	int ret, fd, sock_bytes_unsent;
>+	int fd;
>
> 	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
> 	if (fd < 0) {
>@@ -1297,22 +1296,12 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> 	/* SIOCOUTQ isn't guaranteed to instantly track sent data. Even though
> 	 * the "RECEIVED" message means that the other side has received the
> 	 * data, there can be a delay in our kernel before updating the "unsent
>-	 * bytes" counter. Repeat SIOCOUTQ until it returns 0.
>+	 * bytes" counter. vsock_wait_sent() will repeat SIOCOUTQ until it
>+	 * returns 0.
> 	 */
>-	timeout_begin(TIMEOUT);
>-	do {
>-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
>-		if (ret < 0) {
>-			if (errno == EOPNOTSUPP) {
>-				fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>-				break;
>-			}
>-			perror("ioctl");
>-			exit(EXIT_FAILURE);
>-		}
>-		timeout_check("SIOCOUTQ");
>-	} while (sock_bytes_unsent != 0);
>-	timeout_end();
>+	if (vsock_wait_sent(fd))
>+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>+
> 	close(fd);
> }
>
>
>-- 
>2.49.0
>


