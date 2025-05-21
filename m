Return-Path: <kvm+bounces-47209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E8DABE9A5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F249B7A7B31
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C8322B8BD;
	Wed, 21 May 2025 02:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJtJfoFq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB891A83F7;
	Wed, 21 May 2025 02:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793760; cv=none; b=Y4i15gZqFy9pBlgLcWpYrKDaNacUdPlnWu5qe+CD25HkyLoUueJsdk7CnMg9Oclgdp/RihUGAh8jZUlApvODzUcArY+rKBAn1OssPFLgrYuL7a7FTBEE77fC56Kq0LUGXrvtH5PMRKfJJIHJzoQ2SYAtk3fu5+bFwCiqVd4MlkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793760; c=relaxed/simple;
	bh=Bs4BiJyZnHS+osIO5aswWUeDg/rd7svFNSIs/C9/26E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LJt8YXrUJpvVwm7ryqtQsfU4bQ6EaOgbbejTbbVdauD5PXIQNUeESTP2eIo05vRVZdmIbas6VEuPFFOXFnOtf9HUJ5rfaWS9uM/iMk6TWrW1ksIJ7ak3r5ZKaFU/WiiesKQHsn0EWlnw/FnSvLkOjNLbRJB+U2Y6tiZDW4BEHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MJtJfoFq; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so5039679a12.3;
        Tue, 20 May 2025 19:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747793758; x=1748398558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kd9cM0q6TzRXjUrGv1P7+9M2LieKCrro4Un91zfrq/Q=;
        b=MJtJfoFqwTl8zcez2rCwoQRXzphs0p/1UAv/4o5qOd0GyUm5MQ/ONNnUUBnRFCb/Jt
         GxMwcXHwjGex1EQCp48tQPFmrVzIs+seohWsu4wsA1zpyMeKwrutSp4+zGteeGfFGSW8
         UZeyMk2gY4g5rfFvt0iya8CR2/QPoS0LPDkJwobpqQ4caelsN6MYP831BelnB+1tVXDI
         RrvqYTW62zjvdc4ulMXo+sOV1lD+VI7w0aXTH966zwz98bJ4iC7QQ8ZcJUeF0/d8itug
         3mAd1pmbiaxWbjYrAmTS6hoVmM2b0BmFxJ0+lOu2MgolHOYR+DDEewmJlRTa8oecOE6N
         6LpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747793758; x=1748398558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kd9cM0q6TzRXjUrGv1P7+9M2LieKCrro4Un91zfrq/Q=;
        b=EIzoD4AI9nDWrtfeVcH7V8SAn9x8NtSbmIJ1qvZGNMzlFThB3djIsMfBupz2yfaorG
         yk0BciL9qsr5iY8NhFWQWijZfZSRJjlA8ttwLpYDbc5C5VwtpLckGVzlQEphhbGaI4Qj
         gRN6KZ9KjXAyRgS3JzC0Gm9zoO5oQlAPrbUOEogqPpLQ0+n/wbGWD61BauGx68NNdpV/
         nOw+KGKI6tKlrTx5Hhp2S239Fm7VlDws8yu5YYD3JPHsFRPh+VjPSBV3bqhboxQPIXzQ
         zb2vK3IcwJZBGwXj1+wNgJtH32uw9B3sZfgeOQ9h+QE0/y9Hb5iWPQuHdeXdXRr0g2kV
         1TVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzZ156FAymeME4RnNQoO4ygjLoDsi87gBUURyG9Br1cgaGwdBhIQzkQZSQYR3mZvmJ1T/fhXCZ0xDOhwj+@vger.kernel.org, AJvYcCXq9DlbnzQvlUNSEHLMHSm0HMG3qAVPwOsYUe+2GGl3D/qoHWUx9IkLMVMb7pr3/q70s8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAPR8ladsBjjNLUXQqZOdCFAzXzzDNxIK915ux4s3sgU+Nfw69
	mUaQzO8Gmz6+CSsFgovZlgwemPu61w235VGJ7KRZGTN4bYBm0ITKWkxKHo4LH19hNug=
X-Gm-Gg: ASbGncv1qyhT+6nrv8xDp7Dt8SDRvesj1BMawlHDiM4R5+j8vUJ2JQ3Rjitwmmj07HR
	Rj3Ki5RccaNK+Flhg8AoX2S4Uia90v1q1/DmV3vN5OlBSWS+sgE/3xAtbipH1o4tLLcipsjAmJ8
	s0tdgDJpq8+jsILSEUEayzmw0lcPUuxPCqnbROUPHRp6kho1R6FfYRn39iXKmnWQHE1VR5TKPdZ
	wxwnkIiz8UHvCdX0LfB44MIwRaOfSyfqP9+XdStlScmowE7qzjfBsg4KAtVK81IFaSv2kjGVxnz
	nOU+5U6zJDtnpc0wtP6EdGEO7ArGs3zkaHN+UAXaDZfGxg+EdvLAKNEjJhmd5Hp4H/PmSGP7ZQ=
	=
X-Google-Smtp-Source: AGHT+IFi6LzKyxEuGPX8+9ng4fooYqUmoGNYHzHrk3u0MP3KOPqggigCsjb9hq7ZYiVqv62DNpiDVA==
X-Received: by 2002:a17:90b:2f85:b0:30e:8f60:b53 with SMTP id 98e67ed59e1d1-30e8f600d9bmr22899418a91.19.1747793757727;
        Tue, 20 May 2025 19:15:57 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f364fff8asm2475124a91.39.2025.05.20.19.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 19:15:57 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 3/3] test/vsock: Add ioctl SIOCINQ tests
Date: Wed, 21 May 2025 10:15:47 +0800
Message-Id: <20250521021547.3219644-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <66nlxrh4spcyhp666gqhovnevnnarq2a56fxgkffijnwiartrt@622gumoesmde>
References: <66nlxrh4spcyhp666gqhovnevnnarq2a56fxgkffijnwiartrt@622gumoesmde>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, May 19, 2025 at 03:06:49PM +0800, Xuewei Niu wrote:
> >This patch adds two tests for ioctl SIOCINQ for SOCK_STREAM and
> >SOCK_SEQPACKET. The client waits for the server to send data, and checks if
> >the return value of the SIOCINQ is the size of the data. Then, consumes the
> >data and checks if the value is 0.
> 
> We recently fixed the SIOCOUTQ test, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7fd7ad6f36af36f30a06d165eff3780cb139fa79
> 
> Should we do the same here?

Yeah! Indeed, we have recognized this issue before. I think it is better to
wrap this ioctl operation in a function in "tools/testing/vsock/util.c" and
make it reusable.

Will do.

> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > tools/testing/vsock/vsock_test.c | 102 +++++++++++++++++++++++++++++++
> > 1 file changed, 102 insertions(+)
> >
> >diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> >index d0f6d253ac72..8b3fb88e2877 100644
> >--- a/tools/testing/vsock/vsock_test.c
> >+++ b/tools/testing/vsock/vsock_test.c
> >@@ -1282,6 +1282,78 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> > 	close(fd);
> > }
> >
> >+static void test_unread_bytes_server(const struct test_opts *opts, int type)
> >+{
> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
> >+	int client_fd;
> >+
> >+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
> >+	if (client_fd < 0) {
> >+		perror("accept");
> >+		exit(EXIT_FAILURE);
> >+	}
> >+
> >+	for (int i = 0; i < sizeof(buf); i++)
> >+		buf[i] = rand() & 0xFF;
> >+
> >+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
> >+	control_writeln("SENT");
> >+	control_expectln("RECEIVED");
> >+
> >+	close(client_fd);
> >+}
> >+
> >+static void test_unread_bytes_client(const struct test_opts *opts, int type)
> >+{
> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
> >+	int ret, fd;
> >+	int sock_bytes_unread;
> >+
> >+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
> >+	if (fd < 0) {
> >+		perror("connect");
> >+		exit(EXIT_FAILURE);
> >+	}
> >+
> >+	control_expectln("SENT");
> >+	// The data have come in but is not read, the expected value is
> >+	// MSG_BUF_IOCTL_LEN.
> >+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
> >+	if (ret < 0) {
> >+		if (errno == EOPNOTSUPP) {
> >+			fprintf(stderr,
> >+				"Test skipped, SIOCINQ not supported.\n");
> >+			goto out;
> >+		} else {
> >+			perror("ioctl");
> >+			exit(EXIT_FAILURE);
> >+		}
> >+	} else if (ret == 0 && sock_bytes_unread != MSG_BUF_IOCTL_LEN) {
> >+		fprintf(stderr,
> >+			"Unexpected 'SIOCOUTQ' value, expected %d, got %i\n",
> >+			MSG_BUF_IOCTL_LEN, sock_bytes_unread);
> >+		exit(EXIT_FAILURE);
> >+	}
> >+
> >+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
> >+	// The data is consumed, so the expected is 0.
> >+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
> >+	if (ret < 0) {
> >+		// Don't ignore EOPNOTSUPP since we have already checked it!
> >+		perror("ioctl");
> >+		exit(EXIT_FAILURE);
> >+	} else if (ret == 0 && sock_bytes_unread != 0) {
> >+		fprintf(stderr,
> >+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
> >+			sock_bytes_unread);
> >+		exit(EXIT_FAILURE);
> >+	}
> >+	control_writeln("RECEIVED");
> >+
> >+out:
> >+	close(fd);
> >+}
> >+
> > static void test_stream_unsent_bytes_client(const struct test_opts *opts)
> > {
> > 	test_unsent_bytes_client(opts, SOCK_STREAM);
> >@@ -1302,6 +1374,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
> > 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
> > }
> >
> >+static void test_stream_unread_bytes_client(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_client(opts, SOCK_STREAM);
> >+}
> >+
> >+static void test_stream_unread_bytes_server(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_server(opts, SOCK_STREAM);
> >+}
> >+
> >+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
> >+}
> >+
> >+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
> >+}
> >+
> > #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
> > /* This define is the same as in 'include/linux/virtio_vsock.h':
> >  * it is used to decide when to send credit update message during
> >@@ -1954,6 +2046,16 @@ static struct test_case test_cases[] = {
> > 		.run_client = test_seqpacket_unsent_bytes_client,
> > 		.run_server = test_seqpacket_unsent_bytes_server,
> > 	},
> >+	{
> >+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
> >+		.run_client = test_stream_unread_bytes_client,
> >+		.run_server = test_stream_unread_bytes_server,
> >+	},
> >+	{
> >+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
> >+		.run_client = test_seqpacket_unread_bytes_client,
> >+		.run_server = test_seqpacket_unread_bytes_server,
> >+	},
> 
> Please, append new test at the end, so we will not change test IDs.
> 
> Thanks,
> Stefano

Will do.

Thanks,
Xuewei

> > 	{
> > 		.name = "SOCK_STREAM leak accept queue",
> > 		.run_client = test_stream_leak_acceptq_client,
> >-- 
> >2.34.1
> >

