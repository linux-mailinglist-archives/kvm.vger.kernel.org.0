Return-Path: <kvm+bounces-45517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED196AAB012
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F7431764B2
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAA73EF4FD;
	Mon,  5 May 2025 23:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iJ+CDbaB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA03B358E
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487258; cv=none; b=SDP3peKRG0cjfl3Q27aMKSmQZjsGGoZazimLeNxT/sdyvXYS9HiG6XQnldk/Df75Q6suS3jEOcixacTqIJaOF3jMfhno0db3bGNfNkwnsABQdXojlZ/n0lALbhJLBEedrCxdPQHBZ9ZeGDimBmqZSYT19g3HltGsBdbonssmOFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487258; c=relaxed/simple;
	bh=xkc01XmwPbQQqW2DLbPjrYSssEz2ZnunsGIPKKJvDsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqHIo4Fi9Qx13sRCB/gYDfpFd6ybfzqxGKIfk8Tt34eEhO0ziq9+xczC8FGPQMnX1PboYS6Dky1FMaaUeSJXaD0ALJPCZsK1NwEIICUrrgdvTSYIjmsYMR+r3ecFI+yCG07UU/fSviNS7btZoq5w8nEaZwtRvHwjHJF8YM6d4Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iJ+CDbaB; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22c33e5013aso53525345ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487255; x=1747092055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=iJ+CDbaBkqlhpvSLdONce9RcDxtoEM7+qgYgAed7nb93t0a99ewYHGO4/t9dL6yQWe
         6NSyp5z4m+F711aSkQ5P7nnsIlcxIGMuOqmhUxLS7Uo3enYs27PNhLvJ0bDELANTE+TO
         hl3ow6EDpWaH9lD4+ott+jHwXuvnZNWgd8jwaexeUv9hpYLtn2Vi7Qpj9NcFOauDBqvp
         hg9B+xz5GDLdNafn+JKtBa5/fXxyxUjwncI3NmIaIb/C3gPMkjpQuVgnglchNjKqhlek
         xM3TKuvqIaiqDSZ7X+wfyWU9gbEOWijySKDiNYCwutR2POlp22+JdoXkEbZ/fpm1WDmK
         SQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487255; x=1747092055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=u5UceyQCVBG1jghCfBGtRANNBlgSFSy7xhtseW46GKMBv4rS2+cdWEmxPrMse6QXrB
         w7zgzn+Mjt6Q2wixzdtXPx816936oqD75jL3bPjhlY1iAwktT5/33cxHgw9N8+oO5gOS
         BkUdLqTqLHtyiSehTbzlo13PKIPnF/kuhCMaRsGUmf41uDQyP/WB/obWRWu1f88MTHcJ
         Wh5bxR3pocIFNR6Qi/WWH2uT6awfk6CRY0T0VghOJNOX3aBuyo2B28v3cr7md7m2BkOj
         xyoCfPdxzjm4szuf2qWuWNmXNkr/Bzmp5yQeBsEkWirE09oit2TW8Ntc5vcL/uLJ3AvS
         Zh1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVz0zt74PBUEF7Xa1rX9sA1zx08S3PWNRH1hX46evpP+3pSB0LEWHIU6OfVJSFdjqB+Tsc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf70no7mDJyLw+irBnIuPqqbdjwDqfUDcaGJ+OMAGP+uOX6PtT
	6kjU+bdS3uXkuw7RS0N+ubkvXKV+8KKCNL9aWQveDNsYUQK2UI/bOUOn7GK2jDs=
X-Gm-Gg: ASbGnctAswBUgI+px5BnfOQkbmUWo5i4tqqd4RjKnLeXdEWKic4+EDOnqjKViQ4S4Y9
	+OgiH0IzF7sTbaVRQw2sIMjA/5EkPD9JLzNhyfBrgvAYUzzcAKRg1QkZLEdT78T9MPBfsA8d+o5
	vo5iNQWA1Z1XhD/iOVW4kn0vWP9GNh15/HApf8qcuh7cxiXEksNOsZO/OqFxdHgSXVJkelz4f5i
	antNwC0eR4yivkhywVnjX+EdaksZf8ZbXElP/PHUFZ9Zyx9YSW9ng34rgklJ25swE9HYBJl6fEn
	nxOdrN6kr6d27t9zAGMOLhS/fatIyZfUZpBh7Oqn
X-Google-Smtp-Source: AGHT+IEzyM9z7CVe4AtEhGj/jyZA+D2xzzxXGDSUKPWZMwhpDevNTLCDhN002Fitb043HbVefJtNKA==
X-Received: by 2002:a17:903:18e:b0:224:6ee:ad with SMTP id d9443c01a7336-22e1eb0c7fdmr138057955ad.44.1746487255044;
        Mon, 05 May 2025 16:20:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:54 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 39/50] target/arm/kvm-stub: add missing stubs
Date: Mon,  5 May 2025 16:20:04 -0700
Message-ID: <20250505232015.130990-40-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those become needed once kvm_enabled can't be known at compile time.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 4806365cdc5..34e57fab011 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -109,3 +109,13 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_cpu_pre_save(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+bool kvm_arm_cpu_post_load(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


