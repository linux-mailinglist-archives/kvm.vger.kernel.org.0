Return-Path: <kvm+bounces-42148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E61D8A73EC0
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26B54189EB37
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC03D22AE76;
	Thu, 27 Mar 2025 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Tp7cZtbn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0E4224B1E
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104189; cv=none; b=tyqmiFuLvxhq07S8lUMW1BLCvmPiXxL554ygpcITekBhmxETohHZbz6HSqHy5DVL8fcX8HQ1XfgEbIsjnkZZMXNgh76g9mnyy3N3x0EFoyccofPaB48nK16Wd9DC15z7OL28k22gfXhxspAlhnmCPZBUwALq3X0oieAmzzkm8K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104189; c=relaxed/simple;
	bh=jc2vJE1mq6Gyn5QhWU9RmBNp+6OzHhTTXRDivrMaraQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rEwluiurOJ5GN6aihDVr0TnYXga2vbKtz+tCS1jsgLPO6TihENNYH1Q0PpQEzOEfBu5NkkJoJ0Jla3y8vCrg1Kl9RdLIxg3UiaVO2y7cBFu/Kt/prJvqLv29Xs9jqM5G8Ywbm35m9qTrbmD6T5mQexLitdb6v9NXIqFeIGgmpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Tp7cZtbn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-224341bbc1dso29935115ad.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104186; x=1743708986; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fU6+swbjNie6iv0e0xu8zQCGmiznni+/eNGoYv30rIw=;
        b=Tp7cZtbn5rxqq8eqkbqcGxX5KvKKIfyGVXJnDLOMd6S/leOLvL+AtsYq9EI/76umwV
         VgDgGhZRNY7pw/vofNV3Ut/MJCfuyXYbOr+/cAgZ0BBVF8QRNM7F1EnJPf3GxSWFY1Dp
         ZlmxI+STV+UsEXM7UlLL5x815lo1xSMWYcd6XXJoY3YeD4UYl1TsBJw8DwSFJFMiLmfp
         0GZZ1XPaIjxGjtgkMGRIYw0jXhrdQwPt15eFIFjKj+KPyP0iVeDt+nYjfnkqTJQmYxM9
         JQb6oBvRhHouCKvzT/+Bn+V7pRbr4K0mmtBvbiLyvHaQl3Enp9Dph1HMheuW3ADU2TWC
         Gvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104186; x=1743708986;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fU6+swbjNie6iv0e0xu8zQCGmiznni+/eNGoYv30rIw=;
        b=YyUPYF8MwNC/EcWVeQEGfIDeOP4NN6IJZW7XYWgP0aQj0V27lxyBWcEXmftFzz4r3k
         dPJP9tdGAnOD/8PTMxV+/4XIqCLG1exSqktpB24ZF19kJ+enk/UjcACRW7ex8MsF6tya
         XOdse7jhWnZqPhp56WKeeZF9IJBQLlkntrMm6dxe6O75ITHN9KRC3Qd2VvVq9VkeHSJV
         Deha44xiEWjkiv7/SA55xVaTuxUzr2y6IMDWs7rPkJhSJ/OJT4y+Mldge5n48KSP4Vl5
         tH7+bwtcZkgiNLhNpeSCF33A/k0pFqghxxHUGw6Zbif//wXqqes5cYW7szrNaMye8DvD
         IitA==
X-Forwarded-Encrypted: i=1; AJvYcCVnaFdgIaeqADCF7HIw7cJaZ8B33Yyaa8aE8XmI5pKMdRP/kNUbxH+qzL8M8hnK3W99Fqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzqb3rphpDdD8s1Gyr26nFeOXmQrDC1smBLbwwnXX3DF10IRvsn
	2jVgK9b6S7dDUN7vlWduvoVGKrmoWOo9ChdS9YBHEXx35UvJS0++q8mW2OQW4+4=
X-Gm-Gg: ASbGncsMb8Ogl9eI1wyJpOxk2y/vj8h7jtwXobgffL/YGlKzVSYbrYroXbFunvr3CiK
	euqEru8Gnq9TgAhIRZ/UOh35ZuwSQwiDL0cMisQTP2drB+y0QSopUhnHupTXLwH4Dg5EyYwbpoj
	E2fTQ8pz1wFqtGw11a8tbBV9zzzqX5KQbQ9sLHKx/jXdOrTEzBdLByOnIJG5qvfhofq8n2/ieg8
	LzYddq/nYdIes1HVj8bhCYrfWPVxt9zYXMiag3NcDqqSpPxlUfU0eiNNswsBgXtVCorZkmqs1kC
	y2JFnbnw8xOJ02SUstn7ZE++INtZ/Vm1KoZf7aQK74km5pJOMRYwULedjg==
X-Google-Smtp-Source: AGHT+IG6W5JCnq2W/DPMkiUqQh7RSB5vMs9zmrYMV01msf9VIMSJa0JuflPjxBxsdjfYbz9YgA1nag==
X-Received: by 2002:a17:90b:2ed0:b0:2fe:861b:1ae3 with SMTP id 98e67ed59e1d1-303a7d66291mr7527766a91.8.1743104186345;
        Thu, 27 Mar 2025 12:36:26 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:26 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:50 -0700
Subject: [PATCH v5 09/21] RISC-V: Add Ssccfg/Smcdeleg ISA extension
 definition and parsing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250327-counter_delegation-v5-9-1ee538468d1b@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Smcdeleg extension allows the M-mode to delegate selected counters
to S-mode so that it can access those counters and correpsonding
hpmevent CSRs without M-mode.

Ssccfg (‘Ss’ for Privileged architecture and Supervisor-level
extension, ‘ccfg’ for Counter Configuration) provides access to
delegated counters and new supervisor-level state.

This patch just enables these definitions and enable parsing.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h |  2 ++
 arch/riscv/kernel/cpufeature.c | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index b4eddcb57842..fa5e01bcb990 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -103,6 +103,8 @@
 #define RISCV_ISA_EXT_SSCSRIND		94
 #define RISCV_ISA_EXT_SMCSRIND		95
 #define RISCV_ISA_EXT_SMCNTRPMF         96
+#define RISCV_ISA_EXT_SSCCFG            97
+#define RISCV_ISA_EXT_SMCDELEG          98
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index e3e40cfe7967..f72552adb257 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -150,6 +150,27 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_ext_smcdeleg_validate(const struct riscv_isa_ext_data *data,
+				       const unsigned long *isa_bitmap)
+{
+	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_SSCSRIND) &&
+	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZIHPM) &&
+	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZICNTR))
+		return 0;
+
+	return -EPROBE_DEFER;
+}
+
+static int riscv_ext_ssccfg_validate(const struct riscv_isa_ext_data *data,
+				     const unsigned long *isa_bitmap)
+{
+	if (!riscv_ext_smcdeleg_validate(data, isa_bitmap) &&
+	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_SMCDELEG))
+		return 0;
+
+	return -EPROBE_DEFER;
+}
+
 static const unsigned int riscv_zk_bundled_exts[] = {
 	RISCV_ISA_EXT_ZBKB,
 	RISCV_ISA_EXT_ZBKC,
@@ -394,12 +415,15 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_BUNDLE(zvksg, riscv_zvksg_bundled_exts),
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA_VALIDATE(smcdeleg, RISCV_ISA_EXT_SMCDELEG,
+				      riscv_ext_smcdeleg_validate),
 	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
 	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
 	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
+	__RISCV_ISA_EXT_DATA_VALIDATE(ssccfg, RISCV_ISA_EXT_SSCCFG, riscv_ext_ssccfg_validate),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
 	__RISCV_ISA_EXT_SUPERSET(ssnpm, RISCV_ISA_EXT_SSNPM, riscv_xlinuxenvcfg_exts),

-- 
2.43.0


