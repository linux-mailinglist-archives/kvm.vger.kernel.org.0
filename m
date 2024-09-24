Return-Path: <kvm+bounces-27339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FFB298415C
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87FA51F24672
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 09:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE047155A21;
	Tue, 24 Sep 2024 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="zfHKkb3K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754001547CE
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727168480; cv=none; b=cFstE4vvKuixiUwUfX4lWkH/RtDW4wfKjrp94P8SL7RGRQNYvh4MjFVg4/BNXTFrfKaEzMGIV3LOfMnSuH44RToUJDtyDaCn3bSkcxUC833DNBMtJK0ImqnjEKqigRDkAZiCyzs8HlvA6o+1AuXE89cOXzEMDnTHldkDaD5KrFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727168480; c=relaxed/simple;
	bh=MyD71HI4MA2yAUC70K/NmNxJQezcMoO+zPtOIctDAQY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=W6F3wSi9gClAwQtCR74qXp681T4Tchosx0cpAYH0fMmpEAtEleyyXYqSerosF72I3bTd7s1ymhnjMrCSWQuDWrl/u1uJ5nipDzUaSij+4UfWuvYxvfu4yKJDmxpN1JXCoUMtimDu1YFvAK9mAktPsDoP4hyDsbnFagmOpLBXnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=zfHKkb3K; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5365aa568ceso6147614e87.0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 02:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1727168477; x=1727773277; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V1kAAAtErX+Mbn0MQOV75jcovDzbdqf7yjREy+JSPNM=;
        b=zfHKkb3KibxvDG5DI/1jxvJJM9Gy5bFU/hA3gzLoOJNG5cY68nvUbFmZoJNWOoPbDy
         QdaYyjaAb+YHTb32soahm61/QCfUkLcbYwh9MFZW5VVNL3CnoQdVdOQEuqrB0aeLDAbR
         wRsROTSzAzcptQ2AAQrlEtHnd8Fz+gu3i052WcwCW5HwebECApodwXSohXu2OJ7Cdy79
         h5/KonEDAFIGqVzRjWdNiHm86V7XbNMHG27rsxEEoxK8YMhIa4nv/54xCGrM76BqW9B7
         Ojr/B48NlthQ1kxLCxVYD16uTnewynObyTOFg5WHAtJQIu6qyBr4cMq53p64xoTMd7+o
         kyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727168477; x=1727773277;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1kAAAtErX+Mbn0MQOV75jcovDzbdqf7yjREy+JSPNM=;
        b=naoaytCErmkVLQfNTmi2VcoMdO4+9VFR4Od8u1KFfH1QCxmPpQrArHJj2tws7QLQ+N
         8HEiIkBuyNIDaAz6s8pnhz1aD0ltrDoAp9+o8yj8O0+RwkKKShqAoS8d7jeOSTqgVbcF
         OphuWK0K1zDx6IEsNTsW1NzDIew5lhajnsy2sKwkVwOTkXSXr533PEUkSmjfWHyB5Q6Q
         hVWIMkCuynxFGSWkcPjiqIBKYNnmq5pA1o80Abb6jW3vZZeF7MEWENFw6i6iRT73HU7J
         COKbnxf4RIOgVVtKTthGqSwPQVFEknbOYHZq3yN2UKSKGfsXBmNAH2FxzJrOiegU+lFr
         sLdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ2BQqwsdA98Y+QbwHvaRRqls1GScHVqfv6JKyvvZVnbEp+VtRk96aaZ4Z3NhGgD04iyo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOloD9Kk9Mvlet6r62SgrqVBFFfUNmzu7J0obRWZ74ZFKjJSSm
	PgMXpuIN5alvFybB4cvb9GvfL1huhyvpAGv8mkW/ZJ8w0bQ4cN1k0bvczMPIpP8=
X-Google-Smtp-Source: AGHT+IFwbEJheNGzEgD5vAlxy6ttzfcaZu81VFeEqJsY1P5iYb/DMCt1ffXE/8oRaqbajpxcR435Vg==
X-Received: by 2002:a05:6512:39d4:b0:533:c9d:a01f with SMTP id 2adb3069b0e04-536ac2d6a7amr8799569e87.4.1727168476563;
        Tue, 24 Sep 2024 02:01:16 -0700 (PDT)
Received: from localhost ([193.32.29.227])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a9392f34959sm59743266b.8.2024.09.24.02.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 02:01:16 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 24 Sep 2024 11:01:06 +0200
Subject: [PATCH RFC v4 1/9] skbuff: Introduce SKB_EXT_TUN_VNET_HASH
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240924-rss-v4-1-84e932ec0e6c@daynix.com>
References: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
In-Reply-To: <20240924-rss-v4-0-84e932ec0e6c@daynix.com>
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

This new extension will be used by tun to carry the hash values and
types to report with virtio-net headers.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/linux/if_tun.h | 5 +++++
 include/linux/skbuff.h | 3 +++
 net/core/skbuff.c      | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 043d442994b0..47034aede329 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -9,6 +9,11 @@
 #include <uapi/linux/if_tun.h>
 #include <uapi/linux/virtio_net.h>
 
+struct tun_vnet_hash_ext {
+	u32 value;
+	u16 report;
+};
+
 #define TUN_XDP_FLAG 0x1UL
 
 #define TUN_MSG_UBUF 1
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 29c3ea5b6e93..a361c4150144 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4718,6 +4718,9 @@ enum skb_ext_id {
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
index 83f8cd8aa2d1..997d79d5612c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -60,6 +60,7 @@
 #include <linux/errqueue.h>
 #include <linux/prefetch.h>
 #include <linux/bitfield.h>
+#include <linux/if_tun.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
 #include <linux/kcov.h>
@@ -4979,6 +4980,9 @@ static const u8 skb_ext_type_len[] = {
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


