Return-Path: <kvm+bounces-37299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 882E9A2844F
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 07:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30DD2167351
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 06:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B72D228CBE;
	Wed,  5 Feb 2025 06:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="QH5FA/9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57B9228380
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 06:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738736562; cv=none; b=gKoBotuE5ZM1GmGE2m5tR7VFwfY6Gwv6YkGDuDF67ansMwf2Z4xYpBHHWscDcI/dG4ijosoYfMvx9sINdvydCphAhf+U2ZdG/ua8c2jEP4Pf+lx1KhC6NzVbgakyw30ZeqTFrl8tyc36L2g08izSFLYjBDAc9LiMU4Mz4XOOZRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738736562; c=relaxed/simple;
	bh=k8AT/7ba0LLNdr42q8vL3zcMMHDDU7sY3oym4vZIyT0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IizP9jYZv213MR0+9cuXprngRgOeT1aMdYpNsOo2gECHN6c9PyVyPZdXZoO6FlMbb3V9T/vg43H5RdXdPmdl4QQ4nTWm+gWuAe+yo70jf3JOMv/E4aHZj8FkTRsy6vMMy+gY2PV48n+brN3aligjVGlKdREVcwvzwDjFcAz8jk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=QH5FA/9x; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f43d17b0e3so10882538a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 22:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738736559; x=1739341359; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=beCLR6fS0dAzFFFSsVjnikGsGyHpeeQQjgoShxHI8aw=;
        b=QH5FA/9xqt072asZe5B9//N3mO6mhAz+QH/YNmvtldGolQMWlwGYejVvjtBamDcLp4
         S6ABuX9ImmCgHuvcGRlduNyYiPZ5Ydnv6kd6W5Xq2yUVlIAWtvQq4XMXWF2cYZKvo3Eh
         uQkU7w1C8VpdJCvld8Kou4rkgUbYgYJyzSFpeAY/X27K75fn9vbOUNeoAUzsny0D10r+
         WRZlVSmQDZy/9RoLIlECHt55nk1Oec1qM4I5MNXLkY53o6IqSX4rCU/evEQaT3gYolQ4
         SiiiPIVmcVpAqx99LvEIWfjK5BM+ZbyGdNS5WxbeS2mtKWsc7Kqone2ve8NCNXQzmyMz
         QR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738736559; x=1739341359;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=beCLR6fS0dAzFFFSsVjnikGsGyHpeeQQjgoShxHI8aw=;
        b=hop6LOWsN1ajQRiyh7a4niU3puDix3HGS01s8WMhn7f7B4R7WRzjjizHZBYbKZ1e98
         MuJ142CDda1oIyORyIbeZlvW3fit92An7V2yY4BN+6KWin3Yw+gIE62iLPzkP+x/PGjm
         aWdtuHmubHkrqHQ+oKO9fzP8FnsqMgmNrWl8SwjhJnxUPqcjRSbQf83I817wUcTSTYu1
         WWku/kBLwBcudWPVHhylhUSDBuNVWEhyUuv0eFttEqkgcrb4iNvmrcGxsjv+YZ94mAbf
         QIkpSWLjJ8KWpW+CpWcKFpjS2pCqTPPgNnYQq2NHeX/8Gt22VF6JJr17SqU3ejmZOJwX
         rNVA==
X-Forwarded-Encrypted: i=1; AJvYcCWA9LQjbuUhUsJr4gUrYxZdNSjNjXlwyPqXLWYl3ZhswUXRod/oYi8y01bGhJASH/kLuM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZdzeik0CT2ksWVmSLP4eho4YdZLCvBhZT3MXyU40B6A69Xgw7
	J7uQ0weRg5+WFPnuDk3Liiycv5GKi0tFeziycQ9cOPGdHCgvS4kRHSmjcVQ7Scg=
X-Gm-Gg: ASbGnctgSl5wM9v/2ZeQuBSr2hfN5rOrlpgDcBBfav2/msx6pgPpMS2oKQ7CHS2o/dK
	tPxYu2BSd6zAb1DxC6CnYTYIiiPtX1wMq2rTpmzAcc+vmASpEF2+nXAD8AiID5cJ3XTBMIy42T8
	qP0r91PiSYvvUw/Dwd9zIj9gjkMfAN51AXMGr7wJouM57HIc2NxmUdyw1gku6xXMeNpchXKQtrp
	gW+q8P3SsDIeIwpaAFo/C1WnsNdUfhlkvvXMSc/MuR3g2l1W/KujTEalR0gsKAuEuNrwyyy6bCR
	V2vlSwFdy9dCc2HpJGE=
X-Google-Smtp-Source: AGHT+IEkltYiingUuvZ5OPE7k95CCEI+ZGRFDs15kcTYl15oURn0Qzmrf04BT6IAVXnOElwIy1y3oQ==
X-Received: by 2002:a17:90b:3c52:b0:2ee:74a1:fba2 with SMTP id 98e67ed59e1d1-2f9e079b0efmr2575681a91.20.1738736559002;
        Tue, 04 Feb 2025 22:22:39 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21de330462bsm106232865ad.204.2025.02.04.22.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 22:22:38 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 05 Feb 2025 15:22:23 +0900
Subject: [PATCH net-next v5 1/7] tun: Refactor CONFIG_TUN_VNET_CROSS_LE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-tun-v5-1-15d0b32e87fa@daynix.com>
References: <20250205-tun-v5-0-15d0b32e87fa@daynix.com>
In-Reply-To: <20250205-tun-v5-0-15d0b32e87fa@daynix.com>
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
2.48.1


