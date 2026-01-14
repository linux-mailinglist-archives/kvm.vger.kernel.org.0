Return-Path: <kvm+bounces-68015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 825D4D1DE7D
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 92C52309AB18
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEA739341E;
	Wed, 14 Jan 2026 10:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h15BPRSu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBiEnuB6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2C138B7BF
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 10:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385292; cv=none; b=rUU1TTcVdNVLiN+JmPeeAzi8itjYiOIo484yn/jU1urnL9dapMC+8wpZc2xurDVBwq81zp1t3xJEKRAGcHyqUKWThvhsyjk5Sf/3qD8l0R6jMTSCZfpEXX999JE4tK2TiYC8wdQ7KI6+1ZpIrLLff40Iyq3GWyeWzQ8EhF9IgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385292; c=relaxed/simple;
	bh=R34QuFzq0RM2B+MUSlKhuKjAZtk77eiyestyrQbTikI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StUPSKoHFvzScPuqGvZuWwcpXjmZhg7CftpsujBJ3DW3X6Q2/Oj3uUDtWt/D5YUA10NBblxZ73zoegwnrPWi9vweZE/cufJupsxszKl5bsexOygpOhIrDMOU4PDLFtFtR+Lu7jwIq97iLr+3TUF74xEDFuF7XSrCUKmiVzC5RZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h15BPRSu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBiEnuB6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768385290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gLVLJe5ZoPPurYSTDDy8POZ2YmIqBUOxjilC1ypOvdA=;
	b=h15BPRSubujaR26aC/lP+rzsIrhqQJYCXKboOoo+Rfb7x7l9XqDwgmZVtxi270nUGQewRu
	qe1hY41liDpyXXNJT5DLg9S0GdTABttqZbFZPTBeG75vJMf3DIm6y9He4pRqzwYNY/NZsG
	N0rnnGLbhFGfTjdxzLU/z7WMbcj3d6k=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-WIIEs5m0M0yWie471WwmFQ-1; Wed, 14 Jan 2026 05:08:08 -0500
X-MC-Unique: WIIEs5m0M0yWie471WwmFQ-1
X-Mimecast-MFC-AGG-ID: WIIEs5m0M0yWie471WwmFQ_1768385287
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b844098869cso922474666b.2
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 02:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768385287; x=1768990087; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gLVLJe5ZoPPurYSTDDy8POZ2YmIqBUOxjilC1ypOvdA=;
        b=eBiEnuB66OPvOPhZxPaxxp7aC3QXE2up/Hs0Vq+K/u3RS8FSMGFlN1u4vZEiqlogQW
         7TD+m+n84xHWqz946E3EIoatAHxZwf9RnGeAAKrApHly084t55zr+nTtvUxoOTvLLs0z
         hTTfY9m9iqXMYgUTnvgxJbncpn9jju3OKaNL840XolDO4/EMzJt0bH5QMTdvsR5p+A2y
         IwqYsCQ4AJqPY1hDo3EvLqngqHHXYHc//VFe+yYASrIfq8wgALyQlvSstzVhVecFA3mh
         afEkR6tU0Pgusn3VWY1Hl4lorXqAEwbozwSawL55AaLNj8iWZ8HK1IIBqT4EyVIvZ/VB
         OD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768385287; x=1768990087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLVLJe5ZoPPurYSTDDy8POZ2YmIqBUOxjilC1ypOvdA=;
        b=cfdaIVGSMe0paj6h7nZmMf7m4QKaP1ff5AevAj8Lx3gNkEg6U5Vk0ypuWutTy9cg57
         Y19b7QidgjxpDJk/54ax/8McepiEioaHakem+D8/ax0XhGSkHwNODO0KYxay3QBGEAgo
         UYE+dzqXJ8F5QaSTvlIFagFYlNVOkbme+hSSHXi1FHpL8FCArASoqheijSzOkQYVapTZ
         dGS0qzALGZD+kYdzrH2KNSeqUfnFdd/MvUkMaETlapcy0t06GcVAoWU2tNrkZFs+w/mJ
         bx+wsW5EFxzWemOqRnq1G0/Lxgsme2ZpAIDnPrfU3weFFjyowsiSw1b8VlyEP5i5fxPu
         pn+A==
X-Forwarded-Encrypted: i=1; AJvYcCXJoAKyHsd+LT68jgVHVqFSu5kR1UAJict9q7a4SdgbmgV1kHCE5LgFb/5rcs2OZOii9GU=@vger.kernel.org
X-Gm-Message-State: AOJu0YycE0qkR8l2OpfVs9YFZ/tEnIH1GC/Af0giOMjjKEUspbW1iYfg
	80JNLTzGkPdROR3IoBBMYzjGjrj/XgRIUsaii4NS0ITY7wom4g3AyHfnuos5gUC8brOTbUgsK2P
	tIZirmRL4IF3mfTSDQyiWQJ3UwP32MFhPs9q1GxMHfAqOVOubzfbP1A==
X-Gm-Gg: AY/fxX5kJ540NU+c9xVab5Yl4F4wp+CeBxwj5g9r98YAj7/OeLpR8N3V7bUx9ugQ5ex
	/IV8OC/oQcPlAVqAeoqT4mMtEuNEXAlOa2L2AuQualZFy+a7n6YRmJTGvnxccxmU3EYciTHjKjd
	2JRH0gIqU+tphAEnU0zigoDEvRPWFJ2+K1gLq01B+tmkXpNtmuVfnA5COa51DmSdymj7zplg4CS
	pZZdUUo4ksgzJT9f47/cPhK8aUkSkVbFNMnGCsVncsEUF9lo67qiielOrpSLywBVKzLgKNRG/V7
	1sZQ4qfIxxoE80Wuna9j8wsIIMOWmLKd2QKAWNwtQuVfvXKkvFWSOhA8tLtLLu5aAgGD0rH0hWb
	hOq/pNiPjuM4byBO0b2CfLAgT3a81lIDRkKwzW53rtpyHnQrTibYX+gIgFXkhIQ==
X-Received: by 2002:a17:906:ef0a:b0:b87:b22:f5eb with SMTP id a640c23a62f3a-b87612a48d8mr180863566b.31.1768385286957;
        Wed, 14 Jan 2026 02:08:06 -0800 (PST)
X-Received: by 2002:a17:906:ef0a:b0:b87:b22:f5eb with SMTP id a640c23a62f3a-b87612a48d8mr180858766b.31.1768385286318;
        Wed, 14 Jan 2026 02:08:06 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b871081b04bsm952619866b.53.2026.01.14.02.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 02:08:05 -0800 (PST)
Date: Wed, 14 Jan 2026 11:07:53 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] vsock/test: Add test for a linear and
 non-linear skb getting coalesced
Message-ID: <aWdq75AQZv50CMPQ@sgarzare-redhat>
References: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
 <20260113-vsock-recv-coalescence-v2-2-552b17837cf4@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260113-vsock-recv-coalescence-v2-2-552b17837cf4@rbox.co>

On Tue, Jan 13, 2026 at 04:08:19PM +0100, Michal Luczaj wrote:
>Loopback transport can mangle data in rx queue when a linear skb is
>followed by a small MSG_ZEROCOPY packet.
>
>To exercise the logic, send out two packets: a weirdly sized one (to ensure
>some spare tail room in the skb) and a zerocopy one that's small enough to
>fit in the spare room of its predecessor. Then, wait for both to land in
>the rx queue, and check the data received. Faulty packets merger manifests
>itself by corrupting payload of the later packet.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/vsock_test.c          |  5 +++
> tools/testing/vsock/vsock_test_zerocopy.c | 74 +++++++++++++++++++++++++++++++
> tools/testing/vsock/vsock_test_zerocopy.h |  3 ++
> 3 files changed, 82 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index bbe3723babdc..27e39354499a 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_accepted_setsockopt_client,
> 		.run_server = test_stream_accepted_setsockopt_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM virtio MSG_ZEROCOPY coalescence corruption",
>+		.run_client = test_stream_msgzcopy_mangle_client,
>+		.run_server = test_stream_msgzcopy_mangle_server,
>+	},
> 	{},
> };
>
>diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>index 9d9a6cb9614a..a31ddfc1cd0c 100644
>--- a/tools/testing/vsock/vsock_test_zerocopy.c
>+++ b/tools/testing/vsock/vsock_test_zerocopy.c
>@@ -9,14 +9,18 @@
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
>+#include <sys/ioctl.h>
> #include <sys/mman.h>
> #include <unistd.h>
> #include <poll.h>
> #include <linux/errqueue.h>
> #include <linux/kernel.h>
>+#include <linux/sockios.h>
>+#include <linux/time64.h>
> #include <errno.h>
>
> #include "control.h"
>+#include "timeout.h"
> #include "vsock_test_zerocopy.h"
> #include "msg_zerocopy_common.h"
>
>@@ -356,3 +360,73 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
> 	control_expectln("DONE");
> 	close(fd);
> }
>+
>+#define GOOD_COPY_LEN	128	/* net/vmw_vsock/virtio_transport_common.c */
>+
>+void test_stream_msgzcopy_mangle_client(const struct test_opts *opts)
>+{
>+	char sbuf1[PAGE_SIZE + 1], sbuf2[GOOD_COPY_LEN];
>+	unsigned long hash;
>+	struct pollfd fds;
>+	int fd, i;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	enable_so_zerocopy_check(fd);
>+
>+	memset(sbuf1, 'x', sizeof(sbuf1));
>+	send_buf(fd, sbuf1, sizeof(sbuf1), 0, sizeof(sbuf1));
>+
>+	for (i = 0; i < sizeof(sbuf2); i++)
>+		sbuf2[i] = rand() & 0xff;
>+
>+	send_buf(fd, sbuf2, sizeof(sbuf2), MSG_ZEROCOPY, sizeof(sbuf2));
>+
>+	hash = hash_djb2(sbuf2, sizeof(sbuf2));
>+	control_writeulong(hash);
>+
>+	fds.fd = fd;
>+	fds.events = 0;
>+
>+	if (poll(&fds, 1, TIMEOUT * MSEC_PER_SEC) != 1 ||
>+	    !(fds.revents & POLLERR)) {
>+		perror("poll");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>+
>+void test_stream_msgzcopy_mangle_server(const struct test_opts *opts)
>+{
>+	unsigned long local_hash, remote_hash;
>+	char rbuf[PAGE_SIZE + 1];
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Wait, don't race the (buggy) skbs coalescence. */
>+	vsock_ioctl_int(fd, SIOCINQ, PAGE_SIZE + 1 + GOOD_COPY_LEN);
>+
>+	/* Discard the first packet. */
>+	recv_buf(fd, rbuf, PAGE_SIZE + 1, 0, PAGE_SIZE + 1);
>+
>+	recv_buf(fd, rbuf, GOOD_COPY_LEN, 0, GOOD_COPY_LEN);
>+	remote_hash = control_readulong();
>+	local_hash = hash_djb2(rbuf, GOOD_COPY_LEN);
>+
>+	if (local_hash != remote_hash) {
>+		fprintf(stderr, "Data received corrupted\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	close(fd);
>+}
>diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
>index 3ef2579e024d..d46c91a69f16 100644
>--- a/tools/testing/vsock/vsock_test_zerocopy.h
>+++ b/tools/testing/vsock/vsock_test_zerocopy.h
>@@ -12,4 +12,7 @@ void test_seqpacket_msgzcopy_server(const struct test_opts *opts);
> void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts);
> void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts);
>
>+void test_stream_msgzcopy_mangle_client(const struct test_opts *opts);
>+void test_stream_msgzcopy_mangle_server(const struct test_opts *opts);
>+
> #endif /* VSOCK_TEST_ZEROCOPY_H */
>
>-- 
>2.52.0
>


