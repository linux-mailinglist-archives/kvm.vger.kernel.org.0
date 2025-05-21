Return-Path: <kvm+bounces-47246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8C8ABEEE1
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 11:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED4714E0A74
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 09:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FBF23906A;
	Wed, 21 May 2025 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ubsl7cuR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FD4238C16
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747818061; cv=none; b=QoIvS8HxJ26Vz+nce0MCmZ42aplpsXXA26qeBDMMHqIlN1WZm7IElOHZ4YgkphAh6W9g18JGv6RUeZjTJfZraJT77KWjJ+Q7CpMjNrmGVBShAFsmWnW79FqoYeOmD/HgD9LSnSSL4LB5dnO5Glkk4y3lyxllRhIswR9mCKhHfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747818061; c=relaxed/simple;
	bh=zxqlcCHjn9DECK7D2DJ+PZqC71mdqOI3OEgJbzwKaWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ST+5db8CTRssqGoJnzma2Nyx/Ugn94NquX/ZwcTR5TUdGLdHTo216kiH/jUMNHa2sW0mBkMh6bqvr4kwtwWzGXbp3ctzBkmgiQw9KVonz5w4QE4PQ0bc1iFVDTDh91qsYSEcCYLh52GRsaZPv8SlYKLLe8bxcu/WS42K48l3B3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ubsl7cuR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747818058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AD4EK4fumuor3MaeEitkMqyIxHlSc7zrFrRly6wc7pM=;
	b=Ubsl7cuRN7860gWq4f1c7SVx5aNUB4ZpoXFYGuL1ahg+Sz+IB9mx24DIbTWtIp6FRew53k
	0WcsuiUBHFflFUNB/e7kE50t2HXuxs8Yr6JEzcUz4K+cpPfOenQl3v5k/xLPENophrnUt0
	/AIhbW5BwaOD6xLdem24V3Xc1Ygsn+E=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-pi3r_-EoNgaJbFjW2Q0JOA-1; Wed, 21 May 2025 05:00:57 -0400
X-MC-Unique: pi3r_-EoNgaJbFjW2Q0JOA-1
X-Mimecast-MFC-AGG-ID: pi3r_-EoNgaJbFjW2Q0JOA_1747818056
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acbbb000796so482624666b.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 02:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747818056; x=1748422856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AD4EK4fumuor3MaeEitkMqyIxHlSc7zrFrRly6wc7pM=;
        b=hKAEpUm8No5Tn7bc0Zuje8b6CM3vOMe8wqsoKQNxwwJQ2dPHJ+WS2a4IV+e/elj59h
         D7gP3LaC2psxx4ig7TXTV1YpBhnw0pOlL6ybVFkeEcELhy7TzkcI65crmT6EF+m7DetV
         WiVnWhJ+BwgTJUQ6uvEU46nM2C8yQaPLhcmPTBjkMeoXq3MyUb2uMSvZgxb7OOGZ/n/l
         5bKi2Yefj6XvrUHpVmMXnEnkQ7n9u3u+iEkZHVPeFkXu57knrOru5YHpGzG9j8VrWMPn
         6AEGyzreCFGZ1pxjvFVmxaSupGY7wq9j5XZmeChLI2mUIGoza0ntyK5m6euM1qz3TTxH
         B2CQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5umG72vNE4rQmH/AGjb0aIuezFpN4g9VRFxMYqTXYu7aq/FvuGBwtuX4P3mAHQhn3VLc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5OuqWe3q8gGjcQZN+VNFsb+c/v0GMqXKNIQ5m/LEySY2ddTmV
	0jFA69m+z8pc9fv1Wj09x2U8vNE5/heDjaX/dGYirMGMYN3hFJiyJg7zonXmNEBewEpm7T0PGb7
	Q16E0WSOS5N0xmm5cxwQXdUirH1vtuQsQdXIHZJEErCx6GY6UIOFJ8w==
X-Gm-Gg: ASbGncsrSA1GrFw+Ep/O91F2gCKujmfI1IMvPOErodkNr8VXF/bcCKHSewOtIvQrFjO
	4zCfeuas/IXDYkBpcI40oQCuiEWJZXmr9Hcx6W59atWYwoPZJsKDYQWO45YQ75rN+lN72MxTf25
	63+0izsn7dqRY0UVJemz0mdrVPWmhd+31LGDlIzBUaeYXiPxGotRn5DkwYdR75GK4jkKOLPLHSZ
	lVF/KzbdAlT9XTKZtLCGjPoOrljlC8mOVvn5yz/4XUZKhkM3MzMtHZr4yNXVlJitinN7lwvwoMM
	Wt3orz7MHL3tMkaVXLW1Zd9K/iINMt0GUjqJ5K1Mglg20z3i2vFQbEAvHZMz
X-Received: by 2002:a17:906:4789:b0:ad5:4cd4:5bfd with SMTP id a640c23a62f3a-ad54cd46015mr1406567266b.12.1747818055849;
        Wed, 21 May 2025 02:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjCfNk8+hZJGGzRrIjNaK7ckU8gBwZmBkU+v/X6tNeZwj/R7jjaFqDeo7WbqVCQp/yENzVvA==
X-Received: by 2002:a17:906:4789:b0:ad5:4cd4:5bfd with SMTP id a640c23a62f3a-ad54cd46015mr1406563166b.12.1747818055228;
        Wed, 21 May 2025 02:00:55 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d04e665sm862194666b.5.2025.05.21.02.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 02:00:54 -0700 (PDT)
Date: Wed, 21 May 2025 11:00:50 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: davem@davemloft.net, fupan.lfp@antgroup.com, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	niuxuewei.nxw@antgroup.com, pabeni@redhat.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 3/3] test/vsock: Add ioctl SIOCINQ tests
Message-ID: <k6vzt5brosmomqzb7ibripcxh4pauz4juwqvhv77sv7vbywglq@m4bpb3hpoc3n>
References: <66nlxrh4spcyhp666gqhovnevnnarq2a56fxgkffijnwiartrt@622gumoesmde>
 <20250521021547.3219644-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250521021547.3219644-1-niuxuewei.nxw@antgroup.com>

On Wed, May 21, 2025 at 10:15:47AM +0800, Xuewei Niu wrote:
>> On Mon, May 19, 2025 at 03:06:49PM +0800, Xuewei Niu wrote:
>> >This patch adds two tests for ioctl SIOCINQ for SOCK_STREAM and
>> >SOCK_SEQPACKET. The client waits for the server to send data, and checks if
>> >the return value of the SIOCINQ is the size of the data. Then, consumes the
>> >data and checks if the value is 0.
>>
>> We recently fixed the SIOCOUTQ test, see:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7fd7ad6f36af36f30a06d165eff3780cb139fa79
>>
>> Should we do the same here?
>
>Yeah! Indeed, we have recognized this issue before. I think it is better to
>wrap this ioctl operation in a function in "tools/testing/vsock/util.c" and
>make it reusable.

Yep, if that helps to reduce code duplication, it's fine.

Thanks,
Stefano

>
>Will do.
>
>> >
>> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>> >---
>> > tools/testing/vsock/vsock_test.c | 102 +++++++++++++++++++++++++++++++
>> > 1 file changed, 102 insertions(+)
>> >
>> >diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> >index d0f6d253ac72..8b3fb88e2877 100644
>> >--- a/tools/testing/vsock/vsock_test.c
>> >+++ b/tools/testing/vsock/vsock_test.c
>> >@@ -1282,6 +1282,78 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
>> > 	close(fd);
>> > }
>> >
>> >+static void test_unread_bytes_server(const struct test_opts *opts, int type)
>> >+{
>> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>> >+	int client_fd;
>> >+
>> >+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
>> >+	if (client_fd < 0) {
>> >+		perror("accept");
>> >+		exit(EXIT_FAILURE);
>> >+	}
>> >+
>> >+	for (int i = 0; i < sizeof(buf); i++)
>> >+		buf[i] = rand() & 0xFF;
>> >+
>> >+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
>> >+	control_writeln("SENT");
>> >+	control_expectln("RECEIVED");
>> >+
>> >+	close(client_fd);
>> >+}
>> >+
>> >+static void test_unread_bytes_client(const struct test_opts *opts, int type)
>> >+{
>> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
>> >+	int ret, fd;
>> >+	int sock_bytes_unread;
>> >+
>> >+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
>> >+	if (fd < 0) {
>> >+		perror("connect");
>> >+		exit(EXIT_FAILURE);
>> >+	}
>> >+
>> >+	control_expectln("SENT");
>> >+	// The data have come in but is not read, the expected value is
>> >+	// MSG_BUF_IOCTL_LEN.
>> >+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
>> >+	if (ret < 0) {
>> >+		if (errno == EOPNOTSUPP) {
>> >+			fprintf(stderr,
>> >+				"Test skipped, SIOCINQ not supported.\n");
>> >+			goto out;
>> >+		} else {
>> >+			perror("ioctl");
>> >+			exit(EXIT_FAILURE);
>> >+		}
>> >+	} else if (ret == 0 && sock_bytes_unread != MSG_BUF_IOCTL_LEN) {
>> >+		fprintf(stderr,
>> >+			"Unexpected 'SIOCOUTQ' value, expected %d, got %i\n",
>> >+			MSG_BUF_IOCTL_LEN, sock_bytes_unread);
>> >+		exit(EXIT_FAILURE);
>> >+	}
>> >+
>> >+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
>> >+	// The data is consumed, so the expected is 0.
>> >+	ret = ioctl(fd, SIOCINQ, &sock_bytes_unread);
>> >+	if (ret < 0) {
>> >+		// Don't ignore EOPNOTSUPP since we have already checked it!
>> >+		perror("ioctl");
>> >+		exit(EXIT_FAILURE);
>> >+	} else if (ret == 0 && sock_bytes_unread != 0) {
>> >+		fprintf(stderr,
>> >+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
>> >+			sock_bytes_unread);
>> >+		exit(EXIT_FAILURE);
>> >+	}
>> >+	control_writeln("RECEIVED");
>> >+
>> >+out:
>> >+	close(fd);
>> >+}
>> >+
>> > static void test_stream_unsent_bytes_client(const struct test_opts *opts)
>> > {
>> > 	test_unsent_bytes_client(opts, SOCK_STREAM);
>> >@@ -1302,6 +1374,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
>> > 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
>> > }
>> >
>> >+static void test_stream_unread_bytes_client(const struct test_opts *opts)
>> >+{
>> >+	test_unread_bytes_client(opts, SOCK_STREAM);
>> >+}
>> >+
>> >+static void test_stream_unread_bytes_server(const struct test_opts *opts)
>> >+{
>> >+	test_unread_bytes_server(opts, SOCK_STREAM);
>> >+}
>> >+
>> >+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
>> >+{
>> >+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
>> >+}
>> >+
>> >+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
>> >+{
>> >+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
>> >+}
>> >+
>> > #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
>> > /* This define is the same as in 'include/linux/virtio_vsock.h':
>> >  * it is used to decide when to send credit update message during
>> >@@ -1954,6 +2046,16 @@ static struct test_case test_cases[] = {
>> > 		.run_client = test_seqpacket_unsent_bytes_client,
>> > 		.run_server = test_seqpacket_unsent_bytes_server,
>> > 	},
>> >+	{
>> >+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
>> >+		.run_client = test_stream_unread_bytes_client,
>> >+		.run_server = test_stream_unread_bytes_server,
>> >+	},
>> >+	{
>> >+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
>> >+		.run_client = test_seqpacket_unread_bytes_client,
>> >+		.run_server = test_seqpacket_unread_bytes_server,
>> >+	},
>>
>> Please, append new test at the end, so we will not change test IDs.
>>
>> Thanks,
>> Stefano
>
>Will do.
>
>Thanks,
>Xuewei
>
>> > 	{
>> > 		.name = "SOCK_STREAM leak accept queue",
>> > 		.run_client = test_stream_leak_acceptq_client,
>> >--
>> >2.34.1
>> >
>


