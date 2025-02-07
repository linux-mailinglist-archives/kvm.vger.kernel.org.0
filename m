Return-Path: <kvm+bounces-37561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44783A2BB10
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 07:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAD75166D2D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 06:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C9C234971;
	Fri,  7 Feb 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Qzdq5QMF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6635D2343B6
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 06:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738908671; cv=none; b=KzzbemkShaIkXNO8VQTjRad1hXEyvDCB4f4Fu/U3u9SDazH2X+n02xFdejQTtcK6o39iPEU4tS3xXwIWmEpfxH2SOUX0XkYmSnq5kH7pk1Fjgmk1hrYndUN+GJlyGlOCm2ze+w4wqaeO2r5McnIp9Z6oudiyC996Cy4Wb0siq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738908671; c=relaxed/simple;
	bh=cdUkce1+zju76xB2ulgsqkhH2BtZWQUF+tczDHuY9Ws=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W4OF5zBEz7eMjLgtPf5rGbkbQm0ZFYAurO34plJ3iAHPP54zjg3QNYZA6WyPrdqfm2XjysranSGiOC8sd9pz1tXXOs1xgD+CCYGR27oe2u6AUn2+O+9SbJGFtPzzy3Nq37cXkjKITsoLbplUFAQDnlsbBeHBmlkMf4gyxY0Rans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Qzdq5QMF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2165448243fso42213305ad.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 22:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738908669; x=1739513469; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8e6Q2IF1AlrwVhf0WEzy1BrH8KeyaluzZCG0JrRNn4=;
        b=Qzdq5QMFTDdclgtr7jpZ1OdQsvw37EwK69Zy1SuCQG+t9cohiUx8Nne7KfQU5/YDBV
         d0kz2bs7JP1y+I1fNGFYIBvhTv0Zo4RQayKiYxSTNHBFDTGKBp2LKi2q5qcmr809QspU
         Mo9+2+0Q+iZgV8qRKLYSUGn+bHWCUckSzEL1HkL1KTAGMZrbw0ZqPoi5ZtqhfW0ewwk4
         GeBuwTr2KO8kY6cMMO0XlAmaeaYRCWLxYBOvBcq+5vbxrc/BBq7FppCE01xFeWLoM+ye
         co3rtAN9iuL5PhTrX0oSltdAlDVpZxUSCkWAOmVO0OhNq3soAzQT6yma3G3WvtRlUVYn
         caxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738908669; x=1739513469;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u8e6Q2IF1AlrwVhf0WEzy1BrH8KeyaluzZCG0JrRNn4=;
        b=XdJGZ0MU+Bp8gBlGUhmC2ZIVbfcC8nY8Z+c1fc8MwbrpGEN6ZR3It+h8J3frgkH/I9
         /c1a1V+JpmImAVAo1h4MBNQSGj9IHn+1M+BXT9QNi7l2/8FqQA5bdzlZsLHG5KO8N5ND
         1pNtj4dYaTFAiAclfz+rSKI+3afsSz4tja1S4KlmF3IDrQvXMpqJYNJfau8SlzlJEGzK
         q4dsy2x3EauiE2E5PGBONV/1DCQixx8nb5GRxzDhc7WBhPbI7ZmfQ/Lr511FrhBQJC3k
         yDegipzYllzUezYhzNa+0ON3Ye8fcUmdD517m5CQ4ByEGApOoL33bAF0MY/JVLsQpfrf
         308g==
X-Forwarded-Encrypted: i=1; AJvYcCWcC5kdBnsSz6CgNaRUnBiib1syXYZBGG+Kppp6R4cYjeY0XtlAOt0VzrsPUDpVo7VyhgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrT/dJk8d6tsfDpUj1pE0bcH3Kb/sAO4e+No+Ml8VUp9dglEDw
	vVX2/zex3CAGTY6a30wSRe0wIZY2f9V7Zlm2TqRCA5OYyR2w1WIkaQpBc0tOa/c=
X-Gm-Gg: ASbGnctGqgZ6n27fHwapth9qutWmOvZ4m1e45VV/5FT8WqAdO3oteSfDIkTe3A/QcD3
	n11HgeqX722VzgvtYUbdOuuStdX+u3qKxJMFrjLEhgQJ6HLzFLpGK5W8uUR+2mITQg3qkyuQx9D
	hlE88tFVVIhWEhdy7sWB3VtZOresLBp9P/1KxF+BR65EHwm4jy2xz1xVu8myVaX2Uspk5GouFx8
	6dZfZMzN+VOUJFrLyD/0GgOQzFlGijYrEhXmlMaKqOVDLRdPbFfEn1iTGMU3qdtzw2fpjwq7qxC
	b/kWm7RJ6lf8lpW++74=
X-Google-Smtp-Source: AGHT+IHsiQFjzXezkiITWyryKLHFxWaOkXCA3VROnOenVsONjd60T0L0zqwo9kfDi5iWVlXHr3UF2g==
X-Received: by 2002:a17:903:19cd:b0:216:73f0:ef63 with SMTP id d9443c01a7336-21f4e7ae7cfmr37137465ad.49.1738908668736;
        Thu, 06 Feb 2025 22:11:08 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21f3683d729sm22605005ad.124.2025.02.06.22.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 22:11:08 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Feb 2025 15:10:51 +0900
Subject: [PATCH net-next v6 1/7] tun: Refactor CONFIG_TUN_VNET_CROSS_LE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250207-tun-v6-1-fb49cf8b103e@daynix.com>
References: <20250207-tun-v6-0-fb49cf8b103e@daynix.com>
In-Reply-To: <20250207-tun-v6-0-fb49cf8b103e@daynix.com>
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
 drivers/net/tun.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e816aaba8e5f2ed06f8832f79553b6c976e75bb8..4b189cbd28e63ec6325073d9a7678f4210bff3e1 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -298,17 +298,21 @@ static bool tun_napi_frags_enabled(const struct tun_file *tfile)
 	return tfile->napi_frags_enabled;
 }
 
-#ifdef CONFIG_TUN_VNET_CROSS_LE
 static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
 {
-	return tun->flags & TUN_VNET_BE ? false :
-		virtio_legacy_is_little_endian();
+	bool be = IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
+		  (tun->flags & TUN_VNET_BE);
+
+	return !be && virtio_legacy_is_little_endian();
 }
 
 static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be = !!(tun->flags & TUN_VNET_BE);
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (put_user(be, argp))
 		return -EFAULT;
 
@@ -319,6 +323,9 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be;
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (get_user(be, argp))
 		return -EFAULT;
 
@@ -329,22 +336,6 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 
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
2.48.1


