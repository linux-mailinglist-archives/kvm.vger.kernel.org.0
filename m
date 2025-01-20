Return-Path: <kvm+bounces-35954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE41FA1689A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 127583A5ABD
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D556F1AA1D5;
	Mon, 20 Jan 2025 09:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="gHz0AYG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9161C19A2A3
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737363648; cv=none; b=ZiwGGXBGJCRttTQpzGSuGTqf5XjwDRE12gRwgYQstyaf2PkuJrQQYIk1GmPuBqbJ9dkwBXBcRsn3c6i85i03HFYRHukGjLphQTPZCZz8JJ5VKwGG4zRPChyNWaQHBETNrAq041dJy5vHyAzsi9tN3rhacAJ0ngaHukJ92mXA93k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737363648; c=relaxed/simple;
	bh=LM9iW/m0YgbRl7+h6nWSsqFiOmAXB2xxJK4cNTPhNBE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XBjdZWxgi36CrXxwtwLP8ciCQs4D6f2ZyhCsvVZzNZj2q0frFbAIi37+jCigC5HPxh+9WPhkxiFV1VcOfrRDeB0osBhioj64aAW+Vwo+qzayH1/qnaMY8UJFChMkoSwkVUcSLd5VlATuly08TZuFs8Kv5HTVCPHj5zXYZ3PT4Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=gHz0AYG8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2167141dfa1so73183445ad.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737363646; x=1737968446; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRUixS5CfbfDqt7hn3posZxB5lUwV0PPemsSCTV1gNk=;
        b=gHz0AYG8LWeBNVryG4/GIqNJd33MZxjFXqx8R6VBIpKM8RR6cnm/MBpDPJJqXE3uSg
         mO0MaT+RalV0skJ9XPhDM73FJQR3M0En87H+nojWMLTkc2OB0xeKnCXEtpCznIkkuFyA
         +G6mCLqJ7byNU9GPJo+b+2Bb0j2s2Q88NSouQZ2JM74vRln9+w7r9/TWqbcO44AYD6JA
         oxCcIq5I/jEic7PlWVjtbQhqWAWQc9A/7Eoo6a3e5IyIvQYp3y/Y3hkNs/2Jy6tyHAu8
         butLSezhjU0wSbRXhv81uzPhlE8on/JcxiW6GdOQ4IJ/jManHSMMinC0vMaGqUbkWSU6
         /QaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737363646; x=1737968446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRUixS5CfbfDqt7hn3posZxB5lUwV0PPemsSCTV1gNk=;
        b=qosq1qyx4IeRm30OfJAg5f2dQT8ZTXvEsK5q1UY+BFvfUwfVb6ERNFgMYqVf1bp4dL
         vyr/yypKDo42gLNiOHI7p9fezSyUFa8m8bw1IGPFsI0LXIwO7vZbsb/NSC4CUCSppA7o
         R2OOjUQYcJTUORZG3YJII0sTOxfAH6yZJl9tbOoGIpiuYUq4t2mshjcMwCGnzXSKWJLZ
         RaZH+WDJYnl2S4+63Amvbig9m6XETcXamnwE44TpfjiYTW2W6aAHisbv56uhkGGU7X7d
         LUGS32D5FK2M5/6bDbZ3E8lLovaT2okI/j9lIVdlzrbEl0dBkRcxFT3pBRvnTIlJTHff
         pduQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGTihuUpveJwHelifcwc/ZHfFzxMbScx/Ax68r2jzGgjLhbLgkFBmx3pvBxqyucGqKy3U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwptL8xCyrBZdl+Sku+m/551eLKCQnB06AUG3qOo7rF81KwIHvJ
	W3dpCDQuMgSAPx+CJlj8NUaSLoIYEnn71TdPKqiWbEzWU75ZzYLzS6UzE3wI9Bo=
X-Gm-Gg: ASbGncs5hMX0g+/dwYYoR2Zew2T6OMr6YXqfxIMZ16aNKoNRNo8Kddk/phYorMjvTQJ
	z0oZfyjnXh7FtmotUtWHAQhGop2Ss/sFq+hx1gpVhjC3EaUBFpk5wej2aFQatVT2XC4TLI/fdSj
	pfs6VSsgsxm53OUXOhlqcnbaUdB7d8LUxc5sS8inTNx6j3XDWgH3dbRVefPxiizXHbm0H4EyU4w
	S/H5hMX1D0ASG+z2Z6FvwHBAEUefeEELuEq8CMxoI2z2laleSAHi57gO+O6K+fOJfOuIXTC
X-Google-Smtp-Source: AGHT+IEks6SKihbl6+Qi45ONgGmxvxvz6jOzu1ulUFye+X8vv37vBy4sWvWutLsO9/Ck2HEV+RAlLQ==
X-Received: by 2002:a17:903:234a:b0:215:9eac:1857 with SMTP id d9443c01a7336-21bf029ddf1mr288703675ad.5.1737363645786;
        Mon, 20 Jan 2025 01:00:45 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21c2d3a913csm56890235ad.117.2025.01.20.01.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:00:45 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 20 Jan 2025 18:00:10 +0900
Subject: [PATCH net-next v4 1/9] tun: Refactor CONFIG_TUN_VNET_CROSS_LE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-tun-v4-1-ee81dda03d7f@daynix.com>
References: <20250120-tun-v4-0-ee81dda03d7f@daynix.com>
In-Reply-To: <20250120-tun-v4-0-ee81dda03d7f@daynix.com>
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
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Willem de Bruijn <willemb@google.com>
X-Mailer: b4 0.14.2

Check IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) to save some lines and make
future changes easier.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/tun.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e816aaba8e5f2ed06f8832f79553b6c976e75bb8..452fc5104260fe7ff5fdd5cedc5d2647cbe35c79 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -298,10 +298,10 @@ static bool tun_napi_frags_enabled(const struct tun_file *tfile)
 	return tfile->napi_frags_enabled;
 }
 
-#ifdef CONFIG_TUN_VNET_CROSS_LE
 static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
 {
-	return tun->flags & TUN_VNET_BE ? false :
+	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
+		 (tun->flags & TUN_VNET_BE)) &&
 		virtio_legacy_is_little_endian();
 }
 
@@ -309,6 +309,9 @@ static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be = !!(tun->flags & TUN_VNET_BE);
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (put_user(be, argp))
 		return -EFAULT;
 
@@ -319,6 +322,9 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be;
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (get_user(be, argp))
 		return -EFAULT;
 
@@ -329,22 +335,6 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 
 	return 0;
 }
-#else
-static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
-{
-	return virtio_legacy_is_little_endian();
-}
-
-static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
-{
-	return -EINVAL;
-}
-
-static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_TUN_VNET_CROSS_LE */
 
 static inline bool tun_is_little_endian(struct tun_struct *tun)
 {

-- 
2.47.1


