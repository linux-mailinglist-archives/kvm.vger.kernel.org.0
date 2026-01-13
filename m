Return-Path: <kvm+bounces-67895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EE431D166D3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 04:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C79743011442
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 03:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99400315767;
	Tue, 13 Jan 2026 03:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNf5jAgS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB16930F815
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 03:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768273982; cv=none; b=Uz+HnhLLBxTFrvgzvi44E/NgSt6S2WEWRsaCRIBUGJsmRPueGLkXOh6fYDUC5Sh8/tr4JVbFafMRCpYtBdAfKhHHSwBYPaVUqAan+l87X8j6evgOGwkqYQZjqvr9/eYEV7vK4PR+HjZQGtgJVq252RYbGcRVoQM7fAfz88xEh3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768273982; c=relaxed/simple;
	bh=8kT9Sce1CZrAgVQ7vnNZA70o4fM254DKC0wfkmWzB90=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uSGJMGi5uC8hL7i2BecFP3m2h3/9ZUUIpZd3fzOrsJKTv4+um88cHnTwWwUF89IQs2YC4pJZWLa16X/6/+XHVD84s09nk6ye0JGOTCx1LVlZzlAOzXwnC1Jlcg0qDqwoNkCD1hUYMoIXVWfLTJeczUfwmRhnLECNoimklXUHrQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNf5jAgS; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-78fc0f33998so70655637b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 19:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768273980; x=1768878780; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uP5dCmGJx/cfUOeiPby/DoTXnEYYyl2lr0FiheN3O+M=;
        b=kNf5jAgSfyX83zzdIsjOmR0MpWpvZAPS3A6ymeDkmMlJLH+GYer+D1vPm+Sb9M8/Ky
         Kxaemr6+MEPEybdfLaAEaJt06RaLvSdZpnbfQBlFD4zb1JfA9GAbru597Y++tW1jUWi9
         iQKsofYC23fgZsAmzW4P/m/9ts+byCXIxLPctBzRPVOVO2/naIEUjhlTKwB4pauE18Uw
         U0MKanpcuxsfZHHTmTNetDFspfmXJDrAuwK0+eP/Amn5QR2AW0Tl4+iY9v3W7qZA2hwX
         Wrf8uKvIsOlxj/VpeKSCfO+uzwUmAKcMXlQccJ4YkVJKTtw8OIwUrOxYizFZ99mRkWls
         R2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768273980; x=1768878780;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uP5dCmGJx/cfUOeiPby/DoTXnEYYyl2lr0FiheN3O+M=;
        b=JPjgk0xlbXTEW7QQ0KfNlebHKCbIkXbvaed+sVj3rqDLb1NgrfU5d4E3aO8jaIs+vr
         5q7/JaAe0T3L81RXKNvZfSl/gR+ltVar9k11ilD4B3vsjre2j52y3bUQV4swo25GTRTp
         h4I5c0613zrou6XVbhMh6r2OdXGuK6NGLBRnJ+ydHr0d/+7Ze+eSbXUGa1mmSDxL9YMp
         CzNnqhJNs7o5rdyfU3c1uWNugXUPEd58vthgt57TBZszHU/Pu4ushaQC4VFVwb1rxl16
         cucpatTvpIei+WmB1qambR0aHuay4bCgXDNKF5f7oN0j3JwZbnZYVCB0mCZFAOHXWGTs
         VpnA==
X-Forwarded-Encrypted: i=1; AJvYcCUJKZy28Q5HdnWGYPoJS1dL/xzrT3kdlMOrTmqmPRxvqNhyHBasAHoDhVGob5BJEpWWa6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZc6vm+Rge/Z0xy6msAQZ89P1gYASBNZBGI5mvivwkcuCB1FKp
	5x7FqdzqeN+Kb59aOi30O8RNWkjOllYuWpRKT1HuN2BwN9MsQkFTVrsl
X-Gm-Gg: AY/fxX77hAhwM9Rj8GCXGoeOe+4O2BMYYXc8B8BG9GEGSOdpu0jPN2wN67D7jPxlBNw
	/AJ7TAA6wVsgqEJU+xvOo0lEuJQX/OLilsrRLBMWUCdqkoxj8P2jeKy8ipGVheMArOFfUsasAE3
	wOI70R2BIZeGucLP+3PJsMiVrt64dZM0tMsxTVa3SFQAl2w5kjycVRmr1Nipre0wTl2zcp6V8Kd
	2dDkVhnEo/FM5T3xjQg6At4a7IgwJzRdO7EEnACm4qfQXmb3Ket3sZKETtHXBZw/vKxLzvM+9kn
	yfb/VjGcIc4LzksRUvTfqma/vBf+CnYkdaMtvp1epZZUbVKxzxqSUzStQdxpeqFoXv4qpSUOBU2
	sO8kIeK/VRN0KHAnC4cCXCSHqvZu3zTurwsOjygKlS2z1MsLTSCvwL94D2g+INGN7X7m3YUPhEA
	CLxYJDIbSlTg==
X-Google-Smtp-Source: AGHT+IEb6SZC7b3qvFJYt3k7Bek7L59Xocc4oQtKoQnzhDn4qYGn5XzM6bedIh0Pal8eLsRvCLYfaw==
X-Received: by 2002:a05:690c:9c0c:b0:787:e3c0:f61f with SMTP id 00721157ae682-790b5834fe3mr369495447b3.57.1768273979828;
        Mon, 12 Jan 2026 19:12:59 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d8c52b3sm8800897d50.25.2026.01.12.19.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 19:12:59 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 12 Jan 2026 19:11:13 -0800
Subject: [PATCH net-next v14 04/12] selftests/vsock: increase timeout to
 1200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-vsock-vmtest-v14-4-a5c332db3e2b@meta.com>
References: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
In-Reply-To: <20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Increase the timeout from 300s to 1200s. On a modern bare metal server
my last run showed the new set of tests taking ~400s. Multiply by an
(arbitrary) factor of three to account for slower/nested runners.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vsock/settings b/tools/testing/selftests/vsock/settings
index 694d70710ff0..79b65bdf05db 100644
--- a/tools/testing/selftests/vsock/settings
+++ b/tools/testing/selftests/vsock/settings
@@ -1 +1 @@
-timeout=300
+timeout=1200

-- 
2.47.3


