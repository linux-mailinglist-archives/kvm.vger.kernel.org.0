Return-Path: <kvm+bounces-28103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE13C994003
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 09:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 163AF1C24B33
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 07:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82621E572E;
	Tue,  8 Oct 2024 06:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="wmq6yPXP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B121E5706
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 06:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728370496; cv=none; b=IDU1AS28iZ/ncrkBAIcEiqRQGPq4R+9q5E4GIpbocWtwyNa1o3Frvho9DyUjYwwpwTH8apVWrgyFxbpCRTFOYC4cjm617bu/nGEw6bMjw47fh53E0hcYbLv/vNcBU0hXblrZI1RsEWJUNXXvJ5UzlfICd9OfZRSLf+i5Ld+McGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728370496; c=relaxed/simple;
	bh=GX7xNNedqmkBNoygMLXRBk8YNW8TUTKj2IdIaUHcsB0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=NgGVE9NxZCf4mJtHjPoqVKIArZDkFx0xAuZOZxZ9qKqG9CWT4Vt20Y7jfM0nCN0rpUiII7rdAxhR0R/cgFi+jb10PdFM8MJ8IZr86EI96H2S/ZOQCCHDzr1/7aGcP0ONqtND7eUKbiB7onznXmidUScOUMv5nwlsw7VBeeygjgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=wmq6yPXP; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20bcae5e482so45799525ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 23:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1728370494; x=1728975294; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61I8UVOx3KOO+grmBS2eNs+UXuu5q7xipsiBLUyhIxU=;
        b=wmq6yPXPRSEqM/tb9PmlS7HIcPpfk09lCAmS7zkuhDFvwK8g9X6m0ELFp3dfr0zFg5
         zyY3LOgttb+uAc6Mk5/DRLNHJBMUggPu0S6r1pVfWkPuS9nWad3i1RWSV9XOPn8qRT3P
         7SVhYEqtofujNQBA8ou7sbHrfcQrzTQERXORKzZixdjQM15LEpAYIbPLb9ujKGR/2EjG
         5dw4OjchKgxVOgdWP4o8xnMYMBuzK5KVWRWd3FY7BsAf5i5HR7AIf7WrRsaKomGp+3KT
         I2mVqZwVqdJybMlmUUNlQn3FXAb0BR0AnUBng6sXQMMvde7ICR2yVJkuHw0afL6mx246
         yYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728370494; x=1728975294;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61I8UVOx3KOO+grmBS2eNs+UXuu5q7xipsiBLUyhIxU=;
        b=SqWJD06zF/AptiGA3nFT7cWvd0ple8075EfG8eJg8W9bg8LGJYSTuQAdsS4jpiTI1d
         frJVlx8ZPLgUIapbmpc8SsXEZsc9+UErAaVrP1EPgcMrcTDWQv+Jzla5mZUMAJl8PNM/
         DKti9YF0ddOX7v9O+GkgR/WkqZLhdkNjxF6ochnY9e8MlcKPR6N2jVao+z5AU4s8tUJp
         TQ0Co4SZ8aEjRcMFb5+WZlQLQqbvWlU3sqa1gKpANyGOclgOrXNXi5ZAKlCq3J8D2n2U
         QY5Fsq2eqNrEoPHVbrK+OF3lnOPDgeYSQkgii4rpr10QegwqeXqKgzoso9K7i1x8oPtj
         7sRg==
X-Forwarded-Encrypted: i=1; AJvYcCVBjts54tfdBfG5yfFq39stMPyBJt3+oWCSSSqY51WBX0KRgZIrUVZgUn2pvzNB6aIzpjw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx99SjhQNxkrRXSut5H0kg4bo/ZTRGcVFQSqTCv0n58tIMhq0g
	IhKAHuwTVIOWZLG9euA1A91Qlk1Aqucpfy3CDdTqFCSbv71sSD2KjuOtlb9yHhM=
X-Google-Smtp-Source: AGHT+IFQle2yzzR4dcGGT4YtYzeAeqeN1k82tWPpuGYLK1pMOd+gx8+tY2XKUq2OjAmapp2a+BI3iw==
X-Received: by 2002:a17:903:32c7:b0:20b:987b:e3a0 with SMTP id d9443c01a7336-20bfea56b19mr207151025ad.30.1728370494237;
        Mon, 07 Oct 2024 23:54:54 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-20c139a2bbbsm49777315ad.294.2024.10.07.23.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 23:54:53 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 08 Oct 2024 15:54:23 +0900
Subject: [PATCH RFC v5 03/10] net: flow_dissector: Export
 flow_keys_dissector_symmetric
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241008-rss-v5-3-f3cf68df005d@daynix.com>
References: <20241008-rss-v5-0-f3cf68df005d@daynix.com>
In-Reply-To: <20241008-rss-v5-0-f3cf68df005d@daynix.com>
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
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

flow_keys_dissector_symmetric is useful to derive a symmetric hash
and to know its source such as IPv4, IPv6, TCP, and UDP.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
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
index 0e638a37aa09..9822988f2d49 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1852,7 +1852,8 @@ void make_flow_keys_digest(struct flow_keys_digest *digest,
 }
 EXPORT_SYMBOL(make_flow_keys_digest);
 
-static struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
+struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
+EXPORT_SYMBOL(flow_keys_dissector_symmetric);
 
 u32 __skb_get_hash_symmetric_net(const struct net *net, const struct sk_buff *skb)
 {

-- 
2.46.2


