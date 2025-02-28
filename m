Return-Path: <kvm+bounces-39658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 636DAA492B5
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:02:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4310E7AA38B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 07:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BA11DE898;
	Fri, 28 Feb 2025 07:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="upbCXgDT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2DD1C1F1F
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 07:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740729555; cv=none; b=HbX05fspasK0g0/J7aXg6JXStzFTOyiq0TyWwKTWSVnqc5r2xOWW336tsW9T6mivIBC3HTLttATgrUqAcDCQvaOU1zFNMdr4pdorulwk1JdhFXFw0UIc+I3hU0s7/dKnCEzRnYW9+lvgyDNE0FGmNUpFAGMNwZsq7OyrJ/+WR14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740729555; c=relaxed/simple;
	bh=6JPnLhL8s35dB03n039XAvB3PJPp3xjiscDs8gfFdqE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=bkPCMowPC/Y4JL/3WNI6ftY1a4hzpUwW4zhKEHntzUSWzidCzJ/QlbtC8PKIfxpGak2AcfBPEqdTI13ulK8tRxc5wl5HmlK5YIE+cnOxxLjT0f7xdlZNTL8LyMAbO4cWPWheaXlMsoOzD0PcbNW2hsd2Rm5p+0ya/5GpPHPmAhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=upbCXgDT; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2234bec7192so48081745ad.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 23:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1740729554; x=1741334354; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hY0V7oey/1irsg/oxeJVyzd/IX234qFLR74EBUPiqoM=;
        b=upbCXgDTP3jqAxSxFR5FQGqaOOBHbmAbOZCYoWeCdICddCJGAHPWV1HIB7v0kTkNSr
         83qScXZZY+31RojPTeGtTwtVLURPvfvvFJ2zKftrbQE/0LqjMo9U7LPASggjQtxwxuT0
         8YsOwxn/E1rfQpdwltIVbXO7X77EaEq8M2tQUsEquljGOfP5PzVhcutZjgBEepFjaYWS
         BjkXbpMWkyDcAUe1hPQLvqxGCk6EVO6VduygeFqvIlS1kS3Jieq8nphWftrlwGKIfgbX
         6ajth9YiJ0F7fT+i8KaomPfSaKV2MPDnwQnjh2TLjWOZs1GYYJ8EkSfj6hZY6+Z7NxXG
         tUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740729554; x=1741334354;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hY0V7oey/1irsg/oxeJVyzd/IX234qFLR74EBUPiqoM=;
        b=w07xooqFyByrHK3SIL8vw/ku/lYsElpXswkek3CVE0PIom/WjzLPAjJvOBwmRqArS9
         Ijxr03HR6/SCQrPL1nNvzdi79jnaEs4xG86Xg8GAli91lv/BpWPtg6XZNIm5D/nNrtlS
         w3uA+yvHK5CAbll11MiMhMYT9bR1b9vKJfJDusG+jCI+BILi2BoyRqlE4uSt7L2TkSH/
         PViO0ue4rC+BiQ+BPsy4UA2OltoLvWi9dR0bLSRWTaI+PQux97wCK9pF2xIn4p6WkcRV
         gqtUikv3w1UyMUAoY35Glb0CH5ZsqP1Q9Rk3x+9qClB7JHXziLNI4H0ABS9rYToj430I
         an1A==
X-Forwarded-Encrypted: i=1; AJvYcCWcZIxDLrSEg0ZBgibbvrVm+MAsMYdmZBqkDZFTSPK4MWk6gKYMrGUg0Y/jhTETbwNDSjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8PJUA0Ul03BqWhaQlXSNlAQAsD8nCDrgagvWfrwn7EdT5JRkj
	yUdD5NWy/JXGMeDh+gV5lRmqa4OxAZ69FnG3qUoRJ8mcbuGhASMz2QI2svFMrss=
X-Gm-Gg: ASbGncuxDOKuYfgzV2wYvK7jcFdMYHRow5ueCdkt11szNNlFw0DI2dJt1r0ayb0+9lg
	JCw5sGosX1RytnJRd3SUtLvqVpZknKc6BYVwH0WK7fcBfYpSfVcUdA+xnlHEHR5sF9QvWrpOEDX
	MnBudbCYgE0GLyJKL73LO+yviV+bxjtwdryCn2iJpA58cmkIQursULmy8Dv9TN+MlChxdAC8ltU
	aU4SjwSePVxlIy+CWUQCmFMYh2ysN7+nkxSXA7UmwNps8CwxYSik5M9tBrOruuAa4ax66Md/bbk
	WphYW1KucxH25boZvjNYiXK2+u+ahA==
X-Google-Smtp-Source: AGHT+IFWTUEIr1u8c10m45czztBToHuvUxMVabSMAgvvIo/y/63jq+3tXupc/0FfOTFltv8uY5F7yQ==
X-Received: by 2002:a17:902:ecd0:b0:220:f030:376b with SMTP id d9443c01a7336-22368f91ed0mr42335305ad.21.1740729553732;
        Thu, 27 Feb 2025 23:59:13 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-223504c5bfesm27643365ad.131.2025.02.27.23.59.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 23:59:13 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 28 Feb 2025 16:58:48 +0900
Subject: [PATCH net-next v7 2/6] net: flow_dissector: Export
 flow_keys_dissector_symmetric
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250228-rss-v7-2-844205cbbdd6@daynix.com>
References: <20250228-rss-v7-0-844205cbbdd6@daynix.com>
In-Reply-To: <20250228-rss-v7-0-844205cbbdd6@daynix.com>
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
 Lei Yang <leiyang@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
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


