Return-Path: <kvm+bounces-47272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CA6ABF805
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DCC44E74DA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9B61DE8B6;
	Wed, 21 May 2025 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cEd/FJqj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C501D7999
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838506; cv=none; b=QU2GPiVgWVXSkue5Fwd5rEKr9DBbl+3dXsxqTStLlOFibGt5VpndNuEWcZJQEf2TW/RwrwuXPIRAcSCsONseAv65eP/UjvzTJwODFEyG0bHhxs9kP9B6RsL4bw4CGSi97DIeaUROI1v8RCfjfF8DPT/4f6RtjfX6rjKzJEXZ97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838506; c=relaxed/simple;
	bh=fJrz4e1Ti/Jt27bWzNcWF73I0K+Q9z0Ka+LDgDGAiMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXfMgCSmMjlJJ74Byv096rvP1A5talhsX5N7o4G8Lab5lrNzx8VUiVApP1RmLsj3dj+b033J2r2I0UFDuhg8RAVHtjn8RfC+XK79wwQlKCX8DBSxcnndFtWrZx7bUl80G3t6A08MLP3SiF9saPLCC0u8hqMkEjuPa4Elw75ERJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cEd/FJqj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747838503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mDesXKTayHxGjIGY1j8G0o6g9UGYHXMrYuHHOq5gQRI=;
	b=cEd/FJqjuEwN+FiBB+vAgcFNTKcrRa7ndIC45HqR0iO+wN0X2OJcC2U4HgAdIOsTSBgTF1
	jWIsZytTPHvrJJ0Q+v8b1MmoDwndSkAmWY07tJJpssOfKltofYXEwvAJ6/1lN65X2a/rom
	TnypONEuRrap9YkOyNGHDc4exmq1jdA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-cqkbuVQBPYqDXxjcV1Cn8g-1; Wed, 21 May 2025 10:41:41 -0400
X-MC-Unique: cqkbuVQBPYqDXxjcV1Cn8g-1
X-Mimecast-MFC-AGG-ID: cqkbuVQBPYqDXxjcV1Cn8g_1747838501
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-acf0113e311so605233166b.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747838500; x=1748443300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDesXKTayHxGjIGY1j8G0o6g9UGYHXMrYuHHOq5gQRI=;
        b=Ue3Hj8ovdVjJT3tuN/7uadWK9FWfKbOPRpQNkz/nu4iKdmvyiGqbTTn1U69iL9L9Hg
         Eu9RxY/xYT+HcMfRtddm0Y2o++i/BrVtO01Go8/hJDxq6DPM4Diyz+MqK9ZMTVal8yQL
         YoZErkaoQwgiPP0iXPJAGaPhadw+/Ile6hNanQp7KNBsREuT6ecF2gdRXSpclXfORlxc
         fl6CA0HmBszB0iLy4eul7CXSA7jb0haYuQcK0eHC1A0QrAh4rqmNFGnjkqcTxDwGqpwV
         VlsYEqZSjiPr0Vq4RawnmheYryRk/NGlwO2mKgHwjiCtzEmju/sB2a+lR/6J9Acs0pOA
         8gWw==
X-Forwarded-Encrypted: i=1; AJvYcCXiuTQCDBmYOBX8YH1w0+jCFbjd+pIyLbZJRLKwccBsOOaTSGM6RI5Mrt6cPW7GEOLrOAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrfyo215dS+OvBDI23qRNqDZ9azHTd9RA1kJ64YPUB0Zaanulx
	DkYd+3D8iUX8YVqtXI7ClqrcOVonCAn+PYjSH0LTiXp2XZ0Fsg93zkRpL/0v9LCAHse8PspBZlR
	8gqdgSn+tgoi8iY279ljz0GeGIXQErrL+kLm8rLgyxWqU1fRKlezdRQ==
X-Gm-Gg: ASbGncu4ea82KhVXToH2vXif9FOSqtb6b2dvLG6L9MF2l/Tc97gR9G7b3K7kKAvXwLn
	d36TxfBLPn6NXr25EKw1IPGsHHYwCfnlyYofX01zHnkggq8+gT/qMjWiv0k+mLIGQK9ol9JkkPg
	Dh4enyQ8mXdCDuUhZKl6ElSkxHwfratOb3rp2b62syUn/SlEJwrFItRlc5NAu6yNG8TBoXEW0k6
	VfgJKaaIjnmpc+C5TNvB+vXVwGbyF5pjqciajPkDewO0WDEn7oKwH9Pq7TLc32gY4swhxQA8dp/
	ftmLH7jL5YlO7hnRHXCLFk4xmqlRhK93Ar0y9NewDL0lKvW6Ide4jLi2MP2z
X-Received: by 2002:a17:907:e916:b0:ace:c59c:1b00 with SMTP id a640c23a62f3a-ad52d42dc34mr1768466466b.5.1747838500576;
        Wed, 21 May 2025 07:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE66RxXKL2W6d/q5voawNHWMt+eYxa0BkwW3PNFANgomMqz2eIeLzBYh2MlVa3aFRZzUSRf1g==
X-Received: by 2002:a17:907:e916:b0:ace:c59c:1b00 with SMTP id a640c23a62f3a-ad52d42dc34mr1768463566b.5.1747838499992;
        Wed, 21 May 2025 07:41:39 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d06dfa4sm914996266b.57.2025.05.21.07.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:41:39 -0700 (PDT)
Date: Wed, 21 May 2025 16:41:34 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 4/5] vsock/test: Introduce enable_so_linger()
 helper
Message-ID: <3uci6mlihjdst7iksimvsabnjggwpgskbhxz2262pmwdnrq3lx@v2dz7lsvpxew>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-4-94827860d1d6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521-vsock-linger-v5-4-94827860d1d6@rbox.co>

On Wed, May 21, 2025 at 12:55:22AM +0200, Michal Luczaj wrote:
>Add a helper function that sets SO_LINGER. Adapt the caller.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/util.c       | 13 +++++++++++++
> tools/testing/vsock/util.h       |  4 ++++
> tools/testing/vsock/vsock_test.c | 10 +---------
> 3 files changed, 18 insertions(+), 9 deletions(-)
>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 120277be14ab2f58e0350adcdd56fc18861399c9..41b47f7deadcda68fddc2b22a6d9bb7847cc0a14 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -823,3 +823,16 @@ void enable_so_zerocopy_check(int fd)
> 	setsockopt_int_check(fd, SOL_SOCKET, SO_ZEROCOPY, 1,
> 			     "setsockopt SO_ZEROCOPY");
> }
>+
>+void enable_so_linger(int fd)
>+{
>+	struct linger optval = {
>+		.l_onoff = 1,
>+		.l_linger = LINGER_TIMEOUT
>+	};
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
>+		perror("setsockopt(SO_LINGER)");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e307f0d4f6940e984b84a95fd0d57598e7c4e35f..1b3d8eb2c4b3c41c9007584177455c4fa442334c 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -14,6 +14,9 @@ enum test_mode {
>
> #define DEFAULT_PEER_PORT	1234
>
>+/* Half of the default to not risk timing out the control channel */
>+#define LINGER_TIMEOUT		(TIMEOUT / 2)
>+
> /* Test runner options */
> struct test_opts {
> 	enum test_mode mode;
>@@ -80,4 +83,5 @@ void setsockopt_int_check(int fd, int level, int optname, int val,
> void setsockopt_timeval_check(int fd, int level, int optname,
> 			      struct timeval val, char const *errmsg);
> void enable_so_zerocopy_check(int fd);
>+void enable_so_linger(int fd);
> #endif /* UTIL_H */
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 4c2c94151070d54d1ed6e6af5a6de0b262a0206e..f401c6a79495bc7fda97012e5bfeabec7dbfb60a 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1813,10 +1813,6 @@ static void test_stream_connect_retry_server(const struct test_opts *opts)
>
> static void test_stream_linger_client(const struct test_opts *opts)
> {
>-	struct linger optval = {
>-		.l_onoff = 1,
>-		.l_linger = 1

So, we are changing the timeout from 1 to 5, right?
Should we mention in the commit description?

>-	};
> 	int fd;
>
> 	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>@@ -1825,11 +1821,7 @@ static void test_stream_linger_client(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>-	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
>-		perror("setsockopt(SO_LINGER)");
>-		exit(EXIT_FAILURE);
>-	}
>-
>+	enable_so_linger(fd);

If you need to resend, I'd pass the timeout as parameter, so the test
can use whatever they want.

The rest LGTM.

Thanks,
Stefano

> 	close(fd);
> }
>
>
>-- 
>2.49.0
>


