Return-Path: <kvm+bounces-46238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9184CAB4322
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19BCB7B9E8D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A792C17B1;
	Mon, 12 May 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NX+/muYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4192C085D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073147; cv=none; b=F2bWyTmDwyt7BOmxd190dkve3MR7u6Uz52caGHyqCWuugJ2BibwmiZNjouSfqLLxO3hl4/yZjA/VEvKxn2nmQnzCvrLRLM3eCcoBf/bClGLRZxYZ2ZyX/JgS22b77xx/JY1ps+7sr7jPue8OVDu1QyMTMitbR1zvFTrF4olENm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073147; c=relaxed/simple;
	bh=xkc01XmwPbQQqW2DLbPjrYSssEz2ZnunsGIPKKJvDsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEeuwt6npjhzTj3nmHIguKrp7Ev/Rwf7nc2ZeYjNGPeyw27/2SUuHJ2wYKszya3Y8u9EddYmvwRExsLZLbBd+95E2ZJ2TmsBpji2lpULelAsnveQjot03VGfSl3jBEApAfwozKA0WDZ00v7xBLTN9JO0yd5RQqSvhPtN6m6NwkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NX+/muYJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e6344326dso48593055ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073145; x=1747677945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=NX+/muYJLilswG0Kk1EFBIoSw37dNNc3x0IuTo4yjJsC7Z1QQ4jgI9f1NpG7t+FKjE
         rpjaVDLx0HwF6VenUAkygwg+B+b6v5E5MmAD5kRoke2E1nwnLENBodyf5ZmFfOgh4fja
         RrOSEP/NRvL3n7/3Y15LTsAkvTiHob0pq+9V1C7cXmHe5XVJ1g9WWF0jS03uGorQzqmX
         +rygPAxtZz5j2Q1J5TCfMx41NM7Y60izjqgXdH1txYk7cKqHZHj9ZGvxJvhnWY0N2HRJ
         cYr65qFyxLTFtiV+AvAkelN/T7EPiLAjKS+40mtvTFgbiJhn+UatzNf0nADZ9PpSg27T
         PzLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073145; x=1747677945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=g0ftG/4tZeIC0lyl6U2VsWBqJ7n/yOGsefXs+/qZSUfq5EoD7mOgob6KzxJG2ktHjg
         U0djLZP9+AJHkX7nOmZGXMf3M5PQjcONGBpBM1NmFTlRsHU/QSSP87S/5ggJB9/VW9uY
         eCyDHYvjq3OJ3QH7SaW5t+YAagSCkFK6pH6WxtgqeMz94jIQEAnXYHG+zPtYR/WdkrN0
         ypZ7Uogf3gDXMU0SRjqibq4xqy6QUKzEo/oCN/JhooNSn9ObYp9sToTXDzRgDaeTwTDm
         ib1tJj1hUPHLtP455o5yQVNIvQ7t5PETFWZO7HBf+K1B2+5S75wSS2/I9MkQ7YTLNQ5a
         hbNg==
X-Forwarded-Encrypted: i=1; AJvYcCVo6xOqLFFJ76lwK9KDAHox3hp8Hw1r9VdSLxWhbWkh9vwIYclOKvIw44s0lel7S2qzRaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkxUrGNsDvBViRUEsglb0rqjrcSFgmLAxFm6bkkLjuwo1erMVx
	Id8dupbkDrdZUGr7tcpOrTS616xMLdJc0PBBErFgtGcdyBk5gUMES/3hj02T+XMrpNNde8kMRZ+
	e
X-Gm-Gg: ASbGncsz5yd8Pduf5BYMSkh+5oI9HEj2rfvVFzFNPjJ+s8PL5BdO+IzxM3sI60CmZ++
	X/h2XTgyZmj+pVsWNyEdbiv5bKKayq1g13o3nZ9PCkOFQhon4Mk6DFGta0c0CcFbqf/KqEAIzfU
	iSNt70Bhxajtu8AOFZVmwdnNiE4i5SP6TIagf+sH+8JmBp2ZMKXbNFIpEKLE1dwcFtiUBR+rB3e
	+HrLd+spgZdBVzzpQh9TSOX6DtN3Muo2z75CS7PL4EiYPe2SLPHfcDuojKHX5nWHF0NCodO/CmQ
	Fx1iRLNduduu5ZyPkj5aklj+2nv0o20oWFAu0XdJZh+ZBisg4es=
X-Google-Smtp-Source: AGHT+IFDzqcaX/0EytonVdOMQTT5ip0rYF097hL95/ujsWihHVjpJwlVBrnlb5Xxz7eOAPoupInNqw==
X-Received: by 2002:a17:902:d4cf:b0:22e:60b9:ac99 with SMTP id d9443c01a7336-22fc8d9c6bdmr231746335ad.34.1747073144748;
        Mon, 12 May 2025 11:05:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 37/48] target/arm/kvm-stub: add missing stubs
Date: Mon, 12 May 2025 11:04:51 -0700
Message-ID: <20250512180502.2395029-38-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


