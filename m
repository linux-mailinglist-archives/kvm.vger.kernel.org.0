Return-Path: <kvm+bounces-47280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 981BBABF893
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EC2C7A7EB1
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 14:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E3C21D5A9;
	Wed, 21 May 2025 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4ok8kMb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB261DEFFC
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839380; cv=none; b=cDKEMMtryKqJO64gx62lZl7s0NDY4A/pTxoQe2PFN5/K/3O4IyXfRP/KkUUH31zFTAhLWf73D8HETLsxadgEOEIAfYYAnWpAweXFFxIU3Eg+IJVoaqQZH7i1XpS83kUKO6oySJuYrHcKl/JBkGtuI05quLDE2Km23UctO/NVYEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839380; c=relaxed/simple;
	bh=4+Wj4hxdaXN96SjUIAfwiVesd+p9hyy1LELAnrGN8UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgvE4mXkho49wAU0SsvxcPqxaabDevZj03vVUR7PGeNfUi70BYukYj3wC8SzPhxH6baglccHB0tFTP2/IUApy0xrCImrD9IsJ0eQsv8gLCmsccYJlBoj509I6xmsGgIjkxZvhNFuw0UHbjuwCTYjLnIuUE4ay4oSzg9b+mnTnqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4ok8kMb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747839377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSCBFcNuY0Goh2S9d5LToDFwcxHuL80JaO8Gh+v1hTQ=;
	b=Z4ok8kMbqYfNmgLVlMcdUXsC841s18DPkXoA7VRrwciooIk81EgWrz0dH+Hf3lzsHGtF+/
	Zf9kxXZclokOxjhNqyGkaskSirtsTPct0JRKK+e4Nbp9WUjOF2u5/w+kcd90uzfMDNHmhf
	HQV58JAxbf+t0zD0I+wC9NpEddY8adI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-gCVVEw-1NAiyiPlkjE9zSA-1; Wed, 21 May 2025 10:56:15 -0400
X-MC-Unique: gCVVEw-1NAiyiPlkjE9zSA-1
X-Mimecast-MFC-AGG-ID: gCVVEw-1NAiyiPlkjE9zSA_1747839374
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ad56222a1easo329036466b.1
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 07:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839374; x=1748444174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSCBFcNuY0Goh2S9d5LToDFwcxHuL80JaO8Gh+v1hTQ=;
        b=s99SGOASBZkcKcM/AQbunlrUHyLs+K7T5fEIw/gDsI+AAZQ/ivP02/EHA97EZSglxB
         xZ+qHx141Ze7NjmrKq76pazQa1Pe+5SwT+EiyIb95mNcuD1A/O6GwOZ6ufb1R6Oub2pi
         kvOM5sp2fT+OhBsH9+iz4eaNan8ejAIUULNzUpAQ+7Eoor3QnSs0m3vgz9CbE1ENIYMl
         d2vSM8Apd8taNpjHVRcnaLXhWcM+u48khaIuGgbMG7ElJi/3NaikHhyFctHFd9unEqUL
         2m6tJfT2/EVY6dGqK52ZrMOeCwVPP9O7Ix2JHkl2DKJhf1jypvl3vJeJA8EIv8rn6rCn
         d1gA==
X-Forwarded-Encrypted: i=1; AJvYcCUmd+Hb57MO8qQBs5yXdv0bgy4ygu9//jCqhPUkYc5F71It5hENCOjhfxoQaxVxXidfKWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgALHjO0BAGLPnT9eQjbaXwUDdCxDwCQ16LfbMwVS/hOZ2uPJl
	oIjtNHVgdQlJZspTRHcKURztM6hkpo6yCxT4fM1xQLkAAPNatjZa3jidvoNqWAO3QCgA529p49J
	/s1+7w/Co0O1GF3yvWLQQ2Ho+4E+jhhFz/vMK+p+ukWrroLGxDfreaA==
X-Gm-Gg: ASbGncsLhgUZHuHC0RZlrrZryY11Qo9QwK5nYhKfiId/fpzypBtZyGNPHvfL413lyWF
	UM3ULEMsvjPCQy+2n+iyFCUF+3u/Sz3IWc+3t7HpE77VvJZGRtO7wtHThmoHGudEeCnHrGjcrsZ
	NPBvVFTLdA2YdOkxriTYD9D3/9/woqBHStBt/ZuMZROCRTn/GI8eKjeVw3YWdIQb/NR+vgIVdCO
	4jynHUcYAC4Sf8NKtlOrHQ+9yXzQv0rlZ/mQ3IME5KukXopVbkZv/8nJh5JMgEB66hx+2sRo5aS
	NXv+L4Lfi+cNrAp3hXWwa7lIZvNhaogOU6sqyVwAaQA841vt9TeQKlKPW2Sm
X-Received: by 2002:a17:907:9495:b0:ace:d710:a8d1 with SMTP id a640c23a62f3a-ad52d4dae84mr1752075366b.24.1747839374465;
        Wed, 21 May 2025 07:56:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpoMMbzNscVWDbJ9f7DsJa/QwbA0pdV/T5aW3r3Yle27irZapU6e/PHt7khHjWn7nACqdpnQ==
X-Received: by 2002:a17:907:9495:b0:ace:d710:a8d1 with SMTP id a640c23a62f3a-ad52d4dae84mr1752071266b.24.1747839373682;
        Wed, 21 May 2025 07:56:13 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d278290sm905573266b.78.2025.05.21.07.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 07:56:13 -0700 (PDT)
Date: Wed, 21 May 2025 16:56:10 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 5/5] vsock/test: Add test for an unexpectedly
 lingering close()
Message-ID: <edtepfqev6exbkfdnyzgkdkczif5wnn4oz4t5sxkl6sz64kcaf@f6yztxryvmlq>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
 <20250521-vsock-linger-v5-5-94827860d1d6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521-vsock-linger-v5-5-94827860d1d6@rbox.co>

On Wed, May 21, 2025 at 12:55:23AM +0200, Michal Luczaj wrote:
>There was an issue with SO_LINGER: instead of blocking until all queued
>messages for the socket have been successfully sent (or the linger timeout
>has been reached), close() would block until packets were handled by the
>peer.
>
>Add a test to alert on close() lingering when it should not.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/vsock_test.c | 49 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index f401c6a79495bc7fda97012e5bfeabec7dbfb60a..1040503333cf315e52592c876f2c1809b36fdfdb 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1839,6 +1839,50 @@ static void test_stream_linger_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_stream_nolinger_client(const struct test_opts *opts)
>+{
>+	bool nowait;
>+	time_t ns;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	enable_so_linger(fd);

If we use a parameter for the linger timeout, IMO will be easy to 
understand this test, defining the timeout in this test, set it and 
check the value, without defining LINGER_TIMEOUT in util.h.

>+	send_byte(fd, 1, 0); /* Left unread to expose incorrect behaviour. */
>+	nowait = vsock_wait_sent(fd);
>+
>+	ns = current_nsec();
>+	close(fd);
>+	ns = current_nsec() - ns;
>+
>+	if (nowait) {
>+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>+	} else if ((ns + NSEC_PER_SEC - 1) / NSEC_PER_SEC >= LINGER_TIMEOUT) {

Should we define a macro for this conversion?

Or just use DIV_ROUND_UP:

--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -1831,7 +1831,7 @@ static void test_stream_nolinger_client(const struct test_opts *opts)

         if (nowait) {
                 fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
-       } else if ((ns + NSEC_PER_SEC - 1) / NSEC_PER_SEC >= LINGER_TIMEOUT) {
+       } else if (DIV_ROUND_UP(ns, NSEC_PER_SEC) >= LINGER_TIMEOUT) {
                 fprintf(stderr, "Unexpected lingering\n");
                 exit(EXIT_FAILURE);
         }

The rest LGTM.

Thanks,
Stefano

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
>@@ -1999,6 +2043,11 @@ static struct test_case test_cases[] = {
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


