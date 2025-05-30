Return-Path: <kvm+bounces-48069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3B2AC8773
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D810B4A6E8D
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 04:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E0A20CCD0;
	Fri, 30 May 2025 04:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="p0jMeCwR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1289B1E9905
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748580637; cv=none; b=m+iSpfAxTIPpjnGk1/m5m4gyyCg9UIm3O12FTGqnpVnyRAec/hLdODWfJ/BwiK1SOS+BdVPG2KGwAiPuZr0uZGY3CbCFBw/r5DgPpFgqJ3zTbzf9TCe96Hjg73RO05691siM0DdvRKZJj61htV2qiHENQRK3Vd13dI64BCFFUO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748580637; c=relaxed/simple;
	bh=2oUMDnIBYoOmxLZqcn3thZSyZ/SbegpNqOzQC+cCzEg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=PBJk0YFuIzF1l8ZhzJUFHBi+BZ770GMgAxjx+/vBVJtBFvhKO3i0KBBJXCA9q65a+Xo5V9ymZSoYoJMbE9Bx6ZcDdxDedmTAtd3tn338xzTHgqAHQSPZamxopaT5aV4IFB3FCmFoEudkHInc8ZoldNzk4JQJK8Ogvj6uWckpw+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=p0jMeCwR; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c9907967so1697145b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1748580635; x=1749185435; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RTqe1YGUMZdFRvXBjnIPkdBxtf7RTeZ/o279FoAQM6o=;
        b=p0jMeCwRTCl3QbpKCZ0PeAx4iBbKOypHeipYJ1LbfO5JLAbEZH7aXtAZI4aV4tPGs0
         AGujK3Dx23/n/XtwrMEFpH+Cvg5VWG9OrmMDsldqPzqEN/8i/EZKWu1Vta75nj8BUq3V
         g2DEZoI15jzk2MOqK7mMoJVEf+aev6sa2KsOlBi+xuVf7lhm7FdzoycMqLMsRzWojcZU
         Oeo7hFtAGGlQNIYuNurIAVyHXawBLnnNpvaLQyFrCbP5tF3KLQiFWSHZiK4I/YRa5XDw
         Qe0AFjJPjzZicbMyddnsG85mDrb2o2pOrEeewQ/kCHnsx3oN9x5F7oq7vPtsYfIUu968
         9BAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748580635; x=1749185435;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RTqe1YGUMZdFRvXBjnIPkdBxtf7RTeZ/o279FoAQM6o=;
        b=NkPrmNPqVJhd2jjd/mD8/zqX/RJOei4WOwncJlWxRNvjDBTJrC2Ayfk7VKt1SqgNMQ
         UUvZJjpu4w66Tr7SYtaXhF3arBh4Ps0KYbwqDbhsFDE33o11PKkdTr9NSKB/kdE4H4YT
         2071Hedta0Q5utgePpGZfk7uJGBBl/EO6GK4/s5kaLCBWWvTdH6W/A9tAjB1fBNNpU88
         v3fEuQKWRu/wPNNm7vU3z/eXrEjsWns+tIyjEQ844cFl+P9HFcX6IDnIZgQmVsKmOfoF
         +RAfGvNO7xpvzCqhU5eiFyrJBKWnCczQCpkWtk+OyxGO6Lv9x1/UmaKiazZkUqiwkZ6s
         i6kw==
X-Forwarded-Encrypted: i=1; AJvYcCVDylgT0VbVB3FFkDFM+0ygE79l/bAWAHroHOP/8f1eF9d16SAVsE8aY6TXqbwA1kPN9To=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL9j1+ZpSuTukJPJgtQ0Mn8aNh92BGfQo9ZW85XD/kVM+nLB2o
	rS9UdIGwYqOCkvWlBCMQsTfUGLaQxQW3vPbI+a9GsgUAOWFs6ZMeTF58icx93/KyYlc=
X-Gm-Gg: ASbGncvVbtN1xBWT3T4OGfgs1FmSYjS2EWUDAmMD+IX1T46I78SbQNzZcW4tpAjnyzp
	TVXM/0qnHKfJNKmMA0TRKwCdA4l8mxp/RjNyT2ijVfDJQNxNNRqy0eONPfifV6EPAGiPVSH/8HE
	WERahOapMeyZcx6VeFKiDzpAxj7ZlZFD5MOxsI2fP/zsEH1tTGg89DaXcmsq8vHoz6w4m26HW8G
	goFdLwLTH4NDAQc+oGX2rhwCPnGoueUTUU6tfGwXAKQ0JeTYpQAg+Lb7+z9zbw205g3czELvZcX
	t1OhyFG2DXbRZPki7sGyhAfWMqRyt1KwBcg5R2fSBx3QOihwy9yNMb8mKSLIIQo=
X-Google-Smtp-Source: AGHT+IECFVZeba3N9ihXZ5rbjNszUdlvoohjDNehjvfvwHvZL080L1tWJfpWoXRRwXkMbrFpkWtKqw==
X-Received: by 2002:a05:6a00:4b54:b0:736:5e6f:295b with SMTP id d2e1a72fcca58-747bd97b301mr2912852b3a.12.1748580635197;
        Thu, 29 May 2025 21:50:35 -0700 (PDT)
Received: from localhost ([157.82.128.1])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747afeab6bdsm2179867b3a.37.2025.05.29.21.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 May 2025 21:50:34 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 30 May 2025 13:50:06 +0900
Subject: [PATCH net-next v12 02/10] net: flow_dissector: Export
 flow_keys_dissector_symmetric
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250530-rss-v12-2-95d8b348de91@daynix.com>
References: <20250530-rss-v12-0-95d8b348de91@daynix.com>
In-Reply-To: <20250530-rss-v12-0-95d8b348de91@daynix.com>
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
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

flow_keys_dissector_symmetric is useful to derive a symmetric hash
and to know its source such as IPv4, IPv6, TCP, and UDP.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Lei Yang <leiyang@redhat.com>
---
 include/net/flow_dissector.h | 1 +
 net/core/flow_dissector.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ced79dc8e856..d01c1ec77b7d 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -423,6 +423,7 @@ __be32 flow_get_u32_src(const struct flow_keys *flow);
 __be32 flow_get_u32_dst(const struct flow_keys *flow);
 
 extern struct flow_dissector flow_keys_dissector;
+extern struct flow_dissector flow_keys_dissector_symmetric;
 extern struct flow_dissector flow_keys_basic_dissector;
 
 /* struct flow_keys_digest:
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 9cd8de6bebb5..32c7ee31330c 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1862,7 +1862,8 @@ void make_flow_keys_digest(struct flow_keys_digest *digest,
 }
 EXPORT_SYMBOL(make_flow_keys_digest);
 
-static struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
+struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
+EXPORT_SYMBOL(flow_keys_dissector_symmetric);
 
 u32 __skb_get_hash_symmetric_net(const struct net *net, const struct sk_buff *skb)
 {

-- 
2.49.0


