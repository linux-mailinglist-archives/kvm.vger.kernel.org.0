Return-Path: <kvm+bounces-41214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8590EA64B6E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:01:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A828B7A4CF6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DD323F291;
	Mon, 17 Mar 2025 10:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="glPhiQEb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA5C2376E6
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742209133; cv=none; b=IqYpNss9PCDpRHZk7f2S9LLzpF16GO+N8f5cFivd/Ti/nXgWD6/SwWXPM5SRtukE7WpuaNnDz+Z1HTCSELzGUDVnFysdGWp50o2LYTyl51GVBSWMqxUfx/jsqMEihui2RLiOwGQWy4o88adPtdNi+P/cGi5RUh2cXsddccOi4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742209133; c=relaxed/simple;
	bh=GneHmk/qL//iBdk3HQU3hkToakkrBvwUGgglHdEvMAI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=utGAAc9HZxhNKrug7LAm5ldiUkMY1jUdhbKippqX1h6gV7e6/dCOnOV0UMq/YWdPiB+cFnR6aU5XVBhhI0xaKx7cdspLQFdajYrqn+zF1nk+GPq5QwC0PPDSu3xhHBzwu3pb+WwlBH2xI951cSNnYRj3sNKYDEmi7KbvpU/SJiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=glPhiQEb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-224341bbc1dso75067615ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742209131; x=1742813931; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tr9XV/m9Yn0vfZS8el5Q1nXWgm/+NfgkMX4LFmMiC1g=;
        b=glPhiQEbgprPRJIAaiPPvdrEwy1JnHyYY/PfrZ1UIgFW6PYWjiCN+VgwzUkIeZeQo2
         oiBCFqtQ///+RLLqhC7bp6SOd0h+dteZdvIehfwMmI1ZJW5VsTPpPd6AMGFap+XTJEol
         8mrzc9YV88uSmHx5Y3kjCJhtyvS2vqE01jMQx72ZPzxWJuHNA9T2OxU1mB5LdWWkyDRi
         NP28ThgMdDZmaUpB/7DWGV0cRgj4XWXRN5qZGN2ljs6NpyRzq9dAVKSzMjMznNRvy4dD
         xIe3vopWjWCCAW9lPw/h7zqJYQtrpbaEjhJYyA1378KFroxAv/9Km4bFY3vSCeqBdGQg
         VsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742209131; x=1742813931;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tr9XV/m9Yn0vfZS8el5Q1nXWgm/+NfgkMX4LFmMiC1g=;
        b=uhbhnzxdJYNejrHUy0y9IeZcc3obHMWd0APWuoKMJUetwfR2VlNftOT/lF0B671ysm
         Wh63n+zQFbfERSRWKegTbVvC8grYt+HD78c6r3TmoPkWVYkdY4wN4Pp4h05SY0tJg6nC
         aPmbg2pfiT/kLmn+0FO48hXB1kdJJo6YCDle0i0Lo3jtGgzlWerMGLu8pPOM3gvnXj05
         SwdRBysd9C43Q2qgP5zQ19qpnwZGRYGgz+n6QvoiymdyomtUGCY1VwkJY88T5vqlcCU9
         RYOFoUZubFtd4p0x1fSjg3ry/HelQrqhI55bFAkIl9P/gZHLkhE6zBOipWELIyjXXzGz
         A9qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXme1ch1BU1XCjZDbJ2gPR6Vf87X7rS4qLaHmgXiZ18GxQinVL1WuGzYiXL2+/8iSOE/uQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6gqCF1QucQMuc9O6kawvw11RFjjF19oy98ka+9IT25eZFuTdE
	NJy8rOsYrJ8EnErwaJHVX1tV60USszvNzo4+IzknYJfLAiFrRhnCtPDHAaIqYjE=
X-Gm-Gg: ASbGncsIDDjroZelWrqn9c3o+v41K6NMrbBD0XdAgBv1DWPoF4o2i3sNgC5k70joqTm
	KaajuOLmCvFlGzGqP/1QITsZNrDoV/bL2N7wuZBYwIFEioJaqXsq7lK5IYznkixXyVokHjRNUSp
	giF2sQBXWjIxFjEHVt2EGEWatiJswJxFv0iwS+6XZm0eM0mDVNsDwBZMkJ7mp8MP+EZ4md/Ug2r
	lQ7hfaQVV3XBggLoTI6zyzQN1fN/z366hu8dRlLOtuGWeAaZPcsLngr4A1HPkqstRCDaxpDxBjK
	twW1GZtOJvmc/AO7U2Pj34mAp8HtO9rdBbqOkXYXUJC4NeuM
X-Google-Smtp-Source: AGHT+IG+ei/lg8cM5wfrSZJXqZa9osmFd7Sc/z8/9LCogmJrZABRCUzflnBMKqILkfW838r3yRiXfA==
X-Received: by 2002:a05:6a00:2e25:b0:730:9801:d3e2 with SMTP id d2e1a72fcca58-7372238e7d9mr16744723b3a.8.1742209131380;
        Mon, 17 Mar 2025 03:58:51 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7371167dfa2sm7533712b3a.107.2025.03.17.03.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:58:51 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 17 Mar 2025 19:57:57 +0900
Subject: [PATCH net-next v11 07/10] selftest: tun: Test vnet ioctls without
 device
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250317-rss-v11-7-4cacca92f31f@daynix.com>
References: <20250317-rss-v11-0-4cacca92f31f@daynix.com>
In-Reply-To: <20250317-rss-v11-0-4cacca92f31f@daynix.com>
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

Ensure that vnet ioctls result in EBADFD when the underlying device is
deleted.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Lei Yang <leiyang@redhat.com>
---
 tools/testing/selftests/net/tun.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/net/tun.c b/tools/testing/selftests/net/tun.c
index fa83918b62d1..ad168c15c02d 100644
--- a/tools/testing/selftests/net/tun.c
+++ b/tools/testing/selftests/net/tun.c
@@ -159,4 +159,42 @@ TEST_F(tun, reattach_close_delete) {
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
 TEST_HARNESS_MAIN

-- 
2.48.1


