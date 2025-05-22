Return-Path: <kvm+bounces-47350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E85AC067D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B1DE4E4A8D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 08:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97EE261589;
	Thu, 22 May 2025 08:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aymg8Yts"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137C2609EE
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901114; cv=none; b=OHhyHsfhtNkiXAZVcCl4gQyML9nSJt1JSyxqFqeZ43NBtdmY8Df/fKMG/1xyyAp56T5TlhgTvGb9bsX+4SpsO7b8Ohy9K0gKi3SMsYhmGGIGHI90rQTxTTxSn1QkABFvqbzTVx4tuuzP+0+ft0CnGAxCopHKkOVsv/ovDvxp4n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901114; c=relaxed/simple;
	bh=wxs7csRE3XeEa2HaCc9AcyuRKeM0KTS4eqAyS8l8t9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1FfIOohmwO3qs/PIRBu7WpcHurqsLRhTI9EnqgOhBx9xnwjeZxgSzwYkLCywmPh6ZapzeMU4RVO5V+yGV9yuGSJCxSVb55wiB9RDoICqXE36ATiOi+QJI/2Zbl8zrA4a1UWCniOoXEwhF0EeS+iwBUmUTRKvoO4cqU5TUeEwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aymg8Yts; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747901111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A2ioWDY4VnaW+8IoK+nfxRztpprRUfPENEYGqc38imY=;
	b=Aymg8YtssMegXch83jypoxYBWRjC81gA+W+2JrCZoH4KB3hmt4t7T3e3tFrvEFoPRZce5A
	dDGrFkNWdja1qgOE/TSa4iu7nZW+5Pgsb8pMswTLd1fhwWBTpLm91IIeoHZfHyMcd/s2Cp
	CqfX20qu0CtXFArtlviRWToClQCVIMw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-615pVpCcN7y_n2Bh6NrOpA-1; Thu, 22 May 2025 04:05:09 -0400
X-MC-Unique: 615pVpCcN7y_n2Bh6NrOpA-1
X-Mimecast-MFC-AGG-ID: 615pVpCcN7y_n2Bh6NrOpA_1747901108
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a36416aef2so2452112f8f.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 01:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901108; x=1748505908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2ioWDY4VnaW+8IoK+nfxRztpprRUfPENEYGqc38imY=;
        b=vXXkX1Tf1f3/Ofgyfy/X/rD+FG+XduQ9idCibnEzUSVtGT3dhqPs1I5c14lG04bRL1
         0C/cs2WFfoPvTGSwZ209+BuVwC61zMlBftyAcQOzzUkFzPk7zUJF7/2XE2LLbmLwKYWw
         bzfj1pORiwJpNWlNhDUrG8ep3iknuDW8ZXXIuMUa/x3W0uRWygaS/XxjATqih7xMMFoe
         YK/S+wAse6ewY9Y4ofa9lCbh6UL8tEVyXLAs7qtg1D/9nBUIytAdh/OvYWSm44KNg4rm
         4097n7MmoNr5wAyRm6xrUDXcktcs556HeejJMWgXlsx/Cw3pt6/Di+nxtDA2IFWsCWBg
         BwVg==
X-Forwarded-Encrypted: i=1; AJvYcCWvJbYjThP4RRyHIMHy7z23fBikdc6t1UTPELuFN3W4g/0/5VJeridEYcOcawYB9/yl++Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlbj8lb8nUm2LZIaTtQ0Tc0B/JJEWXquJYPq1mXwrhBXo8DByG
	8ZUQduU4xsQzRRWQQ5MDJneRonbJbmnBzNNYWMXEuZghbrc8AlvlMvin/asWWu72jdJEVLsnW4o
	KQG4kHOBqSOzz2ejdmdioQkK+5k3YHWfIdVA+wVBI8Qf8bursVfF/Ww==
X-Gm-Gg: ASbGncuiNw4QYyDZrMYkzu6VsgD47w6j/RVdPPAA4rvY3YlrmHy9Y5z/tMw8Vbv67/7
	M1yWvCNOnKRDHd5TtGpn5fYBLv1jqBr2qnXo/0WpBiUuflqKSeI09cpwTz+iPTN1ec9as4xAWEL
	OzqL/P3uqK09zvIhH6nVJrCvcjjUAMoUred2Dz5LsFazhWIzOk+Ta9/0LqVSSPHjoM/oMSJLf8T
	azUY87aseil11XqTL2yloX7NeaCI5U4v74xpujUznkqBwPFBWPjH95ZKCZpw2XJOJhf83904VDC
	wNiqU5S+6skuRQre6hJ6Vw6jySG7gbtKihh0ftDjXlsp4xB8oNdy2YaxVua6
X-Received: by 2002:a5d:5888:0:b0:3a4:7373:7179 with SMTP id ffacd0b85a97d-3a47373741fmr5304193f8f.21.1747901108283;
        Thu, 22 May 2025 01:05:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IET+BoZdLjjXwzK++Hg7tw0FGXknQcCMl4uWniUd2z+PpZjOknS9vNZNNh286EYaTyLr1a3Ag==
X-Received: by 2002:a5d:5888:0:b0:3a4:7373:7179 with SMTP id ffacd0b85a97d-3a47373741fmr5304163f8f.21.1747901107793;
        Thu, 22 May 2025 01:05:07 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca62204sm21800704f8f.42.2025.05.22.01.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:05:07 -0700 (PDT)
Date: Thu, 22 May 2025 10:05:02 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v6 3/5] vsock/test: Introduce vsock_wait_sent()
 helper
Message-ID: <foo7xlczou4dl45qblliqfru4yaglxsudqbaejpnc27ocqmc5x@fdevtzvtdfwb>
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
 <20250522-vsock-linger-v6-3-2ad00b0e447e@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250522-vsock-linger-v6-3-2ad00b0e447e@rbox.co>

On Thu, May 22, 2025 at 01:18:23AM +0200, Michal Luczaj wrote:
>Distill the virtio_vsock_sock::bytes_unsent checking loop (ioctl SIOCOUTQ)
>and move it to utils. Tweak the comment.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/util.c       | 25 +++++++++++++++++++++++++
> tools/testing/vsock/util.h       |  1 +
> tools/testing/vsock/vsock_test.c | 23 ++++++-----------------
> 3 files changed, 32 insertions(+), 17 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index de25892f865f07672da0886be8bd1a429ade8b05..4427d459e199f643d415dfc13e071f21a2e4d6ba 100644
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
>+ * Return false if transport does not implement the unsent_bytes() callback.
>+ */
>+bool vsock_wait_sent(int fd)
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
>+	return !ret;
>+}
>+
> /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> int vsock_bind(unsigned int cid, unsigned int port, int type)
> {
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index d1f765ce3eeeed8f738630846bb47c4f3f6f946f..91f9df12f26a0858777e1a65456f8058544a5f18 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> 			   struct sockaddr_vm *clientaddrp);
> void vsock_wait_remote_close(int fd);
>+bool vsock_wait_sent(int fd);
> void send_buf(int fd, const void *buf, size_t len, int flags,
> 	      ssize_t expected_ret);
> void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret);
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 9ea33b78b9fcb532f4f9616b38b4d2b627b04d31..9d3a77be26f4eb5854629bb1fce08c4ef5485c84 100644
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
>+	if (!vsock_wait_sent(fd))
>+		fprintf(stderr, "Test skipped, SIOCOUTQ not supported.\n");
>+
> 	close(fd);
> }
>
>
>-- 
>2.49.0
>


