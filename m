Return-Path: <kvm+bounces-44930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1242DAA4F4E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 17:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7661C1894D39
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 15:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6692B2609DE;
	Wed, 30 Apr 2025 14:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QSLviTiT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7892609D2
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025140; cv=none; b=E3pD9md8XRlWlM4nhBXy62R40ITzR5PqbPCV7n2EvGzH3tuNxaBVdZh/WDjQ5CvrkqV+wHh3E3flGIFfDUtXpNgk2t5//cfM6/waBLhjM9OCS3hLomiUZO6DitwTTuzWfvy5YWSk3oRiL4tv+M1lFxj+SNxAg2lcb7pAO39WumE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025140; c=relaxed/simple;
	bh=1uV/1Qgzj0SAqnlKsgzVPyg4YuyfcV18RNWgGkbmsQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcsswmxIn7Vb+CfCzipH4qOpX5RLrQDqX4LvG4vxaVLM3oT1s7NLMjU32/u+D2H5DZY4CTiTkqBLP4ye8EjEFL9BelscSAxBh04Iyqt7HoTv7IsitO2WEKhR0E/3/ceGt5WSL5XyALB4a3VOaqFNEbgetRlr++bMHD+Ax1auN1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QSLviTiT; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30863b48553so1176128a91.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 07:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746025138; x=1746629938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBK8LHWqvAyuwDxFuuTqDb/KWyXEAnnOTejYROwMLow=;
        b=QSLviTiTbxTZo4i/C3eF2Jsh1l+v5zRq5aZtQIXm0MljVx34EcEEIgfDfE8zHR8xL8
         4D/0Jr3/QaxvkJ7MS+Q/QlTNMjSO2MKcpuYZqSFjBA+dot9t8zdnh4CwGIgKCez2V5gA
         gUXfdOo4Sd97bFtuOC60Pvuw4gpzVdPC7NBzAgnB4JTBNCdBNqPwwgY70g7FC1hdtBnR
         TLrGSPf1X0cQufrDYdoWe2K8CjWNy6HMSvUFZ6aAuLaukhO/H3pemhWqPu2joO6YLr5t
         Ci3/YAYRhaIbldkcM10QoLvICxYnfRQQRno40FYo8ehxXCKO6NKRe6EX3LxZPEkAf+kP
         W5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746025138; x=1746629938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QBK8LHWqvAyuwDxFuuTqDb/KWyXEAnnOTejYROwMLow=;
        b=WzrRebe5aBG1KKOq7zYdyYiYZCHTq8l2WKTEEbEiHFXeFU9lek+cxQdbdnJFo74m+/
         aTts3naFFcIHfWO8kjlxPZLgGgUSEaOb+PhWT5ANkIAmgkGJvjs3jzJIbpND9kPIVGaj
         8lXH2XJsH5SrUsj0Uc4CPra56EzgPb2qg3hwtnQkRb6Pkog2dhW/K7OFUMd+z7rgd+N8
         rbSnxPTTbSN5EayOCpjbUY7vAgYx4UOszKeonUNS0R4PHr5/gq928JgplYTTLIba3d9a
         5acfXCD5FnG11K54p+mz9Xhy8w3hcpsePHICAoq0xRNXKi6u0tNYJpmMTVuk1zplaDlC
         QnJg==
X-Forwarded-Encrypted: i=1; AJvYcCVDFimcspBnlWfmsFvo6GbGZ0x4PQzES2TiPsQ4AZJtvDquDeLHnt17EeU3qBSt0TFXjsY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFElDsoxcjjEFqiyYPGyOP+3fiW3pB4DlZrpA3gcwN94sDHD/L
	A+mHxI75jADFn1OHIeZHmvpOKlhXr+wU7D47ZmNf5KkVKQqC6gYUnusKvNIIgyo=
X-Gm-Gg: ASbGnctwOdcKOXDLd5IIWLCvGGdC2gWUqwZGVbm+OulwOE6gk9rxUWHkCeA5Ih5qXTR
	KLUw3247QI9WkWBcE0o2xj0oSCCmPmA8q5YuxQdD4opJ953dlw/LhVwO0/lCShEiYualqIHzjXq
	4angA9wnmcfFheEbQ0bqR9NODPP5AGX5vx8GQk1wSURmA6dMMFvnKO0lFp0AE9f438WrErB7rLk
	Y+DdYO2DPOwwn+784P0srJLdjckq0100xnvbC45UeLsMOUVKP0ohurnEdxJsxQPO8ZQGJropfEI
	uLBAkhqF/solQZAnPVRQBpeELjfc+y1RCOnihDWV
X-Google-Smtp-Source: AGHT+IGbHAOKE7iuPjYSBIxBLMfH8W4TYKvNqESm7rCnzFL3W3NNnV27ZkpuMRRPW9MKndTzkiNmbQ==
X-Received: by 2002:a17:90b:5647:b0:2fa:3174:e344 with SMTP id 98e67ed59e1d1-30a33d3b0fbmr5073649a91.14.1746025138468;
        Wed, 30 Apr 2025 07:58:58 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a5bd78sm1705652a91.42.2025.04.30.07.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 07:58:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	richard.henderson@linaro.org,
	anjo@rev.ng,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 09/12] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Wed, 30 Apr 2025 07:58:34 -0700
Message-ID: <20250430145838.1790471-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 37b11e8866f..00ae2778058 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


