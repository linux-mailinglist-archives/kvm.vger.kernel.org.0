Return-Path: <kvm+bounces-47088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B58ABD250
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F3171B66263
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D226265CDE;
	Tue, 20 May 2025 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZgVEijk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5146225A65A
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731071; cv=none; b=dUp67V9fy2qSuQozgtr0BarwCn0rrb/ffTZVQGN3nJi6WrfHrENBnWZyFF6LhpoNaLdedAnKwbCjNAN8cJHo8BNwm8WkrAa80ihpXYxP2j+xD6i13UXylu7FcdCK4CQ7oSJrIZsjkgV8LQAlL6LGK7X+LXaRE68Gr/nUQKPFAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731071; c=relaxed/simple;
	bh=zotR65AwVsN1R6gTerMNJvK5LH8OmDOyCFKEesqrLiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYzZSpeTtmNd/EjQpqK5rxidMabmgkt9KSZWjGHiBKr56l/4M21MN8cNHPLRNkSDwex+uiJnk1f+bkoGsE6qjcNeLT0YbOncd2EwUbaqcH6+DqKtcTILQjkNNNMdoOUxv8JpQ3fPJBjPGFsf8FR8pIlgiEyrO8Ult8gALQ50DS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EZgVEijk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747731068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EOR3BGvukeRG/xgG5qyMBebhNmPVVYRJCDBQXWKeXAs=;
	b=EZgVEijkHj1Gxj0g1XUbVHli5jjLlEJiDsf/tevNaSuBinEM8rPD5kII+Z6lMmmv6JWDlZ
	5fxUDFgFayx+RPydXGpH2Tf4enhf0X/TmpiXDCOQ4NorIRtTbTWaTLKdd4q65Gq1N3ttC1
	1uIsgk3u+t9RkCmVnoNP8/O8V+EdkWc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-gTJv6lTsNRu--UwQkucWCg-1; Tue, 20 May 2025 04:51:06 -0400
X-MC-Unique: gTJv6lTsNRu--UwQkucWCg-1
X-Mimecast-MFC-AGG-ID: gTJv6lTsNRu--UwQkucWCg_1747731066
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5ffe81b2ec9so5833565a12.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 01:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731066; x=1748335866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOR3BGvukeRG/xgG5qyMBebhNmPVVYRJCDBQXWKeXAs=;
        b=TWkPnOaTwW6dcfJDASNd3NvuqVfQZyIZAHeB6M+AG1QXnSJqv6mZ5WQpIC+YXuHvbG
         dTSABEscROcL4QiKmCp63SFTtMPuHnQy3hFsTVfEsRTsWqH6mhgGFO07i+7K7ggvR0Ro
         8k1WwycUqMF7u/+QouQxZFBNAXKeptiGnXiffN+P0CbHwBPP5+RiTolOjhlMEMKR96L2
         gcLh7sEGMDYpsgVbrw2TdHt+CmkfOOkNN6axhRhIFk4Wyv48gF3NoJkpsCNvvBfN9B37
         JW93RYfvJHQr0Q5KEPb9etCkPt5c/byGBXYy4pEBmQoqbOMeMIcSsN4RoV91L+jmBfFq
         uEDg==
X-Forwarded-Encrypted: i=1; AJvYcCVcNhWGYSVC/m/BYQfeQWNkqcbJCnPOFyDBYTUVp2vi3Cddu0KANF7rZOAQZgOBI7BcY50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0n7J2tvEZCT7WAtP6fNOtqnb167fMlN1kLomdcZY8PrvxMrPi
	HVquKorLG0+BtFflmOp+O/rb8ah6CZIJ0kEjLUkyHW1CuBddYFKBw6CkedN3St50ua2LopTMvJz
	qWxRJsmkalMIi7CkR1oiVOjQC1mv9uKd8ayQe1rq2ItEVaf/R25EBkA==
X-Gm-Gg: ASbGncusz7NaLhSfLERoKHqT6VfdXmNLM5Ffu7Q+g5rTHm9hLuPBh/VLGcmVU17oGHq
	j5/nAj1hacWEwSG1zvzKC5yRT/76YWZ5xwysbNbVyhJIznRWVa8PYHl42hEEXCsf2CEyvDrNcbw
	rWh2Lrg2DYLcE710sUo+vpNOPrekfyTEtR60YWkLsfkUCP+JXyLZyW3zQtPjCDlehob7cwXYeUE
	dzIAUcw6i5OvzE3SHLD8uZjvMYSvtOO2y8xIwwSt9nsahPiXK0AJmJjGnsAt0YeutR+mwfBtrlz
	j8f8Dqr18kHy4dL7eaZ5aGdZ2MqkQZGWgR6aCT/SD07v5QNoRb7i3nU9TsnC
X-Received: by 2002:a17:907:2682:b0:ad5:2b4e:bb7b with SMTP id a640c23a62f3a-ad52d49e2ddmr1403356266b.15.1747731065646;
        Tue, 20 May 2025 01:51:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaI2ZCuVLkAOsu1YOAu/YmFtpemfCLgNGxHNGFSR/RD5XYMAMIGPJvHO7fGqKwrsdrpyBvDA==
X-Received: by 2002:a17:907:2682:b0:ad5:2b4e:bb7b with SMTP id a640c23a62f3a-ad52d49e2ddmr1403353566b.15.1747731065012;
        Tue, 20 May 2025 01:51:05 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d06e098sm708890366b.59.2025.05.20.01.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 01:51:04 -0700 (PDT)
Date: Tue, 20 May 2025 10:51:00 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, fupan.lfp@antgroup.com, pabeni@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	stefanha@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH 3/3] test/vsock: Add ioctl SIOCINQ tests
Message-ID: <66nlxrh4spcyhp666gqhovnevnnarq2a56fxgkffijnwiartrt@622gumoesmde>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
 <20250519070649.3063874-4-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250519070649.3063874-4-niuxuewei.nxw@antgroup.com>

On Mon, May 19, 2025 at 03:06:49PM +0800, Xuewei Niu wrote:
>This patch adds two tests for ioctl SIOCINQ for SOCK_STREAM and
>SOCK_SEQPACKET. The client waits for the server to send data, and checks if
>the return value of the SIOCINQ is the size of the data. Then, consumes the
>data and checks if the value is 0.

We recently fixed the SIOCOUTQ test, see:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7fd7ad6f36af36f30a06d165eff3780cb139fa79

Should we do the same here?

>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> tools/testing/vsock/vsock_test.c | 102 +++++++++++++++++++++++++++++++
> 1 file changed, 102 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index d0f6d253ac72..8b3fb88e2877 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1282,6 +1282,78 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> 	close(fd);
> }
>
>+static void test_unread_bytes_server(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int client_fd;
>+
>+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
>+	if (client_fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (int i = 0; i < sizeof(buf); i++)
>+		buf[i] = rand() & 0xFF;
>+
>+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
>+	control_writeln("SENT");
>+	control_expectln("RECEIVED");
>+
>+	close(client_fd);
>+}
>+
>+static void test_unread_bytes_client(const struct test_opts *opts, int type)
>+{
>+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>+	int ret, fd;
>+	int sock_bytes_unread;
>+
>+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SENT");
>+	// The data have come in but is not read, the expected value is
>+	// MSG_BUF_IOCTL_LEN.
>+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
>+	if (ret < 0) {
>+		if (errno == EOPNOTSUPP) {
>+			fprintf(stderr,
>+				"Test skipped, SIOCINQ not supported.\n");
>+			goto out;
>+		} else {
>+			perror("ioctl");
>+			exit(EXIT_FAILURE);
>+		}
>+	} else if (ret == 0 && sock_bytes_unread != MSG_BUF_IOCTL_LEN) {
>+		fprintf(stderr,
>+			"Unexpected 'SIOCOUTQ' value, expected %d, got %i\n",
>+			MSG_BUF_IOCTL_LEN, sock_bytes_unread);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
>+	// The data is consumed, so the expected is 0.
>+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
>+	if (ret < 0) {
>+		// Don't ignore EOPNOTSUPP since we have already checked it!
>+		perror("ioctl");
>+		exit(EXIT_FAILURE);
>+	} else if (ret == 0 && sock_bytes_unread != 0) {
>+		fprintf(stderr,
>+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
>+			sock_bytes_unread);
>+		exit(EXIT_FAILURE);
>+	}
>+	control_writeln("RECEIVED");
>+
>+out:
>+	close(fd);
>+}
>+
> static void test_stream_unsent_bytes_client(const struct test_opts *opts)
> {
> 	test_unsent_bytes_client(opts, SOCK_STREAM);
>@@ -1302,6 +1374,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
> 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
> }
>
>+static void test_stream_unread_bytes_client(const struct test_opts *opts)
>+{
>+	test_unread_bytes_client(opts, SOCK_STREAM);
>+}
>+
>+static void test_stream_unread_bytes_server(const struct test_opts *opts)
>+{
>+	test_unread_bytes_server(opts, SOCK_STREAM);
>+}
>+
>+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
>+{
>+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
>+}
>+
>+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
>+{
>+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
>+}
>+
> #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
> /* This define is the same as in 'include/linux/virtio_vsock.h':
>  * it is used to decide when to send credit update message during
>@@ -1954,6 +2046,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_unsent_bytes_client,
> 		.run_server = test_seqpacket_unsent_bytes_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
>+		.run_client = test_stream_unread_bytes_client,
>+		.run_server = test_stream_unread_bytes_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
>+		.run_client = test_seqpacket_unread_bytes_client,
>+		.run_server = test_seqpacket_unread_bytes_server,
>+	},

Please, append new test at the end, so we will not change test IDs.

Thanks,
Stefano

> 	{
> 		.name = "SOCK_STREAM leak accept queue",
> 		.run_client = test_stream_leak_acceptq_client,
>-- 
>2.34.1
>


