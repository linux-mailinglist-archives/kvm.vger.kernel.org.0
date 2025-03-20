Return-Path: <kvm+bounces-41624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBC7A6B0E0
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 755D8189411D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F382C22D7BD;
	Thu, 20 Mar 2025 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EcQM7ypV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673C22D79F
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509835; cv=none; b=HBlsTYf9YKXE7jnbqxb0ZOgxdtt0G99FvrHH3uGYRzLEAxpwtIzJNPejW/h950WMixiaKgRe8C4hMFA6v4hYJXhRQElfWQoP5SHsuAesAdOqfgI/5X0i9IqwK2DxCeSpETgNYmTb+2YfzwZL5Po10/orTv20x11LKt4/ACxLti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509835; c=relaxed/simple;
	bh=D3GLMKf45fU5jKB8izQIf9VhQ0je6soXVPzobdOtb4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EvYNqTnu4LvloLaF0V4mg3T+S1iMqb4NY1Q0TOOY3z7KwaokfUy8QEYDlFJbdyTBZNsTs2DR0hTdui40TdKZLCrE+QOpCE65ff7n5BOi13WHQ3sznr81Fov8UYDBbp60xiQYQwP/lBj2lnmtwtibwnrlhP2htzhw/iBbYFAK+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EcQM7ypV; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22401f4d35aso27994505ad.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509833; x=1743114633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6JY17RXIOhpi9WGu5PHvZc/K1MBVjPo3G9pvjwYgCU=;
        b=EcQM7ypVF/Sq63mKGSJnRPl8bqT7IG6rig3FPDonFwm3nTPpeHLy7uYcPodH0UgxFF
         OEaB6SbhWow0zdFOmOIRYg9qsXsd8Ojp6KoyTaFXCzmRQ8YBExuqZbhRcy/7O2HLQBZh
         ZYOilq7xYyx9OCNLLbGmh/Cyu/bmI2we85apVGGnEzxeZJ0Hb+HJoVrCSbkjdYtoITvk
         qOu2m1zag0gF/FJSWzgoLln5aqFwws8GixwCfcyPWI0TBsUF98AoaBjJKVQiCdMXQUno
         rU1Howdh9fydv/y26NARLWGqyZnhURvDvkohG4+GRzr5Ugg2VhOkHINYe40ltidVovao
         z/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509833; x=1743114633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6JY17RXIOhpi9WGu5PHvZc/K1MBVjPo3G9pvjwYgCU=;
        b=Gde1E7wI6p+Zm2ZFnXkTHCQ+WBUjLXZxbu5mg90GWlRdzCoQsqT04E6113YFZfO7sS
         1CuBlby45tiNYMRNFtKLYfOREBzRSRMDkpJZDJQMd7prREQf+Ber3Y6+oDCWyF+CG9uW
         nQ1DSNSJyjd+KZCFbSBYhWphOIHOgEAeoGrKXT4K/nNqCIkvYuniscSZn0Za3k0c+enn
         TQF1PerOgq9lg/fdM7ggO+3SRYp9AYtByshkyTDjhGo3WgJPcHx3OMsZM0PDaD7IhZ6N
         uNiYO83NL9oaW7uwr1cQz6Vvuyg0i0I7N0J7M5wAf8MKiY7lVnIrhQldniE8YOwHfazR
         0E1w==
X-Gm-Message-State: AOJu0YxbEZOUjN0cdnowx/VhKGMijRRywZsqXRb5DRCMfW8Pp+nIiKMs
	7fL0oCggejrwt8zlSJ2lRDLee3qtF4fQFEdgPr6CQGnN63WFFW4i+ZmzMuxeZSA=
X-Gm-Gg: ASbGncvqQ8WgfPbUJIq5iLjWRfQqDc3IISvAteYJbqqKTjedY3zevHGryOAW8F3zkQK
	q2CIqdpFgB+6T44N8VyS22PtN1F2wYzansHuAEddLxTIQmdJyq07NB04hWn4R6CAH633leYoyIM
	u9rfylEP9p2psjnBYMMqO1bd1X5tJI4drZOJ7gyEzAhc5+ZzemnQef67QNEPB1MOyMiy8k+7Z8Q
	HRHYOX55smf00O8TbqibMgjKDyhduxuQFUDcDGqs9mRKN3aiFZmTLRzaZKT9rXQO9oBlxU4OaVs
	vFcdFZLPDpL5jRVlByjXnenrTid6rouZQ+JUgU+uCtPXrFhqRHSYVZM=
X-Google-Smtp-Source: AGHT+IE59Qwtp5nBxQhisMzue6LUyvUvNBhkAAgS1BGy24OByXsm0hDrGv8KdLQQ/IM83anAIbBe6A==
X-Received: by 2002:a17:902:f54e:b0:223:fb3a:8647 with SMTP id d9443c01a7336-22780e0a4b3mr14803805ad.41.1742509832795;
        Thu, 20 Mar 2025 15:30:32 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:32 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 21/30] target/arm/cpu: flags2 is always uint64_t
Date: Thu, 20 Mar 2025 15:29:53 -0700
Message-Id: <20250320223002.2915728-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not rely on target dependent type, but use a fixed type instead.
Since the original type is unsigned, it should be safe to extend its
size without any side effect.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.h        | 10 ++++------
 target/arm/tcg/hflags.c |  4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index ab7412772bc..cc975175c61 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -194,7 +194,7 @@ typedef struct ARMPACKey {
 /* See the commentary above the TBFLAG field definitions.  */
 typedef struct CPUARMTBFlags {
     uint32_t flags;
-    target_ulong flags2;
+    uint64_t flags2;
 } CPUARMTBFlags;
 
 typedef struct ARMMMUFaultInfo ARMMMUFaultInfo;
@@ -2968,11 +2968,9 @@ uint64_t arm_sctlr(CPUARMState *env, int el);
  * We collect these two parts in CPUARMTBFlags where they are named
  * flags and flags2 respectively.
  *
- * The flags that are shared between all execution modes, TBFLAG_ANY,
- * are stored in flags.  The flags that are specific to a given mode
- * are stores in flags2.  Since cs_base is sized on the configured
- * address size, flags2 always has 64-bits for A64, and a minimum of
- * 32-bits for A32 and M32.
+ * The flags that are shared between all execution modes, TBFLAG_ANY, are stored
+ * in flags. The flags that are specific to a given mode are stored in flags2.
+ * flags2 always has 64-bits, even though only 32-bits are used for A32 and M32.
  *
  * The bits for 32-bit A-profile and M-profile partially overlap:
  *
diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index 8d79b8b7ae1..e51d9f7b159 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -506,8 +506,8 @@ void assert_hflags_rebuild_correctly(CPUARMState *env)
 
     if (unlikely(c.flags != r.flags || c.flags2 != r.flags2)) {
         fprintf(stderr, "TCG hflags mismatch "
-                        "(current:(0x%08x,0x" TARGET_FMT_lx ")"
-                        " rebuilt:(0x%08x,0x" TARGET_FMT_lx ")\n",
+                        "(current:(0x%08x,0x%016" PRIx64 ")"
+                        " rebuilt:(0x%08x,0x%016" PRIx64 ")\n",
                 c.flags, c.flags2, r.flags, r.flags2);
         abort();
     }
-- 
2.39.5


