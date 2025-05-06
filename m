Return-Path: <kvm+bounces-45580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8D9AAC03F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D011E4650D6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3951D26E159;
	Tue,  6 May 2025 09:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/qR00xV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDCA267733
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524601; cv=none; b=NBNFWIe0C7LrsMjJPZHnVnVfCqzKblIisK1dcrpLq7DK69yc/oVkUzA5CQsyhGiNTF21BIltD03+ZjWZ3o1d2NM6N9zz7g07QFgyHZyrRi2MpI3lmXx34Za/jAnWtev18WB2mRtLCklMvQLuxiS1EwVtNSyyu/IjS4K4DsSgZqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524601; c=relaxed/simple;
	bh=OdYxdf2NS9wIbAV3ovwDZCL2iMe9F3X5Sqi4us7Hjcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAY+528yYyjNzzlR1bc6ImAA5CouAbBYAPyMI7TlW5SMHY1jqa09tnKCwko3kr7oPFIGJgH5rnactCL6dSbwwovB1ex32CFw7HFJiQzODqj9oA7jL1EARy2t8l0MrCmKRZjsbXFq0gc7T66eSpny0S+ro9jiannEXGQkYDX+Gvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/qR00xV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746524597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DXoAgnolhnIWon+GSP4Yh+No5sQktwbAsoZby2qJ9Oc=;
	b=D/qR00xVZfdpDDdDQo+s+cHuoJP0KyHrnVc0hKFgnt3yZCGxO6OFs5cvsMD+sZEIKTpPfZ
	ioUBv04NSLm3IWgfc6ZBBwnnbQF30y/XW9I3xpyZvcK8WSHAZeLi7l7Vmkpdy0oL3swFZ4
	sJLgM4d0CCjDtS5+WiACaTsdWJTF0GM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-pUiZKBaQN8y7WoRGXwmoCw-1; Tue, 06 May 2025 05:43:16 -0400
X-MC-Unique: pUiZKBaQN8y7WoRGXwmoCw-1
X-Mimecast-MFC-AGG-ID: pUiZKBaQN8y7WoRGXwmoCw_1746524595
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acb2fdc6b29so600379566b.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 02:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746524595; x=1747129395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXoAgnolhnIWon+GSP4Yh+No5sQktwbAsoZby2qJ9Oc=;
        b=JeXhEq8+kQf07yiQVPnNMkBzTAecY8r9HJVLdl5i/4APtSVnKt1kNqGUdrQkGrffyJ
         0hLHG1jI9xjzVQhliBQjak0VAz+QpnuNENqhEP803DCR/O59sqOxPW76ORqYC/IzCe/C
         oUpTotQf8mTpXVJELhr/BptVL/Ddi1muJdMjfSJ37ik7qKpKUyk8Y5qz/QKLn5hTHy/1
         ZiT1OwwN/vzzrcYtOdfe0QCYTtIjtUstiV4colNzo/0pUr/h0WveNyJl/H1vOIZc4x0b
         mIPqnkJP0JXufrojwP6WMuoI7S58Rtm3cWtOXPWh6B20P56PYN/lClmnUjnCx+wM6eCJ
         7GwA==
X-Forwarded-Encrypted: i=1; AJvYcCXBwf+s3CI9QiIvwHMSPgFfXnpce1/HB4JQGu6FCbhmmAplblYjocgcMaVF3pex/aFPUnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJTAQ3zCm4fALJB67PYjPKmINK/j/pBL8nqRCVBel0oO2KOhB+
	/FTseydZ4+HUixtnnQvoVaERk3Og1xQhZh/EjcuXQEemwLNW9xGqN48oNtVM47j94mbWQ8vbNRs
	AHq5spMk+gcBaCoBxskbJ86wIFVTLtZbQf3GoGLH6XYyQheyD4A==
X-Gm-Gg: ASbGncuy6GP6CsemWZu5bzE4Vo5O9uas875oW2+7g34Bt5OiR3R8ourPT2yH/VAdyOj
	wav7hhkDcoZkp3Iv4h9DTv4adUQgYyDUPKYKvoEIYB843n4V2eNd7TvfO6xKpsLspo4FftY/Bxp
	j552P1xKMH9cIzGXBrKBjKIOBFktsK5Pa/OTkID0FEN/loFfQXwxP5y7E4C2esppNuG6xsmoGBE
	1EXUtDO5g1uNjDdWMJt/1qu4mli0NULqQ7xuZidAuXfSJbhWp3Tv6rSZCvHPevnAROjH9HdISA+
	YPG3BNsTEDtns/TLxQ==
X-Received: by 2002:a17:907:6eac:b0:ac7:b213:b7e5 with SMTP id a640c23a62f3a-ad1d2ecb11emr249439466b.18.1746524595048;
        Tue, 06 May 2025 02:43:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr2idRnebYQGCDDQ8BywfWXGWGiLs9tHDNaPLdjiBxzUREqjzvsHE6e+fFczVT0Qkx8Sxwyg==
X-Received: by 2002:a17:907:6eac:b0:ac7:b213:b7e5 with SMTP id a640c23a62f3a-ad1d2ecb11emr249435966b.18.1746524594435;
        Tue, 06 May 2025 02:43:14 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.219.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad189540dabsm671051666b.171.2025.05.06.02.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 02:43:13 -0700 (PDT)
Date: Tue, 6 May 2025 11:43:10 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
Message-ID: <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co>

On Thu, May 01, 2025 at 10:05:24AM +0200, Michal Luczaj wrote:
>There was an issue with SO_LINGER: instead of blocking until all queued
>messages for the socket have been successfully sent (or the linger timeout
>has been reached), close() would block until packets were handled by the
>peer.

This is a new behaviour that only new kernels will follow, so I think
it is better to add a new test instead of extending a pre-existing test
that we described as "SOCK_STREAM SO_LINGER null-ptr-deref".

The old test should continue to check the null-ptr-deref also for old
kernels, while the new test will check the new behaviour, so we can skip
the new test while testing an old kernel.

Thanks,
Stefano

>
>Add a check to alert on close() lingering when it should not.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/vsock_test.c | 30 +++++++++++++++++++++++++++---
> 1 file changed, 27 insertions(+), 3 deletions(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index d0f6d253ac72d08a957cb81a3c38fcc72bec5a53..82d0bc20dfa75041f04eada1b4310be2f7c3a0c1 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1788,13 +1788,16 @@ static void test_stream_connect_retry_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+#define	LINGER_TIMEOUT	1	/* seconds */
>+
> static void test_stream_linger_client(const struct test_opts *opts)
> {
> 	struct linger optval = {
> 		.l_onoff = 1,
>-		.l_linger = 1
>+		.l_linger = LINGER_TIMEOUT
> 	};
>-	int fd;
>+	int bytes_unsent, fd;
>+	time_t ts;
>
> 	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
> 	if (fd < 0) {
>@@ -1807,7 +1810,28 @@ static void test_stream_linger_client(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>+	/* Byte left unread to expose any incorrect behaviour. */
>+	send_byte(fd, 1, 0);
>+
>+	/* Reuse LINGER_TIMEOUT to wait for bytes_unsent == 0. */
>+	timeout_begin(LINGER_TIMEOUT);
>+	do {
>+		if (ioctl(fd, SIOCOUTQ, &bytes_unsent) < 0) {
>+			perror("ioctl(SIOCOUTQ)");
>+			exit(EXIT_FAILURE);
>+		}
>+		timeout_check("ioctl(SIOCOUTQ) == 0");
>+	} while (bytes_unsent != 0);
>+	timeout_end();
>+
>+	ts = current_nsec();
> 	close(fd);
>+	if ((current_nsec() - ts) / NSEC_PER_SEC > 0) {
>+		fprintf(stderr, "Unexpected lingering on close()\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("DONE");
> }
>
> static void test_stream_linger_server(const struct test_opts *opts)
>@@ -1820,7 +1844,7 @@ static void test_stream_linger_server(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>-	vsock_wait_remote_close(fd);
>+	control_expectln("DONE");
> 	close(fd);
> }
>
>
>-- 
>2.49.0
>


