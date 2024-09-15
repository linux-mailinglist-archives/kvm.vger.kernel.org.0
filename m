Return-Path: <kvm+bounces-26934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A924C97941B
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 03:20:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC19B1C22162
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 01:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A29E27452;
	Sun, 15 Sep 2024 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="mq0+5bfn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DC29463
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726363173; cv=none; b=W4aqgys00U7qthRFQHxyR5WbpwFgr64P+qLZBWEkpUFGBzlgmXJ78pfZB6ElKfJTVuQbohBl6577l00033pzrhD9054Jw95bZUB05zQ3uyfwB+IIQbD4FAJrbf4+P+rIKIAV0iHuOxjq53hvt1V6TRRkcjfYXJY4o+9v8mehI9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726363173; c=relaxed/simple;
	bh=EuaW4FnQJh+ko9mrbbs5IfkUEDZC4yELYDgRCjRezjQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=VJvkJiNSJ/5hgfqQVTqhsumfgAWNCRpneEKlZXX6RC7IFWI9Bb/h0VJ8zF83O7sjg5xh5d2DQDxu+D5faQR9YZGmaRBynHiOTb7Q+3AQzkndURYm3yn1GwVUz52yggYejLYc6BziW6gihiszfpycKfkSXyY0zZwjKeDSfPsEJy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=mq0+5bfn; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2d89229ac81so2812944a91.0
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 18:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1726363170; x=1726967970; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLyCmT9A4d8YcWvLPa/afO2DGfhZ5JLM/zi5Nn9BJts=;
        b=mq0+5bfnvvTZ644fabHUNc3jCzUJyTBGnGjY4cZ5JYQ52/jIqpQxXFASUFr9GMJJix
         x17kWFvnG+a0CFSVM26mRLv7bf0izTiypXio13+p4hrTZkWTYTRKDFAH31NcAj0R67zt
         4sdoMi09lhyO9vx55wF/jiwzuwD24lMGRO8posEaC8U/aDkYK3E8C40ifBCKx0xtNMGs
         YaQ1VbK/UB3pZwComZKRgiQxV8BTS0T0ftFITGbAIcOqo08x6JK91zSyC1k9DygkEihe
         YNUh3KmCq4FqknHdqFDgMXxZgovuQrhzVDVxP6rUpteESaNKC9giBjQQx9f5a1cPHRgW
         +RKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726363170; x=1726967970;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLyCmT9A4d8YcWvLPa/afO2DGfhZ5JLM/zi5Nn9BJts=;
        b=gvM2FuTW+wYyZnBKLQKbpKjytO6N6j4GkPLOe8s71LadHJKS3xRWCCwwVWdULMXTEG
         4RGMHrBRYAER8AFvRvuMdULz82uFbZHS1liIhLCJEVpuow1/y691EWpdclEvbWMRlLrM
         dtzQmlUpq2R9xYJ/Ik5JBgROSxoM7FR5bNFCFal7IJisV6QyDz5FpFoMkq7uXPM4EV9B
         kCyEZMfGd1Gxz94I8U6xcC9z9O6Ggdl/uypG3U4gKPRiCt80K5age77dRZo43TbNR0bN
         wL4lWirl9Uf8DeY6X08WQkC87we+EM6+Ea+kWz2mhr1aLMOifOiyeOzMIzBotr5O0dSS
         Vj/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWHzYeVXV8wlnmVHGtkDpSJBXl6tGVu2qlr0xWxUJQubAgKKuvTziRbOk5WqEBP+PuNe+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyim1y0bYLFuvc4A8ROvN9Q3HrNhYMw/Nxlnzea9Z43W21DPjRr
	wgELMy8xW/lpO6L7wRysejCQP7320cLDXYi3uHsqVWueqf1yiktxBqJkuN6M9+w=
X-Google-Smtp-Source: AGHT+IF2UHBelhth2+1xufYsoelpTaniIMfonBmxDq1YLHlUWtYufWLhO9HlxpOnLIoogIrzsE5JRA==
X-Received: by 2002:a17:90a:d49:b0:2d4:bf3:428e with SMTP id 98e67ed59e1d1-2dba00659fbmr13985420a91.37.1726363170391;
        Sat, 14 Sep 2024 18:19:30 -0700 (PDT)
Received: from localhost ([210.160.217.68])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2dbcfd252b1sm2217917a91.29.2024.09.14.18.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Sep 2024 18:19:30 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sun, 15 Sep 2024 10:17:44 +0900
Subject: [PATCH RFC v3 5/9] tun: Pad virtio header with zero
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240915-rss-v3-5-c630015db082@daynix.com>
References: <20240915-rss-v3-0-c630015db082@daynix.com>
In-Reply-To: <20240915-rss-v3-0-c630015db082@daynix.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

tun used to simply advance iov_iter when it needs to pad virtio header.
This leaves the garbage in the buffer as is and prevents telling if the
header is padded or contains some real data.

In theory, a user of tun can fill the buffer with zero before calling
read() to avoid such a problem, but leaving the garbage in the buffer is
awkward anyway so fill the buffer in tun.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 1d06c560c5e6..9d93ab9ee58f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2073,7 +2073,7 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 		if (unlikely(copy_to_iter(&gso, sizeof(gso), iter) !=
 			     sizeof(gso)))
 			return -EFAULT;
-		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
+		iov_iter_zero(vnet_hdr_sz - sizeof(gso), iter);
 	}
 
 	ret = copy_to_iter(xdp_frame->data, size, iter) + vnet_hdr_sz;
@@ -2146,7 +2146,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 		if (copy_to_iter(&gso, sizeof(gso), iter) != sizeof(gso))
 			return -EFAULT;
 
-		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
+		iov_iter_zero(vnet_hdr_sz - sizeof(gso), iter);
 	}
 
 	if (vlan_hlen) {

-- 
2.46.0


