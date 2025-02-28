Return-Path: <kvm+bounces-39660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE29A492AD
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E02BA3B81F8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596DF1DEFD0;
	Fri, 28 Feb 2025 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="rCVknn+e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191101DB55D
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 07:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740729570; cv=none; b=YD58/W1vSQnaSpwC6rkvIW92Tt1Se+DsmV5fYjGVWx8EU+80/jdcqLwRWDvKf54MD6OxlVFlPK6g7GWYI81xxEyg7+PacaOO52TqsBF3C/92xM6lQHJyd7vc+epPFuPbKCsfKlVX7TWnvmZ5XqEi6o+k7Q+uZBR1VuDR5xJ7Kxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740729570; c=relaxed/simple;
	bh=nEE2/C77oF+j3LxMBPOVoqrwqXRBAnjdJN3gCt7XvfU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=WfLEGgzaoYr4OsbZiSTZA+cJzQtPQ8LHDzLnQHhTe4gNbheJRur73sjy5hPxjx4GEu7dxuIXxbyZtk1hu/qaqRhVqQUUeCZNR3x0NAVfjCHVmZykLLQRGCN/cejwxE5CZVQ+FBliILBSrSEOQv0D2mg1D+MjXKQT8Ax7eSqe7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=rCVknn+e; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fbffe0254fso3789573a91.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 23:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1740729568; x=1741334368; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N/24Tf2dJCQDhe+eHaFoVGEomrBLp8dkxojt6Qs+7G8=;
        b=rCVknn+e+OkQz9SUULOPDMPYr5DJnJsUbozQMjF0rkG5rVIGlwFbq8tUnyAf+Iw1fg
         2taTxmIDbxWAkvv+2d9GSWMoi85DrNyK6sRQIMCJOY4LPcUac23QR2M7Zg+1ICxMzOQa
         eAZ5YsXwOUU6whCx+MfXO2Yfp+pVHJO/lbrN/y/aS5sD8zwQZLLalpM+3hV47HkSeapa
         axjx0VFMmNS/9A01+gY1vrBE80hF4uIhQ23nEWcoMYODYZy4EsqArgKWcuO9v+YB0PUM
         iVlXAMTzmfbbnyuz80Pqo/y/31RLQiIRfO6b/tTHPxn31grYWHvlH6vwopZj2GAboSlX
         ZEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740729568; x=1741334368;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N/24Tf2dJCQDhe+eHaFoVGEomrBLp8dkxojt6Qs+7G8=;
        b=G3VkMKBZ5b6atLiaPXiZg+nziHWj6sfF+hshTqvZm6fIkLzMWKy0LozDnICLQfWN/3
         fu0zYFEITu87lpXPOoRCxJI4RtV2LMI/q08MEX/JGhaGMYFyXHdkpGOuvoHoIZUvBS4l
         Q0zdFUgLb4Wwz9LElUH1Zu1Qdj0093Q8aUGz6l/ae2JCAA4w6G/K79MvUZo1dI412M7M
         XpslrJCuvqBYhZw1ZOrYgiJDeUzf4Dbf3p8PrKgCKTBbNrAJtMVaLXqDuqEiDA2+PdTl
         wThxjWsFJWmurlz6NoWgUjVtLd5h9YpO7P2/sDlgvgexuZZvhWf8PzFD8VwaHmnouv9I
         Gjrg==
X-Forwarded-Encrypted: i=1; AJvYcCVjMtJNODA5bT9nx0/ONk3wWezzRM7mxSCRHcHUuC1wVDMX8loS+jz1tqcdp+2ri1u5+2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnhnWsvbQS/qh5+JZZO2xmxDxqz/ohnion/d8/pM30gdYyN21j
	8Pjd328LdVpXrfy4nh3j1PJ8VSQv69B+xYkq0ewzMNpjE4saPKE5IxZm15SB77w=
X-Gm-Gg: ASbGncsipbDYF7Q3R8+bNinMbbGEvHdTDIkPlCYqkaaihXnTLvIZuR8x23JPxB+/ubg
	Mk6xxb5DwV1ckafED+eYpv+igHGutGbJ3aoRBQJ1SrsEY43XbuDE3LYob7duyqrtSe/fVotuGUH
	Yn1RTYgXEyyU55QANK7q3KcYFaS8JkaqjYUokvmz0YJTTDT+uS7wOsZAqn67ML1imKeMWYQmr7C
	7gBWLv9+fKHDfwFTkoPIAqHytZk79nJt4NokjatZryqzfcbXJf6KOX0kvwIzh+eYV0b493SW+Js
	w5IWbFTEiFdMqvdo3GyE+fye8Nu7ug==
X-Google-Smtp-Source: AGHT+IGakArRWPozSXDLt1J/ZIr5ZW8i64CgVAq8BmJe2fBTFkpotPO0s0B4850yKyMXjttbX+FZIQ==
X-Received: by 2002:a17:90b:3845:b0:2ee:c9b6:c267 with SMTP id 98e67ed59e1d1-2febab403a5mr4261783a91.9.1740729568382;
        Thu, 27 Feb 2025 23:59:28 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2fe825a9681sm5223275a91.9.2025.02.27.23.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 23:59:28 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 28 Feb 2025 16:58:50 +0900
Subject: [PATCH net-next v7 4/6] selftest: tun: Test vnet ioctls without
 device
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250228-rss-v7-4-844205cbbdd6@daynix.com>
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

Ensure that vnet ioctls result in EBADFD when the underlying device is
deleted.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 tools/testing/selftests/net/tun.c | 74 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/net/tun.c b/tools/testing/selftests/net/tun.c
index fa83918b62d1be1c93adcd6c2f07654893cf97f8..463dd98f2b80b1bdcb398cee43c834e7dc5cf784 100644
--- a/tools/testing/selftests/net/tun.c
+++ b/tools/testing/selftests/net/tun.c
@@ -159,4 +159,78 @@ TEST_F(tun, reattach_close_delete) {
 	EXPECT_EQ(tun_delete(self->ifname), 0);
 }
 
+FIXTURE(tun_deleted)
+{
+	char ifname[IFNAMSIZ];
+	int fd;
+};
+
+FIXTURE_SETUP(tun_deleted)
+{
+	self->ifname[0] = 0;
+	self->fd = tun_alloc(self->ifname);
+	ASSERT_LE(0, self->fd);
+
+	ASSERT_EQ(0, tun_delete(self->ifname))
+		EXPECT_EQ(0, close(self->fd));
+}
+
+FIXTURE_TEARDOWN(tun_deleted)
+{
+	EXPECT_EQ(0, close(self->fd));
+}
+
+TEST_F(tun_deleted, getvnethdrsz)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNGETVNETHDRSZ));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, setvnethdrsz)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNSETVNETHDRSZ));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, getvnetle)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNGETVNETLE));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, setvnetle)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNSETVNETLE));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, getvnetbe)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNGETVNETBE));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, setvnetbe)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNSETVNETBE));
+	EXPECT_EQ(EBADFD, errno);
+}
+
+TEST_F(tun_deleted, getvnethashcap)
+{
+	struct tun_vnet_hash cap;
+	int i = ioctl(self->fd, TUNGETVNETHASHCAP, &cap);
+
+	if (i == -1 && errno == EBADFD)
+		SKIP(return, "TUNGETVNETHASHCAP not supported");
+
+	EXPECT_EQ(0, i);
+}
+
+TEST_F(tun_deleted, setvnethash)
+{
+	ASSERT_EQ(-1, ioctl(self->fd, TUNSETVNETHASH));
+	EXPECT_EQ(EBADFD, errno);
+}
+
 TEST_HARNESS_MAIN

-- 
2.48.1


