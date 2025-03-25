Return-Path: <kvm+bounces-41910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5417CA6E90E
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C00F168CFE
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B305D1F2C5B;
	Tue, 25 Mar 2025 04:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aCYq2PPT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AE91F1905
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878782; cv=none; b=DrHkpEL4RcG12lovYGWUht/xZDLwYVNM6dihIFRfsud3zrX8+nTg1zSjTXBye294peIy18F3TTu7a/5oWQgoFu0NmEpQBdIwqhlgL/1mF73ovbXJgkfCXenm5zhv+gWqnbQVTcreaI0nHpvPiAdLptgZBo2kXUXJwo2IoyNe7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878782; c=relaxed/simple;
	bh=D3GLMKf45fU5jKB8izQIf9VhQ0je6soXVPzobdOtb4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0iAsl3uAPc1EBXRLpyv3V0pBMC36MABHaPEg9aznguDKoIsdlZmtbYNi9V7eRUIvhARLlb7jHw6eY26JOi+lb6MZ67W3bTyg5PJc3Po1M0vEcMT0VoRge1zrJHa8ZYG7A0TBLsGNe1+QV9kDdpaIY/KYdK5ZhCw+WmODbxjFNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aCYq2PPT; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff187f027fso11093314a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878781; x=1743483581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6JY17RXIOhpi9WGu5PHvZc/K1MBVjPo3G9pvjwYgCU=;
        b=aCYq2PPTFZkynuMR3JQORIO55bHDhx66kao65DUjtkmsAu3136N0vfONgcq0rSKS3V
         maDbo0MUOi0rYESKzmvQB3oSw72M66eekwdyCEIZZSE5C6xrZvpqYCyX2zS2ojT1uaUg
         efEdA7O+wzwIDjnYTSJ6ImOtytPf5F2dH1fBFF/f2Uk4HEdunMXQNaxNDOqEAdnvmCQx
         ChH8/ZDLrnvGeNqiew4sph+LqHOyzyrQ3+OSAdPJRRq30sTIKtAqNMLU4RsVXw95Ltj4
         mfUkDKOJcdS7G4jLVpp+CgFkiYus57mo+VbPONo4oyqbu1SLE2P8bq9WVDSp+33tZ98C
         DMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878781; x=1743483581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6JY17RXIOhpi9WGu5PHvZc/K1MBVjPo3G9pvjwYgCU=;
        b=XsFZO1FOweMsXMkGfILSQQrvb7fDlN44fnQ/vyCI+7V3IA8WtIeRAdUGdayFKZWGaI
         ihnRarnYdbMj36MPRo5phG+K2qBFgtwFW+wn+EelTtxDmlVLNPZjcGMItL/zv7ooMSNd
         AoCnrzFeAk70Ex2Cv9dm9vCBgdnS46U7CNu8JVIOMNknAZDxwfEcZVoZqdNGY8XaSZwH
         PRWXT0xui9f1L2EGOEoNa3LJ6J0TImphpYywPtj/bCv104Z68MO4SWcFEST2UBeuHBrB
         Jd0vVV5E4q30TakdzYuyULvfs+R6NdIXA9K2RagJJ5Z/xHDdMr2KONUwFClo3PVKhn2d
         0oIA==
X-Forwarded-Encrypted: i=1; AJvYcCVFS8CRZHkvNEa4orUiwF72NaCdTlNzPeSglulrAX1vdwp/sOIXr/+CAOVGANhGcaeyH2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdSWl8rnMiqfRRxIPqDEI4VXXGuFKSnixbP7N/Tj/m5qLwx8Rk
	/6m87zSxt2hgsd+NFbLHbS7jKPWvaBhL/rbtTibcGiugF7W9jp5pPl2Y+JYS1zM=
X-Gm-Gg: ASbGncuhOblK6Nj6KYoKG0EXgaaSiRfozk2pthmSpmgodpEQvIYQIbiuezJKYygakqm
	YJpyplJCoqDm096+BDFwKU9KFisIGjhS1TWsFNntQZIlB7vAKKrztndohVy6x1V8Nz9NiJqkS2v
	FuZ7J4FLSzWdpjJj/hrO4UdkvtDDg8INKKhn13L84MdtKJ3yQytccn2Dm448ZS3IYjrTqPX8kp0
	PRilRrhyfDyp1nDz3CtrWEppJ/DNC2iia60bmh4HSZEqm7yCdowGSNUHB5gK55UVWju+IZj0HJ9
	yOIor6VZ96ekfWhf80Rxab+X3zZyowrdfA27GuYx4oyF
X-Google-Smtp-Source: AGHT+IFyGbABiDoMVDJJuBiMI7scP0+bHtemckn6LiZHb/NiiRx62CqF94ZOcat0iRmwrJR2/o4N8A==
X-Received: by 2002:a17:90b:1848:b0:2ea:8aac:6ac1 with SMTP id 98e67ed59e1d1-3030f3efb95mr26168707a91.15.1742878780601;
        Mon, 24 Mar 2025 21:59:40 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:40 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 20/29] target/arm/cpu: flags2 is always uint64_t
Date: Mon, 24 Mar 2025 21:59:05 -0700
Message-Id: <20250325045915.994760-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
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


