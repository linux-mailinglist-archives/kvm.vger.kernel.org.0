Return-Path: <kvm+bounces-26930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B48C6979402
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 03:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BEB2283C15
	for <lists+kvm@lfdr.de>; Sun, 15 Sep 2024 01:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738B3175AD;
	Sun, 15 Sep 2024 01:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="GwmGf7yo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B549812B93
	for <kvm@vger.kernel.org>; Sun, 15 Sep 2024 01:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726363102; cv=none; b=IUwMX0rKap9n4wAQJhF+cGu+eTtnYHC6zhTIgc/aeBdNC8nJhwqv0Q5ggCgMzfoU3vBGCSeKKQNieI1yEuNq5KFnDVOft/T+qVB4PIfQJCGPnIMk55uKPzivagSYJgD/975RX5VAjR/R2g/0h9TlIxyUnVoWY2+OjRlyLA9LLME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726363102; c=relaxed/simple;
	bh=lLUNpbHX/GXFiFtHpw12GxrI7YDiHIJJxc3/RYWJl4c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=dK1PFnjxSAelDzCCFUMA6+z/o9USh6/UnFFzBBRwKGcdf3L9Mb4UBC8pGLMYp2gpPa7he+95xPnZOHuqymuwQVndlJwSNs8Y0rCJfdIwtJKtWO9JaiIKQmrrG66aJOyxLPVMbiuZkgbkR1KQf3Tw7S3x+jLOEUMvYRk3HAsMbV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=GwmGf7yo; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2d877dab61fso1506440a91.3
        for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 18:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1726363100; x=1726967900; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2yA9Gcv+7jpsWFyFoetAxKnXy2lsD/ZqoQ1BDUECczE=;
        b=GwmGf7yolMXwfnvj0bsI5pyhTjXCWp404TbNNTP5BM28Wp2ZwP5UbMxoPZn7TTugev
         nkyJ3MAvfaOxIv7O5viBtHN156WIt7YZghSquf0AKZvh3opDdrEzQapdfm1RmU+eRGth
         6rqWjIBhJa+HSCb+oBbbJR0D8svwfM1AkM4w8T2rX/6VHYVdA12jh3JAwrMRskJZMgxL
         wGtXd7zR9eydaaDgm+eSXdwquGua3jqH9DJf6j+x1TRKAzV3ri0pM55516i1VEotwha+
         Y9iVVX2Jk3chEmSShnnHM81QHK3sBtgg7OZBHvI4cPdGP5wvrppgM0nAgaCSkTCbIC7P
         bP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726363100; x=1726967900;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yA9Gcv+7jpsWFyFoetAxKnXy2lsD/ZqoQ1BDUECczE=;
        b=nIb4XswDKVNmV+RLFi/KTLzbnidOW3Cx8fVGO/3aPtV1nYFZlXe5pjDUGxs9147jrV
         54PKq4cefWe3GtpQnkAaBxpZIRoF8WqWlZSyHRuwG7UMREz0OY1b2nuvwOzIxPMc1ZfV
         PjD+iUQfUxYd9TkTZS7+DRcTE1yDJp3vYjhc5KREarl/TiYFAF7GD0sVNcidAXcZIr7e
         GjA8WNt7yi6uvl7WLEHkwtEj4TTvkZJ5F8/VBUzV+smYoVSEO9SDMjI6IGFCRSk2JMIB
         nuf/RVXIAl+Vt1IK1XcOJz6u6/J0jyQ8MG1kkbqrOnOqc+iHWbdh+EZPriELE6WtaJd8
         kC8A==
X-Forwarded-Encrypted: i=1; AJvYcCW2KnY42Us85T4YAtXWeZtnZPYoFbG6HvRAyx64RKBm7I6DfdQ1CdVDVoT5hFMpqAeWszo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMlFe0X34WXCq8mv67kyoYIVANxVLLHS8zs+jdDVyUDJWxI9cX
	FpX7Q8UEt/CgewH74CBO90BQJcGnnaS3DuLbs1+MDl8n/VO6vkG9PIQA4pMjynTEkDcw4klRpa3
	OTPc=
X-Google-Smtp-Source: AGHT+IFSAj7upe4/2sUQdHW7jz5sgYJGysCflqOFoadt1kpwGAuHykIm5X1P7+daPBsyN4rHWM4Ujg==
X-Received: by 2002:a17:90b:33c4:b0:2d8:94f1:b572 with SMTP id 98e67ed59e1d1-2dbb9e1ce4fmr10261622a91.18.1726363099986;
        Sat, 14 Sep 2024 18:18:19 -0700 (PDT)
Received: from localhost ([210.160.217.68])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2dbb9c4cdb0sm4356067a91.10.2024.09.14.18.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Sep 2024 18:18:19 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sun, 15 Sep 2024 10:17:40 +0900
Subject: [PATCH RFC v3 1/9] skbuff: Introduce SKB_EXT_TUN_VNET_HASH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240915-rss-v3-1-c630015db082@daynix.com>
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

This new extension will be used by tun to carry the hash values and
types to report with virtio-net headers.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/core/skbuff.c      |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 29c3ea5b6e93..17cee21c9999 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -334,6 +334,13 @@ struct tc_skb_ext {
 };
 #endif
 
+#if IS_ENABLED(CONFIG_TUN)
+struct tun_vnet_hash_ext {
+	u32 value;
+	u16 report;
+};
+#endif
+
 struct sk_buff_head {
 	/* These two members must be first to match sk_buff. */
 	struct_group_tagged(sk_buff_list, list,
@@ -4718,6 +4725,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	SKB_EXT_MCTP,
+#endif
+#if IS_ENABLED(CONFIG_TUN)
+	SKB_EXT_TUN_VNET_HASH,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 83f8cd8aa2d1..ce34523fd8de 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4979,6 +4979,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_TUN)
+	[SKB_EXT_TUN_VNET_HASH] = SKB_EXT_CHUNKSIZEOF(struct tun_vnet_hash_ext),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)

-- 
2.46.0


