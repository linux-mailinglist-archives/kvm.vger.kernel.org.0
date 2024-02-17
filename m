Return-Path: <kvm+bounces-8925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FF8858C2C
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4709A1F2269B
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33DA91DFFE;
	Sat, 17 Feb 2024 00:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="o1MtzOcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504681D55E
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131513; cv=none; b=ijUEkfJTxSfYak8+d2nFNNvB4TpNqxUcRRWXUNPzzcexKhcQpQL7YpFtWZ3FgOmau8DFIN5fgVYxMNrX9HlALvvoajOcht2LpeO9pdO9MUkaQytcjFFIJ/7GMtpNSFSoQUCIqK6PQt4QO6kpFKEUQbGmhx6qv/z0sSGPuaBZx8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131513; c=relaxed/simple;
	bh=v4jFIHIvSZC1Mu5314E7QcCLKtn4E/oUc1oCVyh9DYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XGWRYa1Bj7b2FSvgwciG1jaiMc41jcNxtWIVJYjSrJ/SOWv8DOqjkPxk4wUpC2cd4Xd0CKDtsWwmZPm7EIlSWXI/24CMLGcPbffhiMbYb/EH95mGCKnfdl70T+3cSkST1bQYMmLLSKRif8WLAgXIxwbxAQwyznuhmqcGDX9OWfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=o1MtzOcM; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so1798239b6e.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131509; x=1708736309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2xIx7YE6DTpyA9iQ0shuXDu9l/GTuR0ZUSu2bmZ4Gw=;
        b=o1MtzOcMgcUKuK+vXEaDBYQsO2pTDUnNfMYWBnjuZKToD9szmTBohYU0vQ+apcutyY
         8LYN4+MRwj+a4csJJl/vYsMdnN01xuL9cZyX+S/njqKjUQ9FBDYPX3w1nttoShrwnHH2
         hLUSWESBaA7nZoNgDyEWFbqwv8d5paDbVd5Qhw8b/+BnHSTHuMlNx3CwarwMbSU0RR1z
         QyLDUamvzh4bIKTfNHvdyBKzTK++qAxZhxeVHME2dKFcil6t3ceoaC5VsbyUwYZ49M/e
         N9mVf2r3X4JHfrGzpzx0LzHD9oyvboSGQpCMNvZ0prU2vJruqZ2tizGsBsTv5GP5yUQB
         stOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131509; x=1708736309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a2xIx7YE6DTpyA9iQ0shuXDu9l/GTuR0ZUSu2bmZ4Gw=;
        b=qYeUGBejDs16SI722hQ8oRLcxJjaIwaIDoPHptEz1PNLnGXbWu7Q2B8qpGzGMk6emd
         yHg4llIUFfFJbwBLj9suomzWW6atCxp6DaB8zwYPEPkCN7kVWie3P+rfcQXOVe/EqDFJ
         Ll+ralVGkT1K36948Zz4qi614IwKVetEOkc6T/YpVTIzmSe/0ymXSIQcxrcwSUQOSRkp
         CHIOtJsZtxQTp1z7N44UluM3LVhiP9+nwtsWIOQzRSjQ/LxDAh8lnjCjGCCJhRmsTVOx
         uiWfmIs8iOdkyIZQdmw6ITPKqh/QZeeFhpuPSXMCP4uIHCMm/cKfc7Uf3rskBcyguD9c
         iQZw==
X-Forwarded-Encrypted: i=1; AJvYcCXHncQji6S77Lh3BBPxi6GywYBgCO7Nrsj7v4n3t0JRSkdTtzmqKFkIxcwUsSy6clthyWjGkXoosaPeoTpqL5CbHMUz
X-Gm-Message-State: AOJu0Ywt0fwGb5poOpZ9VpJl1zlh8X9Ich3wQLWPER3hXEku4VkZt/uz
	R9HmGf0OtYIV+iI4qMyycoCIUEi7/AxikM7RL0ulGGK1kuOrnYb2l9FLFlQdr8g=
X-Google-Smtp-Source: AGHT+IFGR2TLppjaVLhGvXb9veJUkvHq4g2Z43QZBpJsKyF4ul3TY6Njmk1X1f97l7rCNISjLsOStA==
X-Received: by 2002:a05:6808:2392:b0:3c0:4357:1d20 with SMTP id bp18-20020a056808239200b003c043571d20mr7982453oib.47.1708131509393;
        Fri, 16 Feb 2024 16:58:29 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:29 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 06/20] RISC-V: Add Sscfg extension CSR definition
Date: Fri, 16 Feb 2024 16:57:24 -0800
Message-Id: <20240217005738.3744121-7-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaiwen Xue <kaiwenx@rivosinc.com>

This adds the scountinhibit CSR definition and S-mode accessible hpmevent
bits defined by smcdeleg/ssccfg. scountinhibit allows S-mode to start/stop
counters directly from S-mode without invoking SBI calls to M-mode. It is
also used to figure out the counters delegated to S-mode by the M-mode as
well.

Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 0a54856fd807..e1bf1466f32e 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -214,6 +214,31 @@
 #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
 #define SMSTATEEN0_SSTATEEN0_SHIFT	63
 #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
+/* HPMEVENT bits. These are accessible in S-mode via Smcdeleg/Ssccfg */
+#ifdef CONFIG_64BIT
+#define HPMEVENT_OF			(_UL(1) << 63)
+#define HPMEVENT_MINH			(_UL(1) << 62)
+#define HPMEVENT_SINH			(_UL(1) << 61)
+#define HPMEVENT_UINH			(_UL(1) << 60)
+#define HPMEVENT_VSINH			(_UL(1) << 59)
+#define HPMEVENT_VUINH			(_UL(1) << 58)
+#else
+#define HPMEVENTH_OF			(_ULL(1) << 31)
+#define HPMEVENTH_MINH			(_ULL(1) << 30)
+#define HPMEVENTH_SINH			(_ULL(1) << 29)
+#define HPMEVENTH_UINH			(_ULL(1) << 28)
+#define HPMEVENTH_VSINH			(_ULL(1) << 27)
+#define HPMEVENTH_VUINH			(_ULL(1) << 26)
+
+#define HPMEVENT_OF			(HPMEVENTH_OF << 32)
+#define HPMEVENT_MINH			(HPMEVENTH_MINH << 32)
+#define HPMEVENT_SINH			(HPMEVENTH_SINH << 32)
+#define HPMEVENT_UINH			(HPMEVENTH_UINH << 32)
+#define HPMEVENT_VSINH			(HPMEVENTH_VSINH << 32)
+#define HPMEVENT_VUINH			(HPMEVENTH_VUINH << 32)
+#endif
+
+#define SISELECT_SSCCFG_BASE		0x40
 
 /* symbolic CSR names: */
 #define CSR_CYCLE		0xc00
@@ -289,6 +314,7 @@
 #define CSR_SCOUNTEREN		0x106
 #define CSR_SENVCFG		0x10a
 #define CSR_SSTATEEN0		0x10c
+#define CSR_SCOUNTINHIBIT	0x120
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142
-- 
2.34.1


