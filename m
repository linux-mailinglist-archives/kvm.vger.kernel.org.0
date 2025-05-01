Return-Path: <kvm+bounces-45060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EFFAA5AED
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34C861BA7B8E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E1127E1C8;
	Thu,  1 May 2025 06:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oAtwJ01p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49E627CCF2
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080662; cv=none; b=IQ1WJYBEgpDZVXBhifQQgeM3BcdnLsQhdIzGpofFWsJDz/yO5ig8cgiqQraYYNHZufS1tpFWtdzXEhzIDER2PIq2sY8BkJEWM+lQtt3AUl4CVOIcu/hz/TT8qqyYSp21QMnR1zKfPnLGTRARnBQhg8vl0JINdYMiGBmnfZ0Q4J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080662; c=relaxed/simple;
	bh=j5y4e6mb3u+4U8elQJsH3B4zm0z+2AKYADpUHZvkyMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxb25c5lRHnJjxJ9YLZvYON7S2tixqtCEkyUREPJlnjG85A1o56m7zw4j2wC5/pNfWotJf02bJDjb5IRCxYFHZuhrdVo7pcGjgcP7PTTubcpgV/uecnELSDlvNwFA7bEjPS43sXNLkm3XjraMdB/79cX0g6ms9CEVOnfNb/OE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oAtwJ01p; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736ab1c43c4so676019b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080658; x=1746685458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIdah7DauyVJu2UfcXO7gW3KsF259Fcu0NGf/SnDj/4=;
        b=oAtwJ01pKoifj4/mbWTlG8oKGfcklpgXiwiwru0CpYFlO93zK63qC09ww5J3BEpqfl
         LzLSVeKYNO7536siGwY2ocScCN/DcHLhqErAQ5P2L6SukErgaS5I7kJVNPtQj+4nZOK9
         366xbATRNDt2geQzludjHoVIMlIu/AnmabkDmwWccHev41JZ7jel/V71M5DarpVa3kvQ
         Ou6HaElB2o3rE9X9xcNohqb4LOC8CGI+bvnR5SCW3jbpeEgnXT1RUyCkUCfT2OmUTR34
         CN5LhgOR564wdZJTIZ602QY5v1ckXstrb89Yt1tqkQ9kl6EEtYAi9yiM1crFee99Ry4D
         73aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080658; x=1746685458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIdah7DauyVJu2UfcXO7gW3KsF259Fcu0NGf/SnDj/4=;
        b=vO8GoJZNWb8qKpH1ZlZy2A9ZDnkiU+w/t3WB62baxgf3azy4u3WSwxSy8DDTQ8RJNN
         Msnh9AT81+C8EoXylOZ8hpN6jOzbdIg1519e+IyVBENeutqV8DnYRNb8P5LhLaZRXtOS
         gpUlzst5hI0p29aFQGxJsnu8lfayG6Um5e269/vXbtF+ZzH4kmdKf+nYr0GiSIzmjjy5
         lq9a9PGhtJUuYXppalBo2Xr463pstyJzB53gxRUR1X3IV+Y9sTyRAKih/qOPVGGG7XZP
         hoM+HDzTORlf/KH+zUllaWcQlntWXc1K4s1cIYBCaToR9e0ZUghilDmh6sv1gfS930Km
         a5Hg==
X-Forwarded-Encrypted: i=1; AJvYcCU0AECMYHAdS8vyoNrx3GziWdhUKrztv3+nt3NyNOhN18Nw0HAmFBT2HJcVmILvrHV1QwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDQSw6hpFAqv21G9ejlZdZ3bVbFgLlx0ETQTtAuMj3EVuTTh5L
	ee8LkcOU+I4d7DofSD8euH6S8pAtgyAKKTJgQ/rRbz7WHMIdmCJPxYXrmvYSzkQ=
X-Gm-Gg: ASbGncv5cpc1TA5LnnYdokkpX4LbX17hh/nr1ju+bIC4cMDrpKiSkFnPi/MdLdbpD4S
	V6YA4pyQjYUWwZtM3kSqZ3hr9bWNUUzawE06/7ku6fY9A8l/if7icf2BU6SI4UMMahGB+HWc1nw
	0re0QRbcuI+6aUTIwQy4jN9F/JW4XActjb8rVjs4kj9O87+RLOQd0NPBs66xxAj8Dc4X9eY91v3
	N38gVISogdg9ubBWYDOB87DjUzxkweaOaQ7sM6g2LNRo642Zm+NV3XogB4P4MNReiuQCo9zPpWj
	Dkp22njiYRDM0q1jIqX7RP7WTACjkDMPaLjpG1FG
X-Google-Smtp-Source: AGHT+IHttOmkTpBafkysIVaoZUp91eACZx3aaBB5iL46qJwlCVUoqafWxeTAwZ79dnw/ta9yzjKOpw==
X-Received: by 2002:a05:6a00:2181:b0:736:4cde:5c0e with SMTP id d2e1a72fcca58-7403a77e9e2mr8027903b3a.10.1746080658189;
        Wed, 30 Apr 2025 23:24:18 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 30/33] target/arm/ptw: remove TARGET_AARCH64 from arm_casq_ptw
Date: Wed, 30 Apr 2025 23:23:41 -0700
Message-ID: <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/ptw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 424d1b54275..f428c9b9267 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -737,7 +737,14 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
                              uint64_t new_val, S1Translate *ptw,
                              ARMMMUFaultInfo *fi)
 {
-#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
+#ifndef CONFIG_TCG
+    /* non-TCG guests only use debug-mode. */
+    g_assert_not_reached();
+#endif
+
+    /* AArch32 does not have FEAT_HADFS */
+    g_assert(arm_feature(env, ARM_FEATURE_AARCH64));
+
     uint64_t cur_val;
     void *host = ptw->out_host;
 
@@ -851,10 +858,6 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
         cur_val = le64_to_cpu(cur_val);
     }
     return cur_val;
-#else
-    /* AArch32 does not have FEAT_HADFS; non-TCG guests only use debug-mode. */
-    g_assert_not_reached();
-#endif
 }
 
 static bool get_level1_table_address(CPUARMState *env, ARMMMUIdx mmu_idx,
-- 
2.47.2


