Return-Path: <kvm+bounces-49718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 702DDADD113
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AF26188CD31
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FC22E92D2;
	Tue, 17 Jun 2025 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ch7lVb55"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DEE2E7F20
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750173070; cv=none; b=goSjkgSaqAPFavct0h8udbNkQ6Eioy1QQQPqQAIYaj3eMdP5WRWkVxo9CC0/iiZ6auOXbXFEP9o4DnsaR7idDl7FSNn88KvWhErIzx4PHwaUccEUA+R2pNXn+el7sF+Hfu7zbGHlO5c7ckF8M+oMaAY4iq+uEKda5soIQ/JmKAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750173070; c=relaxed/simple;
	bh=pdPq9PlVlHWZ2cVzJk1emG6nTw+vRlKhWuL8ddlKXW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moZ6emcfhavpS39/zpkobuw56otHg4YEQK9UZWhkWxmRQU6k04Ke1egjAvUnDpIz9jtPltYUnQ91UF0yJ5/DLpF6ZzFb9ZUba5x3jNJFKPuNZMYR+bpubFeD6vsaYqCILzE8KIliy0Df7EhhdmNiu1vT6SD1M48hT7SF6RekUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ch7lVb55; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750173067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WGX6svIlWpZEQ5EFYjPNzt7elF0IRahwc1dWlkYR+Go=;
	b=ch7lVb55ygvkafVcr0sV4mtXe13cyh1+QBcqnOpzHgGAdx7pznKq1RSEoVCx26VzFzG8Sf
	yBd+8iA83NLY76SM+JTCMh7SyZ7lS65fOXg6tI6DnXML2qAWLRExVVuk0tv7b1SkM2SwXG
	fJFCYtxZDkFopIUIVaVe6FqK02559gQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-DgLPQ6GMPaOA728mvxTLrA-1; Tue, 17 Jun 2025 11:11:06 -0400
X-MC-Unique: DgLPQ6GMPaOA728mvxTLrA-1
X-Mimecast-MFC-AGG-ID: DgLPQ6GMPaOA728mvxTLrA_1750173065
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-452ff9e054eso30724835e9.2
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 08:11:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750173065; x=1750777865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGX6svIlWpZEQ5EFYjPNzt7elF0IRahwc1dWlkYR+Go=;
        b=i0mX52weKls6HBFwLiaOnV0bSyuk0ktaDFrFJsEx82cZLm91TLVCB8pdpfeQl78NcU
         FBPL6EXcwrDuzRo/YueSF/lmuifhB5JVRuGI854bXk6FeS7WNcURkjzmERtwh9IwcyVm
         QjbljVQACWFo3hvqznNOs4Bg2tKq9ipiNkuNqK8HZlieG8o7YfoPb/ShNsQC7ZXp2d71
         43mtbNprIfNwbrmr1F8rX4KJwPR8X7GTOzik9jbiEcuzXcpr/QKUFPVMRMB8A5ru/qh3
         /wHhNmqToJDBmuxybHo9AgC5yf2VC81iud0u9fGLjGsqtZYMuhlgWdpDPwz3c/BUxRWG
         O2Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWGAmy1/r2LBnh7c3LPBPbOafqltR4nBwyDINoz/vRzK7TdISP4Yw6uF1gjTWJFNLgGqpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOnjym+zvvkOiil3ff18rYlUYwESkxUF48t6ho3BxMYdXWzHUV
	BiK2zKtxK6Fqwz/mE6hT6seQ8sSJzck+lDKnQ5N29fA39A3gMoRukU7+9VIa8GignXIxr8mORI+
	AnQg/8yaRsOjZlppX4T66MEpGzcCzXpU2UDBBPKA5dG0Fne8oxMEFAg==
X-Gm-Gg: ASbGncvXGThAVyOP5LSz73W/9uoHVe/lz58GJQDHSS8PH2oZHOihdbmQAPj0338Azy5
	xphwfV3CDAra/EHdCi9agr0MZPMmJmshu646CGedUezgE5+GYjrqEmCgMHHJq6KkxIo0UWRFr6c
	98vd9w0ex4uxsixC1cXM4CBJhEkVt3XI6/gtJaEeLd+Qvm73gVarnrG3F6KZNqCNWjeqN+IHzlf
	dEbV9XC8hpROfCBDglNR4F7+w8HG6XKlyLWqojs64AQk9wDVkVovtDD/H1K0cDLvm3ARlXzgjpl
	p50V8NZSnriTOiOGedwTYWnjcqc+
X-Received: by 2002:a05:600c:4f54:b0:43b:c0fa:f9dd with SMTP id 5b1f17b1804b1-4533cab1c91mr100034855e9.25.1750173064651;
        Tue, 17 Jun 2025 08:11:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLw5YcffSL+V+Aaktp6ydgR00R6Aiz6j5f4o7u0CbWcG6l7Jh0rci6v44UVdISCb4YtYblWQ==
X-Received: by 2002:a05:600c:4f54:b0:43b:c0fa:f9dd with SMTP id 5b1f17b1804b1-4533cab1c91mr100034365e9.25.1750173064079;
        Tue, 17 Jun 2025 08:11:04 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.200.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e13c192sm179620505e9.26.2025.06.17.08.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 08:11:03 -0700 (PDT)
Date: Tue, 17 Jun 2025 17:10:59 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, pabeni@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org, stefanha@redhat.com, 
	leonardi@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, fupan.lfp@antgroup.com, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH net-next v3 2/3] test/vsock: Add retry mechanism to ioctl
 wrapper
Message-ID: <uqpldq5hhpmmgayozfh62wiloggk7rsih6n5lzby75cgxvhbiq@fspi6ik7lbp6>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
 <20250617045347.1233128-3-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250617045347.1233128-3-niuxuewei.nxw@antgroup.com>

On Tue, Jun 17, 2025 at 12:53:45PM +0800, Xuewei Niu wrote:
>Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
>int value and an expected int value. The function will not return until
>either the ioctl returns the expected value or a timeout occurs, thus
>avoiding immediate failure.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> tools/testing/vsock/util.c | 37 ++++++++++++++++++++++++++++---------
> tools/testing/vsock/util.h |  1 +
> 2 files changed, 29 insertions(+), 9 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 0c7e9cbcbc85..ecfbe52efca2 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -16,6 +16,7 @@
> #include <unistd.h>
> #include <assert.h>
> #include <sys/epoll.h>
>+#include <sys/ioctl.h>
> #include <sys/mman.h>
> #include <linux/sockios.h>
>
>@@ -97,28 +98,46 @@ void vsock_wait_remote_close(int fd)
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

I think we can skip this kind of validation in a test, it will crash 
anyway and we don't have in other places.

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
>
> /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index 5e2db67072d5..f3fe725cdeab 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
>+int ioctl_int(int fd, unsigned long op, int *actual, int expected);

what about using vsock_* prefix?
nit: if not, please move after the vsock_* functions.

The rest LGTM!

Thanks,
Stefano

> bool vsock_wait_sent(int fd);
> void send_buf(int fd, const void *buf, size_t len, int flags,
> 	      ssize_t expected_ret);
>-- 
>2.34.1
>


