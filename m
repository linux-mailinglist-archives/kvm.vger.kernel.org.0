Return-Path: <kvm+bounces-47352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9E8AC0687
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A9693B01F5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 08:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25F2262FF3;
	Thu, 22 May 2025 08:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAlIk8wt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A5261595
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901157; cv=none; b=CqxNhpFdjsqlpHzGhPzZPJc//+CLFvtqQtYY77df9zOAbAvfGR3eODrn+VqJmW9cpX7hs2rm74+IKNkGPAMtZUJ4hkNEYfq3s6CjT3TxhoI701sRirfCbwz6jl/ZrJlDsg+zqLRoCESk7BE3qbuQbJXK4TwO4vmMht9QNM0u7A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901157; c=relaxed/simple;
	bh=kWJ+8wnhh914ZGBXjyQG8OCRHhwawgFGLPLGp5cMp2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXQegT1f9iTuQYDi+m9WWW2ChSxZ/I5no4uv+t2/KgpCQjVr+o56nuAjlIsfe8IifcMVlBu1yjVwHy2zn4gbpW471cDMK5EuFxFc75txqts7+v3kVtF0D5ULqORshxLxQd5wi57I9zx0cs4ztAtWGereB0J0OsoIEKvzVIHvpcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAlIk8wt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747901151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4n1+uXd36V+722CeTIUBaJYf703izxjGMMRXpA7T1DQ=;
	b=iAlIk8wtwko4seA3ZYv6kd5elEpY3iGQgnfY8IMHzVis+wVLY/rDuYfzUTtSObRUb3fA0e
	BYELeizErB2958zM5+YBU1zB6g5MtS+QFzIOPmzBLStv8A1pNaVBUlIh/xxZVH/e2toQmJ
	eAISq5Z/MmcaZMGagjxYcrlwRDp8iJ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-Wd8STKeJMqKDmXaigmpvnA-1; Thu, 22 May 2025 04:05:49 -0400
X-MC-Unique: Wd8STKeJMqKDmXaigmpvnA-1
X-Mimecast-MFC-AGG-ID: Wd8STKeJMqKDmXaigmpvnA_1747901148
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf172ffe1so56996495e9.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 01:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901148; x=1748505948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4n1+uXd36V+722CeTIUBaJYf703izxjGMMRXpA7T1DQ=;
        b=QZl7+N9GSUHD7n68/g5fxNGo4BalZWowHoVoZOaXxOdkIGhLT4iUoeNSONOWQlvgFu
         TiE+0qyFRrrLjACQaH7EHcXcxDSigXR9MFF+ZWBz2gvFb1UIGRUxNeKT/JcJKXR1xgnP
         jqcqvYpywDLXKTH6HORzIXiF6riWWcbCRjovzmxWUzmUrPvkhwuqGbORs9XfBMHvE9Tk
         qV4U8bEK5QKyzctX/MVFEzm3TsTu49nV5khC0rLw0r86iSvb5jb/27ay33caabWt/5To
         Usu6XYeQRbOsE+Ap/NJcNLjNaBevke3BtzT7SIEeJ9TvBtevdDB63ZYEzRiZiPvNfSHx
         Bdng==
X-Forwarded-Encrypted: i=1; AJvYcCUdyERGFRMC64tuVPMpjjOyNBoR4oj8YI3GJ/QTYmAf0BJIi3bCEV2rPomNfX5fCM5jqJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr0NpVrTEd6tsFNnqLbkxYIgL7rtR7CVHvDXRyOa7HoI1t4kwt
	DQRwbMti+vPUW5UblMjx+XM/drwUOQripRcxvPH4GHPEPec/CJuNPspL0hi4KI+qRlxW/k2sOXF
	RtTdVw4TSdlO9wCEANsE3mcoLShWztZbNhG4eaEVXQiGxh7WgKiK1Og==
X-Gm-Gg: ASbGncv9pHRdPQ7+lIgQu3FaDhZo2Unxr2HvJiqOeV5RI1xe/w4QpXSv446DThHlYf/
	wU44hpGbUJezBqdzQseUD8O6Fik/AYouXaJm3hLmgJ5CliWfBfG+IspfzJOwlGVnZ8jtML9+ppM
	0CcwiIf1XAi1ta+bZe/GfAhf+dsWkPRpazi7qiBiFc+hJOmQwHe+WkS+2uPsNjuqM0l7f6aLPho
	2MGbsCw/wURLeXsxaCUh09y4fB42/dAr7Ypp9ncl0zjym7D9gl9Nl4vWThXdWk/9tA9LJFcDVJY
	Rm0Jdw35QBMICBFelaPkoEoBRN0zjrrmjsZ7c2sk1cWNB34OWiNd+HtAVNnM
X-Received: by 2002:a05:600c:3ba1:b0:43d:762:e0c4 with SMTP id 5b1f17b1804b1-442ff03bbaemr215407425e9.27.1747901147909;
        Thu, 22 May 2025 01:05:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGO6p/hrwmEdoltdyMAYZsM/Trt1xdM7A/O/RHR4xK1dSQJHwCglht4DgE/PYNhLm3+cM8zWw==
X-Received: by 2002:a05:600c:3ba1:b0:43d:762:e0c4 with SMTP id 5b1f17b1804b1-442ff03bbaemr215401755e9.27.1747901140327;
        Thu, 22 May 2025 01:05:40 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f381465fsm95350675e9.29.2025.05.22.01.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:05:39 -0700 (PDT)
Date: Thu, 22 May 2025 10:05:37 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v6 5/5] vsock/test: Add test for an unexpectedly
 lingering close()
Message-ID: <4huzbqatmv5ohwnwbqoeri55a35yyhlm3drlltldy6mgajjkj2@eptml5ykp54h>
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
 <20250522-vsock-linger-v6-5-2ad00b0e447e@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250522-vsock-linger-v6-5-2ad00b0e447e@rbox.co>

On Thu, May 22, 2025 at 01:18:25AM +0200, Michal Luczaj wrote:
>There was an issue with SO_LINGER: instead of blocking until all queued
>messages for the socket have been successfully sent (or the linger timeout
>has been reached), close() would block until packets were handled by the
>peer.
>
>Add a test to alert on close() lingering when it should not.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/vsock_test.c | 52 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 52 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index b3258d6ba21a5f51cf4791514854bb40451399a9..f669baaa0dca3bebc678d00eafa80857d1f0fdd6 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1839,6 +1839,53 @@ static void test_stream_linger_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+/* Half of the default to not risk timing out the control channel */
>+#define LINGER_TIMEOUT	(TIMEOUT / 2)
>+
>+static void test_stream_nolinger_client(const struct test_opts *opts)
>+{
>+	bool waited;
>+	time_t ns;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	enable_so_linger(fd, LINGER_TIMEOUT);
>+	send_byte(fd, 1, 0); /* Left unread to expose incorrect behaviour. */
>+	waited = vsock_wait_sent(fd);
>+
>+	ns = current_nsec();
>+	close(fd);
>+	ns = current_nsec() - ns;
>+
>+	if (!waited) {
>+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>+	} else if (DIV_ROUND_UP(ns, NSEC_PER_SEC) >= LINGER_TIMEOUT) {
>+		fprintf(stderr, "Unexpected lingering\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("DONE");
>+}
>+
>+static void test_stream_nolinger_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("DONE");
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1999,6 +2046,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_linger_client,
> 		.run_server = test_stream_linger_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM SO_LINGER close() on unread",
>+		.run_client = test_stream_nolinger_client,
>+		.run_server = test_stream_nolinger_server,
>+	},
> 	{},
> };
>
>
>-- 
>2.49.0
>


