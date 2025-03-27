Return-Path: <kvm+bounces-42147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEB5A73EBD
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE1853BFF5F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D16C226D1B;
	Thu, 27 Mar 2025 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="GWnBWuTi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F08D222581
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104187; cv=none; b=KSVv4+qEIYBRNTlVpWzKV8zx8jJ8f6E+3EX/yJ8+R1ppbYMQ0TT/vE/XPozUp3FNcHumqEx/X7xYx1zlc/lb7KcK0c0FwIWb4YvO9YlX5D7sFr3NV2RkVZbzVCiL57eZLBJjBoPoKqHL+txgeKPBd1ZEVAM2d0h7Uuh/+Q1qwjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104187; c=relaxed/simple;
	bh=zbUFnatx4CgI/XxIAGH/rswQYfjg9L9FFatwKHPX9Dw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=stxLN9WMioAF8jRmqXe9ex/Dpe6NYdC+saIV5n/b0NwrEUxCdQIjCTobrWGU05dP80jLwTvjDFHNn9+BF9ClkGNpg5BOE0JCBZpBtTsoQCNTl1XVsZN5UNwddSr6gMWmFoM/BbZ8iF87g22Sv/WItAGIF7rMyz4B3mAW/gov3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=GWnBWuTi; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22423adf751so28526605ad.2
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104185; x=1743708985; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUgUK85uZXa6Y/dNTr7Q9E0wfwXHdLdLqKfyUg5SYXI=;
        b=GWnBWuTiafleafFeUbv53i5WxaFpJqLUqEgvyRsQTaCz1l0n+hmD0qlAMvngWo4pof
         5j8UAfNnMdaQncTvaDU3edDRQLCuecTNkUttnpvjrj/GqTcCiVCsrOjfsF1gfcG2vDoU
         CbyIX30TvTalHuffHvdA65X3JPUYIOJkmsdibVtwHJbOqGu6Jp7XSJCzkAT/HLC6pQu9
         Pfi/AD8jgmqb0TobG5Zo/RlbnPk+q4l4DXFnYRaopYOkOnNShiqNgsbdVXoQwexpyoRW
         GvUzKY/ZIQ9OJWVzpvaDEkBJ/SLdKWHLOXKBYZzt9vGoHawmtGe0oCp1Sog+xt39Q7O7
         uxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104185; x=1743708985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUgUK85uZXa6Y/dNTr7Q9E0wfwXHdLdLqKfyUg5SYXI=;
        b=Oo14z62hfzS2Nk9y8gbIVPdzRm11nqPmwykNNwpwrGPGKlMsysQKd7gppSYbni6KZE
         fOqMYXOAHQqpYv/ruo2tXsf3Avj0yX4VSV8wLYJU5fvpo96BdTIeSYHgqLbbh0BnV5su
         xwOaLJsYJuTqIy3U91qnOLrd9VBI0ddlcetJ6FmQha10X0h15b4klKfJcGGCG+ZkKu6e
         TIn9Sd4m21I/TLtgURgCQSIGrF+D6VOzTuB3Ya03smwA5KfJnVcHpz7+BjbIjuHgADEA
         L2pRZvRgt3ZkFs8oz09bqgspoEPhCnd8wPFYbJLvw9PsazdEuGAlfaJ+pdoptZ8EWICr
         q2yw==
X-Forwarded-Encrypted: i=1; AJvYcCWliTji0ongEgSxXYZU+jzePtFvZtWvBP/vMqO9DtKmeJ2qcu5yLA90eqAt64lr3ZFylh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzANdvZ4oDI/dOuMuEDUcVBqDWixq1Buu5ZC8zU/+2wxwN6bUtu
	INZLtBqcOfLIjd1bW4kN4dGXn6k/44FzanDomZ4LISY9kQOU855sG7WoYt6mgME=
X-Gm-Gg: ASbGncux7fqLmnO7IUjvzg9vZSBJDyvBU3CHmg8rq5K01ChJ6jkMqRoxV0pQ4vnE22r
	8Hll4Pat1LdNesFjr2m1SM8xwLu9tx1bhhBiLpo9qTwMb3IF+ysGcJ87iVmy2DQIpkeRsR9sV2M
	WsUoQjLoWegtDAj0vjHrydwVjqTzwz8nTNOPmWkmiBHWR230l/0kjc4jPHzBpu3dbVKhqA2TifH
	CZyfrFqvFQE5AXkpdDZJYb4bdHQdofogxGRJU0cZuHJeZFLiPgvpLDI1VzTBCHeMkl0NPDd8jL3
	fK0MX5UgT5idzpB8Zay8X5f7J+3tH7Oiw1kk3Wj7YBPE55v9IExoePSNiw==
X-Google-Smtp-Source: AGHT+IHsQmzPAsgx/ng9OITR58/G/eBONWXQGgyTGskdwaITzdO2LxTvI25NheeogcoyYSwC74/u/Q==
X-Received: by 2002:a17:90b:2f4d:b0:2fe:8a84:e033 with SMTP id 98e67ed59e1d1-303a7b5a137mr7359505a91.2.1743104184705;
        Thu, 27 Mar 2025 12:36:24 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:24 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:49 -0700
Subject: [PATCH v5 08/21] RISC-V: Add Sscfg extension CSR definition
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250327-counter_delegation-v5-8-1ee538468d1b@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>, Kaiwen Xue <kaiwenx@rivosinc.com>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

From: Kaiwen Xue <kaiwenx@rivosinc.com>

This adds the scountinhibit CSR definition and S-mode accessible hpmevent
bits defined by smcdeleg/ssccfg. scountinhibit allows S-mode to start/stop
counters directly from S-mode without invoking SBI calls to M-mode. It is
also used to figure out the counters delegated to S-mode by the M-mode as
well.

Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index bce56a83c384..3d2d4f886c77 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -230,6 +230,31 @@
 #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
 #define SMSTATEEN0_SSTATEEN0_SHIFT	63
 #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
+/* HPMEVENT bits. These are accessible in S-mode via Smcdeleg/Ssccfg */
+#ifdef CONFIG_64BIT
+#define HPMEVENT_OF			(BIT_ULL(63))
+#define HPMEVENT_MINH			(BIT_ULL(62))
+#define HPMEVENT_SINH			(BIT_ULL(61))
+#define HPMEVENT_UINH			(BIT_ULL(60))
+#define HPMEVENT_VSINH			(BIT_ULL(59))
+#define HPMEVENT_VUINH			(BIT_ULL(58))
+#else
+#define HPMEVENTH_OF			(BIT_ULL(31))
+#define HPMEVENTH_MINH			(BIT_ULL(30))
+#define HPMEVENTH_SINH			(BIT_ULL(29))
+#define HPMEVENTH_UINH			(BIT_ULL(28))
+#define HPMEVENTH_VSINH			(BIT_ULL(27))
+#define HPMEVENTH_VUINH			(BIT_ULL(26))
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
 
 /* mseccfg bits */
 #define MSECCFG_PMM			ENVCFG_PMM
@@ -311,6 +336,7 @@
 #define CSR_SCOUNTEREN		0x106
 #define CSR_SENVCFG		0x10a
 #define CSR_SSTATEEN0		0x10c
+#define CSR_SCOUNTINHIBIT	0x120
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142

-- 
2.43.0


