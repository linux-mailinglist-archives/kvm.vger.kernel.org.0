Return-Path: <kvm+bounces-40229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E088A5470A
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1041B189398F
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 09:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7AD120C031;
	Thu,  6 Mar 2025 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="1f4Gjbzb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66AA20B80E
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 09:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741255035; cv=none; b=EiwYSOO8FNrDKtHFX9m57JtmB6VkYqCJRzkJCj34+5ZJzhGIo6q7b+hnXVBtCQkbSc1hSPCddc/TbSGPiK86uV9RbDo1BOCmTrjAt8AvmUnu322yCqgchEfHBoC8LsK9C5vnq6CLqnu90FY61VTEZuMZE/eywQHKwhhtWHSC4Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741255035; c=relaxed/simple;
	bh=6JPnLhL8s35dB03n039XAvB3PJPp3xjiscDs8gfFdqE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=j7Iy8bYXMIMeOzDy3GLRZTc/IeQwK7s6AAAURFCSEOWJaItw80Up/Y4FOuQxpzT/r+aF2sq39tWV9gLTA96ld4DL2DIUmBybWblE4FxE3AbRISAtg8PCBG+qeFB0cszKEcn6jc14QVV8kA9fSEUpdfwja90qkhitGpgD7l/wgRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=1f4Gjbzb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223a7065ff8so8886145ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 01:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741255032; x=1741859832; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hY0V7oey/1irsg/oxeJVyzd/IX234qFLR74EBUPiqoM=;
        b=1f4GjbzbUQc2p7rObP8Rffq2hgjmxG5ITm/OnltgmggFk1HeiI5d00OnQ/FuL2k2Iz
         Nh8YEBYAXNdVn//VjatBjYFbzbE1QQjDVJ/HV7bS9fFT9c21xAVJnv9rztsSNfjXBGtb
         Noyz7bxrPpGYFGCCVSf9QkbrekXZBREZYZ9zSD3Xj3wOldG4JEx8dwfT+ThnhBCJfi2v
         7p3iBBJF6UnuMv/7xID6Z9X9OGWyltMqGOwjDT3ynAdbnnK8gc1KarD6KmCJtbEu8q2P
         0vdcHjZNfJGx5yhTI7hBtvdCru9KbRVRjBc5/C1lOdisJOjKoWjds+vieOUjWtaQ2Nrm
         0MSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741255032; x=1741859832;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hY0V7oey/1irsg/oxeJVyzd/IX234qFLR74EBUPiqoM=;
        b=maU6j4ty+s/mIzJHhbhygfiCWVRMAeUc+wZA9LNNgIeeByeYYnyT1dTN8oSSSVef1H
         DF9rT9iyKUMYTR/nleRskWpl9W0ebrMw4T5iJEVgRie+fuV/2P4cyso6jCzqKjCn52eu
         wR6tGmrIU+wTvb/z4WStUWQ7ylxqkI56dEKxK0RhWo2rHHwD44Bi23yEUUgSnVT8kOCt
         ghhpmi8Z90AFSqYjUIgEy4J08MZF/NP1ExJrgF9YjuOlpvzaaQrt0vS/ybtPQ/NGTWgi
         gGhum0kmhSec1d4gSRpo9LY+2cTh3cEcCQQGFltxtRPpEompr57nqcxgI/Ipq33rII13
         8Mqw==
X-Forwarded-Encrypted: i=1; AJvYcCXlm8QBdC5kXRp2AWRmLl7toiOpmUhdW2oBSN1+0V/QSIbjUcvgtejY9IbrArbPOIZDpKE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwivVXmv0dTLO7kUKXQQwusIWNjDfWtxjYuqWknqV9Xk9mQP/Qu
	Rzz7Yb9QUVIDbSseaD994kzmYBZrY/bCBxQoLKXhEhEHsnrMPdx9hz78oStrfP4=
X-Gm-Gg: ASbGnctQ0bI9YiwhpPa1G6p5hnKWF3wYw8elj9lcS+0TuzzfYTGDX50BXH4p9wlSdBL
	4AeJpW2EsGWgmhU3sMVwoPtC6WfoQi8seIRhySKs49pcxlmvM3gPlPR3MS5c8qZI6f+PZPsMUKf
	hghXlru8Y1efjbHiC3zT22XjnXPZWiX1P9jIvqBnOvkltbdVFw45WCzsGT6FCsP7w9gLO15toaf
	a0gPCeRbQPVYULDO1oJpPrnU3TD6D5wIPRwqv8mQ+CgaGsjvc6Z5utevjtgP+audGOXgYxdNzb2
	FwU2f2i5i9oS5zWqxZDnXUL8+cQklHz1YLKxeSRqAmjfF7/l
X-Google-Smtp-Source: AGHT+IGlvJ3QJNQ7zdOmSl6WruunBWchSJlMnXfPdh91/T3HMnxY+JOOEGUyqA7YRqbtPgOIa/y+WA==
X-Received: by 2002:a17:902:ea03:b0:223:f928:4553 with SMTP id d9443c01a7336-223f928486bmr88417775ad.44.1741255032170;
        Thu, 06 Mar 2025 01:57:12 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410a7fc55sm8314515ad.138.2025.03.06.01.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 01:57:11 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 06 Mar 2025 18:56:32 +0900
Subject: [PATCH net-next v8 2/6] net: flow_dissector: Export
 flow_keys_dissector_symmetric
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250306-rss-v8-2-7ab4f56ff423@daynix.com>
References: <20250306-rss-v8-0-7ab4f56ff423@daynix.com>
In-Reply-To: <20250306-rss-v8-0-7ab4f56ff423@daynix.com>
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
X-Mailer: b4 0.14.2

flow_keys_dissector_symmetric is useful to derive a symmetric hash
and to know its source such as IPv4, IPv6, TCP, and UDP.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/net/flow_dissector.h | 1 +
 net/core/flow_dissector.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index ced79dc8e8560e25a4dd567a04f5710b53452b45..d01c1ec77b7d21b17c14b05c47e3cdda39651bec 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -423,6 +423,7 @@ __be32 flow_get_u32_src(const struct flow_keys *flow);
 __be32 flow_get_u32_dst(const struct flow_keys *flow);
 
 extern struct flow_dissector flow_keys_dissector;
+extern struct flow_dissector flow_keys_dissector_symmetric;
 extern struct flow_dissector flow_keys_basic_dissector;
 
 /* struct flow_keys_digest:
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 9cd8de6bebb543c3d672f576e03b29aa86b9d34a..32c7ee31330cf52df05d7a23b3e50d1a1bed9908 100644
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
2.48.1


