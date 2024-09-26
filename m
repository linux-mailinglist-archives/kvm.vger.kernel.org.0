Return-Path: <kvm+bounces-27568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE6C98776C
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 18:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 285541C22D1D
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 16:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D123015AADB;
	Thu, 26 Sep 2024 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="Oztb0/WS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278B381B1
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727367472; cv=none; b=rJAsIwL+F2ELPyVoZuxKFGJ2cfzCMtLgNQ7vA/diX4i0zdtzhCS8US15LJs0xGv4gF+PLYH/lqL00xY6RM1IK5447U3Cx/aFu+rJ0gIroL8VtfqyFEb6XJe4F/rK6om77GuRd1xZuuTMgifgeltzkKIuPr4r4Niywo7Zrqj2SsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727367472; c=relaxed/simple;
	bh=7gDjgu4wElEbQxuDgDh35dLOIRlB1xp7/51JxMwantQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n+h9Hjc0FxxTaPn1MWe478iPniLCqhEqMOxn0Ep6HdD+D2RMuwuJYDX6w/dOM1WmSEkKuc+zfRbcn7uEBh6Dx+vC+dc9Vz8z4nGjkr8o4JiJnSR9xE9JehxgoPY1jWewsYRRlO0C+qSa1FZ6J/DbfdqZZyOvG0xgj3lfhkORrGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=Oztb0/WS; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2B6133F1CC
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1727367444;
	bh=b1Yy5Y+O/8SNdOfIY1NdJ3kg1DxrF1aZEa29oc+RxsM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=Oztb0/WS04iM+MTpN9XLV0YJBWobEOIOA+zZw9TMj+AJgRVb/cVXv4oVY+VA24nux
	 9c0nvNjat1VVe/Qpmzz49J/xjBk3a9baVUV9Hw7/51nB3RbGEGJQpNmNwhfMSscAqf
	 6HCHIAdAvkTLNq2UL7FXgn1GfkGuRBVKUPeUFtJVVCOL/BMvbm5gGYeuqCeRfRlywn
	 iRXZlczQtHtauBxfg3nxXdOKXXfj2/iBfCmN8k74ue5oE7bGaI6H7v/6DTqriMCxNW
	 5twVgh1kqD+qpjtnIKBK4aIBV3+NZUb+DgEK768i1YHaz9IpkNtZmukIp3nkJDsAYD
	 IjE8bvwC4X6jA==
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cb6ed7f9dso10988885e9.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 09:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727367438; x=1727972238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1Yy5Y+O/8SNdOfIY1NdJ3kg1DxrF1aZEa29oc+RxsM=;
        b=VteSOCj6mihvy5K2oInTXAs/nXRmvTokpv37m6u/EFiolwHMnUWuhqeV4IchQqEnxW
         BNl0/qe7ICB/n18NOVdb1DELYOHiaX2g9qkY8Ni/0idyzAJY63/9L5aIsLN1I0fHAQxO
         m3y62qV3LEztwBUbCK7S5kUYsqArKkoU+WeVZSHexPq+mNS0wEft5JpzIAKWG4CLoz+U
         zMw1Mvduq0lUkCK6q7gbWVoDQvCBfTGE0g9ICFdRwIlE1fcNHi9S2yHnXK+s7VHnkx99
         587hSmuim6fn33QEXWTkJpF8J5y0FonOYoViCcY3YeBImF+OGxA6CdZNpmXusP55/Bqs
         SScA==
X-Forwarded-Encrypted: i=1; AJvYcCVvmiuit/hge0KIeM3sJrhnV8qksb1NLi25nJoobHP8zHYaBR9nATr6wuw3s9TE1Y7DnGI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0+ohcYu+ffOFU59MRcYAzjuKzmUZezvjMyuCQQGzsErrI0R18
	KvW9HlgyCBvXL07XgFCuZWv1QFvoRKcI+IQ0Z4n7hYHzk5+OXgXniA/uDj4IOjvYUP9WZ5rsJwV
	iRpSAfa5ZIQXAaPpo+7M8vgh9bUneie6vg99kmII3Qh9319FOTCljVQk5GS9Wg9nGTQ==
X-Received: by 2002:a05:600c:1d88:b0:426:5e1c:1ac2 with SMTP id 5b1f17b1804b1-42f58433478mr169545e9.8.1727367437784;
        Thu, 26 Sep 2024 09:17:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzaX27OdIk12RXul9FuGgRDD+iCxKpGs0uDOQekLQVHE70zEjsFFHKV6Qz72FM1jylL5Re6g==
X-Received: by 2002:a05:600c:1d88:b0:426:5e1c:1ac2 with SMTP id 5b1f17b1804b1-42f58433478mr169345e9.8.1727367437454;
        Thu, 26 Sep 2024 09:17:17 -0700 (PDT)
Received: from amikhalitsyn.lan ([188.192.113.77])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2948231sm14104266b.99.2024.09.26.09.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2024 09:17:17 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: stefanha@redhat.com
Cc: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vhost/vsock: specify module version
Date: Thu, 26 Sep 2024 18:16:40 +0200
Message-Id: <20240926161641.189193-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an explicit MODULE_VERSION("0.0.1") specification
for a vhost_vsock module. It is useful because it allows
userspace to check if vhost_vsock is there when it is
configured as a built-in.

Without this change, there is no /sys/module/vhost_vsock directory.

With this change:
$ ls -la /sys/module/vhost_vsock/
total 0
drwxr-xr-x   2 root root    0 Sep 26 15:59 .
drwxr-xr-x 100 root root    0 Sep 26 15:59 ..
--w-------   1 root root 4096 Sep 26 15:59 uevent
-r--r--r--   1 root root 4096 Sep 26 15:59 version

Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 drivers/vhost/vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 802153e23073..287ea8e480b5 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -956,6 +956,7 @@ static void __exit vhost_vsock_exit(void)
 
 module_init(vhost_vsock_init);
 module_exit(vhost_vsock_exit);
+MODULE_VERSION("0.0.1");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Asias He");
 MODULE_DESCRIPTION("vhost transport for vsock ");
-- 
2.34.1


