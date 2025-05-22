Return-Path: <kvm+bounces-47351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB7AAC0683
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79F073AD28D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 08:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1140B2620C9;
	Thu, 22 May 2025 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LI6bwfy9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CF8261580
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901136; cv=none; b=bugF8iZ6dovidxetZKPS/xVkpna58aqXJzZhgBDcUD7wEjCxsg663ykKZJK/MEnqAAH/wrAeq0VlBkkQc6PB3mME4RtmdzzNC0To0bXQCiHA2wYmVfO/SmqqNP8b8kuXZNlURKJM/AFxaPh6oRFEeXWVoHes32ZR+rN1f240RS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901136; c=relaxed/simple;
	bh=XB1DMlWvcWPFzBP+Imok5+hdMej12hjrOWoDR2YlK1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToPETyGZtdmWsioCJcHntIR5DLDAB8VPOQCknmu8LdJrg8VkctZ5PitkdsvzaLB8DY8OwPfqf+PMD7cPW0SaOwSbfIFQ3EaNgCQS//SZbHVEf+pzj6AbGOY2inqor2sFEyag+CuGkE9N78GHoEznc0Tu6k0bPz2bkmeYO2LcN7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LI6bwfy9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747901133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7k5iTkA7yVBLFLMB+U1JSV+k17S5HvwfFdvLDBIgyTc=;
	b=LI6bwfy9f04rDvcn20p/leJGOJ8zvh/h2J90WiLQf6m4Mpbe0v5tHUGrfESfTNHtfGBcHc
	4KR5c4rjgfzAc6QPbE6Ucz6gInH4SeM8KtqyyI87ozfKzpI3DoVIbHDOgjcLqO3HnZfN8u
	6WASutCzzgP00VOoYiTvkPfw7NmO8cc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-Nbrk1Q5BPvmC8ZMO_7M-vg-1; Thu, 22 May 2025 04:05:29 -0400
X-MC-Unique: Nbrk1Q5BPvmC8ZMO_7M-vg-1
X-Mimecast-MFC-AGG-ID: Nbrk1Q5BPvmC8ZMO_7M-vg_1747901129
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so41481215e9.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 01:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901129; x=1748505929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7k5iTkA7yVBLFLMB+U1JSV+k17S5HvwfFdvLDBIgyTc=;
        b=vFTE8/1VpZ64E57QCwlI6wDr2v3P2orHXkmn9t7PaZzRUZHHXETwJS1hr2TX+AYPSY
         RQjOP9t0fcb/qpXwLRqjXEeEfzlhnMCP0MBtJaBw+fzyGswK7awIkzedyZaMAxhvms/p
         PaZcc5HG37TmDI0Zt99Skq7eYq638LDW1BOlkpIbGy4zOmB9YtFZO96+itHCD+aYI2L9
         M8smMlLZDx4b6GkdBjiRhKhE1QgVPCgziuIBVZGftcHEUvUQp/Y0DxGeSH9wp7T9kWxx
         S9xFtVkAklAU5ZkygNi0tgfiYw2Q/1VoiSdj55RFcztIdYbGz7aF2SQTX/8dcAPoOqM+
         QEbw==
X-Forwarded-Encrypted: i=1; AJvYcCW5q/DLt9xty8B4Maah8TUu9Fcg76VMxCxwpMboCKeT7n00UtHKDRy3tg8yJSJPJJ1+Td4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxX0SJ6XiE3NZmwfhrj24yZ9CH4uc0QdATcOg83AELUnXMMQPu
	fhg0R5P9co+tvdERXNIjeXXJPWxJylLqNwBY4F36UbPm81B7fmmYdj6xmqZ8a8sG66L0xwCbS7W
	VYp49W+JtYS4npyKi/HdbELnLvzi18b7nsfSxZ0urAgzqb86Pmw9j6w==
X-Gm-Gg: ASbGncsd9L2zMI0lH6nkzURX3gCnpORNzkocjtDtqcSu4AiTA/KOYetBker/zNUZ/HE
	7ShSlVxmJ4dUllbbWEVjqtLrnCsiuWonyenEjSmlxn0/sH+JWjQJefmE7E6g83JihYv6HkEmjYQ
	tCienh1FeYsBt/UJZAKdObHhNne94pPZj6ZcvxEAjwBi1b+L8LB8+s+Db0UuWQ38jPtkBhA7AL5
	VEwYRibOogvQDHtvqXYTo5xQvIvBhuGbutM5EIJa42oPmDygQXO6Qh4osRv9SYfAP/K05RBmQbe
	lNec+6YEL343fAI2MKAoYURv2peWsHNlHC3m3w1RQaXi7oFcQY7KDKnlY+VC
X-Received: by 2002:a05:600c:821b:b0:43b:bfa7:c7d with SMTP id 5b1f17b1804b1-442f84c2008mr257388745e9.2.1747901128584;
        Thu, 22 May 2025 01:05:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOJr/dg0WH1mCD/vKgYtxTFY+fPT/s3TzPpEZ0P+tVyaywIvhuNO5rWcBUW3o5S0oEleDuOw==
X-Received: by 2002:a05:600c:821b:b0:43b:bfa7:c7d with SMTP id 5b1f17b1804b1-442f84c2008mr257388275e9.2.1747901128132;
        Thu, 22 May 2025 01:05:28 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442ebd46aa4sm203871645e9.1.2025.05.22.01.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:05:27 -0700 (PDT)
Date: Thu, 22 May 2025 10:05:25 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v6 4/5] vsock/test: Introduce enable_so_linger()
 helper
Message-ID: <hzkiu4tq7bxucsvjtc6pz2mkm2eoeoeqcygjtykuuo2jcfnbpv@2blkh2sdcp27>
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
 <20250522-vsock-linger-v6-4-2ad00b0e447e@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250522-vsock-linger-v6-4-2ad00b0e447e@rbox.co>

On Thu, May 22, 2025 at 01:18:24AM +0200, Michal Luczaj wrote:
>Add a helper function that sets SO_LINGER. Adapt the caller.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> tools/testing/vsock/util.c       | 13 +++++++++++++
> tools/testing/vsock/util.h       |  1 +
> tools/testing/vsock/vsock_test.c | 10 +---------
> 3 files changed, 15 insertions(+), 9 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 4427d459e199f643d415dfc13e071f21a2e4d6ba..0c7e9cbcbc85cde9c8764fc3bb623cde2f6c77a6 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -823,3 +823,16 @@ void enable_so_zerocopy_check(int fd)
> 	setsockopt_int_check(fd, SOL_SOCKET, SO_ZEROCOPY, 1,
> 			     "setsockopt SO_ZEROCOPY");
> }
>+
>+void enable_so_linger(int fd, int timeout)
>+{
>+	struct linger optval = {
>+		.l_onoff = 1,
>+		.l_linger = timeout
>+	};
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_LINGER, &optval, sizeof(optval))) {
>+		perror("setsockopt(SO_LINGER)");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index 91f9df12f26a0858777e1a65456f8058544a5f18..5e2db67072d5053804a9bb93934b625ea78bcd7a 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -80,4 +80,5 @@ void setsockopt_int_check(int fd, int level, int optname, int val,
> void setsockopt_timeval_check(int fd, int level, int optname,
> 			      struct timeval val, char const *errmsg);
> void enable_so_zerocopy_check(int fd);
>+void enable_so_linger(int fd, int timeout);
> #endif /* UTIL_H */
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 9d3a77be26f4eb5854629bb1fce08c4ef5485c84..b3258d6ba21a5f51cf4791514854bb40451399a9 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -1813,10 +1813,6 @@ static void test_stream_connect_retry_server(const struct test_opts *opts)
>
> static void test_stream_linger_client(const struct test_opts *opts)
> {
>-	struct linger optval = {
>-		.l_onoff = 1,
>-		.l_linger = 1
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
>+	enable_so_linger(fd, 1);
> 	close(fd);
> }
>
>
>-- 
>2.49.0
>


